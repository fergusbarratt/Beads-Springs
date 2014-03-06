clear all
close all
%% Input
% generate inputs from problem sheet
testinput1 = ones(1, 21);
testinput2 = 1:9;
% choose between end-user input, testinput1, testinput2

%ks = input('Please enter a vector of at least 3 spring constants ');
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
% invert matrix before for loop
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
% next is plotted, hold released after loop
for i = 1:number_of_masses;
    plot(mass_numbers, displacements(:, i), '-o');
    hold all
end
hold off
% set graph properties for first plot window: title, axis labels, 
% integer x axis ticks. Use sprintf in
% title function to insert newline (\n)
title(sprintf('Displacement of each bead when unit force \n applied to different bead numbers'));
xlabel('Bead #');
ylabel('Displacement of each bead/m');
set(gca,'XTick',1:number_of_masses)
leg_vals = cellstr(num2str((1:number_of_masses)', '%-d'));
leg = legend(leg_vals, 'Position', [0.03 0.5 0.05 0.1]);
legtitle = get(leg, 'title');
set(legtitle, 'string', 'Unit force applied to Bead:');

%% Plot 2
% plot modes in second plot window
subplot(1, 3, 2);
% calculate angular frequency of normal modes using kx = omega^2x. alias
% number of masses to mode_numbers to avoid confusion
% calculate both eigenvalues and eigenvectors, eigenvectors are used in
% later question. vals(vals~=0) extracts eigenvalues off the diagonal into
% vector. works for zero eigenvalues because of floating points. vecs used
% in plot 3
[vecs, vals] = eig(K);
modes = sqrt(vals(vals~=0));
mode_numbers = 1:number_of_masses;
plot(mode_numbers, modes, '.-');
% set graph properties for second plot window: title, axis labels,
% integer x axis ticks
xlabel('Mode #');
ylabel('Angular Frequency / Rad/s');
set(gca,'XTick',1:number_of_masses)
title('Angular Frequency of Normal Modes');

%% Plot 3
% plot displacements in different modes(question 5) in third window
subplot(1, 3, 3);
% displacements are eigenvectors
for i = 1:3;
    plot(1:3, vecs(1:3, i), '-o');
    hold all
end
hold off
% set graph properties: axis labels, integer x axis ticks
title(sprintf('Displacement of each bead\n to produce first three normal modes'));
xlabel('Bead #');
ylabel('Displacement of each bead/m');
set(gca,'XTick',1:3);


