function [nodes, elems] = GenMeshMatlab(x1, y1, z1, x2, y2, z2, xEle, yEle, zEle)
%GENMESHMATLAB 
%   Using (x1, y1, z1) and (x2, y2, z2) as opposite corners of a meshgrid,
%   creates nodes.dyn and elems.dyn using xEle, yEle, and zEle as the
%   number of x, y, and z elements respectively.
    
    
    if (x2 <= x1)
        x = linspace(x2, x1, xEle + 1);
    else
        x = linspace(x1, x2, xEle + 1);
    end
    
    if (y2 <= y1)
        y = linspace(y2, y1, yEle + 1);
    else
        y = linspace(y1, y2, yEle + 1);
    end
    
    if (z2 <= z1)
        z = linspace(z2, z1, zEle + 1);
    else
        z = linspace(z1, z2, zEle + 1);
    end
    
    % nodes preallocation
    nodes = repmat(struct('nodeID', 1, 'x', 1, 'y', 1, 'z', 1), 1, (xEle+1)*(yEle+1)*(zEle+1));
    
    % constructing nodes
    counter = 1;
    for zIter = 1:zEle+1
        for yIter = 1:yEle+1
            for xIter = 1:xEle+1
                nodes(counter) = struct('nodeID', counter, 'x', x(xIter), 'y', y(yIter), 'z', z(zIter));
                counter = counter + 1;
            end
        end
    end
    
    % generating nodes.dyn file
    fid = fopen('nodes.dyn', 'w');
    fprintf(fid, '*NODE\n');
    for i = 1:length(nodes)
        fprintf(fid,'%.0f,%.6f,%.6f,%.6f\n',nodes(i).nodeID,nodes(i).x,nodes(i).y,nodes(i).z);
    end
    fprintf(fid, '*END\n');
    fclose(fid);
    
    % elems preallocation
    elems = repmat(struct('elemID',1,'part',1,'n1',1,'n2',1,'n3',1,'n4',1,'n5',1,'n6',1,'n7',1,'n8',1), 1, xEle*yEle*zEle);
    
    % constructing elements
    % based on the node ID of the first corner, nid1, the other node ids
    % can be given by:
    % nid1
    % nid1 + 1 (going down)
    % nid1 + 1 + (xEle + 1) (going down then right)
    % nid1 + (xEle + 1) (going right)
    % This must be done from 1 to 103 (which is zEle + 1)
    % above gives vertices defining an element face in the order given by
    % the right hand rule (outward normal).
    % opposite face:
    % (xEle + 1)(yEle + 1) + nid1 
    % (xEle + 1)(yEle + 1) + nid1 + 1 (going down)
    % (xEle + 1)(yEle + 1) + nid1 + 1 + (xEle + 1) (going down then right)
    % (xEle + 1)(yEle + 1) + nid1 + (xEle + 1) (going right)
    
    counter = 1;
    yCount = 0;
    zCount = 0;
    for zIter = 1:zEle
        for yIter = 1:yEle
            for xIter = 1:xEle
                elemID = counter;
                n1 = (yCount+zCount)*(xEle+1) + xIter;
                n2 = n1 + 1;
                n3 = n1 + 1 + (xEle+1);
                n4 = n1 + (xEle+1);
                n5 = (xEle+1)*(yEle+1) + n1;
                n6 = (xEle+1)*(yEle+1) + n1 + 1;
                n7 = (xEle+1)*(yEle+1) + n1 + 1 + (xEle+1);
                n8 = (xEle+1)*(yEle+1) + n1 + (xEle+1);
                elems(counter) = struct('elemID',counter,'part',1,'n1',n1,'n2',n2,'n3',n3,'n4',n4,'n5',n5,'n6',n6,'n7',n7,'n8',n8);
%               fprintf('%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f,%.0f\n',elemID,part,n1,n2,n3,n4,n5,n6,n7,n8);
                counter = counter + 1;
            end
            yCount = yCount + 1;
        end
        zCount = zCount + 1;
    end
    
    % generating elems.dyn file
    fid = fopen('elems.dyn', 'w');
    fprintf(fid, '*ELEMENT_SOLID\n');
    for i = 1:length(elems)
        fprintf(fid,'%d,%d,%d,%d,%d,%d,%d,%d,%d,%d\n',elems(i).elemID,elems(i).part,elems(i).n1,elems(i).n2,elems(i).n3,elems(i).n4...
                                                    ,elems(i).n5,elems(i).n6,elems(i).n7,elems(i).n8);
    end
    fprintf(fid, '*END\n');
    fclose(fid);
end