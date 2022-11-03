%% Ciclo Joule "base"

close all; clear; clc;

%% Ciclo termodinamico ideale
% Dati

% Refprop function fluid
%refprop_Dir = "/home/daniele/.wine/drive_c/Program\ Files/REFPROP/mixtures/";
 %fluid = refprop_Dir+"air.mix";

p(1) = 1; %bar
beta = 15;
T(1) = 298; % K 25°C
T(3) = 1550; % K 1227 °C

k_a = 1.4; % Gas biatomico
lambda = (k_a-1)/k_a;

cp = 1.10; %kJ/kgK
R = 0.287; %kJ/kgK

%% Punto 1

%refpropm = @py.CoolProp.CoolProp.PropsSI;

s(1) = refpropm('S','T',T(1), 'P',p(1)*100, 'AIR.MIX')*1e-3;



%s(1) = 6.86;
%% Punto 2
p(2) = beta*p(1);
T(2) = T(1)*beta^lambda; % Isoentropica
% Se ci fosse il rendimento politropico di compressione si avrebbe
% lambda/eta_comp
s(2) = s(1);

%% Punto 3
p(3) = p(2);
s(3) = s(2) + cp*log(T(3)/T(2))-R*log(p(3)/p(2));

%% Punto 4
p(4)=p(1);
T(4) = T(3)/(beta^lambda); %Oppure beta^(lambda*eta_espansione)
s(4) = s(3);

%% Lavoro di compressione ed espansione ideale
lcId = cp*(T(2)-T(1));
ltId = cp*(T(3)-T(4));
luId = ltId-lcId; % lavoro utile
qIn = cp*(T(3)-T(2));
etaTgId = luId/qIn;

disp(etaTgId);


%% Grafici
close all;
figure('name','Ciclo Termodinamico');
plot(s,T, 'o', 'markerfacecolor','k','markeredgecolor','k','markersize',5);
xlabel('s [kJ/kgK]','fontsize',16,'fontweight','bold');
ylabel('T [K]','fontsize',16,'fontweight','bold');
grid on;

hold on;
xlim([s(1)-0.2 s(4)+0.22]);
line(s(1:2),T(1:2),'linewidth',2,'color','k');
line(s(3:4),T(3:4),'linewidth',2,'color','k');

s23Plot = linspace(s(2),s(3),100);
s14Plot = linspace(s(1),s(4),100); %Sono identici in questo caso

T23Plot = T(2)*exp((s23Plot-s(2))/cp);

T34Plot = T(1)*exp((s14Plot-s(1))/cp);

plot(s23Plot,T23Plot,'linewidth',2,'color','k');
plot(s14Plot,T34Plot,'linewidth',2,'color','k');

%% Ciclo reale

% Rendimenti
etaC = 0.8;  % L_ideale/L_reale = (T2-T1)/(T2r-T1)
etaT = 0.9;  % L_reale/L_ideale = (T3r - T4)/(T3 - T4)

Tr=T;
Tr(2) = T(1)+(T(2)-T(1))/etaC;
Tr(4) = T(3)-etaT*(T(3)-T(4));

sr = s;
sr(2) = s(2)+cp*log(Tr(2)/T(2));
sr(4) = s(1)+cp*log(Tr(4)/T(1));

plot(sr,Tr, '*', 'markerfacecolor','r','markeredgecolor','r','markersize',6);

LcRe = cp*Tr(2)-T(1);
LtRe = cp*T(3)-Tr(4);
LuRe = LtRe-LcRe;
qInRe = cp*(T(3)-Tr(2));
etaTGRe = LuRe/qInRe;


