		########## 1. OrthoFinder and Interproscan analyses on proteomes #############

	### 1.1 OrthoFinder command line - the Branchiopoda proteomes were added to a previous OrthoFinder analyses performed on 111 holozoan species

/usr/local/OrthoFinder/ultra_sensitive/orthofinder -b /home/STUDENTI/shared/2022_proteomes/longest_isoform/OrthoFinder/Results_Feb16/WorkingDirectory/ -f /home/STUDENTI/shared/Branchiopoda_proteomes/PROTEOMES_agat/ -t 20 -a 20

	### 1.2 Interproscan analysis

/home/STUDENTI/shared/interproscan-5.45-80.0/interproscan.sh -i path/to/proteome.fasta -d Interproscan/Specie/ -cpu 20

		########## 2. Identify OGs for Ago family, Dicer protein and RdRP protein family ##########

	### 2.1 For each protein or protein family of interest, we scanned the Interproscan output of Homo sapiens searching for sequences with a "canonical" domain composition by using IPR codes. In detail:
	- Ago and Piwi subfamilies: PAZ (IPR003100) and Piwi (IPR003165) domains. These two subfamilies ended up in two different OGs, which identity was determined thanks to the Homo sapiens proteome annotation.
	- Dicer proteins: Dicer (PF03368) and PAZ domains.
	- RdRP proteins: RdRP (IPR007855) domain - in this case we use C. elegans because H. sapiens do not have this proteins. 
	Once we identified the sequences in Homo sapiens, we searched them in the OrthoFinder OGs - the commands for Ago are reported for example

for i in $(cat Homo_sapiens_Ago.txt); do echo -e "$i""\t"$(grep "$i" /home/STUDENTI/shared/2022_proteomes/Homo_sapiens_aa.fasta | grep -oh "\w*gene=\w*")"\t"$(grep "$i" /home/STUDENTI/shared/2022_proteomes/longest_isoform/OrthoFinder/Results_Feb16/WorkingDirectory/Results_Sep02/Orthogroups/Orthogroups.tsv | awk '{print $1}'); done

cp path/to/OG.fasta /home/STUDENTI/shared/Branchiopoda_OGs/Ago/Ago_OG.fasta

for i in $(grep ">" Ago_OG.fasta | sed 's/>//'); do sp=$(grep -oh -f "$i" dataset_withBranchiopoda.txt); grep -w "$i" /home/STUDENTI/shared/Interproscan/"$sp"/"$sp"*.tsv; done > Ago_OG.tsv

		########## 3. Implementation of the domain extraction ##########

	## 3.1 We looked at the domain composition of the sequences of H. sapiens to look at the domain composition of these sequences. For each domain found, we run the "domain_extraction.sh" script.

for i in 0.3 0.5 0.7; do bash domain_composition.sh Ago_OG.tsv Domain_code.txt "$i" 2; done

		########### 4. Reconstruct domain composition for each protein sequence ##########

	### 4.1 Copy the last HMMER iteration file and rename it as "Domain"_searchlast for convenience.

for n in 0.3 0.5 0.7; do cd /home/STUDENTI/shared/Branchiopoda_OGs/Ago/iterations_files/"$n"; for j in $(ls | grep search1 | awk -F_ '{print $1}'| sort -u); do a=$(ls | grep ^"$j"_hmmsearch"[0-9]" | grep -v aln | sed 's/'"$j"'//g' | sort -t "h" -k3,3n | tail -n1); cp "$j""$a" "$j""${a%search*[0-9]}"searchlast; done ; cd /home/STUDENTI/shared/Branchiopoda_OGs/Ago/ ; done

	### 4.2 Create a file in which for every protein sequence are indicate the charachterizing domains, the position and the HMMER e-value (as a confidence measure of the domain identification) - in this command line Ago OG is taken as example

for n in 0.3 0.5 0.7; do for i in $(grep ">" /home/STUDENTI/shared/Branchiopoda_OGs/Ago/Ago_OG.fasta | sed 's/ .*//g;s/>//g'); do for j in $(grep /home/STUDENTI/shared/Branchiopoda_OGs/Ago/"$i" /home/STUDENTI/shared/Branchiopoda_OGs/Ago/*matches_symfrac"$n".fasta); do d=$(ls /home/STUDENTI/shared/Ago/*domain.txt | awk -F"_" '{print $1}'); e=$(echo $j | awk -F- '{print $NF}'); s=$(echo $j | awk -F$ '{print $NF}' | awk -F- '{print $1}'); v=$(grep -A10 ">> $i" /home/STUDENTI/shared/Branchiopoda_OGs/Ago/iterations_files/"$n"/"$d"_hmmsearchlast | grep "$s.*$e .." | grep -oh "\w*e-\w*" | tail -n1) ; echo -e $i"\t"$d"\t"$s"\t"$e"\t"$v ; done | sort -k3,3n ; echo '-' ; done > /home/STUDENTI/shared/Branchiopoda_OGs/Ago/Ago_domain_positions_"$n".txt ; done

	########## 5. File fasta with Branchiopoda species proteins and domain composition information in header ##########

	## 5.1 Create fasta file with Branchiopoda sequences and Drosophila sequences (for RdRP we used C. elegans sequences)

	## 5.2 Run "header.sh" script - we used for all OGs the symfrac parameter set at 0.5

bash header.sh Branchiopoda_Ago.fasta > Branchiopoda_Ago_wheader.fasta
