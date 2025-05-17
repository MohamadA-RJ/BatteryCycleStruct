% This Code is used for transfering the raw battery data from battery
% management Systems (BMS) to a form simialr to the ones used in the NASA batteries database which is 
% widely used in the battery community. These can be accessed from B. Saha and K. Goebel (2007). 
% "Battery Data Set", NASA Ames Prognostics Data Repository 
% (https://www.nasa.gov/intelligent-systems-division), NASA Ames Research Center, Moffett Field, CA

% The goal is to separate the voltage/current/capacity from each respective
% cycle and categorize the data in a structure format and separate them
% into charging/discharging/rest steps 


%%
% If you use this code please reference it accodring to the assocaited paper: 
% M. A. Raja, W. Kim, W. Kim, S. H. Lim, and S. S. Kim, 
% “Computational micromechanics and machine learning-informed design of composite carbon fiber-based structural battery for multifunctional performance prediction,” 
% ACS Applied Materials &amp; Interfaces, vol. 17, no. 13, pp. 20125–20137, Feb. 2025. doi:10.1021/acsami.4c19073 
%%
clear all;
close all;
%% Specify the Excel file name

excel_file = 'SPE40_0.1C.xlsx'; % Update with your actual file name, I am using my file as an example

%% Load data from the Excel file (Multiple Sheets)

% Get the sheet names from the Excel file
[~, sheet_names] = xlsfinfo(excel_file);

% Initialize variables to store combined data
combined_data = [];

% Loop through each sheet to read and combine the data`
for sheet_index = 1:length(sheet_names)
    % Load data from the current sheet
    data = xlsread(excel_file, sheet_names{sheet_index});

    % Append the data to the combined data
    combined_data = [combined_data; data];
end

data = combined_data;
%%
% Set the current threshold for resting
resting_threshold = 1e-15; % This one depends on your profile of the current and the BMS resolution

% Initialize a structure to store charging and discharging data
SPE40_0p1C = struct('cycles', struct('type', {}, 'data', {}));

% Initialize variables for tracking rest periods
isResting = false;
restStartTime = 0;

% Initialize cycle count
cycle_count = 0;

% Loop through the data to separate into charging and discharging cycles
for i = 1:length(data(:,1))
    % Check for rest period
    if abs(data(i,3)) < resting_threshold
        if ~isResting
            isResting = true;
            restStartTime = data(i,1);
        end
        continue; % Skip rest periods
    else
        isResting = false;
    end
    
    % Determine cycle type (charge or discharge)
    if data(i,3) > 0           % If the current is postive its charging data
        cycleType = 'charging';
    elseif data(i,3) < 0
        cycleType = 'discharging';% If the current is negaftive its discharging data 
    else
        continue; % Skip if current is zero
    end
    
    % Store the data in the structure
    if isempty(SPE40_0p1C.cycles) || ~strcmp(SPE40_0p1C.cycles(end).type, cycleType)
        % Create a new structure if the type changes
        cycle_count = cycle_count + 1;
        if cycle_count > 1656  % This is Equal to 828 Cycles, Since each cycle has charging and discharging 
            break;
        end
        SPE40_0p1C.cycles(end+1).type = cycleType;
        SPE40_0p1C.cycles(end).data.test_time = data(i,1);
        SPE40_0p1C.cycles(end).data.Voltage_measured = data(i,2);
        SPE40_0p1C.cycles(end).data.Current_measured = data(i,3);
        SPE40_0p1C.cycles(end).data.capacity = data(i,4);
    else
        % Append data to the existing structure
        SPE40_0p1C.cycles(end).data.test_time = [SPE40_0p1C.cycles(end).data.test_time data(i,1)];
        SPE40_0p1C.cycles(end).data.Voltage_measured = [SPE40_0p1C.cycles(end).data.Voltage_measured data(i,2)];
        SPE40_0p1C.cycles(end).data.Current_measured = [SPE40_0p1C.cycles(end).data.Current_measured data(i,3)];
        SPE40_0p1C.cycles(end).data.capacity = data(i,4); % Store only the last capacity value
    end
end

% This step is oly important if u plan to use your data for machine
% learning for example. as it makes normalalizatin easier

% Adjust test_time for each cycle type (charging and discharging) to start from zero 
for i = 1:length(SPE40_0p1C.cycles)
    % Adjust test_time if data exists
    if isfield(SPE40_0p1C.cycles(i).data, 'test_time')
        first_test_time = SPE40_0p1C.cycles(i).data.test_time(1);
        SPE40_0p1C.cycles(i).data.test_time = SPE40_0p1C.cycles(i).data.test_time - first_test_time;
    end
end

% Save the structure to a MAT file
save('SPE40_0p1C.mat', 'SPE40_0p1C');