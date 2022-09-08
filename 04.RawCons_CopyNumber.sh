########################################################################################
#      Improve raw TE annotation and extract consensus with more than 50 hits          #
########################################################################################
#This script will: 
  #1. Uses RepeatCraft to merge fragmented insertions.
  #2. Extract the consensus with at least 50 insertions.  

#1.
for i in *genomic.fa; do 

  var1=$( echo "$i" | cut -d"-" -f1); 
   /media/storage/jacopomartelossi/Software/repeatcraftp/repeatcraft.py -c /media/storage/jacopomartelossi/Software/repeatcraftp/repeatcraft.cfg -u "$i".out -r "$i".out.gff -o ../Repeats_Curation/Raw.Cons_CopyNumber/"$var1" -m stri
ct; 

done;

#2.
for i in *rmerge.gff; do 

  var=$( echo "$i" | cut -d"." -f1); 
  grep -v "#" "$i" | awk -F"\t" '{print$9}' | cut -d";" -f3 | sed 's/ID=//g' | sort | uniq -c | awk -v OFS="\t" '{print$2,$1}' > "
$var"_RawCounts.txt; 

done;
