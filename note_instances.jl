include("note_structs.jl")

# C, D, E, F, G, A, B = NoteClass.(MusicInterval.(0, [1, 2, 3, 4, 5, 6, 7]))

macro note_variable(name::Symbol)
    :( $(esc(name)) = @n_str $(string(name)) )
end

macro note_variables(names...)
    expr_vec = Expr[]
    println(names)
    for name ∈ names
        push!(expr_vec, :(@note_variable $name))
    end
    Expr(:block, expr_vec...)
end

@note_variables C D E F G A B

@note_variables C♯ D♯ E♯ F♯ G♯ A♯ B♯
@note_variables C♯♯ D♯♯ E♯♯ F♯♯ G♯♯ A♯♯ B♯♯
@note_variables C𝄪 D𝄪 E𝄪 F𝄪 G𝄪 A𝄪 B𝄪

@note_variables C♭ D♭ E♭ F♭ G♭ A♭ B♭
@note_variables C♭♭ D♭♭ E♭♭ F♭♭ G♭♭ A♭♭ B♭♭
@note_variables C𝄫 D𝄫 E𝄫 F𝄫 G𝄫 A𝄫 B𝄫