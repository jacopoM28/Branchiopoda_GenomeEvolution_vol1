# Branchiopoda_GenomeEvolution_vol1

## Bioinformatic pipeline used to study evolution of Transposable Elements in 9 branchiopods genomes.

### Species :  
 - Lpac = *Lepidurus packardi*
 - Lapu = *Lepidurus apus apus*
 - Lart = *Lepidurus arcticus*
 - Lcou = *Lepidurus couesi*
 - Lubb = *Lepidurus apu lubocki*
 - Tita = *Triops cancriformis* (SPA)
 - Tjap = *Triops cancriformis* (JAP)
 - Tlon = *Triops longicaudatus*
 - Tusa = *Triops canctiformis* (ITA) 

### Raw Repeats annotation:

- **01.RepeatModeler.sh:** De-novo TE discovery.  
- **02.RepeatMasker.sh:** TE annotation with automatic generated libraries.  

**NB:** All raw repeats libraries can be found in: Raw_TELibs.zip

### Manual and automatic repeats curation:
- **03.Clean_Proteomes.sh:** Remove TE-related genes from a set of proteomes
- **04.Automatic_Refining_Libraries.sh:** Removal of genes/genes fragments and tandem repeats from libraries.  
- **05.Manual_Curation.sh:** Manual curation of a set of raw consensus.    
- **06.Automatic_Curation.sh:** Automatic curation of all consensus.  This process was run 5 times.  

##### NB: all custom python scripts can be found in: [TE_Scripts](https://github.com/jacopoM28/Python_Scripts/tree/main/TE_scripts)
 
