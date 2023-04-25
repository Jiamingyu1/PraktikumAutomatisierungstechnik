clear all;
close all;
clc;

% Einlesen des Pfads der Bibliothek BHA_Lib_Prakt
addpath(genpath('../BHA_Lib_Prakt/'));

% Einlesen des Pfads der Bibliothek BHA_Lib_Stud
path_BHA_Stud = genpath('../BHA_Lib_Stud/');
addpath(path_BHA_Stud);

load_par_bha

%% input
Data.time       = [0        4       8       9.5     14      22      23      25];
Data.xdot_soll  = [0        0       0       0.1     -0.1    0.1     0.1     0];
Data.ydot_soll  = [0        0       0       0       0       0       0.1     0];
Data.zdot_soll  = [0.1      -0.1    0.1     0       0       0       -0.1    0];
