include("note_structs.jl")

C, D, E, F, G, A, B = NoteClass.(MusicInterval.(0, [1, 2, 3, 4, 5, 6, 7]))

D♭ = NoteClass(i"♭2")
C♯ = NoteClass(i"♯1")

D♯ = NoteClass(i"♯2")
E♭ = NoteClass(i"♭3")

E♯ = NoteClass(i"♯3")
F♭ = NoteClass(i"♭4")

F♯ = NoteClass(i"♯4")
G♭ = NoteClass(i"♭5")

G♯ = NoteClass(i"♯5")
A♭ = NoteClass(i"♭6")

A♯ = NoteClass(i"♯6")
B♭ = NoteClass(i"♭7")

B♯ = NoteClass(i"♯7")
C♭ = NoteClass(i"♭8")