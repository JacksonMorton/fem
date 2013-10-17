#!/bin/env python
"""
bc.py - apply boundary conditions to rectangular solid meshes (the majority of the FE sims); can handle quarter- and half-symmetry models. 
"""

__author__ = "Mark Palmeri (mlp6)"
__date__ = "2012-07-02"
__modified__ = "2013-01-29"
__version__ = "0.3.1"


def main():
    #import pdb 
    import os,sys,math
    import numpy as n

    if sys.version < '2.7':
        sys.exit("ERROR: Requires Python >= v2.7")

    import argparse

    # lets read in some command-line arguments
    parser = argparse.ArgumentParser(description="Generate boundary condition data as specified on the command line.",formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument("--bcfile",help="boundary condition output file",default="bc.dyn")
    parser.add_argument("--nodefile",help="node defintion input file",default="nodes.dyn")
    parser.add_argument("--sym",help="quarter (q), half (h) symmetry or none (none)",default="q")
    parser.add_argument("--top",help="fully constrain top boundary (transducer surface)",default=True)
    parser.add_argument("--bottom",help="full / inplane constraint of bottom boundary (opposite transducer surface) [full, inplane]",default="full")

    opts = parser.parse_args()

    # open the boundary condition file to write
    BCFILE = open(opts.bcfile,'w')
    BCFILE.write("$ Generated using %s (version %s) with the following options:\n" % (sys.argv[0],__version__))
    BCFILE.write("$ %s\n" % opts)
    
    # load in all of the node data, excluding '*' lines
    nodeIDcoords = n.loadtxt(opts.nodefile, delimiter=',', comments='*', dtype=[('id','i4'),('x','f4'),('y','f4'),('z','f4')])

    # there are 6 faces in these models; we need to (1) find all of them and (2) apply the appropriate BCs
    # we'll loop through all of the nodes, see if they are on a face or edge, and then apply the appropriate BC
    [snic, axes] = SortNodeIDs(nodeIDcoords)
    
    # extract spatially-sorted node IDs on a specified plane (these could be internal or external)
    segID = 1
    for r in range(0,3):
        for m in ('bcmin','bcmax'):
            if m == 'bcmin':
                plane = (r,axes[r].min())
            elif m == 'bcmax':
                plane = (r,axes[r].max())
            planeNodeIDs = extractPlane(snic,axes,plane)
            if r == 0: # front/back (front - symmetry, back - non-reflecting)
                if m == 'bcmin': # back (non-reflecting)
                    segID = writeSeg(BCFILE,'BACK',segID,planeNodeIDs)
                elif m == 'bcmax': # front (symmetry)
                    if (opts.sym == 'q') or (opts.sym == 'h'):
                        writeNodeBC(BCFILE,planeNodeIDs[1:-1],'1,0,0,0,1,1') # no top / bottom rows (those will be defined in the top/bottom defs)
                    else:
                        if opts.sym != 'none':
                            sys.exit("ERROR: invalid symmetry flag specified (front face)")
                        segID = writeSeg(BCFILE,'FRONT',segID,planeNodeIDs)
            elif r == 1: # left/right (non-reflecting; left - symmetry)
                if m == 'bcmin': # left (push side)
                    # if quarter-symmetry, then apply BCs, in addition to a modified edge; and don't deal w/ top/bottom
                    if opts.sym == 'q':
                        writeNodeBC(BCFILE,planeNodeIDs[1:-1],'0,1,0,1,0,1')
                    # else make it a non-reflecting boundary
                    else:
                        if (opts.sym != 'h') and (opts.sym != 'none'):
                            sys.exit("ERROR: invalid symmetry flag specified (left/push face)")
                        segID = writeSeg(BCFILE,'LEFT',segID,planeNodeIDs) 
                if m == 'bcmax': # right
                    segID = writeSeg(BCFILE,'RIGHT',segID,planeNodeIDs)
            elif r == 2: # top/bottom (fully-contrained & non-reflecting)
                if m == 'bcmin': # bottom
                    segID = writeSeg(BCFILE,'BOTTOM',segID,planeNodeIDs)
                    if opts.bottom == 'full':
                        writeNodeBC(BCFILE,planeNodeIDs,'1,1,1,1,1,1')
                    elif opts.bottom == 'inplane':
                        writeNodeBC(BCFILE,planeNodeIDs,'0,0,1,1,1,0')
                    else:
                        sys.exit('ERROR: specific bottom BC invalid (can only be full or inplane)')
                if m == 'bcmax': # top
                    segID = writeSeg(BCFILE,'TOP',segID,planeNodeIDs)
                    if opts.top == True:
                        writeNodeBC(BCFILE,planeNodeIDs,'1,1,1,1,1,1')

    # write non-reflecting boundaries (set segment references)
    BCFILE.write('*BOUNDARY_NON_REFLECTING\n')
    for i in range(1,segID):
        BCFILE.write('%i,0.0,0.0\n' % i)
    BCFILE.write('*END\n')

    # close all of our files open for read/write
    BCFILE.close()

#############################################################################################################################
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

#############################################################################################################################
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
        
    EXAMPLE: planeNodeIDs = extractPlane(snic,axes,(0,-0.1))
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
#############################################################################################################################
def writeSeg(BCFILE,title,segID,planeNodeIDs):
    BCFILE.write('*SET_SEGMENT_TITLE\n')
    BCFILE.write('%s\n' % title)
    BCFILE.write('%i\n' % segID)
    for i in range(0,(len(planeNodeIDs)-1)):
        (a,b) = planeNodeIDs.shape
        for j in range(0,(b-1)):
            BCFILE.write("%i,%i,%i,%i\n" % (planeNodeIDs[i,j][0],planeNodeIDs[i+1,j][0],planeNodeIDs[i+1,j+1][0],planeNodeIDs[i,j+1][0]))
    segID = segID + 1
    return segID
#############################################################################################################################
def writeNodeBC(BCFILE,planeNodeIDs,dofs):
    #import pdb
    BCFILE.write('*BOUNDARY_SPC_NODE\n')
    for i in planeNodeIDs: # don't grab the top / bottom rows (those will be defined in the top/bottom defs)
        for j in i:
            BCFILE.write("%i,0,%s\n" % (j[0],dofs))
#############################################################################################################################
    
if __name__ == "__main__":
    main()

