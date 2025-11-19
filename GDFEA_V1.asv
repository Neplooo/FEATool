


% Use for gathering elasticity constants: https://www.engineeringtoolbox.com/young-modulus-d_417.html

clear;
clc;

% Prompt user for model input and material selection.

MaterialTypes = {"Aluminum", "Wood", "Carbon Fiber", "PETG", "Polycarbonate"};

dlgtitle = "Material Selection";

[idx, tf] = listdlg(PromptString=dlgtitle, ListString=MaterialTypes, SelectionMode="Single");

waitfor(msgbox("Next, Select your Object File."));

[file, path] = uigetfile("*.stl");

E = 0; % Elasticity Constant of the Material. (Aluminum = 69 GPa)
nu = 0; % Poissons Ratio - How thin an object gets as it stretches. (Dimensionless)


switch idx
    case idx == 1
        % Set Elasticity Constants to Aluminum
        E = 69E9;
        nu = 0.34;
    case idx == 2
        % Set Elasticity Constants to Wood
        E = 11E9;
        nu = 0.3;
    case idx == 3
        % Set Elasticity Constants to Carbon Fiber
        E = 150E9;
        nu = 0.25;
    case idx == 4
        % Set Elasticity Constants to PETG
        E = 2.3E9;
        nu = 0.42;
    case idx == 5
        % Set Elasticity Constants to Polycarbonate
        E = 2.6E9;
        nu = 0.36;
end

% Configure the Geometry import settings.
model = createpde("structural", "static-solid");

% Import Geometry
importGeometry(model, strcat(path, file));

% Provide Directions to the User.
waitfor(msgbox("Take note of the face that you would like to apply your forces to." + ...
    " Once you find which faces you want to use, Enter them into the boxes."));

% Show faces to the user for load selection
waitfor(pdegplot(model, "FaceLabels","on", "FaceAlpha", 0.5, FaceLabels="on")); %Testing

% Configure input prompts
prompt = {'Enter load application face:','Enter Constrained face:', 'Enter amount of force to be applied (GPa):'};
dlgtitle = 'Load Configuration (DO NOT ADD F TO FACES';
fieldsize = [1 45; 1 45; 1 45];

% Show FEA Input prompts
faceAns = inputdlg(prompt,dlgtitle,fieldsize);

% Debugging
% disp(faceAns(1));
% disp(faceAns(2));
% disp(faceAns(3));

%Convert Geometry to Mesh
msh = generateMesh(model, "Hmax", 0.01);

% Solving FEA

% Apply the structural properties for aluminum to the mesh.
structuralProperties(model, YoungsModulus=E, PoissonsRatio=nu);

% Constrain the Model to a certain face.
structuralBC(model, Face=str2num(faceAns{2}), Constraint="fixed");

% Add a load to the model.
% Face 29 - Top Face
structuralBoundaryLoad(model, Face=str2num(faceAns{1}), Pressure=str2num(faceAns{3}));

% Postprocessing

Rs = solve(model);

figure;

pdeplot3D(model, ColorMapData=Rs.VonMisesStress, Deformation=Rs.Displacement, DeformationScaleFactor=0);

