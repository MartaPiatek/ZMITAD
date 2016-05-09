close all


x1 = val(1,:); % wybranie odprowadzenia do analizy
fs = 1000;              % czêstotliwoœæ próbkowania
N = length (x1);       % d³ugoœæ sygna³u
t = [0:N-1]/fs;        % wektor czasu


% figure(1)
% plot(t,x1)
% xlabel('s');ylabel('mV');title('Wejœciowy sygna³ EKG')

 
%usuniêcie sk³adowej sta³ej i normalizacja sygna³u
x1 = x1 - mean (x1 );    % usuniêcie sk³adowej sta³ej
x1 = x1/ max( abs(x1 )); % normalizacja

% figure(2)
% plot(t,x1)
% xlabel('s');ylabel('V');title('Sygna³ EKG po usuniêciu sk³adowej sta³ej i normalizacji')

% filtr dolnoprzepustowy
% LPF (1-z^-6)^2/(1-z^-1)^2
b=[1 0 0 0 0 0 -2 0 0 0 0 0 1];
a=[1 -2 1];


h_LP=filter(b,a,[1 zeros(1,12)]); % funkcja przenoszenia

x2 = conv (x1 ,h_LP); %splot
x2 = x2/ max( abs(x2 )); % normalizacja

% figure(3)
% plot([0:length(x2)-1]/fs,x2)
% xlabel('s');ylabel('V');title('Sygna³ EKG po filtracji LPF')
% xlim([0 max(t)])
% % 
 
%filtr górnoprzepustowy
% HPF = Allpass-(Lowpass) = z^-16-[(1-z^-32)/(1-z^-1)]
b = [-1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 32 -32 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1];
a = [1 -1];

h_HP=filter(b,a,[1 zeros(1,32)]); % odpowiedŸ impulsowa HPF

x3 = conv (x2 ,h_HP); %splot
x3 = x3/ max( abs(x3 )); %normalizacja

% figure(4)
% plot([0:length(x3)-1]/fs,x3)
% xlabel('s');ylabel('V');title('Sygna³ EKG po filtracji HPF')
% xlim([0 max(t)])

 
% filtr róŸniczkuj¹cy

h = [-1 -2 0 2 1]/8; %odpowiedŸ impulsowa

x4 = conv (x3 ,h);
x4 = x4 (2+[1: N]);
x4 = x4/ max( abs(x4 ));

% figure(5)
% plot([0:length(x4)-1]/fs,x4)
% xlabel('s');ylabel('V');title('Sygna³ EKG po zró¿niczkowaniu')

 
% Podniesienie do kwadratu
x5 = x4 .^2;
x5 = x5/ max( abs(x5 ));
% figure(6)
% plot([0:length(x5)-1]/fs,x5)
% xlabel('s');ylabel('V');title(' Kwadrat sygna³u EKG')
%  
h = ones (1 ,31)/31;
Delay = 15; % OpóŸnienie próbek

x6 = conv (x5 ,h);
x6 = x6 (15+[1: N]);
x6 = x6/ max( abs(x6 ));

% figure(7)
% plot([0:length(x6)-1]/fs,x6)
% xlabel('s');ylabel('V');title('Sygna³ EKG po uœrednieniu')

 
%Detekcja QRS

max_h = max(x6);
thresh = mean (x6 );
poss_reg =(x6>thresh*max_h)';


tescik=diff(cat(1,0,poss_reg));
left=find(tescik==1);
right=find(tescik==-1);

left=left-(6+16);  % niwelacja opóŸnienia pomiêdzy filtracjami LP i HP
right=right-(6+16);% niwelacja opóŸnienia pomiêdzy filtracjami LP i HP

X=x1/max(x1);

for i=1:min(length(left),length(right))
    [R_value(i) R_index(i)] = max( x1(left(i):right(i)) );
    R_index(i) = R_index(i)-1+left(i); % dodanie przesuniêcia

    
    seg1=x1(R_index(i):right(i)+200);
    min_seg1=min(seg1);
    min_seg1_ind=find(seg1==min_seg1);
    S_index(i)=R_index(i)+min_seg1_ind(1);
    S_value(i)=X(S_index(i));
    
    seg3=x1(left(i)-100:R_index(i));
    min_seg3=min(seg3);
    min_seg3_ind=find(seg3==min_seg3);
    Q_index(i)=left(i)-100+min_seg3_ind(1);
    Q_value(i)=X(Q_index(i));
    
    seg2=x1(left(i)-200:Q_index(i));
    max_seg2=max(seg2);
    max_seg2_ind=find(seg2==max_seg2);
    P_index(i)=left(i)-200+max_seg2_ind(1);
    P_value(i)=X(P_index(i));

    
    seg4=x1(S_index(i):S_index(i)+400);
    max_seg4=max(seg4);
    max_seg4_ind=find(seg4==max_seg4);
    T_index(i)=S_index(i)+max_seg4_ind(1);
    T_value(i)=X(T_index(i));
end
%%

%%
figure

X=x1/max(x1);
title('Sygna³ EKG po detekcji');
plot (t,x1/max(x1) , t(R_index) ,R_value(1:end) , 'r^',t(S_index) ,X(S_index) , 'o' ...
    ,t(T_index) ,X(T_index) , 's',t(Q_index) ,X(Q_index) , '*',t(P_index) ,X(P_index),'gs');    
grid on;
legend('EKG','R','S','T','Q','P');
xlim([0 5])
%%
hold on;
for j=1:10
plot(P_index(j)/fs,X(P_index(j)),'k*')

plot(P_start_index(j)/fs,X(P_start_index(j)),'m*')

plot((P_stop_index(j))/fs,X(P_stop_index(j)),'y*')

end

%%
clear P_stop_ind;
for j=1:10
    
 
wart_test(1)=X(P_index(j)-1);
wart_test2(1)=X(P_index(j)-1);

for i=2:150
wart_test(i)=X(P_index(j)-i);
roznica(i)=X(P_index(j)) -wart_test(i);  

% wart_test2(i)=X(P_index(j)+i);
% roznica2(i)=X(P_index(j)) -wart_test(i); 
end

po=diff(roznica);
po_abs=abs(po);
% figure;
% plot(po_abs);hold on;
% plot(find(po_abs==max(po_abs)),max(po_abs),'r*')
% title('po abs')
% 
% figure;
% plot(po);hold on;
% plot(find(po==min(po)),min(po),'r*')
% title('po')

 P_start_index(j)=find(po_abs==max(po_abs));% pocz¹tek za³amka P
 P_start_index(j)=P_index(j)-P_start_index(j);
 
  P_stop_ind=find(abs(X(P_index(j):Q_index(j))-X(P_start_index(j)))<0.01);
  P_stop_index(j)=P_stop_ind(1)+P_index(j) %koniec za³amka P
  
 P_length(j)=(P_stop_index(j)-P_start_index(j))/fs % obliczanie d³ugoœci za³amka P
 P_amplituda(j)=(P_value(j)+X(P_start_index(j))) % obliczanie amplitudy za³amka P
end

P_length_AVR=mean(P_length) % œrednia d³ugoœæ za³amka P w sekundach

P_amplituda_AVR=mean(P_amplituda) % œrednia amplituda w mV

%%
clear Q_stop_ind;
for j=1:3
    
 
wart_test(1)=X(Q_index(j)-1);
wart_test2(1)=X(Q_index(j)-1);

for i=2:150
wart_test(i)=X(Q_index(j)-i);
roznica(i)=X(Q_index(j)) -wart_test(i);  

% wart_test2(i)=X(Q_index(j)+i);
% roznica2(i)=X(Q_index(j)) -wart_test(i); 
end

po=diff(roznica);
po_abs=abs(po);
% figure;
% plot(po_abs);hold on;
% plot(find(po_abs==max(po_abs)),max(po_abs),'r*')
% title('po abs')
% 
% figure;
% plot(po);hold on;
% plot(find(po==min(po)),min(po),'r*')
% title('po')

 Q_start_index(j)=find(po_abs==max(po_abs));% pocz¹tek za³amka P
 Q_start_index(j)=Q_index(j)-Q_start_index(j);
 
  Q_stop_ind=find(abs(X(Q_index(j):R_index(j))-X(Q_start_index(j)))<0.01);
  Q_stop_index(j)=Q_stop_ind(1)+Q_index(j) %koniec za³amka P
  
 Q_length(j)=(Q_stop_index(j)-Q_start_index(j))/fs % obliczanie d³ugoœci za³amka P
 Q_amplituda(j)=(Q_value(j)+X(Q_start_index(j))) % obliczanie amplitudy za³amka P
end

Q_length_AVR=mean(Q_length) % œrednia d³ugoœæ za³amka P w sekundach

Q_amplituda_AVR=mean(Q_amplituda) % œrednia amplituda w mV
%% obliczanie czêstoœci pracy serca

HR=(length(R_index))*60/t(end) % liczba uderzeñ na min


% %% obliczanie interwa³u RR
% for i=1:length(R_index)-1
% RR_interwal(i)=R_index(i+1)-R_index(i);
% end
% 
% figure;
% %plot(RR_interwal,'r.')
% hist(RR_interwal,10)
% xlabel('czas trwania odcinka RR [ms]')
% ylabel('licznoœci')
% 
% RR_interwal_AVR=mean(RR_interwal) % œrednia d³ugoœæ interwa³u RR
% RR_interwal_STD=std(RR_interwal) % odchylenie standardowe
