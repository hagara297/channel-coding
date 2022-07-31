function [ArrayOfDecoded] = interm(ArrayOfPackets,trellis,conv_rate,p)
 punct=[]; %the puncturing vector globally intialized
 ArrayOfDecoded=[];
  %if the conv_rate=1 ,meaning no channel coding is used
    if conv_rate == 1
        %punct=[1111111111111111];
        s=size(ArrayOfPackets);%size gets you (no. of rows       no. of columns)
        for i=1:s(1)
            %encoded=convenc(ArrayOfPackets(i),trellis);
            Errored=bsc(ArrayOfPackets(i,:),p);
            ArrayOfDecoded(i,:)=Errored;

        end
    
    elseif conv_rate == 0.5    %if the conv_rate=0.5 ,meaning convolutional encioding is used
        
        s=size(ArrayOfPackets);%size gets you (no. of rows       no. of columns)
        for i=1:s(1)  %looping on the rows of  the given packet matrix to encod packet by packet
            encoded=convenc(ArrayOfPackets(i,:),trellis);%built in function that encodes with rate =0.5
            Errored=bsc(encoded,p);
            ArrayOfDecoded(i,:)=vitdec(Errored,trellis,35,'trunc','hard');%receive also with rate 1/2

        end
    
    elseif conv_rate ==8/9    %if the conv_rate=8/9 ,meaning incremental redundancy  is used
        s=size(ArrayOfPackets);%size gets you (no. of rows       no. of columns)
        
         %>>>>>>>>>>>>>>>>>>>>>>summary of this part<<<<<<<<<<<<<<<<<<<<<<<<
        %take the packet and start calling the redundancy function by using
        %the cov. rate=8/9 then check the receievd decodded packet if it
        %equals the original one , if the received does equal the oiginal
        %then its added to the array of decoded that will be returned ,else
        %meaning they are not equal  then we will call the redundancy
        %function again with conv. rate =4/5 then check again until we call
        %the redundancy function with the rate of 1/2 meaning no smallaer
        %rate was accepted , then by this case the received packet will be
        %added to the array of decoded regardless if the packet does equat
        %the original or not.
        for i=1:s(1)   %looping on the rows of  the given packet matrix to check packet by packet
            Decoded=redundancy(ArrayOfPackets(i,:),trellis,conv_rate,p);
            if(not(isequal(Decoded,ArrayOfPackets(i,:))))
                Decoded=redundancy(ArrayOfPackets(i,:),trellis,4/5,p);
                if(not(isequal(Decoded,ArrayOfPackets(i,:))))
                     Decoded=redundancy(ArrayOfPackets(i,:),trellis,2/3,p);
                     if(not(isequal(Decoded,ArrayOfPackets(i,:))))
                        Decoded=redundancy(ArrayOfPackets(i,:),trellis,4/7,p);
                        if(not(isequal(Decoded,ArrayOfPackets(i,:))))
                            Decoded=redundancy(ArrayOfPackets(i,:),trellis,1/2,p);
                            ArrayOfDecoded(i,:)=Decoded;
                            
                        end    
                     else
                            ArrayOfDecoded(i,:)=Decoded;
                           
                     end       
                else
                            ArrayOfDecoded(i,:)=Decoded;
                            
                end       
            else
                            ArrayOfDecoded(i,:)=Decoded ;
                            
            end                
            
        end 
    
    end 
end   