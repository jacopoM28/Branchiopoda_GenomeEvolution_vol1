#

for i in *genomic.fa; do 
  varSpecie=$( echo "$i" | cut -d"." -f1); 
  RepeatMasker -small -e NCBI -lib "$varSpecie"-families_renamed.fa -pa 20 -gff -a -no_is -nolow -norna -s "$i";
done;
