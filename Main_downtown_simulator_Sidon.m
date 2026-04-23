clc
clear
isVisualize=1;
opts = detectImportOptions('trajTucsonDowntown.csv');
opts = setvartype(opts, 5, 'string');
rawTrajs = readtable('trajTucsonDowntown.csv',opts);

opts = detectImportOptions('trajTucsonDowntown_debug.csv');
opts = setvartype(opts, 4, 'string');
rawTrajsDebug = readtable('trajTucsonDowntown_debug.csv',opts);

trajMatDebug=table2array([rawTrajsDebug(:,2),rawTrajsDebug(:,3)]);
uTraj=unique(trajMatDebug,'rows');

minX=min(uTraj(:,2));
maxX=max(uTraj(:,2));
minY=min(uTraj(:,1));
maxY=max(uTraj(:,1));
marginValue=0.05;
minXTemp=minX-(maxX-minX)*marginValue;
maxXTemp=maxX+(maxX-minX)*marginValue;
minYTemp=minY-(maxY-minY)*marginValue;
maxYTemp=maxY+(maxY-minY)*marginValue;
minX=minXTemp;
maxX=maxXTemp;
minY=minYTemp;
maxY=maxYTemp;
numGrid=5;
width=(maxX-minX)/numGrid;
height=(maxY-minY)/numGrid;

if isVisualize==1
    figure(1)
    clf
    hold on
    drawBaseMap(uTraj,rawTrajsDebug);
    % figure(2)
    % clf
end
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
                endTime=allTrajTimesteps{i,j}{k,1}{lastIndex,1};
            end
        end
    end
end
disp("!")
% ASSIGN COLOR TO ENTRIES
entryColor=cell(numEntry,1);
entryColor{1,1}=[1,0,0;0,0,1];
entryColor{2,1}=[1,0,1;1,0,0];
entryColor{3,1}=[0,0,1;0,1,0];
entryColor{4,1}=[1,0,1;0,1,0];

duration=seconds(endTime-simulationTime);
% START SIMULATION
globalMinSameColor(numGrid,numGrid)=0;
globalMinDiffColor(numGrid,numGrid)=0;
currentTime=simulationTime;
rawCounter=1;
rectangleHandles(numGrid,numGrid)=0;
isVisSimActive=0;
for i=1:duration
    localColors=cell(numGrid,numGrid);
    % for m=1:numGrid
    %     for n=1:numGrid
    %         localColors{m,n}=[];
    %     end
    % end
    for m=1:size(allTrajStates,1)
        for n=1:size(allTrajStates,2)
            for o=1:size(allTrajStates{m,n},1)
                if allTrajStates{m,n}(o,1)==-2
                    if allTrajTimesteps{m,n}{o,1}{1,1}<=currentTime
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
    if isVisualize==1 && isVisSimActive==1
        % figure(1)
        % clf
        % hold on
        % drawBaseMap(uTraj,rawTrajsDebug);
        if exist("scatterHandles")==1
            for u=1:size(scatterHandles,1)
                delete(scatterHandles(u,1));
            end
        end
        scatterHandles=[];
    end
    for m=1:size(allTrajStates,1)
        for n=1:size(allTrajStates,2)
            for o=1:size(allTrajStates{m,n},1)
                if allTrajStates{m,n}(o,1)>0
                    ind=allTrajStates{m,n}(o,1);
                    x=allTrajs{m,n}{o,1}(ind,2);
                    y=allTrajs{m,n}{o,1}(ind,1);
                    if isVisualize==1 && isVisSimActive==1
                        colorValue=entryColor{m,1}(simTrajColors{m,n}(o,1),:);
                        h=scatter(x,y,80,colorValue,'filled');
                        scatterHandles(size(scatterHandles,1)+1,1)=h;
                    end
                    for gx=1:numGrid
                        if x<minX+width*gx
                            break;
                        end
                    end
                    for gy=1:numGrid
                        if y<minY+height*gy
                            break;
                        end
                    end
                    localColors{gx,gy}(size(localColors{gx,gy},1)+1,1)=simTrajColors{m,n}(o,1);% store color code
                    localColors{gx,gy}(size(localColors{gx,gy},1),2)=m;% store the entry the color code is coming from
                end
            end
        end
    end
    % figure(2)
    % clf
    % [minSameColor,minDiffColor]=gridAnonimity(numGrid,minX-(maxX-minX)*0.01,minY-(maxY-minY)*0.01,maxX+(maxX-minX)*0.01,maxY+(maxY-minY)*0.01);
    if rawCounter>450 && rawCounter<duration-450
        isVisSimActive=1;
        for m=1:numGrid
            for n=1:numGrid
                uc=size(unique(localColors{m,n}),1);
                if uc>0 && (uc<globalMinDiffColor(m,n) || globalMinDiffColor(m,n)==0)
                    globalMinDiffColor(m,n)=uc;
                end
                % if uc>1
                %     disp("DEBUG!!!")
                % end
                [~,~,ix]=unique(localColors{m,n});
                c=min(accumarray(ix,1));
                % if size(c,1)>1
                %     disp("DEBUG!!!")
                % end
                if size(c,1)>0
                    if c>0 && (c<globalMinSameColor(m,n) || globalMinSameColor(m,n)==0)
                        globalMinSameColor(m,n)=c;
                    end
                end
                if isVisualize==1
                    if rectangleHandles(m,n)~=0
                        delete(rectangleHandles(m,n));
                    end
                    if uc==1
                        colorValue=entryColor{localColors{m,n}(1,2),1}(localColors{m,n}(1,1),:);
                        hr=rectangle('Position',[minX+(m-1)*width,minY+(n-1)*height,width,height],'FaceColor',colorValue,'FaceAlpha',0.4);
                        % pause(1.0)
                    else
                        hr=rectangle('Position',[minX+(m-1)*width,minY+(n-1)*height,width,height],'FaceColor','none');
                    end
                    rectangleHandles(m,n)=hr;
                end
            end
        end
        % pause(1.0)
    end
    currentTime=currentTime+seconds(1)
    rawCounter=rawCounter+1
    pause(0.001)
end

function drawBaseMap(uTraj,rawTrajsDebug)
% scatter(uTraj(:,2),uTraj(:,1),[],[0,0,1])
for i=2:size(rawTrajsDebug,1)
    if strcmp(rawTrajsDebug{i,1},rawTrajsDebug{i-1,1})==1
        trajLat=rawTrajsDebug{i,2};
        trajLon=rawTrajsDebug{i,3};
        trajLatNext=rawTrajsDebug{i-1,2};
        trajLonNext=rawTrajsDebug{i-1,3};
        line([trajLon,trajLonNext],[trajLat,trajLatNext],'color',[0.0,0,0.0],'LineWidth',4)
    end
end
end