data=load('patientsDATA.txt');
%%
data=load('analiza.txt');
%%
indCH=find(data(:,18)==0)
indZ=find(data(:,18)==1)

liczbaZ=length(indZ)
liczbaCH=length(indCH)

x=randi(liczbaCH,1,liczbaZ) % losowanie chorych 
    
  indWyb=indCH(x)  

ch=data(indWyb,:)

zd=data(indZ,:)

DATA(1:length(indZ),:)=zd;
DATA(length(indZ)+1:length(indZ)+length(indWyb) ,:)=ch;

X=DATA(:,1:17);
Y=DATA(:,18);

%%

ctree = ClassificationTree.fit(X,Y,'Holdout',0.30,'ClassNames',{'0','1'}) %Utw�rz drzewo decyzyjne


CMdl = ctree.Trained{1};         
testIdx = test(ctree.Partition); 
XTest = X(testIdx,:);
YTest = Y(testIdx);

idx = randsample(sum(testIdx),10);
label = predict(CMdl,XTest);
table(YTest(idx),label(idx),'VariableNames',...
    {'TrueLabel','PredictedLabel'})
%%
for i=1:length(label)
wynik(i)=str2num(label{i});
end
%%
plotconfusion(YTest',label')

%%

%view(ctree,'mode','graph');    %graficzna reprezentacja drzewa
  view(ctree); %regu�owa reprezentacja drzewa 
  
  %%
  Ynew = predict(ctree,X); %klasy dla ka�dego przyk�adu trenuj�cego
  
  %%
  
  plotconfusion(Y',Ynew') % macierz przek�ama�
  %%
  for i=2:100
      m(i)=i;
tree = ClassificationTree.fit(X,Y,'crossval','on','minleaf',m(i)); %m � minimalna liczba przyk�ad�w w li�ciu
blad(i) = kfoldLoss(tree); %b��d kroswalidacji w i-tej iteracji

  end
  figure;plot(blad)
  %%
  OptimalTree = ClassificationTree.fit(X,Y,'minleaf',13); 
view(OptimalTree,'mode','graph'); 

%%

errOpt1 = resubLoss(OptimalTree) %b��d na zbiorze ucz�cym dla OptimalTree
err1 = resubLoss(ctree) %b��d na zbiorze ucz�cym dla ctree
errOpt2 = kfoldLoss(crossval(OptimalTree)) %b��d kroswalidacji dla OptimalTree 
err2 = kfoldLoss(crossval(ctree)) %b��d kroswalidacji dla ctree

%%

[~,~,~,bestlevel] = cvLoss(ctree,'subtrees','all','treesize','min') 

PruneTree = prune(ctree,'Level',bestlevel); 
view(PruneTree,'mode','graph'); 
errBest1 = resubLoss(ctree) %b��d na zbiorze ucz�cym dla ctree
errBest2 = kfoldLoss(crossval(ctree)) %b��d kroswalidacji dla ctree


