using Agents
using LightGraphs


mutable struct Citizen <: AbstractAgent
    id::Int64
    pos::Int64
    opinions::Float64
    trust::Float64
    memory::AbstractArray  # priority queue / higher weight of events frequently reported on
    newsfeed::AbstractArray
    perceived_threat::Float64
    media_use::Float64
    fear::Float64
    risk_affinity::Float64
    # frustration
    comply::Bool
end

struct Event
    severity::Float64
    pos::Int64
    scope::Symbol  # :L -> local, :G -> global
    type::String  # specify the levels somewhere

    # severity
    # proximity
        # social proximity: event affects myself or my friends
    # local / global
        # somebody close gets infected

    # event types:

        # new policies / information
            # travel restrictions
            # open / close:
                # schools / colleges / kindergartens
                # shops / manufacturing / playgrounds / public transport / recreation facilities
                # hospitals / physicians
        # not adhering to policy -> consequences
        # loosening / tightening of policies
            # contingent on model state (e.g., number of infected -> threshold / range)

        # beginning of a wave / outbreak
            # report numbers (media)

        # financial news / big company bankruptcy
        # social topics relating to Corona

        # potential remedy / vaccine

        # panic / panic buying / "prepping" / irrational behavior
        # organised protest

    # analyse UK media coverage -> classify

end

function create_events(model)
    # non-complicance event:
        # subgraph of non-compliant agents
        # find biggest component
        # greater than threshold?
            # find most central agent -> position of event
            # create the event

    # remedy event:
        # if rand() < 0.01
            # create remedy event

    # outbreak event:
        # contingent on SIR model
end

struct Newspost
    # event
    # type of post (video / text)
    # accuracy
    # credibility
    # bias / reporting bias
    # sentiment / emotional loading
    # news outlet / source
    # date of publication
    # view count / impact
end

function share_newspost(agent, model, event)
end


# SIR model to be run in parallel

c = Int64[
    2 2 2;
    2 2 2;
    2 2 2
]
n = Int64[33, 33, 34]

space = GraphSpace(stochastic_block_model(c, n))

properties = Dict(
    "compliance" => 0.0,
    "policy_ranges" => Dict(),  # policy => range
    "hospital_capacity" => 1.0,  # initialize with realistic number
    "policy_restrictiveness" => 0.0,
    "event_thresholds" => Dict()
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

function check_feed!(agent)
    # change internal state according to feed
end

function update_memory!()
    # update priorities
end

function agent_step!()
    # look at news feed
    # do sth with memory
    # factor in trust
    # (perceived threat --> comply)

    # --> outcome on opinion
    # --> outcome on comply
end

function model_step!()
    # count number of compliant agents
end
