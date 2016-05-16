clear
clc

data=load('patientsDATA.txt');

% x=randi(100)
% y=x+randi(144)

x=1;
y=length(data);


P_amplitude_AVR=data(x:y,1);
P_length_AVR=data(x:y,2);
Q_amplitude_AVR =data(x:y,3);
Q_length_AVR =data(x:y,4);
R_amplitude_AVR =data(x:y,5);
R_length_AVR =data(x:y,6);
S_amplitude_AVR =data(x:y,7);
S_length_AVR =data(x:y,8);
T_amplitude_AVR =data(x:y,9);
T_length_AVR =data(x:y,10);
odstep_PQ_AVR =data(x:y,11);
odstep_QT_AVR =data(x:y,12);
zespol_QRS_AVR =data(x:y,13);
dcinek_PQ_AVR =data(x:y,14);
odcinek_ST_AVR =data(x:y,15);
HR =data(x:y,16);
RR_interwal_AVR=data(x:y,17); 
GRUPA =data(x:y,18);
ID =data(x:y,19);

%
[idx1,C1]=fun_clustering(P_amplitude_AVR);
[idx2,C2]=fun_clustering(P_length_AVR);
[idx3,C3]=fun_clustering(Q_amplitude_AVR);
[idx4,C4]=fun_clustering(Q_length_AVR);
[idx5,C5]=fun_clustering(R_amplitude_AVR);
[idx6,C6]=fun_clustering(R_length_AVR);
[idx7,C7]=fun_clustering(S_amplitude_AVR);
[idx8,C8]=fun_clustering(S_length_AVR);
[idx9,C9]=fun_clustering(T_amplitude_AVR);
[idx10,C10]=fun_clustering(T_length_AVR);
[idx11,C11]=fun_clustering(odstep_PQ_AVR);
[idx12,C12]=fun_clustering(odstep_QT_AVR)
[idx13,C13]=fun_clustering(zespol_QRS_AVR)
[idx14,C14]=fun_clustering(dcinek_PQ_AVR)
[idx15,C15]=fun_clustering(odcinek_ST_AVR)
[idx16,C16]=fun_clustering(HR)
[idx17,C17]=fun_clustering(RR_interwal_AVR)


%
klasyfikacja=zeros(length(idx1),1);
n=17 % liczba cech
for j=1:n % dla j-tej cechy
    
    switch j
    case 1
        idx=idx1
    case 2
        idx=idx2
    case 3
        idx=idx3
    case 4
        idx=idx4
    case 5
        idx=idx5
    case 6
        idx=idx6   
    case 7
        idx=idx7
    case 8
        idx=idx8
    case 9
        idx=idx9
    case 10
        idx=idx10
    case 11
        idx=idx11
    case 12
        idx=idx12
    case 13
        idx=idx13
    case 14
        idx=idx14
    case 15
        idx=idx15
    case 16
        idx=idx16
    case 17
        idx=idx17
    end
    
for i=1:length(idx)
if(idx(i)==1)
    klasyfikacja(i,j)=0;
end
if (idx(i)==2)
    klasyfikacja(i,j)=1;
end
end

end


%

for j=1:length(idx1)
    suma_klasyfikacji(j)=sum(klasyfikacja(j,:));
end

for i=1:length(suma_klasyfikacji)
if(suma_klasyfikacji(i)>n/2)
    ocena(i)=1;
else
    ocena(i)=0;

end
end
%

zdrowy_klas=0;
chory_klas=0;
falszywieZdrowy_klas=0;
falszywieChory_klas=0;
klasyfikacja_poprawna=0;
klasyfikacja_bledna=0;

for i=1:length(ocena)

   if(GRUPA(i)==ocena(i))
       klasyfikacja_poprawna=klasyfikacja_poprawna+1;
       
   else klasyfikacja_bledna=klasyfikacja_bledna+1;
   end
   
end

for i=1:length(ocena)

   if(GRUPA(i)== 1 && ocena(i)==1)
       zdrowy_klas=zdrowy_klas+1;
   end
   if(GRUPA(i)== 0 && ocena(i)==0)
       chory_klas=chory_klas+1;
   end
   
   if(GRUPA(i)==1 && ocena(i)==0)
       falszywieChory_klas= falszywieChory_klas+1;
   end
      if(GRUPA(i)==0 && ocena(i)==1)
          falszywieZdrowy_klas=falszywieZdrowy_klas+1;
          
   end
end

% efektywnoœæ klasyfikacji

zdrowy=length(find(GRUPA==1)); % prawdziwie zdrowy

chory=length(find(GRUPA==0)); % prawdziwie chory




dokladnosc=100*(zdrowy_klas+chory_klas)/(zdrowy+chory)

dokladnosc_zdrowi=100*(zdrowy_klas/(zdrowy))
dokladnosc_chorzy=100*(chory_klas/(chory))
