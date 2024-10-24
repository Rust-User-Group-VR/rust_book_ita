## Commenti

Tutti i programmatori si impegnano a rendere il loro codice facile da comprendere, ma a volte è giustificata una spiegazione extra. In questi casi, i programmatori lasciano *commenti* nel loro codice sorgente che il compilatore ignorerà ma che le persone che leggono il codice sorgente potrebbero trovare utili.

Ecco un semplice commento:

```rust
// hello, world
```

In Rust, lo stile idiomatico dei commenti inizia un commento con due barre, e il commento continua fino alla fine della riga. Per i commenti che si estendono oltre una singola riga, sarà necessario includere `//` su ciascuna riga, come questo:

```rust
// Stiamo facendo qualcosa di complicato qui, abbastanza lungo da
// richiedere più righe di commenti per farlo! Uff! Si spera che questo commento
// spieghi cosa sta succedendo.
```

I commenti possono essere posizionati anche alla fine delle righe contenenti il codice:

<span class="filename">Filename: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-24-comments-end-of-line/src/main.rs}}
```

Ma più spesso li vedrete utilizzati in questo formato, con il commento su una linea separata sopra il codice che annota:

<span class="filename">Filename: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-25-comments-above-line/src/main.rs}}
```

Rust ha anche un altro tipo di commento, commenti di documentazione, che discuteremo nella sezione [“Pubblicazione di un Crate su Crates.io”][publishing]<!-- ignore --> del Capitolo 14.

[publishing]: ch14-02-publishing-to-crates-io.html
