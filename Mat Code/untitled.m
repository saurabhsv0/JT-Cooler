% Read Excel file
data = readtable('data.xlsx');

% Display data
disp(data)

% Access specific column
marks = data.ProductID;

% Calculate average
avg = mean(marks);


fprintf('Average Marks = %.2f\n', avg);

dat = readtable('data.xlsx');

value = dat{50,5};   % Row 1, Column 2
disp(value)