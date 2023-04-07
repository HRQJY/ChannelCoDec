numX8=[-128:1:127];
num_dec=numX8/8;
num_bin_negFormat=dec2bin(numX8,8)-48;

for i = 1:256
    if num_bin_negFormat(i,1)==0
        num_bin(i,1:8)=num_bin_negFormat(i,1:8);
    else
        num_bin(i,1:8)=num_bin_negFormat(i,1:8)*-1;
    end
end