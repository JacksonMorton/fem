#%GENMESHMATLAB 
#%   Using (x1, y1, z1) and (x2, y2, z2) as opposite corners of a meshgrid,
#%   creates nodes.dyn and elems.dyn using xEle, yEle, and zEle as the
#%   number of x, y, and z elements respectively.

#from numpy import linspace
import numpy as np
xEle = 10

def gen_mesh(x1, x2, y1, y2, z1, z2):
    if x2 <= x1:
        y = np.linspace(x2, x1, xEle, True, False)
        print y
    else:
        # linsapce
    if y2 <= y1:
        # linspace
    else:
        linsapce
    if z2 <= z1:
        # linspace
    else:
        # linsapce



