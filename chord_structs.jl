include("interval_structs.jl")

using Parameters
using DataStructures

struct RelativeChord{T <: Interval}
    intervals::SortedSet{T}
end
RelativeChord(intervals) = RelativeChord(SortedSet(intervals))

Base.in(elt::T, chord::RelativeChord{T}) where T = elt ∈ chord.intervals
Base.show(io::IO, chord::RelativeChord) = join(io, string.(chord.intervals), ' ')

BASE_MAJOR_CHORD = RelativeChord([i"1", i"3", i"5"])


# @with_kw struct ChordAttribute{T <: Function}
#     representations::Vector{String} # list of suffix representations, e.g. ["-", "m", "min"]
#     default_representation_index::Int = 1 # index of default representation, e.g. 2 for "m7"
#     # detection_regex::Regex # regex specifying how to detect quality, e.g. r"-|m|min"
#     modifier::T # function specifying how to modify chords
# end

abstract type ChordAttribute end

@with_kw struct ChordQuality{T <: Function} <: ChordAttribute
    representations::Vector{String} # list of suffix representations, e.g. ["-", "m", "min"]
    default_representation_index::Int = 1 # index of default representation, e.g. 2 for "m7"
    detection_representations::Vector{String} = representations
    modifier::T # function specifying how to modify chords
end
apply_quality(chord::RelativeChord, quality::ChordQuality) = quality.modifier(chord)

re_match_to_symbol_dict(re_match::RegexMatch) = Dict(Symbol(group) => String(val) for (group, val) ∈ pairs(re_match))

@with_kw struct ChordExtension{T <: Function, S <: Tuple{Vararg{Function}}} <: ChordAttribute
    # regex for detecting chord extension where the group names (e.g. "ivl") are keyword arguments to the other functions in the struct
    detection_regex::Regex
    # tuple of representation functions with the detection_regex group names as keyword arguments and outputting a string representation,
    # e.g. [ivl -> "sus$ivl", ivl -> ivl == "4" ? "sus" : "sus$ivl"]
    representations::S
    default_representation_index::Int = 1 # index of default representation function
    # function taking a chord and the detection_regex group names as keyword arguments specifying how to modify chords
    modifier::T 
end
ChordExtension(detection_regex, representations::Vector{Function}, default_representation_index, modifier) = ChordExtension(detection_regex = detection_regex, representations = Tuple(representations), default_representation_index = default_representation_index, modifier = modifier)

apply_extension(chord::RelativeChord, extension::ChordExtension; kwargs...) = extension.modifier(chord; kwargs...)
apply_extension(chord::RelativeChord, extension::ChordExtension, re_match::RegexMatch) = apply_extension(chord, extension; re_match_to_symbol_dict(re_match)...)
apply_extension(chord::RelativeChord, extension::ChordExtension, extension_string::String) = apply_extension(chord, extension, match(extension.detection_regex, extension_string))

# unparameterised_apply_extension(; kwargs...) = (chord, extension) -> apply_extension(chord, extension; kwargs...)
# unparameterised_apply_extension(str::Union{String, RegexMatch}) = (chord, extension) -> apply_extension(chord, extension, extension_string)

evert_quality_vector(vec::Vector{ChordQuality}) = Dict(
    rep => quality  for quality in vec for rep in quality.detection_representations
)
evert_extension_vector(vec::Vector{ChordExtension}) = Dict(
    extension.detection_regex => extension for extension in vec
)



# @with_kw struct RelativeChord
#     name::String # text name of chord, e.g. "minor 7th"
#     suffixes::Vector{String} # list of all possible suffixes, e.g. ["-7", "m7", "min7"]
#     default_suffix_index::Int = 1 # index of default suffix, e.g. 2 for "m7"
#     intervals::ChordComposition # notes which compose the chord
# end

# _chord_re::Regex = r"(?:^|\s)(?<accidental>[#♯𝄪b♭𝄫]*)(?<interval>\d+)(?:$|\s)"

# RelativeChord(name, suffixes, default_suffix_index, intervals::String) = RelativeChord(name, suffixes, default_suffix_index, re_match_to_music_interval.(eachmatch(_chord_re, intervals, overlap = true)))