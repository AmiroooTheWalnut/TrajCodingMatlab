clc
clear
rawTrajs = readtable('trajTucsonUni.csv');
figure(1)
clf
hold on
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
    inInd=str2num(vals{1,1});
    outInd=str2num(vals{2,1});
    if isStartFound==0
%         pause(2)
%         figure(1)
%         clf
%         hold on
        trajStartLat=str2num(rawTrajs{i,2}{1,1});
        trajStartLon=str2num(rawTrajs{i,3}{1,1});
        scatter(trajStartLon,trajStartLat,75,[0,0,1],'filled')
        isStartFound=1;
        prevTraj=rawTrajs{i,1}{1,1};
        if i~=1 && i~=size(rawTrajs,1)
            trajEndLat=str2num(rawTrajs{i-1,2}{1,1});
            trajEndLon=str2num(rawTrajs{i-1,3}{1,1});
            scatter(trajEndLon,trajEndLat,75,[1,0,0],'filled')
        end
        if i==size(rawTrajs,1)
            trajEndLat=str2num(rawTrajs{i-1,2}{1,1});
            trajEndLon=str2num(rawTrajs{i-1,3}{1,1});
            scatter(trajEndLon,trajEndLat,75,[1,0,0],'filled')
        end
    else
        trajLat=str2num(rawTrajs{i,2}{1,1});
        trajLon=str2num(rawTrajs{i,3}{1,1});
        if i~=size(rawTrajs,1)
            trajLatNext=str2num(rawTrajs{i-1,2}{1,1});
            trajLonNext=str2num(rawTrajs{i-1,3}{1,1});
            line([trajLon,trajLonNext],[trajLat,trajLatNext],'color',[0.2,1,0.2],'LineWidth',4)
        end
%         try
%             s=datetime(rawTrajs{i,4}{1,1},'InputFormat','yyyy-MM-dd''T''HH:mm:ss');
%         catch
%             s=datetime(rawTrajs{i,4}{1,1},'InputFormat','yyyy-MM-dd''T''HH:mm');
%         end
%         try
%             e=datetime(rawTrajs{i-1,4}{1,1},'InputFormat','yyyy-MM-dd''T''HH:mm:ss');
%         catch
%             e=datetime(rawTrajs{i-1,4}{1,1},'InputFormat','yyyy-MM-dd''T''HH:mm');
%         end
%         d=seconds(e-s);
        scatter(trajLon,trajLat,30,[0.8,1,0],'filled')
%         text(trajLon,trajLat,num2str(d))
    end
    pause(0.02)
end