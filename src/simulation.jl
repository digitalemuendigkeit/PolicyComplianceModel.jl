using Agents
using LightGraphs
using DataFrames
using CSV
using Random
using Distributions


mutable struct Citizen <: AbstractAgent
    id::Int64
    pos::Int64
    opinions::Float64  # find distribution
    newsfeed::AbstractArray
    # trust::Float64  # trust in administration, find distribution
    # memory::AbstractArray  # priority queue / higher weight of events frequently reported on
    # perceived_threat::Float64
    # media_use::Float64
    # fear::Float64
    # risk_affinity::Float64
    # frustration
    # comply::Bool
end


struct Event
    quality::Int64
    pos::Int64
    scope::Symbol  # :L -> local, :G -> global
    type::Symbol
end

function create_events!(model)
    # non-complicance event:
        # subgraph of non-compliant agents
        # find biggest component
        # greater than threshold?
            # find most central agent -> position of event
            # create the event
    # triggered when a specified number of agents don't comply
    # non-compliance event triggers reaction of authorities
        # might backfire or not
    # linked to behavioral_effects event
    if rand() < 0.1
        scope = bitrand()[1] ? :L : :G
        push!(
            model.events,
            Event(bitrand()[1] ? -1 : 1, rand(1:nv(model.space.graph)), scope, :non_compliance)
        )
    end

    # outbreak event:
        # contingent on SIR model
    # contingent on non-compliance
    # random: frequently at first, then more infrequently
    if rand() < 0.1
        scope = bitrand()[1] ? :L : :G
        push!(
            model.events,
            Event(rand() * 2 - 1, rand(1:nv(model.space.graph)), scope, :outbreak)
        )
    end

    # socio-economic event:
        # if rand() < 0.01
            # create socio_economic event
    # severity contingent on number of agents it concerns
    # linked with outbreak
    # positive - negative continuum
    # -> model variable (e.g., socio-economic norm)
        # agents have thresholds for behaviors
    if rand() < 0.1
        scope = bitrand()[1] ? :L : :G
        push!(
            model.events,
            Event(rand() * 2 - 1, rand(1:nv(model.space.graph)), scope, :socio_economic)
        )
    end

    # remedy event:
        # if rand() < 0.01
            # create remedy event
    # phases medications go through
    # mainly news on vaccine
    # every two days -> new article on remedy (content varies though)
    # dependence on overall threat level
    if rand() < 0.01
        scope = bitrand()[1] ? :L : :G
        push!(
            model.events,
            Event(rand() * 2 - 1, rand(1:nv(model.space.graph)), scope, :remedy)
        )
    end
    # research event
    # if rand() < 0.01
        # create research event
    # grouping research and remedy event?
    # remedy = positive research event
    # not directly affected by agents
    # positive - negative scale
    if rand() < 0.1
        scope = bitrand()[1] ? :L : :G
        push!(
            model.events,
            Event(rand() * 2 - 1, rand(1:nv(model.space.graph)), scope, :research)
        )
    end

    # behavioral effects event:
        # for n in nodes
            # if n_agents > threshold:
                # create behavioral_effects event
    # hamstering / bulk buying
        # perceived risk + concern
        # personality
        # concern decreases with time
        # media play a role
    # protests
        # conformist vs. non-conformist
        # social norm
        # compliance vs. non-compliance
        # [0, 1]
        # threshold for protests (influenced by disease numbers)
            # low numbers + high restrictions
        # dependent on personality
    if rand() < 0.1
        scope = bitrand()[1] ? :L : :G
        push!(
            model.events,
            Event(rand() * 2 - 1, rand(1:nv(model.space.graph)), scope, :behavioral_effects)
        )
    end
end

mutable struct Newspost
    event::Event
    accuracy::Float64
    bias::Float64
    sentiment::Float64
    date::Int64
    view_count::Int64
end

function create_newsposts!(model)
    if length(model.events) > 10
        range = 1:10
    else
        range = 1:length(model.events)
    end
    for e in model.events[range]
        for i in 1:(ceil(Int64, 20 * e.severity))
            push!(
                model.newsposts,
                Newspost(e, rand(), rand(), rand(), model.tick, 0),
            )
        end
    end
end


function share_newspost(agent, model, event)
end

# SIR model to be run in parallel

populations = CSV.read(joinpath("data", "uk_structure", "populations_metro_areas.csv"))
populations = collect(populations["Populations"])

# n = Int64[33, 33, 34]
# c = Int64[
#     2 2 2;
#     2 2 2;
#     2 2 2
# ]

n = [convert(Int64, i) for i in round.(populations ./ 1000)]
c = ones(Float64, 75, 75)
for i in 1:length(n)
    for j in 1:length(n)
        c[i, j] = (n[i] + n[j]) / sum(n)
        c[j, i] = c[i, j]
    end
end

space = GraphSpace(stochastic_block_model(c, n))

# using GraphPlot
# gplot(space.graph)

# https://link.springer.com/article/10.1007/s41109-019-0170-z ?

properties = Dict(
    :compliance => 0.0,
    :policy_ranges => Dict(),  # policy => range
    :hospital_capacity => 1.0,  # initialize with realistic number
    :policy_restrictiveness => 0.0,
    :event_thresholds => Dict(),
    :event_types => Symbol[
        :outbreak, :non_compliance, :behavioral_effects,
        :socio_economic, :remedy, :research
    ],
    :events => Event[],
    :newsposts => Newspost[],
    :tick => 0
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
            randn(),
            Newspost[]
        ),
        model
    )
end

function check_feed!(agent)

end

function update_memory!()
    # update priorities
end

function agent_step!(agent, model)
    # look at news feed
    # do sth with memory
    # factor in trust
    # (perceived threat --> comply)

    # --> outcome on opinion
    # --> outcome on comply
end

function model_step!(model)
    create_events!(model)
    create_newsposts!(model)
    model.tick += 1
    return model
    # count number of compliant agents
end

agent_df, model_df = run!(
    model, agent_step!, model_step!, 100,
    adata=[], mdata=[:events, :newsposts]
)

model_df[!, :events]
