ekg=val(1,:);

% wywo³anie funkcji detekcji
[P_index,P_value,Q_index,Q_value,R_index,R_value,S_index, S_value, T_index, T_value]=detekcja(ekg);

% parametry za³amka P
[P_stop_index,P_start_index,P_length_AVR,P_amplitude_AVR]=fun_P_parameters(Q_index,P_index,P_value,ekg)

% parametry za³amka Q
[Q_stop_index,Q_start_index,Q_length_AVR,Q_amplitude_AVR]=fun_Q_parameters(R_index,Q_value,Q_index,ekg)

% parametry za³amka R
[R_stop_index,R_start_index,R_length_AVR,R_amplitude_AVR]=fun_R_parameters(S_index,R_value,R_index,ekg)

% parametry za³amka S
[S_stop_index,S_start_index,S_length_AVR,S_amplitude_AVR]=fun_S_parameters(T_index,S_value,S_index,ekg)

% parametry za³amka T
[T_stop_index,T_start_index,T_length_AVR,T_amplitude_AVR]=fun_T_parameters(P_index,T_value,T_index,ekg)

% HR 
[HR]=fun_HR(ekg,R_index)

% odstêp RR
[RR_interwal_AVR]=fun_RR_interval(R_index);



%PQ
[odcinek_PQ_AVR,odstep_PQ_AVR]=fun_PQ(P_start_index,P_stop_index,Q_start_index)

%QT
[odstep_QT_AVR]=fun_QT(Q_start_index,T_stop_index)

%QRS
[zespol_QRS_AVR]=fun_QRS(Q_start_index,S_stop_index)

%ST
[odcinek_ST_AVR]=fun_ST(T_start_index,S_stop_index)


