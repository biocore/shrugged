import os
import tempfile


try:
    TMP_DIR_ROOT = config['tmp_dir_root']
    samples = config["samples"]
    trimmer = config["trimmer"]
except KeyError:
    print('Error: you must pass a config file using --configfile')
    raise

include: "oecophylla/util/folders.rule"

include: "oecophylla/raw/raw.rule"
include: "oecophylla/qc/qc.rule"
include: "oecophylla/util/clean.rule"
# include: "oecophylla/util/test.rule"
include: "oecophylla/util/util.rule"
include: "oecophylla/util/simplify_fasta.rule"
# include: "oecophylla/mash/mash.rule"
include: "oecophylla/assemble/assemble.rule"
# include: "oecophylla/map/map.rule"
# include: "oecophylla/bin/bin.rule"
# include: "oecophylla/anvio/anvio.rule"
include: "oecophylla/taxonomy/taxonomy.rule"
# include: "oecophylla/function/function.rule"
# include: "oecophylla/report/report.rule"

rule all:
    # raw
    input:
        raw_dir + "multiQC_per_file/multiqc_report.html",
        raw_dir + "multiQC_per_sample/multiqc_report.html",
    # QC
        expand(qc_dir + "{sample}/{trimmer}_trimmed/{sample}.trimmed.R1.fastq.gz", sample=samples, trimmer=trimmer),
        expand(qc_dir + "{sample}/{trimmer}_trimmed/{sample}.trimmed.R2.fastq.gz", sample=samples, trimmer=trimmer),
        expand(qc_dir + "{sample}/filtered/{sample}.R1.trimmed.filtered.fastq.gz", sample=samples),
        expand(qc_dir + "{sample}/filtered/{sample}.R2.trimmed.filtered.fastq.gz", sample=samples),
        qc_dir + "multiQC_per_sample/multiqc_report.html",
    # Assembly
        expand(assemble_dir + "{sample}/{assembler}/{sample}.contigs.fa",
               sample=samples, assembler=config['assemblers']),
        expand(assemble_dir + "{sample}/metaquast/{sample}.metaquast.done",
               sample=samples),
        expand(assemble_dir + "{sample}/quast/{sample}.quast.done",
               sample=samples),
    # # Mapping
    #     # expand(map_dir + "{bin_sample}/mapping/{bin_sample}_{abund_sample}.cram",
    #     #        sample=samples, bin_sample=config['binning_samples'],
    #     #        abund_sample=config['abundance_samples']),
    # # Binning
    #     expand(bin_dir + "{bin_sample}/maxbin/{bin_sample}.summary",
    #            bin_sample=config['binning_samples']),
    #     expand(bin_dir + "{bin_sample}/abundance_files.tar.gz",
    #            bin_sample = config['binning_samples']),
    # # Anvio
    #     expand(anvio_dir + "{bin_sample}/{bin_sample}_samples-summary_CONCOCT.tar.gz",
    #            bin_sample=config['binning_samples']),
    #     expand(anvio_dir + "{bin_sample}/{bin_sample}.db.anvi_add_maxbin.done",
    #            bin_sample=config['binning_samples']),
    # Taxonomy
    #     taxonomy_dir + "metaphlan2/joined_taxonomic_profile.tsv",
        taxonomy_dir + "kraken/combined_profile.tsv"#,
    #     taxonomy_dir + "shogun/combined_profile.tsv",
    # # Function
    #     expand(# individual normed bioms
    #            func_dir + "{sample}/humann2/{sample}_genefamilies_{norm}.biom",
    #            norm = config['params']['humann2']['norms'],
    #            sample = samples),
    #     expand(# stratified
    #            func_dir + "humann2/stratified/combined_genefamilies_{norm}_{mapped}_unstratified.biom",
    #            norm = config['params']['humann2']['norms'],
    #            mapped=['all','mapped']),
    # # Distance
    #     expand(distance_dir + '{sample}/distance/{sample}.msh',
    #            sample=samples),
    #     expand(distance_dir + '{sample}/distance/{sample}.refseq.txt',
    #            sample=samples),
    #     distance_dir + 'combined_analysis/mash.dist.dm',
    #     distance_dir + 'combined_analysis/mash.dist.p'
