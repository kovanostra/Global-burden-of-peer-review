function [ totalAnnualTime ] = TotalTimeSpentAnnually( reviews, timeSpent )
 
r = rand(1,length(reviews));
time = zeros(1,length(reviews));
parfor j = 1:length(reviews)
    if (r(j) > timeSpent(1))
        time(j) = random('uniform',0,5);
    elseif (r(j) < timeSpent(2))
        time(j) = random('uniform',6,10);
    elseif (r(j) < timeSpent(3))
        time(j) = random('uniform',11,20);
    elseif (r(j) < timeSpent(4))
        time(j) = random('uniform',21,30);
    elseif (r(j) < timeSpent(5))
        time(j) = random('uniform',31,50);
    elseif (r(j) < timeSpent(6))
        time(j) = random('uniform',51,100);
    else
        time(j) = random('uniform',101,150); 
    end
end
totalAnnualTime = sum(time(:));

end

