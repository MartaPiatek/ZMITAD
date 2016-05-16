data=load('patientsDATA.txt');
data2=data(:,1:17)
[coeff,score,latent,tsquared,explained]  = pca(data2)
figure()
pareto(explained)
xlabel('Principal Component')
ylabel('Variance Explained (%)')