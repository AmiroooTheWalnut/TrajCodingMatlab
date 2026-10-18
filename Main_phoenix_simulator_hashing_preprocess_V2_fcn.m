function [totalCars,totalProtected,numIsolatedTrajs,avgIsolatedTimePercentages,f_est,f_est_theory,f_truth,entryExitStatistics]=Main_phoenix_simulator_hashing_preprocess_V2_fcn(protectionDistance,protectionTimePercentage,epsilon,dropChance,forceRecalcCheckPoint,dataName,dataNameDebug,saveName)
totalCars=-1;
totalProtected=-1;
numIsolatedTrajs=-1;
avgIsolatedTimePercentages=-1;
% forceRecalcCheckPoint=false;
isVisualize=0;
% protectionTimePercentage=0.5;
% epsilon=10;%color selection mixture
simStartEndOffset=2500;
% protectionDistance=150;
downtownImg = imread("PhoenixMap.png");
downtownImg = imrotate(downtownImg,180);
downtownImg = flip(downtownImg,2);
downtownImg = im2double(downtownImg);
isfijOnly=true;
if isfile(saveName)==0 || forceRecalcCheckPoint==true
    % saveName='phoenix_checkpoint.mat';
    % dataName='trajPhoenixNorthWest_tiny.csv';
    % dataNameDebug='trajPhoenixNorthWest_tiny_debug.csv';
    disp('Start preprocessing')
    [width,height,uniqueColors,numColors,simDuration,numEntry,numExit,simulationTime,entryColor,allTrajStates,allTrajTimesteps,entryColorCodes,allTrajs,minX,maxX,minY,maxY,exitLatLon,numIsolatedTrajIndices,numTrajJumps]=preprocessTrajs_fcn(dataName,dataNameDebug,saveName,dropChance,isVisualize,numGrid);
    disp('End preprocessing')
else
    load(saveName)
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
if isfijOnly==true
    entryExitStatistics(numEntry,numExit)=0;
    exitColorStatistics(numExit,size(entryColor,1))=0;
    exitOnlyStatistics(numExit,1)=0;
    g=ceil(exp(epsilon)+1);
    p_star=exp(epsilon)/(exp(epsilon)+g-1);
    for m=1:size(allTrajs,1)
        for n=1:size(allTrajs,2)
            for o=1:size(allTrajs{m,n},1)
                p=7919;
                s=numEntry;
                a=randi(p);
                b=randi(p);
                selectedRow=mod(mod(a*m+b,p),g)+1;
                if rand(1,1)>p_star
                    rowOptions=1:g;
                    rowOptions(:,selectedRow)=[];
                    selectedRowPert=floor(1+rand(1,1)*(g-2));
                    selectedRow=rowOptions(1,selectedRowPert);
                end
                % colorIndex=entryColorCodes(m,selectedRow);
                % simTrajColors{m,n}(o,1)=colorIndex;
                % exitColorStatistics(n,colorIndex)=exitColorStatistics(n,colorIndex)+1;
                simTrajColors{m,n}(o,1)=m;

                % val=rand(1,1);
                % selectedIndex=1;
                % for q=1:numEntry
                %     if val<cumEntryColorProb(m,q)% m is entry q is color index
                %         selectedIndex=q;
                %         break;
                %     end
                % end
                % colorIndex=entryColorCodes(m,selectedIndex);
                % % colorIndex=simTrajColors{m,n}(o,1);
                % exitColorStatistics(n,colorIndex)=exitColorStatistics(n,colorIndex)+1;

                for e=1:numEntry
                    outH=mod(mod(a*e+b,p),g)+1;
                    if outH==selectedRow
                        entryExitStatistics(e,n)=entryExitStatistics(e,n)+1;
                    end
                end
                % for u=1:size(entryColorCodes(n,:),2)
                %     selectedEntry=-1;
                %     if entryColorCodes(n,u)==colorIndex
                %         selectedEntry=u;
                %         break
                %     end
                % end
                % entryExitStatistics(selectedEntry,n)=entryExitStatistics(selectedEntry,n)+1;

                
            end
        end
    end
    f_ij_true(numEntry,numExit)=0;
    for i=1:size(allTrajs,1)
        for j=1:size(allTrajs,2)
            f_ij_true(i,j)=f_ij_true(i,j)+size(allTrajs{i,j},1);
        end
    end
    % g=exp(epsilon)+1;
    % g=numEntry;
    q_star=1/(g);
    p_star=exp(epsilon)/(exp(epsilon)+g-1);
    % q_star=1-p_star;
    % p_star=1-q_star;
    Z=entryExitStatistics;
    V=sum(f_ij_true,1);
    % V=sum(entryExitStatistics,2);
    f_est=(Z-V'*q_star)/(p_star-q_star);
    mV=min(min(f_est));
    % f_est=f_est-mV;
    f_est_p=abs(Z)/sum(sum(abs(Z)));
    f_est_theory=V*((4*exp(epsilon))/((exp(epsilon)-1)^2))+f_ij_true;
    f_truth=f_ij_true;
    disp('!!!!')
else
    entryColorProb(numEntry,numExit)=0;
    exitColorStatistics(numExit,size(entryColor,1))=0;
    entryExitStatistics(numEntry,numExit)=0;
    g=ceil(exp(epsilon)+1);
    p_star=exp(epsilon)/(exp(epsilon)+g-1);
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
                            % colorIndices=entryColorCodes(m,:);
                            % colorIndices=nonzeros(colorIndices);
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
                            selectedRow=mod(mod(a*m+b,p),g)+1;
                            if rand(1,1)>p_star
                                rowOptions=1:g;
                                rowOptions(:,selectedRow)=[];
                                selectedRowPert=floor(1+rand(1,1)*(g-2));
                                selectedRow=rowOptions(1,selectedRowPert);
                            end
                            % colorIndex=entryColorCodes(m,selectedRow);
                            % simTrajColors{m,n}(o,1)=colorIndex;
                            % exitColorStatistics(n,colorIndex)=exitColorStatistics(n,colorIndex)+1;
                            simTrajColors{m,n}(o,1)=m;

                            % val=rand(1,1);
                            % selectedIndex=1;
                            % for q=1:numEntry
                            %     if val<cumEntryColorProb(m,q)% m is entry q is color index
                            %         selectedIndex=q;
                            %         break;
                            %     end
                            % end
                            % colorIndex=entryColorCodes(m,selectedIndex);
                            % % colorIndex=simTrajColors{m,n}(o,1);
                            % exitColorStatistics(n,colorIndex)=exitColorStatistics(n,colorIndex)+1;

                            for e=1:numEntry
                                outH=mod(mod(a*e+b,p),g)+1;
                                if outH==selectedRow
                                    entryExitStatistics(e,n)=entryExitStatistics(e,n)+1;
                                end
                            end
                            % colorIndex=entryColorCodes(m,selectedRow);
                            % simTrajColors{m,n}(o,1)=colorIndex;
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
                                    for u=1:size(entryColorCodes(k,:),2)
                                        selectedEntry=-1;
                                        if entryColorCodes(k,u)==colorIndex
                                            selectedEntry=u;
                                            break
                                        end
                                    end
                                    entryExitStatistics(selectedEntry,k)=entryExitStatistics(selectedEntry,k)+1;
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
        currentTime=currentTime+seconds(1)
        rawCounter=rawCounter+1
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
    disp(["avg Time isolated: ",num2str(allAvgIsolatedTimePercentages/counter)])

    % f_est=inv(entryColorProb)*exitColorStatistics;
    f_ij_true(numEntry,numExit)=0;
    for i=1:size(allTrajs,1)
        for j=1:size(allTrajs,2)
            f_ij_true(i,j)=f_ij_true(i,j)+size(allTrajs{i,j},1);
        end
    end
    q_star=1/(g);
    p_star=exp(epsilon)/(exp(epsilon)+g-1);
    % q_star=1-p_star;
    % p_star=1-q_star;
    Z=entryExitStatistics;
    V=sum(f_ij_true,1);
    % V=sum(entryExitStatistics,2);
    f_est=(Z-V'*q_star)/(p_star-q_star);
    mV=min(min(f_est));
    % f_est=f_est-mV;
    f_est_p=abs(Z)/sum(sum(abs(Z)));
    f_est_theory=V*((4*exp(epsilon))/((exp(epsilon)-1)^2))+f_ij_true;
    f_truth=f_ij_true;
end
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

function sumSameColorDistCalc()

end