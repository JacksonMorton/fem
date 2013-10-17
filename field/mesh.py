import sys, os

sys.path.insert(0, os.path.join(
        os.path.dirname(os.path.dirname(os.path.realpath(__file__))), 'mesh'))

import bc

del sys.path[0], sys, os
