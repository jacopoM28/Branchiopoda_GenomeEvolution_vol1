#####################################################
#     Clean proteomes from TE-related genes         #
#####################################################
#TE.pep.lib = TE-related protein db (RepeatPeps Lib + EDTA)
#ALL.pep = All branchiopods proteomes

makeblastdb -in Libs/TE.pep.lib -dbtype prot
cd Proteoms;
blastp -num_threads 20 -query ALL.pep -db ../Libs/TE.pep.lib -evalue 1e-5 -outfmt 6 -out ALL.pep.blastp -max_hsps 1
awk -F"\t" '{print$1}' ALL.pep.blastp | sort -u > ALL_TE.Homology.txt
awk '{ if ((NR>1)&&($0~/^>/)) { printf("\n%s", $0); } else if (NR==1) { printf("%s", $0); } else { printf("\t%s", $0); } }' ALL.pep | grep -w -v -Ff ALL_TE.Homology.txt - | tr "\t" "\n" > ALL-noTE.pep
