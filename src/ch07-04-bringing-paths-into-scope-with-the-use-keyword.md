## Portare i Percorsi nello Scope con la Parola Chiave `use`

Scrivere i percorsi per chiamare le funzioni può sembrare scomodo e ripetitivo. Nella Listing 7-7, sia che scegliamo il percorso assoluto o relativo per la funzione `add_to_waitlist`, ogni volta che vogliamo chiamare `add_to_waitlist` dobbiamo specificare anche `front_of_house` e `hosting`. Fortunatamente, c'è un modo per semplificare questo processo: possiamo creare una scorciatoia per un percorso con la parola chiave `use` una volta, e poi usare il nome più corto ovunque nello scope.

Nella Listing 7-11, portiamo il modulo `crate::front_of_house::hosting` nello scope della funzione `eat_at_restaurant` così dobbiamo solo specificare `hosting::add_to_waitlist` per chiamare la funzione `add_to_waitlist` in `eat_at_restaurant`.

<span class="filename">Filename: src/lib.rs</span>

```rust,noplayground,test_harness
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-11/src/lib.rs}}
```

<span class="caption">Listing 7-11: Portare un modulo nello scope con `use`</span>

Aggiungere `use` e un percorso nello scope è simile a creare un collegamento simbolico nel filesystem. Aggiungendo `use crate::front_of_house::hosting` nel crate root, `hosting` è ora un nome valido in quello scope, proprio come se il modulo `hosting` fosse stato definito nel crate root. I percorsi portati nello scope con `use` controllano anche la privacy, come qualsiasi altro percorso.

Nota che `use` crea solo la scorciatoia per lo specifico scope in cui `use` si verifica. La Listing 7-12 sposta la funzione `eat_at_restaurant` in un nuovo modulo figlio chiamato `customer`, che è poi un scope diverso rispetto alla dichiarazione `use`, quindi il corpo della funzione non compila.

<span class="filename">Filename: src/lib.rs</span>

```rust,noplayground,test_harness,does_not_compile,ignore
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-12/src/lib.rs}}
```

<span class="caption">Listing 7-12: Una dichiarazione `use` si applica solo allo scope in cui si trova</span>

L'errore del compilatore mostra che la scorciatoia non si applica più nel modulo `customer`:

```console
{{#include ../listings/ch07-managing-growing-projects/listing-07-12/output.txt}}
```

Nota che c'è anche un avviso che il `use` non è più utilizzato nel suo scope! Per risolvere questo problema, sposta il `use` anche all'interno del modulo `customer`, o riferisciti alla scorciatoia nel modulo padre con `super::hosting` all'interno del modulo figlio `customer`.

### Creare Percorsi `use` Idiomatici

Nella Listing 7-11, potresti esserti chiesto perché abbiamo specificato `use crate::front_of_house::hosting` e poi chiamato `hosting::add_to_waitlist` in `eat_at_restaurant`, piuttosto che specificare il percorso `use` fino alla funzione `add_to_waitlist` per ottenere lo stesso risultato, come nella Listing 7-13.

<span class="filename">Filename: src/lib.rs</span>

```rust,noplayground,test_harness
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-13/src/lib.rs}}
```

<span class="caption">Listing 7-13: Portare la funzione `add_to_waitlist` nello scope con `use`, che non è idiomatico</span>

Anche se sia la Listing 7-11 che la Listing 7-13 raggiungono lo stesso compito, la Listing 7-11 è il modo idiomatico di portare una funzione nello scope con `use`. Portare il modulo genitore della funzione nello scope con `use` significa che dobbiamo specificare il modulo genitore quando chiamiamo la funzione. Specificare il modulo genitore quando chiamiamo la funzione rende chiaro che la funzione non è definita localmente pur minimizzando la ripetizione del percorso completo. Il codice nella Listing 7-13 non è chiaro su dove sia definita `add_to_waitlist`.

D'altra parte, quando si portano negli scope struct, enum, e altri elementi con `use`, è idiomatico specificare il percorso completo. La Listing 7-14 mostra il modo idiomatico di portare lo struct `HashMap` della libreria standard nello scope di un crate binario.

<span class="filename">Filename: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-14/src/main.rs}}
```

<span class="caption">Listing 7-14: Portare `HashMap` nello scope in modo idiomatico</span>

Non c'è una forte ragione dietro questo idioma: è solo la convenzione che è emersa, e la gente è abituata a leggere e scrivere codice Rust in questo modo.

L'eccezione a questo idioma è se stiamo portando due elementi con lo stesso nome nello scope con dichiarazioni `use`, perché Rust non lo permette. La Listing 7-15 mostra come portare due tipi `Result` nello scope che hanno lo stesso nome ma moduli genitori diversi, e come riferirsi a loro.

<span class="filename">Filename: src/lib.rs</span>

```rust,noplayground
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-15/src/lib.rs:here}}
```

<span class="caption">Listing 7-15: Portare due tipi con lo stesso nome nello stesso scope richiede l'uso dei loro moduli genitori.</span>

Come puoi vedere, usare i moduli genitori distingue i due tipi `Result`. Se invece specificassimo `use std::fmt::Result` e `use std::io::Result`, avremmo due tipi `Result` nello stesso scope, e Rust non saprebbe a quale ci riferiamo quando usiamo `Result`.

### Fornire Nuovi Nomi con la Parola Chiave `as`

C'è un'altra soluzione al problema di portare due tipi con lo stesso nome nello stesso scope con `use`: dopo il percorso, possiamo specificare `as` e un nuovo nome locale, o *alias*, per il tipo. La Listing 7-16 mostra un altro modo di scrivere il codice nella Listing 7-15 rinominando uno dei due tipi `Result` usando `as`.

<span class="filename">Filename: src/lib.rs</span>

```rust,noplayground
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-16/src/lib.rs:here}}
```

<span class="caption">Listing 7-16: Rinominare un tipo quando viene portato nello scope con la parola chiave `as`</span>

Nella seconda dichiarazione `use`, abbiamo scelto il nuovo nome `IoResult` per il tipo `std::io::Result`, che non confliggerà con il `Result` da `std::fmt` che abbiamo anche portato nello scope. La Listing 7-15 e la Listing 7-16 sono considerate idiomatiche, quindi la scelta è tua!

### Riesportare Nomi con `pub use`

Quando portiamo un nome nello scope con la parola chiave `use`, il nome disponibile nel nuovo scope è privato. Per permettere al codice che chiama il nostro codice di riferirsi a quel nome come se fosse stato definito nello scope del codice chiamante, possiamo combinare `pub` e `use`. Questa tecnica si chiama *riesportazione* perché stiamo portando un elemento nello scope ma rendendolo anche disponibile per essere portato nello scope di altri.

La Listing 7-17 mostra il codice nella Listing 7-11 con la dichiarazione `use` nel modulo root cambiata in `pub use`.

<span class="filename">Filename: src/lib.rs</span>

```rust,noplayground,test_harness
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-17/src/lib.rs}}
```

<span class="caption">Listing 7-17: Rendere un nome disponibile per qualsiasi codice da usare da un nuovo scope con `pub use`</span>

Prima di questa modifica, il codice esterno avrebbe dovuto chiamare la funzione `add_to_waitlist` usando il percorso `restaurant::front_of_house::hosting::add_to_waitlist()`, che avrebbe anche richiesto che il modulo `front_of_house` fosse contrassegnato come `pub`. Ora che questo `pub use` ha riesportato il modulo `hosting` dal modulo root, il codice esterno può usare il percorso `restaurant::hosting::add_to_waitlist()` invece.

La riesportazione è utile quando la struttura interna del tuo codice è diversa da come i programmatori che chiamano il tuo codice penserebbero al dominio. Ad esempio, in questa metafora del ristorante, le persone che gestiscono il ristorante pensano a "front of house" e "back of house". Ma i clienti che visitano un ristorante probabilmente non pensano alle parti del ristorante in questi termini. Con `pub use`, possiamo scrivere il nostro codice con una struttura ma esporne un'altra. Farlo rende la nostra libreria ben organizzata per i programmatori che lavorano sulla libreria e per quelli che chiamano la libreria. Guarderemo un altro esempio di `pub use` e come influisce sulla documentazione del tuo crate nella sezione [“Esportare una API Pubblica Conveniente con `pub use`”][ch14-pub-use]<!-- ignore --> del Capitolo 14.

### Usare Pacchetti Esterni

Nel Capitolo 2, abbiamo programmato un progetto di gioco d'azzardo che usava un pacchetto esterno chiamato `rand` per ottenere numeri casuali. Per usare `rand` nel nostro progetto, abbiamo aggiunto questa linea a *Cargo.toml*:

<!-- Quando aggiorni la versione di `rand` usata, aggiorna anche la versione di `rand` usata in questi file così corrispondono tutte:
* ch02-00-guessing-game-tutorial.md
* ch14-03-cargo-workspaces.md
-->

<span class="filename">Filename: Cargo.toml</span>

```toml
{{#include ../listings/ch02-guessing-game-tutorial/listing-02-02/Cargo.toml:9:}}
```

Aggiungere `rand` come dipendenza in *Cargo.toml* dice a Cargo di scaricare il pacchetto `rand` e tutte le dipendenze da [crates.io](https://crates.io/) e rendere `rand` disponibile per il nostro progetto.

Poi, per portare le definizioni di `rand` nello scope del nostro pacchetto, abbiamo aggiunto una linea `use` che inizia con il nome del crate, `rand`, e abbiamo elencato gli elementi che volevamo portare nello scope. Ricorda che nella sezione [“Generare un Numero Casuale”][rand]<!-- ignore --> nel Capitolo 2, abbiamo portato nello scope il `Rng` trait e chiamato la funzione `rand::thread_rng`:

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-03/src/main.rs:ch07-04}}
```

I membri della comunità Rust hanno reso disponibili molti pacchetti su [crates.io](https://crates.io/), e portarli nel tuo pacchetto comporta questi stessi passaggi: elencarli nel file *Cargo.toml* del tuo pacchetto e usare `use` per portare gli elementi dai loro crate nello scope.

Nota che la libreria standard `std` è anche un crate esterno al nostro pacchetto. Poiché la libreria standard viene fornita con il linguaggio Rust, non dobbiamo modificare *Cargo.toml* per includere `std`. Ma dobbiamo riferirci a essa con `use` per portare elementi da lì nello scope del nostro pacchetto. Ad esempio, con `HashMap` useremmo questa linea:

```rust
use std::collections::HashMap;
```

Questo è un percorso assoluto che inizia con `std`, il nome del crate della libreria standard.

### Usare Percorsi Annidati per Ripulire Lunghe Liste `use`

Se stiamo usando più elementi definiti nello stesso crate o nello stesso modulo, elencare ogni elemento su una propria linea può occupare molto spazio verticale nei nostri file. Ad esempio, queste due dichiarazioni `use` che avevamo nel gioco d'azzardo nella Listing 2-4 portano elementi da `std` nello scope:

<span class="filename">Filename: src/main.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch07-managing-growing-projects/no-listing-01-use-std-unnested/src/main.rs:here}}
```

Invece, possiamo usare percorsi annidati per portare gli stessi elementi nello scope in una sola linea. Facciamo questo specificando la parte comune del percorso, seguita da due punti doppi, e poi parentesi graffe attorno a un elenco delle parti dei percorsi che differiscono, come mostrato nella Listing 7-18.

<span class="filename">Filename: src/main.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-18/src/main.rs:here}}
```

<span class="caption">Listing 7-18: Specificare un percorso annidato per portare più elementi con lo stesso prefisso nello scope</span>

Nei programmi più grandi, portare molti elementi nello scope dallo stesso crate o modulo usando percorsi annidati può ridurre di molto il numero di dichiarazioni `use` separate necessarie!

Possiamo usare un percorso annidato a qualsiasi livello in un percorso, che è utile quando si combinano due dichiarazioni `use` che condividono un sotto-percorso. Ad esempio, la Listing 7-19 mostra due dichiarazioni `use`: una che porta `std::io` nello scope e una che porta `std::io::Write` nello scope.

<span class="filename">Filename: src/lib.rs</span>

```rust,noplayground
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-19/src/lib.rs}}
```

<span class="caption">Listing 7-19: Due dichiarazioni `use` dove una è un sotto-percorso dell'altra</span>

La parte comune di questi due percorsi è `std::io`, ed è il percorso completo. Per unire questi due percorsi in una dichiarazione `use`, possiamo usare `self` nel percorso annidato, come mostrato nella Listing 7-20.

<span class="filename">Filename: src/lib.rs</span>

```rust,noplayground
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-20/src/lib.rs}}
```

<span class="caption">Listing 7-20: Combinare i percorsi nella Listing 7-19 in una dichiarazione `use`</span>

Questa linea porta `std::io` e `std::io::Write` nello scope.

### L'Operatore Glob

Se vogliamo portare *tutti* gli elementi pubblici definiti in un percorso nello scope, possiamo specificare quel percorso seguito dall'operatore glob `*`:

```rust
use std::collections::*;
```

Questa dichiarazione `use` porta tutti gli elementi pubblici definiti in `std::collections` nello scope corrente. Fai attenzione quando usi l'operatore glob! Glob può rendere più difficile capire quali nomi sono nello scope e dove è stato definito un nome usato nel tuo programma.

L'operatore glob è spesso usato quando si scrivono test per portare tutto ciò che si trova sotto test nel modulo `tests`; ne parleremo nella sezione [“Come Scrivere Test”][writing-tests]<!-- ignore --> nel Capitolo 11. L'operatore glob è talvolta usato anche come parte del pattern prelude: vedi [la documentazione della libreria standard](../std/prelude/index.html#other-preludes)<!-- ignore --> per ulteriori informazioni su questo pattern.

[ch14-pub-use]: ch14-02-publishing-to-crates-io.html#exporting-a-convenient-public-api-with-pub-use
[rand]: ch02-00-guessing-game-tutorial.html#generating-a-random-number
[writing-tests]: ch11-01-writing-tests.html#how-to-write-tests

