function resultant_max = gaussian_shaped_multi_targets(sigma, y_o, sz, patch)
%GAUSSIAN_SHAPED_LABELS
%   Gaussian-shaped labels for all shifts of a sample.
%
%   LABELS = GAUSSIAN_SHAPED_LABELS(SIGMA, SZ)
%   Creates an array of labels (regression targets) for all shifts of a
%   sample of dimensions SZ. The output will have size SZ, representing
%   one label for each possible shift. The labels will be Gaussian-shaped,
%   with the peak at 0-shift (top-left element of the array), decaying
%   as the distance increases, and wrapping around at the borders.
%   The Gaussian function has spatial bandwidth SIGMA.
%
%   Joao F. Henriques, 2014
%   http://www.isr.uc.pt/~henriques/


% 	%as a simple example, the limit sigma = 0 would be a Dirac delta,
% 	%instead of a Gaussian:
% 	labels = zeros(sz(1:2));  %labels for all shifted samples
% 	labels(1,1) = magnitude;  %label for 0-shift (original sample)

[r_targets, c_targets] = find(y_o~=0);
locations_2B_shifted = [r_targets, c_targets];

[cs rs] = meshgrid(1:sz(2),1:sz(1));
cs = cs  - floor(sz(2)/2) ;
rs = rs  - floor(sz(1)/2) ;

%move the peak to the top-left, with wrap-around
% 	labels = circshift(labels, -floor(sz(1:2) / 2) + 1);
for i=1:size(locations_2B_shifted,1)
	labels(:,:,i) = y_o(r_targets(i), c_targets(i))*circshift(exp(-0.5 / sigma^2 * (rs.^2 + cs.^2)), floor(locations_2B_shifted(i,:)- floor(sz/2)));
%     figure;imshow(labels(:,:,i),[])
%     pause
end
%     resultant = sum(labels,3);
%     labels(:,:,i+1) = sum(labels,3);

    resultant_max = max(labels,[],3);
        dummy1 = circshift(resultant_max,+ceil(sz(1:2) / 2) - 1);
%         figure;imshow(dummy1,[])
%         colormap = 'jet';
%         figure(4);surf(dummy1)

    
    resultant_addition = sum(labels,3)/size(labels,3);
%     adel = zeros(size(labels,1),size(labels,2));
%     adel(1,1) = 1;
%     dummy1 = circshift(resultant_addition,-ceil(sz(1:2) / 2) + 1);
%     bb = imguidedfilter(dummy1,patch); %Bilateral filter using gray scale image as guide
%     resultant = circshift(bb,ceil(sz(1:2) / 2) - 1);
    
%     figure;imshow(adel,[]);
%     figure;imshow(circshift(adel,-ceil(sz(1:2) / 2) + 1),[])
    
%     bb = imguidedfilter(circshift(adel,-floor(sz(1:2) / 2) + 1),patch);
%     figure;imshow(bb,[]);


%     figure;imshow(sum(labels,3),[])
%sanity check: make sure it's really at top-left
% 	assert(labels(1,1) == 1)
% figure
% for i=1:size(labels,3)
%     subplot(ceil(size(labels,3)/5),5,i);
%     imshow(labels(:,:,i),[]);
% end
end

