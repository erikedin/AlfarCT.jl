#!/usr/bin/env -S julia --project=. -p 2 -i

using AlfarCT.UTDigimorph

path = ARGS[1]

UTDigimorph.showslice(path)