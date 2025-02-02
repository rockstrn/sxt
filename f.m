%小波变换f子函数
function y = f(x1 , x2)

%函数功能：
%       y=f(x1,x2)将两幅原图像x1和x2基于区域特性量测的融合规则进行融合,得到融合后的图像y
%       首先计算两幅图像的匹配度，若匹配度大于阈值，说明两幅图像对应局部能量较接近，
%       因此采用加权平均的融合方法；若匹配度小于阈值，说明两幅图像对应局部能量相差较大，
%       因此选取局部区域能量较大的小波系数作为融合图像的小波系数
%输入参数：
%      x1----输入原图像1
%      x2----输入原图像2
%输出参数：
%      y----融合后的图像
%------------------------------------------------------------%

w=1/16*[1 2 1;2 4 2;1 2 1];   %权系数
E1=conv2(x1.^2,w,'same');     %分别计算两幅图像相应分解层上对应局部区域的“能量”
E2=conv2(x2.^2,w,'same');
M=2*conv2(x1.*x2,w,'same')./(E1+E2);%计算两幅图像对应局部区域的匹配度
T=0.7;                              %定义匹配阈值
Wmin=1/2-1/2*((1-M)/(1-T));
Wmax=1-Wmin;
[m,n]=size(M);

for i=1:m
    for j=1:n
        if M(i,j)<T                %如果匹配度小于匹配阈值，说明两幅图像对应局部区域能量距离较远；
            if E1(i,j)>=E2(i,j)    %那么就直接选取区域能量较大的小波系数
                y(i,j)=x1(i,j);
            else
                y(i,j)=x2(i,j);
            end
        else                       %如果匹配度大于匹配阈值，说明两幅图像对应局部区域能量比较接近；
            if E1(i,j)>=E2(i,j)    %那么就采用加权的融合算法
                y(i,j)=Wmax(i,j)*x1(i,j)+Wmin(i,j)*x2(i,j);
            else
                y(i,j)=Wmin(i,j)*x1(i,j)+Wmax(i,j)*x2(i,j);
            end
        end
    end
end