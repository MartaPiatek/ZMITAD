close all


x1 = val(1,:); % wybranie odprowadzenia do analizy
fs = 1000;              % czêstotliwoœæ próbkowania
N = length (x1);       % d³ugoœæ sygna³u
t = [0:N-1]/fs;        % wektor czasu


figure(1)
subplot(2,1,1)
plot(t,x1)
xlabel('s');ylabel('V');title('Wejœciowy sygna³ EKG')
subplot(2,1,2)
plot(t(200:600),x1(200:600))
xlabel('s');ylabel('V');title('Wejœciowy sygna³ EKG fragment 1-3 s')
xlim([1 3])
 
%usuniêcie sk³adowej sta³ej i normalizacja sygna³u
x1 = x1 - mean (x1 );    % usuniêcie sk³adowej sta³ej
x1 = x1/ max( abs(x1 )); % normalizacja

figure(2)
plot(t,x1)
xlabel('s');ylabel('V');title('Sygna³ EKG po usuniêciu sk³adowej sta³ej i normalizacji')

% filtr dolnoprzepustowy
% LPF (1-z^-6)^2/(1-z^-1)^2
b=[1 0 0 0 0 0 -2 0 0 0 0 0 1];
a=[1 -2 1];


h_LP=filter(b,a,[1 zeros(1,12)]); % funkcja przenoszenia

x2 = conv (x1 ,h_LP); %splot
x2 = x2/ max( abs(x2 )); % normalizacja

figure(3)
plot([0:length(x2)-1]/fs,x2)
xlabel('s');ylabel('V');title('Sygna³ EKG po filtracji LPF')
xlim([0 max(t)])

 
%filtr górnoprzepustowy
% HPF = Allpass-(Lowpass) = z^-16-[(1-z^-32)/(1-z^-1)]
b = [-1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 32 -32 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1];
a = [1 -1];

h_HP=filter(b,a,[1 zeros(1,32)]); % odpowiedŸ impulsowa HPF

x3 = conv (x2 ,h_HP); %splot
x3 = x3/ max( abs(x3 )); %normalizacja

figure(4)
plot([0:length(x3)-1]/fs,x3)
xlabel('s');ylabel('V');title('Sygna³ EKG po filtracji HPF')
xlim([0 max(t)])

 
% filtr róŸniczkuj¹cy

h = [-1 -2 0 2 1]/8; %odpowiedŸ impulsowa

x4 = conv (x3 ,h);
x4 = x4 (2+[1: N]);
x4 = x4/ max( abs(x4 ));

figure(5)
plot([0:length(x4)-1]/fs,x4)
xlabel('s');ylabel('V');title('Sygna³ EKG po zró¿niczkowaniu')

 
% Podniesienie do kwadratu
x5 = x4 .^2;
x5 = x5/ max( abs(x5 ));
figure(6)
plot([0:length(x5)-1]/fs,x5)
xlabel('s');ylabel('V');title(' Kwadrat sygna³u EKG')
 
%MOVING WINDOW INTEGRATION
% Make impulse response
h = ones (1 ,31)/31;
Delay = 15; % OpóŸnienie próbek

x6 = conv (x5 ,h);
x6 = x6 (15+[1: N]);
x6 = x6/ max( abs(x6 ));

figure(7)
plot([0:length(x6)-1]/fs,x6)
xlabel('s');ylabel('V');title('Sygna³ EKG po uœrednieniu')

 
%Detekcja QRS

max_h = max(x6);
thresh = mean (x6 );
poss_reg =(x6>thresh*max_h)';

figure (8)
hold on
plot (t(1000:6000),x1(1000:6000)/max(x1))
box on
xlabel('s');ylabel('Integrated')
xlim([1 3])


tescik=diff(cat(1,0,poss_reg));
left=find(tescik==1);
right=find(tescik==-1);

left=left-(6+16);  % niwelacja opóŸnienia pomiêdzy filtracjami LP i HP
right=right-(6+16);% niwelacja opóŸnienia pomiêdzy filtracjami LP i HP

for i=1:min(length(left),length(right))
    [R_value(i) R_loc(i)] = max( x1(left(i):right(i)) );
    R_loc(i) = R_loc(i)-1+left(i); % dodanie przesuniêcia

    [Q_value(i) Q_loc(i)] = min( x1(left(i):R_loc(i)) );
    Q_loc(i) = Q_loc(i)-1+left(i); % dodanie przesuniêcia


    [S_value(i) S_loc(i)] = min( x1(R_loc(i):right(i)) );
    S_loc(i) = S_loc(i)-1+left(i); % dodanie przesuniêcia

    
    [P_value(i) P_loc(i)] = max( x1(left(i):Q_loc(i)) );
    P_loc(i) = P_loc(i)-1+left(i); % dodanie przesuniêcia


    [T_value(i) T_loc(i)] = max( x1(Q_loc(i):(Q_loc(i)+300)) );
    T_loc(i) = T_loc(i)-1+left(i); % dodanie przesuniêcia

    
    seg1=x1(R_loc(i):right(i)+200);
    minimum=min(seg1);
    min_indeks=find(seg1==minimum);
    S_indeks(i)=R_loc(i)+min_indeks(1)
    
    seg2=x1(left(i)-200:left(i));
    maksimum=max(seg2);
    max_indeks=find(seg2==maksimum);
   P_indeks(i)=left(i)-max_indeks(1)
    
    seg3=x1(R_loc(i)-150:R_loc(i));
    minimum=min(seg3);
    min_indeks=find(seg3==minimum);
    Q_indeks(i)=R_loc(i)-min_indeks(1)
    
    
end

% usuniêcie indeksów na pocz¹tku sygna³u
P_loc=P_loc(find(P_loc~=0));
Q_loc=Q_loc(find(Q_loc~=0));
R_loc=R_loc(find(R_loc~=0));
S_loc=S_loc(find(S_loc~=0));
T_loc=T_loc(find(T_loc~=0));
%%
figure
title('Sygna³ EKG po detekcji');
plot (t,x1/max(x1)  ,t(P_loc) ,P_value(1:end), 's', t(R_loc) ,R_value(1:end) , 'r^', ...
    t(S_loc) ,S_value(1:end), '*',t(Q_loc) , Q_value(1:end), 'o',t(T_loc) , T_value(1:end), 'k*');                          
legend('EKG','P','R','S','Q','T');

%% 
seg1=x1(R_loc(1):right(1)+200);
minimum=min(seg1)
min_indeks=find(seg1==minimum)
Q_indeks=min_indeks(1)

    seg2=x1(left(i)-200:R_loc(i));
    minimum=min(seg2)
    max_indeks=find(seg1==minimum)
    Q_indeks(i)=R_loc(i)+min_indeks(1)
    
figure;
plot(seg1)
%% obliczanie interwa³u RR
for i=1:length(R_loc)-1
RR_interwal(i)=R_loc(i+1)-R_loc(i);
end

figure;
%plot(RR_interwal,'r.')
hist(RR_interwal,10)
xlabel('czas trwania odcinka RR [ms]')
ylabel('licznoœci')

%% Uœrednianie po kilku cyklach pracy serca

N=4 %liczba cykli do uœrednienia
i=1
sum=x1(R_loc(i)+550:R_loc(i+1)+550);


for i=2:N+1
frag1=x1(R_loc(i)+550:R_loc(i+1)+550)
if(length(frag1)~=length(sum))
   T=0.5*length(sum);
   frag1=x1((R_loc(i)+T):(R_loc(i+1)+T))
    
end
sum=sum+frag1;

end
figure;
plot(frag1)

figure;
plot(sum)