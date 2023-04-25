%% Init
clc

%% Modellparameter
g = 9.81;                  % Beschleunigungskonstante [m/s^2]
R = 0.02;                  % Ballradius [m]
m = 0.0027;                % Ballmasse [kg]
Jb = 2/3*m*R^2;            % Tr�gheitsmoment [kg*m^2]
alphamax = 20/360*2*pi;    % Maximaler Winkel [rad]
alphapmax = 30/360*2*pi;   % Maximale Winkelgeschwindigkeit [rad/s]

%% Anfangszust�nde
x0 = [0.2 0];              % Anfangsbedingung f�r die Integratoren
alpha0 = 0;                % Anfangsbedingung f�r den Integrator

%% Simulationsparameter
Tend = 20;                 % Simulationszeit [s]

%% Parameter Solltrajektorie
Period = 5;                % Sinusperiodendauer [s]
Ampl = 0.2;                % Sinusamplitude [m]

%% Auslegung P-Regler innerer Motorregelkreis

% P-Regler Parametrierung
% Hier Verst�rkung f�r den P-Regler eintragen
Kalpha = 0;

%% Auslegung PD-Regler f�r Balldynamik
% Implementieren Sie hier das lineare Ballmodell in Zustandsraumdarstellung
Ab = 0;
Bb = 0;
Cb = 0;
Db = 0;

Sysb = 0;

% PD-Regler Parametrierung
% Legen Sie hier den PD Regler aus


% Tragen Sie hier die Verst�rkungen f�r den PD-Regler ein
Kp = 0;
Kd = 0;

% Berechnen Sie hier die Dynamik des geschlossenen Regelkreises

% Simulieren Sie hier den Anfangswertfehler. Nutzen Sie als Anfangswert x0
