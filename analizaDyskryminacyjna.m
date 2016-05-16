data=load('patientsDATA.txt');
data2=data(:,1:17)
groups=data(:,18)


lda = fitcdiscr(data2(:,1:17),groups,'DiscrimType','Linear'); % linear discriminant analysis (LDA).
ldaClass = resubPredict(lda);

ldaResubErr = resubLoss(lda) % b³¹d klasyfikacji 

[ldaResubCM,grpOrder] = confusionmat(groups,ldaClass) % macierz b³êdów

% bad = ~strcmp(ldaClass,groups);
% hold on;
% plot(data2(bad,1), data2(bad,2), 'kx');
% hold off;