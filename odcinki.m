%% odcinek PQ
fs=1000;
for i=1:min(length(Q_start_index),length(P_stop_index))
    if(Q_start_index(i)~=0 & P_stop_index(i)~=0)
odcinek_PQ(i)=(abs((Q_start_index(i)-P_stop_index(i))))/fs;

    end
end
odcinek_PQ_AVR=mean(odcinek_PQ)

%% odcinek ST
fs=1000;
for i=1:min(length(T_start_index),length(S_stop_index))
    if(T_start_index(i)~=0 & S_stop_index(i)~=0)
odcinek_ST(i)=(abs((T_start_index(i)-S_stop_index(i))))/fs;

    end
end
odcinek_ST_AVR=mean(odcinek_ST)

%% zespó³ QRS
fs=1000;
for i=1:min(length(Q_start_index),length(S_stop_index))
    if(Q_start_index(i)~=0 & S_stop_index(i)~=0)
zespol_QRS(i)=(abs((S_stop_index(i)-Q_start_index(i))))/fs;

    end
end
zespol_QRS_AVR=mean(zespol_QRS)
%% odstêp PQ
fs=1000;
for i=1:min(length(Q_start_index),length(P_start_index))
    if(Q_start_index(i)~=0 & P_start_index(i)~=0)
odstep_PQ(i)=(abs((Q_start_index(i)-P_start_index(i))))/fs;

    end
end
odstep_PQ_AVR=mean(odstep_PQ)
%% odstêp QT
fs=1000;
for i=1:min(length(Q_start_index),length(T_stop_index))
    if(Q_start_index(i)~=0 & T_stop_index(i)~=0)
odstep_QT(i)=(abs((T_stop_index(i)-Q_start_index(i))))/fs;

    end
end
odstep_QT_AVR=mean(odstep_QT)
