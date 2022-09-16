#################################################################
#                 Automatic refinment of TE libraries           #
#################################################################
#Remove genes/gene fragments and tandem repeats from a repeats consensus library
  #0. Renam consensus sequences adding species ID prefix.
  #1. Blast each TE library against previously cleaned proteomes.
  #2. Use ProtExcluder to remove genes and gene fragments.
  #3. Use the cleanup_tandem.pl script to remove tandem repeats (they are not transposable elements).
  #4. Merge libraries and remove redundancy

##0.

for i in *-families.fa; do

        varName=$( echo "$i" | cut -d"-" -f1);
        sed 's/>/>'"$varName"'_/' "$i" > "$varName"-families_Renamed.fa;

done;


##1.

for i in *Renamed.fa; do 

  blastx -query "$i" -db ALL-noTE.pep -evalue 1e-10 -num_descriptions 10 -out "$i"_Blastx.out -num_threads 20; 
  
done;

##2.
for i in *Blastx.out; do 

  var1=$( echo "$i" | awk -F"-" '{print$1}'); 
  perl /media/storage/jacopomartelossi/Software/ProtExcluder1.1/ProtExcluder.pl "$i" "$var1"-families_Renamed.fa; 
  
done;

##3.

for i in *fanoProtFinal; do 

  var1=$( echo "$i" | awk -F"-" '{print$1}'); 
  perl /media/storage/jacopomartelossi/Software/cleanup_tandem.pl -f "$i" -minlen 80 -misschar n -nr 0.5 > "$var1"-families.noProt.noTandem.fa; 

done;

##4. Merge libraries and remove redundancy
cat *-families.noProt.noTandem.fa > ALL_RawLibs.noProt.noTandem.fa;
cd-hit-est -T 0 -i ALL_RawLibs.noProt.noTandem.fa -M 1000000 -o ALL_RawLibs.noProt.noTandem.nr.fa -c 0.8 -n 5 -aS 0.8 -g 1 -G 0
