clc
clear
opts = detectImportOptions('trajTucsonDowntown_debug.csv');
opts = setvartype(opts, 4, 'string');
rawTrajs = readtable('trajTucsonDowntown_debug.csv',opts);
figure(1)
clf
hold on
numEntry=4;
numExit=4;
allTrajs=cell(numEntry,numExit);
isStartFound=0;
prevTraj='-1';
for i=1:size(rawTrajs,1)
    %     if i==302
    %         disp('!!!')
    %     end
    if isStartFound==1
        if strcmp(prevTraj,rawTrajs{i,1}{1,1})==0
            isStartFound=0;
        end
    end
    vals=split(rawTrajs{i,1}{1,1},'_');
    if isStartFound==0
        if exist("buildingTrajs","var")==1
            allTrajs{inInd+1,outInd+1}=buildingTrajs;
        end
    end
    inInd=str2num(vals{1,1});
    outInd=str2num(vals{2,1});
    if isStartFound==0
        buildingTrajs=[];
        %         pause(2)
        %         figure(1)
        %         clf
        %         hold on
        trajStartLat=rawTrajs{i,2};
        trajStartLon=rawTrajs{i,3};
        % scatter(trajStartLon,trajStartLat,75,[0,0,1],'filled')
        isStartFound=1;
        prevTraj=rawTrajs{i,1}{1,1};
        if i~=1 && i~=size(rawTrajs,1)
            trajEndLat=rawTrajs{i-1,2};
            trajEndLon=rawTrajs{i-1,3};
            % scatter(trajEndLon,trajEndLat,75,[1,0,0],'filled')
        end
        if i==size(rawTrajs,1)
            trajEndLat=rawTrajs{i-1,2};
            trajEndLon=rawTrajs{i-1,3};
            % scatter(trajEndLon,trajEndLat,75,[1,0,0],'filled')
        end
        buildingTrajs(size(buildingTrajs,1)+1,1)=trajStartLat;
        buildingTrajs(size(buildingTrajs,1),2)=trajStartLon;
    else
        trajLat=rawTrajs{i,2};
        trajLon=rawTrajs{i,3};
        buildingTrajs(size(buildingTrajs,1)+1,1)=trajLat;
        buildingTrajs(size(buildingTrajs,1),2)=trajLon;
        if i~=size(rawTrajs,1)
            trajLatNext=rawTrajs{i-1,2};
            trajLonNext=rawTrajs{i-1,3};
            % line([trajLon,trajLonNext],[trajLat,trajLatNext],'color',[0.2,1,0.2],'LineWidth',4)
        end
        % scatter(trajLon,trajLat,30,[0.8,1,0],'filled')
    end
    % pause(0.02)
end
allTrajs{inInd+1,outInd+1}=buildingTrajs;


% TRYING TO DETECT INTERSECTIONS. ABANDONED FOR NOW.
% trajMat=table2array([rawTrajs(:,2),rawTrajs(:,3)]);
% [~,~,ic]=unique(trajMat,'rows');
% accumarray(ic, 1);
% 
% % intersections=cell(numEntry,numExit,numEntry,numExit);
% % for i=1:size(allTrajs,1)
% %     for j=1:size(allTrajs,2)
% %         for ii=1:size(allTrajs,1)
% %             for jj=1:size(allTrajs,2)
% %                 if ~(i==ii && j==jj)
% %                     intersections{i,j,ii,jj}=[];
% %                     for m=1:size(allTrajs{i,j},1)
% %                         for n=1:size(allTrajs{ii,jj},1)
% %                             if allTrajs{i,j}(m,1)==allTrajs{ii,jj}(n,1) && allTrajs{i,j}(m,2)==allTrajs{ii,jj}(n,2)
% %                                 intersections{i,j,ii,jj}(size(intersections{i,j,ii,jj},1)+1,1)=allTrajs{i,j}(m,1);
% %                                 intersections{i,j,ii,jj}(size(intersections{i,j,ii,jj},1),2)=allTrajs{i,j}(m,1);
% %                             end
% %                         end
% %                     end
% %                 end
% %             end
% %         end
% %     end
% % end