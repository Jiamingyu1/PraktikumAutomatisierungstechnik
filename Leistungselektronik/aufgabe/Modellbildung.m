clc, clearvars, close all
%% Initialisierung

% Parameter
param.L     = 150e-6;   %Induktivität [L]
param.R_L   = 0.17;     %Serienwiderstand Induktivität [Ohm]
param.C     = 300e-6;   %Ausgangskondensator [C]
param.R_C   = 0.36;     %Serienwiderstand Kondensator [Ohm]
param.R_sw  = 0.21;     %Drain-Source Widerstand MOSFET [Ohm]
param.R_D   = 0.01;     %Diode Leitwiderstand [Ohm]
param.V_D   = 0.80;     %Diode Vorwärtsspannung [V] 
param.f_sw  = 20e3;     %Schaltfrequenz [Hz]

% Arbeitspunkt
param.R_load = 47;  %Lastwiderstand [Ohm]
param.V_ls   = 12;  %Eingangsspannung [V]

%% Vorbereitungsaufgaben V1
% Idealisiertes Modell des Hochsatzstellers
%################################################ (c): Stationärer Zustand
%#########################################################################
Boost.ideal.D_bar = 0.4;    % Tastverhältnis
Boost.ideal.V_C_bar = param.V_ls / (1 - Boost.ideal.D_bar);  % Stationäre Kondensatorspannung [V]
Boost.ideal.I_L_bar = param.V_ls / ((1 - Boost.ideal.D_bar)^2 * param.R_load);  % Stationärer Spulenstrom [A]

%############### (d): Modell in Zustandsraumdarstellung mit x = [I_L, V_C]
%#########################################################################
Boost.ideal.A = [-param.R_L/param.L , (Boost.ideal.D_bar - 1)/param.L; ...
                (1 - Boost.ideal.D_bar)/param.C , -1/(param.C * param.R_load)]; %Linearisierte Systemmatrix
Boost.ideal.B = [Boost.ideal.V_C_bar/param.L ; -Boost.ideal.I_L_bar/param.C]; %Linearisierte Eingangsmatrix
Boost.ideal.C = [0 1]; %Linearisierte Ausgangsmatrix
Boost.ideal.D = 0; %Linearisierte Druchgriff

Boost.ideal.strecke = ss(Boost.ideal.A,Boost.ideal.B,Boost.ideal.C,Boost.ideal.D);  %state-space Modell (Siehe doc ss)

%######################### (e): Modell als Übertragungsfunktion (ohne R_L)
%#########################################################################
Boost.ideal.G = tf([-(param.L * Boost.ideal.I_L_bar) , ((1 - Boost.ideal.D_bar) * Boost.ideal.V_C_bar)], ...
                   [(param.C * param.L) , (param.L/param.R_load) , (1 - Boost.ideal.D_bar)^2]);  %transfer function modell (siehe doc tf)

%################################ (f) Vergleich der Übertragungsfunktionen
%#########################################################################
opt = bodeoptions;
opt.FreqUnits = 'Hz';
opt.PhaseMatching = 'on';

figure('name','Führungsübertragungsfunkion des idealen Wandlers'), hold all
bode(Boost.ideal.strecke, opt)
bode(Boost.ideal.G, opt)
legend('Mit R_L','Ohne R_L')
grid on

%%
%####################### (j): Einfluss des Arbeitspunkt auf ideales Modell
%#########################################################################
% Nomineller Arbeitspunkt: 
param.R_load = 25;        %Lastwiderstand [Ohm]
param.V_ls = 12;          %Eingangsspannung [V]
Boost.ideal.D_bar = 0.4;  %Tastverhältniss

Boost.ideal.V_C_bar = param.V_ls / (1 - Boost.ideal.D_bar);
Boost.ideal.I_L_bar = param.V_ls / ((1 - Boost.ideal.D_bar)^2 * param.R_load);

Boost.ideal.A = [-param.R_L/param.L , (Boost.ideal.D_bar - 1)/param.L; ...
                (1 - Boost.ideal.D_bar)/param.C , -1/(param.C * param.R_load)]; %Linearisierte Systemmatrix
Boost.ideal.B = [Boost.ideal.V_C_bar/param.L ; -Boost.ideal.I_L_bar/param.C]; %Linearisierte Eingangsmatrix
Boost.ideal.C = [0 1]; %Linearisierte Ausgangsmatrix
Boost.ideal.D = 0; %Linearisierte Druchgriff
Boost.ideal.strecke = ss(Boost.ideal.A,Boost.ideal.B,Boost.ideal.C,Boost.ideal.D);

figure('name','Einfluss des Arbeitspunkt auf Führungsübertragungsfunktion'), hold all
bode(Boost.ideal.strecke,opt)
grid on

% Worst-Case Arbeitspunkt von 10V auf 24V D=0.583
param.R_load = 15;       %Lastwiderstand [Ohm]
param.V_ls = 10;         %Eingangsspannung [V] 
Boost.ideal.D_bar = 0.583;  %Tastverhältniss

Boost.ideal.V_C_bar = param.V_ls / (1 - Boost.ideal.D_bar);
Boost.ideal.I_L_bar = param.V_ls / ((1 - Boost.ideal.D_bar)^2 * param.R_load);

Boost.ideal.A = [-param.R_L/param.L , (Boost.ideal.D_bar - 1)/param.L; ...
                (1 - Boost.ideal.D_bar)/param.C , -1/(param.C * param.R_load)]; %Linearisierte Systemmatrix
Boost.ideal.B = [Boost.ideal.V_C_bar/param.L ; -Boost.ideal.I_L_bar/param.C]; %Linearisierte Eingangsmatrix
Boost.ideal.C = [0 1]; %Linearisierte Ausgangsmatrix
Boost.ideal.D = 0; %Linearisierte Druchgriff
Boost.ideal.strecke = ss(Boost.ideal.A,Boost.ideal.B,Boost.ideal.C,Boost.ideal.D);

bode(Boost.ideal.strecke,opt)

legend('Nomineller Arbeitspunkt','Worst-Case Arbeitspunkt')
grid on

%% Vorbereitungsaufgaben V2
% Reales Modell des Hochsatzstellers
%#########################################################################

% Stationärer Zustand
Boost.real.D_bar = Boost.ideal.D_bar;

syms V_C_bar;
syms I_L_bar;

S = solve(-(param.R_L+Boost.real.D_bar*param.R_sw+(1-Boost.real.D_bar)*param.R_D+(1-Boost.real.D_bar)*param.R_C*param.R_load/(param.R_C+param.R_load))*I_L_bar-(1-Boost.real.D_bar)*param.R_load/(param.R_C+param.R_load)*V_C_bar-(1-Boost.real.D_bar)*param.V_D+param.V_ls==0,...
    (-1/(param.R_C+param.R_load)*V_C_bar+(1-Boost.real.D_bar)*param.R_load/(param.R_C+param.R_load)*I_L_bar)==0,I_L_bar,V_C_bar);

Boost.real.V_C_bar = double(S.V_C_bar(1));
Boost.real.I_L_bar = double(S.I_L_bar(1));

clear S V_C_bar I_L_bar

%################################################# (b) Zustandsraum-Modell
%#########################################################################
Boost.real.A = [-1/param.L*(param.R_L+Boost.real.D_bar*param.R_sw+(1-Boost.real.D_bar)*param.R_D+(1-Boost.real.D_bar)*param.R_C*param.R_load/(param.R_C+param.R_load)), -1/param.L*(1-Boost.real.D_bar)*param.R_load/(param.R_C+param.R_load);...
        1/param.C*(1-Boost.real.D_bar)*param.R_load/(param.R_C+param.R_load), -1/param.C/(param.R_C+param.R_load)];
Boost.real.B = [1/param.L*((param.R_D-param.R_sw+param.R_C*param.R_load/(param.R_C+param.R_load))*Boost.real.I_L_bar+(param.R_load/(param.R_C+param.R_load))*Boost.real.V_C_bar+param.V_D);...
        -1/param.C*param.R_load/(param.R_C+param.R_load)*Boost.real.I_L_bar];
Boost.real.C = [1 0; 0 1];
Boost.real.D = [0; 0];

Boost.real.strecke = ss(Boost.real.A,Boost.real.B,Boost.real.C,Boost.real.D);
Boost.real.strecke = series(tf([param.R_C*param.C,1],1),Boost.real.strecke(2,1));

% Vergleich der Übertragungsfunktionen (real und ideal)
figure('name','Vergleich des idealen und realen Wandlers'), hold all
bode(Boost.real.strecke,opt)
bode(Boost.ideal.strecke,opt)
legend('Real','Ideal')
grid on
