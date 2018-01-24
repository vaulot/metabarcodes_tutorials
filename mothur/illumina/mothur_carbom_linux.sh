# 1. Change the path below to the path where you have downloaded the fastQ files
DIR_DATA="/home/metabarcodes_tutorials/fastq_carbom"

# 2. Change the path below to the path where you have downloaded the mothuer fules
MOTHUR="/usr/local/genome2/mothur-1.39.5/mothur"

# Nothing else to change below
FILE_PR2_TAX="../databases/pr2_version_4.72_mothur.tax"
FILE_PR2_FASTA="../databases/pr2_version_4.72_mothur.fasta"
FILE_SILVA="../databases/silva.seed_v123.euk.fasta"
FILE_PR2_END="72"
FILE_OLIGOS="../databases/oligos18s_V4_Zingone.oligos"
PROJECT="carbom"

cd $DIR_DATA

$MOTHUR "#make.contigs(file=$PROJECT.txt, processors=32)"

$MOTHUR "#screen.seqs(fasta=$PROJECT.trim.contigs.fasta,group=$PROJECT.contigs.groups,maxambig=0,minlength=350, maxlength=450, processors=32)"
$MOTHUR "#count.groups(group = $PROJECT.contigs.good.groups)"

$MOTHUR "#pcr.seqs(fasta=$PROJECT.trim.contigs.good.fasta, group=$PROJECT.contigs.good.groups, oligos=$FILE_OLIGOS, pdiffs=2, rdiffs=2, processors=32)"
$MOTHUR "#count.groups(group=$PROJECT.contigs.good.pcr.groups)"

cp $PROJECT.trim.contigs.good.pcr.fasta $PROJECT_18S.fasta
cp $PROJECT.contigs.good.pcr.groups $PROJECT_18S.groups

$MOTHUR "#unique.seqs(fasta=$PROJECT_18S.fasta)"

$MOTHUR "#count.seqs(name=$PROJECT_18S.names, group=$PROJECT_18S.groups, processors=32)"

$MOTHUR "#count.groups(count=$PROJECT_18S.count_table)"

$MOTHUR "#split.abund(count=$PROJECT_18S.count_table, fasta=$PROJECT_18S.unique.fasta, cutoff=1, accnos=true)"

$MOTHUR "#count.groups(count=$PROJECT_18S.abund.count_table)"

$MOTHUR "#align.seqs(fasta=$PROJECT_18S.unique.abund.fasta, reference=$FILE_SILVA, flip=T, processors=32)"

$MOTHUR "#filter.seqs(fasta=$PROJECT_18S.unique.abund.align, processors=32)"

$MOTHUR "#pre.cluster(fasta=$PROJECT_18S.unique.abund.filter.fasta, count=$PROJECT_18S.abund.count_table, diffs=1, processors=32)"

$MOTHUR "#summary.seqs(fasta=$PROJECT_18S.unique.abund.filter.precluster.fasta, processors=32)"

$MOTHUR "#chimera.uchime(fasta=$PROJECT_18S.unique.abund.filter.precluster.fasta, count=$PROJECT_18S.unique.abund.filter.precluster.count_table, processors=32)"

$MOTHUR "#remove.seqs(fasta=$PROJECT_18S.unique.abund.filter.precluster.fasta, accnos=$PROJECT_18S.unique.abund.filter.precluster.denovo.uchime.accnos, count=$PROJECT_18S.unique.abund.filter.precluster.count_table)"

$MOTHUR "#summary.seqs(fasta=$PROJECT_18S.unique.abund.filter.precluster.pick.fasta)"

$MOTHUR "#count.groups(count=$PROJECT_18S.unique.abund.filter.precluster.pick.count_table)"

$MOTHUR "#split.abund(count=$PROJECT_18S.unique.abund.filter.precluster.pick.count_table, fasta=$PROJECT_18S.unique.abund.filter.precluster.pick.fasta, cutoff=2, accnos=true)"

$MOTHUR "#screen.seqs(fasta=$PROJECT_18S.unique.abund.filter.precluster.pick.abund.fasta, count=$PROJECT_18S.unique.abund.filter.precluster.pick.abund.count_table, minlength=200, processors=32)"

cp $PROJECT_18S.unique.abund.filter.precluster.pick.abund.good.fasta        $PROJECT_18S.uniq.preclust.no_chim.more_than_2.fasta
cp $PROJECT_18S.unique.abund.filter.precluster.pick.abund.good.count_table $PROJECT_18S.uniq.preclust.no_chim.more_than_2.count_table

$MOTHUR "#summary.seqs(fasta=$PROJECT_18S.uniq.preclust.no_chim.more_than_2.fasta)"

$MOTHUR "#count.groups(count=$PROJECT_18S.uniq.preclust.no_chim.more_than_2.count_table)"

$MOTHUR "#classify.seqs(fasta=$PROJECT_18S.uniq.preclust.no_chim.more_than_2.fasta, count=$PROJECT_18S.uniq.preclust.no_chim.more_than_2.count_table, reference=$FILE_PR2.fasta, taxonomy=$FILE_PR2.tax, processors=32, probs=T)"

$MOTHUR "#dist.seqs(fasta=$PROJECT_18S.uniq.preclust.no_chim.more_than_2.fasta, processors=32)"

$MOTHUR "#cluster(column=$PROJECT_18S.uniq.preclust.no_chim.more_than_2.dist, count=$PROJECT_18S.uniq.preclust.no_chim.more_than_2.count_table, cutoff=0.02, processors=32)"

$MOTHUR "#classify.otu(taxonomy=$PROJECT_18S.uniq.preclust.no_chim.more_than_2.$FILE_PR2_END.wang.taxonomy, count=$PROJECT_18S.uniq.preclust.no_chim.more_than_2.count_table, list=$PROJECT_18S.uniq.preclust.no_chim.more_than_2.opti_mcc.list, label=0.02, probs=F, basis=sequence)"

$MOTHUR "#get.oturep(fasta=$PROJECT_18S.uniq.preclust.no_chim.more_than_2.fasta, column=$PROJECT_18S.uniq.preclust.no_chim.more_than_2.dist, count=$PROJECT_18S.uniq.preclust.no_chim.more_than_2.count_table, list=$PROJECT_18S.uniq.preclust.no_chim.more_than_2.opti_mcc.list, method=abundance, cutoff=0.02)"

$MOTHUR "#create.database(list=$PROJECT_18S.uniq.preclust.no_chim.more_than_2.opti_mcc.list, count=$PROJECT_18S.uniq.preclust.no_chim.more_than_2.opti_mcc.0.02.rep.count_table, label=0.02, repfasta=$PROJECT_18S.uniq.preclust.no_chim.more_than_2.opti_mcc.0.02.rep.fasta , constaxonomy=$PROJECT_18S.uniq.preclust.no_chim.more_than_2.opti_mcc.0.02.cons.taxonomy)"
