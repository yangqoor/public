function [coeff]=LogNatFac(flg)
%-------------
flCoefficients(1)=+76.180091729471460000;
flCoefficients(2)=-86.505320329416770000;
flCoefficients(3)=+24.014098240830910000;
flCoefficients(4)=-01.231739572450155000;
flCoefficients(5)=+00.001208650973866179;
flCoefficients(6)=-00.000005395239384953;
temp1=flg+1;
temp2=temp1;
temp3=temp1+5.5-(temp1+0.5)*log(temp1+5.5);
temp4=1.000000000190015;
temp2=temp2+1;
temp4=temp4+flCoefficients(1)/temp2;
temp2=temp2+1;
temp4=temp4+flCoefficients(2)/temp2;
temp2=temp2+1;
temp4=temp4+flCoefficients(3)/temp2;
temp2=temp2+1;
temp4=temp4+flCoefficients(4)/temp2;
temp2=temp2+1;
temp4=temp4+flCoefficients(5)/temp2;
temp2=temp2+1;
temp4=temp4+flCoefficients(6)/temp2;
coeff=log(2.5066282746310005*temp4/temp1)-temp3;