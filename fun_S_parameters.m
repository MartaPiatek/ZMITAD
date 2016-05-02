function [S_stop_index,S_start_index,S_length_AVR,S_amplitude_AVR]=fun_S_parameters(T_index,S_value,S_index,ekg)

% obliczanie d³ugoœci i amplitudy za³amka P
fs=1000;
X=ekg/max(ekg);

clear S_stop_ind;
j=1;
while j<length(S_index)
    clear wart_test
     
wart_test(1)=X(S_index(j)-1);

for i=2:100
wart_test(i)=X(S_index(j)-i);
roznica(i)=S_value(j) -wart_test(i);  

end

diff_roznica=diff(roznica);
diff_roznica_abs=diff_roznica;
%diff_roznica_abs=abs(diff_roznica); %%%%%%%%%%%%%%%%%%%%%%

    tmp_max=find(diff_roznica_abs==min(diff_roznica_abs));%%%%%%%%%% min czy max
%     if(length(tmp_max)>1)
       index_max_diff_abs= tmp_max(1);
%     end

  S_start_index(j)=index_max_diff_abs; % pocz¹tek za³amka Q
  
 S_start_index(j)=S_index(j)-S_start_index(j);
 
 
 if(sum(abs(X(S_index(j):T_index(j))-X(S_start_index(j)))<0.01)==0)
     S_stop_index(j)=0;
     S_length(j)=0;
     S_amplitude(j)=(S_value(j)+X(S_start_index(j))); % obliczanie amplitudy za³amka S
    
 else
  S_stop_ind=find(abs(X(S_index(j):T_index(j))-X(S_start_index(j)))<0.01);
  
  S_stop_index(j)=S_stop_ind(1)+S_index(j); %koniec za³amka Q
  
 S_length(j)=(S_stop_index(j)-S_start_index(j))/fs ;% obliczanie d³ugoœci za³amka Q
 S_amplitude(j)=(S_value(j)+X(S_start_index(j))); % obliczanie amplitudy za³amka Q
 end
 
j=j+1;
end

sum_length=0;
number_length=0;
sum_amplitude=0;
number_amplitude=0;

for k=1:length(S_length)
    
    if(S_length(k)~=0)
        number_length=number_length+1;
        sum_length=sum_length+S_length(k);
    end

        if(S_amplitude(k)~=0)
        number_amplitude=number_amplitude+1;
        sum_amplitude=sum_amplitude+S_amplitude(k);
    end
    
end
S_length_AVR=1000*sum_length/number_length % œrednia d³ugoœæ za³amka S w ms

S_amplitude_AVR=(sum_amplitude/number_amplitude) % œrednia amplituda S w mV

S_length_std=std(S_length_AVR); %odchylenie std
S_amplitude_std=std(S_amplitude_AVR);
end