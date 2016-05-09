function [RR_interwal_AVR]=fun_RR_interval(R_index)

% obliczanie interwa�u RR
for i=1:length(R_index)-1
RR_interwal(i)=R_index(i+1)-R_index(i);
end

RR_interwal_AVR=mean(RR_interwal) % �rednia d�ugo�� interwa�u RR
RR_interwal_STD=std(RR_interwal) % odchylenie standardowe
end
