function [HR]=fun_HR(ekg)

% obliczanie cz�sto�ci pracy serca
fs = 1000;              % cz�stotliwo�� pr�bkowania
N = length (ekg);       % d�ugo�� sygna�u
t = [0:N-1]/fs;        % wektor czasu

HR=(length(R_index))*60/t(end) % liczba uderze� na min

end
