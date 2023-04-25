%% TRUNC SPECIFIC PARAMETERS (GENERATED)
% Kinematik (berechnete Parameter), die anhand der spezifischen Parameter
% berechnet werden.

%% Berechnung der Radien der Seilführungen r_ms und der Balgsymmetrieachsen r_mb

BHA.Trunk.r_ms_20 = BHA.Trunk.r_ms_10 - sin(BHA.Trunk.theta_i(1)) * ( BHA.Trunk.ls_ik_init(1) + BHA.Trunk.ls_ih(1) ) - sin(BHA.Trunk.theta_i(2)) * BHA.Trunk.ls_ib(2);
BHA.Trunk.r_ms_30 = BHA.Trunk.r_ms_20 - sin(BHA.Trunk.theta_i(2)) * ( BHA.Trunk.ls_ik_init(2) + BHA.Trunk.ls_ih(2) ) - sin(BHA.Trunk.theta_i(3)) * BHA.Trunk.ls_ib(3);
BHA.Trunk.r_mb_20 = BHA.Trunk.r_mb_10 - sin(BHA.Trunk.beta_i(1))  * ( BHA.Trunk.ls_ik_init(1) + BHA.Trunk.ls_ih(1) ) - sin(BHA.Trunk.beta_i(2))  * BHA.Trunk.ls_ib(2);
BHA.Trunk.r_mb_30 = BHA.Trunk.r_mb_20 - sin(BHA.Trunk.beta_i(2))  * ( BHA.Trunk.ls_ik_init(2) + BHA.Trunk.ls_ih(2) ) - sin(BHA.Trunk.beta_i(3))  * BHA.Trunk.ls_ib(3);

% früher: BHA.Kin.s_i0 / s_im (teilweise falsch dokumentiert als a_i0/a_im)
BHA.Trunk.r_ms_i0 = [ BHA.Trunk.r_ms_10; BHA.Trunk.r_ms_20; BHA.Trunk.r_ms_30 ]; 		% [m] Radius der Seilführung am Ende des Sektionsfußes   (von Segment j=0 pro Sektion)
BHA.Trunk.r_ms_im = BHA.Trunk.r_ms_i0 - sin(BHA.Trunk.theta_i).*BHA.Trunk.ls_ik_init; 	% [m] Radius der Seilführung am Anfang des Sektionskopfs (von Segment j=m pro Sektion)
BHA.Trunk.r_ms_i  = ( BHA.Trunk.r_ms_i0 + BHA.Trunk.r_ms_im )/2;						% [m] Mittlerer Radius der Seilführung
% früher: BHA.Kin.a_i0 / a_im (teilweise falsch dokumentiert als s_i0/s_im)
BHA.Trunk.r_mb_i0 = [ BHA.Trunk.r_mb_10; BHA.Trunk.r_mb_20; BHA.Trunk.r_mb_30 ]; 		% [m] Radius der Balgsymmetrieachsen am Ende des Sektionsfußes  (von Segment j=0 pro Sektion)
BHA.Trunk.r_mb_im = BHA.Trunk.r_mb_i0 - sin(BHA.Trunk.beta_i).*BHA.Trunk.ls_ik_init;	% [m] Radius der Balgsymmetrieachsen am Anfang des Sektionskops (von Segment j=m pro Sektion)
BHA.Trunk.r_mb_i  = ( BHA.Trunk.r_mb_i0 + BHA.Trunk.r_mb_im )/2;						% [m] Mittlerer Radius der Balgsymmetrielinie

%% Skalare Parameter entfernen, die bereits vektoriell hinterlegt sind

BHA.Trunk = rmfield(BHA.Trunk,'r_ms_10');
BHA.Trunk = rmfield(BHA.Trunk,'r_ms_20');
BHA.Trunk = rmfield(BHA.Trunk,'r_ms_30');

BHA.Trunk = rmfield(BHA.Trunk,'r_mb_10');
BHA.Trunk = rmfield(BHA.Trunk,'r_mb_20');
BHA.Trunk = rmfield(BHA.Trunk,'r_mb_30');


%% Kinematikparameter für Variable Curvature Modellierung

for ii=1:length(BHA.Trunk.vc.num_segm)
	BHA.Trunk.vc.r_ms_ij{ii,1} = [	BHA.Trunk.r_ms_i0(ii),...
									BHA.Trunk.r_ms_i0(ii)*ones(1,BHA.Trunk.vc.num_segm(ii)+1) + ((BHA.Trunk.r_ms_im(ii)-BHA.Trunk.r_ms_i0(ii))/BHA.Trunk.vc.num_segm(ii)) * (0:1:BHA.Trunk.vc.num_segm(ii)),...
									BHA.Trunk.r_ms_im(ii)];								% [m] Radius der Seilführung von Segment j der Sektion i
	BHA.Trunk.vc.r_mb_ij{ii,1} = [	BHA.Trunk.r_mb_i0(ii),...
									BHA.Trunk.r_mb_i0(ii)*ones(1,BHA.Trunk.vc.num_segm(ii)+1) + ((BHA.Trunk.r_mb_im(ii)-BHA.Trunk.r_mb_i0(ii))/BHA.Trunk.vc.num_segm(ii)) * (0:1:BHA.Trunk.vc.num_segm(ii)),...
									BHA.Trunk.r_mb_im(ii)];								% [m] Radius der Balgsymmetrieachse von Segment j der Sektion i
end   
clear ii;
