function [P_stop_index,P_start_index,P_length_AVR,P_amplitude_AVR]=fun_P_parameters(Q_index,P_index,P_value,ekg)

% obliczanie d³ugoœci i amplitudy za³amka P
fs=1000;
X=ekg/max(ekg);
clear P_stop_ind;
j=1;
while j<length(P_index)
    clear wart_test
    clear wart_test2 
 
wart_test(1)=X(P_index(j)-1);

for i=2:150
wart_test(i)=X(P_index(j)-i);
roznica(i)=P_value(j) -wart_test(i);  

end

diff_roznica=diff(roznica);
diff_roznica_abs=abs(diff_roznica);

    tmp_max=find(diff_roznica_abs==max(diff_roznica_abs));
%     if(length(tmp_max)>1)
       index_max_diff_abs= tmp_max(1);
%     end

  P_start_index(j)=index_max_diff_abs; % pocz¹tek za³amka P
  
 P_start_index(j)=P_index(j)-P_start_index(j);
 
 
 if(sum(abs(X(P_index(j):Q_index(j))-X(P_start_index(j)))<0.01)==0)
     P_stop_index(j)=0;
     P_length(j)=0;
     P_amplitude(j)=(P_value(j)+X(P_start_index(j))); % obliczanie amplitudy za³amka P
    
 else
  P_stop_ind=find(abs(X(P_index(j):Q_index(j))-X(P_start_index(j)))<0.01);
  
  P_stop_index(j)=P_stop_ind(1)+P_index(j); %koniec za³amka P
  
 P_length(j)=(P_stop_index(j)-P_start_index(j))/fs; % obliczanie d³ugoœci za³amka P
 P_amplitude(j)=(P_value(j)+X(P_start_index(j))); % obliczanie amplitudy za³amka P
 end
 
j=j+1;
end

sum_length=0;
number_length=0;
sum_amplitude=0;
number_amplitude=0;

for k=1:length(P_length)
    
    if(P_length(k)~=0)
        number_length=number_length+1;
        sum_length=sum_length+P_length(k);
    end

        if(P_amplitude(k)~=0)
        number_amplitude=number_amplitude+1;
        sum_amplitude=sum_amplitude+P_amplitude(k);
    end
    
end
P_length_AVR=1000*(sum_length/number_length); % œrednia d³ugoœæ za³amka P w sekundach
P_amplitude_AVR=(sum_amplitude/number_amplitude); % œrednia amplituda w mV

P_length_std=std(P_length_AVR); %odchylenie std
P_amplitude_std=std(P_amplitude_AVR);
end