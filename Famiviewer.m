%全ての画像のDICOM情報を取得するとともにDICOM画像を表示する
clear;
clf;


%DICOMファイルが保存されているフォルダのパス
folderPath = uigetdir();

% フォルダ内の全てのファイルを取得
fileList = dir(fullfile(folderPath, '*.dcm'));
numFiles = numel(fileList);

% DICOMファイルの情報を格納するためのセル配列
dicomInfoCellArray = cell(numFiles, 1);

% 各DICOMファイルの情報を取得
for i = 1:numFiles
    % DICOMファイルのパスを取得
    dicomFilePath = fullfile(folderPath, fileList(i).name);
    
    % DICOMファイルの情報を取得
    dicomInfo = dicominfo(dicomFilePath);
    
    % DICOMファイルの情報をセル配列に格納
    dicomInfoCellArray{i} = dicomInfo;
end

% DICOMファイルの情報を確認
%for i = 1:numFiles
    %fprintf('DICOMファイル: %s\n', fileList(i).name);
    %disp(dicomInfoCellArray{i});
%end

%次に画像を読み込む
img = dicomreadVolume(folderPath);

%画像枚数を確認する
num_imges = size(img, 4);

% ウィンドウ幅とウィンドウセンターの情報を取得する
WW = dicomInfo.WindowWidth;
WL = dicomInfo.WindowCenter;

%初期画像を表示
currentImg = 1;
hFig = figure(1);
hIm = imagesc(img(:,:,currentImg));
colormap(gray);
axis image;
colorbar;
title(['Image ', num2str(currentImg)]);

% キー入力を待機し、十字キーが押されるたびに画像を更新
while ishandle(hFig)
    waitforbuttonpress;
    key = get(hFig, 'CurrentKey');
    
    switch key
        case 'uparrow' 
            currentImg = min(currentImg + 1, num_imges);
        case 'downarrow' 
            currentImg = max(currentImg - 1, 1);
        case 'j'
            WW = max(WW - 10, 2);
        case 'l'
            WW = WW + 10;
        case 'i'
            WL = WL + 10;
        case 'm'
            WL = WL - 10;
        case 'q'
            break;    
        otherwise
            continue;
    end
    
    % 画像を更新して表示
    set(hIm, 'CData', img(:,:,currentImg));
    caxis([WL - WW/2, WL + WW/2]);
    title(['Image ', num2str(currentImg)]);
end
