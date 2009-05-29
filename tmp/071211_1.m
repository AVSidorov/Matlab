for i=1:8
 Hist00=sid_spectr(peaks,5,2^(i-1),1);
 H(:,i+1)=Hist00(:,2);
 np(i)=calc_noise(Hist00(:,2),20);
end;
 H(:,1)=Hist00(:,1);
for i=2:9
    for ii=2:9
        m_dp(i-1,ii-1)=s_diff(H(:,i),H(:,ii));
    end;
end;
cm=colormap(hsv(9));
figure; hold on; grid on;
for i=1:8
    plot([1,2,4,8,16,32,64,128],m_dp(:,i),'Color',cm(i,:),'.-');
end;
    plot([1,2,4,8,16,32,64,128],np(:),'Color','.-');
