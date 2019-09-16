# Sombric et al. 2019

This code was developed with MATLAB 2016a.

This repository represents the code that was used for the analysis and figures presented in Sombric et al. 2019.  This repository includes code developed within the Sensorimotor Learning Lab for standard data processing of all collected data types (including kinematics, kinetics, EMG, etc.).  The most up to date version of this code repository can be found here <https://github.com/PittSMLlab/labTools>. 

I would like to direct your attention to the folder labeled "CodeByCarly" which contains code exclusively written by myself.  I would like to specifically note "computeForceParameters" which shows how I converted raw physiological data into clean, neatly organized data ready to be added to a larger data structure.  This code has examples of my approach to missing data, data normalization, data filtering, and data exclusion.  To see how I organize an entire studies worth of data processing, statistics, and visualization, please see the function titles "InclineDeclineStats_JustYoung". For examples of statistical or data visualization coding, I would like to direct you to any of the functions called by "InclineDeclineStats_JustYoung."

If you wish to run this code, you can use data available on my figshare to generate all analysis and figures (https://figshare.com/account/home#/projects/68747).  A truncated version of "InclineDeclineStats_JustYoung" called "InclineDeclineStats_JustYoung_FigShare" can be used in conjunction with the data available on figshare.
