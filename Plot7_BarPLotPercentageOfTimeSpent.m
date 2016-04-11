%% Initialization
clear tempBins timePerBin populationPerBin bins k minValue maxValue tempMin tempMax
close all; %clc;

reviewersPool = reviewers(1);
reviewersPerReview(:,1) = round(reviewersPool.*reviewingProb');
reviewersPerReview(:,2) = reviewsPerformed';
timeSpentPerReviewer = cell(length(reviewersPerReview));
percPartTimeWorkers = zeros(length(reviewersPerReview),3);

hours = 8;
year = 365;
weekends = 2*52;
holidays = 25.3;
fullTime = 0.56;
fullWorkYearHours = hours*(year - weekends - holidays);
percPartTimeWorkers(:,1) = round(fullTime.*reviewersPerReview(:,1));

halfTime = 0.22;
halfWorkYearHours = fullWorkYearHours/2;
percPartTimeWorkers(:,2) = round(halfTime.*reviewersPerReview(:,1));

thirtyTime = 0.22;
thirtyWorkYearHours = fullWorkYearHours*0.3;
percPartTimeWorkers(:,3) = round(thirtyTime.*reviewersPerReview(:,1));

workYearHours = [fullWorkYearHours halfWorkYearHours thirtyWorkYearHours];

for iPreallocate = 1:length(reviewersPerReview)
    timeSpentPerReviewer{iPreallocate,1} = zeros(reviewersPerReview(iPreallocate),reviewsPerformed(iPreallocate));
end

%% Calculation of time spent in reviewing
for iSampleHours = 1:length(reviewingTime)
    hoursToSample{iSampleHours} = (reviewingTime(iSampleHours,1):0.1:reviewingTime(iSampleHours,2));
end

tempPercentage = cumsum(reviewingTimePercentage);
for iReviewGroup = 1:length(reviewersPerReview)
    r = rand(reviewersPerReview(iReviewGroup),reviewsPerformed(iReviewGroup));
    decreaseFactor = (1 - 0.005*reviewsPerformed(iReviewGroup));
    for iReview = 1:reviewersPerReview(iReviewGroup,2)
        sampleIndexes = datasample([1:length(reviewingTime)]', reviewersPerReview(iReviewGroup,1), 'Weights', reviewingTimePercentage');
        for iReviewer = 1:reviewersPerReview(iReviewGroup,1)
            timeSpentPerReviewer{iReviewGroup,1}(iReviewer,iReview) = randsample(hoursToSample{sampleIndexes(iReviewer)}, true);
        end
    end
    
    for iReviewer = 1:reviewersPerReview(iReviewGroup,1)
        % Total time spent for reviewing per scientist
        timeSpentPerReviewer{iReviewGroup,2}(iReviewer,1) = sum(timeSpentPerReviewer{iReviewGroup,1}(iReviewer,:));
    end

    % Percentage of time compared to total work time
    if (isempty(timeSpentPerReviewer{iReviewGroup,2})) == 0
        indexStart = 1;
        indexStop = percPartTimeWorkers(iReviewGroup,1);
        for ipartTimeResearchers = 1:3 
            timeSpentPerReviewer{iReviewGroup,3}(indexStart:indexStop,1) = ...
                timeSpentPerReviewer{iReviewGroup,2}(indexStart:indexStop,1)./workYearHours(ipartTimeResearchers);
            indexStart = indexStop + 1;
            if (ipartTimeResearchers < 2)
                indexStop = indexStop + percPartTimeWorkers(iReviewGroup,ipartTimeResearchers + 1);
            elseif (ipartTimeResearchers == 2)
                indexStop = length(timeSpentPerReviewer{iReviewGroup,2});
            end
        end
    end
end


% Use data from Mulligan
BarPlot7_MulliganData;
percentile95 = prctile(percentageOfTimeSpent,95)
b = find(percentageOfTimeSpent == percentile95);
percentile95Researchers = (length(percentageOfTimeSpent) - b(1))./pubmedScientistScenario(1,2:5);

figIndex = 7;
perc = 100;
xMax = 0.1 * perc;
yMax = max(populationPerBin(:,3)) * perc + 1;
BarPlot7_PlotScript

% % Use constant time of 5 hours
% BarPlot7_ConstantTime
% figIndex = 8;
% BarPlot7_PlotScript

% % Use decreasing time
% BarPlot7_DecreasingTime
% figIndex = 8;
% BarPlot7_PlotScript