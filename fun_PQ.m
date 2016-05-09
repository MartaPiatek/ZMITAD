function [odcinek_PQ_AVR,odstep_PQ_AVR]=fun_PQ(P_start_index,P_stop_index,Q_start_index)

% odcinek PQ

fs=1000;
for i=1:min(length(Q_start_index),length(P_stop_index))
    if(Q_start_index(i)~=0 & P_stop_index(i)~=0)
odcinek_PQ(i)=(abs((Q_start_index(i)-P_stop_index(i))))/fs;

    end
end
odcinek_PQ_AVR=mean(odcinek_PQ);

% odstêp PQ

for i=1:min(length(Q_start_index),length(P_start_index))
    if(Q_start_index(i)~=0 & P_start_index(i)~=0)
odstep_PQ(i)=(abs((Q_start_index(i)-P_start_index(i))))/fs;

    end
end
odstep_PQ_AVR=mean(odstep_PQ)


end