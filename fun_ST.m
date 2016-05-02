function [odcinek_ST_AVR]=fun_ST(T_start_index,S_stop_index)

% odcinek ST
fs=1000;
for i=1:min(length(T_start_index),length(S_stop_index))
    if(T_start_index(i)~=0 & S_stop_index(i)~=0)
odcinek_ST(i)=(abs((T_start_index(i)-S_stop_index(i))))/fs;

    end
end
odcinek_ST_AVR=mean(odcinek_ST)

end