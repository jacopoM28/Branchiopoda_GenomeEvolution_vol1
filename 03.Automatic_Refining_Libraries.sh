#################################################################
#                 Automatic refinment of TE libraries           #
#################################################################
#This script will: 
  #1. Blast each TE library agains a set of proteomes (NB: is important to remove any protein with TE-related signature from target database)
  #2. Use ProtExcluder to remove genes and gene fragments
  #3. Use the cleanup_tandem.pl script to remove tandem repeats (they are not transposable elements)


##1.

for i in *Renamed.fa; do 

  blastx -query "$i" -db Cleaned_Prot.pep -evalue 1e-10 -num_descriptions 10 -out "$i"_Blastx.out -num_threads 20; 
  
done;

##2.
for i in *Blastx.out; do 

  var1=$( echo "$i" | awk -F"-" '{print$1}'); 
  perl /media/storage/jacopomartelossi/Software/ProtExcluder1.1/ProtExcluder.pl "$i" "$var1"-families_Renamed.fa; 
  
done;

##3.

for i in *fanoProtFinal; do 

  var1=$( echo "$i" | awk -F"-" '{print$1}'); 
  perl /media/storage/jacopomartelossi/Software/cleanup_tandem.pl -f "$i" -minlen 80 -misschar n -nr 0.5 > "$var1"-families.noProt
.noTandem.fa; 

done;
