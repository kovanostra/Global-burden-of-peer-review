clear all; close all; clc

%% Data
savePath = '/Users/kovanostra/Desktop/PhD/Presentations/Global burden of peer review/images/Full_scenarios';
currentPath = '/Users/kovanostra/Documents/MATLAB/paris/PhD/3.Burden of peer review';

% MEDLINE
load('PubMedFull.mat');
%   pubmedScientistScenario -> 26x5
%   1: Year
%   2: All authors
%   3: First/Last authors
%   4: First/Second/Last authors
%   5: First/Last authors of 3 year period

% NATURE MATERIALS
source{1} = load('NatMatReviewing.mat'); % 2002 - 2012

% PUBLONS
source{2} = load('PublonsReviewing2015.mat'); % 2015
source{3} = load('PublonsReviewing2014.mat'); % 2014
source{4} = load('PublonsReviewing2013.mat'); % 2013

dataSource = 2;
reviewingProb = source{dataSource}.reviewingProb;
reviewsPerformed = source{dataSource}.reviewsPerformed;
name = source{dataSource}.name;
name

% MULLIGAN
mulligan = load('MulliganResubmissions.mat');
resubmissionProbability = mulligan.resubmissionProbabilityMedicine;
%% Preallocation 
publications = [];
years = length(pubmedScientistScenario);
submissions = zeros(years,1);
reviews = zeros(years,1);
reviewers = zeros(years,1);
reviewingTime = zeros(years,1);
yearsOfReview = zeros(years,1);
workingYears = zeros(years,1);
load('MulliganTimeSpent.mat');
reviewingTimePercentage = reviewingTimePercentageMedicine;

%% Main processes
Calculations

%% Plots
YMatrixGeneral = [pubmedScientistScenario(end:-1:1,2)'; pubmedScientistScenario(end:-1:1,3)';...
    pubmedScientistScenario(end:-1:1,4)'; pubmedScientistScenario(end:-1:1,5)'];
names = {'', 'All authors', 'First/Last authors', 'First/Second/Last authors', 'First/Last authors of 3 year period'};
saveNames = {'BarPlot', 'SubmissionsvsAuthors', 'ReviewersVsAuthors', 'WorkingTime', 'LorenzPlot', ...
    'BarPlotPercentageReviewTime', 'BarPlotPercMulligan', 'BarPlotPercDecreasing'};
fileType = {'.eps', 'epsc'};

% % Bar plot 2015 (First/Last authors)
% Plot1_BarPlot
% 
% % Submissions vs authors
% Plot2_SubmissionsVsAuthors
% 
% % Reviewers vs authors
% Plot3_ReviewersVsAuthors
% 
% % Time available for work vs time to review
% Plot4_WorkingTime
% 
% % Lorenz plot
% Plot5_LorenzPlot
% 
% % Percentage of time spent in peer review 2015 (First/Last authors)
% Plot6_BarPercentageOfTimeInReview

Plot7_BarPLotPercentageOfTimeSpent
close(figure7)
% close all;

% Data input
% DataInput

% Reviews vs reviewers
% ReviewsVsAuthors

varsToSave = {'name', 'percPartTimeWorkers','inHouseAcceptanceRate', 'percentageOfTimeSpent', ...
              'timeSpentPerReviewer', 'percentageOfUnpublished','secondRoundProbability', 'reviewers', ...
              'pubmedPublications', 'pubmedScientistScenario', 'resubmissionProbability', ...
              'percentile95Researchers', 'reviews',  'submissions', 'fullVectorMulligan', 'proportionsOfTime', 'percentile95'...
              'binEdges', 'binWidth', 'yValues', 'lastXPercentageLaborMin', 'lastXPercentageLaborMax'};
save(['Main_results_' name], varsToSave{:})

clearvars('-except', varsToSave{:});