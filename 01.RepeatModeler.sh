########################################################################
#                      De novo TE library                              #
########################################################################
#The script must be run in a directory with all genomes in fasta files (*.fa files)
#In my case, I have: Tusa.genomic.fa; Tita.genomic.fa ecc...

NINJA_DIR=/home/jacopomartelossi/.conda/envs/Repeats/bin
for i in *.fa; do 
  var1=$(echo "$i" | cut -d"." -f1); 
  BuildDatabase -name "$var1" -engine ncbi "$i"
  RepeatModeler -pa 5 -engine ncbi -database "$var1" -LTRStruct -debug 2>&1 | tee "$var1"_LTR_struct.log;
done;
