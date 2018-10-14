#!/usr/bin/env python
# inspired by afew's mail mover
# run as python mail-mover.py FILE DEST

import os, shutil
import sys
import uuid

def get_new_name(fname,dest):
    return os.path.join(dest, str(uuid.uuid4())+':'+os.path.basename(fname).split(':')[-1])


filename = sys.argv[1]
destination = sys.argv[2]

try:
    shutil.copy2(filename, get_new_name(filename,destination))
    os.remove(filename)
except shutil.SameFileError:
    print("file {} already exists".format(filename))
except shutil.Error as e:
    if str(e).endswith("already exists"):
        print("file {} already exists".format(filename))
    else:
        raise
