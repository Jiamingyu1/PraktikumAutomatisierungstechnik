clear all;
close all;
clc;

% Einlesen des Pfads der Bibliothek BHA_Lib_Prakt
addpath(genpath('../BHA_Lib_Prakt/'));

% Einlesen des Pfads der Bibliothek BHA_Lib_Stud
path_BHA_Stud = genpath('../BHA_Lib_Stud/');
addpath(path_BHA_Stud);

load_par_bha

ii=1;

%% Input: Seillängen

lData.time  = [0,   2,      3,      4,      5,      6,      7,      8,      9,      10];
lData.dl_1k = [0,   100,    50,     50,     50,     75,     75,     20,     80,     0;...
               0,   100,    100,    50,     25,     50,     100,    60,     30,     0;...
               0,   100,    100,    50,     75,     50,     50,     70,     0,      0;...
              ]*1e-3;
          
lData.l_1k = lData.dl_1k + ones(size(lData.dl_1k))* BHA.Trunk.ls_ik_init(ii);

%% Auswertung
if 0
        
    % Läd Musterlösung und die entsprechenden Input-Seillängen ein
    switch ii
        case 1
            load('Musterloesung_S1.mat');
        case 2
            load('Musterloesung_S2.mat')
        case 3
            load('Musterloesung_S3.mat');
        otherwise
            ii = 1;
            disp('Index wurde zu 1 gesetzt!')
            load('Musterloesung_S1.mat');
    end
        
    sim('Kin_v_Sek_cc.slx')

    figure
       
    subplot(4,1,1)
    hold on; grid on;
        plot(ML.l_Ik.time, reshape(ML.l_Ik.signals.values(1,1,:),1,[]), 'r:', 'LineWidth', 2)
        plot(ML.l_Ik.time, reshape(ML.l_Ik.signals.values(2,1,:),1,[]), 'g:', 'LineWidth', 2)
        plot(ML.l_Ik.time, reshape(ML.l_Ik.signals.values(3,1,:),1,[]), 'b:', 'LineWidth', 2)
        
        plot(l_Ik.time, reshape(l_Ik.signals.values(1,1,:),1,[]), 'r', 'LineWidth', 1)
        plot(l_Ik.time, reshape(l_Ik.signals.values(2,1,:),1,[]), 'g', 'LineWidth', 1)
        plot(l_Ik.time, reshape(l_Ik.signals.values(3,1,:),1,[]), 'b', 'LineWidth', 1)
        
        ylim([0.19, 0.30])
        ylabel('l_{Ik} in [m]')
        title('k=1 -> rot,  k=2 -> grün,  k=3 -> blau')
        
    subplot(4,1,2)
    hold on; grid on;
        plot(ML.pos.time, reshape(ML.pos.signals.values(1,1,:),1,[]), 'r:', 'LineWidth', 2)
        plot(ML.pos.time, reshape(ML.pos.signals.values(2,1,:),1,[]), 'g:', 'LineWidth', 2)
        plot(ML.pos.time, reshape(ML.pos.signals.values(3,1,:),1,[]), 'b:', 'LineWidth', 2)
        
        plot(pos.time, reshape(pos.signals.values(1,1,:),1,[]), 'r', 'LineWidth', 1)
        plot(pos.time, reshape(pos.signals.values(2,1,:),1,[]), 'g', 'LineWidth', 1)
        plot(pos.time, reshape(pos.signals.values(3,1,:),1,[]), 'b', 'LineWidth', 1)
        
        ylabel('pos in [m]')
		xlim([1,10]);
        title('x -> rot,  y -> grün,  z -> blau')
        
    subplot(4,1,3)
    hold on; grid on;
        plot(ML.axis.time, reshape(ML.axis.signals.values(1,1,:),1,[]), 'r:', 'LineWidth', 2)
        plot(ML.axis.time, reshape(ML.axis.signals.values(2,1,:),1,[]), 'g:', 'LineWidth', 2)
        plot(ML.axis.time, reshape(ML.axis.signals.values(3,1,:),1,[]), 'b:', 'LineWidth', 2)
        
        plot(axis.time, reshape(axis.signals.values(1,1,:),1,[]), 'r', 'LineWidth', 1)
        plot(axis.time, reshape(axis.signals.values(2,1,:),1,[]), 'g', 'LineWidth', 1)
        plot(axis.time, reshape(axis.signals.values(3,1,:),1,[]), 'b', 'LineWidth', 1)
        
        ylim([-1.1, 1.1])
		xlim([1,10]);
        ylabel('axis []')
        title('x -> rot,  y -> grün,  z -> blau')
        
    subplot(4,1,4)
    hold on; grid on;
        plot(ML.angle.time, ML.angle.signals.values, 'r:', 'LineWidth', 2)
                
        plot(angle.time, angle.signals.values, 'r', 'LineWidth', 1)
       
	    xlim([1,10]);
        ylabel('angle [rad]')

end