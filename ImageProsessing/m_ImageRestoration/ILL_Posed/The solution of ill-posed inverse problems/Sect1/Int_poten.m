% Int_poten

% �������� ��������� ���� �������, ����������� ���������� ����� � ���������
% ��������� rho, ���������� �� ������� �:
%
% Delta_g(x)=rho/2/pi*\int_a^b ln(((x-t)^2+H^2)/((x-t)^2+(H-z(t))^2))dt
%     rho=rho_2-rho_1
%
% ������������ ������������ ������� ������ ������ (������ ��������������)
% � ����������� ������� z(t) (�.29 - 30).

clear all
close all

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FntNm='Arial Cyr';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

disp(' ');
disp('   ���������� �������� ��������� ���� �������, ����������� ���������� �����');
disp('   � ��������� ��������� rho, ���������� �� ������� �.');
disp('   ������������ ������������ ������� ���� ������ ������ (������ ��������������).');
disp('      ���������� ����� �������� �� ���������� ������ ������!');
disp(' ');

rho=1;H=10;% ���������
n=121;m=2*n;
t=linspace(-2,2,n);x=linspace(-2,2,m);h=t(2)-t(1);% �����
z=zeros(size(t));
D=abs(t)<=1;z(D)=(1-t(D).^2).^2;

U=zeros(m,1);
C=ones(size(z));C(1)=0.5;C(end)=0.5;
% ������ ������ ����� ���������
for ii=1:m;S=0;
    for jj=1:n;
      S=S+C(jj)*h*log(((x(ii)-t(jj)).^2+H^2)./((x(ii)-t(jj)).^2+(H-z(jj)).^2));
    end
   U(ii)=S*rho/2/pi;
end
   dd=[0.01 0.05 0.1];% ��������������� ������ ������
for k=1:length(dd);
    disp('   ��� � ��������� ������ ������������� ������ ������ delta ������� <����>');pause
    RN=randn(size(z'));delta=dd(k);
   z1=z'+delta*norm(z)*RN/norm(RN);
   
% ���������� ������������ ������ ����� �� ����������� z(t)   
[F,U1]=invpot2(z1,x,t,H,rho,h,U,n,m);
er(k)=F;
figure(k);subplot(2,1,1);
plot(t,z,'b',t(1:3:end)',z1(1:3:end),'r.',...
   [x(1) x(end)],[H H],'g','LineWidth',2);set(gca,'FontName',FntNm);
set(gca,'YLim',[-0.1 10.5],'YTickLabel',[]);
title('����� ���������� �������������� ��������')
h5=text(0.8,9.2,'H=0');h5=text(0.8,1.2,'H=-10');
legend('������ ����� ��������',['����������� �����: \delta=' num2str(delta)],...
   '����������� �����',2);
subplot(2,1,2);
plot(x',U,x(1:5:end)',U1(1:5:end),'r.');xlabel('x');set(gca,'YLim',[0.0 0.04]);
h6=get(gca,'YLim');ys=mean(h6);
text(-0.2,ys,['Error=' num2str(F)]);%norm(U-U1)/norm(U)
legend('������ �������� ����������',['����������� ��������: \delta = ' num2str(delta)],4)
set(gca,'FontName',FntNm);
title('����������� �������� ��������������� ����������')
%
drawnow
end
%   ����������� ������������� ������ ���������� �� ������ ���������� ������ 
disp(' ');disp(' ����������� ������������� ������ ������������ ������� Error');
disp(' �� �������������� ������ ���������� ������ delta:');
disp(' ');disp([' delta = ' num2str(dd)]);disp(['Error = ' num2str(er)]);
disp(' '); 
%
