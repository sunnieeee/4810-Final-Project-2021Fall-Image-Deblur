%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Sefl Defined Functino -- Wiener Filter
% Least Mean Square Error between Estimated and True images
% Dated: 12/12/2021
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function X = wnr(Y,PSF,NSR)
    Y = im2double(Y);
    N = size(Y,1);
    M = size(Y,2);
    col = size(Y,3);
    X = zeros([N,M,col]);
    for i=1:col
        yi = Y(:,:,i);
        Y_dft = fft2(yi); % Fourier Transform of blurred noisy images
        H_dft = psf2otf(PSF, [N,M]); % Convert the PSF to an Optical Transfer Function (OTF)
        
        %                   H*(k,l) S_x(k,l)
        % G(k,l)  =  -------------------------------
        %            |H(k,l)|^2 S_x(k,l) + S_n(k,l)
        %                     S_y - S_n
        %         =  -------------------------------
        %                    H(k,l) S_y
        %                       H*(k,l)
        %         =  -------------------------------
        %             |H(k,l)|^2  +  estimated_NSR

        G = conj(H_dft)./(abs(H_dft).^2+NSR);
        X(:,:,i) = real(ifft2(G .* Y_dft)); % Inverse Fourier Transform
    end
    
end