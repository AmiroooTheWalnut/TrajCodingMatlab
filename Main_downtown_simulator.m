clc
clear
opts = detectImportOptions('trajTucsonDowntown.csv');
opts = setvartype(opts, 5, 'string');
rawTrajs = readtable('trajTucsonDowntown.csv',opts);

opts = detectImportOptions('trajTucsonDowntown_debug.csv');
opts = setvartype(opts, 4, 'string');
rawTrajsDebug = readtable('trajTucsonDowntown_debug.csv',opts);

trajMatDebug=table2array([rawTrajsDebug(:,2),rawTrajsDebug(:,3)]);
uTraj=unique(trajMatDebug,'rows');

figure(1)
clf
hold on
drawBaseMap(uTraj,rawTrajsDebug);
numEntry=4;
numExit=4;
allTrajs=cell(numEntry,numExit);
allTrajTimesteps=cell(numEntry,numExit);

%
% STATE -2 MEANS THAT TRAJECTORY HAS NOT STARTED TO SIMULATE
% STATE -1 MEANS THAT TRAJECTORY SIMULATION HAS FINISHED
% STATE >=1 MEANS THAT TRAJECTORY IS SIMULATING REPRESENTING THE LAST
%   ACTIVE INDEX IN THE TRAJECTORY
allTrajStates=cell(numEntry,numExit);

%
% THE INDEX OF THE COLOR IS STORED. THE COLOR IS EXTRACTED BY USING THE
% "entryColor" VARIABLE
%
simTrajColors=cell(numEntry,numExit);
for i=1:numEntry
    for j=1:numExit
        allTrajs{i,j}=cell(0,1);
        simTrajColors{i,j}=cell(0,1);
        allTrajStates{i,j}=cell(0,1);
        allTrajTimesteps{i,j}=cell(0,1);
    end
end

isStartFound=0;
prevTraj=-1;
for i=1:size(rawTrajs,1)
%     if i==302
%         disp('!!!')
%     end
    if isStartFound==1
        if prevTraj~=rawTrajs{i,1}
            isStartFound=0;
        end
    end
    vals=split(rawTrajs{i,2}{1,1},'_');
    if isStartFound==0
        if exist("buildingTrajs","var")==1
            allTrajs{inInd+1,outInd+1}{size(allTrajs{inInd+1,outInd+1},1)+1,1}=buildingTrajs;
            allTrajTimesteps{inInd+1,outInd+1}{size(allTrajTimesteps{inInd+1,outInd+1},1)+1,1}=buildingTimes;
        end
    end
    inInd=str2num(vals{1,1});
    outInd=str2num(vals{2,1});
    if isStartFound==0
        buildingTrajs=[];
        buildingTimes=cell(0,1);
%         pause(2)
%         figure(1)
%         clf
%         hold on
        trajStartLat=rawTrajs{i,3};
        trajStartLon=rawTrajs{i,4};
        % scatter(trajStartLon,trajStartLat,75,[0,0,1],'filled')
        isStartFound=1;
        prevTraj=rawTrajs{i,1};
        if i~=1 && i~=size(rawTrajs,1)
            trajEndLat=rawTrajs{i-1,3};
            trajEndLon=rawTrajs{i-1,4};
            % scatter(trajEndLon,trajEndLat,75,[1,0,0],'filled')
        end
        if i==size(rawTrajs,1)
            trajEndLat=rawTrajs{i-1,3};
            trajEndLon=rawTrajs{i-1,4};
            % scatter(trajEndLon,trajEndLat,75,[1,0,0],'filled')
        end
        buildingTrajs(size(buildingTrajs,1)+1,1)=trajStartLat;
        buildingTrajs(size(buildingTrajs,1),2)=trajStartLon;
        try
            d=datetime(rawTrajs{i,5},"InputFormat","yyyy-MM-dd'T'HH:mm:ss");
        catch
            try
                d=datetime(rawTrajs{i,5},"InputFormat","yyyy-MM-dd'T'HH:mm");
            catch exception
                rethrow(exception)
            end
        end
        buildingTimes{size(buildingTimes,1)+1,1}=d;
    else
        trajLat=rawTrajs{i,3};
        trajLon=rawTrajs{i,4};
        buildingTrajs(size(buildingTrajs,1)+1,1)=trajLat;
        buildingTrajs(size(buildingTrajs,1),2)=trajLon;
        try
            d=datetime(rawTrajs{i,5},"InputFormat","yyyy-MM-dd'T'HH:mm:ss");
        catch
            try
                d=datetime(rawTrajs{i,5},"InputFormat","yyyy-MM-dd'T'HH:mm");
            catch exception
                rethrow(exception)
            end
        end
        buildingTimes{size(buildingTimes,1)+1,1}=d;
        if i~=size(rawTrajs,1)
            trajLatNext=rawTrajs{i-1,3};
            trajLonNext=rawTrajs{i-1,4};
            % line([trajLon,trajLonNext],[trajLat,trajLatNext],'color',[0.2,1,0.2],'LineWidth',4)
        end
        % scatter(trajLon,trajLat,30,[0.8,1,0],'filled')
    end
    % pause(0.02)
end
allTrajs{inInd+1,outInd+1}{size(allTrajs{inInd+1,outInd+1},1)+1,1}=buildingTrajs;
allTrajTimesteps{inInd+1,outInd+1}{size(allTrajTimesteps{inInd+1,outInd+1},1)+1,1}=buildingTimes;
for i=1:size(allTrajs,1)
    for j=1:size(allTrajs,2)
        allTrajStates{i,j}=zeros([size(allTrajs{i,j},1),1])-2;
        simTrajColors{i,j}=zeros([size(allTrajs{i,j},1),1]);
    end
end
% FINISHED PREPROCESSING ALL TRAJECTORIES, READY TO START SIMULATION
% FIND EARLIEST TIME
simulationTime=allTrajTimesteps{1,1}{1,1}{1,1};
for i=1:size(allTrajTimesteps,1)
    for j=1:size(allTrajTimesteps,2)
        for k=1:size(allTrajTimesteps{i,j},1)
            if allTrajTimesteps{i,j}{k,1}{1,1}<simulationTime
                simulationTime=allTrajTimesteps{i,j}{k,1}{1,1};
            end
        end
    end
end
% FIND LAST TIME
endTime=allTrajTimesteps{1,1}{1,1}{1,1};
for i=1:size(allTrajTimesteps,1)
    for j=1:size(allTrajTimesteps,2)
        for k=1:size(allTrajTimesteps{i,j},1)
            lastIndex=size(allTrajTimesteps{i,j}{k,1},1);
            if allTrajTimesteps{i,j}{k,1}{lastIndex,1}>endTime
                endTime=allTrajTimesteps{i,j}{k,1}{k,1};
            end
        end
    end
end
disp("!")
% ASSIGN COLOR TO ENTRIES
entryColor=cell(numEntry,1);
entryColor{1,1}=[1,0,0;0,0,1];
entryColor{2,1}=[0,1,0;0,0,1];
entryColor{3,1}=[1,0,0;0,1,0];
entryColor{4,1}=[1,0,0;0,0,1];

duration=seconds(endTime-simulationTime);
% START SIMULATION
currentTime=simulationTime;
for i=1:duration
    for m=1:size(allTrajStates,1)
        for n=1:size(allTrajStates,2)
            for o=1:size(allTrajStates{m,n},1)
                if allTrajStates{m,n}(o,1)==-2
                    if allTrajTimesteps{m,n}{o,1}{1,1}>=currentTime
                        allTrajStates{m,n}(o,1)=1;
                        colorIndex=1+floor(rand(1,1)*size(entryColor{m,1},1));
                        simTrajColors{m,n}(o,1)=colorIndex;
                    end
                elseif allTrajStates{m,n}(o,1)>0
                    lastIndex=size(allTrajTimesteps{m,n}{o,1},1);
                    if allTrajTimesteps{m,n}{o,1}{lastIndex,1}<currentTime
                        allTrajStates{m,n}(o,1)=-1;
                    elseif allTrajTimesteps{m,n}{o,1}{allTrajStates{m,n}(o,1)+1,1}<=currentTime
                        allTrajStates{m,n}(o,1)=allTrajStates{m,n}(o,1)+1;
                    end
                end
            end
        end
    end
    figure(1)
    clf
    hold on
    drawBaseMap(uTraj,rawTrajsDebug);
    for m=1:size(allTrajStates,1)
        for n=1:size(allTrajStates,2)
            for o=1:size(allTrajStates{m,n},1)
                if allTrajStates{m,n}(o,1)>0
                    ind=allTrajStates{m,n}(o,1);
                    scatter(allTrajs{m,n}{o,1}(ind,2),allTrajs{m,n}{o,1}(ind,1),80,simTrajColors{m,n}(o,1))
                end
            end
        end
    end
    pause(1)
    currentTime=currentTime+seconds(1)
end

function drawBaseMap(uTraj,rawTrajsDebug)
% scatter(uTraj(:,2),uTraj(:,1),[],[0,0,1])
for i=2:size(rawTrajsDebug,1)
    if strcmp(rawTrajsDebug{i,1},rawTrajsDebug{i-1,1})==1
        trajLat=rawTrajsDebug{i,2};
        trajLon=rawTrajsDebug{i,3};
        trajLatNext=rawTrajsDebug{i-1,2};
        trajLonNext=rawTrajsDebug{i-1,3};
        line([trajLon,trajLonNext],[trajLat,trajLatNext],'color',[0.2,1,0.2],'LineWidth',4)
    end
end
end