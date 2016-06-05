DATA=load('analiza.txt');

X=DATA(:,1:17);
Y=DATA(:,18);
%%
SVMModel = fitcsvm(X,Y,'Holdout',0.30,'ClassNames',{'0','1'})


SVM1 = SVMModel.Trained{1};         
testIdx = test(SVMModel.Partition); 
XTest = X(testIdx,:);
YTest = Y(testIdx);

idx = randsample(sum(testIdx),10);
label = predict(SVM1,XTest);
table(YTest(idx),label(idx),'VariableNames',...
    {'TrueLabel','PredictedLabel'})


%%

plotconfusion(YTest',label')
