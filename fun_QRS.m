function [zespol_QRS_AVR]=fun_QRS(Q_start_index,S_stop_index)

%zespó³ QRS

fs=1000;
for i=1:min(length(Q_start_index),length(S_stop_index))
    if(Q_start_index(i)~=0 & S_stop_index(i)~=0)
zespol_QRS(i)=(abs((S_stop_index(i)-Q_start_index(i))))/fs;

    end
end
zespol_QRS_AVR=mean(zespol_QRS)


end