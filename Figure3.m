clc; close all;
% Create figure
figure1 = figure;

%% Create axes
axes1 = axes('Parent',figure1,...
    'Position',[0.0669693530079455 0.586898395721925 0.885362253209671 0.373621943916418]);
hold(axes1,'on');

% Create xlabel
xlabel('Authors (%)');

% Create ylabel
ylabel('Reviews (%)');

% Create title
title('A');

names = {'','All authors', '1^{st} or last authors', '1^{st}, 2^{nd} or last last authors',...
    ['1^{st} or last authors -',sprintf('\n'),'last 3 years']};

colors = {[0.313725501298904 0.313725501298904 0.313725501298904],...
          [0.850980401039124 0.325490206480026 0.0980392172932625],...
          [0.929411768913269 0.694117665290833 0.125490203499794],...
          [1 0.600000023841858 0.7843137383461]};

aa = cell(4);
for i = 2:min(size(pubmedScientistScenario))
    totalAuthors = pubmedScientistScenario(1,i);
    noReviewsPercentage = (1 - reviewers(1)/totalAuthors);
    authorPercentages = [reviewers(1).*reviewingProb(end:-1:1)./totalAuthors noReviewsPercentage];
    authorPercentages = cumsum(authorPercentages);
    temp = reviewers(1).*reviewingProb(end:-1:1).*reviewsPerformed(end:-1:1);
    temp(length(reviewingProb) + 1) = 0;
    reviewsPercentages = cumsum(temp)./reviews(1);
    if i == 2
        a = plot(authorPercentages,authorPercentages,'DisplayName','Equal labor','LineStyle','--','LineWidth',2,...
            'Color',[0.925490200519562 0.839215695858002 0.839215695858002]);
        b = plot(1,'Parent',axes1,'DisplayName','Potential reviewers:','LineStyle','none');
    end
    help{i-1}(:,1) = authorPercentages';
    help{i-1}(:,2) = reviewsPercentages';
    c(i) = plot(100.*authorPercentages, 100.*reviewsPercentages, 'LineWidth', 2,...
                'Color', colors{i-1}, 'DisplayName', names{i});
    aa{i-1}(:,1) = authorPercentages; 
    aa{i-1}(:,2) = reviewsPercentages;
end


% Uncomment the following line to preserve the X-limits of the axes
xlim(axes1,[0 100]);
box(axes1,'on');
ylim(axes1,[0 100]);
box(axes1,'on');


% Create legend
legend1 = legend([a b c(2) c(5) c(4) c(3)],...
                            {'Equal labor',...
                            'Potential reviewers:',...
                             'All authors',...
                             ['1^{st} or last authors -',sprintf('\n'),'last 3 years'],...
                             '1^{st}, 2^{nd} or last authors',...
                             '1^{st} or last authors'});
set(legend1, 'Location','best');

%% Create axes
axes2 = axes('Parent',figure1,...
    'Position',[0.0669693530079455 0.0521390374331551 0.885362253209671 0.401069518716578]);
hold(axes2,'on');

% Blue = [0 100 190]./255;
% Red = [210 70 0]./255;
% Yellow = [255 160 30]./255;
% Grey: 70%

proportionsOfTime1 = proportionsOfTime(:,[1 4 3 2]);
proportionsOfTime1(:,2) = proportionsOfTime1(:,2) - [0.05 -0.01 -0.01 -0.01 -0.01]';

% Create bar
plot(1,'Parent',axes2,'DisplayName','Potential reviewers:','LineStyle','none')
plot1 = plot(proportionsOfTime1,'Parent',axes2);
set(plot1(2),'DisplayName',['1^{st} or last authors -',sprintf('\n'),'last 3 years'],...
    'Color',[1 0.600000023841858 0.7843137383461],'LineWidth',2);
set(plot1(4),'DisplayName','1^{st}, 2^{nd} or last authors',...
    'Color',[0.929411768913269 0.694117665290833 0.125490203499794],'LineWidth',2);
set(plot1(3),'DisplayName','1^{st} or last authors',...
    'Color',[0.850980401039124 0.325490206480026 0.0980392172932625],'LineWidth',2);
set(plot1(1),'DisplayName','All authors',...
    'Color',[0.313725501298904 0.313725501298904 0.313725501298904],'LineWidth',2);

% Create xlabel
xlabel('Work time devoted to peer review','HorizontalAlignment','center');

% Create ylabel
ylabel('Authors (%)');

% Authors'' work time devoted to peer review
title('B',...
    'HorizontalAlignment','center',...
    'FontWeight','bold');

xlim(axes2,[1 5]);
ylim(axes2,[0 1.]);
box(axes2,'on');
% Set the remaining axes properties
set(axes2,'XTick',[1 2 3 4 5],'XTickLabel',...
    {'0%','0.1 - 1%','1.1 - 2.5%','2.6 - 5%','> 5%'},'YTickLabel',...
    {'0','10','20','30','40','50','60','70','80','90','100'});
% Create legend
legend2 = legend(axes2,'show');
set(legend2,'Location','northeast');
