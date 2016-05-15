data=load('patientsDATA.txt');
data2=data(:,1:17)
[coeff,score,latent]  = pca(data2)