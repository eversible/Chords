include("tonic_chords.jl")

practice_set(relative_chord_list::Vector{String}; kwargs...) = Dict(string(tonic) * chord_str => chord for chord_str ∈ relative_chord_list for (tonic, chord) ∈ pairs(all_tonics(parse(RelativeChord{MusicInterval}, chord_str; kwargs...))))

macro practice_set(set_name, chords::String...)
    chords = collect(chords)
    :($(esc(set_name)) = practice_set($chords))
end

# single chords
@practice_set major_chords ""
@practice_set minor_chords "-"
@practice_set major7_chords "Δ7"
@practice_set dominant7_chords "7"
@practice_set minor_major7_chords "-Δ7"
@practice_set half_diminished_chords "ø7"
@practice_set diminished_chords "o7"
@practice_set augmented_chords "+"
@practice_set augmented7_chords "+7"
@practice_set minor_augmented_chords "-+"
@practice_set minor_augmented_dominant_chords "-+7"
@practice_set suspended_chords "(sus2)" "(sus4)" "9(sus4)"

# multiple chords
@practice_set basic_chords "" "-" "7" "Δ7"
@practice_set common_chords "" "-" "7" "Δ7" "-Δ7" "o7" "ø7"
@practice_set extra_chords "" "-" "7" "Δ7" "-Δ7" "o7" "ø7" "+" "+7" "9(sus4)"