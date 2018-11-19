function Faces = Detect_Faces(file_vid, FaceDetector)
vid = VideoReader(file_vid);
nFrames=vid.NumberOfFrames;
Frames=read(vid,[2 nFrames-1]);
counter = 0;
for j=1:size(Frames,4)
    cframe = Frames(:,:,:,j);
    mFaceResult = face_segment(cframe, FaceDetector);
    if isempty(mFaceResult)
        continue;
    end
    counter = counter + 1;
    Faces{counter} = mFaceResult;
end