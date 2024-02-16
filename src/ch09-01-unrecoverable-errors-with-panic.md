## Errori Irrecuperabili con `panic!`

A volte, succedono cose brutte nel tuo codice, e non c'è nulla che tu possa fare al
riguardo. In questi casi, Rust dispone della macro `panic!`. Ci sono due modi per causare un
panico in pratica: compiendo un'azione che causa un panico nel nostro codice (come
per esempio, accedendo ad un array oltre la sua estremità) o chiamando esplicitamente la macro `panic!`.
In entrambi i casi, causiamo un panico nel nostro programma. Di default, questi panici
stamperranno un messaggio d'errore, si disimballeranno, puliranno lo stack, e chiuderanno. Tramite una
variabile d'ambiente, è possibile anche far visualizzare a Rust lo stack delle chiamate quando si verifica un
panico per facilitare l'individuazione della fonte del panico.

> ### Disimballaggio dello Stack o Interruzione in Risposta a un Panico
>
> Di default, quando si verifica un panico, il programma inizia a *disimballarsi*, il che
> significa che Rust risale lo stack e pulisce i dati di ciascuna funzione
> che incontra. Tuttavia, questo risalire e pulire richiede molto lavoro. Quindi, Rust,
> ti permette di scegliere l'alternativa di *interrompere* immediatamente,
> terminando il programma senza pulire.
>
> I dati che il programma stava utilizzando dovranno poi essere puliti
> dal sistema operativo. Se nel tuo progetto hai bisogno di rendere il binario risultante
> il più piccolo possibile, puoi passare dal disimballaggio all'interruzione in caso di
> panico aggiungendo `panic = 'abort'` alla sezione `[profile]` appropriata nel tuo
> file *Cargo.toml*. Ad esempio, se vuoi interrompere al verificarsi di un panico in modalità rilascio, aggiungi questo:
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

La chiamata a `panic!` causa il messaggio di errore contenuto nelle ultime due righe.
La prima riga mostra il nostro messaggio di panico e il posto nel nostro codice sorgente dove
è avvenuto il panico: *src/main.rs:2:5* indica che è la seconda riga,
quinto carattere del nostro file *src/main.rs*.

In questo caso, la riga indicata fa parte del nostro codice, e se andiamo a quella
riga, vediamo la chiamata alla macro `panic!`. In altri casi, la chiamata a `panic!`
potrebbe essere nel codice che il nostro codice richiama, e il nome del file e il numero della riga riportati dal
messaggio di errore saranno il codice di qualcun altro dove viene chiamata la macro `panic!`,
non la riga del nostro codice che ha portato alla chiamata a `panic!`. Possiamo
utilizzare la backtrace delle funzioni da cui proviene la chiamata a `panic!` per capire
quale parte del nostro codice sta causando il problema. Discuteremo le backtrace
in più dettaglio in seguito.

### Utilizzo di una Backtrace di `panic!`

Diamo un'occhiata ad un altro esempio per vedere com'è quando una chiamata a `panic!` proviene
da una libreria a causa di un bug nel nostro codice invece che dal nostro codice che chiama
la macro direttamente. L'Esempio 9-1 ha del codice che tenta di accedere ad un
indice in un vettore oltre l'intervallo degli indici validi.

<span class="filename">Nome del file: src/main.rs</span>

```rust,should_panic,panics
{{#rustdoc_include ../listings/ch09-error-handling/listing-09-01/src/main.rs}}
```

<span class="caption">Esempio 9-1: Tentativo di accedere ad un elemento oltre la
fine di un vettore, che causerà una chiamata a `panic!`</span>

Qui, stiamo tentando di accedere al 100esimo elemento del nostro vettore (che si trova
all'indice 99 perché l'indicizzazione inizia da zero), ma il vettore ha solo 3 elementi.
In questa situazione, Rust andrà in panico. Utilizzare `[]` dovrebbe restituire un
elemento, ma se passi un indice non valido, non c'è alcun elemento che Rust potrebbe
restituire qui che sarebbe corretto.

In C, tentare di leggere oltre la fine di una struttura dati è un comportamento indefinito.
Potresti ottenere quello che c'è nella posizione di memoria che dovrebbe
corrispondere a quell'elemento nella struttura dati, anche se la memoria
non appartiene a quella struttura. Questo è chiamato un *buffer overread* e può
portare a vulnerabilità di sicurezza se un attaccante è in grado di manipolare l'indice
in modo tale da leggere dati a cui non dovrebbe avere accesso e che sono memorizzati dopo
la struttura dati.

Per proteggere il tuo programma da questo tipo di vulnerabilità, se provi a leggere un
elemento ad un indice che non esiste, Rust interromperà l'esecuzione e rifiuterà di
continuare. Proviamolo e vediamo:

```console
{{#include ../listings/ch09-error-handling/listing-09-01/output.txt}}
```

Questo errore punta alla riga 4 del nostro `main.rs` dove tentiamo di accedere all'indice
99. La riga successiva ci dice che possiamo impostare la variabile d'ambiente `RUST_BACKTRACE`
per ottenere una backtrace di esattamente cosa è successo a causare l'errore. Una *backtrace* è una lista di tutte le funzioni che sono state chiamate per arrivare a questo punto. Le backtrace in Rust funzionano come in altri linguaggi: 
la chiave per leggere la backtrace è iniziare dall'alto e leggere fino a quando non vedi
file che hai scritto. Questo è il punto in cui il problema ha avuto origine. Le righe sopra
quella posizione sono codice che il tuo codice ha chiamato; le righe sotto sono codice che
ha chiamato il tuo codice. Queste righe prima e dopo potrebbero includere codice base di Rust,
codice della libreria standard, o crate che stai utilizzando. Proviamo ad ottenere una
backtrace impostando la variabile d'ambiente `RUST_BACKTRACE` a qualsiasi valore
tranne 0. L'Esempio 9-2 mostra un output simile a quello che vedrai.

<!-- manual-regeneration
cd listings/ch09-error-handling/listing-09-01
RUST_BACKTRACE=1 cargo run
copia l'output della backtrace qui sotto
controlla il numero della backtrace menzionato nel testo sotto l'elenco
-->
```console
$ RUST_BACKTRACE=1 cargo run
thread 'main' panicked at 'indice fuori dai limiti: la lunghezza è 3 ma l'indice è 99', src/main.rs:4:5
stack backtrace:
   0: rust_begin_unwind
             at /rustc/e092d0b6b43f2de967af0887873151bb1c0b18d3/library/std/src/panicking.rs:584:5
   1: core::panicking::panic_fmt
             at /rustc/e092d0b6b43f2de967af0887873151bb1c0b18d3/library/core/src/panicking.rs:142:14
   2: core::panicking::panic_bounds_check
             at /rustc/e092d0b6b43f2de967af0887873151bb1c0b18d3/library/core/src/panicking.rs:84:5
   3: <usize as core::slice::index::SliceIndex<[T]>>::index
             at /rustc/e092d0b6b43f2de967af0887873151bb1c0b18d3/library/core/src/slice/index.rs:242:10
   4: core::slice::index::<impl core::ops::index::Index<I> for [T]>::index
             at /rustc/e092d0b6b43f2de967af0887873151bb1c0b18d3/library/core/src/slice/index.rs:18:9
   5: <alloc::vec::Vec<T,A> as core::ops::index::Index<I>>::index
             at /rustc/e092d0b6b43f2de967af0887873151bb1c0b18d3/library/alloc/src/vec/mod.rs:2591:9
   6: panic::main
             at ./src/main.rs:4:5
   7: core::ops::function::FnOnce::call_once
             at /rustc/e092d0b6b43f2de967af0887873151bb1c0b18d3/library/core/src/ops/function.rs:248:5
note: Alcuni dettagli sono omessi, esegui con `RUST_BACKTRACE=full` per un backtrace completo.
```

<span class="caption">Listing 9-2: Il backtrace generato da una chiamata a
`panic!` visualizzato quando la variabile di ambiente `RUST_BACKTRACE` è impostata</span>

C'è molto output! L'output esatto che vedi potrebbe essere diverso a seconda del tuo sistema operativo e della versione di Rust. Per ottenere backtraces con queste informazioni, devono essere abilitati i simboli di debug. I simboli di debug sono abilitati di default quando si usa `cargo build` o `cargo run` senza il flag `--release`, come abbiamo qui.

Nell'output nella Listing 9-2, la linea 6 del backtrace punta alla riga nel nostro progetto che sta causando il problema: la linea 4 di *src/main.rs*. Se non vogliamo che il nostro programma vada in panic, dovremmo iniziare la nostra indagine nel punto indicato dalla prima linea che menziona un file che abbiamo scritto. Nella Listing 9-1, dove abbiamo scritto deliberatamente codice che avrebbe causato un panic, il modo per correggere il panic è non richiedere un elemento oltre il range degli indici del vettore. Quando il tuo codice andrà in panic in futuro, dovrai capire quale azione sta intraprendendo il codice con quali valori per causare il panic e cosa dovrebbe fare invece il codice.

Torneremo su `panic!` e su quando dovremmo e non dovremmo usare `panic!` per gestire le condizioni d'errore nella sezione ["Usare `panic!` o non
Usare `panic!`"][usare-panic-o-non-panic]<!-- ignore --> più avanti in questo capitolo. Successivamente, vedremo come recuperare da un errore usando `Result`.

[usare-panic-o-non-panic]:
ch09-03-to-panic-or-not-to-panic.html#usare-panic-o-non-panic

