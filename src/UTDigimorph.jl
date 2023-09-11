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

module UTDigimorph

using Alfar.Visualizer
using Alfar.Visualizer.Show3DTextures
using Alfar.Visualizer.ShowTextures
using Alfar.Rendering.Textures

using TiffImages

mutable struct TiffFormat <: TextureInputIO{Float16}
    data::Vector{Float16}
    current::Int

    function TiffFormat(path::String)
        img = TiffImages.load(path)
        onedimimg = reshape(img, (prod(size(img)), ))
        data = [Float16(onedimimg[i]) for i in eachindex(onedimimg)]
        new(data, 1)
    end
end


function Textures.readtexel(tf::TiffFormat, ::Type{Float16})
    v = tf.data[tf.current]
    tf.current +=1
    v
end

datasets = Dict{Symbol, Vector{String}}(
    :Pawpaw => ["pawpa$(lpad(i, 4, '0')).tif" for i=1:1088],
)

function loadslice(slicepath::String) :: IntensityTextureInput{2, Float16}
    tiffformat = TiffFormat(slicepath)
    dimension = TextureDimension{2}(646, 958)
    IntensityTextureInput{2, Float16}(dimension, tiffformat)
end

function loadslicetexture(slicepath::String) :: IntensityTexture{2, Float16}
    textureinput = loadslice(slicepath)
    IntensityTexture{2, Float16}(textureinput)
end

function loadslices(path::String, dataset::Symbol) :: IntensityTexture{3, Float16}
    textureinputs2d = IntensityTextureInput{2, Float16}[
        loadslice(joinpath(path, slicepath))
        for slicepath in datasets[dataset]
    ]

    dimension = TextureDimension{2}(646, 958)
    textureinput = IntensityTextureInput{3, Float16}(dimension, textureinputs2d)
    IntensityTexture{3, Float16}(textureinput)
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

function showslice(path::String)
    context = Visualizer.start()

    ev = Visualizer.SelectVisualizationEvent("ShowTexture")
    put!(context.channel, ev)

    loadev = ShowTextures.Load2DTexture(loadslicetexture, (path, ))
    put!(context.channel, loadev)

    if !isinteractive()
        Visualizer.waituntilstop(context)
    end
end

end # module UTDigimorph