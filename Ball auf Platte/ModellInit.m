%% Laden der Messung
load vergleichswerte;
Zeit = vergleichswerte(1,:)';
Ballposition = vergleichswerte(2,:)';
Ballgeschwindigkeit = vergleichswerte(3,:)';
Winkel = vergleichswerte(4,:)';
Winkelgeschwindigkeit = vergleichswerte(5,:)';

%% Modell- und Simulationsparameter 
g = 9.81;                  % Beschleunigungskonstante [m/s^2]
R = 0.015;                 % Ballradius [m]
rho = 7850;                % Dichte Stahl [kg/m^3]
m = 4/3*pi*R^3*rho;        % Ballmasse [kg]
Jb = 2/5*m*R^2;            % Traegheitsmoment [kg*m^2]
Tend = 2.4;                % Endzeit [s]

%% Anfangszustand 
x0 = [0 0 0];

%% Simulationsparameter

Tstep = 0.01;
Tend = 2.5;