
clear all
close all

%% Input
% generate inputs from problem sheet
testinput1 = ones(1, 21);
testinput2 = 1:9;
% choose between end-user input, testinput1, testinput2

%ks = input('Please enter a vector of at least 2 spring constants ');
ks = testinput1;
%ks = testinput2;

% define for utility
number_of_masses = size(ks, 2)-1;

%% Initalisation
% construct K matrix
K1 = zeros(1, number_of_masses);
K2 = zeros(1, number_of_masses-1);
for i = 1:(number_of_masses);
    K1(i) = ks(i)+ks(i+1);
end
for i = 1:number_of_masses-1;
    K2(i) = -ks(i+1);
end
K = diag(K1) + diag(K2, -1) + diag(K2, 1);

%% Forces
% Unit forces are vectors produced by rows of the identity matrix indexed
% by bead number
% initialise blank displacements vector to be added to by for loop
% invert matrix before for loop for speed
forces = eye(number_of_masses);
displacements = zeros(number_of_masses);
inverted = inv(K);
for i = 1:number_of_masses;
    displacements(:, i) = -inverted*forces(:, i);
end
mass_numbers = 1:number_of_masses;

%% Plot 1
subplot(1, 3, 1);
% plot displacements in first plot window. hold all keeps each line as the
% next is plotted, hold released after loop. all instead of on to maintain
% colour changes
for i = 1:number_of_masses;
    plot(mass_numbers, displacements(:, i), '-o');
    hold all
end
hold off

% Set graph properties for first plot window: title, axis labels, integer x axis ticks. 
% Use sprintf in title function to insert newline (\n)
title(sprintf('Displacement of each bead when unit force \n applied to different bead numbers'));
xlabel('Bead #');
ylabel('Displacement of each bead/m');
set(gca,'XTick',1:number_of_masses)

% Generate legend dynamically from input
leg_vals = cellstr(num2str((1:number_of_masses)', '%-d'));
leg1 = legend(leg_vals, 'Position', [0.03 0.5 0.05 0.1]);
legtitle = get(leg1, 'title');
set(legtitle, 'string', 'Unit force applied to Bead:');

%% Plot 2
% Plot modes in second plot window
subplot(1, 3, 2);
% Calculate angular frequency of normal modes using kx = omega^2x. Alias
% number of masses to mode_numbers to avoid confusion.
% Calculate both eigenvalues and eigenvectors, eigenvectors are used in
% later question. vals(vals~=0) extracts non-zero eigenvalues off the diagonal into
% vector modes, still works for zero eigenvalues because of floating points
[vecs, vals] = eig(K);
modes = sqrt(vals(vals~=0));
mode_numbers = 1:number_of_masses;
plot(mode_numbers, modes, '.-');

% Set graph properties for second plot window: title, axis labels,
% integer x axis ticks
xlabel('Mode #');
ylabel('Angular Frequency / Rad/s');
set(gca,'XTick',1:number_of_masses)
title('Angular Frequency of Normal Modes');

%% Plot 3
% Plot displacements in different modes(question 5) in third window.
subplot(1, 3, 3);
% Restrict mode plotting to inputs of at least 2 masses. Plot two
% modes if only two masses, 3 otherwise

if number_of_masses == 2;
    modes_to_plot = 2;
else
    modes_to_plot = 3;
end

if (number_of_masses>=2);
    % Displacements are eigenvectors of K calculated in Plot 2. 
    for i = 1:modes_to_plot;
        plot(1:number_of_masses, vecs(:, i), '-o');
        hold all
    end
    hold off
else
    text(0.2, 0.5, 'Too few spring constants for modes plot');
end
    
% Set graph properties: Title, axis labels, integer x axis ticks
% Use sprintf to title graph properly for different numbers of plotted modes
format_spec = 'Displacement of each bead\n to produce first %d normal modes';
title(sprintf(format_spec, modes_to_plot));
xlabel('Bead #');
ylabel('Displacement of each bead/m');
set(gca,'XTick',1:number_of_masses);

% Produce legend dynamically
leg_vals = cellstr(num2str((1:3)', 'Mode %-d'));
leg2 = legend(leg_vals, 'Position', [0.93 0.5 0.05 0.1]);


