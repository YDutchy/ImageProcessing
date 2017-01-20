function [ imageData ] = processImage( imageData, handles )
    % Main entry point for image processing. All re-usable data should be 
    % declared here and passed along to each subsystem.
    tic
    % Gray data
    grayData = rgb2gray(imageData);
    grayData = medfilt2(grayData);
    
    
    % Clean noise from value channel -> Equalize values /w histeq
    hsvData = rgb2hsv(imageData);
    hsvData(:, :, 3) = medfilt2(hsvData(:, :, 3));

    hsvData(:, :, 1) = imadjust(hsvData(:, :, 1),stretchlim(hsvData(:, :, 1)),[]);
    hsvData(:, :, 3) = imadjust(hsvData(:, :, 3),stretchlim(hsvData(:, :, 3)),[]);
    mayorHorizontalEdgeGradient = sobelEdge_H(grayData);
    mayorVerticalEdgeGradient = medfilt2(sobelEdge_V(grayData), [7, 7]);
    bothEdgeGradients = mayorHorizontalEdgeGradient | mayorVerticalEdgeGradient;
    split = double(closing(bothEdgeGradients, 1, 'Rectangular'));
            
    bin_split_data_yellow = splitYellow( hsvData );
    bin_split_data_yellow = bin_split_data_yellow & grayData > 72;
    %[bin_split_data_yellow, edges] = postProcessColourSegmentation( bin_split_data_yellow, grayData );

    % - Begin draftt
        [bboxes2, centroids2, charactersplit, gradient_v, binaryImage] = clusterCharactersInImage(grayData, hsvData, handles.videoHeight, handles.videoWidth);
        updateAxes(grayData, handles, 2);
        updateAxes(charactersplit, handles, 3);
        updateAxes(gradient_v, handles, 4);
        title('v - h')
        updateAxes(gradient_v, handles, 5);
        title('clusters')
        updateAxes(binaryImage, handles, 6);
        title('after segmentation')
        plotBoundingBoxes(bboxes2);
        plotCentroids(centroids2);
    % - End draftt
    return
    
    [binaryImage, centroids, bbox, orientations, CC] = extractCandidateLicensePlates(bin_split_data_yellow, handles.videoHeight, handles.videoWidth);

    toc
    
    
%     if(length(bbox) > 0)
        disp(['Found ' num2str(length(bbox)) ' objects'])
        image1 = hsv2rgb(hsvData);
        image2 = split;
        image3 = bin_split_data_yellow;
        image4 = 0;
        image5 = binaryImage;
        image6 = mayorVerticalEdgeGradient;
%     else
%         disp(['No objects found: attempting strategy 2 '])
%         bin_split_data_white = splitWhitePlate( grayData );
%         [binaryImage, bands] = findVerticalEdgeRegions( grayData, mayorVerticalEdgeGradient, handles.videoHeight, handles.videoWidth );
%         image1 = hsv2rgb(hsvData);
%         image2 = binaryImage;
%         image3 = bin_split_data_white;
%         image4 = mayorVerticalEdgeGradient;
%         image5 = grayData;
%         image6 = bands;
%     end
    
    % Assign to image-feeds
    
    
    
    % Uncomment to enable image Statistics:
    % showStats(handles, hsvData);
  
    % Updates the live-views
    updateAxes(image1, handles, 2);
    updateAxes(image2, handles, 3);
    updateAxes(image3, handles, 4);
    updateAxes(image4, handles, 5);
    
    
    
    updateAxes(image5, handles, 6); title('bboxes');
    plotBoundingBoxes(bbox);
    plotCentroids(centroids);
    
    updateAxes(image6, handles, 7);
    axes(handles.axes7);
    histogram(hsvData(:, :, 1), 100), title('hue distribution')
end

function [] = plotBoundingBoxes(bbox)
    hold on
    for i = 1:length(bbox)
        rectangle('Position',bbox(i).BoundingBox,'EdgeColor','r');
    end, hold off
end

function [] = plotCentroids(centroids) 
    if(length(centroids) > 0)
        hold on, plot(centroids(:, 1), centroids(:, 2), 'b*'), hold off;
    end
end

function [] = showStats(handles, hsvData) 
    axes(handles.axes5);
    histogram(hsvData(:, :, 1), 100), title('hue distribution')
    axes(handles.axes6);
    histogram(hsvData(:, :, 2), 100), title('saturation distribution')
    axes(handles.axes7);
    histogram(hsvData(:, :, 3), 100), title('value distribution')
end

