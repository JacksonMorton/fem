# import sys             # The 'sys' and 'numpy' modules are not being used.
# import numpy as np
from __future__ import division
#GENMESHMATLAB
#   Using (x1, y1, z1) and (x2, y2, z2) as opposite corners of a meshgrid,
#   creates nodes.dyn and elems.dyn using xEle, yEle, and zEle as the
#   number of x, y, and z elements respectively.

# Corner of meshgrid (x1,y1,z1)
corner_1 = [1,1,1]
x1 = corner_1[0]
y1 = corner_1[1]
z1 = corner_1[2]
# Opposite corner of meshgrid (x2,y2,z2)
corner_2 = [2,3,4]
x2 = corner_2[0]
y2 = corner_2[1]
z2 = corner_2[2]
# Number of x elements, y elements, and z elements, respectively.
numElements = [2,2,2]
xEle = numElements[0]
yEle = numElements[1]
zEle = numElements[2]

# open a file for writing

#def gen_mesh():
# Original thought was to import and use numpy.meshgrid, as we discusses, but
# once I looked into the details I wasn't sure if it was completely applicable
# to what I was trying to do.

# My next thought was to make a directory that printed after each iteration of
# a nested for loop, as shown below:
    #nodes = {'nodeID':[], 'x':[], 'y':[], 'z':[]}
# However, I ran into problems bc I couldn't figure out how to append each list
# after each for loop iteration, and I wasn't sure if I could get each list to
# print out neatly into columns in a .dyn or .txt file.
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
            file2.write("%i %i %i %i %i %i %i %i %i %i" % (elementID,part,n1,n2,n3,n4,n5,n6,n7,n8))
            print("%i %i %i %i %i %i %i %i %i %i" % (elementID,part,n1,n2,n3,n4,n5,n6,n7,n8))
            #if Test2 == True:
                #Check to see that there are only two discrete values for x,y,and z.
                #See additional checks written down.
file2.close()
            
    