GRUPA=0; % grupa kontrolna
%GRUPA=1; % grupa chorych

ID=0552


DANE=[P_amplitude_AVR P_length_AVR Q_amplitude_AVR Q_length_AVR R_amplitude_AVR R_length_AVR ...
    S_amplitude_AVR S_length_AVR T_amplitude_AVR T_length_AVR odstep_PQ_AVR odstep_QT_AVR ...
    zespol_QRS_AVR odcinek_PQ_AVR odcinek_ST_AVR HR RR_interwal_AVR GRUPA ID ]

%%

save patientsDATA.txt DANE -ascii 

%%
save patientsDATA.txt DANE -ascii -append 