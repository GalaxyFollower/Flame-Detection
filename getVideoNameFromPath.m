function name=getVideoNameFromPath(video_path)
i=strfind(video_path,'\');
j=strfind(video_path,'.');
name=video_path(i(size(i,2))+1:j(size(j,2))-1);