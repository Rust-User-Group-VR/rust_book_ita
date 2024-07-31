## Errori irreversibili con `panic!`

A volte succedono cose brutte nel tuo codice, e non c'è nulla che tu possa fare a riguardo. In questi casi, Rust ha la macro `panic!`. Ci sono due modi per causare un panic in pratica: compiendo un'azione che causa il panic del nostro codice (come accedere a un array oltre la fine) o chiamando esplicitamente la macro `panic!`. In entrambi i casi, causiamo un panic nel nostro programma. Per impostazione predefinita, questi panic stamperanno un messaggio di errore, faranno il unwind, puliranno lo stack e poi termineranno. Tramite una variabile d'ambiente, puoi anche far visualizzare a Rust lo stack delle chiamate quando si verifica un panic per rendere più facile rintracciare la fonte del panic.

> ### Fare Unwind dello Stack o Abortire in risposta a un Panic
>
> Per impostazione predefinita, quando si verifica un panic, il programma inizia a fare *unwinding*, il che significa che Rust risale lo stack e pulisce i dati di ciascuna funzione che incontra. Tuttavia, risalire e pulire è un lavoro intenso. Pertanto, Rust ti consente di scegliere l'alternativa di *abortire* immediatamente, che termina il programma senza pulire.
>
> La memoria utilizzata dal programma dovrà quindi essere pulita dal sistema operativo. Se nel tuo progetto hai bisogno di ridurre il più possibile la dimensione del binario risultante, puoi passare dall'unwinding all'aborting su un panic aggiungendo `panic = 'abort'` alle sezioni appropriate `[profile]` nel tuo file *Cargo.toml*. Ad esempio, se vuoi abortire su panic in modalità release, aggiungi questo:
>
> ```toml
> [profile.release]
> panic = 'abort'
> ```

Proviamo a chiamare `panic!` in un programma semplice:

<span class="filename">Nome del file: src/main.rs</span>

```rust,should_panic,panics
{{#rustdoc_include ../listings/ch09-error-handling/no-listing-01-panic/src/main.rs}}
```

Quando esegui il programma, vedrai qualcosa di simile a questo:

```console
{{#include ../listings/ch09-error-handling/no-listing-01-panic/output.txt}}
```

La chiamata a `panic!` causa il messaggio di errore contenuto nelle ultime due righe. La prima riga mostra il nostro messaggio di panic e il punto nel nostro codice sorgente dove si è verificato il panic: *src/main.rs:2:5* indica che è la seconda riga, quinto carattere del nostro file *src/main.rs*.

In questo caso, la riga indicata fa parte del nostro codice, e se andiamo a quella riga, vediamo la chiamata alla macro `panic!`. In altri casi, la chiamata a `panic!` potrebbe essere nel codice che il nostro codice chiama, e il nome del file e il numero della riga riportati dal messaggio di errore saranno il codice di qualcun altro dove è stata chiamata la macro `panic!`, non la riga del nostro codice che ha portato infine alla chiamata a `panic!`.

<!-- Old heading. Do not remove or links may break. -->
<a id="using-a-panic-backtrace"></a>

Possiamo utilizzare il backtrace delle funzioni da cui è stata fatta la chiamata a `panic!` per capire la parte del nostro codice che sta causando il problema. Per capire come usare un backtrace di `panic!`, vediamo un altro esempio e capiamo come appare quando una chiamata a `panic!` proviene da una libreria a causa di un bug nel nostro codice anziché dal nostro codice che chiama direttamente la macro. Il Listing 9-1 ha del codice che tenta di accedere a un indice in un vettore oltre il range degli indici validi.

<span class="filename">Nome del file: src/main.rs</span>

```rust,should_panic,panics
{{#rustdoc_include ../listings/ch09-error-handling/listing-09-01/src/main.rs}}
```

<span class="caption">Listing 9-1: Tentativo di accesso a un elemento oltre la fine di un vettore, che causerà una chiamata a `panic!`</span>

Qui stiamo tentando di accedere al 100° elemento del nostro vettore (che è all'indice 99 perché l'indicizzazione inizia da zero), ma il vettore ha solo tre elementi. In questa situazione, Rust farà panic. Utilizzare `[]` dovrebbe restituire un elemento, ma se passi un indice non valido, non c'è nessun elemento che Rust potrebbe restituire correttamente.

In C, tentare di leggere oltre la fine di una struttura dati è un comportamento indefinito. Potresti ottenere ciò che si trova nella posizione di memoria che corrisponderebbe a quell'elemento nella struttura dati, anche se la memoria non appartiene a quella struttura. Questo è chiamato *buffer overread* e può portare a vulnerabilità di sicurezza se un attaccante è in grado di manipolare l'indice in modo da leggere dati a cui non dovrebbe essere consentito di accedere memorizzati dopo la struttura dati.

Per proteggere il tuo programma da questo tipo di vulnerabilità, se tenti di leggere un elemento a un indice che non esiste, Rust fermerà l'esecuzione e rifiuterà di continuare. Proviamolo e vediamo:

```console
{{#include ../listings/ch09-error-handling/listing-09-01/output.txt}}
```

Questo errore punta alla riga 4 del nostro *main.rs* dove tentiamo di accedere all'indice `99` del vettore in `v`.

La riga `note:` ci dice che possiamo impostare la variabile d'ambiente `RUST_BACKTRACE` per ottenere un backtrace di esattamente ciò che è successo per causare l'errore. Un *backtrace* è un elenco di tutte le funzioni che sono state chiamate fino a questo punto. I backtrace in Rust funzionano come in altri linguaggi: la chiave per leggere il backtrace è iniziare dall'alto e leggere fino a vedere i file che hai scritto tu. Quello è il punto in cui è nato il problema. Le righe sopra quel punto sono codice che il tuo codice ha chiamato; le righe sotto sono codice che ha chiamato il tuo codice. Queste righe prima e dopo possono includere codice core di Rust, codice della libreria standard o crates che stai usando. Proviamo a ottenere un backtrace impostando la variabile d'ambiente `RUST_BACKTRACE` a qualsiasi valore eccetto `0`. Il Listing 9-2 mostra un output simile a quello che vedrai.

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
   4: core::slice::index::<impl core::ops::index::Index<I> per [T]>::index
             at /rustc/07dca489ac2d933c78d3c5158e3f43beefeb02ce/library/core/src/slice/index.rs:18:9
   5: <alloc::vec::Vec<T,A> as core::ops::index::Index<I>>::index
             at /rustc/07dca489ac2d933c78d3c5158e3f43beefeb02ce/library/alloc/src/vec/mod.rs:2770:9
   6: panic::main
             at ./src/main.rs:4:6
   7: core::ops::function::FnOnce::call_once
             at /rustc/07dca489ac2d933c78d3c5158e3f43beefeb02ce/library/core/src/ops/function.rs:250:5
note: Some details are omitted, run with `RUST_BACKTRACE=full` for a verbose backtrace.
```

<span class="caption">Listing 9-2: Il backtrace generato da una chiamata a `panic!` visualizzato quando la variabile d'ambiente `RUST_BACKTRACE` è impostata</span>

È un sacco di output! L'output esatto che vedrai potrebbe essere diverso a seconda del sistema operativo e della versione di Rust. Per ottenere backtrace con queste informazioni, devono essere abilitati i simboli di debug. I simboli di debug sono abilitati per impostazione predefinita utilizzando `cargo build` o `cargo run` senza il flag `--release`, come abbiamo fatto qui.

Nell'output nel Listing 9-2, la riga 6 del backtrace punta alla riga nel nostro progetto che sta causando il problema: la riga 4 di *src/main.rs*. Se non vogliamo che il nostro programma faccia panic, dovremmo iniziare la nostra indagine dal punto indicato dalla prima riga che menziona un file che abbiamo scritto noi. Nel Listing 9-1, dove abbiamo deliberatamente scritto codice che farebbe panic, il modo per risolvere il panic è non richiedere un elemento oltre il range degli indici del vettore. Quando il tuo codice farà panic in futuro, dovrai capire quale azione il codice sta intraprendendo con quali valori per causare il panic e cosa dovrebbe fare il codice invece.

Torneremo su `panic!` e quando dovremmo e non dovremmo usare `panic!` per gestire le condizioni di errore nella sezione [“To `panic!` or Not to `panic!`”](ch09-03-to-panic-or-not-to-panic.html#to-panic-or-not-to-panic)<!-- ignore --> più avanti in questo capitolo. Prossimamente, vedremo come recuperare da un errore usando `Result`.

[to-panic-or-not-to-panic]:
ch09-03-to-panic-or-not-to-panic.html#to-panic-or-not-to-panic

