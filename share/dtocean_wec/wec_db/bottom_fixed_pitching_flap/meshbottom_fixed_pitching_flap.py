"""
Mesh Oyster
"""

# Add Python Scripts to PYTHONPATH
extra = r'C:\Users\pmr\Documents\Python Scripts\pauwecs'
from sys import path
path.append(extra)

import numpy as np
import toolbox.mesh as mesh

deg, width, thick, deep = 0., 18., 1.8, 8.9+2.
geometry = np.array([[-width*.5, -thick*.5, deg], [width*.5, -thick*.5, deg],
                     [width*.5, thick*.5, deg], [-width*.5, thick*.5, deg], 
                     [-width*.5, -thick*.5, deg]], dtype = float)

oyster = mesh.mesher(Nth=30, Nz=20, radius=5, draught=deep, geometry=geometry, thf=2*np.pi)
oyster.rotation(np.array([0., 0., np.pi/2.], float))

oyster.Show_Norms(0.5)

fn = r'C:\Users\pmr\Documents\Python Scripts\OUTDTOhydro\OysterIn\oyster'

oyster.GDF(fn, ULEN = 1, GRAV = 9.81, ISX = 0, ISY = 0)
