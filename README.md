# matlab-analysis-on-operant-reinforcement

This repository contains all the analysis scripts for the Y-mazes setup. This setup was published in Werkhoven et al. 2019.

The data is not contained within the repository due to its size. The main script used for the results from the screen performed on the dopaminergic lines
is the effects_screening.m.

The results from this script are then saved in a text file within the data folder (it contains an additional file with the name of the lines that correspond
to the column names).

The creation of the barplot in a similar format as for the other screens occurs with the only R script present in the repository: barplot_occupancy.R. The only
thing to adapt from with script is the working_directory variable that should point to the main folder of the repository. Then it will creatre a barplot that will
be saved with eps format in the current working directory (this can be found out by running 'getwd()' in the command line).
