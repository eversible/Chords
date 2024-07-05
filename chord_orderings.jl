include("chord_qualities.jl")

import Base: Ordering, lt


struct WeakOrdering{T, S} <: Ordering
    assignment_dict::ImmutableDict{T, S}
end

# lt(ordering::WeakOrdering{T, S}, a::T, b::T) where {T, S} = all(haskey.(Ref(ordering.assignment_dict), (a, b))) ? ordering.assignment_dict[a] < ordering.assignment_dict[b] : false
lt(ordering::WeakOrdering{T, S}, a::T, b::T) where {T, S} = ordering.assignment_dict[a] < ordering.assignment_dict[b]


function assign_ordering_integers(heirarchy::Vector{Vector{T}}) where T
    assignment_dict = Dict{T, Int}()
    for level ∈ 1:length(heirarchy)
        for t ∈ heirarchy[level]
            haskey(assignment_dict, t) || (assignment_dict[t] = level)
        end
    end
    ImmutableDict(assignment_dict...)
end


detection_weak_ordering_heirarchy = [
    ["Maj", "o/"],
    vcat([quality.detection_representations for quality in [major, sixnine, half_diminished]]...),
    ["min"],
    vcat([quality.detection_representations for quality in [minor, augmented, diminished, dominant7, dominant9, dominant11, dominant13]]...)
]
detection_weak_ordering_assignment = assign_ordering_integers(detection_weak_ordering_heirarchy)

standard_quality_detection_ordering = WeakOrdering(detection_weak_ordering_assignment)

standard_qualities_ordered_dict = sort!(OrderedDict(standard_qualities_dict), order = standard_quality_detection_ordering)


evaluation_weak_ordering_heirarchy = [
    [dominant7, dominant9, dominant11, dominant13],
    [augmented, sixnine, minor, half_diminished, diminished],
    [major]
]
evaluation_weak_ordering_assignment = assign_ordering_integers(evaluation_weak_ordering_heirarchy)

standard_quality_evaluation_ordering = WeakOrdering(evaluation_weak_ordering_assignment)