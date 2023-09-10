#!/usr/bin/env -S julia --project=. -p 2

using AlfarCT.StanfordDatasets

path = ARGS[1]
dataset = if length(ARGS) > 1
    ARGS[2]
else
    :CThead
end

StanfordDatasets.run(path, dataset)