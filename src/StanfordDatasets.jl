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

function run(path::String, dataset::Symbol)
    println("Slices: $(datasets[dataset])")

    context = Visualizer.start()

    ev = Visualizer.SelectVisualizationEvent("Show3DTexture")
    put!(context.channel, ev)

    if !isinteractive()
        Visualizer.waituntilstop(context)
    end
end

end # module StanfordDatasets