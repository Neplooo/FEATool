
clear;
clc;

% Material Properties
E = 69E9; % Elasticity Constant of the Material. (Aluminum = 69 GPa)
nu = 0.34; % Poissons Ratio - How thin an object gets as it stretches. (Dimensionless)

p1 = 100E1; % In Pa
p2 = 4.5E5; % In Pa

% Import Geometry
model = createpde("structural", "static-solid");

importGeometry(model, "C:\Users\User\Downloads\TopPlate.stl");

%pdegplot(model, "FaceLabels","on", "FaceAlpha", 0.5, FaceLabels="on"); %Testing

%Convert Geometry to Mesh
msh = generateMesh(model, "Hmax", 0.01);

%pdeplot3D(model); % Testing Mesh

% Solving FEA

% Apply the structural properties for aluminum to the mesh.
structuralProperties(model, YoungsModulus=E, PoissonsRatio=nu);

% Constrain the Model to a certain face.
structuralBC(model, Face=35, Constraint="fixed");

% Add a load to the model.
% Face 29 - Top Face
structuralBoundaryLoad(model, Face=33, Pressure=p1);

% Postprocessing

Rs = solve(model);

pdeplot3D(model, ColorMapData=Rs.VonMisesStress, Deformation=Rs.Displacement, DeformationScaleFactor=0);