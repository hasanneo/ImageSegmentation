function size = convertToOriginalSize(mat,size)
t1=reshape(mat(1,:),size).';
t2=reshape(mat(2,:),size).';
t3=reshape(mat(3,:),size).';
size(:,:,1)=t1;
size(:,:,2)=t2;
size(:,:,3)=t3;
return;