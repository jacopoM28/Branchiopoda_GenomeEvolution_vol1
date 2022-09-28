# Branchiopoda_GenomeEvolution_vol1

## Bioinformatic pipeline used to study evolution of Transposable Elements and their repression genes in 9 branchiopods genomes.

### Species:  
 - Lpac = *Lepidurus packardi*
 - Lapu = *Lepidurus apus apus*
 - Lart = *Lepidurus arcticus*
 - Lcou = *Lepidurus couesi*
 - Lubb = *Lepidurus apu lubocki*
 - Tita = *Triops cancriformis* (SPA)
 - Tjap = *Triops cancriformis* (JAP)
 - Tlon = *Triops longicaudatus*
 - Tusa = *Triops canctiformis* (ITA) 

### Scripts:

- **01.RepeatModeler.sh:** De-novo TE discovery.  
- **02.Clean_Proteomes.sh:** Remove TE-related genes from a set of proteomes.  
- **03.Automatic_Refining_Libraries.sh:** Removal of genes/genes fragments and tandem repeats from libraries.  
- **04.Manual_Curation.sh:** Manual curation of a set of raw consensus.    
- **05.Automatic_Curation.sh:** Automatic curation of all consensus.  This process was run 10 times.  
- **06.RepeatMasker.sh** TE annotation using RepeatMasker and both raw and curated TE libraries.
- **0X.TE_Repression.Genes.sh** Mining of Piwi, DICER, Ago, RdRP genes from proteomes (No Lpac).

#### Data:
- **Raw_TELibs:** Raw consensus libraries without gene/gene fragments and tandem repeats resulting from scripts 01,02 and 03 

##### NB: all custom python scripts used for TE curation and annotaion can be found in: [TE_Scripts](https://github.com/jacopoM28/Python_Scripts/tree/main/TE_scripts)
 
