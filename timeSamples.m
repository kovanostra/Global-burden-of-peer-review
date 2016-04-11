function [ totalTimePercentage ] = timeSamples( reviewsAverage, reviewingTimePercentage, reviewingTime )
scientistsPerTime = round(reviewsAverage.*reviewingTimePercentage);
totalTime = 0;
for iTime = 1:length(reviewingTimePercentage)
    tempTime = randsample(reviewingTime(iTime,1):reviewingTime(iTime,2), scientistsPerTime(iTime), true);
    totalTime = totalTime + sum(tempTime);
end
totalTimePercentage = totalTime/((365-52*2-30)*8);

end

