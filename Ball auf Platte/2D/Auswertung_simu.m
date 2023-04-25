clc
% close all

%% Reale Messwerte

% Zeit und Stellgrößen

time_real = stell_simu.time;                         %  Zeit
time_real_0 = time_real;
i0 = 1;
% Messdaten

x_real = mess_simu.signals.values(i0:end,1);              % Postion Ball
y_real = mess_simu.signals.values(i0:end,3);
alpha_real = mess_simu.signals.values(i0:end,2);          % Plattenwinkel
beta_real = mess_simu.signals.values(i0:end,4);
stellx_real = stell_simu.signals.values(i0:end,1);        % Reale Stellgroessen
stelly_real = stell_simu.signals.values(i0:end,2);

% Sollgrößen
x_soll = soll_simu.signals.values(i0:end,1);              % Postion Ball
y_soll = soll_simu.signals.values(i0:end,2);
alpha_soll = soll_simu.signals.values(i0:end,3);          % Plattenwinkel
beta_soll = soll_simu.signals.values(i0:end,4);


%% Plotten
figure
subplot 221
plot(time_real_0,x_soll,time_real_0,x_real);
legend('Soll','Ist');
    title('x-Verlauf');
    xlabel('Zeit in Sekunden');
    ylabel('Ballposition x in Meter');
subplot 222
plot(time_real_0,y_soll,time_real_0,y_real);
legend('Soll','Ist');
    title('y-Verlauf');
    xlabel('Zeit in Sekunden');
    ylabel('Ballposition y in Meter');
subplot 223
plot(time_real_0,180/pi*alpha_soll,time_real_0,180/pi*alpha_real);
legend('Soll','Ist');
    title('Plattenwinkel');
    xlabel('Zeit in Sekunden');
    ylabel('alpha in Grad');
subplot 224
plot(time_real_0,180/pi*beta_soll,time_real_0,180/pi*beta_real);
legend('Soll','Ist');
    title('Plattenwinkel');
    xlabel('Zeit in Sekunden');
    ylabel('alpha in Grad');
    
figure
plot(x_soll,y_soll,x_real,y_real)
legend('Soll','Ist');
    title('Trajektorie');
    xlabel('x in Meter');
    ylabel('y in Meter');
axis equal
