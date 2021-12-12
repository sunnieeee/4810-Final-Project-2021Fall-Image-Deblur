%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reference: https://www.mathworks.com/help/images/ref/deconvwnr.html
%            https://www.mathworks.com/help/images/deblurring-images-using-a-wiener-filter.html
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear;
figure(1);
set(gcf,'color',[1 1 1]);
set(gcf,'position',[0 5 1500 900])

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Original Image
subplot(2,3,1);
I = im2double(imread('4810.png'));
figure(1),imshow(I);
title('Original Image');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Motion Blur
subplot(2,3,2);
LEN = 21;
THETA = 11;
PSF = fspecial('motion', LEN, THETA); % Create a point-spread function (PSF)
blurred = imfilter(I, PSF, 'conv', 'circular');
figure(1), imshow(blurred)
title('Blurred Image');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Noise
subplot(2,3,3);
NOISE_NAME = "gaussian";
NOISE_MEAN = 0;
NOISE_VAR = 0.0001;
if NOISE_NAME == "gaussian"
    blurred_noisy = imnoise(blurred, NOISE_NAME, ...
                        NOISE_MEAN, NOISE_VAR);
elseif NOISE_NAME == "none"
    blurred_noisy = blurred;
end
figure(1), imshow(blurred_noisy)
title('Blurred and Noisy Image '+NOISE_NAME);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Deconv Using Matlab Function
subplot(2,3,4);
if NOISE_NAME == "gaussian"
    estimated_nsr = NOISE_VAR / var(I(:));
elseif NOISE_NAME == "none"
    estimated_nsr = 0;
end
wnr1 = deconvwnr(blurred_noisy, PSF, estimated_nsr);
figure(1), imshow(wnr1)
title('Restoration Image using Matlab wnr');

psnr_matlab = psnr(wnr1,I);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Deconv Using Self Defined Function
subplot(2,3,5)
wnr2 = wnr(blurred_noisy, PSF, estimated_nsr);
figure(1), imshow(wnr2)
title('Restoration Image using self wnr');

psnr_self = psnr(wnr2,I);