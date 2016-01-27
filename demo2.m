% we compute depth images naddifferent statistics for 10.2015
% we have measurements from fogmeter:)
%% Open pool
parpool local

%% loading measurements
load('measurements.mat')

% folder with files
file = dir('TRAINING/*.jpg');
fileName = {file.name}; 

% strucute for storing data
dataStruct(length(fileName),1) = struct('radiance',[],'transmission',[],...
    'trans_est',[],'atmosphere',[],'dark_channel',[],'date',[],'vis',[]);

%% performing operations
parfor i=1:length(fileName)
    tic
    image = double(imread(strcat('TRAINING/',fileName{i})))/255;
    image = image(25:end,5:end-5,:); %removing frame
    nameSplit = strsplit(strrep(fileName{i},'.jpg',''),'_');
    
    % extracting datetime from filename
    tempDate = datetime(strcat(nameSplit{2},nameSplit{3}),...
        'InputFormat','yyyyMMddHHmm');
    
    % get data from measurements
    vis = interp1(datenum(measurements{:,1}),measurements{:,2},...
        datenum(tempDate));
    
    % looking 
    [R, T, T_est, A, D] = dehaze(image, 0.95, 10);
    
    % storing data
    dataStruct(i) = struct('radiance',R,'transmission',T,...
    'trans_est',T_est,'atmosphere',A,'dark_channel',D,'date',datenum(tempDate),...
    'vis',vis);
    % saving every 50 images
%     if rem(i,50)==0 ||i==length(fileName)
%         save('results_training.mat','dataStruct')
%     end

    disp(['Done: ',num2str(i),' time: ', num2str(toc)])
end
  
% sky = (image(:,:,1)>A(1)).*(image(:,:,2)>A(2)).*(image(:,:,3)>A(3));
% imshow(sky.*T)

%% plotting and unerstanding part

vis = cell2mat({dataStruct(1:length(fileName)).vis});
date = cell2mat({dataStruct(1:length(fileName)).date});
dateTime = datetime(date', 'ConvertFrom', 'datenum');
for i=1:length(fileName)
    trans(i,:) = mean(dataStruct(i).transmission);
end

%% plotting
figure
plot(trans')

%%
for i=1:length(fileName)
    if rem(i,10)==1
        figure('units','normalized','outerposition',[0 0 1 1])
    end
    ind = rem(i,10);
    if ind==0
        ind = 10;
    end
    subplot(2,5,ind)
    plot(flipud(trans(i,:)'))
    title([datestr(dateTime(i)),' ',num2str(vis(i))])
end
    
    

%mesh(dataStruct(10).transmission)
