%function [ S,P_value ] = kafang( image,rate )
% �������ܣ��ȶ�ͼ����Ƕ����Ϊrate����˳��LSBǶ�룬Ȼ����п�����д����
% ���������input��ԭʼͼ��rate��Ƕ���ʣ�ȡֵ��[0,1]
% ���������S��ſ���ͳ��ֵ��P�����Ӧ��pֵ�����۲�ֵ�����ֵ���Ƴ̶ȵĸ���
% �������ӣ�[ S,P_value ] = kafang( 'livingroom.tif',0.5 )
%��һ��ͼ��

image='blond.tiff';
rate=0.5;
cover=imread(image);
%cover=cover(:,:,1);
ste_cover=double(cover); 
[m,n]=size(ste_cover); 

%����rate����������Ϣλ�ĳ��ȣ�������������Ϣmsg
msglen=floor(m*n*rate);
msg= rand(1,msglen);  %�������ֱ����randint������������еĻ�
for i=1:msglen
    if msg(i)>=0.5
        msg(i)=1;
    else
        msg(i)=0;
    end
end
 
%ʹ��lsb��д�㷨Ƕ��������Ϣ
p=1;
for f2=1:n
    for f1=1:m      
       if p>=msglen
         break;
       end
       ste_cover(f1,f2)=ste_cover(f1,f2)-mod(ste_cover(f1,f2),2)+msg(1,p);
       p=p+1;
    end
    if p==msglen
        break;
    end
end 

 %��ste_coverת��Ϊuint8���ͣ�ʹ��imhist������������
 ste_cover=uint8( ste_cover);
 
 S=[];
 P_value=[];
 
 %��ͼ��5%�ķָһ���ֳ�20��
 interval=n/20;
 for j=0:19
    h=imhist(ste_cover(:,floor(j* interval)+1:floor((j+1)* interval)));
    h_length=size(h);
    p_num=floor(h_length/2);   
    Spov=0; %��¼����ͳ����
    K=0;
    for i=1:p_num
        if(h(2*i-1)+h(2*i))~=0
            Spov=Spov+(h(2*i-1)-h(2*i))^2/(2*(h(2*i-1)+h(2*i))); 
            K=K+1;
        end
    end
    %SpovΪ����ͳ������K-1Ϊ���ɶ�
    P=1-chi2cdf(Spov,K-1);   
    
    if j~=0
     %  Spov=Spov+S(j); %����ע����Ϊ�ۼƿ���ͳ���� 
    end
    
    S=[S Spov];
    P_value=[ P_value P];
 end

%��ʾ�仯���ߣ�x_label�Ǻ����꣬�����������ռ����ͼ��İٷֱ�
x_label=5:5:100;
figure,
subplot(211),plot(x_label,S,'LineWidth',2),title('X^2ͳ��');
subplot(212),plot(x_label,P_value,'LineWidth',2),title('pֵ');