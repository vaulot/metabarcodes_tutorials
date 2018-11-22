#==========================================================================================================================
#      Set default directory
#==========================================================================================================================

# set.dir(tempdefault=C:\My tem file)

#==========================================================================================================================
# Separate sequences based on primers and barcodes and put in groups (perfect match)
#==========================================================================================================================

trim.seqs(fasta=Bio_CHLO.fasta, oligos=Oligos_Biosope.txt, pdiffs=2, bdiffs=0, processors=8)

#==========================================================================================================================
# Remove flow cytometry samples
#==========================================================================================================================

remove.groups(group=Bio_CHLO.groups, groups=T4.V4_Euk-T21.V4_Euk-T43.V4_Euk-T65.V4_Euk, fasta=Bio_CHLO.trim.fasta)

#==========================================================================================================================
#      Generate file only with unique sequences and count sequences related to each unique sequences
#==========================================================================================================================
unique.seqs(fasta=Bio_CHLO.trim.pick.fasta)

#==========================================================================================================================
#     Create a count table
#==========================================================================================================================
count.seqs(name=Bio_CHLO.trim.pick.names, group=Bio_CHLO.pick.groups)

#==========================================================================================================================
#     Classify roughly using the full PR2 database
#==========================================================================================================================

classify.seqs(fasta=Bio_CHLO.trim.pick.unique.fasta,count=Bio_CHLO.trim.pick.count_table, reference=pr2.pcr.fasta, taxonomy=pr2.pcr.tax, processors=1, probs=F)
#==========================================================================================================================
#      Align unique sequences using reference alignement from Silva
#==========================================================================================================================

align.seqs(fasta=Bio_CHLO.trim.pick.unique.fasta, reference=silva.seed.pcr.filter.fasta, flip=T)

#==========================================================================================================================
#    OTUs
#==========================================================================================================================

dist.seqs(fasta=Bio_CHLO.trim.pick.unique.align, processors=8)

cluster(column=Bio_CHLO.trim.pick.unique.dist, count=Bio_CHLO.trim.pick.count_table, method=nearest, cutoff=0.3)

classify.otu(taxonomy=Bio_CHLO.trim.pick.unique.pcr.wang.taxonomy, count=Bio_CHLO.trim.pick.count_table, list=Bio_CHLO.trim.pick.unique.nn.unique_list.list, label=0.02, probs=f, basis=sequence)

get.oturep(column=Bio_CHLO.trim.pick.unique.dist, count=Bio_CHLO.trim.pick.count_table,list=Bio_CHLO.trim.pick.unique.nn.unique_list.list, label=0.02, fasta=Bio_CHLO.trim.pick.unique.fasta, method=abundance)

create.database(list=Bio_CHLO.trim.pick.unique.nn.unique_list.list, count=Bio_CHLO.trim.pick.unique.nn.unique_list.0.02.rep.count_table, label=0.02, repfasta=Bio_CHLO.trim.pick.unique.nn.unique_list.0.02.rep.fasta , constaxonomy=Bio_CHLO.trim.pick.unique.nn.unique_list.0.02.cons.taxonomy)

rarefaction.single(list=Bio_CHLO.trim.pick.unique.nn.unique_list.list)
