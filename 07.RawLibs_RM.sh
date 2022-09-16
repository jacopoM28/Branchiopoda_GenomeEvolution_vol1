####################################################################
#                           RepeatMasker analyses                  #
####################################################################
#Repeats annotation using both raw and curated TE libraries

mkdir Raw_Libs
mkdir Curated_Libs
cd Raw_Libs

for i in /media/storage/jacopomartelossi/Notostraca_Analyses/Genomes/Branchiopods/*.fa; do 
  ln -s "$i"; 
done;

for i in /media/storage/jacopomartelossi/Notostraca_Analyses/Repeats_Curation/Libs/*.fa; do 
  ln -s "$i"; 
done;

for i in *.genomic.fa; do 

  varSpecie=$( echo "$i" | cut -d"." -f1); 
   RepeatMasker -small -e NCBI -lib "$varSpecie"-families.noProt.noTandem.fa -pa 20 -gff -a -no_is "$i"; 
done;
 
cd ../Curated_Libs

for i in /media/storage/jacopomartelossi/Notostraca_Analyses/Genomes/Branchiopods/*.fa; do 
  ln -s "$i"; 
done;

 
