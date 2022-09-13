#####################################################
#     Clean proteomes from TE-related genes         #
#####################################################
###TE.pep.lib = TE-related protein db (RepeatPeps Lib + EDTA)
###ALL.pep = All branchiopods proteomes

#Create blastdb from TE-related protein
makeblastdb -in Libs/TE.pep.lib -dbtype prot
cd Proteoms;

#Blast all concatenated proteomes against TE-related protein db
blastp -num_threads 20 -query ALL.pep -db ../Libs/TE.pep.lib -evalue 1e-5 -outfmt 6 -out ALL.pep.blastp -max_hsps 1

#Create list of hitted proteins
awk -F"\t" '{print$1}' ALL.pep.blastp | sort -u > ALL_TE.Homology.txt

#Remove hitted proteins from proteomes
awk '{ if ((NR>1)&&($0~/^>/)) { printf("\n%s", $0); } else if (NR==1) { printf("%s", $0); } else { printf("\t%s", $0); } }' ALL.pep | grep -w -v -Ff ALL_TE.Homology.txt - | tr "\t" "\n" > ALL-noTE.pep
