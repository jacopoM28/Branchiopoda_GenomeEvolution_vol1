##########################################################################
#.   Rename the TE-related protein library at the superfamily level.     #
##########################################################################

while read line; do 
  var1=$( echo "$line" | awk '{print$1}'); 
   var2=$( echo "$2" | awk '{print$2}'; sed -i 's,'"$var1"','"$var2"',
g' RepeatPeps_Renamed.lib; 

done< Rename_RepeatPeps.txt
