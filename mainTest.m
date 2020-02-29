clc;
clear all;
close all;

[file,path]=uigetfile('*.tiff','Read  Ref Image File');

ss=strcat(path,file);

I=imread(ss);


figure,
imshow(I)
title('Input Image')

%% Preprocess

% Extract Red Region

R=im2double(imadjust(I(:,:,1)));

figure,
imshow(R,[])
title('Red Region')

% OTSU threshold

level = graythresh(R);
BW = 1-im2bw(R,level);
figure,
imshow(BW)
title('Segmented Image')


% morphlogy operation
bwImg2=imopen(BW,strel('square',5));
figure,
imshow(bwImg2)
title('Morpholgy Image')


%% 
%bwImg2=imresize(bwImg2,[126,468]);

[sz1 ,sz2]=size(bwImg2);

blocksize2=round(sz1/7)
blocksize1=round(sz2/26)

% mat2cell(bwImg2,ones(round(sz1/7),1)*7,ones(round(sz2/26),1)*26);


y2=bwImg2;
I2=[];
v=[];
z1=size(y2,1)/blocksize2;
z2=size(y2,2)/blocksize1;
a=1;

for i=1:z2
for j=1:z1
  rectangle('Position',[(i*blocksize1)-blocksize1 (j*blocksize2)-blocksize2 blocksize1 blocksize2], ...
         'EdgeColor','y');
 % I2(:,:,a) = imresize(imcrop(y2,[(i*blocksize1)-blocksize1+1 (j*blocksize2)-blocksize2+1 blocksize1 blocksize2]),[blocksize1,blocksize2],'bicubic'); 
   
  a=a+1; 
  hold on 
end 
end 
title('8x8 block division')

%
ss=regionprops(logical(bwImg2),'all')

figure,
imshow(bwImg2)
hold on
for ik=1:numel(ss)
  thisBB = ss(ik).BoundingBox;
  rectangle('Position', [thisBB(1),thisBB(2),thisBB(3),thisBB(4)],...
  'EdgeColor','g','LineWidth',2 )
hold on
end


%% Measure Position
bwImg2=imresize(bwImg2,[126,468]);

[sk1,sk2]=size(bwImg2);
%dR=32;n1=32;
n1=round(sk2/26);
m1=round(sk1/7);
Iz1=mat2cell(bwImg2,ones(round(sk1/n1),1)*n1,ones(round(sk2/m1),1)*m1);

%figure,imshow(cell2mat(Iz1))

%%
figure,
for i=1:size(Iz1,1)
    for j=1:size(Iz1,2)
          test=mean(mean(abs(Iz1{i,j}))) 
          imshow(Iz1{i,j},[])
          if(test>0.5)
              
              mat(i,j)=1;
          else
              mat(i,j)=0;
          end
%         pause;
    end
end

mat



%% Answer Sheet
ip=1;
while(ip==1)


[file,path]=uigetfile('*.tiff','Read Answer sheet File');

ss=strcat(path,file);

I=imread(ss);


figure,
imshow(I)
title('Input Image')

%% Preprocess

% Extract Red Region

R=im2double(imadjust(I(:,:,1)));

figure,
imshow(R,[])
title('Red Region')

% OTSU threshold

level = graythresh(R);
BW = 1-im2bw(R,level);
figure,
imshow(BW)
title('Segmented Image')


% morphlogy operation
bwImg2=imopen(BW,strel('square',10));
figure,
imshow(bwImg2)
title('Morpholgy Image')


%% 
%bwImg2=imresize(bwImg2,[126,468]);

[sz1 ,sz2]=size(bwImg2);

blocksize2=round(sz1/7)
blocksize1=round(sz2/26)

% mat2cell(bwImg2,ones(round(sz1/7),1)*7,ones(round(sz2/26),1)*26);


y2=bwImg2;
I2=[];
v=[];
z1=size(y2,1)/blocksize2;
z2=size(y2,2)/blocksize1;
a=1;

for i=1:z2
for j=1:z1
  rectangle('Position',[(i*blocksize1)-blocksize1 (j*blocksize2)-blocksize2 blocksize1 blocksize2], ...
         'EdgeColor','y');
 % I2(:,:,a) = imresize(imcrop(y2,[(i*blocksize1)-blocksize1+1 (j*blocksize2)-blocksize2+1 blocksize1 blocksize2]),[blocksize1,blocksize2],'bicubic'); 
   
  a=a+1; 
  hold on 
end 
end 


title('8x8 block division')

%

ss=regionprops(logical(bwImg2),'all')

figure,
imshow(bwImg2)
hold on
for ik=1:numel(ss)
    

thisBB = ss(ik).BoundingBox;
  rectangle('Position', [thisBB(1),thisBB(2),thisBB(3),thisBB(4)],...
  'EdgeColor','g','LineWidth',2 )
hold on
end


%% Measure Position
bwImg2=imresize(bwImg2,[126,468]);

[sk1,sk2]=size(bwImg2);
%dR=32;n1=32;
n1=round(sk2/26);
m1=round(sk1/7);
Iz1=mat2cell(bwImg2,ones(round(sk1/n1),1)*n1,ones(round(sk2/m1),1)*m1);

%figure,imshow(cell2mat(Iz1))

%%
figure,
for i=1:size(Iz1,1)
    for j=1:size(Iz1,2)
          test=mean(mean(abs(Iz1{i,j}))) 
          imshow(Iz1{i,j},[])
          if(test>0.5)
              
              mat1(i,j)=1;
          else
              mat1(i,j)=0;
          end
%         pause;
    end
end

mat1




%% Result
mat1([1, 7],:) =0;
mat1(:,[1, 26])=0;

mat([1, 7],:) =0;
mat(:,[1, 26])=0;

corrct=mat.*mat1;

Rans1=corrct(2:end-1,2:end-1);

fprintf('Correct Result/n')
Rr=find(Rans1==1)
numel(Rr)

Iz2=Iz1;

for i=1:size(Iz1,1)
    for j=1:size(Iz1,2)
        if(corrct(i,j)==1)
        Iz2{i,j}=ones(18);
        else
        Iz2{i,j}=zeros(18);
        end                
    end
end

Ic=cell2mat(Iz2);

%
wrong=~mat.*mat1;
Wans2=wrong(2:end-1,2:end-1);

fprintf('Wrong Result/n')
Wr=find(Wans2==1)
numel(Wr)



Iz3=Iz1;
for i=1:size(Iz3,1)
    for j=1:size(Iz3,2)
        if(wrong(i,j)==1)
        Iz3{i,j}=ones(18);
        else
        Iz3{i,j}=zeros(18);
        end                
    end
end

Iw=cell2mat(Iz3);



Ix=zeros(126,468,3);
Ix(:,:,1)=Iw;
Ix(:,:,2)=Ic;
Ix(:,:,3)=zeros(126,468);
figure,
imshow(Ix);
title('Result')
hold on
 text(12, 12, ['Correct Result-->' num2str(numel(Rr))],'FontSize',12,'color','g'); 
 hold on
 text(31, 31, ['Wrong Result-->' num2str(numel(Wr))],'FontSize',12,'color','w'); 
 hold off
%%
RightAnswer(ip)=(numel(Rr));
WrongAnswer(ip)=(numel(Wr));
s11=input('Need To Continue(y/n)-->','s');
if(s11=='y')
    ip=1;
else
    ip=2;
end
end