% This script generates single-trial data for Fisher's geometric model
% generalised to allow 2 parties (coreplicons) and suppressors. Note that
% this script will not run without specifying values for o0, o1, theta,
% z(1), T, sigma, s, lambda. Calling this script from 'Run_single_trial' or
% Run_multiple_trials' will ensure that these parameters are specified.

for t=1:T % Loop over time steps. Each time step, a new mutation arises. 
    % This mutation may be a trait influencer or suppressor, and belong to 
    % coreplicon 1 or 0 (to be determined). The mutation may either fix or 
    % be lost from the popualtion (to be determined). 
    
coreprand = rand; % This random number will be used to assign the new 
% mutation to coreplicon 1 or 0. If theta>corep then it will belong to 
% coreplocon 1. If theta<corep then it will belong to coreplocon 0.
suprand = rand; % This random number will be used to determine whether the 
% new mutation is a suppressor or trait influencer. 
mut = normrnd(0,sigma); % This will give the direction and magnitude of a 
% change in trait value, if the new mutation turns out to be a trait 
% influencer rather than a suppressor. 

% 'dist_list' is an array containing the 'mut' values for all
% previously-fixed trait influencers. In the 'double-if' statement directly
% below, I am determining 'suptot', which is the probability that the new
% mutation is a suppressor rather than a trait influencer. The 'double-if' 
% statement ensures that suptot is only nonzero if there are already trait
% influencers available to suppress - if there are no trait influencers
% available to suppress, suptot is set to zero.
if exist('dist_list') == 1   
if isempty(dist_list)==0
xx = s.*(sum(exp(-lambda.*([fliplr(1:length(dist_list))]-1)))); % xx is a 
% variable that we define only in the service of calculating 'suptot'.
suptot = xx ./ (xx+1); % The rationale behind the expression for 'suptot' 
% is given in the main text.
else
suptot=0;
end
else
suptot=0;
end

% The following 'if statement' is used to determine whether the new
% mutation is a suppressor or trait influencer. If the condition is
% satisfied (i.e., if suptot>sup), then the new mutation is a suppressor;
% if not, it is a trait influencer.
if suptot>suprand

% Given that the new mutation is a suppressor, the line below serves to 
% pick out a trait influencer from 'dist_list' for suppression. The
% relative probability of different trait influencers being picked out is
% determined by their position in the 'trait influencer queue', with more
% recent trait influencers being more likely to be suppressed (as long as
% lambda>0).
supmut = randsample(dist_list,1,true,exp(-lambda.*([fliplr(1:length(dist_list))]-1)));

% Given that the new mutation is a suppressor, and targets the
% trait-influencer given by 'supmut', the below 'if statement' determines
% whether the suppressor fixes or is lost. Fixation occurs if the trait (z)
% is moved towards the optimum trait value for the suppressor's coreplicon.
if ((theta>coreprand && (o1-z(t)+supmut)^2 < (o1-z(t))^2 ) || (theta<coreprand && (o0-z(t)+supmut)^2 < (o0-z(t))^2 ))  
    
dist_list(dist_list == supmut) = []; % This ensures that suppressed trait 
% influencers are removed from the list of fixed trait influencers. This
% reflectes an assumption that trait influencers are lost from the
% popualtion after being suppressed.

z(t+1)=z(t)-supmut; % This changes the trait value to a new value, undoing 
% the previous effect of the trait influencer that has now been suppressed.

else % This 'else' statement accounts for occasions where a suppressor has 
    % arisen by mutation but has not fixed. The trait value is accordingly
    % unchanged.

    z(t+1)=z(t);

end 

% The 'elseif' statement below accounts for occasions where a trait
% influencer rather than suppressor has arisen, and where the trait
% influencer fixes in the population (because it brings the trait closer
% towards the optimum of the coreplicon to which the trait influencer
% belongs).
elseif suptot < suprand && ((theta>coreprand && (o1-z(t)-mut)^2 < (o1-z(t))^2 ) || (theta<coreprand && (o0-z(t)-mut)^2 < (o0-z(t))^2 ))  

% The following 'double if' statement is used to determine the position of 
% the 'dist_list' array to add the newly fixed trait influencer into. If 
% 'dist_list' is as-yet undefined or empty, this position ('pos') will be 1
% (i.e., the first position in the array). If 'dist_list' already has 
% entries, the 'dist_list' array will be expanded by one, and the new trait
% influencer will be added to the last position in this array.       
if exist('dist_list') == 1   
if isempty(dist_list)==0
    pos=length(dist_list)+1;
else
    pos=1;
end
else
    pos=1;
end

dist_list(pos) = mut; % This adds the newly fixed trait influencer to the 
% 'dist_list' array.

z(t+1)=z(t)+mut; % This changes the trait value to a new value, in line 
% with the magnitude and direction of the newly-fixed trait influencer. 

else % This 'else' statement accounts for occasions where a trait 
    % influencer has arisen by mutation but has not fixed. The trait value 
    % is accordingly unchanged.

z(t+1)=z(t);

end
end

