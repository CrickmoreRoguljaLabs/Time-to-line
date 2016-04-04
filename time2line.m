function [ duration ] = time2line( data2, fn, filepath )
%time2line reads in data or excel sheel to convert time points to dashes
%and separate the dashes by genotypes. It can output duration if needed
%   [ duration ] = time2line( data2, fn, filepath )
%   [ duration ] = time2line( data2 ) treats the timepoints in the data2
%   matrix as from the same genotype
%   [ duration ] = time2line( [], fn, filepath ) looks for the data using
%   the file specified by fullfile[filepath,fn]
%   [ duration ] = time2line( ) uses a gui to guide the user to find the
%   specified excel file


% If no inputs are provided, use gui to get the file
if nargin < 1
    % Read in data
    [fn, filepath] = uigetfile('.xlsx');
    [data,text] = xlsread(fullfile(filepath,fn));
    
    % Throw out the first 2 columns
    data2 = data(:,3:end);
end

% If no data are provided, get the data using the path
if isempty(data2)
    % Read in data
    [data,text] = xlsread(fullfile(filepath,fn));
    
    % Throw out the first 2 columns
    data2 = data(:,3:end);
end


% Find out how many rows of data are provided
nsamples = size(data2,1);

% Find out the maximal number of bouts in the data
nmaxbouts = size(data2,2)/2;

% Initiate the duration matrix
duration = zeros(nsamples,nmaxbouts);

% If there is text data, use it to get the genotypes
if exist('text', 'var')
    % In case text contains column titles
    nrows2start_txt = size(text,1) - size(data2) + 1;
    
    % Get the genotypes column
    genos = text(nrows2start_txt:(nrows2start_txt+nsamples-1), 2);

    % Find out how many are unique and their indices
    [genos_unique, ~, genoinx] = unique(genos);
else
    % If no text data are available, set all data to be from the same geno
    genos_unique = 1;
    genoinx = ones(nsamples,1);    
end

% Randomize color
colormat = rand(size(genos_unique,1),3);

% Initiate the figure
figure('Color', [1 1 1])

hold on
for i =1 : nsamples
    % Find out the current genotype index
    current_genoinx = genoinx(i);
    
    for j = 1: nmaxbouts
        % Bout indices
        j1 = (j-1)*2+1;
        j2 = j*2;
        
        if ~isnan(data2(i,j1))
            % Draw the dash
            hline = plot([data2(i,j1), data2(i,j2)], [i i], '-',...
                'LineWidth',6, 'Color', colormat(current_genoinx,:));
            
            % Compute duration
            duration(i,j) = data2(i,j2) - data2(i,j1);
        else
            % Otherwise no duration
            duration(i,j) = NaN;
        end
        
    end
end
hold off

% X-axis = 4.5 hours
xlim([0 270])

% Y-axis
ylim([0 size(data2,1)+0.5])

% Axis labels
xlabel('Time in satiety assay (hours)','FontSize',14)
ylabel('Fly number','FontSize',14)

% Set X ticks
set(gca,'XTick',[0 60 120 180 240 300])
set(gca,'XTickLabel',[0 1 2 3 4 5])

% Set font size
set(gca,'FontSize',14)
end
