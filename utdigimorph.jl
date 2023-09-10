#!/usr/bin/env -S julia --project=. -p 2 -i

using AlfarCT.UTDigimorph

path = ARGS[1]
dataset = if length(ARGS) > 1
    Symbol(ARGS[2])
else
    :Pawpaw
end

UTDigimorph.run(path, dataset)