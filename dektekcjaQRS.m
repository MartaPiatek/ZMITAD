close all


x1 = val(1,:); % wybranie odprowadzenia do analizy
fs = 1000;              % cz�stotliwo�� pr�bkowania
N = length (x1);       % d�ugo�� sygna�u
t = [0:N-1]/fs;        % wektor czasu


% figure(1)
% plot(t,x1)
% xlabel('s');ylabel('mV');title('Wej�ciowy sygna� EKG')

 
%usuni�cie sk�adowej sta�ej i normalizacja sygna�u
x1 = x1 - mean (x1 );    % usuni�cie sk�adowej sta�ej
x1 = x1/ max( abs(x1 )); % normalizacja

% figure(2)
% plot(t,x1)
% xlabel('s');ylabel('V');title('Sygna� EKG po usuni�ciu sk�adowej sta�ej i normalizacji')

% filtr dolnoprzepustowy
% LPF (1-z^-6)^2/(1-z^-1)^2
b=[1 0 0 0 0 0 -2 0 0 0 0 0 1];
a=[1 -2 1];


h_LP=filter(b,a,[1 zeros(1,12)]); % funkcja przenoszenia

x2 = conv (x1 ,h_LP); %splot
x2 = x2/ max( abs(x2 )); % normalizacja

% figure(3)
% plot([0:length(x2)-1]/fs,x2)
% xlabel('s');ylabel('V');title('Sygna� EKG po filtracji LPF')
% xlim([0 max(t)])
% % 
 
%filtr g�rnoprzepustowy
% HPF = Allpass-(Lowpass) = z^-16-[(1-z^-32)/(1-z^-1)]
b = [-1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 32 -32 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1];
a = [1 -1];

h_HP=filter(b,a,[1 zeros(1,32)]); % odpowied� impulsowa HPF

x3 = conv (x2 ,h_HP); %splot
x3 = x3/ max( abs(x3 )); %normalizacja

% figure(4)
% plot([0:length(x3)-1]/fs,x3)
% xlabel('s');ylabel('V');title('Sygna� EKG po filtracji HPF')
% xlim([0 max(t)])

 
% filtr r�niczkuj�cy

h = [-1 -2 0 2 1]/8; %odpowied� impulsowa

x4 = conv (x3 ,h);
x4 = x4 (2+[1: N]);
x4 = x4/ max( abs(x4 ));

% figure(5)
% plot([0:length(x4)-1]/fs,x4)
% xlabel('s');ylabel('V');title('Sygna� EKG po zr�niczkowaniu')

 
% Podniesienie do kwadratu
x5 = x4 .^2;
x5 = x5/ max( abs(x5 ));
% figure(6)
% plot([0:length(x5)-1]/fs,x5)
% xlabel('s');ylabel('V');title(' Kwadrat sygna�u EKG')
%  
h = ones (1 ,31)/31;
Delay = 15; % Op�nienie pr�bek

x6 = conv (x5 ,h);
x6 = x6 (15+[1: N]);
x6 = x6/ max( abs(x6 ));

% figure(7)
% plot([0:length(x6)-1]/fs,x6)
% xlabel('s');ylabel('V');title('Sygna� EKG po u�rednieniu')

 
%Detekcja QRS

max_h = max(x6);
thresh = mean (x6 );
poss_reg =(x6>thresh*max_h)';


tescik=diff(cat(1,0,poss_reg));
left=find(tescik==1);
right=find(tescik==-1);

left=left-(6+16);  % niwelacja op�nienia pomi�dzy filtracjami LP i HP
right=right-(6+16);% niwelacja op�nienia pomi�dzy filtracjami LP i HP

X=x1/max(x1);

for i=1:min(length(left),length(right))
    [R_value(i) R_loc(i)] = max( x1(left(i):right(i)) );
    R_loc(i) = R_loc(i)-1+left(i); % dodanie przesuni�cia

    
    seg1=x1(R_loc(i):right(i)+200);
    min_seg1=min(seg1);
    min_seg1_ind=find(seg1==min_seg1);
    S_index(i)=R_loc(i)+min_seg1_ind(1);
    S_value(i)=X(S_index(i));
    
    seg3=x1(left(i)-100:R_loc(i));
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
figure;
plot(x1(left(i):right(i)))


%% 
figure

X=x1/max(x1);
title('Sygna� EKG po detekcji');
plot (t,x1/max(x1) , t(R_loc) ,R_value(1:end) , 'r^',t(S_index) ,X(S_index) , 'o' ...
    ,t(T_index) ,X(T_index) , 's',t(Q_index) ,X(Q_index) , '*',t(P_index) ,X(P_index),'gs');                          
legend('EKG','R','S','T','Q','P');

%% obliczanie cz�sto�ci pracy serca

HR=(length(R_loc))*60/t(end) % liczba uderze� na min




%% obliczanie interwa�u RR
for i=1:length(R_loc)-1
RR_interwal(i)=R_loc(i+1)-R_loc(i);
end

figure;
%plot(RR_interwal,'r.')
hist(RR_interwal,10)
xlabel('czas trwania odcinka RR [ms]')
ylabel('liczno�ci')

%% test segment�w
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
%% U�rednianie po kilku cyklach pracy serca


N=4 %liczba cykli do u�rednienia
i=1

sum=x1(R_loc(i)+550:R_loc(i+1)+550);
freq1=1*length(x1(R_loc(i)+550:R_loc(i+1)+550))/fs
%%
N=4
for i=1:N-1
    
frag1=x1(R_loc(i)+550:R_loc(i+1)+550)

% if(length(frag1)~=length(sum))
%    T=0.5*length(sum);
%    frag1=x1((R_loc(i)+T):(R_loc(i+1)+T))
%     
% end
%sum=sum+frag1;

freq(i)=1*length(x1(R_loc(i)+550:R_loc(i+1)+550))/fs;

n_freq=min(freq);

end
n_freq=min(freq);
p=5;
q=p/n_freq;
y = resample(frag1,p,131);
%%

figure;
plot(y)
length(y)
length(frag1)
%%
figure;
plot(frag1)

figure;
plot(sum)