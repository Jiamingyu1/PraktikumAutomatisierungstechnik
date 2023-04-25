clc, clearvars, close all
%% Initialisierung

% Parameter
param.L     = 150e-6;  %Induktivit�t [L]
param.R_L   = 0.17;    %Serienwiderstand Induktivit�t [Ohm]
param.C     = 300e-6;  %Ausgangskondensator [C]
param.R_C   = 0.36;    %Serienwiderstand Kondensator [Ohm]
param.R_sw  = 0.21;    %Drain-Source Widerstand MOSFET [Ohm]
param.R_D   = 0.01;    %Diode Leitwiderstand [Ohm]
param.V_D   = 0.80;    %Diode Vorw�rtsspannung [V] 
param.f_sw  = 20e3;    %Schaltfrequenz [Hz]

%% Vorbereitungsaufgaben V3
%############################################ (a): Worst-Case Arbetispunkt
%#########################################################################

param.R_load = 15;      %Lastwiderstand [Ohm]
param.V_ls   =  10;      %Eingangsspannung [V]
Boost.real.D_bar = 0.583;  %Tastverh�ltnis


%################################# (b): Linearisiertes State-Space Modell
%#########################################################################
s = tf('s'); %Objekt der Laplace Variable

%Station�rer Zustand:
syms V_C_bar;
syms I_L_bar;

S = solve(-(param.R_L+Boost.real.D_bar*param.R_sw+(1-Boost.real.D_bar)*param.R_D+(1-Boost.real.D_bar)*param.R_C*param.R_load/(param.R_C+param.R_load))*I_L_bar-(1-Boost.real.D_bar)*param.R_load/(param.R_C+param.R_load)*V_C_bar-(1-Boost.real.D_bar)*param.V_D+param.V_ls==0,...
    (-1/(param.R_C+param.R_load)*V_C_bar+(1-Boost.real.D_bar)*param.R_load/(param.R_C+param.R_load)*I_L_bar)==0,I_L_bar,V_C_bar);

Boost.real.V_C_bar = double(S.V_C_bar(1));
Boost.real.I_L_bar = double(S.I_L_bar(1));

clear V_C_bar I_L_bar S

%Linearisiertes Modell Zustandsraumdarstellung:
Boost.real.A = [-1/param.L*(param.R_L+Boost.real.D_bar*param.R_sw+(1-Boost.real.D_bar)*param.R_D+(1-Boost.real.D_bar)*param.R_C*param.R_load/(param.R_C+param.R_load)), -1/param.L*(1-Boost.real.D_bar)*param.R_load/(param.R_C+param.R_load);...
        1/param.C*(1-Boost.real.D_bar)*param.R_load/(param.R_C+param.R_load), -1/param.C/(param.R_C+param.R_load)];
Boost.real.B = [1/param.L*((param.R_D-param.R_sw+param.R_C*param.R_load/(param.R_C+param.R_load))*Boost.real.I_L_bar+(param.R_load/(param.R_C+param.R_load))*Boost.real.V_C_bar+param.V_D);...
        -1/param.C*param.R_load/(param.R_C+param.R_load)*Boost.real.I_L_bar];
Boost.real.C = [1 0; 0 1];
Boost.real.D = [0; 0];

%State-Space Modell:
Boost.real.strecke = ss(Boost.real.A,Boost.real.B,Boost.real.C,Boost.real.D);
Boost.real.strecke = series(Boost.real.strecke(2,1),tf([param.R_C*param.C,1],1));

%Transfer function Modell:
fprintf('�bertragungsfunktion des realen Modells am Abrbeitspunkt D = %.1f (%.2fA , %.2fV):\n',Boost.real.D_bar,Boost.real.I_L_bar,Boost.real.V_C_bar)
display(tf(Boost.real.strecke)) 

figure(1), hold all
opt = bodeoptions;
opt.FreqUnits = 'Hz';
opt.PhaseMatching  = 'On';
opt.Xlim = [10,5e4];
bode(Boost.real.strecke,opt)


%########################################## (c): Totzeit diskrete Regelung
%#########################################################################
% ctr.fb                = 1000;  %Abtastfrequenz des Reglers im Mikrocontroller [Hz]
% ctr.fb              = 5000; 
% ctr.fb              = 20000;
ctr.fb = 10000;
Boost.real.totzeit = 1/2/ctr.fb;  %Totzeit der diskreten Regelung [s]

Gtotzeit = pade(Boost.real.strecke,Boost.real.totzeit);  %�bertragungsfunktion (transfer function Modell) der Pade-Approximation

Boost.real.strecke_totzeit = series(Gtotzeit,Boost.real.strecke);  %Strecke mit Totzeit

%Vergleich Bodeplot mit und ohne Ber�cksichtigung der Diskretisierung
figure(1), hold all
bode(Boost.real.strecke_totzeit,opt)
grid on
legend('Real','Real + Totzeit')

%################################################ (d): Auslegung PI Regler
%#########################################################################
%% Reglung mit PI    
% optss = pidtuneOptions('PhaseMargin',37);
[c,info] = pidtune(Boost.real.strecke_totzeit,'Pi');
c
ctr.kP = c.Kp;     
ctr.kI = c.Ki/c.Kp;


fprintf('Reglerauslegung: kI = %.0f, kP = %.4f\n',ctr.kI,ctr.kP)

ctr.C = tf([ctr.kP ctr.kP*ctr.kI],[1 0]); %�bertragungsfunktion zeitkontinuierlicher Regler

fprintf('�bertragungsfunktion PI-Regler:\n')
display(ctr.C)

%################################ Vergleich offener Kreis der Regelstrecke
%#########################################################################
figure(2), hold all
ctr.G0   =  series(Boost.real.strecke,ctr.C); %�bertragungsfunktion offerner Kreis ohene Totzeit
ctr.G0td =  series(Boost.real.strecke_totzeit,ctr.C);  %�bertragungsfunktion offerner Kreis mit Totzeit
bode(ctr.G0,'--',ctr.G0td,opt)      
grid on
title('Offener Kreis')
legend('Ohne Totzeit','Mit Totzeit')

%############################################## Schlie�en des Regelkreises
%#########################################################################
ctr.F0 = feedback(ctr.G0td,1); %�bertragungsfunktion des geschlossenen Kreises
display(tf(ctr.F0))
%################################# Sprungantwort des geschlossenen Kreises
%#########################################################################
figure(3), hold all
step(ctr.F0)
grid on

figure(4), hold all
bode(ctr.C)      
grid on
title('Regler')

