% Piano_Ts_vapore_ciclo_combinato

clc
close all 
clear all

fluid='water';
pAP=122.46; %bar
pMP=35.17;
pBP=5.8;
T1=41.79; %°C
pco=refpropm('P','T',T1+273.15,'Q',0.5,fluid)*1e-2;

% Liquido saturo
TlAP=refpropm('T','P',pAP*1e2,'Q',0,fluid)-273.15;
TlMP=refpropm('T','P',pMP*1e2,'Q',0,fluid)-273.15;
TlBP=refpropm('T','P',pBP*1e2,'Q',0,fluid)-273.15;

slAP=refpropm('S','P',pAP*1e2,'Q',0,fluid)*1e-3;
slMP=refpropm('S','P',pMP*1e2,'Q',0,fluid)*1e-3;
slBP=refpropm('S','P',pBP*1e2,'Q',0,fluid)*1e-3;

hlAP=refpropm('H','P',pAP*1e2,'Q',0,fluid)*1e-3;
hlMP=refpropm('H','P',pMP*1e2,'Q',0,fluid)*1e-3;
hlBP=refpropm('H','P',pBP*1e2,'Q',0,fluid)*1e-3;

% Vapore saturo secco

hvAP=refpropm('H','P',pAP*1e2,'Q',1,fluid)*1e-3;
hvMP=refpropm('H','P',pMP*1e2,'Q',1,fluid)*1e-3;
hvBP=refpropm('H','P',pBP*1e2,'Q',1,fluid)*1e-3;

% Vapore surriscaldato

TvAP=563.54; %°C     Temp max AP     p12
TvfMP=372.05; %°C    Temp fredda MP  p8'
TvMP=563.11; %°C     Temp max MP     p8
TvBP=245; %°C        Temp vapore BP  p4

svAP=refpropm('S', 'T', TvAP+273.15,'P', pAP*1e2, fluid)*1e-3;
svMP=refpropm('S', 'T', TvMP+273.15,'P', pMP*1e2, fluid)*1e-3;
svBP=refpropm('S', 'T', TvBP+273.15,'P', pBP*1e2, fluid)*1e-3;


%% Piano T-s

Tmin=15; %°C
Tcrit=refpropm('T','C',0,' ',0,fluid)-273.15;
T=Tmin:(Tcrit-Tmin)/100:Tcrit;

sl=ones(length(T),1);
svs=ones(length(T),1);

for i=1:length(T)-1
sl(i)=refpropm('S','T',T(i)+273.15,'Q',0,fluid)*1e-3;
svs(i)=refpropm('S','T',T(i)+273.15,'Q',1,fluid)*1e-3;
    
end

sl(end)=refpropm('S','C',0,' ',0,fluid)*1e-3;
svs(end)=refpropm('S','C',0,' ',0,fluid)*1e-3;


% Isobare

slco=refpropm('S','T',T1+273.15,'Q',0,fluid)*1e-3;
s_pco=slco:(svBP-slco)/100:svBP;
T_pco=ones(length(s_pco),1);

for i=1:length(s_pco)
    
   T_pco(i)=refpropm('T','P',pco*1e2,'S',s_pco(i)*1e3, fluid)-273.15; 
    
end

% Isobara di BP

s_pBP = slBP:(svBP-slBP)/100:svBP;
T_pBP = ones(length(s_pBP),1);

for i=1:length(s_pBP)
    T_pBP(i)= refpropm ('T', 'P', pBP*1e2, 'S', s_pBP(i)*1e3, fluid)-273.15;
end

% Isobara MP

s_pMP=slMP:(svMP-slMP)/100:svMP;
T_pMP=ones(length(s_pMP),1);

for i=1:length(s_pMP)
    
   T_pMP(i)=refpropm('T','P',pMP*1e2,'S',s_pMP(i)*1e3, fluid)-273.15; 
    
end

% Isobara AP

s_pAP=slAP:(svAP-slAP)/100:svAP;
T_pAP=ones(length(s_pAP),1);

for i=1:length(s_pAP)
    
   T_pAP(i)=refpropm('T','P',pAP*1e2,'S',s_pAP(i)*1e3, fluid)-273.15; 
    
end


% Grafico

figure('name', 'Piano T-s')
plot(sl, T, svs, T, 'linewidth', 2, 'color', 'k')
xlabel('s [kJ/kgK]', 'fontsize', 16, 'fontweight', 'bold')
ylabel('T [°C]', 'fontsize', 16, 'fontweight', 'bold')
hold on
% Punti
plot([slco svBP],[T1 T1], 'o', 'markerfacecolor','k', 'markersize', 4, 'markeredgecolor','k')
plot([slBP svBP],[TlBP TvBP], 'o', 'markerfacecolor','g', 'markersize', 4, 'markeredgecolor','g')
plot([slMP svMP],[TlMP TvMP], 'o', 'markerfacecolor','b', 'markersize', 4, 'markeredgecolor','b')
plot([slAP svAP],[TlAP TvAP], 'o', 'markerfacecolor','r', 'markersize', 4, 'markeredgecolor','r')
% Compressioni
line([slco slAP], [T1 TlAP], 'linewidth', 2, 'color', 'r')
line([slco slMP], [T1 TlMP], 'linewidth', 2, 'color', 'b')
line([slco slBP], [T1 TlBP], 'linewidth', 2, 'color', 'g')
% Isobare
plot(s_pco, T_pco, 'linewidth', 2, 'color', 'k')
plot(s_pBP, T_pBP, 'linewidth', 2, 'color', 'g')
plot(s_pMP, T_pMP, 'linewidth', 2, 'color', 'b')
plot(s_pAP, T_pAP, 'linewidth', 2, 'color', 'r')
% Espansioni
line([svAP svAP], [TvAP TvfMP], 'linewidth', 2, 'color', 'r')
line([svMP svBP], [TvMP TvBP], 'linewidth', 2, 'color', 'b')
line([svBP svBP], [TvBP T1], 'linewidth', 2, 'color', 'g')
% Punto Incontro portate a MP
plot([svAP],[TvfMP], 'o', 'markerfacecolor','m', 'markersize', 4, 'markeredgecolor','m')





