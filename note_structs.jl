include("interval_structs.jl")

import Base: getindex, convert, show, +

MIDDLE_C_INDEX = 4

const _letters_to_intervals_from_C_dict::ImmutableDict{String, Int} = ImmutableDict(
    "C" => 1,
    "D" => 2,
    "E" => 3,
    "F" => 4,
    "G" => 5,
    "A" => 6,
    "B" => 7
)

const _intervals_to_letters_from_C_dict::ImmutableDict{Int, String} = ImmutableDict((v => k for (k, v) ∈ pairs(_letters_to_intervals_from_C_dict))...)

const _note_class_re::Regex = r"^(?<tonic>[A-G])(?<accidental>[b♭𝄫#♯𝄪]*)$"

struct Note{T <: Interval}
    interval_from_middle_C::T
end
Note(interval::Int) = Note{MathInterval}(MathInterval(interval))

struct NoteClass{T <: Interval}
    interval_from_C::T # only matters modulo 12 for MathInterval and 7 for MusicInterval
    NoteClass(interval::MathInterval) = new{MathInterval}(MathInterval(interval.interval % 12))
    NoteClass(interval::MusicInterval) = new{MusicInterval}(MusicInterval(interval.accidental, (interval.interval - 1) % 7 + 1))
end
NoteClass(interval::Int) = NoteClass(MathInterval(interval))
NoteClass(accidental::Int, interval::Int) = NoteClass(MusicInterval(accidental, interval))

+(accidental::Accidental, note::NoteClass) = NoteClass(accidental + note.interval_from_C)

show(io::IO, note_class::NoteClass{MusicInterval}) = print(io, _intervals_to_letters_from_C_dict[note_class.interval_from_C.interval] * string_accidental(note_class.interval_from_C))

getindex(note_class::NoteClass{MathInterval}, octave::Int) = Note(note_class.interval_from_C + MathInterval(12*(octave - MIDDLE_C_INDEX)))

isless(x::NoteClass, y::NoteClass) = x.interval_from_C < y.interval_from_C

convert(::NoteClass, note::Note) = NoteClass(note.interval_from_middle_C)

function parse(::Type{NoteClass{MusicInterval}}, s::AbstractString)
    tonic, accidental = getindex.(Ref(match(_note_class_re, s)), ["tonic", "accidental"])
    NoteClass(MusicInterval(compute_accidental(accidental), _letters_to_intervals_from_C_dict[tonic]))
end

macro n_str(s)
    parse(NoteClass{MusicInterval}, s)
end

struct Key
    sharps::Int # specifies number of sharps in key, negative for flats
end
# show(io::IO, key::Key) = key.sharps ≥ 0 ? print(io, "♯"^key.sharps) : print(io, "♭"^-key.sharps)

# note 7 is self-inverse in mod 12, so multiplying by 7 transforms chromatic scale into circle of fifths
Key(note_class::NoteClass{MusicInterval}) = Key(rem(MathInterval(naturalise(note_class.interval_from_C)).interval * 7 + 1, 12, RoundDown) - 1 + 7*(note_class.interval_from_C.accidental))

apply_key(key::Key, note_class::NoteClass{MusicInterval}) = NoteClass(MusicInterval(div(key.sharps, 7, RoundDown) + (rem(note_class.interval_from_C.interval * 2 - 1, 7, RoundDown) + 1 ≤ rem(key.sharps, 7, RoundDown)), note_class.interval_from_C.interval))

major_scale(note_class::NoteClass{MathInterval}) = NoteClass.(Ref(note_class.interval_from_C) .+ MathInterval.([_music_to_math_dict[i] for i ∈ 1:7]))

major_scale(note_class::NoteClass{MusicInterval}) = apply_key.(Ref(Key(note_class)), NoteClass.(MusicInterval.(0, [rem(note_class.interval_from_C.interval + i - 1, 7, RoundDown) + 1 for i ∈ 0:6])))