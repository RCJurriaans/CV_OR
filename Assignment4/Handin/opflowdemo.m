% Optical Flow demo on sphere and synth image pairs
% Creates a grid of optical flow vectors

sphere1 = rgb2gray(im2double(imread('sphere1.ppm')));
sphere2 = rgb2gray(im2double(imread('sphere2.ppm')));
synth1 = im2double(imread('synth1.pgm'));
synth2 = im2double(imread('synth2.pgm'));

LucasKanade(sphere1, sphere2);
LucasKanade(synth1, synth2);