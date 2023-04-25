% PSI_PARAM(B)
% Berechnet die Parameter der approximierten Durchflussfunktion \Psi basierend
% auf dem kritischen Druckverhältnis B
function [a1,a2,c0] = psi_param(b)
    %#codegen
    a1  = -0.2*b.^2 - 0.06*b + 1.21;
    a2  = -0.26*b + 1.23;
    c0  = -0.22*b + 1.19;
	
	if nargout < 1
		q = linspace(0,1);
		q2 = linspace(b,1);
		figure;clf;plot(q,a1*(1-q)./(c0-q),q,a2*(1-q)./(c0-q),q2,sqrt(1-((q2-b)./(1-b)).^2));
	end
end