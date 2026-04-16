#!/usr/bin/env python3
import os

slicer.util.pip_install("--upgrade pip")
slicer.util.pip_uninstall("torch")
slicer.util.pip_install("--pre torch torchvision torchaudio --index-url https://download.pytorch.org/whl/nightly/cu129")

import torch
print(torch.cuda.is_available())
print(torch.version.cuda) # Should show 12.9

exit()
