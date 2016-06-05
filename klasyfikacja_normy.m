% co mamy:
%d³ugoœci:

clear
clc
data=load('patientsDATA.txt');

x=1+randi(240);

P_amplitude_AVR=data(x,1);
P_length_AVR=data(x,2);
Q_amplitude_AVR =data(x,3);
Q_length_AVR =data(x,4);
R_amplitude_AVR =data(x,5);
R_length_AVR =data(x,6);
S_amplitude_AVR =data(x,7);
S_length_AVR =data(x,8);
T_amplitude_AVR =data(x,9);
T_length_AVR =data(x,10);
odstep_PQ_AVR =data(x,11);
odstep_QT_AVR =data(x,12);
zespol_QRS_AVR =data(x,13);
dcinek_PQ_AVR =data(x,14);
odcinek_ST_AVR =data(x,15);
HR =data(x,16);
RR_interwal_AVR=data(x,17); 
GRUPA =data(x,18);
ID =data(x,19);


 
 if ((P_length_AVR < 110) && (P_length_AVR > 40 ) && (odstep_PQ_AVR > 0.01) && (odstep_PQ_AVR<0.2) && (Q_length_AVR<100) && (zespol_QRS_AVR < 0.5) && (zespol_QRS_AVR > 0.1) && (T_length_AVR > 60) && (T_length_AVR < 160) && (odcinek_ST_AVR > 0.00002) && (odcinek_ST_AVR < 0.12 )&&(HR < 100) && (HR > 50)&&(R_length_AVR > 10 ) && (odstep_QT_AVR < 0.60)&&(RR_interwal_AVR > 160)&&(T_amplitude_AVR>0.1)) 

    disp('zdrowy')
 else
     disp('chory') 
 end

  