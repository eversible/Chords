include("chord_orderings.jl")

# absolute_chord_decomposition_re = r"^(?<tonic>[A-G][b♭𝄫#♯𝄪]*)(?<qualities>[^()]*)(?:\((?<extensions>.*)\))?$"
relative_chord_decomposition_re = r"^(?<qualities>[^()]*)(?:\((?<extensions>.*)\))?$"

function RelativeChord(qualities::Vector{ChordQuality}, extensions::Vector{ChordExtension}, evaluation_ordering::Ordering, base_chord = BASE_MAJOR_CHORD)
    ordered_modifiers = (q -> q.modifier).(sort(qualities, order = evaluation_ordering, rev = true))
    composed_modifier = reduce(∘, ordered_modifiers)
    composed_modifier(base_chord)
end

import Base: parse

function parse(
    ::Type{RelativeChord},
    chord::String,
    ordered_qualities_dict::OrderedDict{String, ChordQuality},
    extensions_dict::Dict{String, ChordExtension},
    evaluation_ordering::Ordering,
    base_chord::RelativeChord = BASE_MAJOR_CHORD
)

    qualities, extensions = getindex.(Ref(match(relative_chord_decomposition_re, chord)), ["qualities", "extensions"])

    qualities_vector = ChordQuality[]
    extensions_vector = ChordExtension[]

    if !(qualities isa Nothing)
        for (rep, quality) ∈ pairs(ordered_qualities_dict)
            if occursin(rep, qualities)
                push!(qualities_vector, quality)
                qualities = replace(qualities, rep => "")
            end
        end
        @assert isempty(qualities) "unknown chord qualities"
    end

    RelativeChord(qualities_vector, extensions_vector, evaluation_ordering)
end

# RelativeChord((m = match(relative_chord_decomposition_re, chord))["qualities"], m["extensions"], detection_ordering, evaluation_ordering)

# tonic, qualities, extensions = getindex.(Ref(match(chord_decomposition_re, chord)), ("tonic", "qualities", "extensions"))

parse(
    T::Type{RelativeChord},
    chord::String,
    qualities_dict::Dict{String, ChordQuality},
    extensions_dict::Dict{String, ChordExtension},
    detection_ordering::Ordering,
    evaluation_ordering::Ordering,
    base_chord::RelativeChord = BASE_MAJOR_CHORD
) = parse(T, chord, sort(OrderedDict(qualities_dict), order = detection_ordering), extensions_dict, evaluation_ordering, base_chord = base_chord)


macro rc_str(chord) # TODO: update extensions_dict
    parse(RelativeChord, chord, standard_qualities_ordered_dict, Dict{String, ChordExtension}(), standard_quality_evaluation_ordering)
end