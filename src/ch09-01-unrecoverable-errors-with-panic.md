## Errori Irrecuperabili con `panic!`

A volte accadono cose indesiderate nel tuo codice, e non c'è nulla che tu possa fare al riguardo. In questi casi, Rust ha la macro `panic!`. Ci sono due modi per causare un panic nella pratica: eseguendo un'azione che provoca un panic nel nostro codice (come accedere a un array oltre la fine) o chiamando esplicitamente la macro `panic!`. In entrambi i casi, causiamo un panic nel nostro programma. Di default, questi panics stamperanno un messaggio di errore, svilupperanno, puliranno lo stack e si interromperanno. Tramite una variabile d'ambiente, puoi anche far sì che Rust visualizzi lo stack delle chiamate quando si verifica un panic, per rendere più facile rintracciare la causa del panic.

> ### Sviluppare lo Stack o Abortire in Risposta a un Panic
>
> Di default, quando si verifica un panic, il programma inizia a *sviluppare*, il che significa che Rust risale lo stack e pulisce i dati da ogni funzione che incontra. Tuttavia, risalire e pulire richiede molto lavoro. Rust, quindi, ti permette di scegliere l'alternativa di *abortire* immediatamente, il che termina il programma senza pulire.
>
> La memoria che il programma stava utilizzando dovrà poi essere pulita dal sistema operativo. Se nel tuo progetto hai bisogno di rendere il binario risultante il più piccolo possibile, puoi passare dallo sviluppare all'abortire in caso di panic aggiungendo `panic = 'abort'` alle sezioni `[profile]` appropriate nel tuo file *Cargo.toml*. Ad esempio, se vuoi abortire in caso di panic in modalità release, aggiungi questo:
>
> ```toml
> [profile.release]
> panic = 'abort'
> ```

Proviamo a chiamare `panic!` in un programma semplice:

<span class="filename">Nome file: src/main.rs</span>

```rust,should_panic,panics
{{#rustdoc_include ../listings/ch09-error-handling/no-listing-01-panic/src/main.rs}}
```

Quando esegui il programma, vedrai qualcosa di simile a questo:

```console
{{#include ../listings/ch09-error-handling/no-listing-01-panic/output.txt}}
```

La chiamata a `panic!` causa il messaggio di errore contenuto nelle ultime due righe. La prima linea mostra il nostro messaggio di panic e il luogo nel nostro codice sorgente in cui si è verificato il panic: *src/main.rs:2:5* indica che è la seconda linea, quinto carattere del nostro file *src/main.rs*.

In questo caso, la linea indicata fa parte del nostro codice, e se andiamo a quella linea, vediamo la chiamata alla macro `panic!`. In altri casi, la chiamata a `panic!` potrebbe essere in codice che il nostro codice chiama, e il nome del file e il numero di linea riportati dal messaggio di errore saranno nel codice di qualcun altro dove è chiamata la macro `panic!`, non la linea del nostro codice che alla fine ha portato alla chiamata di `panic!`.

<!-- Vecchio titolo. Non rimuovere o i link potrebbero rompersi. -->
<a id="using-a-panic-backtrace"></a>

Possiamo utilizzare il backtrace delle funzioni da cui la chiamata a `panic!` è partita per capire quale parte del nostro codice sta causando il problema. Per capire come usare un backtrace di `panic!`, diamo un'occhiata a un altro esempio e vediamo com'è quando una chiamata a `panic!` proviene da una libreria a causa di un bug nel nostro codice invece che dal nostro codice che chiama direttamente la macro. Il Listato 9-1 contiene un codice che tenta di accedere a un indice in un vettore oltre l'intervallo degli indici validi.

<span class="filename">Nome file: src/main.rs</span>

```rust,should_panic,panics
{{#rustdoc_include ../listings/ch09-error-handling/listing-09-01/src/main.rs}}
```

<span class="caption">Listato 9-1: Tentativo di accesso a un elemento oltre la fine di un vettore, che causerà una chiamata a `panic!`</span>

Qui, stiamo tentando di accedere al centesimo elemento del nostro vettore (che è all'indice 99 perché l'indicizzazione inizia da zero), ma il vettore ha solo tre elementi. In questa situazione, Rust genererà un panic. Utilizzare `[]` dovrebbe restituire un elemento, ma se passi un indice non valido, non c'è nessun elemento che Rust potrebbe restituire qui che sarebbe corretto.

In C, tentare di leggere oltre la fine di una struttura dati è comportamento indefinito. Potresti ottenere qualunque cosa si trovi nella posizione di memoria che corrisponderebbe a quell'elemento nella struttura dati, anche se la memoria non appartiene a quella struttura. Questo è chiamato *buffer overread* e può portare a vulnerabilità di sicurezza se un attaccante è in grado di manipolare l'indice in modo da leggere dati che non dovrebbero essere consentiti, memorizzati dopo la struttura dati.

Per proteggere il tuo programma da questo tipo di vulnerabilità, se tenti di leggere un elemento a un indice che non esiste, Rust interromperà l'esecuzione e rifiuterà di continuare. Proviamo e vediamo:

```console
{{#include ../listings/ch09-error-handling/listing-09-01/output.txt}}
```

Questo errore indica la linea 4 del nostro *main.rs* dove tentiamo di accedere all'indice `99` del vettore in `v`.

La linea `note:` ci dice che possiamo impostare la variabile d'ambiente `RUST_BACKTRACE` per ottenere un backtrace di ciò che è successo esattamente per causare l'errore. Un *backtrace* è una lista di tutte le funzioni che sono state chiamate fino a questo punto. I backtrace in Rust funzionano come in altri linguaggi: la chiave per leggere il backtrace è iniziare dalla cima e leggere finché non vedi i file che hai scritto. Quello è il punto in cui ha avuto origine il problema. Le linee sopra quel punto sono il codice che il tuo codice ha chiamato; le linee sotto sono il codice che ha chiamato il tuo codice. Queste linee prima e dopo potrebbero includere codice core di Rust, codice della libreria standard, o crates che stai utilizzando. Proviamo a ottenere un backtrace impostando la variabile d'ambiente `RUST_BACKTRACE` a qualsiasi valore tranne `0`. Il Listato 9-2 mostra un output simile a quello che vedrai.

<!-- manual-regeneration
cd listings/ch09-error-handling/listing-09-01
RUST_BACKTRACE=1 cargo run
copy the backtrace output below
check the backtrace number mentioned in the text below the listing
-->

```console
$ RUST_BACKTRACE=1 cargo run
thread 'main' panicked at src/main.rs:4:6:
index out of bounds: the len is 3 but the index is 99
stack backtrace:
   0: rust_begin_unwind
             at /rustc/07dca489ac2d933c78d3c5158e3f43beefeb02ce/library/std/src/panicking.rs:645:5
   1: core::panicking::panic_fmt
             at /rustc/07dca489ac2d933c78d3c5158e3f43beefeb02ce/library/core/src/panicking.rs:72:14
   2: core::panicking::panic_bounds_check
             at /rustc/07dca489ac2d933c78d3c5158e3f43beefeb02ce/library/core/src/panicking.rs:208:5
   3: <usize as core::slice::index::SliceIndex<[T]>>::index
             at /rustc/07dca489ac2d933c78d3c5158e3f43beefeb02ce/library/core/src/slice/index.rs:255:10
   4: core::slice::index::<impl core::ops::index::Index<I> for [T]>::index
             at /rustc/07dca489ac2d933c78d3c5158e3f43beefeb02ce/library/core/src/slice/index.rs:18:9
   5: <alloc::vec::Vec<T,A> as core::ops::index::Index<I>>::index
             at /rustc/07dca489ac2d933c78d3c5158e3f43beefeb02ce/library/alloc/src/vec/mod.rs:2770:9
   6: panic::main
             at ./src/main.rs:4:6
   7: core::ops::function::FnOnce::call_once
             at /rustc/07dca489ac2d933c78d3c5158e3f43beefeb02ce/library/core/src/ops/function.rs:250:5
note: Some details are omitted, run with `RUST_BACKTRACE=full` for a verbose backtrace.
```

<span class="caption">Listato 9-2: Il backtrace generato da una chiamata a
`panic!` visualizzato quando la variabile d'ambiente `RUST_BACKTRACE` è impostata</span>

È un sacco di output! L'output esatto che vedi potrebbe essere diverso a seconda del tuo sistema operativo e della versione di Rust. Per ottenere backtrace con queste informazioni, i simboli di debug devono essere abilitati. I simboli di debug sono abilitati di default quando si usa `cargo build` o `cargo run` senza il flag `--release`, come abbiamo fatto qui.

Nell'output del Listato 9-2, la linea 6 del backtrace punta alla linea del nostro progetto che sta causando il problema: linea 4 di *src/main.rs*. Se non vogliamo che il nostro programma vada in panic, dovremmo iniziare la nostra indagine nella posizione indicata dalla prima linea che menziona un file che abbiamo scritto. Nel Listato 9-1, in cui abbiamo deliberatamente scritto codice che avrebbe causato un panic, il modo per risolvere il panic è non richiedere un elemento oltre l'intervallo degli indici del vettore. Quando il tuo codice causerà un panic in futuro, dovrai capire quale azione il codice sta eseguendo con quali valori per causare il panic e cosa dovrebbe fare il codice invece.

Torneremo su `panic!` e su quando dovremmo e non dovremmo usare `panic!` per gestire condizioni di errore nella sezione [“A `panic!` o non a `panic!`”][to-panic-or-not-to-panic]<!-- ignore --> più avanti in questo capitolo. Successivamente, vedremo come recuperare da un errore usando `Result`.

[to-panic-or-not-to-panic]:
ch09-03-to-panic-or-not-to-panic.html#to-panic-or-not-to-panic

