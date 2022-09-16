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

ln -s /media/storage/jacopomartelossi/Notostraca_Analyses/Repeats_Curation/Libs/ALL_RawLibs.noProt.noTandem.nr.fa

##RepeatMasker with merged raw TE library
for i in *.genomic.fa; do 

   RepeatMasker -small -e NCBI -lib ALL_RawLibs.noProt.noTandem.nr.fa -pa 20 -gff -a -no_is "$i"; 
   
done;
 
cd ../Curated_Libs

for i in /media/storage/jacopomartelossi/Notostraca_Analyses/Genomes/Branchiopods/*.fa; do 
  ln -s "$i"; 
done;

#RepeatMasker with merged curated TE library
 
