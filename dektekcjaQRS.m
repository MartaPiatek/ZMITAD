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
%%
for i=3:min(length(left),length(right))
    [R_value(i-2) R_index(i-2)] = max( x1(left(i):right(i)) );
    R_index(i-2) = R_index(i-2)-1+left(i); % dodanie przesuniêcia

    
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

%%
figure

X=x1/max(x1);
title('Sygna³ EKG po detekcji');
plot (t,x1/max(x1) , t(R_index(1:end)) ,R_value((1:end)) , 'r^',t(S_index(1:end)) ,X(S_index(1:end)) , 'o' ...
    ,t(T_index(1:end)) ,X(T_index(1:end)) , 's',t(Q_index(1:end)) ,X(Q_index(1:end)) , '*',t(P_index(1:end)) ,X(P_index(1:end)),'gs');    
grid on;
legend('EKG','R','S','T','Q','P');
xlim([0 5])
%%
hold on;
for j=2:3
plot(S_index(j)/fs,X(S_index(j)),'k*')

plot(S_start_index(j)/fs,X(S_start_index(j)),'m*')

% plot((S_stop_index(j))/fs,X(S_stop_index(j)),'y*')

end

%%
clear P_stop_ind;
j=1;
while j<length(P_index)
    clear wart_test
    clear wart_test2 
 
wart_test(1)=X(P_index(j)-1);

for i=2:150
wart_test(i)=X(P_index(j)-i);
roznica(i)=P_value(j) -wart_test(i);  

% wart_test2(i)=X(P_index(j)+i);
% roznica2(i)=X(P_index(j)) -wart_test(i); 
end

diff_roznica=diff(roznica);
diff_roznica_abs=abs(diff_roznica);

    tmp_max=find(diff_roznica_abs==max(diff_roznica_abs));
%     if(length(tmp_max)>1)
       index_max_diff_abs= tmp_max(1);
%     end

  P_start_index(j)=index_max_diff_abs; % pocz¹tek za³amka P
  
 P_start_index(j)=P_index(j)-P_start_index(j);
 
 
 if(sum(abs(X(P_index(j):Q_index(j))-X(P_start_index(j)))<0.01)==0)
     P_stop_index(j)=0;
     P_length(j)=0;
     P_amplitude(j)=(P_value(j)+X(P_start_index(j))); % obliczanie amplitudy za³amka P
    
 else
  P_stop_ind=find(abs(X(P_index(j):Q_index(j))-X(P_start_index(j)))<0.01);
  
  P_stop_index(j)=P_stop_ind(1)+P_index(j); %koniec za³amka P
  
 P_length(j)=(P_stop_index(j)-P_start_index(j))/fs; % obliczanie d³ugoœci za³amka P
 P_amplitude(j)=(P_value(j)+X(P_start_index(j))); % obliczanie amplitudy za³amka P
 end
 
j=j+1;
end

sum_length=0;
number_length=0;
sum_amplitude=0;
number_amplitude=0;

for k=1:length(P_length)
    
    if(P_length(k)~=0)
        number_length=number_length+1;
        sum_length=sum_length+P_length(k);
    end

        if(P_amplitude(k)~=0)
        number_amplitude=number_amplitude+1;
        sum_amplitude=sum_amplitude+P_amplitude(k);
    end
    
end
P_length_AVR=sum_length/number_length % œrednia d³ugoœæ za³amka P w sekundach

P_amplitude_AVR=sum_amplitude/number_amplitude % œrednia amplituda w mV

%%
clear Q_stop_ind;
j=1;
while j<length(Q_index)
    clear wart_test
    clear wart_test2 
 
wart_test(1)=X(Q_index(j)-1);

for i=2:150
wart_test(i)=X(Q_index(j)-i);
roznica(i)=Q_value(j) -wart_test(i);  

end

diff_roznica=diff(roznica);
diff_roznica_abs=abs(diff_roznica);

    tmp_max=find(diff_roznica_abs==max(diff_roznica_abs));
%     if(length(tmp_max)>1)
       index_max_diff_abs= tmp_max(1);
%     end

  Q_start_index(j)=index_max_diff_abs; % pocz¹tek za³amka Q
  
 Q_start_index(j)=Q_index(j)-Q_start_index(j);
 
 
 if(sum(abs(X(Q_index(j):R_index(j))-X(Q_start_index(j)))<0.01)==0)
     Q_stop_index(j)=0;
     Q_length(j)=0;
     Q_amplitude(j)=(Q_value(j)+X(Q_start_index(j))); % obliczanie amplitudy za³amka Q
    
 else
  Q_stop_ind=find(abs(X(Q_index(j):R_index(j))-X(Q_start_index(j)))<0.01);
  
  Q_stop_index(j)=Q_stop_ind(1)+Q_index(j); %koniec za³amka Q
  
 Q_length(j)=(Q_stop_index(j)-Q_start_index(j))/fs ;% obliczanie d³ugoœci za³amka Q
 Q_amplitude(j)=(Q_value(j)+X(Q_start_index(j))); % obliczanie amplitudy za³amka Q
 end
 
j=j+1;
end

sum_length=0;
number_length=0;
sum_amplitude=0;
number_amplitude=0;

for k=1:length(Q_length)
    
    if(Q_length(k)~=0)
        number_length=number_length+1;
        sum_length=sum_length+Q_length(k);
    end

        if(Q_amplitude(k)~=0)
        number_amplitude=number_amplitude+1;
        sum_amplitude=sum_amplitude+Q_amplitude(k);
    end
    
end
Q_length_AVR=sum_length/number_length % œrednia d³ugoœæ za³amka Q w sekundach

Q_amplitude_AVR=sum_amplitude/number_amplitude % œrednia amplituda Q w mV


%%

clear R_stop_ind;
j=1;
while j<length(R_index)
    clear wart_test
     
wart_test(1)=X(R_index(j)-1);

for i=2:150
wart_test(i)=X(R_index(j)-i);
roznica(i)=R_value(j) -wart_test(i);  

end

diff_roznica=diff(roznica);
diff_roznica_abs=abs(diff_roznica);

    tmp_max=find(diff_roznica_abs==max(diff_roznica_abs));
%     if(length(tmp_max)>1)
       index_max_diff_abs= tmp_max(1);
%     end

  R_start_index(j)=index_max_diff_abs; % pocz¹tek za³amka Q
  
 R_start_index(j)=R_index(j)-R_start_index(j);
 
 
 if(sum(abs(X(R_index(j):S_index(j))-X(R_start_index(j)))<0.01)==0)
     R_stop_index(j)=0;
     R_length(j)=0;
     R_amplitude(j)=(R_value(j)+X(R_start_index(j))); % obliczanie amplitudy za³amka R
    
  else
  R_stop_ind=find(abs(X(R_index(j):S_index(j))-X(R_start_index(j)))<0.01);
  
  R_stop_index(j)=R_stop_ind(1)+R_index(j); %koniec za³amka Q
  
 R_length(j)=(R_stop_index(j)-R_start_index(j))/fs ;% obliczanie d³ugoœci za³amka R
 R_amplitude(j)=(R_value(j)+X(R_start_index(j))); % obliczanie amplitudy za³amka R
 end
 
j=j+1;
end

sum_length=0;
number_length=0;
sum_amplitude=0;
number_amplitude=0;

for k=1:length(R_length)
    
    if(R_length(k)~=0)
        number_length=number_length+1;
        sum_length=sum_length+R_length(k);
    end

        if(R_amplitude(k)~=0)
        number_amplitude=number_amplitude+1;
        sum_amplitude=sum_amplitude+R_amplitude(k);
    end
    
end
R_length_AVR=sum_length/number_length % œrednia d³ugoœæ za³amka R w sekundach

R_amplitude_AVR=sum_amplitude/number_amplitude % œrednia amplituda R w mV

%%

clear S_stop_ind;
j=1;
while j<length(S_index)
    clear wart_test
     
wart_test(1)=X(S_index(j)-1);

for i=2:100
wart_test(i)=X(S_index(j)-i);
roznica(i)=S_value(j) -wart_test(i);  

end

diff_roznica=diff(roznica);
diff_roznica_abs=diff_roznica;
%diff_roznica_abs=abs(diff_roznica); %%%%%%%%%%%%%%%%%%%%%%

    tmp_max=find(diff_roznica_abs==min(diff_roznica_abs));%%%%%%%%%% min czy max
%     if(length(tmp_max)>1)
       index_max_diff_abs= tmp_max(1);
%     end

  S_start_index(j)=index_max_diff_abs; % pocz¹tek za³amka Q
  
 S_start_index(j)=S_index(j)-S_start_index(j);
 
 
 if(sum(abs(X(S_index(j):T_index(j))-X(S_start_index(j)))<0.01)==0)
     S_stop_index(j)=0;
     S_length(j)=0;
     S_amplitude(j)=(S_value(j)+X(S_start_index(j))); % obliczanie amplitudy za³amka S
    
 else
  S_stop_ind=find(abs(X(S_index(j):T_index(j))-X(S_start_index(j)))<0.01);
  
  S_stop_index(j)=S_stop_ind(1)+S_index(j); %koniec za³amka Q
  
 S_length(j)=(S_stop_index(j)-S_start_index(j))/fs ;% obliczanie d³ugoœci za³amka Q
 S_amplitude(j)=(S_value(j)+X(S_start_index(j))); % obliczanie amplitudy za³amka Q
 end
 
j=j+1;
end

sum_length=0;
number_length=0;
sum_amplitude=0;
number_amplitude=0;

for k=1:length(S_length)
    
    if(S_length(k)~=0)
        number_length=number_length+1;
        sum_length=sum_length+S_length(k);
    end

        if(S_amplitude(k)~=0)
        number_amplitude=number_amplitude+1;
        sum_amplitude=sum_amplitude+S_amplitude(k);
    end
    
end
S_length_AVR=sum_length/number_length % œrednia d³ugoœæ za³amka S w sekundach

S_amplitude_AVR=sum_amplitude/number_amplitude % œrednia amplituda S w mV


%%

clear T_stop_ind;
j=1;
while j<length(T_index)-1
    clear wart_test
     
wart_test(1)=X(T_index(j)-1);

for i=2:150
wart_test(i)=X(T_index(j)-i);
roznica(i)=T_value(j) -wart_test(i);  

end

diff_roznica=diff(roznica);
diff_roznica_abs=abs(diff_roznica);

    tmp_max=find(diff_roznica_abs==max(diff_roznica_abs));
%     if(length(tmp_max)>1)
       index_max_diff_abs= tmp_max(1);
%     end

  T_start_index(j)=index_max_diff_abs; % pocz¹tek za³amka Q
  
 T_start_index(j)=T_index(j)-T_start_index(j);
 
 
 if(sum(abs(X(T_index(j):P_index(j+1))-X(T_start_index(j)))<0.01)==0)
     T_stop_index(j)=0;
     T_length(j)=0;
     T_amplitude(j)=(T_value(j)+X(T_start_index(j))); % obliczanie amplitudy za³amka S
    
 else
  T_stop_ind=find(abs(X(T_index(j):P_index(j+1))-X(T_start_index(j)))<0.01);
  
  T_stop_index(j)=T_stop_ind(1)+T_index(j); %koniec za³amka Q
  
 T_length(j)=(T_stop_index(j)-T_start_index(j))/fs ;% obliczanie d³ugoœci za³amka Q
 T_amplitude(j)=(T_value(j)+X(T_start_index(j))); % obliczanie amplitudy za³amka Q
 end
 
j=j+1;
end

sum_length=0;
number_length=0;
sum_amplitude=0;
number_amplitude=0;

for k=1:length(T_length)
    
    if(T_length(k)~=0)
        number_length=number_length+1;
        sum_length=sum_length+T_length(k);
    end

        if(T_amplitude(k)~=0)
        number_amplitude=number_amplitude+1;
        sum_amplitude=sum_amplitude+T_amplitude(k);
    end
    
end
T_length_AVR=sum_length/number_length % œrednia d³ugoœæ za³amka T w sekundach

T_amplitude_AVR=sum_amplitude/number_amplitude % œrednia amplituda T w mV

%% zespó³ QRS do poprawy problem z S

for i=1:length(Q_start_index)
QRS_length(i)=((S_start_index(i)+(S_length(i)*fs))-Q_start_index(i))/fs

QRS(i)=Q_length(i)+R_length(i)+S_length(i);
end

%% PQ
for i=1:length(P_start_index)
   PQ(i)=(Q_stop_index(i)-P_start_index(i))/fs 
end
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
