addpath(genpath('/login/jdha/matlab/new_matlab/utilities/ann_mwrapper'))

git_path='/work/jholt/Git/GCOMS1k/STARTFILES/';
projects_path='/projectsa/accord/GCOMS1k/';

%git_path='C:\Users\jholt\Documents\GitHub\GCOMS1k\STARTFILES\';
%projects_path='C:\Users\jholt\Documents\Projects\';

addpath([git_path 'Global_Rivers/Mfiles/']);

Global_rivers_path=[projects_path 'Global_Rivers/'];
lme_path=[projects_path 'LME/LME66/'];
bathy_path=[projects_path 'LME/LME_Bathy/'];

domain_path='/projectsa/accord/GCOMS1k/INPUTS/';
domain_outpath='/projectsa/accord/GCOMS1k/OUTPUTS/';
assess_path='/projectsa/accord/GCOMS1k/ASSESSMENT/';

%domain_path='C:\Users\jholt\work\GCOMS1k\INPUTS\';
%domain_outpath='C:\Users\jholt\work\GCOMS1k\OUTPUTS\';

parent_path='/projectsa/NEMO/gmaya/ORCA12/2013/';
Re=6367456.0*pi/180;
tiny=1e-6;
