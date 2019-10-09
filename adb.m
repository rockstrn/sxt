%Í¼ÏñÀ©Õ¹º¯Êı
function Y=adb(X,bd)
[z s]=size(X);
Y=zeros(z+bd(1),s+bd(2));
Y(1:z,1:s)=X;
if(bd(1)>0)
  Y(z+1:z+bd(1),1:s)=X(z-1:-1:z-bd(1),1:s);
end;
if(bd(2)>0)
  Y(1:z,s+1:s+bd(2))=X(1:z,s-1:-1:s-bd(2));
end;
if(bd(1)>0&bd(2)>0)
  Y(z+1:z+bd(1),s+1:s+bd(2))=X(z-1:-1:z-bd(1),s-1:-1:s-bd(2));
end;