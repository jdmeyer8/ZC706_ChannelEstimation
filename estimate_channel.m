%function chEst = estimate_channel()
%if ~exist('rx', 'var')
    %load('testsig.mat');
%end

%%
rxSig = rx_i(:,2) + 1i*rx_q(:,2);
goldSig = gold_i + 1i*gold_q;

%rxSig = rxSig + normrnd(0, 10, size(rxSig));

l_rx = size(rxSig,1);
l_gold = size(goldSig,1);

cross_corr = xcorr(rxSig, goldSig);
%%
%plot(abs(flipud(cross_corr)), '.-');
%title('Cross Correlation','fontweight','bold');
%xlabel('Index','fontweight','bold');
%ylabel('Cross Correlation Magnitude','fontweight','bold');

%%
peakInd_raw = find(cross_corr == max(cross_corr));
peakInd_rx = peakInd_raw - (l_rx - l_gold) - (l_gold-1);
rxInd = peakInd_rx:(peakInd_rx+l_gold-1);

rxExtracted = rxSig(rxInd,:);
chEst = (goldSig\rxExtracted);

%Send