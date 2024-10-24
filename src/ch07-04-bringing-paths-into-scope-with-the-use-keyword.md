## Importare Percorsi nello Scope con la parola chiave `use`

Dover scrivere i percorsi per chiamare le funzioni può sembrare scomodo e
ripetitivo. Nel Listing 7-7, sia che scegliessimo il percorso assoluto o relativo per
la funzione `add_to_waitlist`, ogni volta che volevamo chiamare `add_to_waitlist`
dovevamo specificare anche `front_of_house` e `hosting`. Fortunatamente, c'è un
modo per semplificare questo processo: possiamo creare un collegamento rapido a un percorso con la parola chiave `use` una volta, e poi usare il nome più breve ovunque nello scope.

Nel Listing 7-11, importiamo il modulo `crate::front_of_house::hosting` nello
scope della funzione `eat_at_restaurant` così dobbiamo solo specificare
`hosting::add_to_waitlist` per chiamare la funzione `add_to_waitlist` in
`eat_at_restaurant`.

<span class="filename">Nome del file: src/lib.rs</span>

```rust,noplayground,test_harness
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-11/src/lib.rs}}
```

<span class="caption">Listing 7-11: Importare un modulo nello scope con
`use`</span>

Aggiungere `use` e un percorso in uno scope è simile a creare un collegamento simbolico nel
filesystem. Aggiungendo `use crate::front_of_house::hosting` nel crate
root, `hosting` è ora un nome valido in quello scope, come se il modulo `hosting`
fosse stato definito nel crate root. I percorsi importati nello scope con `use`
controllano anche la privacy, come qualsiasi altro percorso.

Nota che `use` crea solo il collegamento rapido per lo specifico scope in cui si
trova. Il Listing 7-12 sposta la funzione `eat_at_restaurant` in un nuovo
modulo figlio chiamato `customer`, che è quindi un diverso scope rispetto alla dichiarazione `use`,
quindi il Blocco della funzione non verrà compilato.

<span class="filename">Nome del file: src/lib.rs</span>

```rust,noplayground,test_harness,does_not_compile,ignore
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-12/src/lib.rs}}
```

<span class="caption">Listing 7-12: Una dichiarazione `use` si applica solo nello scope in cui si trova</span>

Il messaggio di errore del compilatore mostra che il collegamento rapido non si applica più all'interno del modulo `customer`:

```console
{{#include ../listings/ch07-managing-growing-projects/listing-07-12/output.txt}}
```

Nota che c'è anche un avviso che l'`use` non è più utilizzato nel suo scope! Per
risolvere questo problema, sposta l'`use` anche all'interno del modulo `customer`, o riferisci il collegamento rapido nel modulo genitore con `super::hosting` all'interno del modulo figlio `customer`.

### Creare Percorsi `use` Idiomatici

Nel Listing 7-11, potresti esserti chiesto perché abbiamo specificato `use
crate::front_of_house::hosting` e poi abbiamo chiamato `hosting::add_to_waitlist` in
`eat_at_restaurant`, piuttosto che specificare il percorso `use` fino alla
funzione `add_to_waitlist` per ottenere lo stesso risultato, come nel Listing 7-13.

<span class="filename">Nome del file: src/lib.rs</span>

```rust,noplayground,test_harness
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-13/src/lib.rs}}
```

<span class="caption">Listing 7-13: Importare la funzione `add_to_waitlist` nello scope con `use`, che è non idiomatico</span>

Sebbene entrambi i Listing 7-11 e 7-13 svolgano lo stesso compito, il Listing 7-11 è il modo idiomatico di importare una funzione nello scope con `use`. Importare il modulo genitore della funzione nello scope con `use` significa che dobbiamo specificare il modulo genitore quando chiamiamo la funzione. Specificare il modulo genitore quando chiamiamo la funzione rende chiaro che la funzione non è definita localmente, riducendo al minimo la ripetizione del percorso completo. Il codice nel Listing 7-13 non è chiaro sulla definizione di `add_to_waitlist`.

D'altra parte, quando si importano structs, enums e altri elementi con `use`,
è idiomatico specificare il percorso completo. Il Listing 7-14 mostra il modo idiomatico di importare lo struct `HashMap` della libreria standard nello scope di un crate binario.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-14/src/main.rs}}
```

<span class="caption">Listing 7-14: Importare `HashMap` nello scope in modo idiomatico</span>

Non ci sono forti motivi dietro questa convenzione: è solo la convenzione che è
emersa, e la gente è abituata a leggere e scrivere codice Rust in questo modo.

L'eccezione a questa convenzione è quando portiamo nello scope due elementi con lo stesso nome usando dichiarazioni `use`, perché Rust non lo consente. Il Listing 7-15 mostra come importare nello scope due tipi `Result` con lo stesso nome ma moduli genitori differenti, e come riferirsi a essi.

<span class="filename">Nome del file: src/lib.rs</span>

```rust,noplayground
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-15/src/lib.rs:here}}
```

<span class="caption">Listing 7-15: Importare nello stesso scope due tipi con lo stesso nome richiede l'uso dei loro moduli genitori.</span>

Come puoi vedere, usare i moduli genitori distingue i due tipi `Result`.
Se invece avessimo specificato `use std::fmt::Result` e `use std::io::Result`, avremmo due tipi `Result` nello stesso scope, e Rust non saprebbe quale intendevamo quando usiamo `Result`.

### Fornire Nuovi Nomi con la parola chiave `as`

C'è un'altra soluzione al problema di importare nello stesso scope due tipi con lo stesso nome usando `use`: dopo il percorso, possiamo specificare `as` e un nuovo nome locale, o *alias*, per il tipo. Il Listing 7-16 mostra un altro modo di scrivere il codice nel Listing 7-15 rinominando uno dei due tipi `Result` con `as`.

<span class="filename">Nome del file: src/lib.rs</span>

```rust,noplayground
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-16/src/lib.rs:here}}
```

<span class="caption">Listing 7-16: Rinominare un tipo quando viene importato nello scope con la parola chiave `as`</span>

Nella seconda dichiarazione `use`, abbiamo scelto il nuovo nome `IoResult` per il
tipo `std::io::Result`, che non confliggerà con il `Result` da `std::fmt`
che abbiamo già importato nello scope. Sia il Listing 7-15 che il Listing 7-16 sono
considerati idiomatici, quindi la scelta sta a te!

### Riesportare Nomi con `pub use`

Quando importiamo un nome nello scope con la parola chiave `use`, il nome disponibile nel nuovo scope è privato. Per permettere al codice che chiama il nostro codice di riferirsi a quel nome come se fosse stato definito nello scope di quel codice, possiamo combinare `pub` e `use`. Questa tecnica si chiama *riesportazione* perché stiamo importando un elemento nello scope ma lo rendiamo anche disponibile affinché altri possano importarlo nel loro scope.

Il Listing 7-17 mostra il codice nel Listing 7-11 con `use` nel modulo root
cambiato in `pub use`.

<span class="filename">Nome del file: src/lib.rs</span>

```rust,noplayground,test_harness
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-17/src/lib.rs}}
```

<span class="caption">Listing 7-17: Rendere un nome disponibile per qualsiasi codice da usare
da un nuovo scope con `pub use`</span>

Prima di questo cambiamento, il codice esterno avrebbe dovuto chiamare la funzione `add_to_waitlist`
usando il percorso `restaurant::front_of_house::hosting::add_to_waitlist()`, che avrebbe anche richiesto che il modulo `front_of_house` fosse segnato come `pub`. Ora che questo `pub use` ha riesportato il modulo `hosting` dal modulo root, il codice esterno può usare il percorso `restaurant::hosting::add_to_waitlist()` invece.

La riesportazione è utile quando la struttura interna del tuo codice è diversa da come i programmatori che chiamano il tuo codice penserebbero al dominio. Per esempio, in questa metafora del ristorante, le persone che gestiscono il ristorante pensano a "front of house" e "back of house". Ma i clienti che visitano un ristorante probabilmente non penseranno alle parti del ristorante in quei termini. Con `pub use`, possiamo scrivere il nostro codice con una struttura e esporne un’altra. Così facendo, la nostra libreria è ben organizzata per i programmatori che lavorano alla libreria e per i programmatori che la utilizzano. Vedremo un altro esempio di `pub use` e come influisce sulla documentazione del tuo crate nella sezione [“Esportare una Comoda API Pubblica con `pub use`”][ch14-pub-use] del Capitolo 14.

### Usare Pacchetti Esterni

Nel Capitolo 2, abbiamo programmato un progetto di gioco di indovinelli che utilizzava un pacchetto esterno chiamato `rand` per ottenere numeri casuali. Per usare `rand` nel nostro progetto, abbiamo aggiunto questa riga a *Cargo.toml*:

<span class="filename">Nome del file: Cargo.toml</span>

```toml
{{#include ../listings/ch02-guessing-game-tutorial/listing-02-02/Cargo.toml:9:}}
```

Aggiungere `rand` come dipendenza in *Cargo.toml* dice a Cargo di scaricare il
pacchetto `rand` e qualsiasi dipendenza da [crates.io](https://crates.io/) e
rendere `rand` disponibile per il nostro progetto.

Poi, per importare le definizioni di `rand` nello scope del nostro pacchetto, abbiamo aggiunto una riga `use` iniziante con il nome del crate, `rand`, ed elencato gli elementi
che volevamo importare nello scope. Ricorda che nella sezione [“Generazione di un Numero Casuale”][rand] nel Capitolo 2, abbiamo importato il trait `Rng` nello scope e chiamato la funzione `rand::thread_rng`:

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-03/src/main.rs:ch07-04}}
```

I membri della comunità Rust hanno reso disponibili molti pacchetti su
[crates.io](https://crates.io/), e includerne uno nel tuo pacchetto
comporta questi stessi passaggi: elencarli nel file *Cargo.toml* del tuo pacchetto e
usare `use` per importare elementi dai loro crates nello scope.

Nota che la libreria standard `std` è anche un crate che è esterno al nostro
pacchetto. Poiché la libreria standard è fornita con il linguaggio Rust, non
abbiamo bisogno di cambiare *Cargo.toml* per includere `std`. Ma dobbiamo
riferirci ad essa con `use` per importare elementi da lì nello scope del nostro
pacchetto. Per esempio, con `HashMap` useremmo questa riga:

```rust
use std::collections::HashMap;
```

Questo è un percorso assoluto che inizia con `std`, il nome del crate della libreria standard.

### Usare Percorsi Annidati per Pulire Grandi Liste `use`

Se stiamo usando più elementi definiti nello stesso crate o nello stesso modulo, elencare ciascun elemento su una propria riga può occupare molto spazio verticale nei nostri file. Per esempio, queste due dichiarazioni `use` che avevamo nel gioco di indovinelli nel Listing 2-4 importano elementi da `std` nello scope:

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch07-managing-growing-projects/no-listing-01-use-std-unnested/src/main.rs:here}}
```

Invece, possiamo usare percorsi annidati per importare gli stessi elementi nello scope in una
linea. Possiamo fare ciò specificando la parte comune del percorso, seguita da due
due punti, e poi parentesi graffe attorno a un elenco delle parti dei percorsi che
differiscono, come mostrato nel Listing 7-18.

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-18/src/main.rs:here}}
```

<span class="caption">Listing 7-18: Specificare un percorso annidato per importare più elementi con lo stesso prefisso nello scope</span>

In programmi più grandi, importare molti elementi nello scope dallo stesso crate o
modulo usando percorsi annidati può ridurre il numero di dichiarazioni `use` separate
necessarie di molto!

Possiamo usare un percorso annidato a qualsiasi livello di un percorso, il che è utile
quando si combinano due dichiarazioni `use` che condividono un sotto-percorso. Per esempio, il Listing 7-19 mostra due dichiarazioni `use`: una che importa `std::io` nello scope e una che importa `std::io::Write` nello scope.

<span class="filename">Nome del file: src/lib.rs</span>

```rust,noplayground
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-19/src/lib.rs}}
```

<span class="caption">Listing 7-19: Due dichiarazioni `use` dove uno è un sotto-percorso
dell'altro</span>

La parte comune di questi due percorsi è `std::io`, e questo è il
percorso completo del primo. Per unire questi due percorsi in una sola
dichiarazione `use`, possiamo usare `self` nel percorso annidato, come mostrato nel Listing 7-20.

<span class="filename">Nome del file: src/lib.rs</span>

```rust,noplayground
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-20/src/lib.rs}}
```

<span class="caption">Listing 7-20: Combinare i percorsi nel Listing 7-19 in una
dichiarazione `use`</span>

Questa riga importa `std::io` e `std::io::Write` nello scope.

### Il Glob Operator

Se vogliamo importare *tutti* gli elementi pubblici definiti in un percorso nello scope, possiamo
specificare quel percorso seguito dall'operatore `*` glob:

```rust
use std::collections::*;
```

Questa dichiarazione `use` importa tutti gli elementi pubblici definiti in `std::collections` nello
scope corrente. Attenzione quando si utilizza l'operatore glob! Glob può rendere più difficile capire
quali nomi sono nello scope e dove un nome usato nel tuo programma è stato definito.

L'operatore glob è spesso usato quando si testano per portare tutto sotto test
nel modulo `tests`; ne parleremo nella sezione [“Come Scrivere Test”][writing-tests] nel
Capitolo 11. L'operatore glob è anche a volte usato come parte del pattern prelude: vedi
[la documentazione della libreria standard](../std/prelude/index.html#other-preludes) per maggiori
informazioni su quel pattern.

[ch14-pub-use]: ch14-02-publishing-to-crates-io.html#exporting-a-convenient-public-api-with-pub-use
[rand]: ch02-00-guessing-game-tutorial.html#generating-a-random-number
[writing-tests]: ch11-01-writing-tests.html#how-to-write-tests
