function [ yearlySubmissions, totalAnnualReviews, reviewers, totalTime ] = AnnualBurden( papersPublications, ...
                                                                                         percentageOfUnpublished, ...
                                                                                         secondRoundProbability, ...
                                                                                         inHouseAcceptanceRate)

% Publications correspond at most to 75% distinct total submissions
yearlySubmissions = round((papersPublications*(1 + percentageOfUnpublished)));
totalAnnualReviews = NumberOfAnnualReviews( yearlySubmissions, secondRoundProbability, inHouseAcceptanceRate) ;                                              


%% Amount of annual reviews performed

% % MULLIGAN DATA
% load('MulliganReviewing.mat');

% % WARE DATA
% load('WareReviewing.mat');

% NATURE MATERIALS DATA
load('NatMatReviewing.mat');

% % PUBLONS DATA
% load('PublonsReviewing2015.mat');
% load('PublonsReviewing2014.mat');
% load('PublonsReviewing2013.mat');

% % FOR MULLIGAN & WARE DATA
% scientistsPerReview = 0;
% reviewsOffered = 0;
% i = 1000;
% while (reviewsOffered < totalAnnualReviews)
% %     scientistsPerReview = round(i.*reviewingProb);
% 
% %     
% %     for iScientists = 1:length(reviewingProb)
% %         temp = randsample(reviewsPerformed(iScientists,1):reviewsPerformed(iScientists,2), scientistsPerReview(iScientists), true);
% %         reviewsOffered = reviewsOffered + sum(temp);
% %     end
%     
%     
%     i = i + 1;
% end
% reviewers = i - 1

% FOR NATURE MATERIALS & PUBLONS DATA
reviewers = totalAnnualReviews/sum(reviewingProb.*reviewsPerformed);

%% Time spent in peer review

% MULLIGAN DATA
load('MulliganTimeSpent.mat');
scientistsPerTime = round(totalAnnualReviews.*reviewingTimePercentage);
totalTime = 0;

for iTime = 1:length(reviewingTimePercentage)
    tempTime = randsample(reviewingTime(iTime,1):reviewingTime(iTime,2), scientistsPerTime(iTime), true);
    totalTime = totalTime + sum(tempTime);
end

end