% ciclo_combinato_Ts.m
% Piano ts vapore ciclo combinato
close all; clear; clc;

%Ciclo combinato a vapore

%Exergia è energia di prima specie
%Temperatura tipica di una fiamma di idrogeno: 2400K
%La potenza della turbina a gas è solitamente doppia rispetto a quella 
%a vapore.
%I due surriscaldatori a pressioni diverse hanno temperature massime
%identiche, dunque il surriscaldatore di media pressione viene posto
%immediatamente dopo

%Fattore di recupero sigma = (q/q_TEORICA)
fluid = 'water';
pAP = 122.45; %bar
pMP = 35.17;
pBP = 5.8;

p = [pBP,pMP,pAP]*100; %KPa

npoints = 100;

Tm = 41.79; %C

pco = refpropm('P','T',Tm(1)+273.15,'Q',0.5,fluid)/100; %Pressione a titolo 0.5 

% Assegnazione dimensioni p
Tl = p;
h1 = p;
s  = p;
hv = p;

for i = 1 : length(p)
    %Liquido saturo
    [Tl(i), h1(i), s(i)] = refpropm('THS','P',p(i),'Q',0,fluid);

    %Vapore saturo secco
    hv(i) = refpropm('H','P',p(i),'Q',1,fluid)*1e-3;
end
Tl = Tl-273.15;
h1 = h1*1e-3;
s = s*1e-3;
%Vapore surriscaldato

TvAP=563.54; %°C     Temp max AP     p12
TvfMP=372.05; %°C    Temp fredda MP  p8'
TvMP=563.11; %°C     Temp max MP     p8
TvBP=245; %°C        Temp vapore BP  p4


Tv = [TvBP,TvMP,TvAP];

sv = Tv;

for i = 1: length(Tv)
    sv(i) = refpropm('S','T',Tv(i)+273.15,'P',p(i),fluid)*1e-3;
end

%% Piano T-s

Tmin = 15; %C
Tcrit = refpropm('T','C',0,'',0,fluid)-273.15;

T = linspace(Tmin,Tcrit,npoints);

%Preallocating
sl = T;
svs = T;

%Curva a campana
for i = 1: length(T)-1
    sl(i) = refpropm('S','T',T(i)+273.15,'Q',0,fluid)*1e-3;
    svs(i) = refpropm('S','T',T(i)+273.15,'Q',1,fluid)*1e-3;
end

sl(end) = refpropm('S','C',0,'',0,fluid)*1e-3;
svs(end) = sl(end);



% Isobare
slco = refpropm('S','T',Tm+273.15,'Q',0,fluid)*1e-3;

s_pco = linspace(slco,sv(3),npoints);

%Allocating
T_pco = s_pco;

for i =1:length(s_pco)
    T_pco(i) = refpropm('T','P',pco*1e2,'S',s_pco(i)*1e3,fluid)-273.15;
end

s_p = ones(length(p),npoints);
%Prealloc
T_p = s_p;

for j = 1 : length(p)
s_p(j,:) = linspace(s(j),sv(j),npoints);
for i = 1 : length(s_p)
    T_p(j,i) = refpropm('T','P',p(j),'S',s_p(j,i)*1e3,fluid)-273.15;
end
end

%% Plot piano T-S
figure('name', 'Piano T-s')
%Curva a campana
plot(sl, T, svs, T, 'linewidth', 2, 'color', 'k')
xlabel('s [kJ/kgK]', 'fontsize', 16, 'fontweight', 'bold')
ylabel('T [°C]', 'fontsize', 16, 'fontweight', 'bold')
hold on
%grid on;

%Colori per le curve
color = 'gbr';

%Raffreddamento
plot([slco sv(1)],[Tm Tm], '-ko','linewidth', 2, 'markerfacecolor','k', 'markersize', 3)

%Compressioni
for i = 1 : length(s)
plot([slco s(i)], [Tm Tl(i)], 'linewidth', 2,'Color',color(i));
plot(s_p(i,:),T_p(i,:),'linewidth', 2,'Color',color(i));
end

%Espansioni
sv = [sv(1) sv];
Tv = [Tm Tv];
for i = 1 : length(sv)-2
    plot([sv(i) sv(i+1)],[Tv(i),Tv(i+1)],'-o','linewidth', 2,'Color',color(i), 'markerfacecolor','k', 'markersize', 3);
end

plot([sv(end) sv(end)],[Tv(end-1),TvfMP],'-o','linewidth', 2,'Color',color(length(sv)-1), 'markerfacecolor','k', 'markersize', 3);

