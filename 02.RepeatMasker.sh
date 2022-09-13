########################################################################
#                 TE annotation with raw TE libraries                  #
########################################################################
#The script must be run in a directory with all genomes in fasta files (*.fa files) and all libraries (*-families_renamed.fa)

for i in *genomic.fa; do 
  varSpecie=$( echo "$i" | cut -d"." -f1); 
  RepeatMasker -small -e NCBI -lib "$varSpecie"-families_renamed.fa -pa 20 -gff -a -no_is -nolow -norna -s "$i";
done;
