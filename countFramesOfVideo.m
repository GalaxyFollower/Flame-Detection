%This function counts the frames in a video
function n=countFramesOfVideo(path)

hVideoSrc = video.MultimediaFileReader(path, 'ImageColorSpace', 'Intensity');
n=0;
while ~isDone(hVideoSrc)
    n=n+1;
    step(hVideoSrc);
end 