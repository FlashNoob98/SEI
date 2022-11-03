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

%Fattore di recupero sigma) = (q/q_TEORICA)
fluid = 'water';
pAP = 122.45; %bar
pMP = 35.17;
pBP = 5.8;
p = [pAP,pMP,pBP];

Tm = 41.79; %C

pco = refpropm('P','T',Tm(1)+273.15,'Q',0.5,fluid)/100; %Pressione a titolo 0.5 

for i =1:length(p)
    %Liquido saturo
    T1(i) = refpropm('T','P',p(i)*1e-2,'Q',0,fluid)-273.15;
    h1(i) = refpropm('H','P',p(i),'Q',0,fluid)*1e-3;
    s(i) = refpropm('S','P',p(i)*1e-2,'Q',0,fluid)*1e-3;

    %Vapore saturo secco
    hv(i) = refpropm('H','P',p(i),'Q',1,fluid)*1e-3;
end

%Vapore surriscaldato

TvAP = 563.54; %C
TvMP = 563.11;
TvBP = 245;

Tv = [TvAP,TvMP,TvBP];

TvfMP = 372.05;

for i = 1: length(Tv)
    sv(i) = refpropm('S','T',Tv(i)+273.15,'P',p(i)*1e-2,fluid)*1e-3;
end

%% Piano T-s

Tmin = 15; %C
Tcrit = refpropm('T','C',0,'',0,fluid)-273.15;

T = linspace(Tmin,Tcrit,100);

sl = ones(length(T),1);
svs = ones(length(T),1);

for i = 1: length(T)-1
    sl(i) = refpropm('S','T',T(i)+273.15,'Q',0,fluid)*1e-3;
    svs(i) = refpropm('S','T',T(i)+273.15,'Q',1,fluid)*1e-3;
end

sl(end) = refpropm('S','C',0,'',0,fluid)*1e-3;
svs(end) = sl(end);



% Isobare
slco = refpropm('S','T',Tm+273.15,'Q',0,fluid)*1e-3;

s_pco = linspace(slco,sv(3),100);
T_pco = ones(length(s_pco));

for i =1:length(s_pco)
    T_pco(i) = refpropm('T','P',pco*1e2,'S',s_pco(i)*1e3,fluid)-273.15;
end





for j = 1: length(p)
s_p(j,:) = linspace(s(j),sv(j),100);
T_p(j,:) = ones(size(s_p,2),1)';

for i = 1:length(s_p)
    T_p(j,i) = refpropm('T','P',p(j)*1e2,'S',s_p(j,i));
end

end
