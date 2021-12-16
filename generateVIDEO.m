clc, clear
pause(0.1)
% GENERATE VIDEO
genera=true;
Tsim=8;
fps = 30;

t = 1/fps:1/fps:Tsim;  
animar=true;

if genera
nn=input('Video name: ', 's');
else
nn='';
end

FigList = findobj(allchild(0),'flat', 'Type', 'figure');
for iFig = 1:length(FigList)
  FigHandle = FigList(iFig); FigHandle.Name
  FigName   = num2str(get(FigHandle, 'Number'));
  set(0, 'CurrentFigure', FigHandle);
  %SAVEname=[nn '_' FigHandle.Name '_' FigName];
  %FigHandle.Renderer='Painters'; %to save in pdf properly, necessary only for 3D plots
  

  if animar
      % for figuras
      % for limites
      % for subplots
      % for graficas
      
      % configuracion de subplot
      ob = findobj(gcf,'type','axes');
      N=length(ob);
      if N==1
          Nrows=1; Ncols=1;
      else
        pos = cell2mat(get(ob,'position'));
        Nrows = numel(unique(pos(:,2))); % the same Y position means the same row
        Ncols = numel(unique(pos(:,1))); % the same X position means the same column
      end
      %for para salvar datos
      for sub = 1:N
          if N>1
            subplot(Nrows,Ncols,sub);
          end
          a = findobj(gca,'Type','line');
          b=gca;
          b.YLimMode='manual'; b.XLimMode='manual'; b.ZLimMode='manual';
          
          xdata = get(a, 'XData');
          ydata = get(a, 'YData');
          zdata = get(a, 'ZData');
          SDX{sub} = xdata;  SDY{sub} = ydata;  SDZ{sub} = zdata;
      end
    
  if genera
        nameV=[ nn '_' FigHandle.Name '_' rand_name() '.avi'];
        vw = VideoWriter(nameV);
        open(vw);
        disp('Writting video...')
        nameG=[ nn '_' FigHandle.Name '_' rand_name() '.gif'];
  end
  
  for k = 1 : length(a)
    xdata=SDX{1};
    if iscell(xdata)
        xd = xdata{k};
    else
        xd = xdata;
    end    

    indices(k,:) = ceil(t*length(xd)/Tsim);
  end
    
  for lim = 1 : size(indices,2)
  for sub = 1 : N
      if N>1
  subplot(Nrows,Ncols,sub)
      end
  a = findobj(gca,'Type','line');
  b=gca;
  b.YLimMode='manual'; b.XLimMode='manual'; b.ZLimMode='manual';
  
  xdata = SDX{sub};
  ydata = SDY{sub};
  zdata = SDZ{sub};
  
  for k = 1 : length(a)
    xdataAUX=SDX{1};
    if iscell(xdataAUX)
        xd = xdataAUX{k};
    else
        xd = xdataAUX;
    end
    indices(k,:) = ceil(t*length(xd)/Tsim);
  end

      for gra = 1 : length(a)
          if iscell(xdata)
          xd = xdata{gra};
          yd = ydata{gra};
          zd = zdata{gra};
          else
              xd = xdata;
              yd = ydata;
              zd = zdata;
          end
          xd = xd(1:indices(gra,lim)); yd = yd(1:indices(gra,lim));
          if length(zd)==0
              set(a(gra),'Xdata',xd,'Ydata',yd)
          else
              zd = zd(1:indices(gra,lim));
              set(a(gra),'Xdata',xd,'Ydata',yd,'Zdata',zd)
          end 
      end
  end
    drawnow
    if genera
        F = getframe(gcf);
        writeVideo(vw,F);
        
        im = frame2im(F);
        [imind,cm] = rgb2ind(im,256);
        if lim==1
            imwrite(imind,cm,nameG,'gif','DelayTime',1/fps,'Loopcount',inf); 
        else 
            imwrite(imind,cm,nameG,'gif','DelayTime',1/fps,'WriteMode','append');
        end
    end  
    
  end
    if genera
        close(vw);
    end
    close(FigHandle)
  end
end

if exist('carpeta')
    close all;
end