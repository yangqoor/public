%   nonregul

%   ���������� ������������������� �������
disp('%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% ');
disp(' ');disp('   ������������������ �������');
disp(' ');disp('   ��� ������� ������� ����� �������');pause

% ���������� ������� �������� ������
z2=AA\(U);% 
% ����������� ��������������� 
UU1=AA*z2;
Residual=norm(UU1-U)/norm(U);
Error=norm(z2'-a0,inf)/norm(a0,inf);
disp(['   Residual=' num2str(Residual) '   C_error=' num2str(Error)]);

Var_error_n=Var1(z2'-a0)/Var1(a0)

figure(102);subplot(1,2,1);plot(s,a0,'r',s,z2','.-');
set(gca,'FontName',FntNm);
title('������ � ������������ �������')
%subplot(1,2,2);plot(s,U0,'r',s,UU1,'.');
old_val(s,U0,UU1);
set(gca,'FontName',FntNm);
title('�������. � ������. ������ �����')
set(gcf,'NumberTitle','off','Name','������������������ ���','Position',[435 237 560 420])
