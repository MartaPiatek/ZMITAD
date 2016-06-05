DATA=load('analiza.txt');

X=DATA(:,1:17);
Y=DATA(:,18);
%%
CVMdl = fitcnb(X,Y,'Holdout',0.30,...
    'ClassNames',{'0','1'});
CMdl = CVMdl.Trained{1};         
testIdx = test(CVMdl.Partition); 
XTest = X(testIdx,:);
YTest = Y(testIdx);

idx = randsample(sum(testIdx),10);
label = predict(CMdl,XTest);
table(YTest(idx),label(idx),'VariableNames',...
    {'TrueLabel','PredictedLabel'})

%%

 plotconfusion(YTest',wynik)
%%

for i=1:length(label)
wynik(i)=str2num(label{i});
end