# Comprendere l'Ownership

L'Ownership è la caratteristica più unica di Rust e ha profonde implicazioni per il
resto del linguaggio. Consente a Rust di garantire la sicurezza della memoria senza
aver bisogno di un garbage collector, quindi è importante capire come funziona l'ownership.
In questo capitolo, parleremo di ownership così come di diverse caratteristiche correlate:
il borrowing, le slice, e come Rust dispone i dati in memoria.

