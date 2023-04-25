function xdot = Boost_ideal(t,x,param,D_pre,D_post)
% Vorbereitsungsaufgabe V3
% Ideales Modell des Hochsetzsteller nach Gl. 2.22 - 2.23
% Defnition der ODE Funktion (odefun) fr die Simulation ber [t,x] = ode45(odefun,tspan,x0)
% Siehe Matlab Dokumentation ode45

%Simulation der Sprungantwort ber zeitabhngigen Duty Cycle
if t>0
    D = D_post; % D(t) fr t > 0  (nach Sprung)
else
    D = D_pre;  % D(t) fr t <= 0 (vor Sprung)
end

%Zustandsraumdarstellung
I_L = x(1);  % Zustand x1 ... Spulenstrom
V_C = x(2);  % Zustand x2 ... Kondensatorspannung

%ODE System:
I_L_dot = (1/param.L)*(-param.R_L*I_L-(1-D)*V_C+param.V_ls); 
V_C_dot = (1/param.C)*((1-D)*I_L-V_C/param.R_load);

xdot = [I_L_dot; V_C_dot];


