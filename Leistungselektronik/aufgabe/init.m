%% Initialisierung
% Hochsatzsteller:
param.L     = 150e-6;        %Induktivität [L]
param.R_L   = 0.17;          %Serienwiderstand Induktivität [Ohm]
param.C     = 300e-6;        %Ausgangskondensator [C]
param.R_C   = 0.36;          %Serienwiderstand Kondensator [Ohm]
param.R_sw  = 0.21;          %Drain-Source Widerstand MOSFET [Ohm]
param.R_D   = 0.01;          %Diode Leitwiderstand [Ohm]
param.V_D   = 0.80;          %Diode Vorwärtsspannung [V] 

% Strommessung:
param.R_shunt     = 50e-3;   %Widerstände R6,R8,R18 [Ohm]
param.R_opamp_in  = 2e3;     %Widerstände R12,R16 [Ohm]
param.R_opamp_fbk = 20e3;    %Widerstände R10,R17 [Ohm]
param.C12         = 100e-12; %Kapazitäten C1,C2 [C]
param.Vref        = 3.3;     %Referenzspannung [V]

% Arbeitspunkt
param.V_ls  = 12;            %Eingangsspannung [V]
param.R_load= 47;            %Lastwiderstand [Ohm]
Boost.D_bar = 0.5;           %Duty Cycle

%% Initialisierung Stationärer Zustand
syms V_C_bar;
syms I_L_bar;

S = solve(-(param.R_L+Boost.D_bar*param.R_sw+(1-Boost.D_bar)*param.R_D+(1-Boost.D_bar)*param.R_C*param.R_load/(param.R_C+param.R_load))*I_L_bar-(1-Boost.D_bar)*param.R_load/(param.R_C+param.R_load)*V_C_bar-(1-Boost.D_bar)*param.V_D+param.V_ls==0,...
    (-1/(param.R_C+param.R_load)*V_C_bar+(1-Boost.D_bar)*param.R_load/(param.R_C+param.R_load)*I_L_bar)==0,I_L_bar,V_C_bar);

Boost.V_C_bar = double(S.V_C_bar(1));  %Kondensator Spannung
Boost.I_L_bar = double(S.I_L_bar(1));  %Spulenstrom

clear S V_C_bar I_L_bar

fprintf('######## Initialisierung: \n')
fprintf('%-25s %.2f V\n','Eingangsspannung:',param.V_ls)
fprintf('%-25s %.2f Ohm\n','Lastwiderstand:',param.R_load)
fprintf('%-25s %d %%\n','Duty Cycle:',Boost.D_bar*100)
fprintf('%-25s %.2f V\n','Ausgangspannung V_C:',Boost.V_C_bar)
fprintf('%-25s %.2f A\n','Spulenstrom I_L:',Boost.I_L_bar)

%% Praktikumsaufgabe P1
%#################################################### (a) Schaltsignal PWM
%#########################################################################
param.f_sw   = 20000;  %Schaltfrequenz [Hz]

%##################################################### (b) Spannungsteiler
%#########################################################################
param.C9     = 10e-9;  %Kapazität C9 [C]
param.R_1314 = 2*10^6;    %Widerstand R13+R14 des Spannungsteilers [Ohm]
param.R15    = 13*10^3;    %Widerstand R15 des Spannungsteilers [Ohm] = 13e3

% Skalierung
%#############
%Spannungsmessung
scale.Vout.offset = 0;  %Skalierung Offset
scale.Vout.factor = (param.R_1314+param.R15)/param.R15;  %Skalierung Faktor
%Strommessung
scale.I_L.offset = 3.3;  %Skalierung Offset = param.Vref
scale.I_L.factor = 5.96;  %Skalierung Faktor

%% Praktikumsaufgabe P2
%################################################ (a) Festkomma-Arithmetik
%#########################################################################
ctr.q = 19;                 %Q-Wert Datentyp
ctr.qresolution = 0.000001907;       %Genauigkeit Q-Wert
ctr.qmax = 4095.999998093;              %maximal darstellbarer Wert
ctr.qmin = -4096;              %minmial darstellbarer Wert

%########################################### (b) Diskreter Regler Taktrate
%#########################################################################
ctr.fb = 10e3; %Reglerfrequenz [Hz]

%% Praktikumsaufgabe P4
%################################################## Implementierung Regler
%#########################################################################
ctr.kI = 2089;   %Integrator Gain
ctr.kP = 1.952e-4;   %Proportional Gain
