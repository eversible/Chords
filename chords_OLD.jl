include("chord_structs.jl")

# taken from https://help.flat.io/en/music-notation-software/jazz-chords-list/

base_relative_chords = RelativeChord[
    # 2 notes
    RelativeChord(
        name = "5th",
        suffixes = ["5"],
        intervals = "1 5"
    ),

    # 3 notes
    RelativeChord(
        name = "Major",
        suffixes = [""],
        intervals = "1 3 5"
    ),
    RelativeChord(
        name = "minor",
        suffixes = ["-", "m", "min"],
        intervals = "1 ♭3 5"
    ),
    RelativeChord(
        name = "diminished",
        suffixes = ["o", "dim"],
        intervals = "1 ♭3 ♭5"
    ),
    RelativeChord(
        name = "Augmented",
        suffixes = ["+", "aug"],
        intervals = "1 3 ♯5"
    ),

    # 4 notes
    RelativeChord(
        name = "Dominant 7th",
        suffixes = ["7"],
        intervals = "1 3 5 ♭7"
    ),
    RelativeChord(
        name = "Major 7th",
        suffixes = ["Δ7", "M7", "Maj7"],
        intervals = "1 3 5 7"
    ),
    RelativeChord(
        name = "minor 7th",
        suffixes = ["-7", "m7", "min7"],
        intervals = "1 ♭3 5 ♭7"
    ),
    RelativeChord(
        name = "minor Major 7th",
        suffixes = ["-Δ7", "mM7", "minMaj7"],
        intervals = "1 ♭3 5 7"
    ),
    RelativeChord(
        name = "Augmented 7th",
        suffixes = ["+7", "aug7"],
        intervals = "1 3 ♯5 ♭7"
    ),
    RelativeChord(
        name = "diminished 7th",
        suffixes = ["o7", "dim7"],
        intervals = "1 ♭3 ♭5 𝄫7"
    ),
    RelativeChord(
        name = "half-diminished 7th",
        suffixes = ["ø7"],
        intervals = "1 ♭3 ♭5 ♭7"
    ),
    RelativeChord(
        name = "Major 6th",
        suffixes = ["6"],
        intervals = "1 3 5 6"
    ),
    RelativeChord(
        name = "minor 6th",
        suffixes = ["-6", "m6", "min6"],
        intervals = "1 ♭3 5 6"
    ),
    RelativeChord(
        name = "Augmented Major 7th",
        suffixes = ["+Δ7", "augΔ7", "+M7", "augM7", "+Maj7", "augMaj7"],
        intervals = "1 3 ♯5 7"
    ),

    # 5 notes
    RelativeChord(
        name = "Dominant 9th",
        suffixes = ["9"],
        intervals = "1 3 5 ♭7 9"
    ),
    RelativeChord(
        name = "minor 9th",
        suffixes = ["-9", "m9", "min9"],
        intervals = "1 ♭3 5 ♭7 9"
    ),
    RelativeChord(
        name = "Major 9th",
        suffixes = ["Δ9", "M9", "Maj9"],
        intervals = "1 3 5 7 9"
    ),
    RelativeChord(
        name = "Augmented 9th",
        suffixes = ["+9", "aug9"],
        intervals = "1 3 ♯5 ♭7 9"
    ),
    RelativeChord(
        name = "diminished 9th",
        suffixes = ["o9", "dim9"],
        intervals = "1 ♭3 ♭5 𝄫7 9"
    ),
    RelativeChord(
        name = "half-diminished 9th",
        suffixes = ["o9", "dim9"],
        intervals = "1 ♭3 ♭5 ♭7 9"
    ),
    RelativeChord(
        name = "minor Major 9th",
        suffixes = ["-Δ9", "mM9", "minMaj9"],
        intervals = "1 ♭3 5 7 9"
    ),
    RelativeChord(
        name = "6th/9th",
        suffixes = ["69"],
        intervals = "1 3 5 6 9"
    ),

    # 6 notes
    RelativeChord(
        name = "Dominant 11th",
        suffixes = ["11"],
        intervals = "1 3 5 ♭7 9 11"
    ),
    RelativeChord(
        name = "minor 11th",
        suffixes = ["-11", "m11", "min11"],
        intervals = "1 ♭3 5 ♭7 9 11"
    ),
    RelativeChord(
        name = "Major 11th",
        suffixes = ["Δ11", "M11", "Maj11"],
        intervals = "1 3 5 7 9 11"
    ),
    RelativeChord(
        name = "minor Major 11th",
        suffixes = ["-Δ11", "mM11", "minMaj11"],
        intervals = "1 ♭3 5 7 9 11"
    ),

    # 7 notes
    RelativeChord(
        name = "Dominant 13th",
        suffixes = ["13"],
        intervals = "1 3 5 ♭7 9 11 13"
    ),
    RelativeChord(
        name = "minor 13th",
        suffixes = ["-13", "m13", "min13"],
        intervals = "1 ♭3 5 ♭7 9 11 13"
    ),
    RelativeChord(
        name = "Major 13th",
        suffixes = ["Δ13", "M13", "Maj13"],
        intervals = "1 3 5 7 9 11 13"
    ),
    RelativeChord(
        name = "minor Major 13th",
        suffixes = ["-Δ13", "mM13", "minMaj13"],
        intervals = "1 ♭3 5 7 9 11 13"
    )
]