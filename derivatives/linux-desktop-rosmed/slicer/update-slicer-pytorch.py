#!/usr/bin/env python3
import os

pytorchver=129

if len(sys.argv) > 1:
    pytorchver=int(sys.argv[1])

print("Installing pytorch " + str(pytorchver))

url="https://download.pytorch.org/whl/nightly/cu%d" % pytorchver

slicer.util.pip_install("--upgrade pip")
slicer.util.pip_uninstall("torch")
slicer.util.pip_uninstall("torchvision")
slicer.util.pip_install("--pre torch torchvision --index-url %s" % url)

import torch
print(torch.cuda.is_available())
print(torch.version.cuda)

exit()
