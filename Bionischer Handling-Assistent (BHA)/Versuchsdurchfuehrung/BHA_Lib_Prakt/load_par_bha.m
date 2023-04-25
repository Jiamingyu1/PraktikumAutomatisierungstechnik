load par_bha

%% Parameterfix
BHA.Trunk.ls_ib        = [ 0.0180;  0.0040; 0.0040 ];
BHA.Trunk.ls_ik_init   = [ 0.1860;	0.1840;	0.1810 ];			% [m]   Inertiallänge des Aktors (gemessene Seillänge) einer Sektion in unbedrucktem Zustand (alterungsbeding verschoben von neutraler Länge)
BHA.Trunk.theta_i      = [3;    3;    3]*pi/180;                % [rad] Winkel der Verjüngung des Aktorelements
BHA.Trunk.beta_i       = [3;    3;    3]*pi/180;                % [rad] Winkel der Verjüngung der Aktorymmetrieachse

BHA.Trunk.r_ms_10 = BHA.Trunk.r_ms_i0(1);
BHA.Trunk.r_mb_10 = BHA.Trunk.r_mb_i0(1);

bha_ini_parameters_trunk_generate_kinematic_parameters

BHA.Base.initial_translation	= [0.693; 0; 1.573];

%% Filterfix & Stepsizefix

CTRL.Measurement.f_filt_pressure = 24;
%CTRL.Valve.tA = 0.004;
CTRL.TCP.tA = 0.02;

%% Reglerfix

% Positions Regelung des TCP
CTRL.TCP.dx_max  = 0.10; %[m/s]
CTRL.TCP.dy_max  = 0.10; %[m/s]
CTRL.TCP.dz_max  = 0.07; %[m/s]

CTRL.TCP.d_theta_x_max  = 15*pi/180; %[rad/s]
CTRL.TCP.d_theta_y_max  = 15*pi/180; %[rad/s]

if 0
    CTRL.TCP.ell_ik_min    = BHA.Trunk.ls_ik_init + 0.010*ones(3,1);    % Original (alt, konservativ)
    CTRL.TCP.ell_ik_max    = BHA.Trunk.ls_ik_init + 0.070*ones(3,1);
else
    CTRL.TCP.ell_ik_min    = BHA.Trunk.ls_ik_min;                       % Angepasst, neu
    CTRL.TCP.ell_ik_max    = BHA.Trunk.ls_ik_max;
end