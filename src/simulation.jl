using Agents
using LightGraphs


mutable struct Citizen <: AbstractAgent
    id::Int64
    pos::Int64
    opinions::AbstractArray
    trust::Float64
    memory::AbstractArray
    newsfeed::AbstractArray
    perceived_threat::Float64
    comply::Bool
end

struct Event
end


c = Int64[
    2 2 2;
    2 2 2;
    2 2 2
]
n = Int64[33, 33, 34]

space = GraphSpace(stochastic_block_model(c, n))

properties = Dict(
    "Compliance" => 0.0
)

model = AgentBasedModel(
    Citizen,
    space,
    scheduler=random_activation,
    properties=properties
)

for i in 1:100
    add_agent_pos!(
        Citizen(
            i,
            i,
            Int64[1, 1, 1, 1],
            0.0,
            Event[Event(), Event()],
            Event[Event(), Event()],
            0.0,
            false
        ),
        model
    )
end

model

function agent_step!()
    # look at news feed
    # do sth with memory
    # factor in trust
    # (perceived threat --> comply)

    # --> outcome on opinion
    # --> outcome on comply
end

function model_step!()
end
