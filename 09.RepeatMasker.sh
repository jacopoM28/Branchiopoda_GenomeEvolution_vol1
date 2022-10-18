####################################################################
#                           RepeatMasker analyses                  #
####################################################################
#Repeats annotation using both raw and curated TE libraries

cd RepeatMasker/
mkdir Raw_Libs
mkdir Curated_Libs
mkdir Pipeline_Check
cd Raw_Libs
for i in /media/storage/jacopomartelossi/Notostraca_Analyses/Genomes/Branchiopods/*.fa; do 

	ln -s "$i"; 

done;
ln -s /media/storage/jacopomartelossi/Notostraca_Analyses/Repeats_Curation/Libs/RawLibs/RawLib.nr.fa

##RepeatMasker with merged raw TE library
for i in *.genomic.fa; do 

  	RepeatMasker -small -e NCBI -lib RawLib.nr.fa -pa 20 -gff -a -no_is "$i"; 
   
done;
cd ../Curated_Libs
for i in /media/storage/jacopomartelossi/Notostraca_Analyses/Genomes/Branchiopods/*.fa; do 
  
	ln -s "$i"; 

done;
ln -s /media/storage/jacopomartelossi/Notostraca_Analyses/Repeats_Curation/Libs/FullLib_Merged.Consensus.nr.BlastxClassified.fa

#RepeatMasker with merged curated TE library
for i in *.genomic.fa; do

	RepeatMasker -small -e NCBI -lib FullLib_Merged.Consensus.nr.BlastxClassified.fa -pa 20 -gff -a -no_is "$i";

done;

#-----------RepeatMasker with only sequences selected for manual curation in their 3 versions (Manually curated, Automatically curated, Raw)--------#
cd ../Pipeline_Check
mkdir AutoLib
mkdir ManualLib
mkdir Raw

cd AutoLib
for i in /media/storage/jacopomartelossi/Notostraca_Analyses/Genomes/Branchiopods/*.fa; do

	ln -s "$i";

done;
ln -s /media/storage/jacopomartelossi/Notostraca_Analyses/Repeats_Curation/Libs/AutoLibs/ManuallyCurated_AutoLib.fa
for i in *.genomic.fa; do

	RepeatMasker -small -e NCBI -lib ManuallyCurated_AutoLib.fa -pa 20 -gff -a -no_is "$i";
done;

cd ../ManualLib
for i in /media/storage/jacopomartelossi/Notostraca_Analyses/Genomes/Branchiopods/*.fa; do

	ln -s "$i";

done;
ln -s /media/storage/jacopomartelossi/Notostraca_Analyses/Repeats_Curation/Libs/ManualLibs/ALL_ManuallyCurated.fa
for i in *.genomic.fa; do 

	RepeatMasker -small -e NCBI -lib ALL_ManuallyCurated.fa -pa 20 -gff -a -no_is "$i";

done;
cd ../Raw
for i in /media/storage/jacopomartelossi/Notostraca_Analyses/Genomes/Branchiopods/*.fa; do

	ln -s "$i";

done;
ln -s /media/storage/jacopomartelossi/Notostraca_Analyses/Repeats_Curation/Libs/RawLibs/ManuallyCurated_RawLib.fa
for i in *.genomic.fa; do

	 RepeatMasker -small -e NCBI -lib ManuallyCurated_RawLib.fa -pa 20 -gff -a -no_is "$i";
done;
cd ../
