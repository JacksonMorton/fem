#!/bin/env python
""" Extract the inteisities along a specified axis """

__author__ = "Mark Palmeri"
__email__ = "mlp6@duke.edu"
__date__ = "2013-10-17"

def extractAxisIntensity(dynaInput, axis, location, tol):
    """
    INPUTS: 
        dynaInput (string) - dyna.mat file with intensity data
        axis (int) - 1-3, based on dyna coordinates [1 = elevation, 2 = lateral, 3 = axial]
        location (floats) - 2 element vector with locations of the orthogonal positions (dyna units, cm)
        tol (float) - optional node search tolerance (dyna units, cm)

    OUTPUTS:
        axis (float vector) - axis positions (cm)
        intensity (float vector) - intensities along axis

    EXAMPLE: [axial,intensity]=extractAxisIntensity('dyna.mat',3,[0 0],1e-3)
    """
 
    import scipy.io
    import numpy as np

    from mesh import bc

    fieldData = scipy.io.load(dynaInput)
    intensity = fieldData['intensity']
    fieldParams = fieldData['FIELD_PARAMS']
    mpn = fieldParams[0][0]
    
    [snic,axes]=bc.SortNodeIDs(mpn)


'''
axisOfInterest=find(abs(mpn(:,SearchDims(1))) < (location(1) + Tol) & ...
    abs(mpn(:,SearchDims(1))) > (location(1) - Tol) & ...
    abs(mpn(:,SearchDims(2))) < (location(2) + Tol) & ...
    abs(mpn(:,SearchDims(2))) > (location(2) - Tol));

axis = abs(mpn(axisOfInterest,axis));
inten = InputIntensity(axisOfInterest);
'''
