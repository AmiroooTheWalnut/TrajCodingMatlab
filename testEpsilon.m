clc
clear
epsilon=10;
numEntry=4;
numExit=4;
entryColorProb(numEntry,numExit)=0;
cumEntryColorProb(numEntry,numExit)=0;
for i=1:numEntry
    for j=1:numEntry
        if i==j
            entryColorProb(i,j)=exp(epsilon)/(exp(epsilon)+3);
        else
            entryColorProb(i,j)=1/(exp(epsilon)+3);
        end
        if j==1
            cumEntryColorProb(i,j)=entryColorProb(i,j);
        elseif j>1
            cumEntryColorProb(i,j)=cumEntryColorProb(i,j-1)+entryColorProb(i,j);
        end
    end
end