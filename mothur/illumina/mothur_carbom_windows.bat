:: 1. Change the path below to the path where you have downloaded the fastQ files
SET DIR_DATA="C:\Users\vaulot\Google Drive\Scripts\metabarcodes_tutorials\fastq_carbom"

:: 2. Change the path below to the path where you have downloaded the mothur program
SET MOTHUR="C:\Program Files (x86)\mothur\mothur.exe"

:: Nothing else to change below

SET FILE_PR2_TAX="..\databases\pr2_version_4.72_mothur.tax"
SET FILE_PR2_FASTA="..\databases\pr2_version_4.72_mothur.fasta"
SET FILE_PR2_END="72"
SET FILE_SILVA="..\databases\silva.seed_v123.euk.fasta"
SET FILE_OLIGOS="..\databases\oligos18s_V4_Zingone.oligos"

SET PROJECT="carbom"

:: Extract V4 region from PR2 database (not necessary)
:: %MOTHUR% "#pcr.seqs(fasta=%FILE_PR2_FASTA%, taxonomy=%FILE_PR2_TAX%, oligos=%FILE_OLIGOS%, pdiffs=2, rdiffs=2, processors=32)"

CD %DIR_DATA%

%MOTHUR% "#make.contigs(file=%PROJECT%.txt, processors=32)"

%MOTHUR% "#screen.seqs(fasta=%PROJECT%.trim.contigs.fasta,group=%PROJECT%.contigs.groups,maxambig=0,minlength=350, maxlength=450, processors=32)"
%MOTHUR% "#count.groups(group = %PROJECT%.contigs.good.groups)"

%MOTHUR% "#pcr.seqs(fasta=%PROJECT%.trim.contigs.good.fasta, group=%PROJECT%.contigs.good.groups, oligos=%FILE_OLIGOS%, pdiffs=2, rdiffs=2, processors=32)"
%MOTHUR% "#count.groups(group=%PROJECT%.contigs.good.pcr.groups)"

:: Do at the DOS level
rename %PROJECT%.trim.contigs.good.pcr.fasta %PROJECT%_18S.fasta
rename %PROJECT%.contigs.good.pcr.groups %PROJECT%_18S.groups

%MOTHUR% "#unique.seqs(fasta=%PROJECT%_18S.fasta)"

%MOTHUR% "#count.seqs(name=%PROJECT%_18S.names, group=%PROJECT%_18S.groups, processors=32)"

%MOTHUR% "#count.groups(count=%PROJECT%_18S.count_table)"

%MOTHUR% "#split.abund(count=%PROJECT%_18S.count_table, fasta=%PROJECT%_18S.unique.fasta, cutoff=1, accnos=true)"

%MOTHUR% "#count.groups(count=%PROJECT%_18S.abund.count_table)"

%MOTHUR% "#align.seqs(fasta=%PROJECT%_18S.unique.abund.fasta, reference='%FILE_SILVA%', flip=T, processors=32)"

%MOTHUR% "#filter.seqs(fasta=%PROJECT%_18S.unique.abund.align, processors=32)"

%MOTHUR% "#pre.cluster(fasta=%PROJECT%_18S.unique.abund.filter.fasta, count=%PROJECT%_18S.abund.count_table, diffs=1, processors=32)"

%MOTHUR% "#summary.seqs(fasta=%PROJECT%_18S.unique.abund.filter.precluster.fasta, processors=32)"

%MOTHUR% "#chimera.uchime(fasta=%PROJECT%_18S.unique.abund.filter.precluster.fasta, count=%PROJECT%_18S.unique.abund.filter.precluster.count_table, processors=32)"

%MOTHUR% "#remove.seqs(fasta=%PROJECT%_18S.unique.abund.filter.precluster.fasta, accnos=%PROJECT%_18S.unique.abund.filter.precluster.denovo.uchime.accnos, count=%PROJECT%_18S.unique.abund.filter.precluster.count_table)"

%MOTHUR% "#summary.seqs(fasta=%PROJECT%_18S.unique.abund.filter.precluster.pick.fasta)"

%MOTHUR% "#count.groups(count=%PROJECT%_18S.unique.abund.filter.precluster.pick.count_table)"

%MOTHUR% "#split.abund(count=%PROJECT%_18S.unique.abund.filter.precluster.pick.count_table, fasta=%PROJECT%_18S.unique.abund.filter.precluster.pick.fasta, cutoff=2, accnos=true)"

%MOTHUR% "#screen.seqs(fasta=%PROJECT%_18S.unique.abund.filter.precluster.pick.abund.fasta, count=%PROJECT%_18S.unique.abund.filter.precluster.pick.abund.count_table, minlength=200, processors=32)"

COPY %PROJECT%_18S.unique.abund.filter.precluster.pick.abund.good.fasta        %PROJECT%_18S.uniq.preclust.no_chim.more_than_2.fasta
COPY %PROJECT%_18S.unique.abund.filter.precluster.pick.abund.good.count_table %PROJECT%_18S.uniq.preclust.no_chim.more_than_2.count_table

%MOTHUR% "#summary.seqs(fasta=%PROJECT%_18S.uniq.preclust.no_chim.more_than_2.fasta)"

%MOTHUR% "#count.groups(count=%PROJECT%_18S.uniq.preclust.no_chim.more_than_2.count_table)"

%MOTHUR% "#classify.seqs(fasta=%PROJECT%_18S.uniq.preclust.no_chim.more_than_2.fasta, count=%PROJECT%_18S.uniq.preclust.no_chim.more_than_2.count_table, reference=%FILE_PR2_FASTA%, taxonomy=%FILE_PR2_TAX%, processors=1, probs=F, method=knn)"

%MOTHUR% "#classify.seqs(fasta=%PROJECT%_18S.uniq.preclust.no_chim.more_than_2.fasta, count=%PROJECT%_18S.uniq.preclust.no_chim.more_than_2.count_table, reference=%FILE_PR2_FASTA%, taxonomy=%FILE_PR2_TAX%, processors=1, probs=F, method=wang)"

%MOTHUR% "#dist.seqs(fasta=%PROJECT%_18S.uniq.preclust.no_chim.more_than_2.fasta, processors=32)"

%MOTHUR% "#cluster(column=%PROJECT%_18S.uniq.preclust.no_chim.more_than_2.dist, count=%PROJECT%_18S.uniq.preclust.no_chim.more_than_2.count_table, cutoff=0.02, processors=32)"

%MOTHUR% "#classify.otu(taxonomy=%PROJECT%_18S.uniq.preclust.no_chim.more_than_2.%FILE_PR2_END%_mothur.knn.taxonomy, count=%PROJECT%_18S.uniq.preclust.no_chim.more_than_2.count_table, list=%PROJECT%_18S.uniq.preclust.no_chim.more_than_2.opti_mcc.list, label=0.02, probs=F, basis=sequence)"

%MOTHUR% "#get.oturep(fasta=%PROJECT%_18S.uniq.preclust.no_chim.more_than_2.fasta, column=%PROJECT%_18S.uniq.preclust.no_chim.more_than_2.dist, count=%PROJECT%_18S.uniq.preclust.no_chim.more_than_2.count_table, list=%PROJECT%_18S.uniq.preclust.no_chim.more_than_2.opti_mcc.list, method=abundance, cutoff=0.02)"

%MOTHUR% "#create.database(list=%PROJECT%_18S.uniq.preclust.no_chim.more_than_2.opti_mcc.list, count=%PROJECT%_18S.uniq.preclust.no_chim.more_than_2.opti_mcc.0.02.rep.count_table, label=0.02, repfasta=%PROJECT%_18S.uniq.preclust.no_chim.more_than_2.opti_mcc.0.02.rep.fasta , constaxonomy=%PROJECT%_18S.uniq.preclust.no_chim.more_than_2.opti_mcc.0.02.cons.taxonomy)"
