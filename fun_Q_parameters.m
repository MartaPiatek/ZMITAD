function [Q_length_AVR,Q_amplitude_AVR]=fun_Q_parameters(R_index,Q_value,Q_index,ekg)

% obliczanie d³ugoœci i amplitudy za³amka Q
fs=1000;
X=ekg/max(ekg);

clear Q_stop_ind;
j=1;
while j<length(Q_index)
    clear wart_test
    clear wart_test2 
 
wart_test(1)=X(Q_index(j)-1);

for i=2:150
wart_test(i)=X(Q_index(j)-i);
roznica(i)=Q_value(j) -wart_test(i);  

end

diff_roznica=diff(roznica);
diff_roznica_abs=abs(diff_roznica);

    tmp_max=find(diff_roznica_abs==max(diff_roznica_abs));
%     if(length(tmp_max)>1)
       index_max_diff_abs= tmp_max(1);
%     end

  Q_start_index(j)=index_max_diff_abs; % pocz¹tek za³amka Q
  
 Q_start_index(j)=Q_index(j)-Q_start_index(j);
 
 
 if(sum(abs(X(Q_index(j):R_index(j))-X(Q_start_index(j)))<0.01)==0)
     Q_stop_index(j)=0;
     Q_length(j)=0;
     Q_amplitude(j)=(Q_value(j)+X(Q_start_index(j))); % obliczanie amplitudy za³amka Q
    
 else
  Q_stop_ind=find(abs(X(Q_index(j):R_index(j))-X(Q_start_index(j)))<0.01);
  
  Q_stop_index(j)=Q_stop_ind(1)+Q_index(j); %koniec za³amka Q
  
 Q_length(j)=(Q_stop_index(j)-Q_start_index(j))/fs ;% obliczanie d³ugoœci za³amka Q
 Q_amplitude(j)=(Q_value(j)+X(Q_start_index(j))); % obliczanie amplitudy za³amka Q
 end
 
j=j+1;
end

sum_length=0;
number_length=0;
sum_amplitude=0;
number_amplitude=0;

for k=1:length(Q_length)
    
    if(Q_length(k)~=0)
        number_length=number_length+1;
        sum_length=sum_length+Q_length(k);
    end

        if(Q_amplitude(k)~=0)
        number_amplitude=number_amplitude+1;
        sum_amplitude=sum_amplitude+Q_amplitude(k);
    end
    
end
Q_length_AVR=1000*sum_length/number_length % œrednia d³ugoœæ za³amka Q w sekundach

Q_amplitude_AVR=sum_amplitude/number_amplitude % œrednia amplituda Q w mV

Q_length_std=std(Q_length_AVR); %odchylenie std
Q_amplitude_std=std(Q_amplitude_AVR);
end