# README

DDE/D protein libraries collected from pubblicy avaible online resources. All sequences were classified at the superfamily level following [Yuan and Wessler](https://www.pnas.org/doi/abs/10.1073/pnas.1104208108) with a RepeatMasker formatted style.

- **DDE_Prot.fa:** [Yuan and Wessler](https://www.pnas.org/doi/abs/10.1073/pnas.1104208108).
- **RepeatPeps_DDE.fa:** DDE/D DNA transposons present in the RepeatPeps library and reclassified at the superfamily level following [Yuan and Wessler](https://www.pnas.org/doi/abs/10.1073/pnas.1104208108).  
- **Merged_DDE.nr.fa:** Merged non redundant DDE/D library. Used to find DDE/D-related protein evidences across the genomes with tblastn (script 06).  
- **Expresso:** T-Coffe expresso alignment used to generate HMM profiles for each superfamilies. All sequences come from [Yuan and Wessler](https://www.pnas.org/doi/abs/10.1073/pnas.1104208108) because of the high accuracy in the dataset. 
- **.hmm** DNA DDE/D superfamily-specific hmm profiles, builded up with expresso alignments. They were used in script 06 to accurate classify all ORFs identified with tblastn.  
