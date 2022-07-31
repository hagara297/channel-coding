clc
clear all
clear

obj=VideoReader('highway.avi'); %reading the video
a=read(obj);
frames=get(obj,'NumFrames'); %  to get the number of frames
for i=1:frames   % To extract the frames of the video 
    I(i).cdata=a(:,:,:,i);
end
s=size(I(1).cdata); %SIZE OF THE ORIGINAL video
mov(1:frames) =struct('cdata', zeros(s(1),s(2), s(3), 'uint8'),'colormap', []);

Total_Bits = s(1)*s(2)*s(3)*frames*8;
%extracting the RGB data from each frame

for i = 1:frames 
  %Red Components of the Frame
     R(: , : ,i ) = I(i).cdata(:,:,1); 
 %Green Components of the Frame
     G(: , : ,i )=I(i).cdata(:,:,2); 
%Blue Components of the Frame
     B(: , : ,i )=I(i).cdata(:,:,3); 
end
%FIRST RESHAPE FOR RESHAPING THE MATRIX INTO A VECTOR
r1_R=reshape(R,1,[]);
r1_G=reshape(G,1,[]);
r1_B=reshape(B,1,[]);

% convrt unsigned integers to binar (signed)
Rdouble = double(R);
Gdouble = double(G);
Bdouble = double(B);
Rbin = de2bi(Rdouble);
Gbin = de2bi(Gdouble);
Bbin = de2bi(Bdouble);
%reshape the the binary into a 1 row vector
r2_R=reshape(Rbin,1,[]);
r2_G=reshape(Gbin,1,[]);
r2_B=reshape(Bbin,1,[]);
%concate the arrays of the R G B into one vector to be sen5t to the interm
%function
con=[r2_R(:,:) r2_G(:,:) r2_B(:,:)];
reshaped_packets = reshape(con, [] , 1024);%OUTPUT: array of frames of unknown no. of packets(rows) and of 1024 column(each column corresponds to a bit)
%--------------------
p=0.001;%probability of error
trellis= poly2trellis(7,[171 133]);
conv_rate=8/9;
%--------------------
%///////////////////////////////////////////////-------sender---------------////////////////////////////////////////////////////////////
%CALLING THE INTERM FUNCTION TO RETURN THE DECODED ARRAY
ArrayOfDecoded=interm(reshaped_packets,trellis,conv_rate,p);
%//////////////////////////////////////////////////////PLOTTING//////////////////////////////////////////////

% Plot of the throughput (data rate) vs. different values of p from (0.0001 to 0.2) using 
%incremental redundancy
BER1=[];
p=[0.0001 0.001 0.002 0.005 0.01 0.05 0.1 0.15 0.2];
for i=1:length(p)
    ArrayOfDecoded=interm(reshaped_packets,trellis,conv_rate,p(1,i));
    [BER,ratio]=biterr(ArrayOfDecoded,reshaped_packets);
    BER1(i)=(1-ratio);

end
figure()
legend('pb','BER')
plot(p,BER1)
%
% Plot of the coded bit error probability vs. different values of p from (0.0001 to 0.2) 
% assuming code rate =1/2
% OR
% Plot of the coded bit error probability vs. different values of p from (0.0001 to 0.2) 
% using incremental redundancy (increasing code rate)
BERt=[];
p=[0.0001 0.001 0.002 0.005 0.01 0.05 0.1 0.15 0.2];
for i=1:length(p)
    ArrayOfDecoded=interm(reshaped_packets,trellis,conv_rate,p(1,i));
    [BER,ratio]=biterr(ArrayOfDecoded,reshaped_packets);
    BERt(i)=ratio;

end
figure()
legend('pb','BER')
plot(p,BERt)



%//////////////////////////////////////////////----------receiver------------/////////////////////////////////////////////////////////
%RESHAPE THE RECEIVED DECOODED ARRAY
% r4=reshape(ArrayOfDecoded,1,[]);
% %SPLIT THE ARRAY INTO R G B vectors
% sz=length(r4)/3;
% R_rec=r4(1,1:sz);
% G_rec=r4(1,sz+1:2*sz);
% B_rec=r4(1,(2*sz)+1:3*sz);
% %reshape each colr alone into matrix of 8 columns then convert to unsigned
% %integers
%  
% r5_R=reshape(R_rec,[],8);
% r5_G=reshape(G_rec,[],8);
% r5_B=reshape(B_rec,[],8);
% 
% R_bi2dec=bi2de(r5_R);
% G_bi2dec=bi2de(r5_G);
% B_bi2dec=bi2de(r5_B);
% 
% R_uint8=uint8(R_bi2dec);
% G_uint8=uint8(G_bi2dec);
% B_uint8=uint8(B_bi2dec);
% %reshape each color into the original matrix dimensions
% r6_R=reshape(R_uint8,144,176,frames);
% r6_G=reshape(G_uint8,144,176,frames);
% r6_B=reshape(B_uint8,144,176,frames);
% %collect the frames back in order to form a video
% for i = 1:frames
%     
%     mov(1,i).cdata(:,:,1) = r6_R(:,:,i); 
%     mov(1,i).cdata(:,:,2) = r6_G(:,:,i);
%     mov(1,i).cdata(:,:,3) = r6_B(:,:,i);
% end
% % create video and name it
% 
% videoName = strcat('0.001 red',int2str(p*1000),'.avi')
% %   then write video in vw
% vw = VideoWriter(videoName,'UNcompressed Avi')
% open(vw)
% writeVideo(vw,mov)
% close(vw);
% 
% VideoWriter(mov,'NewVideo.avi');
% implay('NewVideo.avi');


% legend('Estimated BER','Theoretical BER')
% xlabel('Eb/No (dB)')
% ylabel('Bit Error Rate')
