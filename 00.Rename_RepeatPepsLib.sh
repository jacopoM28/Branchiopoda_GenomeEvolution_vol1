#######################################################################################
#.   Rename the RepeatMasker TE-related protein library at the superfamily level      #
#                     and merge with the DDE one                                      #
#######################################################################################

#1. Renamed the library
while read line; do 
  
  var1=$( echo "$line" | awk '{print$1}'); 
  var2=$( echo "$line" | awk '{print$2}'); 
  sed -i 's,'"$var1"' ,'"$var2"' ,g' RepeatPeps_Renamed.lib; 
  
done< Rename_RepeatPeps.txt

#2. Extract DNA DDE transposase
grep ">" DDE_Prot.fa | awk -F"#" '{print$2}' | grep -w -A1 -Ff - RepeatPeps_Renamed.lib > RepeatPeps_DDE.fa
sed -i 's/--//g' RepeatPeps_DDE.fa
sed -i '/^$/d' RepeatPeps_DDE.fa 

#3.Merge with DDE library
cat DDE_Prot.fa RepeatPeps_DDE.fa > Merged_DDE.fa

#4. Remove redundancy at the 70% of similarity (not necessary to have a lot of similar sequences)
cd-hit -i Merged_DDE.fa -o Merged_DDE.nr.fa -c 0.7 -n 5

