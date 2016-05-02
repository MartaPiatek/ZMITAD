function [odstep_QT_AVR]=fun_QT(Q_start_index,T_stop_index)
% odstêp QT
fs=1000;
for i=1:min(length(Q_start_index),length(T_stop_index))
    if(Q_start_index(i)~=0 & T_stop_index(i)~=0)
odstep_QT(i)=(abs((T_stop_index(i)-Q_start_index(i))))/fs;

    end
end
odstep_QT_AVR=mean(odstep_QT)
end