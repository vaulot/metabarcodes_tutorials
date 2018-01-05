Tutorial preparation
set.dir(tempdefault=C:\Daniel\PowerPoint and Talks\Cours Brasil 2014\Mothur tutorial\)

# Extract only Chloro - Not done during tutorial
get.lineage(fasta=pr2_gb200.fasta, taxonomy=pr2_gb200.tax, taxon=Eukaryota;Archaeplastida;Chlorophyta)
get.lineage(fasta=silva.seed_v119.Euk.fasta, taxonomy=silva.seed_v119.Euk.tax, taxon=Eukaryota;Archaeplastida;Chloroplastida;Chlorophyta)