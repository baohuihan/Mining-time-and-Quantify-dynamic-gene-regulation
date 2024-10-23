%% spatiotemporal Bcd Hb Kr and fit
clear 
close all
[num,txt,raw]=xlsread('Z:\kr-enhancer\number_Kr_13new.xlsx','oreR-all4');
protein_add1 = 'Bcd protein';
RNA_add = 'Kr RNA';
for j=2:length(txt(:,1))
    if char(txt(j,5))=='H'
       protein_add2 = 'Hb protein';
    else
        protein_add2 = 'Gt protein';
    end
bhh_path=char(txt(j,1));
    if ismissing(txt(j,2))== 1
 load([bhh_path,sprintf('%d',num(j,1)),'\fit\',char(txt(j,3)),'_',RNA_add,'_intensity_new3.mat']);
 load([bhh_path,sprintf('%d',num(j,1)),'\fit\',char(txt(j,3)),'_',protein_add1,'_intensity_new3.mat']);
 load([bhh_path,sprintf('%d',num(j,1)),'\fit\',char(txt(j,3)),'_',protein_add2,'_intensity_new3.mat']);
    else
       load([bhh_path,char(txt(j,2)),'\fit\',char(txt(j,3)),'_',RNA_add,'_intensity_new.mat']);
       load([bhh_path,char(txt(j,2)),'\fit\',char(txt(j,3)),'_',protein_add1,'_intensity_new.mat']);
       load([bhh_path,char(txt(j,2)),'\fit\',char(txt(j,3)),'_',protein_add2,'_intensity_new.mat']);
    end
    peakr(j-1)=max(fiout(:,2));
    T(j-1)=num(j,22);
    R(:,j-1)=fiout(:,2);
    P1(:,j-1)=nu_out(:,2);%Hb Gt
    P2(:,j-1)=nu_out2(:,2);%Bcd
    Tr(:,j-1)=num(j,22)*ones(21,1);%cycle13 13
    Tp(:,j-1)=num(j,22)*ones(21,1);%cycle13 13
end
PHb=P1;
PGt=P1;
THb=Tp;
TGt=Tp;
outP(:,1)=num(:,22);
outP(:,2)=num(:,8);
for j=2:length(txt(:,1))
    if char(txt(j,5))=='H'
       PGt(:,j-1)=0;
       TGt(:,j-1)=0;
    else
        PHb(:,j-1)=0;
       THb(:,j-1)=0;
       outP(j,:)=0;
    end
    
end


    nucleus_bin = 1:0.5:13;
    average_radius = 0.5;
 bin_max = min(nucleus_bin+average_radius,13);
 bin_min = max(nucleus_bin-average_radius,0.1);
 dq=jet(14);
%figure;
 for I_bin = 1:length(nucleus_bin)
     %% RNA
        RR=R.*double((Tr >= bin_min(I_bin))&(Tr <= bin_max(I_bin)));
        RR(find(isnan(RR)==1))=0;
        RR(:,all(RR==0,1))=[];
        fi0(:,I_bin) = mean(RR,2);        
        timer(I_bin)=mean(Tr((Tr >= bin_min(I_bin))&(Tr <= bin_max(I_bin))));
 
        fi1(:,I_bin)=std(RR,0,2);
        [max_active(I_bin),Rnu]=max(fi0(:,I_bin));
        std_RNA(I_bin)=fi1(Rnu,I_bin);
  
       active_50=abs(fi0(:,I_bin)-0.5*max_active(I_bin));
        [~,positiona]=min(active_50(1:11));
        [~,positionp]=min(active_50(12:21));
        bounda(I_bin)=fiout(positiona,1);
        boundp(I_bin)=fiout(positionp+11,1);
        boundpeak(I_bin)=fiout(Rnu,1);
              
%         position1=find(diff(fi0(:,I_bin))==min(diff(fi0(:,I_bin))));
%         position2=find(diff(fi0(:,I_bin))==max(diff(fi0(:,I_bin))));
%         
%         bound1(I_bin)=fiout(position1,1);
%         bound2(I_bin)=fiout(position2,1);
        
      %% Protein
        PPHb=PHb.*double((Tp >= bin_min(I_bin))&(Tp <= bin_max(I_bin)));
        PPHb(find(isnan(PPHb)==1))=0;
        PPHb(:,all(PPHb==0,1))=[];
        nuHb(:,I_bin) = mean(PPHb,2);
        timepHb(I_bin)=mean(THb((THb >= bin_min(I_bin))&(THb <= bin_max(I_bin))));
        
%         PPGt=PGt.*double((Tp >= bin_min(I_bin))&(Tp <= bin_max(I_bin)));
%         PPGt(find(isnan(PPGt)==1))=0;
%         PPGt(:,all(PPGt==0,1))=[];
%         nuGt(:,I_bin) = mean(PPGt,2);
%         timepGt(I_bin)=mean(TGt((TGt >= bin_min(I_bin))&(TGt <= bin_max(I_bin))));
        
        PP2=P2.*double((Tp >= bin_min(I_bin))&(Tp <= bin_max(I_bin)));
        PP2(find(isnan(PP2)==1))=0;
        PP2(:,all(PP2==0,1))=[];
        nu2(:,I_bin) = mean(PP2,2);
        nustd2(:,I_bin) = std(PP2,0,2);  
        timep(I_bin)=mean(Tp((Tp >= bin_min(I_bin))&(Tp <= bin_max(I_bin))));
        
         max_ProteinHb(I_bin)=max(nuHb(:,I_bin));
%         max_ProteinGt(I_bin)=max(nuGt(5:9,I_bin));
         [max_Protein2(I_bin),Bcdnu]=max(nu2(:,I_bin));
         std_protein2(I_bin)=nustd2(Bcdnu,I_bin);
%         
%         ProteinHb_EL(I_bin)=nuHb(9,I_bin);
%         ProteinGt_EL(I_bin)=nuGt(9,I_bin);
%         Protein2_EL(I_bin)=nu2(9,I_bin);
%         
%         position3=find(diff(nuHb(1:11,I_bin))==min(diff(nuHb(1:11,I_bin))));
%         try
%         bound3(I_bin)=nu_out(position3,1);
%         end
%         position4=find(diff(nuGt(1:11,I_bin))==min(diff(nuGt(1:11,I_bin))));
%         try
%         bound4(I_bin)=nu_out(position4,1);
%         end
         Hb_50=abs(nuHb(:,I_bin)-0.5*max_ProteinHb(I_bin));
        [~,positionhb]=min(Hb_50(5:15));
        Bcd_50=abs(nu2(:,I_bin)-0.5*max_Protein2(I_bin));
        [~,positionbcd]=min(Bcd_50(5:15));
        boundhb(I_bin)=nu_out(positionhb+4,1);
        boundbcd(I_bin)=nu_out(positionbcd+4,1);
  %% subplot out      
        %errorbar(fnout(:,1),fi0(:,I_bin),fi1(:,I_bin));
%         figure(1)
%         subplot(2,7,I_bin)
%         yyaxis left
%         plot(fiout(:,1),fi0(:,I_bin),'b-');
%         ylim([0 20])
%         hold on
%         for n=1:length(RR(1,:))
%             scatter(fiout(:,1),RR(:,n),'filled','MarkerFaceColor','b','MarkerFaceAlpha',.1);            
%             hold on
%         end
%        
%         set(gca,'xtick',0:0.5:1);
%         set(gca,'ytick',0:10:20);
%        ylabel('RNA Intensity (au)')
%        
%         yyaxis right
%         
%         plot(nu_out(:,1),nuHb(:,I_bin),'g-');
%         hold on
% %         plot(nu_out(:,1),nuGt(:,I_bin),'k');
% %         hold on
%         plot(nu_out2(:,1),nu2(:,I_bin),'r-');
%         hold on
%         for n=1:length(PPHb(1,:))
%             scatter(nu_out(:,1),PPHb(:,n),'filled','MarkerFaceColor','g','MarkerFaceAlpha',.1);        
%             hold on
%         end
%         for n=1:length(PP2(1,:))
%             scatter(nu_out(:,1),PP2(:,n),'filled','MarkerFaceColor','r','MarkerFaceAlpha',.1);
%             hold on
%         end
%         set(gca,'ytick',0:50:100);
%         %title(['T=', num2str(timer(I_bin),'%1.1f')]);
%         %title(['T=', num2str(timer(I_bin),'%1.1f'),'Thb=', num2str(timepHb(I_bin),'%1.1f'),'Tgt=', num2str(timepGt(I_bin),'%1.1f')]);
%         %hold off
%         %legend_str{I_bin} = ['T=', num2str(timer(I_bin),'%1.1f'),'Thb=', num2str(timepHb(I_bin),'%1.1f'),'Tgt=', num2str(timepGt(I_bin),'%1.1f')];
%         %legend(['T=', num2str(timer(I_bin),'%1.1f')])
%         text(0.55,95,['T=', num2str(timer(I_bin),'%1.1f')])
%         ylim([0 100])
%         xlabel('AP axis (normalized)')
%         ylabel('protein Intensity (nM)')
        %text(0.05,55,['T=', num2str(time(I_bin)])
        
%         figure(2)
%         %subplot(2,7,14)
%         plot(fiout(:,1),fi0(:,I_bin),'color',dq(I_bin,:));
%         hold on
%          set(gca,'ytick',0:10:20);
%          set(gca,'xtick',0:0.5:1);
%         colormap(jet)
        
%% Frame
%         F=getframe(gcf);
%         I=frame2im(F);
%         [I,map]=rgb2ind(I,256);
%         if I_bin == 1
%             imwrite(I,map,'Z:\bhh-fish\RNAapply\cycle13.gif','gif','Loopcount',inf,'DelayTime',1);
%         else
%             imwrite(I,map,'Z:\bhh-fish\RNAapply\cycle13.gif','gif','WriteMode','append','DelayTime',1);
%         end
 end
  figure
 %plot(timer,max_active,'b')
 errorbar(timer,max_active,std_RNA,'b')
 hold on
 plot(T,peakr,'bo');
 xlim([1 13]);
 
%  figure
%  plot(timer,boundpeak,'k');
%  hold on
%  plot(timer,boundp,'c');
%  hold on
%  plot(timer,bounda,'b');
%  hold on
%  plot(timepHb,boundhb,'g');
%  hold on
%  plot(timep,boundbcd,'r');
 %% fit
 EL=0.2:0.05:0.7;
% [R1,a,b]=unique(fi0(5:15,:)','rows','stable');
% R1=R1';
% [Bcd,~,~]=unique(nu2(5:15,:)','rows','stable');
% Bcd=Bcd';
% [Hb,~,~]=unique(nuHb(5:15,:)','rows','stable');
% Hb=Hb';
% t=unique(timer,'stable');
R1=fi0(5:15,:);
Bcd=nu2(5:15,:);
Hb=nuHb(5:15,:);
t=timer;
save('Z:\kr-enhancer\fit2\Bcd_13.mat','Bcd');
save('Z:\kr-enhancer\fit2\Hb_13.mat','Hb');
save('Z:\kr-enhancer\fit2\R1_13.mat','R1');
save('Z:\kr-enhancer\fit2\t_13.mat','t');
save('Z:\kr-enhancer\fit2\Bcd_13_all.mat','nu2');
save('Z:\kr-enhancer\fit2\Hb_13_all.mat','nuHb');
save('Z:\kr-enhancer\fit2\R1_13_all.mat','fi0');
%%
% load('Z:\kr-enhancer\fit\Bcd.mat');
% load('Z:\kr-enhancer\fit\Hb.mat');
% load('Z:\kr-enhancer\fit\R1.mat');
Kr=R1;
%Kr=R1;
%EL=0.1:0.025:0.5;
co0=[0 20 2 8 5 7 7 2 8 5 7 20 2 8 5 7 1 t(1) 5 8 11];
lb=[0 1 1 1 1 1 1 1 1 1 1 1 1 1 1 1 0.3 3 4 7 10];
ub=[10 35 20 20 10 10 20 20 20 10 10 30 20 20 10 10 5 6 6 10 13];
[co,resnorm,residual,exitflag,output,lambda,jacobian] = lsqcurvefit(@myfun_cycle13,co0,EL,Kr,lb,ub);
%conf=nlparci(co,residual,'jacobian',jacobian,"Alpha",0.9);%90% confidence
%%   ŷ����


% t=t(2:8);
% R1=R1(:,2:8);
% Bcd=Bcd(:,2:8);
% Hb=Hb(:,2:8);
x=zeros(length(EL),length(t));
y=zeros(length(EL),length(t));
R=zeros(length(EL),length(t));
%co=[0 2 3 3 3 3 2];
for n=1:length(EL)
    R(n,1)=R1(n,1);
for i=1:length(t)-1
    x(n,i)=Bcd(n,i);
    y(n,i)=Hb(n,i);
    dR1=co(1)+(co(2).*((x(n,i).^co(5))./(co(3).^co(5)+x(n,i).^co(5))).*(co(4).^co(6))./(co(4).^co(6)+y(n,i).^co(6)))-co(17).*R(n,i);
    dR2=co(1)+(co(7).*((x(n,i).^co(10))./(co(8).^co(10)+x(n,i).^co(10))).*(co(9).^co(11))./(co(9).^co(11)+y(n,i).^co(11)))-co(17).*R(n,i);
    dR3=co(1)+(co(12).*((x(n,i).^co(15))./(co(13).^co(15)+x(n,i).^co(15))).*(co(14).^co(16))./(co(14).^co(16)+y(n,i).^co(16)))-co(17).*R(n,i);
    dR4=-co(17).*R(n,i);
    if t(i+1)<=co(18)
        R(n,i+1)=R(n,i);
    elseif t(i)<=co(18)&&t(i+1)>co(18)
        R(n,i+1)=R(n,i)+(t(i+1)-co(18)).*dR1;
    elseif t(i)>co(18)&&t(i+1)<=co(19)
       R(n,i+1)=R(n,i)+(t(i+1)-t(i)).*dR1;
    elseif t(i)<=co(19)&&t(i+1)>co(19)
        R(n,i+1)=R(n,i)+(co(19)-t(i)).*dR1+(t(i+1)-co(19)).*dR2;
    elseif t(i)>co(19)&&t(i+1)<=co(20)
       R(n,i+1)=R(n,i)+(t(i+1)-t(i)).*dR2;
    elseif t(i)<=co(20)&&t(i+1)>co(20)
        R(n,i+1)=R(n,i)+(co(20)-t(i)).*dR2+(t(i+1)-co(20)).*dR3;
    elseif t(i)>co(20)&&t(i+1)<=co(21)
       R(n,i+1)=R(n,i)+(t(i+1)-t(i)).*dR3;
    elseif t(i)<=co(21)&&t(i+1)>co(21)
        R(n,i+1)=R(n,i)+(co(21)-t(i)).*dR3+(t(i+1)-co(21)).*dR4;
    elseif t(i)>co(21)
       R(n,i+1)=R(n,i)+(t(i+1)-t(i)).*dR4;
    end
end
end
figure
for i=1:length(t)
    %figure
    subplot(5,5,i)
    scatter3(Bcd(:,i),Hb(:,i),R(:,i),'filled','MarkerFaceColor','r');
    hold on
    scatter3(Bcd(:,i),Hb(:,i),Kr(:,i),'filled','MarkerFaceColor','b');
    xlabel('Bcd');ylabel('hb');
    zlim([0 20])
    title(['T=',num2str(t(i))]);
end

%% surf 
Lnwindow = 0.25;
nu_L1 = 0.5:0.5:8.5;
nu_L2 = 0.25:0.25:6.5;
r1=[Bcd(:,1),Hb(:,1),R1(:,1)];
rkr=zeros(length(nu_L1),length(nu_L2));
 for Lcenter1 = 1:length(nu_L1)
     for Lcenter2 = 1:length(nu_L2)
    nu_map = (r1(:,1) >= nu_L1(Lcenter1)-Lnwindow) & (r1(:,1) <= nu_L1(Lcenter1)+Lnwindow) & (r1(:,2) >= nu_L2(Lcenter2)-Lnwindow) & (r1(:,2) <= nu_L2(Lcenter2)+Lnwindow);
    rkr(Lcenter1,Lcenter2) = mean(r1(nu_map,3));
     end
 end
 rkr(find(isnan(rkr)==1))=0;
 [hb,bcd]=meshgrid(nu_L2,nu_L1);
 figure
 mesh(bcd,hb,rkr);
 
 ela=4;
 elp=10;
 for i=1:length(t)-1
     
    for Lcenter1 = 1:length(nu_L1)
     for Lcenter2 = 1:length(nu_L2)
    
    dR1=co(1)+(co(2).*((nu_L1(Lcenter1).^co(5))./(co(3).^co(5)+nu_L1(Lcenter1).^co(5))).*(co(4).^co(6))./(co(4).^co(6)+nu_L2(Lcenter2).^co(6)))-co(17).*rkr(Lcenter1,Lcenter2);
    dR2=co(1)+(co(7).*((nu_L1(Lcenter1).^co(10))./(co(8).^co(10)+nu_L1(Lcenter1).^co(10))).*(co(9).^co(11))./(co(9).^co(11)+nu_L2(Lcenter2).^co(11)))-co(17).*rkr(Lcenter1,Lcenter2);
    dR3=co(1)+(co(12).*((nu_L1(Lcenter1).^co(15))./(co(13).^co(15)+nu_L1(Lcenter1).^co(15))).*(co(14).^co(16))./(co(14).^co(16)+nu_L2(Lcenter2).^co(16)))-co(17).*rkr(Lcenter1,Lcenter2);
    dR4=-co(17).*rkr(Lcenter1,Lcenter2);
    if t(i+1)<=co(18)
        rkr(Lcenter1,Lcenter2)=rkr(Lcenter1,Lcenter2);
    elseif t(i)<=co(18)&&t(i+1)>co(18)
        rkr(Lcenter1,Lcenter2)=rkr(Lcenter1,Lcenter2)+(t(i+1)-co(18)).*dR1;
    elseif t(i)>co(18)&&t(i+1)<=co(19)
       rkr(Lcenter1,Lcenter2)=rkr(Lcenter1,Lcenter2)+(t(i+1)-t(i)).*dR1;
    elseif t(i)<=co(19)&&t(i+1)>co(19)
        rkr(Lcenter1,Lcenter2)=rkr(Lcenter1,Lcenter2)+(co(19)-t(i)).*dR1+(t(i+1)-co(19)).*dR2;
    elseif t(i)>co(19)&&t(i+1)<=co(20)
       rkr(Lcenter1,Lcenter2)=rkr(Lcenter1,Lcenter2)+(t(i+1)-t(i)).*dR2;
    elseif t(i)<=co(20)&&t(i+1)>co(20)
        rkr(Lcenter1,Lcenter2)=rkr(Lcenter1,Lcenter2)+(co(20)-t(i)).*dR2+(t(i+1)-co(20)).*dR3;
    elseif t(i)>co(20)&&t(i+1)<=co(21)
       rkr(Lcenter1,Lcenter2)=rkr(Lcenter1,Lcenter2)+(t(i+1)-t(i)).*dR3;
    elseif t(i)<=co(21)&&t(i+1)>co(21)
        rkr(Lcenter1,Lcenter2)=rkr(Lcenter1,Lcenter2)+(co(21)-t(i)).*dR3+(t(i+1)-co(21)).*dR4;
    elseif t(i)>co(21)
       rkr(Lcenter1,Lcenter2)=rkr(Lcenter1,Lcenter2)+(t(i+1)-t(i)).*dR4;
    end
    
     end
    end
    pn1(:,i)=polyfit(Bcd(ela:elp,i),Bcd(ela:elp,i+1),1);
    pn2(:,i)=polyfit(Hb(ela:elp,i),Hb(ela:elp,i+1),1);
    nu_L1=pn1(1,i).*nu_L1+pn1(2,i);
    nu_L2=pn2(1,i).*nu_L2+pn2(2,i);
    [hb,bcd]=meshgrid(nu_L2,nu_L1);
    figure
%     mesh(bcd,hb,rkr,'FaceAlpha',0.2);
    surf(bcd,hb,rkr,'FaceAlpha',0.2);
    colormap(jet)
    hold on
%     scatter3(Bcd(ela:elp,i+1),Hb(ela:elp,i+1),R(ela:elp,i+1),'filled','MarkerFaceColor','r','MarkerFaceAlpha',.4);
%     hold on
    scatter3(Bcd(ela:elp,i+1),Hb(ela:elp,i+1),R1(ela:elp,i+1),'filled','MarkerFaceColor','b','MarkerFaceAlpha',1);
    hold on
    for n=ela:elp
    plot3([Bcd(n,i+1),Bcd(n,i+1)],[Hb(n,i+1),Hb(n,i+1)],[R1(n,i+1),R(n,i+1)],'k');
    hold on
    end
    title(['T=',num2str(t(i+1))]);
    xlabel('Bcd');ylabel('hb');zlabel('kr');
    grid off
    
%     xlim([0 20])
%     ylim([0 20])
    zlim([0 25])
%     set(gca,'xtick',0:10:20);
%     set(gca,'ytick',0:10:20);
    set(gca,'ztick',0:10:20);
    view([-80 42])
 end