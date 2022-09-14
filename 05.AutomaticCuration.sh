################################################################################
#                  Automatic curation of raw TE libraries                      #
################################################################################
##Automatic versione of the BEE pipeline to extend raw consensus.

for i in ../../Genomes/Branchiopods/*genomic.fa; do

        varSpecie=$( echo "$i" | cut -d"/" -f5 | cut -d"." -f1);
        mkdir "$varSpecie";
        cd "$varSpecie";
        #Counter for the 5 extension rounds
        for j in {1..5}; do

                mkdir rnd"$j";
                cd rnd"$j";
                ln -s ../../../../Genomes/Branchiopods/"$i"
                #If it's the first extension round, use the automatically generated libraries as queries...
                if [ "$j" = 1 ]; then
                        ln -s  ../../../Libs/"$varSpecie"-families.noProt.noTandem.fa
                        python ../../../../TE_Scripts/AutomaticBEE.py --genome "$varSpecie".genomic.fa --lib "$varSpecie"-families.noProt.noTandem.fa --out "$varSpecie"_auto_rnd"$j" --blast_identity 70 --blast_query_cov 70 --num_threads 30 --min_Blast_Hits 5
                #if not, use the previously extended ones...        
                else
                        #Previous round variable, necessary to softlink the correct library as new query
                        varRound="$(( j-1 ))"
                        ln -s ../rnd"$varRound"/"$varSpecie"_auto_rnd"$varRound"_Consensus.fa
                        python ../../../../TE_Scripts/AutomaticBEE.py --genome "$varSpecie".genomic.fa --lib "$varSpecie"_auto_rnd"$varRound"_Consensus.fa --out "$varSpecie"_auto_rnd"$j" --blast_identity 70 --blast_query_cov 70 --num_threads 30 --min_Blast_Hits 5;
                fi;
                cd ../;
        done;
        cd ../
done;

