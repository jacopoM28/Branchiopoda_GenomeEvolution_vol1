#####################################################################################
#           Manual charachterization of Lpac DDE.D autonomous elements              #
#####################################################################################

mkdir Element_Characterization

awk '/^>/ {printf("\n%s\n",$0);next; } { printf("%s",$0);}  END {printf("\n");}' Lpac_DDE.cds.fa > Lpac_DDE.cds.oneliner.fa
grep -v "#" Lpac_DDE.BestHits.domtblout | while read line; do 

varHit=$( echo "$line" | awk '{print$1}' | sed 's/_aln//'); 
varSeq=$( echo "$line" | awk '{print$4}'); 
grep -w -A1 "$varSeq" Lpac_DDE.cds.oneliner.fa | sed 's/lcl/'"$varHit"'/'; 

done > Element_Characterization/Lpac_DDE.D_Hits.fa

cd Element_Characterization
#Cluster nucleotide sequences corresponding to DDE.D tpase following 80-80 rule
cd-hit-est -g 1 -o Lpac_DDE.D_Hits.nr.fa -i Lpac_DDE.D_Hits.fa -n 4 -c 0.80 -t 1 -aS 0.8 -d 0 -G 0;
clstr_sort_by.pl < Lpac_DDE.D_Hits.nr.fa.clstr no > Lpac_DDE.D_Hits.nr.fa.ordered.clstr;
#Extract all clusters with at least 5 members
make_multi_seq.pl Lpac_DDE.D_Hits.fa Lpac_DDE.D_Hits.nr.fa.ordered.clstr multi-seq 5; 
mv multi-seq Lpac_Min5_Clusters;
cd Lpac_Min5_Clusters;

#Rename the clusters
for j in $( ls ); do 

  mv "$j" Lpac_"$j".fasta; 

done;

for i in *fasta; do 

  #Align all clusters
  einsi --thread 20 "$i" > "${i//.fasta/.einsi}"; 
  #Build up consensus sequences
  CIAlign --remove_insertions --make_consensus --consensus_name "${i//.fasta/_cons}" --outfile_stem "${i//.fasta/}" --infile "${i//.fasta/.einsi}"
done;

######These consensus were used in a Blast-Extend-Extract script to manually curate them
