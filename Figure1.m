clc; close all;
% Create figure
figure1 = figure;

%% Create axes
axes5 = axes('Parent',figure1,...
    'Position',[0.558549222797927 0.0520694259012016 0.414507772020725 0.436683130336017]);
hold(axes5,'on');

% Create bar
bar(100*reviewingTimePercentageMedicine,'Parent',axes5,...
    'FaceColor',[0.20392157137394 0.301960796117783 0.494117647409439],...
    'EdgeColor','none');

% Create xlabel
xlabel('Time spent per review (h)','Units','pixels',...
    'HorizontalAlignment','center');

% Create ylabel
ylabel('Reviews (%)');

% Distribution of time spent per review
title('D','FontWeight','bold');

xlim(axes5,[0.5 6.5]);
box(axes5,'on');
% Set the remaining axes properties
set(axes5,'XTick',[1 2 3 4 5 6],'XTickLabel',...
    {'1-5','6-10','11-20','21-30','31-50','51-100'});

%% Create axes
axes3 = axes('Parent',figure1,...
    'Position',[0.558549222797927 0.583837209302326 0.414507772020725 0.376109386158288]);
hold(axes3,'on');

% Create bar
bar(reviewsPerformed,100*reviewingProb,'Parent',axes3,...
    'FaceColor',[0.20392157137394 0.301960796117783 0.494117647409439],...
    'EdgeColor','none');

% Create xlabel
xlabel('Reviews completed per reviewer','HorizontalAlignment','center');

% Create ylabel
ylabel('Reviewers (%)');

% Distribution of peer review effort
title('B','HorizontalAlignment','center',...
    'FontWeight','bold');

xlim(axes3,[0.5 20.5]);
box(axes3,'on');
% Set the remaining axes properties
set(axes3,'XTick',[1 5 10 15 20],'XTickLabel',{'1','5','10','15','20'});

%% Create axes
axes4 = axes('Parent',figure1,...
    'Position',[0.692307692307692 0.745989304812834 0.255744255744256 0.18048128342246]);
hold(axes4,'on');

% Create bar
bar(reviewsPerformed,100*reviewingProb,'Parent',axes4,...
    'FaceColor',[0.20392157137394 0.301960796117783 0.494117647409439],...
    'EdgeColor','none');

% Create title
title('');

xlim(axes4,[20.5 101]);
box(axes4,'on');
% Set the remaining axes properties
set(axes4,'Color',[0.933333337306976 0.933333337306976 0.933333337306976],...
    'XTick',[21 40 60 80 100],'XTickLabel',{'21','40','60','80','100'});


%% Create axes
axes1 = axes('Parent',figure1,...
    'Position',[0.0669693530079455 0.583837209302326 0.408678315385837 0.376109386158288]);
hold(axes1,'on');

% Create semilogy
semilogy(pubmedPublications(end:-1:1,2),'Parent',axes1,'LineWidth',4,...
    'Color',[0.20392157137394 0.301960796117783 0.494117647409439],...
    'DisplayName','Publications');

% Create xlabel
xlabel('Year');

% Create ylabel
ylabel('Number of articles','HorizontalAlignment','center');

% Annual publications in PubMed
title('A','FontWeight','bold');

xlim(axes1,[1 26]);
% ylim(axes1,[300000 10000000]);

box(axes1,'on');
% Set the remaining axes properties
set(axes1,'XTick',[1 6 11 16 21 26],'XTickLabel',...
    {'1990','1995','2000','2005','2010','2015'},'YScale','log');

% % Create legend
% legend1 = legend(axes1,'show');
% set(legend1,'Location','northwest','FontSize',13);


%% Create axes
axes2 = axes('Parent',figure1,...
    'Position',[0.0669693530079455 0.0520694259012017 0.408678315385837 0.436683130336017]);
hold(axes2,'on');

% Create multiple lines using matrix input to semilogy
semilogy1 = semilogy(pubmedScientistScenario(end:-1:1,2:5),'Parent',axes2,'LineWidth',4);
set(semilogy1(1),'DisplayName','All authors',...
    'Color', [0.313725501298904 0.313725501298904 0.313725501298904]);
set(semilogy1(2),'DisplayName','1^{st} or last authors',...
    'Color',[0.850980401039124 0.325490206480026 0.0980392172932625]);
set(semilogy1(3),'DisplayName','1^{st}, 2^{nd} or last authors',...
    'Color',[0.929411768913269 0.694117665290833 0.125490203499794]);
set(semilogy1(4),...
    'DisplayName',['1^{st} or last authors -',sprintf('\n'),'last 3 years'],...
    'Color',[1 0.600000023841858 0.7843137383461]);

% Create xlabel
xlabel('Year');

% Create ylabel
ylabel('Number of authors');

% Distinct authors who published in a given year
title('C','FontWeight','bold');

xlim(axes2,[1 26]);
ylim(axes2,[300000 10000000]);
box(axes2,'on');
% Set the remaining axes properties
set(axes2,'XTick',[1 6 11 16 21 26],'XTickLabel',...
    {'1990','1995','2000','2005','2010','2015'},'YScale','log');
% Create legend
legend2 = legend([semilogy1(1) semilogy1(4) semilogy1(3) semilogy1(2)],...
                            {'All authors',...
                             ['1^{st} or last authors -',sprintf('\n'),'last 3 years'],...
                             '1^{st}, 2^{nd} or last authors',...
                             '1^{st} or last authors'});
set(legend2,'Location','northwest','FontSize',13);

% Create textbox
annotation(figure1,'textbox',...
    [0.772300238621482 0.811935621249621 0.109880829015544 0.0401069518716578],...
    'String',{'> 20 reviews'},...
    'FontWeight','bold',...
    'FontSize',11,...
    'FitBoxToText','off',...
    'EdgeColor','none');

% Create arrow
annotation(figure1,'arrow',[0.97411189846423 0.824889100536768],...
    [0.585713226021808 0.708707878428225],'LineWidth',2);