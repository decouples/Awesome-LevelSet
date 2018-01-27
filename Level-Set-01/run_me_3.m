function run3
  paths;
  clf; colormap gray;

  %- prepare image and initialization
%   data = load('images/brain', 'img', 'mask');
%   data.img  = data.img(40:120, 40:100, 50:150);
%   data.mask = data.mask(40:120, 40:100, 50:150);
%   iterations = 140;
  
  I=imread('images/08.bmp');
  G = rgb2gray(I);
  
  disp('draw initial segmentation: left-click marks boundary points, right-click finishes');
  mask = get_blob_mask(G);
  iterations = 240;
  
  %- speed functional
  h = mean_speed();
  %h = mean_var_speed();
  %h = georgiou_speed();
  %h = bhattacharyya_speed();
  %h = threshold_speed();
  
  %- initialize
  [phi C] = mask2phi(mask);
  h.init(G, phi, C); % initialize statistics
  
  %- curve evolution
  %[phi_ C_] = ls_sparse3(phi, C, h, iterations);
  [phi_ C_] = ls_sparse(phi, C, h, iterations);

  %- display results
  imagesc(G(:,:,3)); axis image off;
  hold on;
  contour(phi(:,:,3),  [0 0], 'r', 'LineWidth', 2); % initial
  contour(phi_(:,:,3), [0 0], 'b', 'LineWidth', 2); % final
  hold off;

end
