%% Lineare Zustandsrueckfuehrung

clc

%% Systemparameter

% Zykluszeit
t_sample = 0.01;

% Kameraparameter
x_koord_max = 189;                              % maximaler Rueckgabewert fur x-Koordinate der Kamera
x_koord_min = -197;                             % minimaler Rueckgabewert fur x-Koordinate der Kamera
y_koord_max = 195;                              % maximaler Rueckgabewert fur y-Koordinate der Kamera
y_koord_min = -195;                             % minimaler Rueckgabewert fur y-Koordinate der Kamera

x_koord_offset = -21;                           % Offset der x-Koordinate der Kamera [Einheit der Kamera]
y_koord_offset = 0;                             % Offset der x-Koordinate der Kamera [Einheit der Kamera]

% Motorparameter
x_sv_max = 14000;                               % maximale Schrittanzahl in x-Richtung [Mikroschritte]
x_sv_min = -14000;                              % minimale Schrittanzahl in x-Richtung [Mikroschritte]
y_sv_max = 14000;                               % maximale Schrittanzahl in y-Richtung [Mikroschritte]
y_sv_min = -14000;                              % minimale Schrittanzahl in y-Richtung [Mikroschritte]

x_sv_m_max = 0.0225;                             % maximale Position in x-Richtung [Meter]
x_sv_m_min = -0.0225;                            % minimale Position in x-Richtung [Meter]
y_sv_m_max = 0.0225;                             % maximale Position in x-Richtung [Meter]
y_sv_m_min = -0.0225;                            % minimale Position in x-Richtung [Meter]

% Ballparameter
m_B = 0.0027;                                   % Ballmasse
R_B = 0.02;                                       % Ballradius
A_B = pi*R_B^2;                                   % Ballquerschnittsflaeche
cw_B = 0.45;                                    % Widerstandsbeiwert
J_B = 2/3*m_B*R_B^2;                              % Ballmassentraegheitsmoment - hohl
%J_B = 2/5*m_B*R;                               % Ballmassentraegheitsmoment - massiv

% Plattenparameter
m_Pl = 2;                                       % Gewicht der Platte
r_Pl = 0.6;                                     % Seitenlaenge der Platte
d_Pl = 0.003;                                   % Dicke der Platte
J_Pl = 1/12*m_Pl*(r_Pl^2+d_Pl^2);               % Traegheitsmoment der Platte

d_ML_x = 0.125;                                 % Abstand: Aufhaenggelenk <=> Motorgelenk
d_ML_y = 0.125;                                 % Abstand: Aufhaenggelenk <=> Motorgelenk
d_MR_x = 0.175;                                 % Abstand: Motorgelenk <=> Plattenende
d_MR_y = 0.175;                                 % Abstand: Motorgelenk <=> Plattenende
d_L_x = 0.295;                                  % Abstand: Plattenende <=> Aufhaenggelenk
d_L_y = 0.295;                                  % Abstand: Plattenende <=> Aufhaenggelenk

alpha_max = asin(x_sv_m_max/d_ML_x);            % maximaler Neigwinkel in alpha [rad]
alpha_min = asin(x_sv_m_min/d_ML_x);            % maximaler Neigwinkel in alpha [rad]
beta_max = asin(y_sv_m_max/d_ML_y);             % maximaler Neigwinkel in beta [rad]
beta_min = asin(y_sv_m_min/d_ML_y);             % maximaler Neigwinkel in beta [rad]

% Umrechnungsfaktoren
e_x_koord_pos = (d_L_x-R_B)/abs(x_koord_max);            % Umrechnung     Kamerakoordinaten => Position (x-Achse) [Meter]
e_x_koord_neg = (d_L_x-R_B)/abs(x_koord_min);            % Umrechnung     Kamerakoordinaten => Position (x-Achse) [Meter]
e_y_koord_pos = (d_L_y-R_B)/abs(y_koord_max);            % Umrechnung     Kamerakoordinaten => Position (y-Achse) [Meter]
e_y_koord_neg = (d_L_y-R_B)/abs(y_koord_min);            % Umrechnung     Kamerakoordinaten => Position (y-Achse) [Meter]

e_x_sv = x_sv_max/alpha_max;                    % Umrechnung    alpha_soll => Mikroschrittanzahl x-Motor
e_y_sv = y_sv_max/beta_max;                     % Umrechnung    beta_soll => Mikroschrittanzahl y-Motor

e_rad_x_sv = e_x_sv/40;                % Umrechnung    Winkelgeschwindigkeit [rad] => Schrittfrequenz x-Motor [MS/25ms]
e_rad_y_sv = e_y_sv/40;                 % Umrechnung    Winkelgeschwindigkeit [rad] => Schrittfrequenz y-Motor [MS/25ms]

% Stellgroessenbeschraenkung
soll_max_min = 1000;                            % maximale Geschwindigkeit
alpha_stell_max = soll_max_min;
alpha_stell_min = -soll_max_min;
beta_stell_max = soll_max_min;
beta_stell_min = -soll_max_min;

d_alpha_max = alpha_stell_max/e_rad_x_sv;
d_alpha_min = alpha_stell_min/e_rad_x_sv;
d_beta_max = beta_stell_max/e_rad_y_sv;
d_beta_min = beta_stell_min/e_rad_y_sv;

k_alphamax = 0.7;                               % maximaler Plattenwinkelfaktor von 14000
k_betamax = 0.7;                               % maximaler Plattenwinkelfaktor von 14000

% Tiefpass fuer Motorstellgroesse
omega_B = 40;

% Physikalische Konstanten
rho = 1.2041;                                   % Luftdichte bei 20 Grad C
g = 9.81;                                       % Erdbeschleunigung

% Anfangsbedingungen für Beobachter
x_0 = 0.2;                                        % Anfangswert x-Position
d_x_0 = 0;                                      % Anfangswert Geschwindigkeit in x-Richtung
alpha_0 = 0;                                    % Anfangswert Neigung in x-Richtung
y_0 = 0;                                        % Anfangswert y-Position
d_y_0 = 0;                                      % Anfangswert Geschwindigkeit in y-Richtung
beta_0 = 0;                                     % Anfangswert Neigung in y-Richtung

x0_obs = [x_0 d_x_0 alpha_0  y_0 d_y_0 beta_0 ];

%% System

% ZUSTANDSLINEARISIERUNG UM DIE RUHELAGE 0

syms x1 x2 x3 x4 x5 x6 u1 u2
f = [ x2;
      -g/(1+J_B/(R_B^2*m_B))*sin(x3);
      u1;
      x5;
      -g/(1+J_B/(R_B^2*m_B))*sin(x6);
      u2 ];
x = [ x1 x2 x3 x4 x5 x6];
u = [u1 u2];

A_sym = jacobian( f, x);
B_sym = jacobian( f, u);

A = double(subs( A_sym , {x1 x2 x3 x4 x5 x6 u1 u2}, { 0 0 0 0 0 0 0 0 }));
B = double(subs( B_sym , {x1 x2 x3 x4 x5 x6 u1 u2}, { 0 0 0 0 0 0 0 0 }));
C = [1 0 0 0 0 0
     0 0 0 1 0 0];
C_mess = [1 0 0 0 0 0
          0 0 1 0 0 0
          0 0 0 1 0 0
          0 0 0 0 0 1 ];
D = zeros(2,2);
D_mess = zeros(4,2);
sys = ss(A,B,C_mess,D_mess);

clear x x1 x2 x3 x4 x5 x6 u u1 u2

%% Regler - Polvorgabe

% K = place(A,B,3*[-0.98,-0.99,-1.0,-1.01,-1.02,-1.03 ]');

%% Beobachter

L_red = place(A',C',1*[-3.0 -3.1 -3.2 -3.3 -3.4 -3.5])';
% L_mess = place(A',C_mess',5*[-3.0 -3.1 -3.2 -3.3 -3.4 -3.5])';

