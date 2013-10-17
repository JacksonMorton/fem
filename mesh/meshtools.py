#!/usr/local/bin/python2.7
"""
meshtools.py - tools to sort nodes and extract planes and axes from meshes
"""

__author__ = "Mark Palmeri"
__email__ = "mlp6@duke.edu"
__date__ = "2013-10-17"


def SortNodeIDs(nic):
    '''
    Sort the node IDs by spatial coordinates into a 3D matrix and return the corresponding axes

    INPUTS:
        nic - nodeIDcoords (n matrix [# nodes x 4, dtype = i4,f4,f4,f4])

    OUTPUTS:
        SortedNodeIDs - n matrix (x,y,z)
        x - array
        y - array
        z - array
    '''

    import numpy as n

    axes = [n.unique(nic['x']), n.unique(nic['y']), n.unique(nic['z'])]
    
    # test to make sure that we have the right dimension (and that precision issues aren't adding extra unique values)
    if len(nic) != (axes[0].size * axes[1].size * axes[2].size):
        sys.exit('ERROR: Dimension mismatch - possible precision error when sorting nodes (?)') 

    # sort the nodes by x, y, then z columns
    I = nic.argsort(order=('x','y','z')) 
    snic = nic[I]
    snic = snic.reshape((axes[0].size,axes[1].size,axes[2].size))  
    
    return [snic, axes]

def extractPlane(snic,axes,plane):
    '''
    Extract the node IDs on a specified plane from a sorted node ID & coordinate 3D array.

    INPUTS:
        snic - sorted node IDs & coordinates array
        axes - list of unique coordinates in the x, y, and z dimensions
        plane - list:
            index - index of the plane to extract (x=0, y=1, z=2)
            coord - coordinate of the plane to extract (must exist in axes list)

    OUPUTS:
        planeNodeIDs - spatially-sorted 2D node IDs on the specified plane
        
    EXAMPLE: planeNodeIDs = extractPlane(snic,axes,(2,-0.1))
    '''
    if plane[0] == 0:
        planeNodeIDs = snic[axes[plane[0]] == plane[1],:,:]
    elif plane[0] == 1: 
        planeNodeIDs = snic[:,axes[plane[0]] == plane[1],:]
    elif plane[0] == 2: 
        planeNodeIDs = snic[:,:,axes[plane[0]] == plane[1]]
    else:
        sys.exit("ERROR: Specified plane index to extract does not exist")

    planeNodeIDs = planeNodeIDs.squeeze()
    return planeNodeIDs

def extractAxis(snic,axes,axis):
    '''
    Extract the node IDs on a specified axis from a sorted node ID & coordinate 3D array.

    INPUTS:
        snic - sorted node IDs & coordinates array
        axes - list of unique coordinates in the x, y, and z dimensions
        axis - list:
            dim - dimension of the axis to extract (x=0, y=1, z=2)
            coords - orthogonal coordinates that define the axis (must exist in axes list)

    OUPUTS:
        axisNodeIDs - spatially-sorted node IDs on the specified axis
        
    EXAMPLE: axisNodeIDs = extractAxis(snic,axes,(2,0,0))
    '''
    if axis[0] == 0:
        axisNodeIDs = snic[:,axes[1] == axis[1],axes[2] == axis[2]]
    elif axis[0] == 1: 
        axisNodeIDs = snic[axes[0] == axis[1],:,axes[2] == axis[2]]
    elif axis[0] == 2: 
        axisNodeIDs = snic[axes[0] == axis[1],axes[1] == axis[2],:]
    else:
        sys.exit("ERROR: Specified axis indices to extract do not exist")

    axisNodeIDs = axisNodeIDs.squeeze()
    return axisNodeIDs
