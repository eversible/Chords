include("chord_structs.jl")

suspended_modifier(chord::RelativeChord{MusicInterval}; interval) = RelativeChord(setdiff(chord.intervals, SortedSet([MINOR_3RD, MAJOR_3RD])) ∪ (isempty(interval) ? SortedSet([PERFECT_4TH]) : SortedSet([parse(MusicInterval, interval)])))
addition_modifier(chord::RelativeChord{MusicInterval}; interval) = RelativeChord(chord.intervals ∪ SortedSet([parse(MusicInterval, interval)]))
omission_modifier(chord::RelativeChord{MusicInterval}; interval) = RelativeChord(setdiff(chord.intervals, SortedSet([parse(MusicInterval, interval)])))

# should you actually remove all instances of the interval, rather than just the no-accidental interval?
accidentallation_modifier(chord::RelativeChord{MusicInterval}; interval) = RelativeChord(setdiff(chord.intervals, SortedSet([MusicInterval(0, (i = parse(MusicInterval, interval)).interval)])) ∪ SortedSet([i]))

suspension, addition, omission, accidentallation = 
standard_extensions_vector = [
    ChordExtension( # suspension
        detection_regex = r"sus(?<interval>[#♯𝄪b♭𝄫]*\d*)",
        representations = (interval -> "sus$interval", interval -> interval == "4" ? "sus" : "sus$interval"),
        modifier = suspended_modifier
    ),
    ChordExtension( # addition
        detection_regex = r"add(?<interval>[#♯𝄪b♭𝄫]*\d*)",
        representations = (interval -> "add$interval",),
        modifier = addition_modifier
    ),
    ChordExtension( # omission
        detection_regex = r"omit(?<interval>[#♯𝄪b♭𝄫]*\d*)",
        representations = (interval -> "omit$interval",),
        modifier = omission_modifier
    ),
    ChordExtension( # accidentallation
        detection_regex = r"(?<interval>[#♯𝄪b♭𝄫]*\d*)",
        representations = (interval -> String(interval),),
        modifier = accidentallation_modifier
    )
]