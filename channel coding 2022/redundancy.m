function[Decoded]=redundancy(Packet,trellis,conv_rate,p)
        Decoded=[];
        % take the packet,trellis,conv_rate,with a certain probability
        % and see which rate we will send with it and it punct to encode
        % the packet and than add an error to the encoded packet through th
        % BSC channel and then decode the errored packet through th vitdec
        % predefined function then the redunduncy function will return the 
        % decoded packets  
        if conv_rate==(8/9)
            %trellis = poly2trellis(7,[171 133]);
            punct=[1 1 1 0 1 0 1 0 0 1 1 0 1 0 1 0];
            encoded=convenc(Packet,trellis,punct);
            Errored=bsc(encoded,p);
            Decoded=vitdec(Errored,trellis,35,'trunc','hard',punct);
         
        elseif conv_rate==(4/5)
           % trellis = poly2trellis(7,[171 133]);
            punct =[1 1 1 0 1 0 1 0 1 1 1 0 1 0 1 0];
            encoded=convenc(Packet,trellis,punct);
            Errored=bsc(encoded,p);
            Decoded=vitdec(Errored,trellis,35,'trunc','hard',punct);
         
        elseif conv_rate==(2/3)
           % trellis = poly2trellis(7,[171 133]);
            punct =[1 1 1 0 1 1 1 0 1 1 1 0 1 1 1 0];
            encoded=convenc(Packet,trellis,punct);
            Errored=bsc(encoded,p);
            Decoded=vitdec(Errored,trellis,35,'trunc','hard',punct);

        elseif conv_rate==(4/7)
           % trellis = poly2trellis(7,[171 133]);
            punct =[1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 0];
            encoded=convenc(Packet,trellis,punct);
            Errored=bsc(encoded,p);
            Decoded=vitdec(Errored,trellis,35,'trunc','hard',punct);
            
        elseif conv_rate==(1/2)
           % trellis = poly2trellis(7,[171 133]);
            punct =[1 1 1 1 1 1 1 0 1 1 1 1 1 1 1 0];
            encoded=convenc(Packet,trellis);
            Errored=bsc(encoded,p);
            Decoded=vitdec(Errored,trellis,35,'trunc','hard');    

            
        end
end