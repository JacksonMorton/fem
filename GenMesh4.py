#!/usr/bin/env python

#!/usr/bin/python
#!/bin/env python


from __future__ import division

"""
This script take three inputs and retuns a linear 

LICENSE
=======
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
"""

__author__ = "Jackson Bruce Morton II"
__email__ = "jmorton27@gmail.com"
__date__ = "2014-01-16"
__modified__ = "2014-02-03"
__license__ = "GPLv3"

import os
# import sys             # The 'sys' and 'numpy' modules are not being used.
# import numpy as np

#GENMESHMATLAB
#   Using (x1, y1, z1) and (x2, y2, z2) as opposite corners of a meshgrid,
#   creates nodes.dyn and elems.dyn using xEle, yEle, and zEle as the
#   number of x, y, and z elements respectively.

## Corner of meshgrid (x1,y1,z1)
##corner_1 = [1,1,1]
#x1 = corner_1[0]
#y1 = corner_1[1]
#z1 = corner_1[2]
## Opposite corner of meshgrid (x2,y2,z2)
##corner_2 = [3,3,3]
#x2 = corner_2[0]
#y2 = corner_2[1]
#z2 = corner_2[2]
## Number of x elements, y elements, and z elements, respectively.
##numElements = [2,2,2]
#xEle = numElements[0]
#yEle = numElements[1]
#zEle = numElements[2]
corner1 = [1,1,1]
corner2 = [3,3,3]
numbElements = [2,2,2]

import sys,argparse
parser = argparse.ArgumentParser(description='Generate nodes.txt and elements.txt files based on user inputs.')
parser.add_argument("--corner_1", help="One of the corners that defines the mesh.", default=corner1, nargs=3, type=int)
parser.add_argument("--corner_2", help="The seconds corner that defines the mesh.", default=corner2, nargs=3, type=int)
parser.add_argument("--numElements", help="The number of mesh elements in the x direction ,y direction, and z direction, respectively.", default=numbElements, nargs=3,type=int)
args = parser.parse_args()

corner_1 = args.corner_1
corner_2 = args.corner_2
numElements = args.numElements
print "corner_1:", corner_1 
print"numElements:", numElements
# Corner of meshgrid (x1,y1,z1)
#corner_1 = [1,1,1]
x1 = corner_1[0]
y1 = corner_1[1]
z1 = corner_1[2]
# Opposite corner of meshgrid (x2,y2,z2)
#corner_2 = [3,3,3]
x2 = corner_2[0]
y2 = corner_2[1]
z2 = corner_2[2]
# Number of x elements, y elements, and z elements, respectively.
#numElements = [2,2,2]
xEle = numElements[0]
yEle = numElements[1]
zEle = numElements[2]

def main():
#    import sys, argparse
    if sys.version < '2.7':
        sys.exit("ERROR: Requires Python >= v2.7")    
    
#    parser = argparse.ArgumentParser(description='Generate nodes.txt and elements.txt files based on user inputs.')
#    parser.add_argument("corner_1", help="One of the corners that defines the mesh.")
#    parser.add_argument("corner_2", help="The seconds corner that defines the mesh.")
#    parser.add_argument("numElements", help="The number of mesh elements in the x direction ,y direction, and z direction, respectively.")
#    args = parser.parse_args()
  
    
    #args = parser.parse_args()
    #disp = args.disp
    #vel = args.vel
    
    node_counter()
    element_counter()
###############################################################################
def node_counter():  
    '''
    This is a description of node_counter().
    '''
    Test1 = True # Define a boolean that runs the testing parameters when 'True'.
    fid = open('nodes.txt','w+')
    for i in range(1,xEle+2):
        for j in range(1,yEle+2):
            for k in range(1,zEle+2):
                nodeID = (i-1)*((yEle+1)*(zEle+1))+(j-1)*(zEle+1)+k
                ##print("%i %i %i %i\n" % (nodeID, i, j, k))
                # I tried to use the enumerate function for the nodeID, as so:
                #         for index, k in enumerate(range(0,zEle):
                # but I got stuck.  Instead, Line 38 is a simple eqation that
                # starts at 1 and increases by one for each iteration.
                x = x1 + (i-1)*(x2-x1)/xEle
                y = y1 + (j-1)*(y2-y1)/yEle
                z = z1 + (k-1)*(z2-z1)/zEle
                # x,y,and z are found by simple eqns., but the choice to use
                # (n-1) instead of n was a little tricky to think through.
                ##fid.write(str(nodeID) + str(x) + str(y) + str(z) + '\n')
                fid.write("%i,%.2f,%.2f,%.2f\n" % (nodeID, x, y, z))
                print("%i %.2f %.2f %.2f\n" % (nodeID, x, y, z))
                #print "i="+str(i)+", j="+str(j)+", k="+str(k)  
                # This is where I have the most questions:
                # 1) Is there a difference between a .txt and a .dyn file?
                # 2) Now that I have written to nodes.txt, how do I view the
                #   file?
                if Test1 == True:            
                    if nodeID > (xEle+1)*(yEle+1)*(zEle+1): # CHECK #1
                        print "ERROR: Some nodeID values exceed the total number of nodes."  
                        break
                        #return
                    if x<x1 or x>x2: # CHECK #2
                        print "ERROR: An 'x' value exists outside the expected range."
                        break
                    if y<y1 or y>y2:
                        print "ERROR: A 'y' value exists outside the expected range."
                        break
                    if z<z1 or z>z2:
                        print "ERROR: A 'z' value exists outside the expected range."
                        break
            else:
                continue
            break
        else:
            continue
        break
    #fid.split(None, -1)
    fid.close()

###############################################################################
def element_counter():   
    '''
    This is a description of element_counter(). 
    '''
    Test2 = True
    part = 1
    file2 = open('elements.txt','w+')
    for i in range(1,xEle+1):
        for j in range(1,yEle+1):
            for k in range(1,zEle+1):
                elementID = (i-1)*(yEle*zEle) + (j-1)*zEle + k
                n1 = (i-1)*((yEle+1)*(zEle+1))+(j-1)*(zEle+1)+k
                n2 = n1+(zEle+1)
                n3 = n2+1
                n4 = n1+1
                n5 = n1+(yEle+1)*(zEle+1)
                n6 = n5+(zEle+1)
                n7 = n6+1
                n8 = n5+1
                file2.write("%i %i %i %i %i %i %i %i %i %i\n" % (elementID,part,n1,n2,n3,n4,n5,n6,n7,n8))
                print("%i %i %i %i %i %i %i %i %i %i" % (elementID,part,n1,n2,n3,n4,n5,n6,n7,n8))
                #if Test2 == True:
                    #Check to see that there are only two discrete values for x,y,and z.
                    #See additional checks written down.
    file2.close()
  
###############################################################################          


if __name__ == "__main__":
    main()


