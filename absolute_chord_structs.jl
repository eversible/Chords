include("chord_evaluation.jl")
include("note_structs.jl")

import Base: convert, show

# absolute_chord_decomposition_re = r"^(?<tonic>[A-G][b♭𝄫#♯𝄪]*)(?<qualities>[^()]*)(?:\((?<extensions>.*)\))?$"
const _partial_absolute_chord_decomposition_re::Regex = r"(?<tonic>[A-G][b♭𝄫#♯𝄪]*)(?<relative_chord>.*)"

struct PointedChord{T <: Interval}
    tonic::NoteClass{T}
    relative_chord::RelativeChord{T}
end

function parse(
    ::Type{PointedChord{MusicInterval}},
    s::AbstractString,
    ordered_qualities_dict::OrderedDict{String, ChordQuality} = standard_qualities_ordered_dict,
    extensions_dict::Dict{Regex, ChordExtension} = standard_extensions_dict,
    evaluation_ordering::Ordering = standard_quality_evaluation_ordering;
    base_chord::RelativeChord = BASE_MAJOR_CHORD
)
    tonic, relative_chord = getindex.(Ref(match(_partial_absolute_chord_decomposition_re, s)), ["tonic", "relative_chord"])
    PointedChord(parse(NoteClass{MusicInterval}, tonic), parse(RelativeChord{MusicInterval}, relative_chord, ordered_qualities_dict, extensions_dict, evaluation_ordering, base_chord = base_chord))
end

macro pc_str(s)
    parse(PointedChord{MusicInterval}, s, standard_qualities_ordered_dict, standard_extensions_dict, standard_quality_evaluation_ordering, base_chord = BASE_MAJOR_CHORD)
end

# TODO:
struct ChordClass{T <: Interval}
    notes::Vector{NoteClass{T}}
end
show(io::IO, chord::ChordClass) = join(io, string.(chord.notes), ' ')

apply_chord(chord::RelativeChord{MusicInterval}, base_scale::Vector{NoteClass{MusicInterval}})::ChordClass = ChordClass([interval.accidental + base_scale[mod1(interval.interval, end)] for interval ∈ chord])

convert(::Type{ChordClass}, pointed_chord::PointedChord)::ChordClass = apply_chord(pointed_chord.relative_chord, major_scale(pointed_chord.tonic))

macro c_str(s)
    :(convert(ChordClass, @pc_str $s))
end