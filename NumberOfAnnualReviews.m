function [ reviews ] = NumberOfAnnualReviews( yearlySubmissions, secondRoundProbability, inHouseAcceptanceRate, resubmissionProbability)

reviewsAndRevisions = round(yearlySubmissions.*resubmissionProbability);
secondRoundPapers = secondRoundProbability.*reviewsAndRevisions(1);
reviews = inHouseAcceptanceRate.*2.5.*(round(reviewsAndRevisions(1)) + secondRoundPapers);

for iRevisions = 2:length(reviewsAndRevisions)
    secondRoundPapers = secondRoundProbability.*reviewsAndRevisions(iRevisions);
    reviews = reviews + inHouseAcceptanceRate.*2.5.*(iRevisions*reviewsAndRevisions(iRevisions) + secondRoundPapers);
end

end

