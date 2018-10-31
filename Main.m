clear all;
%Loading the KD cup 99 dataset. The original data set comprises of 41
%attributes which was reduced to 34 after removing the symbolic attributes.
load('proj_data.mat');
%Initializing a matrix with all values equal to zero
cnt=zeros(1,34);
% APRIORI ALGORITHM ; Mining frequent 1-length item sets - evaluating the 
% frequency of continuous variables of each attribute (Modifies Binary 
% Apriori Algorithm for continuous features)
for i=1:34
    for j=1:211791
        if(project1(j,i)~=0)
            cnt(1,i)=cnt(1,i)+1;
        end
    end
end
% setting support equal to 100. We identified the attributes which affected
% only one of the five possibilities and removed them as they had no impact
% on classification.
tot=0;
for i=1:34
    if(cnt(1,i)>=100)
        tot=tot+1;
        dataAfterApriori(:,tot)=project1(:,i);
    end
end
%tot = 23; 11 attributes were found insignificant
normalData=dataAfterApriori(1:98468,:);
attackData=dataAfterApriori(98469:211791,:);

%Finding range of each attribute for normal and attack data and if the
%range came out equal, we removed the corrosponding attribute. 
rangeNormal=max(normalData)-min(normalData);
rangeAttack=max(attackData)-min(attackData);

isRangeEqual=zeros(1,tot);
for i=1:tot
    if(rangeNormal(1,i)==rangeAttack(1,i))
        isRangeEqual(1,i)=1;
    end
end

tot2=0;
for i=1:tot
    if(isRangeEqual(1,i)==0)
        tot2=tot2+1;
        dataWithSignificantFeatures(:,tot2)=dataAfterApriori(:,i);
    end
end
% tot2 = 14; By the end of the pre-processing step, only 14 significant
% attributes remain

% Defining the 15th column by the output column of the initial dataset 
dataWithSignificantFeatures(:,tot2+1)=project1(:,35);

shuffledArray = dataWithSignificantFeatures(randperm(size(dataWithSignificantFeatures,1)),:);

%splitting the complete dataset into training and testing datasets in the
%ratio 70:30
training=shuffledArray(1:ceil(0.7*211791),:);
testing=shuffledArray(1+ceil(0.7*211791):211791,:);

%In order to have reproducible results, training testing data once produced
%was stored and loaded for the next part of the code, i.e., Rule Generation
load('training.mat');
training = sortrows(training,tot2+1);

normalData=training(1:68871,1:14);
attackData=training(68872:148254,1:14);

%From this step, we used the Fuzzy toolbox for Fuzzy rule generation and
%filtering. Deviation matrices were used to find the intersection which
%helped in generation of rules.
deviationNormal=[min(normalData);max(normalData)];
deviationAttack=[min(attackData);max(attackData)];