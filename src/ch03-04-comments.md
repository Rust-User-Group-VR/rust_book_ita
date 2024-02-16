## Commenti

Tutti i programmatori si impegnano per rendere il loro codice facile da capire, ma a volte
è giustificata una spiegazione extra. In questi casi, i programmatori lasciano *commenti* nel
loro codice sorgente che il compilatore ignorerà ma che le persone che leggono il codice sorgente potrebbero trovare utile.

Ecco un semplice commento:

```rust
// ciao, mondo
```

In Rust, lo stile idiomatico dei commenti inizia un commento con due barre, e il
commento continua fino alla fine della riga. Per commenti che si estendono oltre una
singola riga, dovrai includere `//` su ogni riga, così:

```rust
// Quindi stiamo facendo qualcosa di complicato qui, abbastanza lungo da avere bisogno
// di molteplici righe di commenti per farlo! Uff! Speriamo che questo commento
// spieghi cosa sta succedendo.
```

I commenti possono anche essere posti alla fine delle righe contenenti codice:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-24-comments-end-of-line/src/main.rs}}
```

Ma li vedrai più spesso utilizzati in questo formato, con il commento su a
linea separata sopra il codice che sta annotando:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-25-comments-above-line/src/main.rs}}
```

Rust ha anche un altro tipo di commento, i commenti di documentazione, di cui parleremo
nella sezione ["Pubblicare una Crate su Crates.io"][publishing]<!-- ignora -->
del Capitolo 14.

[publishing]: ch14-02-publishing-to-crates-io.html
