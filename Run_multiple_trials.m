% This specifies parameter values for a single trial and then runs the 
% 'Generate_data.m' script. It outputs the mean trait value and plots a
% graph of how the trait value changes over time.

clearvars
clc
close all

% Fixed parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
o0 = 0; % Optimum trait value for party 0.
o1 = 1; % Optimum trait value for party 1.
theta = 0.8; % Coreplicon 1 proportional size (i.e., fraction of genome 
% constituted by coreplicon 1 rather than coreplicon 0).
z(1) = 0.5; % Initial trait value.
T=10000;%100000; % Number of time steps.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Variable parameters %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
sigmaR = [0.2 0.4 0.6]; % Range of sigma values. sigma is the std dev for 
% the normal distribution from which trait influencing mutations are drawn.
sR = [0 0.4 0.8]; % Range of s values. s = mu_sup / mu_trait. It is the 
% rate of generating suppressors of first-in-line trait influencers by 
% mutation, divided by the rate of generating trait influencers by 
% mutation. Biological realism would suggest that this should be small 
% (<<1).
lambdaR = [0 0.5 500]; % Range of lambda values. lambda is the rate with 
% which probability of being suppressed drops off with larger positions in 
% the 'trait-influencer queue'. lambda=0 implies no drop off; lambda 
% approaching infinity means only the first trait influencer in the queue 
% may be suppressed. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

resmat = nan(3,3,3); % This generates an empty matrix to be filled with 
% results.

% The following three 'for loops' loop across all values of sigma, s and
% lambda, generating data for each.
for cur_sigma = 1:length(sigmaR)

    sigma = sigmaR(cur_sigma);

for cur_s = 1:length(sR)

    s = sR(cur_s);

for cur_lambda = 1:length(lambdaR)

    lambda = lambdaR(cur_lambda);

Generate_data

resmat(cur_sigma,cur_s,cur_lambda) = mean(z(round(T/4):T)); % For each 
% value of sigma, s and lambda, the mean trait value (recorded for the 
% latter 3/4 of generations, to allow for an acclimatisation period) is
% added into the results matrix.

end
end
end

save('results_test.mat') % This saves the results.

% Results are plotted as scatter graphs %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure
scatter(resmat(:,1,3),sigmaR,500,"x",'k','LineWidth',3)
hold on
scatter(resmat(:,2,3),sigmaR,500,"x",'r','LineWidth',3)
scatter(resmat(:,3,3),sigmaR,500,"x",'b','LineWidth',3)
hold off
xline(theta,'LineStyle','--')
%title('No suppression')
xlim([0.5 1])
ylim([0 0.8])
ylabel('Mutation size (\sigma)')
xlabel('Resulting trait value (z)')
box off
fontsize(16,"points")
set(gcf,'color','w');

figure
scatter(resmat(:,1,1),sigmaR,500,"x",'k','LineWidth',3)
hold on
scatter(resmat(:,2,1),sigmaR,500,"x",'r','LineWidth',3)
scatter(resmat(:,3,1),sigmaR,500,"x",'b','LineWidth',3)
hold off
xline(theta,'LineStyle','--')
%title('No suppression')
xlim([0.5 1])
ylim([0 0.8])
ylabel('Mutation size (\sigma)')
xlabel('Resulting trait value (z)')
box off
fontsize(16,"points")
set(gcf,'color','w');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%