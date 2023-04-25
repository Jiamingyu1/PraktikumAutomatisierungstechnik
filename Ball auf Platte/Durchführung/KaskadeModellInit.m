%% Init
clear
clc

%% Modellparameter
g = 9.81;                  % Beschleunigungskonstante [m/s^2]
R = 0.02;                  % Ballradius [m]
m = 0.0027;                % Ballmasse [kg]
Jb = 2/3*m*R^2;            % Trägheitsmoment [kg*m^2]
alphamax = 20/360*2*pi;    % Maximaler Winkel [rad]
alphapmax = 30/360*2*pi;   % Maximale Winkelgeschwindigkeit [rad/s]

%% Anfangszustände
x0 = [0.2 0];              % Anfangsbedingung für die Integratoren
alpha0 = 0;                % Anfangsbedingung für den Integrator

%% Simulationsparameter
Tend = 20;                 % Simulationszeit [s]
Tstep = 0.01;              % Zeitschrittweite [s]

%% Parameter Solltrajektorie
Period = 5;                % Sinusperiodendauer [s]
Ampl = 0.2;                % Sinusamplitude [m]

%% Auslegung P-Regler innerer Motorregelkreis

% P-Regler Parametrierung
% Hier Verstärkung für den P-Regler eintragen
Kalpha = 10;

%% Auslegung PD-Regler für Balldynamik
% Implementieren Sie hier das lineare Ballmodell in Zustandsraumdarstellung



Ab = [0 1;0 0];
Bb = [0; -5/7*g];
Cb = [1 0];
Db = zeros(1);
Sysb = ss(Ab,Bb,Cb,Db);


% PD-Regler Parametrierung
% Legen Sie hier den PD Regler aus
w_c = 3;
[C_c, Info] = pidtune(Sysb,'pd',w_c);
C_c

% Tragen Sie hier die Verstärkungen für den PD-Regler ein
Kp = C_c.Kp;
Kd = C_c.Kd;

% Berechnen Sie hier die Dynamik des geschlossenen Regelkreises

% Simulieren Sie hier den Anfangswertfehler. Nutzen Sie als Anfangswert x0
