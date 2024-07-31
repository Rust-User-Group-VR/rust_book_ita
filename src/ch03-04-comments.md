## Commenti

Tutti i programmatori cercano di rendere il proprio codice facile da capire, ma a volte
è necessaria un'ulteriore spiegazione. In questi casi, i programmatori lasciano *commenti* nel
loro codice sorgente che il compilatore ignorerà ma che le persone che leggono il codice sorgente possono trovare utili.

Ecco un semplice commento:

```rust
// hello, world
```

In Rust, lo stile idiomatico dei commenti inizia con due barre oblique, e il
commento continua fino alla fine della riga. Per i commenti che si estendono oltre una
singola riga, sarà necessario includere `//` su ogni riga, come questo:

```rust
// Quindi stiamo facendo qualcosa di complicato qui, abbastanza lungo da richiedere
// più righe di commenti per spiegarlo! Uff! Speriamo che questo commento
// spieghi cosa sta succedendo.
```

I commenti possono anche essere posizionati alla fine delle righe contenenti codice:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-24-comments-end-of-line/src/main.rs}}
```

Ma li vedrai più spesso usare in questo formato, con il commento su una
riga separata sopra il codice che annota:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-25-comments-above-line/src/main.rs}}
```

Rust ha anche un altro tipo di commento, commenti di documentazione, di cui parleremo nella sezione
[“Pubblicare un Crate su Crates.io”][publishing]<!-- ignore --> del Capitolo 14.

[publishing]: ch14-02-publishing-to-crates-io.html
