% Fuzzy Rules were fed into the Fuzzy toolbox and an FIS file was generated.
% It will then be used to evaluate the Fuzzy System 
clear all;
% Loading the test data to evaluate the fuzzy system developed
load('TrainFuzzy.mat');
% Actual Output is extracted from the original dataset
actualOut=trainingCopy(:,13);
% Output Column removed from the Testing Data
trainingCopy=trainingCopy(:,1:12);
% Loading the FIS file(Fuzzy System)
fismat=readfis('Fuzzy.fis');
% Evaluating the system via the test data
out=evalfis(trainingCopy,fismat);

% Initializing the count to zero
tp=0;
tn=0;
fp=0;
fn=0;
evalOut=zeros(148254,1);
for i=1:148254
% Finding evalOut by comparing the output obtained from the Fuzzy System
% with the set threshold value 
    if(out(i,1)>0.8)
        evalOut(i,1)=1;
    end
% Comparing the evaluated output with the actual Output
    if(evalOut(i,1)==actualOut(i,1))
        tp=tp+1;
        if(evalOut(i,1)==0)
            tn=tn+1;
            tp=tp-1;
        end
    end
    if(evalOut(i,1)~=actualOut(i,1))
        fp=fp+1;
        if(evalOut(i,1)==0)
            fn=fn+1;
            fp=fp-1;
        end
    end
end
% Obtaining the accuracy of the system developed
Aprecision=tp/(tp+fp)
Arecall=tp/(tp+fn)
beta=1;
AfMeasure=((beta^2)+1)*Aprecision*Arecall/(((beta^2)*Aprecision)+Arecall)

Nprecision=tn/(tn+fn)
Nrecall=tn/(tn+fp)
beta=1;
NfMeasure=((beta^2)+1)*Nprecision*Nrecall/(((beta^2)*Nprecision)+Nrecall)

accuracy=(tp+tn)/(tp+tn+fp+fn)