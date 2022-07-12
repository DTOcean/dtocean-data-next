"""
Mesh Pelamis
"""

# Add Python Scripts to PYTHONPATH
extra = r'C:\Users\pmr\Documents\Python Scripts\pauwecs'
from sys import path
path.append(extra)

import numpy as np
import toolbox.mesh as mesh

fn = r'C:\Users\pmr\Documents\Python Scripts\INPUTforeverybody\Barge\WAMITresults\barge.GDF'
fn1 = r'C:\Users\pmr\Documents\Python Scripts\OUTDTOhydro\2BargeIn\bargeleft'
fn2 = r'C:\Users\pmr\Documents\Python Scripts\OUTDTOhydro\2BargeIn\bargeright'
barge1 = mesh.readGDF(fn)
barge2 = mesh.readGDF(fn)
barge1.translation(np.array([barge1.coord[:, :, 0].min(), 0., 0.], float))
barge2.translation(np.array([barge2.coord[:, :, 0].max(), 0., 0.], float))
barge1.GDF(fn1)
barge2.GDF(fn2)
