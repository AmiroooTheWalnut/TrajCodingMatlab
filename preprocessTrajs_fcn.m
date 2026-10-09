function [width,height,uniqueColors,numColors,simDuration,numEntry,numExit,simulationTime,entryColor,allTrajStates,allTrajTimesteps,entryColorCodes,allTrajs,minX,maxX,minY,maxY,exitLatLon,numIsolatedTrajIndices,numTrajJumps]=preprocessTrajs_fcn(dataName,dataNameDebug,saveName,dropChance,isVisualize,numGrid)
% dataName='trajPhoenixNorthWest_tiny.csv'
% dataNameDebug='trajPhoenixNorthWest_tiny_debug.csv'
opts = detectImportOptions(dataName);
opts = setvartype(opts, 5, 'string');
rawTrajs = readtable(dataName,opts);

opts = detectImportOptions(dataNameDebug);
opts = setvartype(opts, 4, 'string');
rawTrajsDebug = readtable(dataNameDebug,opts);

trajMatDebug=table2array([rawTrajsDebug(:,2),rawTrajsDebug(:,3)]);
uTraj=unique(trajMatDebug,'rows');

minX=min(uTraj(:,2));
maxX=max(uTraj(:,2));
minY=min(uTraj(:,1));
maxY=max(uTraj(:,1));
marginValue=0.02;
minXTemp=minX-(maxX-minX)*marginValue;
maxXTemp=maxX+(maxX-minX)*marginValue;
minYTemp=minY-(maxY-minY)*marginValue;
maxYTemp=maxY+(maxY-minY)*marginValue;
minX=minXTemp;
maxX=maxXTemp;
minY=minYTemp;
maxY=maxYTemp;
width=(maxX-minX)/numGrid;
height=(maxY-minY)/numGrid;

if isVisualize==1
    figure(1)
    clf
    hold on
    imagesc([-112.2737 -111.874], [33.431 33.688], downtownImg);
    drawBaseMap(uTraj,rawTrajsDebug,150);
    % figure(2)
    % clf
end
strEE=table2array(rawTrajsDebug(size(rawTrajsDebug,1),1));
strEE=strEE{1,1};
strEESplit=split(strEE,'_');
numEntry=str2num(strEESplit{1,1})+1;
numExit=str2num(strEESplit{2,1})+1;
allTrajs=cell(numEntry,numExit);
allTrajTimesteps=cell(numEntry,numExit);


%
% STATE -2 MEANS THAT TRAJECTORY HAS NOT STARTED TO SIMULATE
% STATE -1 MEANS THAT TRAJECTORY SIMULATION HAS FINISHED
% STATE >=1 MEANS THAT TRAJECTORY IS SIMULATING REPRESENTING THE LAST
%   ACTIVE INDEX IN THE TRAJECTORY
% SECOND COLUMN IS THE INDEX OF TRAJECOTRY
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

entryLatLon(numEntry,2)=0;
exitLatLon(numEntry,2)=0;
isFirst=1;
lastEE='';
for m=1:size(rawTrajsDebug,1)
    splitVals=split(rawTrajsDebug{m,1}{1,1},'_');
    entryVal=str2num(splitVals{1,1});
    exitVal=str2num(splitVals{2,1});
    if isFirst==1
        entryLatLon(entryVal+1,:)=[rawTrajsDebug{m,2},rawTrajsDebug{m,3}];
        isFirst=0;
        lastEE=rawTrajsDebug{m,1}{1,1};
    else
        if strcmp(rawTrajsDebug{m,1}{1,1},lastEE)==0
            splitVals=split(rawTrajsDebug{m-1,1}{1,1},'_');
            % entryValPrev=str2num(splitVals{1,1});
            exitValPrev=str2num(splitVals{2,1});
            exitLatLon(exitValPrev+1,:)=[rawTrajsDebug{m-1,2},rawTrajsDebug{m-1,3}];
            entryLatLon(entryVal+1,:)=[rawTrajsDebug{m,2},rawTrajsDebug{m,3}];
            isFirst=0;
            lastEE=rawTrajsDebug{m,1}{1,1};
        end
    end
end

isStartFound=0;
prevTraj=-1;
rejectingTraj=-1;
for i=1:size(rawTrajs,1)
    % for i=1:10000
    if mod(i,10000)==0
        disp(i)
    end
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
        if rejectingTraj==rawTrajs{i,1}
            continue
        end
        if rand(1,1)<dropChance
            rejectingTraj=rawTrajs{i,1};
            continue
        end
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
idCounter=1;
for m=1:size(allTrajStates,1)
    for n=1:size(allTrajStates,2)
        for o=1:size(allTrajStates{m,n},1)
            allTrajStates{m,n}(o,2)=idCounter;
            idCounter=idCounter+1;
        end
    end
end

% ROW IS TRAJ ID, VALUE IS NUMBER OF REPEATS
numIsolatedTrajIndices(idCounter-1,1)=0;
numTrajJumps(idCounter-1,1)=0;

% FINISHED PREPROCESSING ALL TRAJECTORIES, READY TO START SIMULATION
% FIND EARLIEST TIME
% simulationTime=allTrajTimesteps{1,1}{1,1}{1,1};
simulationTime=datetime("2028-03-01T18:53:40","InputFormat","yyyy-MM-dd'T'HH:mm:ss");
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
% endTime=allTrajTimesteps{1,1}{1,1}{1,1};
endTime=datetime("2008-03-01T18:53:40","InputFormat","yyyy-MM-dd'T'HH:mm:ss");
for i=1:size(allTrajTimesteps,1)
    for j=1:size(allTrajTimesteps,2)
        for k=1:size(allTrajTimesteps{i,j},1)
            lastIndex=size(allTrajTimesteps{i,j}{k,1},1);
            if allTrajTimesteps{i,j}{k,1}{lastIndex,1}>endTime
                endTime=allTrajTimesteps{i,j}{k,1}{lastIndex,1};
            end
        end
    end
end
disp("!")
% ASSIGN COLOR TO ENTRIES
entryColor=cell(numEntry,1);
counter=1;
for i=1:numEntry
    temp(numEntry,3)=0;
    counterInternal=1;
    for j=0:1/(numEntry):1-1/(numEntry)
        temp(counterInternal,:)=hsv2rgb([j,1,1]);
        counterInternal=counterInternal+1;
    end
    entryColor{counter,1}=temp;
    counter=counter+1;
    temp=[];
end
% for i=0:1/(numEntry):1-1/(numEntry)
%     entryColor{counter,1}=hsv2rgb([i,1,1]);
%     counter=counter+1;
% end

% entryColor{1,1}=[1,0,0;0,1,0;0,0,1;1,0,1];
% entryColor{2,1}=[1,0,0;0,1,0;0,0,1;1,0,1];
% entryColor{3,1}=[1,0,0;0,1,0;0,0,1;1,0,1];
% entryColor{4,1}=[1,0,0;0,1,0;0,0,1;1,0,1];

entryColorCodes(numEntry,numEntry)=0;
allColors=[];
for i=1:size(entryColor,1)
    for j=1:size(entryColor{i,1},1)
        allColors(size(allColors,1)+1,:)=entryColor{i,1}(j,:);
    end
end
uniqueColors=unique(allColors,'rows');
numColors=size(uniqueColors,1);

for i=1:size(entryColor,1)
    for j=1:size(entryColor{i,1},1)
        for k=1:size(uniqueColors,1)
            if uniqueColors(k,:)==entryColor{i,1}(j,:)
                entryColorCodes(i,j)=k;
            end
        end
    end
end

simDuration=seconds(endTime-simulationTime);
save(saveName)