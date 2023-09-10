# Copyright 2023 Erik Edin
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

module StanfordDatasets

using Alfar.Visualizer
using Alfar.Visualizer.Show3DTextures
using Alfar.Rendering.Textures

const datasets = Dict{Symbol, Vector{String}}(
    :CThead => ["CThead.$(i)" for i=1:113],
    :MRbrain => ["MRbrain.$(i)" for i=1:109]
)

function loadslice(slicepath::String) :: IntensityTextureInput{2, UInt16}
    open(slicepath, "r") do io
        flatformat = FlatBinaryFormat{UInt16}(io)
        dimension = TextureDimension{2}(256, 256)
        IntensityTextureInput{2, UInt16}(dimension, flatformat)
    end
end

function loadslices(path::String, dataset::Symbol) :: IntensityTextureInput{3, UInt16}
    textureinputs2d = IntensityTextureInput{2, UInt16}[
        loadslice(joinpath(path, slicepath))
        for slicepath in datasets[dataset]
    ]

    dimension = TextureDimension{2}(256, 256)
    IntensityTextureInput{3, UInt16}(dimension, textureinputs2d)
end

function run(path::String, dataset::Symbol)
    context = Visualizer.start()

    ev = Visualizer.SelectVisualizationEvent("Show3DTexture")
    put!(context.channel, ev)


    loadev = Show3DTextures.Load3DTexture(loadslices, (path, dataset))
    put!(context.channel, loadev)

    if !isinteractive()
        Visualizer.waituntilstop(context)
    end
end

end # module StanfordDatasets