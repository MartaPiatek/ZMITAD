DATA=load('patientsDATA.txt');

X=DATA(:,1:17);
Y=DATA(:,18);

Mdl = fitcknn(X,Y,'NumNeighbors',8,'Holdout',0.30,'ClassNames',{'0','1'})


%%

ModM = Mdl.Trained{1};         
testIdx = test(Mdl.Partition); 
XTest = X(testIdx,:);
YTest = Y(testIdx);

idx = randsample(sum(testIdx),10);
label = predict(ModM,XTest);
table(YTest(idx),label(idx),'VariableNames',...
    {'TrueLabel','PredictedLabel'})
plotconfusion(YTest',label')

%%

[label,score,cost] = predict(Mdl,X)
rloss = resubLoss(Mdl)
rng('default')
cvmdl = crossval(Mdl,'kfold',8);
kloss = kfoldLoss(cvmdl)
