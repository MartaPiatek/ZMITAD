function [params]=licz_parametry(wektor_czasowy, dane_ekg)

%parametry na szybko :)
sr=mean(dane_ekg);
minmin=min(dane_ekg);
maxmax=max(dane_ekg);
czest=(wektor_czasowy(2)-wektor_czasowy(1))/2;
amp=maxmax-minmin;
Ps=mean((dane_ekg).^2);
RMS=sqrt(Ps);
N=length(wektor_czasowy);
t=N*czest;
params ={cat(2,'srednia[mV]: ',num2str(sr));
    cat(2,'minimum[mV]: ',mat2str(minmin));
    cat(2,'maksimum[mV]:  ',mat2str(maxmax));
    cat(2,'cz�stotlwios� sygna�u[Hz]:  ',mat2str(czest)) ; 
    cat(2,'amplituda sygna�u[mV]:  ',mat2str(amp)); 
    cat(2,'moc sygna�u [dB]:  ',mat2str(Ps));  
    cat(2,'wartosc skuteczna[mV]:  ',num2str(RMS));
    cat(2,'dlugo�� sygna�u[s]:  ',num2str(t));
    };