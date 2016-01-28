TrainingFiles = dir('NovemberDay/*.jpg');
TrainingFileNames = {TrainingFiles(3:end).name};

load visibilityNovember

num_samples = 500;



variations_hor = zeros(num_samples,1);
grad_vert = zeros(num_samples,1);
for i=1:num_samples
    image = double(imread(strcat('NovemberDay/',TrainingFileNames{i})))/255;
    image = image(25:end,5:end-5,:);
    [~, T, ~, ~,~] = dehaze(image, 0.95, 10);
    %R - Result
    %plot(mean(T'),'b-')
%     plot(mean(T),'b-')
%     drawnow
%     F(i) = getframe;
%     F_pictures(i) = im2frame(image);
    %figure(i)
    %subplot(17,2,i)
    %title(TrainingFileNames{i})
    
   % Compute statistics of the transmission curve
   trans_hor = mean(T);
   trans_vert = mean(T');
   variations_hor(i) = sum(abs(trans_hor(2:end)-trans_hor(1:end-1)));
   %grad_vert(i) = max(trans_vert(2:end)-trans_vert(1:end-1));
   [max_now,ind_now] = max(trans_vert(2:end)-trans_vert(1:end-1));
   grad_vert(i) = ind_now/length(trans_vert);
   disp(['Done: ',num2str(i)])
end
figure
for i = 1:num_samples
    if visibilityNovember(i)>1000
        color_str = '.g';
        plot(variations_hor(i),grad_vert(i),color_str,'MarkerSize',16), hold on
    elseif 500<visibilityNovember(i) && visibilityNovember(i)<=1000
        color_str = '.b';
        plot(variations_hor(i),grad_vert(i),color_str,'MarkerSize',16), hold on
    elseif 200<visibilityNovember(i) && visibilityNovember(i)<=500
        color_str = '.r';
        plot(variations_hor(i),grad_vert(i),color_str,'MarkerSize',16), hold on
    elseif 0<=visibilityNovember(i)  && visibilityNovember(i)<=200 
        color_str = '.k';
        plot(variations_hor(i),grad_vert(i),color_str,'MarkerSize',16), hold on
    end
    xlabel('Total variation of horizontal means','FontSize',16)
    ylabel('Position of maximal jump','FontSize',16)
    title('Correlation of vertcial and horizontal data')
end

  
% sky = (image(:,:,1)>A(1)).*(image(:,:,2)>A(2)).*(image(:,:,3)>A(3));
% imshow(sky.*T)
