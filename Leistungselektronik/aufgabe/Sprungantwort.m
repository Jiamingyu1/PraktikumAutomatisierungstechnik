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

% Arbeitspunkt
param.R_load = 47;  %Lastwiderstand [Ohm]
param.V_ls   = 15;  %Eingangsspannung [V]


%% Vorbereitungsaufgaben V3
%#########################################################################

% Bedingungen
D_pre  = 0.30;  %Tastverh�ltnis vor Sprung
D_post = 0.50;  %Tastverh�ltnis nach Sprung

%########################################################## Ideales Modell
%#########################################################################
Boost.ideal.x0 = [param.V_ls / ((1 - D_pre)^2 * param.R_load); param.V_ls / (1 - D_pre)];  %Anfangswert

%Simulation:
options = odeset('RelTol',1e-8);  %ode45 Optionen
tspan   = [-0.03 0.07];           %Simulationszeit [s]
[Boost.ideal.t,Boost.ideal.x] = ode45(@(t,x) Boost_ideal(t,x,param,D_pre,D_post),tspan,Boost.ideal.x0,options);

%########################################################### Reales Modell
%#########################################################################
%Station�re L�sung:
syms V_C_bar;
syms I_L_bar;

S = solve(-(param.R_L+D_pre*param.R_sw+(1-D_pre)*param.R_D+(1-D_pre)*param.R_C*param.R_load/(param.R_C+param.R_load))*I_L_bar-(1-D_pre)*param.R_load/(param.R_C+param.R_load)*V_C_bar-(1-D_pre)*param.V_D+param.V_ls==0,...
    (-1/(param.R_C+param.R_load)*V_C_bar+(1-D_pre)*param.R_load/(param.R_C+param.R_load)*I_L_bar)==0,I_L_bar,V_C_bar);

Boost.real.V_C_bar = double(S.V_C_bar(1));
Boost.real.I_L_bar = double(S.I_L_bar(1));

clear S V_C_bar I_L_bar

Boost.real.x0 = [Boost.real.I_L_bar; Boost.real.V_C_bar];  %Anfangswert

%Simulation:
options = odeset('RelTol',1e-8);  %ode45 Optionen
tspan   = [-0.03 0.07];           %Simulationszeit [s]
[Boost.real.t,Boost.real.x] = ode45(@(t,x) Boost_real(t,x,param,D_pre,D_post),tspan,Boost.real.x0,options);

%#################################################################### PLOT
%#########################################################################
figure('name','Vergleich der Modelle')

ax(1) = subplot(2,1,1); hold all
title('I_L')
plot(Boost.ideal.t,Boost.ideal.x(:,1))
plot(Boost.real.t,Boost.real.x(:,1))
ylabel('I_L [A]')
grid on
legend('Ideales Modell','Reales Modell')

ax(2) = subplot(2,1,2); hold all
title('V_{out}')
plot(Boost.ideal.t,Boost.ideal.x(:,2))
plot(Boost.real.t,Boost.real.x(:,2))
ylabel('V_{out} [A]')
xlabel('t [s]')
grid on

linkaxes(ax,'x')
