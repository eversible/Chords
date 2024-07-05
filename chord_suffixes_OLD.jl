#! MOVED INTO chord_qualities.jl

include("chord_structs.jl")

macro remadd_chord(name, removals, additions)
    removals  = SortedSet{MusicInterval}(eval(removals ))
    additions = SortedSet{MusicInterval}(eval(additions))
    math_removals  = convert.(MathInterval, removals )
    math_additions = convert.(MathInterval, additions)
    quote
        $(esc(name))(chord::RelativeChord{MusicInterval}) = RelativeChord(setdiff(chord.intervals, $removals) ∪ $additions)
        $(esc(name))(chord::RelativeChord{MathInterval}) = RelativeChord(setdiff(chord.intervals, $math_removals) ∪ $math_additions)
    end
end

@remadd_chord minor_modifier [i"3"] [i"♭3"]
@remadd_chord augmented_modifier [i"5"] [i"♯5"]
@remadd_chord dominant7_modifier [] [i"♭7"]
@remadd_chord dominant9_modifier [] [i"♭7", i"9"]
@remadd_chord dominant11_modifier [] [i"♭7", i"9", i"11"]
@remadd_chord dominant13_modifier [] [i"♭7", i"9", i"11", i"13"]
@remadd_chord sixnine_modifier [] [i"6", i"9"]

major_modifier(chord::RelativeChord{MusicInterval}) = MINOR_7TH ∈ chord || DIMINISHED_7TH ∈ chord ? RelativeChord(setdiff(chord.intervals, SortedSet([MINOR_7TH, DIMINISHED_7TH])) ∪ SortedSet([MAJOR_7TH])) : chord
#! DO I WANT THE FOLLOWING BEHAVIOUR? MAYBE DO NOT DEFINE FOR MATHINTERVALS
major_modifier(chord::RelativeChord{MathInterval}) = MATH_MINOR_7TH ∈ chord || DIMINISHED_7TH ∈ chord ? RelativeChord(setdiff(chord.intervals, SortedSet([MATH_MINOR_7TH, MATH_DIMINISHED_7TH])) ∪ SortedSet([MATH_MAJOR_7TH])) : chord

@remadd_chord half_diminished_modifier [i"3", i"5"] [i"♭3", i"♭5"]
diminished_modifier(chord::RelativeChord{MusicInterval}) = half_diminished_modifier(MINOR_7TH ∈ chord ? RelativeChord(setdiff(chord.intervals, SortedSet([MINOR_7TH])) ∪ SortedSet([DIMINISHED_7TH])) : chord)
diminished_modifier(chord::RelativeChord{MathInterval}) = half_diminished_modifier(MATH_MINOR_7TH ∈ chord ? RelativeChord(setdiff(chord.intervals, SortedSet([MATH_MINOR_7TH])) ∪ SortedSet([MATH_DIMINISHED_7TH])) : chord)