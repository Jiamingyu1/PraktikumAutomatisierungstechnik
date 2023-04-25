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

lData.time  = [0,   2,      3,      4,      5,      6,      7,      8,      9,      10];
lData.dl_1k = [0,   100,    50,     50,     50,     75,     75,     20,     80,     0;...
               0,   100,    100,    50,     25,     50,     100,    60,     30,     0;...
               0,   100,    100,    50,     75,     50,     50,     70,     0,      0;...
              ]*1e-3;
lData.dl_2k = [0,   100,    50,     50,     50,     75,     75,     70,     50,     0;...
               0,   100,    100,    50,     25,     50,     100,    40,     0,      0;...
               0,   100,    100,    50,     75,     50,     50,     30,     70,     0;...
              ]*1e-3;
lData.dl_3k = [0,   100,    50,     50,     50,     75,     75,     40,     20,     0;...
               0,   100,    100,    50,     25,     50,     100,    50,     80,     0;...
               0,   100,    100,    50,     75,     50,     50,     10,     50,     0;...
              ]*1e-3;
          
          
lData.l_1k = lData.dl_1k + ones(size(lData.dl_1k))* BHA.Trunk.ls_ik_init(1);
lData.l_2k = lData.dl_2k + ones(size(lData.dl_2k))* BHA.Trunk.ls_ik_init(2);
lData.l_3k = lData.dl_3k + ones(size(lData.dl_3k))* BHA.Trunk.ls_ik_init(3);

%% Auswertung
if 1
    load('Musterloesung_MA.mat');

    sim('Kin_v_BHA_cc.slx')

    figure
       
    subplot(3,1,1)
    hold on; grid on;
        plot(ML.pos.time, reshape(ML.pos.signals.values(1,1,:),1,[]), 'r:', 'LineWidth', 2)
        plot(ML.pos.time, reshape(ML.pos.signals.values(2,1,:),1,[]), 'g:', 'LineWidth', 2)
        plot(ML.pos.time, reshape(ML.pos.signals.values(3,1,:),1,[]), 'b:', 'LineWidth', 2)
        
        plot(pos.time, reshape(pos.signals.values(1,1,:),1,[]), 'r', 'LineWidth', 1)
        plot(pos.time, reshape(pos.signals.values(2,1,:),1,[]), 'g', 'LineWidth', 1)
        plot(pos.time, reshape(pos.signals.values(3,1,:),1,[]), 'b', 'LineWidth', 1)
        
        ylabel('pos in [m]')
        title('x -> rot,  y -> grün,  z -> blau')
        
    subplot(3,1,2)
    hold on; grid on;
        plot(ML.axis.time, reshape(ML.axis.signals.values(1,1,:),1,[]), 'r:', 'LineWidth', 2)
        plot(ML.axis.time, reshape(ML.axis.signals.values(2,1,:),1,[]), 'g:', 'LineWidth', 2)
        plot(ML.axis.time, reshape(ML.axis.signals.values(3,1,:),1,[]), 'b:', 'LineWidth', 2)
        
        plot(axis.time, reshape(axis.signals.values(1,1,:),1,[]), 'r', 'LineWidth', 1)
        plot(axis.time, reshape(axis.signals.values(2,1,:),1,[]), 'g', 'LineWidth', 1)
        plot(axis.time, reshape(axis.signals.values(3,1,:),1,[]), 'b', 'LineWidth', 1)
        
        ylim([-1.1, 1.1])
        ylabel('axis []')
        title('x -> rot,  y -> grün,  z -> blau')
        
    subplot(3,1,3)
    hold on; grid on;
        plot(ML.angle.time, ML.angle.signals.values, 'r:', 'LineWidth', 2)
                
        plot(angle.time, angle.signals.values, 'r', 'LineWidth', 1)
       
        ylabel('angle [rad]')

end