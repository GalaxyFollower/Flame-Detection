function saveResults(sheet,videoName)
global  t position dz_dt d2z_dt2 d3z_dt3 Af As dA_dt filePath Su Su_ Karlovitz tWalls bords numPointsAnalysis

if(nargin>=2)
    [FileName,PathName,FilterIndex] = uiputfile('*.xls','Save Results',['Results\' videoName '.xls']);
    filePath=[PathName FileName];
end
if(nargin==0)
    sheet=1;
end
    


xlswrite(filePath,getParameterSummary(tWalls,bords,numPointsAnalysis),sheet);
xlswrite(filePath,{'Time (ms)', 'Time Spark (ms)', 'Time Left wall (ms)','Time Right wall (ms)', 'Time Ac_max(ms)','position (cm)', ... 
    'dz/dt (cm/ms)','d2z/dt2 (cm/ms)','d3z/dt3 (cm/ms)','Flame Area (cm2)','dAf/dt (cm2/s)', 'Cross-seccional Area(cm2)', ...
    'Su''(cm/ms)', 'K(1/ms)','Su (cm/ms)'}, sheet, 'A11');

tx=(min(t):min(diff(t)):max(t))';
ii=find(arrayfun(@(i)~isempty(find(abs(t-tx(i))<1E-5, 1)),(1:length(tx))'));


    results=double([]);
    %results=[t t-tWalls(1) t-tWalls(2) t-tWalls(3) t-tWalls(4) position  dz_dt d2z_dt2 d3z_dt3 Af dA_dt As  Su_ Karlovitz Su]
    position2=zeros(size(tx));
    position2(:)=nan;
    position2(ii)=position;
    Af2=zeros(size(tx));
    Af2(:)=nan;
    Af2(ii)=Af;
    As2=zeros(size(tx));
    As2(:)=nan;
    As2(ii)=As;    
    results=[tx tx-tWalls(1) tx-tWalls(2) tx-tWalls(3) tx-tWalls(4) position2  dz_dt d2z_dt2 d3z_dt3 Af2 dA_dt As2  Su_ Karlovitz Su]
    xlswrite(filePath,results, sheet, 'A12');


fprintf('Results succesfuly saved in:\n');
fprintf(strrep(strrep(filePath,'%','%%'),'\','/'));
fprintf('\n');
    


function summary=getParameterSummary(tWalls, bords, numPointsAnalysis)

model_path=[gcs '/Edit Parameters'];
% Cannot change parameter 'numPointsAnalysis' of 'FlameAnalysisv3/Edit Parameters' while simulation is running because its sample time is constant (inf). Constant sample times generally
% occur when the 'inline parameters' option is set to 'on'.
if  strcmp(get_param(model_path,'splinesmoothing'),'Spline Smoothing (matlab)')
      numpointtitle='Smoothing parameter';
      orderanalysisval=' - ';
else
      numpointtitle='Points Polynomial R';
      orderanalysisval=get_param(model_path,'orderAnalysis');
end
summary={'Background Estimator',get_param(model_path,'bge'), ...
         'alfa',get_param(model_path,'alfa'),[],[]; ...
         'Flame Front Fraction',get_param(model_path,'fff'), ...
         'Points Polynomial FP',get_param(model_path,'numberOfPoints'),[],[]; ...
         'Separation Threshold','[deprecated on Version 2]', ...
         'Polynomial''s order FP',get_param(model_path,'order'),[],[]; ...
         'Progressive Change','[deprecated on Version 2]', ...
         'Type of Aproximation',get_param(model_path,'aprox_type'),[],[]; ...
         'Time Between Frames',get_param(model_path,'tbf'), ...
          numpointtitle,['[' num2str(numPointsAnalysis) ']'],...
         'Regression of Logarithms',get_param(model_path,'uselog'); ...
         'Pixels/cm',get_param(model_path,'ppcm'), ...
         'Polynomial''s order R', orderanalysisval,[],[]; ...
         'Pixels to Electrodes',get_param(model_path,'p2e'), ...
         'Date',datestr(now),[],[]; ...
         'left wall (cm)', bords(1),'Right Wall (cm)', bords(2),'Time of Spark(ms)',tWalls(1);...
         'Time of left wall(ms)',tWalls(2),'Time of right wall(ms)',tWalls(3),'Time Max_d2Z/dt2(ms)', tWalls(4)
        };
    