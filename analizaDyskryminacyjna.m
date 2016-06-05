data=load('patientsDATA.txt');
data2=data(:,1:17)
groups=data(:,18)


%%


lda = fitcdiscr(data2(:,1:17),groups,'DiscrimType','Linear'); % linear discriminant analysis (LDA).
ldaClass = resubPredict(lda);

ldaResubErr = resubLoss(lda) % b³¹d klasyfikacji 

[ldaResubCM,grpOrder] = confusionmat(groups,ldaClass) % macierz b³êdów

% bad = ~strcmp(ldaClass,groups);
% hold on;
% plot(data2(bad,1), data2(bad,2), 'kx');
% hold off;

chorzy_klas=ldaResubCM(1,1)
falszywieChory=ldaResubCM(2,2)
zdrowi_klas=ldaResubCM(2,1)
falszywieZdrowi=ldaResubCM(2,1)

dokladnosc_zdrowi=100*zdrowi_klas/(chorzy_klas+falszywieChory+zdrowi_klas+falszywieZdrowi)
dokladnosc_chorzy=100*chorzy_klas/(chorzy_klas+falszywieChory+zdrowi_klas+falszywieZdrowi)

dokladnosc=100*(chorzy_klas+zdrowi_klas)/(chorzy_klas+falszywieChory+zdrowi_klas+falszywieZdrowi)
