function [R_stop_index,R_start_index,R_length_AVR,R_amplitude_AVR]=fun_R_parameters(S_index,R_value,R_index,ekg)

% obliczanie d³ugoœci i amplitudy za³amka R
X=ekg/max(ekg);
fs=1000;

clear R_stop_ind;
j=1;
while j<length(R_index)
    clear wart_test
     
wart_test(1)=X(R_index(j)-1);

for i=2:150
wart_test(i)=X(R_index(j)-i);
roznica(i)=R_value(j) -wart_test(i);  

end

diff_roznica=diff(roznica);
diff_roznica_abs=abs(diff_roznica);

    tmp_max=find(diff_roznica_abs==max(diff_roznica_abs));
%     if(length(tmp_max)>1)
       index_max_diff_abs= tmp_max(1);
%     end

  R_start_index(j)=index_max_diff_abs; % pocz¹tek za³amka Q
  
 R_start_index(j)=R_index(j)-R_start_index(j);
 
 
 if(sum(abs(X(R_index(j):S_index(j))-X(R_start_index(j)))<0.01)==0)
     R_stop_index(j)=0;
     R_length(j)=0;
     R_amplitude(j)=(R_value(j)+X(R_start_index(j))); % obliczanie amplitudy za³amka R
    
  else
  R_stop_ind=find(abs(X(R_index(j):S_index(j))-X(R_start_index(j)))<0.01);
  
  R_stop_index(j)=R_stop_ind(1)+R_index(j); %koniec za³amka Q
  
 R_length(j)=(R_stop_index(j)-R_start_index(j))/fs ;% obliczanie d³ugoœci za³amka R
 R_amplitude(j)=(R_value(j)+X(R_start_index(j))); % obliczanie amplitudy za³amka R
 end
 
j=j+1;
end

sum_length=0;
number_length=0;
sum_amplitude=0;
number_amplitude=0;

for k=1:length(R_length)
    
    if(R_length(k)~=0)
        number_length=number_length+1;
        sum_length=sum_length+R_length(k);
    end

        if(R_amplitude(k)~=0)
        number_amplitude=number_amplitude+1;
        sum_amplitude=sum_amplitude+R_amplitude(k);
    end
    
end
R_length_AVR=1000*sum_length/number_length % œrednia d³ugoœæ za³amka R w sekundach

R_amplitude_AVR=(sum_amplitude/number_amplitude) % œrednia amplituda R w mV

R_length_std=std(R_length_AVR); %odchylenie std
R_amplitude_std=std(R_amplitude_AVR);
end