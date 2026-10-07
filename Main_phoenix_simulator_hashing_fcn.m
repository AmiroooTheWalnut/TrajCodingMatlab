function [totalCars,totalProtected,numIsolatedTrajs,avgIsolatedTimePercentages,f_est,f_est_theory,f_truth,exitColorStatistics]=Main_phoenix_simulator_hashing_fcn(protectionDistance,protectionTimePercentage,epsilon,dropChance,forceRecalcCheckPoint,dataName,dataDebugName)
% forceRecalcCheckPoint=true;
isVisualize=0;
% protectionTimePercentage=0.5;
% epsilon=10;%color selection mixture
simStartEndOffset=2500;
% protectionDistance=150;
downtownImg = imread("PhoenixMap.png");
downtownImg = imrotate(downtownImg,180);
downtownImg = flip(downtownImg,2);
downtownImg = im2double(downtownImg);
if isfile(strcat("phoenix_checkpoint_",num2str(dropChance),".mat"))==0 || forceRecalcCheckPoint==true
    disp("Preprocessing started")
    opts = detectImportOptions(dataName);
    opts = setvartype(opts, 5, 'string');
    rawTrajs = readtable(dataName,opts);

    opts = detectImportOptions(dataDebugName);
    opts = setvartype(opts, 4, 'string');
    rawTrajsDebug = readtable(dataDebugName,opts);

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
    numGrid=5;
    width=(maxX-minX)/numGrid;
    height=(maxY-minY)/numGrid;

    strEE=table2array(rawTrajsDebug(size(rawTrajsDebug,1),1));
    strEE=strEE{1,1};
    strEESplit=split(strEE,'_');
    numEntry=str2num(strEESplit{1,1})+1;
    numExit=str2num(strEESplit{2,1})+1;
    % numEntry=20;
    % numExit=20;
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
            disp(i/size(rawTrajs,1))
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
    % disp("!")
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
    averageColorAverageDistance(numColors,1)=0;
    sumColorMinDistance(numColors,1)=0;
    averageUncoveredTime(numColors,1)=0;
    sumUncoveredTime(numColors,1)=0;
    effectiveSimDuration=0;
    for i=1:size(entryColor,1)
        for j=1:size(entryColor{i,1},1)
            for k=1:size(uniqueColors,1)
                if uniqueColors(k,:)==entryColor{i,1}(j,:)
                    entryColorCodes(i,j)=k;
                end
            end
        end
    end

    duration=seconds(endTime-simulationTime);
    % START SIMULATION
    globalMinSameColor(numGrid,numGrid)=0;
    globalMinDiffColor(numGrid,numGrid)=0;
    currentTime=simulationTime;
    rawCounter=1;
    rectangleHandles(numGrid,numGrid)=0;
    isVisSimActive=0;
    save(strcat("phoenix_checkpoint_",num2str(dropChance),".mat"),'-regexp', '^(?!isVisualize$|protectionTimePercentage$|epsilon$|simStartEndOffset$|protectionDistance$|downtownImg$).*')
    disp("Preprocessing finished")
else
    load(strcat("phoenix_checkpoint_",num2str(dropChance),".mat"))
end
if isVisualize==1
    figure(1)
    clf
    hold on
    imagesc([-112.2737 -111.874], [33.431 33.688], downtownImg);
    drawBaseMap(uTraj,rawTrajsDebug,150);
    % figure(2)
    % clf
end
% entryColorProb(numEntry,numExit)=0;
% cumEntryColorProb(numEntry,numExit)=0;
% for i=1:numEntry
%     for j=1:numEntry
%         if i==j
%             entryColorProb(i,j)=exp(epsilon)/(exp(epsilon)+numEntry-1);
%         else
%             entryColorProb(i,j)=1/(exp(epsilon)+numEntry-1);
%         end
%         if j==1
%             cumEntryColorProb(i,j)=entryColorProb(i,j);
%         elseif j>1
%             cumEntryColorProb(i,j)=cumEntryColorProb(i,j-1)+entryColorProb(i,j);
%         end
%     end
% end
exitColorStatistics(numExit,size(entryColor,1))=0;
for i=1:duration
    % INSIDE EACH CELL (Nx3), FIRST LAT SECOND LON THIRD TRAJ INDEX
    allColorLocations=cell(numColors,1);
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
                        % colorIndex=1+floor(rand(1,1)*size(entryColor{m,1},1));
                        colorIndices=entryColorCodes(m,:);
                        colorIndices=nonzeros(colorIndices);
                        % colorIndex=1+floor(rand(1,1)*size(colorIndices,1));
                        % val=rand(1,1);
                        % selectedIndex=1;
                        % for q=1:numEntry
                        %     if val<cumEntryColorProb(m,q)% m is entry q is color index
                        %         selectedIndex=q;
                        %         break;
                        %     end
                        % end
                        p=7919;
                        s=numEntry;
                        a=randi(p);
                        b=randi(p);
                        selectedIndex=mod(mod(a*m+b,p),s)+1;
                        colorIndex=entryColorCodes(m,selectedIndex);
                        simTrajColors{m,n}(o,1)=colorIndices(colorIndex,1);
                    end
                elseif allTrajStates{m,n}(o,1)>0
                    lastIndex=size(allTrajTimesteps{m,n}{o,1},1);
                    if allTrajTimesteps{m,n}{o,1}{lastIndex,1}<=currentTime
                        allTrajStates{m,n}(o,1)=-1;% TRAJ ENDED
                        temp=allTrajs{m,n}(o,1);
                        temp2=temp{1,1};
                        endPoint=temp2(size(temp2,1),:);
                        for k=1:size(exitLatLon,1)
                            if exitLatLon(k,1)==endPoint(1,1) && exitLatLon(k,2)==endPoint(1,2)
                                colorIndex=simTrajColors{m,n}(o,1);
                                exitColorStatistics(k,colorIndex)=exitColorStatistics(k,colorIndex)+1;
                                break
                            end
                        end
                        % disp("!")
                    elseif allTrajTimesteps{m,n}{o,1}{allTrajStates{m,n}(o,1)+1,1}<=currentTime
                        initV=allTrajStates{m,n}(o,1)+1;
                        for q=initV:size(allTrajTimesteps{m,n}{o,1},1)
                            if allTrajTimesteps{m,n}{o,1}{q,1}<=currentTime
                                allTrajStates{m,n}(o,1)=q;
                            else
                                break;
                            end
                        end
                        % allTrajStates{m,n}(o,1)=allTrajStates{m,n}(o,1)+1;
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
                    if ind<size(allTrajs{m,n}{o,1},1)-1
                        startTime=allTrajTimesteps{m,n}{o,1}{ind,1};
                        endTime=allTrajTimesteps{m,n}{o,1}{ind+1,1};
                        localDuration=seconds(endTime-startTime);
                        if localDuration>=1
                            % if localDuration==0
                            %     localDuration
                            % end
                            passedDuration=seconds(currentTime-startTime);
                            localLambda=passedDuration/localDuration;
                            % if localLambda>10 || localLambda<0
                            %     localLambda
                            % end
                            % if passedDuration>localDuration+10
                            %     passedDuration-localDuration
                            % end
                            endX=allTrajs{m,n}{o,1}(ind+1,2);
                            endY=allTrajs{m,n}{o,1}(ind+1,1);
                            x=x*(1-localLambda)+localLambda*endX;
                            y=y*(1-localLambda)+localLambda*endY;
                        end
                    end

                    % colorValue=entryColor{m,1}(simTrajColors{m,n}(o,1),:);
                    colorValue=uniqueColors(simTrajColors{m,n}(o,1),:);
                    if isVisualize==1 && isVisSimActive==1
                        h=scatter(x,y,80,colorValue,'filled');
                        scatterHandles(size(scatterHandles,1)+1,1)=h;
                    end
                    maxSize=size(allColorLocations{simTrajColors{m,n}(o,1),1},1);
                    allColorLocations{simTrajColors{m,n}(o,1),1}(maxSize+1,:)=[x,y,allTrajStates{m,n}(o,2)];

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
    if rawCounter>simStartEndOffset && rawCounter<duration-simStartEndOffset
        isVisSimActive=1;
        for c=1:size(allColorLocations,1)
            minDist=10000;
            for m=1:size(allColorLocations{c,1},1)
                minDistInternal=10000;
                for n=m+1:size(allColorLocations{c,1},1)
                    if m~=n
                        dx=allColorLocations{c,1}(m,1)-allColorLocations{c,1}(n,1);
                        dy=allColorLocations{c,1}(m,2)-allColorLocations{c,1}(n,2);
                        d=sqrt(dx^2+dy^2);
                        if d<minDist
                            minDist=d;
                        end
                        if d<minDistInternal
                            minDistInternal=d;
                        end
                        % if d~=0
                        %     disp('DEBUG!!!!')
                        % end
                    end
                end
                if minDistInternal*6.8986113164*22*1609.34>protectionDistance
                    numIsolatedTrajIndices(allColorLocations{c,1}(m,3),1)=numIsolatedTrajIndices(allColorLocations{c,1}(m,3),1)+1;
                    % disp('DEBUG!!!!')
                elseif numIsolatedTrajIndices(allColorLocations{c,1}(m,3),1)<300
                    numIsolatedTrajIndices(allColorLocations{c,1}(m,3),1)=0;
                end
                numTrajJumps(allColorLocations{c,1}(m,3),1)=numTrajJumps(allColorLocations{c,1}(m,3),1)+1;
            end
            if minDist<10000
                sumColorMinDistance(c,1)=sumColorMinDistance(c,1)+minDist;
            end
        end

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
                % if isVisualize==1
                %     if rectangleHandles(m,n)~=0
                %         delete(rectangleHandles(m,n));
                %     end
                %     if uc==1
                %         % colorValue=entryColor{localColors{m,n}(1,2),1}(localColors{m,n}(1,1),:);
                %         colorValue=uniqueColors(localColors{m,n}(1,1),:);
                %         hr=rectangle('Position',[minX+(m-1)*width,minY+(n-1)*height,width,height],'FaceColor',colorValue,'FaceAlpha',0.4);
                %         % pause(1.0)
                %     else
                %         hr=rectangle('Position',[minX+(m-1)*width,minY+(n-1)*height,width,height],'FaceColor','none');
                %     end
                %     rectangleHandles(m,n)=hr;
                % end
            end
        end
        % pause(1.0)
        effectiveSimDuration=effectiveSimDuration+1;
    end
    currentTime=currentTime+seconds(1);
    rawCounter=rawCounter+1;
    pause(0.001)
end
for c=1:size(allColorLocations,1)
    averageColorAverageDistance(c,1)=(sumColorMinDistance(c,1)/effectiveSimDuration)*6.8986113164*22*1609.34;
end
numIsolatedTrajs=0;
for i=1:size(numIsolatedTrajIndices,1)
    if numIsolatedTrajIndices(i,1)>300
        numIsolatedTrajs=numIsolatedTrajs+1;
    end
end

outStr="";
for i=1:size(averageColorAverageDistance,1)
    if i==size(averageColorAverageDistance,1)
        outStr=strcat(outStr,num2str(averageColorAverageDistance(i,1)));
    else
        outStr=strcat(outStr,num2str(averageColorAverageDistance(i,1)),", ");
    end

end
numTrajs=0;
for i=1:size(allTrajs,1)
    for j=1:size(allTrajs,2)
        numTrajs=numTrajs+size(allTrajs{i,j},1);
    end
end
disp(["Total number of cars: ",num2str(numTrajs)])
disp(["numIsolatedTrajs: ",num2str(numIsolatedTrajs)])
disp(["averageMinDistColor: ",outStr])
allAvgIsolatedTimePercentages=0;
counter=0;
totalProtected=0;
for i=1:size(numIsolatedTrajIndices,1)
    if numTrajJumps(i,1)>0
        isolatedTimePercentage=numIsolatedTrajIndices(i,1)/numTrajJumps(i,1);
        if isolatedTimePercentage>protectionTimePercentage
            totalProtected=totalProtected+1;
        end
        allAvgIsolatedTimePercentages=allAvgIsolatedTimePercentages+isolatedTimePercentage;
        counter=counter+1;
    end
end
avgIsolatedTimePercentages=allAvgIsolatedTimePercentages/counter;
disp(["avg Time isolated: ",num2str(allAvgIsolatedTimePercentages/counter)])
totalCars=size(numIsolatedTrajIndices,1);

% f_est=inv(entryColorProb)*exitColorStatistics;
f_ij_true(numEntry,numExit)=0;
for i=1:size(allTrajs,1)
    for j=1:size(allTrajs,2)
        f_ij_true(i,j)=f_ij_true(i,j)+size(allTrajs{i,j},1);
    end
end
Z=exitColorStatistics;
V=sum(exitColorStatistics,2);
g=exp(epsilon)+1;
q_star=1/(g);
p_star=exp(epsilon)/(exp(epsilon)+g-1);
f_est=(Z-V*q_star)/(p_star-q_star);
f_est_theory=V*((4*exp(epsilon))/((exp(epsilon)-1)^2))+f_ij_true;
f_truth=f_ij_true;
end

function drawBaseMap(uTraj,rawTrajsDebug,skipPoints)
% scatter(uTraj(:,2),uTraj(:,1),[],[0,0,1])
currentSkipValue=0;
for i=2:size(rawTrajsDebug,1)
    if strcmp(rawTrajsDebug{i,1},rawTrajsDebug{i-1,1})==1
        if currentSkipValue>skipPoints
            trajLat=rawTrajsDebug{i,2};
            trajLon=rawTrajsDebug{i,3};
            trajLatNext=rawTrajsDebug{i-1,2};
            trajLonNext=rawTrajsDebug{i-1,3};
            line([trajLon,trajLonNext],[trajLat,trajLatNext],'color',[0.0,0,0.0],'LineWidth',4)
            currentSkipValue=0;
        else
            currentSkipValue=currentSkipValue+1;
        end
    else
        trajLat=rawTrajsDebug{i,2};
        trajLon=rawTrajsDebug{i,3};
        trajLatNext=rawTrajsDebug{i-1,2};
        trajLonNext=rawTrajsDebug{i-1,3};
        scatter(trajLon,trajLat,250,"white","filled",'Marker','diamond','MarkerEdgeColor','black')
        scatter(trajLonNext,trajLatNext,250,"white","filled",'Marker','square','MarkerEdgeColor','black')
    end
end
end