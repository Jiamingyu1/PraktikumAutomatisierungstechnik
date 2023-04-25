clear all;
close all;
clc;

% Einlesen des Pfads der Bibliothek BHA_Lib_Prakt
addpath(genpath('../BHA_Lib_Prakt/'));

% Einlesen des Pfads der Bibliothek BHA_Lib_Stud
path_BHA_Stud = genpath('../BHA_Lib_Stud/');
addpath(path_BHA_Stud);

load_par_bha


%% Input: Seillängen
if 0
    if 1
        pkt = input('Validierung der Jacobimatrix an Punkt [1,2,3]:')
        load(['ML_Jacobi_Pkt',int2str(pkt), '.mat'])
    else
        pkt = 0;
    end

    lData.time  = [0, 1];
    switch pkt
        case 1
            lData.dl_1k = [50;  50;     50]*1e-3;
            lData.dl_2k = [50;  50;     50]*1e-3;
            lData.dl_3k = [50;  50;     50]*1e-3;
            J_ML = ML.J(:,:,2);
        case 2
            lData.dl_1k = [25;  25;     25]*1e-3;
            lData.dl_2k = [75;  75;     75]*1e-3;
            lData.dl_3k = [75;  75;     75]*1e-3;
            J_ML = ML.J(:,:,2);
        case 3
            lData.dl_1k = [20;  90;     40]*1e-3;
            lData.dl_2k = [70;  40;     80]*1e-3;
            lData.dl_3k = [30;  60;     70]*1e-3;
            J_ML = ML.J(:,:,2);
        otherwise
            lData.dl_1k = [50;  50;     50]*1e-3;
            lData.dl_2k = [50;  50;     50]*1e-3;
            lData.dl_3k = [50;  50;     50]*1e-3;
            J_ML = zeros(3,9);
    end
    lData.dl_1k = [lData.dl_1k, lData.dl_1k];
    lData.dl_2k = [lData.dl_2k, lData.dl_2k];
    lData.dl_3k = [lData.dl_3k, lData.dl_3k];

    lData.l_1k = lData.dl_1k + ones(size(lData.dl_1k))* BHA.Trunk.ls_ik_init(1);
    lData.l_2k = lData.dl_2k + ones(size(lData.dl_2k))* BHA.Trunk.ls_ik_init(2);
    lData.l_3k = lData.dl_3k + ones(size(lData.dl_3k))* BHA.Trunk.ls_ik_init(3);

    sim('Jq_cc.slx')
    if pkt~=0
        Fehler = J(:,:,2)-J_ML
    end
end