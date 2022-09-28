####

## $1 = File tsv
## $2 = File txt with domain codes (format: DOMAIN-NAME_*.txt)
## $3 = Valore del symfrac
## $4 = differenza ordine di grandezza OG-proteomi (per evalue). Es: 100 seq nell'OG, circa 2 ordini di grandezza in meno di un proteoma medio (~10^4) ==> cutoff di evalue per hmmsearch diminuisce di due esponenti
## I file fasta contenenti le sequenze degli OG devono avere estensione .fasta

domain=$(echo "$2" | awk -F "_" '{print $1}')
evalue=$(awk "BEGIN { print 3+$4}")

# Create fasta file with all matches
for i in $(grep -f "$2" "$1" | awk -F "\t" '$9<=1e-3' | awk '{print $1}' | sort -u ); 
	do species=$(echo "$i" | grep -oh -f /home/STUDENTI/shared/dataset_withBrachiopoda.txt)
	for m in $(grep "$i" /home/STUDENTI/shared/Interproscan/"$species"/"$species"*.gff3 | grep -f "$2" | awk -F "\t" '$6<=1e-3' | perl -lne '/(?<=ID\=)(.+?)(?=\;)/ and print $1')
		do grep -A1 -w "$m" /home/STUDENTI/shared/Interproscan/"$species"/"$species"_matches.fasta | sed 's/>/>'"$i"'_/g'
	done > "$i"_tmp 
	/usr/local/cdhit-master/cd-hit -i "$i"_tmp -o "$i"_tmp_cdhit -c 1 -t 1 -G 0 -aS 0.8 -aL 0.2 -g 0 > log_tmp
done

c=0
cc=$( expr "$c" + 1 )

cat *_tmp_cdhit > all_"$domain"_matches"$c".fasta
rm *_tmp*

# First HMMER round
# Align the domain matches
mafft --auto --thread 10 all_"$domain"_matches"$c".fasta > all_"$domain"_matches"$c".fasta_aln

# Build profile on domains alignment
hmmbuild --amino --symfrac "$3" --cpu 10 all_"$domain"_matches"$c".hmm all_"$domain"_matches"$c".fasta_aln

# Search profiles back on the multifasta file
hmmsearch -o "$domain"_hmmsearch"$cc" -A "$domain"_hmmsearch"$cc"_aln --incE 1e-$evalue all_"$domain"_matches"$c".hmm "${1%tsv}"fasta


# Extract from HMMER output, new domain sequences (fasta)
IFS=$'\n'
for i in $(grep "#=GS" "$domain"_hmmsearch"$cc"_aln | awk '{print $2}' | sed 's/\//\t/g;s/-/\t/g')
	do header=$(echo "$i" | awk '{print $1}' | sed -E 's/^[0-9]+\|//')
	start=$(echo $i | awk '{print $2}')
	end=$(echo $i | awk '{print $3}')
	grep "$header" "${1%tsv}"fasta | sed 's/ .*//g;s/'"$header"'/'"$header"'_hmmer\$'"$start"'-'"$end"'/g'
	grep -A1 "$header" "${1%tsv}"fasta | tail -n +2 | cut -c "$start"-"$end"
done > all_"$domain"_matches"$cc".fasta


# While loop until the latest iteration retrieves the same number of matches of the previous one
if [ `grep -c ">" all_"$domain"_matches"$cc".fasta` -eq `grep -c ">" all_"$domain"_matches"$c".fasta` ]
	then ccc=$(echo "$cc")
	else while [ `grep -c ">" all_"$domain"_matches"$cc".fasta` -ne `grep -c ">" all_"$domain"_matches"$c".fasta` ]
		do ccc=$( expr "$cc" + 1) 
		mafft --auto --thread 10 all_"$domain"_matches"$cc".fasta > all_"$domain"_matches"$cc".fasta_aln
		hmmbuild --amino --symfrac "$3" --cpu 10 all_"$domain"_matches"$cc".hmm all_"$domain"_matches"$cc".fasta_aln
		hmmsearch -o "$domain"_hmmsearch"$ccc" -A "$domain"_hmmsearch"$ccc"_aln --incE 1e-$evalue all_"$domain"_matches"$cc".hmm "${1%tsv}"fasta
		IFS=$'\n'
		for i in $(grep "#=GS" "$domain"_hmmsearch"$ccc"_aln | awk '{print $2}' | sed 's/\//\t/g;s/-/\t/g')
			do header=$(echo "$i" | awk '{print $1}' | sed -E 's/^[0-9]+\|//')
			start=$(echo $i | awk '{print $2}')
			end=$(echo $i | awk '{print $3}')
			grep "$header" "${1%tsv}"fasta | sed 's/ .*//g;s/'"$header"'/'"$header"'_hmmer\$'"$start"'-'"$end"'/g'
			grep -A1 "$header" "${1%tsv}"fasta | tail -n +2 | cut -c "$start"-"$end"
       		done > all_"$domain"_matches"$ccc".fasta
		c=$(expr "$c" + 1 )
		cc=$(expr "$cc" + 1)
	done
fi

mkdir iterations_files
mkdir iterations_files/"$3"
mv *hmmsearch[0-9]* iterations_files/"$3"
mv *matches[0-9]* iterations_files/"$3"
cp iterations_files/"$3"/all_"$domain"_matches"$ccc".fasta ./"$domain"_matches_symfrac"$3".fasta


# CP INIZIALE
