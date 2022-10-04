for i in ../Genomes/Branchiopods/*genomic.fa; do

  varSpecie=$( echo "$i" | cut -d"/" -f4 | cut -d"." -f1);
  mkdir "$varSpecie";
  cd "$varSpecie"
  ln -s ../../Genomes/Branchiopods/"$varSpecie".genomic.fa
  makeblastdb -in "$varSpecie".genomic.fa -dbtype nucl
  #tblastn with a query database composed by DNA DDE/D Tpase
  tblastn -query ../../Libs/Merged_DDE.nr.fa -db "$varSpecie".genomic.fa -evalue 1e-10 -num_threads 20 -outfmt 6 -out "$varSpecie".tblastn
  #blast2bed, from blast to bed output
  sh ../blast2bed "$varSpecie".tblastn 
  bedtools sort -i  "$varSpecie".tblastn.bed >  "$varSpecie".sorted.bed
  samtools faidx "$varSpecie".genomic.fa 
  #Expand blast hits by 50bp at both ends to correct for imprecise annotations
  bedtools slop -i "$varSpecie".sorted.bed -g "$varSpecie".genomic.fa.fai -b 50 > "$varSpecie".extended.bed
  bedtools sort -i  "$varSpecie".extended.bed >  "$varSpecie".extended.sorted.bed
  #Merge overlapping genomics intervals
  bedtools merge -s -i "$varSpecie".extended.sorted.bed > "$varSpecie".merged.bed 
  #Extract all extended hits
  bedtools getfasta -fi "$varSpecie".genomic.fa -bed "$varSpecie".merged.bed -fo "$varSpecie"_DDE.fa
  #Some sed to reformat the header for ORFinder...quite ugly but efficients
  sed -i 's/:/__SEP__/g' "$varSpecie"_DDE.fa
  sed -i 's/|/_/' "$varSpecie"_DDE.fa
  #ORFfinder requiring a mininum ORF length of 250 aa and ignoring nested ORF
  /media/storage/jacopomartelossi/Software/ORFfinder -in "$varSpecie"_DDE.fa -ml 450 -n true -out "$varSpecie"_DDE.pep -outfmt 0
  #If analyzing the Lpac genome extract also nucleotide sequences of identified ORF (necessary for further analyses)
  if [ $varSpecie == Lpac ]; then

    /media/storage/jacopomartelossi/Software/ORFfinder -in "$varSpecie"_DDE.fa -ml 450 -n true -out "$varSpecie"_DDE.cds.fa -outfmt 1 
  
  fi;
  #hmmscan to identify homogies to known DDE/D DNA domains
  hmmscan --cpu 8  --domtblout "$varSpecie"_DDE.domtblout --tblout "$varSpecie"_DDE.tblout ../../Libs/DDE_Tpase/ALL_DDE.hmm "$varSpecie"_DDE.pep
   #Keep only the best-hit for each translated extended blast hit
  sed -i 's/lcl|ORF._//' "$varSpecie"_DDE.domtblout
  sed -i 's/:.* / /' "$varSpecie"_DDE.domtblout
  awk '!x[$4]++' "$varSpecie"_DDE.domtblout > "$varSpecie"_DDE.BestHits.domtblout
  #Output summary table
  grep -v "#" "$varSpecie"_DDE.BestHits.domtblout | awk '{print$1}' | sort | uniq -cd | awk -v OFS="\t" -v var="$varSpecie" '{print$2,$1,var}' >> ../TE-RelatedHits.tsv
  cd ../;
  
done;
