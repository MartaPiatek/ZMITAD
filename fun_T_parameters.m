function [T_length_AVR,T_amplitude_AVR]=fun_T_parameters(P_index,T_value,T_index,ekg)

% obliczanie d³ugoœci i amplitudy za³amka T
fs=1000;
X=ekg/max(ekg);

clear T_stop_ind;
j=1;
while j<length(T_index)-1
    clear wart_test
     
wart_test(1)=X(T_index(j)-1);

for i=2:150
wart_test(i)=X(T_index(j)-i);
roznica(i)=T_value(j) -wart_test(i);  

end

diff_roznica=diff(roznica);
diff_roznica_abs=abs(diff_roznica);

    tmp_max=find(diff_roznica_abs==max(diff_roznica_abs));
%     if(length(tmp_max)>1)
       index_max_diff_abs= tmp_max(1);
%     end

  T_start_index(j)=index_max_diff_abs; % pocz¹tek za³amka Q
  
 T_start_index(j)=T_index(j)-T_start_index(j);
 
 
 if(sum(abs(X(T_index(j):P_index(j+1))-X(T_start_index(j)))<0.01)==0)
     T_stop_index(j)=0;
     T_length(j)=0;
     T_amplitude(j)=(T_value(j)+X(T_start_index(j))); % obliczanie amplitudy za³amka S
    
 else
  T_stop_ind=find(abs(X(T_index(j):P_index(j+1))-X(T_start_index(j)))<0.01);
  
  T_stop_index(j)=T_stop_ind(1)+T_index(j); %koniec za³amka Q
  
 T_length(j)=(T_stop_index(j)-T_start_index(j))/fs ;% obliczanie d³ugoœci za³amka Q
 T_amplitude(j)=(T_value(j)+X(T_start_index(j))); % obliczanie amplitudy za³amka Q
 end
 
j=j+1;
end

sum_length=0;
number_length=0;
sum_amplitude=0;
number_amplitude=0;

for k=1:length(T_length)
    
    if(T_length(k)~=0)
        number_length=number_length+1;
        sum_length=sum_length+T_length(k);
    end

        if(T_amplitude(k)~=0)
        number_amplitude=number_amplitude+1;
        sum_amplitude=sum_amplitude+T_amplitude(k);
    end
    
end
T_length_AVR=1000*sum_length/number_length % œrednia d³ugoœæ za³amka T w sekundach

T_amplitude_AVR=sum_amplitude/number_amplitude % œrednia amplituda T w mV

T_length_std=std(T_length_AVR); %odchylenie std
T_amplitude_std=std(T_amplitude_AVR);
end