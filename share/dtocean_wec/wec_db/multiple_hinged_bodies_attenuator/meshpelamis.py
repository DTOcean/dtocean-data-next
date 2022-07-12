"""
Mesh Pelamis
"""

# Add Python Scripts to PYTHONPATH
extra = r'C:\Users\pmr\Documents\Python Scripts\pauwecs'
from sys import path
path.append(extra)

import numpy as np
import toolbox.mesh as mesh

covers = True

radius = 4./2.
draught = 180./5.

Nth = 11
Nz = 30
geometry = 'Cylinder'
Cyl = mesh.mesher(Nth, Nz, radius, draught, geometry, thf = np.pi, zcut = 0., axes = (0,1,2))
Cyl.rotation(np.array([0., 0., np.pi/2.]))

Nl = 7
CoverU = mesh.circumference(Nl, radius, z=0, upwards=True)
CoverD = mesh.circumference(Nl, radius, z=-draught, upwards=False)

dist = [i*draught for i in range(-2, 3)]
        
pelamisT = [mesh.mergesurfs((CoverU, Cyl)),] 
for i in range(len(dist)-2):
    pelamisT.append(mesh.SurF(Cyl.coord.copy()))
pelamisT.append(mesh.mergesurfs((Cyl, CoverD)))
 
for iD, D in enumerate(dist):
    pelamisT[iD].rotation(np.array([0., np.pi/2., 0.]))
    pelamisT[iD].coord = pelamisT[iD].coord[np.all(pelamisT[iD].coord[:, :, 2] <= 1e-6, axis=1)]
    pelamisT[iD].Chkud(np.array([[0., 0., 0.],]))
    pelamisT[iD].translation(np.array([-draught/2., 0., 0.]))
    pelamisT[iD].translation(np.array([D, 0., 0.]))
    fn = r'C:\Users\pmr\Documents\Python Scripts\OUTDTOhydro\P2PelamisIn\pelamis{:}'.format(int(D))
    pelamisT[iD].GDF(fn, ULEN = 1, GRAV = 9.81, ISX = 0, ISY = 0)
    pelamisT[iD].Show_Norms(.1)
    print pelamisT[iD].coord.reshape((-1,3)).mean(axis=0)
    print pelamisT[iD].coord.shape

m = 1350*1e3 # kg
J = m/12.*(3.*radius**2+draught**2) # kg*m**2
print "Mass (kg): {:.3f}".format(m)    
print "Moment of Inertia (kg*m**2): {:.3f}".format(J)
