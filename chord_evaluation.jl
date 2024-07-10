include("chord_orderings.jl")
include("chord_extensions.jl")

# TODO: slash chords

# absolute_chord_decomposition_re = r"^(?<tonic>[A-G][b♭𝄫#♯𝄪]*)(?<qualities>[^()]*)(?:\((?<extensions>.*)\))?$"
const _relative_chord_decomposition_re::Regex = r"^(?<qualities>[^()]*)(?:\((?<extensions>.*)\))?$"

# function RelativeChord(qualities::Vector{ChordQuality}, extensions::Vector{ChordExtension}, evaluation_ordering::Ordering, base_chord = BASE_MAJOR_CHORD)
#     ordered_modifiers = reverse((q -> q.modifier).(sort(qualities, order = evaluation_ordering)))
#     composed_modifier = reduce(∘, ordered_modifiers)
#     composed_modifier(base_chord)
# end

import Base: parse

function parse(
    ::Type{RelativeChord{T}},
    chord::AbstractString,
    ordered_qualities_dict::OrderedDict{String, ChordQuality} = standard_qualities_ordered_dict,
    extensions_dict::Dict{Regex, ChordExtension} = standard_extensions_dict,
    evaluation_ordering::Ordering = standard_quality_evaluation_ordering;
    base_chord::RelativeChord = BASE_MAJOR_CHORD
) where T <: Interval

    qualities, extensions = getindex.(Ref(match(_relative_chord_decomposition_re, chord)), ["qualities", "extensions"])

    quality_vector = ChordQuality[]
    if !isnothing(qualities) && !isempty(qualities)
        for (rep, quality) ∈ pairs(ordered_qualities_dict)
            if occursin(rep, qualities)
                push!(quality_vector, quality)
                qualities = replace(qualities, rep => "")
            end
        end
        @assert isempty(qualities) "unknown chord qualities"

        ordered_quality_modifiers = (q -> q.modifier).(sort(quality_vector, order = evaluation_ordering))
        composed_quality_modifier = reduce(∘, reverse(ordered_quality_modifiers))
    else
        composed_quality_modifier = identity
    end

    extension_modifier_vector = Function[]
    if !isnothing(extensions) && !isempty(extensions)
        extension_list = strip.(split(extensions, ","))
        for str_ext ∈ extension_list
            for (re, extension) ∈ pairs(extensions_dict)
                m = match(re, str_ext)
                if !isnothing(m)
                    push!(extension_modifier_vector, (chord -> apply_extension(chord, extension, m)))
                    break
                end
            end
        end
        composed_extension_modifier = reduce(∘, reverse(extension_modifier_vector))
    else
        composed_extension_modifier = identity
    end

    final_modifier = composed_extension_modifier ∘ composed_quality_modifier

    final_modifier(base_chord)
end

# RelativeChord((m = match(relative_chord_decomposition_re, chord))["qualities"], m["extensions"], detection_ordering, evaluation_ordering)

# tonic, qualities, extensions = getindex.(Ref(match(chord_decomposition_re, chord)), ("tonic", "qualities", "extensions"))

parse(
    ::Type{RelativeChord{T}},
    chord::AbstractString,
    qualities_dict::Dict{String, ChordQuality},
    extensions_dict::Dict{Regex, ChordExtension},
    detection_ordering::Ordering,
    evaluation_ordering::Ordering;
    base_chord::RelativeChord = BASE_MAJOR_CHORD
) where T <: Interval = parse(RelativeChord{T}, chord, sort(OrderedDict(qualities_dict), order = detection_ordering), extensions_dict, evaluation_ordering, base_chord = base_chord)


macro rc_str(chord)
    parse(RelativeChord{MusicInterval}, chord, standard_qualities_ordered_dict, standard_extensions_dict, standard_quality_evaluation_ordering, base_chord = BASE_MAJOR_CHORD)
end