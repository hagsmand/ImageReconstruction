im = phantom(512);

%define geometry
vol_geom = astra_create_vol_geom(512, 512);
prj_geom = astra_create_proj_geom('parallel', 1, 512, linspace2(0,pi,180));

%strip model forward
proj_id = astra_create_projector('strip', prj_geom, vol_geom);

%define projector
[sino_id, sino] = astra_create_sino(im, proj_id);

figure(1); imshow(im, []);
figure(2); imshow(sino, []);

%re create 2d snogram back
sinogram_id = astra_mex_data2d('create', '-sino', prj_geom, sino);

% Create a data object for the reconstruction
rec_id = astra_mex_data2d('create', '-vol', vol_geom);

% algorithm (analytic recontruct)
cfg = astra_struct('FBP');   % ART, SART, SIRT, CGLS, FBP
cfg.ReconstructionDataId = rec_id;
cfg.ProjectionDataId = sinogram_id;
cfg.ProjectorId = proj_id;

alg_id = astra_mex_algorithm('create', cfg); % algo for 

% Run 20 iterations of the algorithm
% This will have a runtime in the order of 10 seconds.
astra_mex_algorithm('iterate', alg_id, 20);

% Get the result
rec = astra_mex_data2d('get', rec_id);
figure(3); imshow(rec, []);
