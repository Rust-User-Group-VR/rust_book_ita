## Riferimenti e Borrowing

Il problema con il codice della tupla nella Lista 4-5 è che dobbiamo restituire la
`String` alla funzione di chiamata in modo che possiamo ancora utilizzare la `String` dopo la
chiamata a `calculate_length`, perché la `String` è stata spostata in
`calculate_length`. Invece, possiamo fornire un riferimento al valore `String`.
Un *riferimento* è come un puntatore nel senso che è un indirizzo che possiamo seguire per accedere
ai dati memorizzati a quell'indirizzo; quei dati sono di proprietà di qualche altra variabile.
A differenza di un puntatore, un riferimento è garantito che punti a un valore valido di un
tipo particolare per la durata di quel riferimento.

Ecco come definiresti e usare una funzione `calculate_length` che ha un
riferimento a un oggetto come parametro invece di prendere il possesso del valore:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-07-reference/src/main.rs:all}}
```

Innanzitutto, notate che tutto il codice della tupla nella dichiarazione di variabile e nel
valore di ritorno della funzione è sparito. In secondo luogo, notate che passiamo `&s1` in
`calculate_length` e, nella sua definizione, prendiamo `&String` piuttosto che
`String`. Questi simboli di e commerciale (`&`) rappresentano *riferimenti*, e permettono di fare riferimento
a un valore senza prendere il possesso. La Figura 4-5 illustra questo concetto.

<img alt="Tre tabelle: la tabella per s contiene solo un puntatore alla tabella
per s1. La tabella per s1 contiene i dati dello stack per s1 e punta ai
dati della stringa nell'heap." src="img/trpl04-05.svg" class="center" />

<span class="caption">Figura 4-5: Un diagramma di `&String s` che punta a `String
s1`</span>

> Nota: Il contrario della referenziazione utilizzando `&` è la *dereferenziazione*, che è
> realizzata con l'operatore di dereferenziazione, `*`. Vedremo alcuni usi del
> operatore di dereferenziazione nel capitolo 8 e discuteremo i dettagli della dereferenziazione in
> Capitolo 15.

Diamo uno sguardo più da vicino alla chiamata della funzione qui:

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-07-reference/src/main.rs:here}}
```

La sintassi `&s1` ci permette di creare un riferimento che *rifersce* al valore di `s1`
ma non ne ha il possesso. Poiché non ne ha il possesso, il valore a cui punta non sarà
rilasciato quando il riferimento smette di essere utilizzato.

Allo stesso modo, la firma della funzione usa `&` per indicare che il tipo del
parametro `s` è un riferimento. Aggiungiamo alcune annotazioni esplicative:

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-08-reference-with-annotations/src/main.rs:here}}
```

L'ambito in cui la variabile `s` è valida è lo stesso di qualsiasi ambito del
parametro della funzione, ma il valore puntato dal riferimento non viene rilasciato
quando `s` smette di essere utilizzato, perché `s` non ne ha il possesso. Quando le funzioni
hanno riferimenti come parametri invece dei valori reali, non avremo bisogno di
restituire i valori per restituire il possesso, perché non abbiamo mai avuto
il possesso.

Chiamiamo l'azione di creare un riferimento *borrowing*. Come nella vita reale, se una
persona possiede qualcosa, puoi prestarla da loro. Quando hai finito, devi restituirla. Non ne sei il proprietario.

Allora, cosa succede se proviamo a modificare qualcosa che stiamo prendendo in prestito? Prova il codice in
Lista 4-6. Alert spoiler: non funziona!

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch04-understanding-ownership/listing-04-06/src/main.rs}}
```

<span class="caption">Lista 4-6: Tentativo di modificare un valore preso in prestito</span>

Ecco l'errore:

```console
{{#include ../listings/ch04-understanding-ownership/listing-04-06/output.txt}}
```

Proprio come le variabili sono immutabili per default, lo sono anche i riferimenti. Non siamo
permessi a modificare qualcosa a cui abbiamo un riferimento.

### Riferimenti Mutabili

Possiamo correggere il codice della Lista 4-6 per permetterci di modificare un valore prestato
con solo poche piccole modifiche che usano, invece, un *riferimento mutevole*:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-09-fixes-listing-04-06/src/main.rs}}
```

Prima cambiamo `s` in `mut`. Poi creiamo un riferimento mutevole con `&mut
s` quando chiamiamo la funzione `change`, e aggiorniamo la firma della funzione per
accettare un riferimento mutevole con `some_string: &mut String`. Questo rende molto chiaro che la funzione `change` muterà il valore che prende in prestito.

I riferimenti mutabili hanno una grande restrizione: se si ha un riferimento mutevole a
un valore, non si possono avere altri riferimenti a quel valore. Questo codice che
cerca di creare due riferimenti mutabili a `s` fallirà:

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-10-multiple-mut-not-allowed/src/main.rs:here}}
```

Ecco l'errore:

```console
{{#include ../listings/ch04-understanding-ownership/no-listing-10-multiple-mut-not-allowed/output.txt}}
```

Questo errore dice che questo codice non è valido perché non possiamo prendere in prestito `s` come
mutevole più di una volta alla volta. Il primo prestito mutevole è in `r1` e deve
durare fino a quando viene utilizzato nel `println!`, ma tra la creazione di quel
riferimento mutevole e il suo uso, abbiamo cercato di creare un altro riferimento mutevole
in `r2` che prende in prestito gli stessi dati di `r1`.

La restrizione che impedisce più riferimenti mutabili ai stessi dati allo stesso tempo permette la mutazione ma in modo molto controllato. È qualcosa
che i nuovi Rustaceans fanno fatica a capire perché la maggior parte dei linguaggi ti lascia mutare
quando vuoi. Il vantaggio di avere questa restrizione è che Rust può
prevenire le corse ai dati a tempo di compilazione. Una *corsa ai dati* è simile a una condizione di corsa
e si verifica quando questi tre comportamenti si verificano:

* Due o più puntatori accedono ai stessi dati allo stesso tempo.
* Almeno uno dei puntatori viene utilizzato per scrivere i dati.
* Non c'è alcun meccanismo utilizzato per sincronizzare l'accesso ai dati.

Le corse ai dati causano comportamenti indefiniti e possono essere difficili da diagnosticare e correggere
quando stai cercando di rintracciarli a runtime; Rust previene questo problema rifiutandosi di compilare il codice con corse ai dati!

Come sempre, possiamo usare le parentesi graffe per creare un nuovo ambito, permettendo per
più riferimenti mutabili, solo non *simultanei*:

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-11-muts-in-separate-scopes/src/main.rs:here}}
```

Rust impone una regola simile per combinare riferimenti mutabili e immutabili.
Questo codice produce un errore:

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-12-immutable-and-mutable-not-allowed/src/main.rs:here}}
```

Ecco l'errore:

```console
{{#include ../listings/ch04-understanding-ownership/no-listing-12-immutable-and-mutable-not-allowed/output.txt}}
```

Whew! *Anche* non possiamo avere un riferimento mutevole mentre abbiamo un riferimento immutabile
allo stesso valore.

Gli utenti di un riferimento immutabile non si aspettano che il valore cambi improvvisamente
sotto di loro! Tuttavia, sono ammessi più riferimenti immutabili perché nessuno
chi sta solo leggendo i dati ha la capacità di influenzare la lettura degli altri
dei dati.

Nota che l'ambito di un riferimento inizia da dove viene introdotto e continua
attraverso l'ultima volta che quel riferimento viene utilizzato. Ad esempio, questo codice sarà
compila perché l'ultimo uso dei riferimenti immutabili, il `println!`,
avviene prima che il riferimento mutevole sia introdotto:

```rust,edition2021
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-13-reference-scope-ends/src/main.rs:here}}
```

L'ambito dei riferimenti immutabili `r1` e `r2` termina dopo il `println!`
dove sono utilizzati per l'ultima volta, che è prima che il riferimento mutevole `r3` sia
creato. Questi ambiti non si sovrappongono, quindi questo codice è permesso: il compilatore può
dirci che il riferimento non viene più utilizzato in un punto prima della fine della
ambito.

Anche se a volte gli errori di prestito possono essere frustranti, ricorda che è il compilatore Rust che evidenzia un possibile bug in anticipo (al momento della compilazione invece che al momento dell'esecuzione) e ti mostra esattamente dove si trova il problema. Quindi non devi rintracciare perché i tuoi dati non sono quello che pensavi fossero.

### Riferimenti in sospeso

Nei linguaggi con puntatori, è facile creare erroneamente un *puntatore in sospeso*, un puntatore che fa riferimento a una posizione nella memoria che potrebbe essere stata assegnata a qualcun altro, liberando un po' di memoria pur conservando un puntatore a quella memoria. In contrasto, in Rust, il compilatore garantisce che i riferimenti non saranno mai riferimenti in sospeso: se hai un riferimento a qualche dato, il compilatore garantirà che i dati non andranno fuori dallo scope prima del riferimento ai dati stessi.

Proviamo a creare un riferimento in sospeso per vedere come Rust li previene con un errore di compilazione:

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-14-dangling-reference/src/main.rs}}
```

Ecco l'errore:

```console
{{#include ../listings/ch04-understanding-ownership/no-listing-14-dangling-reference/output.txt}}
```

Questo messaggio di errore fa riferimento a una caratteristica che non abbiamo ancora coperto: lifetime. Parleremo delle lifetime in dettaglio nel Capitolo 10. Ma, se si trascurano le parti sulle lifetime, il messaggio contiene la chiave del perché questo codice è un problema:

```testo
il tipo di ritorno di questa funzione contiene un valore preso in prestito, ma non c'è nessun valore
da cui possa essere preso in prestito
```

Diamo un'occhiata più da vicino a cosa sta succedendo esattamente in ogni fase del nostro codice `dangle`:

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-15-dangling-reference-annotated/src/main.rs:here}}
```

Poiché `s` è creato all'interno di `dangle`, quando il codice di `dangle` è finito,
`s` verrà deallocato. Ma abbiamo cercato di restituire un riferimento ad esso. Ciò significa
che questo riferimento sarebbe puntato a una `String` non valida. Questo non va bene! Rust
non ci permette di fare questo.

La soluzione qui è restituire direttamente la `String`:

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-16-no-dangle/src/main.rs:here}}
```

Questo funziona senza problemi. L'Ownership viene spostato e nulla viene
deallocato.

### Le regole dei riferimenti

Riprendiamo ciò che abbiamo discusso sui riferimenti:

* In un dato momento, puoi avere *o* un solo riferimento mutable *o* un qualsiasi numero di riferimenti immutable.
* I riferimenti devono essere sempre validi.

Avanti, esamineremo un tipo diverso di riferimento: gli slice.
