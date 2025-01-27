using Base: ImmutableDict

import Base: +, -, <, parse, string, show, isless, zero, convert, promote_rule

abstract type Interval end

struct MathInterval <: Interval
    interval::Int
end

+(x::MathInterval, y::MathInterval) = MathInterval(x.interval + y.interval)
-(x::MathInterval, y::Interval) = MathInterval(x.interval - y.interval)
-(x::MathInterval) = MathInterval(-x.interval)

struct Accidental <: Integer
    sharps::Int # number of sharps/flats; negative for flats, positive for sharps
end
convert(::Type{Accidental}, sharps::Int)::Accidental = Accidental(sharps)
convert(::Type{Int}, accidental::Accidental)::Int = accidental.sharps
promote_rule(::Type{Accidental}, ::Type{Int}) = Int
zero(::Type{Accidental})::Accidental = Accidental(0)
+(x::Accidental, y::Accidental)::Accidental = Accidental(x.sharps + y.sharps)
-(x::Accidental, y::Accidental)::Accidental = Accidental(x.sharps - y.sharps)
isless(x::Accidental, y::Accidental) = x.sharps < y.sharps
<(x::Accidental, y::Accidental) = isless(x, y) #! isless fallback not working directly for some reason?

struct MusicInterval <: Interval
    accidental::Accidental
    interval::Int
end
naturalise(interval::MusicInterval)::MusicInterval = MusicInterval(zero(Accidental), interval.interval)

+(accidental::Accidental, interval::MusicInterval) = MusicInterval(interval.accidental + accidental, interval.interval)

compute_accidental(s::AbstractString)::Accidental = Accidental(
    count(∈("#♯"), s) * 1 +
    count(∈("𝄪"), s) * 2 +
    count(∈("b♭"), s) * -1 +
    count(∈("𝄫"), s) * -2
)

string_accidental(accidental::Accidental)::String = (n = accidental.sharps) ≥ 0 ? '♯'^(n % 2) * '𝄪'^(n ÷ 2) : '♭'^-(n % 2) * '𝄫'^-(n ÷ 2)
string_accidental(interval::MusicInterval)::String = string_accidental(interval.accidental)

const _interval_re::Regex = r"^(?<accidental>[#♯𝄪b♭𝄫]*)(?<interval>\d+)$"

re_match_to_music_interval(m::RegexMatch)::MusicInterval = MusicInterval(compute_accidental(m["accidental"]), parse(Int, m["interval"]))

parse(::Type{MusicInterval}, s::AbstractString)::MusicInterval = (
    (m = match(_interval_re, s)) isa Nothing
    ? throw(ArgumentError("invalid interval specification"))
    : re_match_to_music_interval(m)
)

string(music_interval::MusicInterval)::String = string_accidental(music_interval) * string(music_interval.interval)

show(io::IO, music_interval::MusicInterval) = print(io, string(music_interval))

const _music_to_math_dict::ImmutableDict{Int, Int} = ImmutableDict(
    1 => 0,
    2 => 2,
    3 => 4,
    4 => 5,
    5 => 7,
    6 => 9,
    7 => 11
)

MathInterval(music_interval::MusicInterval)::MathInterval = MathInterval(
    music_interval.accidental.sharps + 
    _music_to_math_dict[(music_interval.interval - 1) % 7 + 1] + 12*((music_interval.interval - 1) ÷ 7)
)

isless(x::MusicInterval, y::MusicInterval)::Bool = (x.interval < y.interval) | (x.interval == y.interval && x.accidental < y.accidental)

macro i_str(s)
    parse(MusicInterval, s)
end

PERFECT_UNISON = UNISON = i"1"
DIMINISHED_2ND = i"𝄫2"
MATH_PERFECT_UNISON = MATH_UNISON = MATH_DIMINISHED_2ND = 0

MINOR_2ND = i"♭2"
AUGMENTED_UNISON = i"♯1"
MATH_MINOR_2ND = MATH_AUGMENTED_UNISON = 1

MAJOR_2ND = i"2"
DIMINISHED_3RD = i"𝄫3"
MATH_MAJOR_2ND = MATH_DIMINISHED_3RD = 2

MINOR_3RD = i"♭3"
AUGMENTED_2ND = "♯2"
MATH_MINOR_3RD = MATH_AUGMENTED_2ND = 3

MAJOR_3RD = i"3"
DIMINISHED_4TH = i"𝄫4"
MATH_MAJOR_3RD = MATH_DIMINISHED_4TH = 4

PERFECT_4TH = i"4"
AUGMENTED_3RD = i"♯3"
MATH_PERFECT_4TH = MATH_AUGMENTED_3RD = 5

DIMINISHED_5TH = i"♭5"
AUGMENTED_4TH = i"♯4"
MATH_DIMINISHED_5TH = MATH_AUGMENTED_4TH = 6

PERFECT_5TH = i"5"
DIMINISHED_6TH = i"𝄫6"
MATH_PERFECT_5TH = MATH_DIMINISHED_6TH = 7

MINOR_6TH = i"♭6"
AUGMENTED_5TH = i"♯5"
MATH_MINOR_6TH = MATH_AUGMENTED_5TH = 8

MAJOR_6TH = i"6"
DIMINISHED_7TH = i"𝄫7"
MATH_MAJOR_6TH = MATH_DIMINISHED_7TH = 9

MINOR_7TH = i"♭7"
AUGMENTED_6TH = i"♯6"
MATH_MINOR_7TH = MATH_AUGMENTED_6TH = 10

MAJOR_7TH = i"7"
DIMINISHED_OCTAVE = i"♭8"
MATH_MAJOR_7TH = MATH_DIMINISHED_OCTAVE = 11

PERFECT_OCTAVE = OCTAVE = i"8"
AUGMENTED_7TH = i"♯7"
MATH_PERFECT_OCTAVE = MATH_OCTAVE = MATH_AUGMENTED_7TH = 12

# MAJOR_9TH = i"9"
# MAJOR_11TH = i"11"
# MAJOR_13TH = i"13"