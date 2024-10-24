## Riferimenti e Borrowing

Il problema con il codice della tupla nel Listato 4-5 è che dobbiamo restituire il `String` alla funzione chiamante in modo da poter ancora usare il `String` dopo la chiamata a `calculate_length`, perché il `String` è stato mosso in `calculate_length`. Invece, possiamo fornire un riferimento al valore `String`. Un *riferimento* è come un puntatore nel senso che è un indirizzo che possiamo seguire per accedere ai dati memorizzati in quell'indirizzo; quei dati sono di proprietà di qualche altra variabile. A differenza di un puntatore, un riferimento è garantito puntare a un valore valido di un tipo particolare per tutta la durata di quel riferimento.

Ecco come definiresti e useresti una funzione `calculate_length` che ha un riferimento a un oggetto come parametro invece di prendere Ownership del valore:

<span class="filename">Filename: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-07-reference/src/main.rs:all}}
```

Per prima cosa, nota che tutto il codice della tupla nella dichiarazione della variabile e il valore restituito della funzione è sparito. Secondo, nota che passiamo `&s1` in `calculate_length` e, nella sua definizione, prendiamo `&String` anziché `String`. Questi simboli di ampersand rappresentano i *riferimenti*, e ti permettono di fare riferimento a qualche valore senza prenderne l'Ownership. La Figura 4-5 illustra questo concetto.

<img alt="Tre tabelle: la tabella per s contiene solo un puntatore alla tabella per s1. La tabella per s1 contiene i dati dello stack per s1 e punta ai dati della stringa sull'heap." src="img/trpl04-05.svg" class="center" />

<span class="caption">Figura 4-5: Un diagramma di `&String s` puntando a `String s1`</span>

> Nota: L'opposto del riferimento utilizzando `&` è il *dereferenziare*, che si realizza con l'operatore di dereferenziazione, `*`. Vedremo alcuni utilizzi dell'operatore di dereferenziazione nel Capitolo 8 e discuteremo i dettagli della dereferenziazione nel Capitolo 15.

Diamo uno sguardo più da vicino alla chiamata della funzione qui:

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-07-reference/src/main.rs:here}}
```

La sintassi `&s1` ci permette di creare un riferimento che *si riferisce* al valore di `s1` ma non ne prende l'Ownership. Poiché non ha l'Ownership, il valore a cui punta non verrà eliminato quando il riferimento smette di essere usato.

Allo stesso modo, la firma della funzione usa `&` per indicare che il tipo del parametro `s` è un riferimento. Aggiungiamo alcune annotazioni esplicative:

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-08-reference-with-annotations/src/main.rs:here}}
```

Lo Scope in cui la variabile `s` è valida è lo stesso di qualsiasi parametro di funzione, ma il valore a cui si punta attraverso il riferimento non viene eliminato quando `s` smette di essere usato, perché `s` non ha l'Ownership. Quando le funzioni hanno riferimenti come parametri anziché i valori effettivi, non avremo bisogno di restituire i valori per restituire l'Ownership, perché non abbiamo mai avuto l'Ownership.

Chiamiamo l'azione di creare un riferimento *borrowing*. Come nella vita reale, se una persona possiede qualcosa, puoi prenderla in prestito. Quando hai finito, devi restituirla. Non ne possiedi l'Ownership.

Quindi, cosa succede se proviamo a modificare qualcosa che stiamo prendendo in prestito? Prova il codice nel Listato 4-6. Avviso spoiler: non funziona!

<span class="filename">Filename: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch04-understanding-ownership/listing-04-06/src/main.rs}}
```

<span class="caption">Listato 4-6: Tentativo di modificare un valore preso in prestito</span>

Ecco l'errore:

```console
{{#include ../listings/ch04-understanding-ownership/listing-04-06/output.txt}}
```

Proprio come le variabili sono immutabili di default, lo sono anche i riferimenti. Non ci è consentito modificare qualcosa a cui stiamo facendo riferimento.

### Riferimenti Mutabili

Possiamo correggere il codice dal Listato 4-6 per permetterci di modificare un valore preso in prestito con solo alcune piccole modifiche che utilizzano, invece, un *riferimento mutabile*:

<span class="filename">Filename: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-09-fixes-listing-04-06/src/main.rs}}
```

Per prima cosa, cambiamo `s` per essere `mut`. Poi creiamo un riferimento mutabile con `&mut s` dove chiamiamo la funzione `change`, e aggiorniamo la firma della funzione per accettare un riferimento mutabile con `some_string: &mut String`. Questo rende molto chiaro che la funzione `change` modificherà il valore che prende in prestito.

I riferimenti mutabili hanno una grande restrizione: se hai un riferimento mutabile a un valore, non puoi avere altri riferimenti a quel valore. Questo codice che tenta di creare due riferimenti mutabili a `s` fallirà:

<span class="filename">Filename: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-10-multiple-mut-not-allowed/src/main.rs:here}}
```

Ecco l'errore:

```console
{{#include ../listings/ch04-understanding-ownership/no-listing-10-multiple-mut-not-allowed/output.txt}}
```

Questo errore dice che questo codice è invalido perché non possiamo prendere in prestito `s` come mutabile più di una volta alla volta. Il primo borrow mutabile è in `r1` e deve durare fino a quando viene utilizzato nel `println!`, ma tra la creazione di quel riferimento mutabile e il suo utilizzo, abbiamo provato a creare un altro riferimento mutabile in `r2` che prende in prestito gli stessi dati di `r1`.

La restrizione che impedisce riferimenti mutabili multipli agli stessi dati nello stesso momento permette la mutazione ma in modo molto controllato. È qualcosa con cui i nuovi Rustaceans lottano perché la maggior parte dei linguaggi ti permette di mutare quando vuoi. Il vantaggio di avere questa restrizione è che Rust può prevenire i data race al tempo di compilazione. Un *data race* è simile a una race condition e si verifica quando questi tre comportamenti si verificano:

* Due o più puntatori accedono agli stessi dati contemporaneamente.
* Almeno uno dei puntatori viene utilizzato per scrivere i dati.
* Non c'è un meccanismo utilizzato per sincronizzare l'accesso ai dati.

I data race causano comportamento indefinito e possono essere difficili da diagnosticare e correggere quando si cerca di rintracciarli a runtime; Rust impedisce questo problema rifiutando di compilare codice con data race!

Come sempre, possiamo usare le parentesi graffe per creare un nuovo Scope, permettendo riferimenti mutabili multipli, ma non *simultanei*:

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-11-muts-in-separate-scopes/src/main.rs:here}}
```

Rust applica una regola simile per combinare riferimenti mutabili e immutabili. Questo codice risulta in un errore:

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-12-immutable-and-mutable-not-allowed/src/main.rs:here}}
```

Ecco l'errore:

```console
{{#include ../listings/ch04-understanding-ownership/no-listing-12-immutable-and-mutable-not-allowed/output.txt}}
```

Uff! Non possiamo neanche avere un riferimento mutabile mentre abbiamo un riferimento immutabile allo stesso valore.

Gli utenti di un riferimento immutabile non si aspettano che il valore cambi improvvisamente sotto di loro! Tuttavia, riferimenti immutabili multipli sono consentiti perché nessuno che sta solo leggendo i dati ha la capacità di influenzare la lettura dei dati da parte di qualcun altro.

Nota che lo Scope di un riferimento inizia dal punto in cui viene introdotto e continua attraverso l'ultima volta che quel riferimento viene usato. Per esempio, questo codice compilerà perché l'ultimo uso dei riferimenti immutabili, il `println!`, avviene prima che venga introdotto il riferimento mutabile:

```rust,edition2021
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-13-reference-scope-ends/src/main.rs:here}}
```

Lo Scope dei riferimenti immutabili `r1` e `r2` termina dopo il `println!` dove vengono usati per l'ultima volta, che è prima che il riferimento mutabile `r3` venga creato. Questi Scope non si sovrappongono, quindi questo codice è consentito: il compilatore può dire che il riferimento non è più usato in un punto prima della fine dello Scope.

Anche se gli errori di borrowing possono essere frustranti a volte, ricorda che è il compilatore Rust a evidenziare un potenziale bug in anticipo (al tempo di compilazione piuttosto che a runtime) e mostrandoti esattamente dove si trova il problema. In questo modo non devi rintracciare il motivo per cui i dati non sono ciò che pensavi.

### Riferimenti Dangling

Nei linguaggi con puntatori, è facile creare erroneamente un *puntatore dangling*—un puntatore che si riferisce a una posizione in memoria che potrebbe essere stata assegnata a qualcun altro—liberando qualche memoria mentre si mantiene un puntatore a quella memoria. In Rust, al contrario, il compilatore garantisce che i riferimenti non saranno mai riferimenti dangling: se hai un riferimento a qualche dato, il compilatore si assicurerà che i dati non escano dallo Scope prima del riferimento ai dati.

Proviamo a creare un riferimento dangling per vedere come Rust li previene con un errore al tempo di compilazione:

<span class="filename">Filename: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-14-dangling-reference/src/main.rs}}
```

Ecco l'errore:

```console
{{#include ../listings/ch04-understanding-ownership/no-listing-14-dangling-reference/output.txt}}
```

Questo messaggio di errore si riferisce a una caratteristica che non abbiamo ancora trattato: i lifetimes. Discuteremo i lifetimes in dettaglio nel Capitolo 10. Ma, se ignori le parti sui lifetimes, il messaggio contiene la chiave del perché questo codice è un problema:

```text
this function's return type contains a borrowed value, but there is no value
for it to be borrowed from
```

Diamo uno sguardo più approfondito a cosa sta succedendo esattamente in ogni fase del nostro codice `dangle`:

<span class="filename">Filename: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-15-dangling-reference-annotated/src/main.rs:here}}
```

Poiché `s` è creato all'interno di `dangle`, quando il codice di `dangle` è finito, `s` sarà deallocato. Ma abbiamo provato a restituire un riferimento a esso. Ciò significa che questo riferimento punterebbe a un `String` non valido. Questo non va bene! Rust non ci permetterà di farlo.

La soluzione qui è restituire il `String` direttamente:

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-16-no-dangle/src/main.rs:here}}
```

Questo funziona senza problemi. L'Ownership viene trasferita, e nulla viene deallocato.

### Le Regole dei Riferimenti

Facciamo un riepilogo di ciò che abbiamo discusso riguardo ai riferimenti:

* In qualsiasi momento, puoi avere *o* un solo riferimento mutabile *o* un qualsiasi numero di riferimenti immutabili.
* I riferimenti devono essere sempre validi.

Successivamente, esamineremo un diverso tipo di riferimento: i slices.
