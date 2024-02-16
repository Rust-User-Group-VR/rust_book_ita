## Portare i Percorsi nello Scope con la Keyword `use`

Dover scrivere i percorsi per chiamare le funzioni può sembrare scomodo e
ripetitivo. Nell'Elencazione 7-7, che abbiamo scelto il percorso assoluto o relativo alla
funzione `add_to_waitlist`, ogni volta che volevamo chiamare `add_to_waitlist`
dovevamo specificare anche `front_of_house` e `hosting`. Fortunatamente, c'è un
modo per semplificare questo processo: possiamo creare una scorciatoia per un percorso con la keyword `use`
una volta, e poi usare il nome più corto ovunque nel resto dello scope.

Nell'Elencazione 7-11, portiamo il modulo `crate::front_of_house::hosting` nello
scope della funzione `eat_at_restaurant` così dobbiamo solo specificare
`hosting::add_to_waitlist` per chiamare la funzione `add_to_waitlist` in
`eat_at_restaurant`.

<span class="filename">Nome del file: src/lib.rs</span>

```rust,noplayground,test_harness
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-11/src/lib.rs}}
```

<span class="caption">Elencazione 7-11: Portare un modulo nello scope con
`use`</span>

Aggiungere `use` e un percorso in uno scope è simile a creare un link simbolico nel
filesystem. Aggiungendo `use crate::front_of_house::hosting` nella crate
root, `hosting` è ora un nome valido in quello scope, proprio come se il modulo `hosting`
fosse stato definito nella root della crate. I percorsi portati nello scope con `use`
controllano anche la privacy, come qualsiasi altro percorso.

Da notare che `use` crea la scorciatoia solo per lo scope particolare in cui il
`use` si verifica. L'Elencazione 7-12 sposta la funzione `eat_at_restaurant` in un nuovo
modulo figlio chiamato `customer`, che è quindi uno scope diverso rispetto al `use`
dichiarazione, quindi il corpo della funzione non verrà compilato:

<span class="filename">Nome del file: src/lib.rs</span>

```rust,noplayground,test_harness,does_not_compile,ignore
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-12/src/lib.rs}}
```

<span class="caption">Elencazione 7-12: Una dichiarazione `use` si applica solo nello scope
in cui si trova</span>

L'errore del compilatore mostra che la scorciatoia non si applica più all'interno del
modulo `customer`:

```console
{{#include ../listings/ch07-managing-growing-projects/listing-07-12/output.txt}}
```

Notate che c'è anche un avviso che il `use` non viene più utilizzato nel suo scope! Per
risolvere questo problema, sposta il `use` all'interno del modulo `customer` anch'esso, o fai riferimento
la scorciatoia nel modulo padre con `super::hosting` all'interno del modulo figlio
`customer`.

### Creare Percorsi Idiomatici `use`

Nell'Elencazione 7-11, potreste esservi chiesti perché abbiamo specificato `use
crate::front_of_house::hosting` e poi chiamato `hosting::add_to_waitlist` in
`eat_at_restaurant` piuttosto che specificare il percorso `use` fino alla
la funzione `add_to_waitlist` per ottenere lo stesso risultato, come nell'Elencazione 7-13.

<span class="filename">Nome del file: src/lib.rs</span>

```rust,noplayground,test_harness
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-13/src/lib.rs}}
```

<span class="caption">Elencazione 7-13: Portare la funzione `add_to_waitlist`
nello scope con `use`, che è anti-idiomatico</span>

Sebbene sia l'Elencazione 7-11 che la 7-13 raggiungano lo stesso compito, l'Elencazione 7-11 è
il modo idiomatico per portare una funzione nello scope con `use`. Portare il
modulo padre della funzione nello scope con `use` significa che dobbiamo specificare il
modulo padre quando chiamiamo la funzione. Specificare il modulo padre quando
chiamiamo la funzione rende chiaro che la funzione non è definita localmente
pur minimizando la ripetizione del percorso completo. Il codice nell'Elencazione 7-13 è
poco chiaro su dove sia definito `add_to_waitlist`.

D'altra parte, quando portiamo strutture, enum e altri elementi con `use`,
è idiomatico specificare l'intero percorso. L'Elencazione 7-14 mostra un modo idiomatico
per portare la struttura `HashMap` della standard library nello scope di una
crate binaria.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-14/src/main.rs}}
```

<span class="caption">Elencazione 7-14: Portando `HashMap` nello scope in un
modo idiomatico</span>

Non c'è una ragione forte dietro questo idioma: è solo la convenzione che è
emergere, e le persone si sono abituate a leggere e scrivere codice Rust in questo modo.

L'eccezione a questo idioma è se stiamo portando due oggetti con lo stesso nome
nello scope con le dichiarazioni `use`, perché Rust non lo permette. L'Elencazione 7-15
mostra come portare due tipi `Result` nello scope che hanno lo stesso nome ma
moduli genitori diversi e come riferirsi a loro.

<span class="filename">Nome del file: src/lib.rs</span>

```rust,noplayground
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-15/src/lib.rs:here}}
```

<span class="caption">Elencazione 7-15: Portare due tipi con lo stesso nome in
lo stesso scope richiede l'uso dei loro moduli genitori.</span>

Come potete vedere, l'uso dei moduli genitori distingue i due tipi `Result`.
Se invece avessimo specificato `use std::fmt::Result` e `use std::io::Result`, avremmo
due tipi `Result` nello stesso scope e Rust non saprebbe a quale dei due
significavamo quando usavamo `Result`.

### Fornire Nuovi Nomi con la Keyword `as`

C'è un'altra soluzione al problema di portare due tipi con lo stesso nome
nello stesso scope con `use`: dopo il percorso, possiamo specificare `as` e un nuovo
nome locale, o *alias*, per il tipo. L'Elencazione 7-16 mostra un altro modo di scrivere
il codice nell'Elencazione 7-15 rinominando uno dei due tipi `Result` utilizzando `as`.

<span class="filename">Nome del file: src/lib.rs</span>

```rust,noplayground
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-16/src/lib.rs:here}}
```

<span class="caption">Elencazione 7-16: Rinominazione di un tipo quando è portato in
scope con la keyword `as`</span>

Nella seconda dichiarazione `use`, abbiamo scelto il nuovo nome `IoResult` per il
tipo `std::io::Result`, che non entrerà in conflitto con il `Result` da `std::fmt`
che abbiamo anche portato nello scope. L'Elencazione 7-15 e l'Elencazione 7-16 sono
considerate idiomatiche, quindi la scelta è tua!

### Re-esportazione di Nomi con `pub use`

Quando portiamo un nome nello scope con la keyword `use`, il nome disponibile nel
nuovo scope è privato. Per permettere al codice che chiama il nostro codice di riferirsi a
quel nome come se fosse stato definito nello scope di quel codice, possiamo combinare `pub`
e `use`. Questa tecnica si chiama *re-exporting* perché stiamo portando
un oggetto nello scope ma anche rendendo quell'oggetto disponibile per altri da portare nel
loro scope.

L'Elencazione 7-17 mostra il codice nell'Elencazione 7-11 con `use` nel modulo root
modificato in `pub use`.

<span class="filename">Nome del file: src/lib.rs</span>

```rust,noplayground,test_harness
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-17/src/lib.rs}}
```

<span class="caption">Elencazione 7-17: Rendere un nome disponibile per qualsiasi codice da usare
da un nuovo scope con `pub use`</span>

Prima di questa modifica, il codice esterno avrebbe dovuto chiamare la funzione `add_to_waitlist` utilizzando il percorso `restaurant::front_of_house::hosting::add_to_waitlist()`. Ora che questo `pub use` ha ri-esportato il modulo `hosting` dal modulo radice, il codice esterno può ora utilizzare il percorso `restaurant::hosting::add_to_waitlist()` invece.

La ri-esportazione è utile quando la struttura interna del tuo codice è diversa da come i programmatori che chiamano il tuo codice penserebbero al dominio. Per esempio, in questa metafora del ristorante, le persone che gestiscono il ristorante pensano alla "front of house" e alla "back of house". Ma i clienti che visitano un ristorante probabilmente non penseranno alle parti del ristorante in questi termini. Con `pub use`, possiamo scrivere il nostro codice con una struttura ma esporre una struttura diversa. Tale operazione rende la nostra libreria ben organizzata sia per i programmatori che lavorano sulla libreria, sia per i programmatori che chiamano la libreria. Esamineremo un altro esempio di `pub use` e come influisce sulla documentazione del tuo crate nella sezione ["Esportare una API pubblica conveniente con `pub use`"][ch14-pub-use]<!-- ignore --> del Capitolo 14.
 
### Usare i pacchetti esterni

Nel Capitolo 2, abbiamo programmato un progetto di gioco d'indovinelli che utilizzava un pacchetto esterno chiamato `rand` per ottenere numeri casuali. Per utilizzare `rand` nel nostro progetto, abbiamo aggiunto questa riga a *Cargo.toml*:

<!-- Quando si aggiorna la versione di `rand` utilizzata, aggiorna anche la versione di
`rand` usata in questi file in modo che corrispondano tutti:
* ch02-00-guessing-game-tutorial.md
* ch14-03-cargo-workspaces.md
-->

<span class="filename">Nome del file: Cargo.toml</span>

```toml
{{#include ../listings/ch02-guessing-game-tutorial/listing-02-02/Cargo.toml:9:}}
```
Aggiungendo `rand` come dipendenza in *Cargo.toml*, si dice a Cargo di scaricare il pacchetto `rand` e tutte le sue dipendenze da [crates.io](https://crates.io/) e rendere `rand` disponibile al nostro progetto.

Poi, per portare le definizioni di `rand` nell'ambito del nostro pacchetto, abbiamo aggiunto una riga `use` che inizia con il nome del crate, `rand`, e abbiamo elencato gli elementi che volevamo portare nell'ambito. Ricorda che nella sezione ["Generare un numero casuale"][rand]<!-- ignore --> del Capitolo 2, abbiamo portato il trait `Rng` nell'ambito e chiamato la funzione `rand::thread_rng`:

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-03/src/main.rs:ch07-04}}
```
I membri della comunità Rust hanno reso disponibili molti pacchetti su [crates.io](https://crates.io/), e includerne uno qualsiasi nel tuo pacchetto comporta gli stessi passaggi: elencarli nel file *Cargo.toml* del tuo pacchetto e usare `use` per portare gli elementi dai loro crate nell'ambito.

Nota che la libreria standard `std` è anche un crate che è esterno al nostro pacchetto. Poiché la libreria standard è fornita con il linguaggio Rust, non abbiamo bisogno di cambiare *Cargo.toml* per includere `std`. Ma dobbiamo fare riferimento ad essa con `use` per portare gli elementi da lì nell'ambito del nostro pacchetto. Ad esempio, con `HashMap` utilizzeremmo questa riga:

```rust
use std::collections::HashMap;
```
Questo è un percorso assoluto che inizia con `std`, il nome del crate della libreria standard.

### Utilizzare percorsi annidati per pulire grandi liste `use`

Se stiamo usando più elementi definiti nello stesso crate o nello stesso modulo, elencare ogni elemento sulla propria riga può occupare molto spazio verticale nei nostri file. Ad esempio, queste due istruzioni `use` che avevamo nel Gioco d'Indovinelli nell'Elenco 2-4 portano elementi da `std` nell'ambito:

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch07-managing-growing-projects/no-listing-01-use-std-unnested/src/main.rs:here}}
```
Invece, possiamo usare percorsi annidati per portare gli stessi elementi nell'ambito in una sola riga. Lo facciamo specificando la parte comune del percorso, seguita da due punti, e poi parentesi graffe attorno a un elenco delle parti dei percorsi che differiscono, come mostrato nell'Elenco 7-18.

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-18/src/main.rs:here}}
```
<span class="caption">Elenco 7-18: Specificare un percorso annidato per portare più
elementi con lo stesso prefisso nell'ambito</span>

Nei programmi più grandi, portare molti elementi nell'ambito dallo stesso crate o
modulo usando percorsi annidati può ridurre il numero di statement `use`
separati necessari di molto!

Possiamo usare un percorso annidato a qualsiasi livello in un percorso, il che è utile quando si combinano
due istruzioni `use` che condividono un sottopercorso. Ad esempio, l'Elenco 7-19 mostra due
Istruzioni `use`: una che porta `std::io` nell'ambito e una che porta
`std::io::Write` nell'ambito.

<span class="filename">Nome del file: src/lib.rs</span>

```rust, non giocare
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-19/src/lib.rs}}
``` 

<span class="caption">Elenco 7-19: Due istruzioni `use` dove una è un sottopercorso
dell'altro</span>

La parte comune di questi due percorsi è `std::io`, e quello è il completo primo
percorso. Per unire questi due percorsi in un'unica istruzione `use`, possiamo usare `self` in
il percorso annidato, come mostrato nell'Elenco 7-20.

<span class="filename">Nome del file: src/lib.rs</span>

```rust,non giocare
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-20/src/lib.rs}}
```

<span class="caption">Elenco 7-20: Combinando i percorsi nell'Elenco 7-19 in
una sola istruzione `use`</span>

Questa riga porta `std::io` e `std::io::Write` nell'ambito.

### L'Operatore Globale

Se vogliamo portare *tutti* gli elementi pubblici definiti in un percorso nell'ambito, possiamo
specificare quel percorso seguito dall'operatore globale `*`:

```rust
use std::collections::*;
```

Questa istruzione `use` porta tutti gli elementi pubblici definiti in `std::collections` nel
ambito corrente. Fai attenzione quando usi l'operatore globale! Glob può rendere difficile
capire quali nomi sono nell'ambito e dove un nome usato nel tuo programma
è stato definito.

L'operatore globale è spesso usato durante i test per portare tutto ciò che è sotto test nel modulo `tests`; ne parleremo nella sezione ["Come scrivere
Test"][writing-tests]<!-- ignore --> nel Capitolo 11. L'operatore globale
viene anche a volte utilizzato come parte del modello di preludio: vedi [la documentazione della libreria
standard](../std/prelude/index.html#other-preludes)<!-- ignore -->
per ulteriori informazioni su quel modello.

[ch14-pub-use]: ch14-02-publishing-to-crates-io.html#exporting-a-convenient-public-api-with-pub-use
[rand]: ch02-00-guessing-game-tutorial.html#generating-a-random-number
[writing-tests]: ch11-01-writing-tests.html#how-to-write-tests

