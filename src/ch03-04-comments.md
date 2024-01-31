## Commenti

Tutti i programmatori si sforzano di rendere il loro codice facile da capire, ma a volte
è garantita un'ulteriore spiegazione. In questi casi, i programmatori lasciano *commenti* nel
loro codice sorgente che il compilatore ignorerà, ma che le persone che leggono il codice sorgente potrebbero trovare utili.

Ecco un semplice commento:

```rust
// ciao, mondo
```

In Rust, lo stile idiomatico di commento inizia un commento con due barre, e il
commento continua fino alla fine della riga. Per commenti che si estendono oltre una
singola riga, dovrai includere `//` su ogni riga, come questo:

```rust
// Quindi stiamo facendo qualcosa di complicato qui, abbastanza lungo da richiedere
// più righe di commenti per farlo! Uff! Speriamo che questo commento spiegherà 
// cosa sta succedendo.
```

I commenti possono anche essere posti alla fine delle righe contenenti il codice:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-24-comments-end-of-line/src/main.rs}}
```

Ma più spesso li vedrai utilizzati in questo formato, con il commento su una
riga separata sopra il codice a cui si riferisce:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-25-comments-above-line/src/main.rs}}
```

Rust ha anche un altro tipo di commento, i commenti di documentazione, di cui ne discuteremo
nella sezione [“Pubblicazione di una Crate su Crates.io”][pubblicazione]<!-- ignora -->
del Capitolo 14.

[pubblicazione]: ch14-02-publishing-to-crates-io.html
