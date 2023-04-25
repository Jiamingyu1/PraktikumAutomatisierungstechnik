clearvars, clc, close all

%% Initialisierung der Parameter
run('init.m')

%% Messung
load('Sprung15VD30D50.mat');

%% Praktikumsaufgabe P3
%############################################## (a) Skalierung der Messung
%#########################################################################
Meas.t = TBD;  %Zeitvektor

%Messdaten
Meas.V_out = TBD; % Gemessene Ausgangsspannung [V]
Meas.I_L   = TBD; % Gemessener Spulenstrom [A]

%##################################################### (b) Messung Filtern
%#########################################################################
%Filterauslegung:
Filt.cutoffFrequency = 20e3;                       %Filter Grenzfrequenz [Hz]
Filt.samplingFrequency = 1/Tinterval;              %Abtastrate Messung   [Hz]
Filt.niquistFrequency = Filt.samplingFrequency/2;  %Nyquist Frequenz     [Hz]

[Filt.b,Filt.a] = butter(4,2*Filt.cutoffFrequency/Filt.samplingFrequency);          %Auslegung Butterworth-Filter
[Filt.bch,Filt.ach] = cheby1(4,0.1,2*Filt.cutoffFrequency/Filt.samplingFrequency);  %Auslegung Chebyshev Typ 1 Filter

%Frequnzgang des digitalen Filters:
figure('name','Übertragungsfunktion Butterworth Filter')
freqz(Filt.b,Filt.a,logspace(1,6,2000),Filt.samplingFrequency) 

figure('name','Übertragungsfunktion Chebyshev Typ 1 Filter')
freqz(Filt.bch,Filt.ach,logspace(1,6,2000),Filt.samplingFrequency) 

%Filterung der Messung:
Meas.I_L_f   = filtfilt(Filt.b,Filt.a,Meas.I_L);
Meas.V_out_f = filtfilt(Filt.b,Filt.a,Meas.V_out);

Meas.I_L_fch   = filtfilt(Filt.bch,Filt.ach,Meas.I_L);
Meas.V_out_fch = filtfilt(Filt.bch,Filt.ach,Meas.V_out);

%Vergleich von ungefilterten und gefilterten Messdaten:
figure('name','Datenfilterung')

ax(1) = subplot(2,1,1); hold all
plot(Meas.t,Meas.I_L)
plot(Meas.t,Meas.I_L_f,'LineWidth',2)
plot(Meas.t,Meas.I_L_fch,'LineWidth',2)
ylabel('I_L [A]')
grid on
legend('Messung','Messung mit Butterworth Filter','Messung mit Chebyshev Typ 1 Filter')

ax(2) = subplot(2,1,2); hold all
plot(Meas.t,Meas.V_out)
plot(Meas.t,Meas.V_out_f,'LineWidth',2)
plot(Meas.t,Meas.V_out_fch,'LineWidth',2)
ylabel('V_{out} [V]')
grid on

linkaxes(ax,'x')
set(ax,'XLim',[Tstart,0.012])

%#################################### (c) Validierung idealisiertes Modell
%#########################################################################

%Initialisiere Paramter und Modellszenario:
param.V_ls   = TBD;  %Eingangsspannung [V]
param.R_load = TBD;  %Lastwiderstand [Ohm] 

D_pre  = TBD;  %Initialer Duty Cycle [-]
D_post = TBD;  %Duty Cycle nach Sprung [-]

% Ideales Modell
SimIdeal.x0 = [TBD; TBD]; %Anfangswert

%Simulation
options = odeset('RelTol',1e-8);
tspan   = [TBD, TBD];    %Simulationszeit
[SimIdeal.t,SimIdeal.x] = ode45(@(t,x) Boost_ideal(t,x,param,D_pre,D_post),tspan,SimIdeal.x0,options);

%############################################ (d) Validierung PLECS Modell
%#########################################################################
% PLECS Modell simulation
T_step = TBD;  %Zeitpunkt des Sprungs im Duty Cycle
sim('Boost_lsg.slx')

SimBoost.t = simout.Time - T_step;  %Zeitvektor
SimBosst.I_L   = simout.Data(:,1);  %Simulierter Spulenstrom
SimBosst.V_out = simout.Data(:,2);  %Simulierte  Ausgangsspannung

%###################################### (e) Vergleich Simulation / Messung
%#########################################################################
figure('name','Vergleich von Modell und Messung')

ax(1) = subplot(2,1,1); hold all
title('I_L')
plot(Meas.t,Meas.I_L_f)
plot(SimIdeal.t,SimIdeal.x(:,1))
plot(SimBoost.t,SimBosst.I_L)
ylabel('I_L [A]')
legend('Messung','Ideal','PLECS')
grid on

ax(2) = subplot(2,1,2); hold all
title('V_{out}')
plot(Meas.t,Meas.V_out_f)
plot(SimIdeal.t,SimIdeal.x(:,2))
plot(SimBoost.t,SimBosst.V_out)
ylabel('V_{out} [A]')
xlabel('t [s]')
legend('Messung','Ideal','PLECS')
grid on

linkaxes(ax,'x')
set(ax,'XLim',[Tstart,0.012])
