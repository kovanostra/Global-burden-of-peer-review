% Parameters
a = (0.1:0.05:0.5);
r = (0.6:0.05:0.9);
I = (0.4:0.05:0.8);

percentageOfUnpublished = 0.25; %a(4);
secondRoundProbability = 0.9; %r(end);
inHouseAcceptanceRate = 0.75; %I(end - 3);

for iYears = 1:years
    
    %% Volume of reviews and reviews and reviewers
    % Calculate submissions
    publications = pubmedPublications(iYears,2);
    submissions(iYears) = round((publications*(1 + percentageOfUnpublished)));
    
    % Calculate reviews and reviewers
    reviews(iYears) = NumberOfAnnualReviews( submissions(iYears), secondRoundProbability, inHouseAcceptanceRate, resubmissionProbability) ;
    reviewers(iYears) = reviews(iYears)/sum(reviewingProb.*reviewsPerformed);
    
    %% Time spent in peer review
    scientistsPerTime = round(reviews(iYears).*reviewingTimePercentage);
    totalTime = 0;

    for iTime = 1:length(reviewingTimePercentage)
        tempTime = randsample(reviewingTime(iTime,1):reviewingTime(iTime,2), scientistsPerTime(iTime), true);
        totalTime = totalTime + sum(tempTime);
    end
    totalReviewingTime(iYears) = totalTime;
    yearsOfReview(iYears) = (totalReviewingTime(iYears)/24)/365;
    workingYears(iYears) = (totalReviewingTime(iYears)/8)/(365 - 4*5 - 2*52);

end
totalReviewingTime(1:end-1,2) = (totalReviewingTime(1:end-1,1)-totalReviewingTime(2:end,1))./totalReviewingTime(2:end,1);
