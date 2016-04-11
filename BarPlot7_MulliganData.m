for i = 1:length(timeSpentPerReviewer)
    timeSpentPerReviewer{i,4} = reshape(timeSpentPerReviewer{i,1}', min(size(timeSpentPerReviewer{i,1})).*max(size(timeSpentPerReviewer{i,1})),1);
end

fullVector = timeSpentPerReviewer{1,4};
for i = 2:length(timeSpentPerReviewer)
    fullVector = vertcat(fullVector,timeSpentPerReviewer{i,4});
end
fullVectorMulligan = sort(fullVector);

clear r
%% Calculation of the scientists percentages

% Concaternate vectors and fix of the percentages time vector
temp = timeSpentPerReviewer{1,3}';
for iFixVector = 2:length(reviewersPerReview)
    percentageOfTimeSpent = horzcat(temp,timeSpentPerReviewer{iFixVector,3}');
    temp = percentageOfTimeSpent;
end
percentageOfTimeSpent = sort(percentageOfTimeSpent)';

figure9 = figure;
h = histogram(percentageOfTimeSpent);
binEdges = h.BinEdges(2:end);
binWidth = h.BinWidth;
yValues = histcounts(percentageOfTimeSpent);
close(figure9)

% populationPerBin
populationThatSpendsXTime = zeros(4,5);

populationPerBin(:,2) = yValues/pubmedScientistScenario(1,2); % All authors
populationThatSpendsXTime(1,:) = [ pubmedScientistScenario(1,2)-sum(yValues) sum(yValues(1:10)) sum(yValues(11:25)) sum(yValues(26:50)) sum(yValues(51:end))];
temp1 = populationThatSpendsXTime(1,:)./pubmedScientistScenario(1,2);

populationPerBin(:,3) = yValues/pubmedScientistScenario(1,3); % First/last authors
populationThatSpendsXTime(2,:) = [ pubmedScientistScenario(1,3)-sum(yValues) sum(yValues(1:10)) sum(yValues(11:25)) sum(yValues(26:50)) sum(yValues(51:end))];
temp2 = populationThatSpendsXTime(2,:)./pubmedScientistScenario(1,3);

populationPerBin(:,4) = yValues/pubmedScientistScenario(1,4); % First/second/last authors
populationThatSpendsXTime(3,:) = [ pubmedScientistScenario(1,4)-sum(yValues) sum(yValues(1:10)) sum(yValues(11:25)) sum(yValues(26:50)) sum(yValues(51:end))];
temp3 = populationThatSpendsXTime(3,:)./pubmedScientistScenario(1,4);

populationPerBin(:,5) = yValues/pubmedScientistScenario(1,5); % First/last authors for 3 years
populationThatSpendsXTime(4,:) = [ pubmedScientistScenario(1,5)-sum(yValues) sum(yValues(1:10)) sum(yValues(11:25)) sum(yValues(26:50)) sum(yValues(51:end))];
temp4 = populationThatSpendsXTime(4,:)./pubmedScientistScenario(1,5);

proportionsOfTime = [temp1; temp2; temp3; temp4]';

% Find how much time does the last x percent of scientists devote to peer
% review
x = [0.01 0.025 0.05];
scientistsInPercentage = length(fullVectorMulligan).*x;
helpSum = cumsum(yValues(end:-1:1));
for i = 1:length(x)
    indTemp = find( helpSum >= scientistsInPercentage(i));
    ind(i) = indTemp(1);
end
lastXPercentageLaborMin = binEdges(length(yValues) - ind);
lastXPercentageLaborMax = binEdges(end);