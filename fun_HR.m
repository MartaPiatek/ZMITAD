function [HR]=fun_HR(ekg)

% obliczanie czêstoœci pracy serca
fs = 1000;              % czêstotliwoœæ próbkowania
N = length (ekg);       % d³ugoœæ sygna³u
t = [0:N-1]/fs;        % wektor czasu

HR=(length(R_index))*60/t(end) % liczba uderzeñ na min

end
