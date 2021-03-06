
function [P_index,P_value,Q_index,Q_value,R_index,R_value,S_index, S_value, T_index, T_value, HR,RR_interwal]=detekcja(ekg)

close all

x1 = ekg; % wybranie odprowadzenia do analizy

fs = 1000;              % cz�stotliwo�� pr�bkowania
N = length (x1);       % d�ugo�� sygna�u
t = [0:N-1]/fs;        % wektor czasu
 
%usuni�cie sk�adowej sta�ej i normalizacja sygna�u
x1 = x1 - mean (x1 );    % usuni�cie sk�adowej sta�ej
x1 = x1/ max( abs(x1 )); % normalizacja

% filtr dolnoprzepustowy
% LPF (1-z^-6)^2/(1-z^-1)^2
b=[1 0 0 0 0 0 -2 0 0 0 0 0 1];
a=[1 -2 1];

h_LP=filter(b,a,[1 zeros(1,12)]); % funkcja przenoszenia

x2 = conv (x1 ,h_LP); %splot
x2 = x2/ max( abs(x2 )); % normalizacja

%filtr g�rnoprzepustowy
% HPF = Allpass-(Lowpass) = z^-16-[(1-z^-32)/(1-z^-1)]
b = [-1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 32 -32 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1];
a = [1 -1];

h_HP=filter(b,a,[1 zeros(1,32)]); % odpowied� impulsowa HPF

x3 = conv (x2 ,h_HP); %splot
x3 = x3/ max( abs(x3 )); %normalizacja

% filtr r�niczkuj�cy

h = [-1 -2 0 2 1]/8; %odpowied� impulsowa

x4 = conv (x3 ,h);
x4 = x4 (2+[1: N]);
x4 = x4/ max( abs(x4 ));

% Podniesienie do kwadratu
x5 = x4 .^2;
x5 = x5/ max( abs(x5 ));
  
h = ones (1 ,31)/31;
Delay = 15; % Op�nienie pr�bek

x6 = conv (x5 ,h);
x6 = x6 (15+[1: N]);
x6 = x6/ max( abs(x6 ));

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

for i=3:min(length(left),length(right))
    [R_value(i-2) R_index(i-2)] = max( x1(left(i):right(i)) );
    R_index(i-2) = R_index(i-2)-1+left(i); % dodanie przesuni�cia

    
    seg1=x1(R_index(i-2):right(i)+200);
    min_seg1=min(seg1);
    min_seg1_ind=find(seg1==min_seg1);
    S_index(i-2)=R_index(i-2)+min_seg1_ind(1);
    S_value(i-2)=X(S_index(i-2));
    
    seg3=x1(left(i)-100:R_index(i-2));
    min_seg3=min(seg3);
    min_seg3_ind=find(seg3==min_seg3);
    Q_index(i-2)=left(i)-100+min_seg3_ind(1);
    Q_value(i-2)=X(Q_index(i-2));
    
    seg2=x1(left(i)-200:Q_index(i-2));
    max_seg2=max(seg2);
    max_seg2_ind=find(seg2==max_seg2);
    P_index(i-2)=left(i)-200+max_seg2_ind(1);
    P_value(i-2)=X(P_index(i-2));

    
    seg4=x1(S_index(i-2):S_index(i-2)+300);
    max_seg4=max(seg4);
    max_seg4_ind=find(seg4==max_seg4);
    T_index(i-2)=S_index(i-2)+max_seg4_ind(1);
    T_value(i-2)=X(T_index(i-2));
end

%% 
% figure
% 
% X=x1/max(x1);
% title('Sygna� EKG po detekcji');
% plot (t,x1/max(x1) , t(R_index) ,R_value(1:end) , 'r^',t(S_index) ,X(S_index) , 'o' ...
%     ,t(T_index) ,X(T_index) , 's',t(Q_index) ,X(Q_index) , '*',t(P_index) ,X(P_index),'gs');                          
% legend('EKG','R','S','T','Q','P');

%% obliczanie cz�sto�ci pracy serca

HR=(length(R_index))*60/t(end); % liczba uderze� na min

%% obliczanie interwa�u RR
for i=1:length(R_index)-1
RR_interwal(i)=R_index(i+1)-R_index(i);
end

end
