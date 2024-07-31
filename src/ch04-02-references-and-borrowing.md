## Riferimenti e Borrowing

Il problema con il codice della tupla in Listing 4-5 è che dobbiamo restituire lo `String` alla funzione chiamante affinché possiamo ancora usare lo `String` dopo la chiamata a `calculate_length`, poiché lo `String` è stato spostato in `calculate_length`. Invece, possiamo fornire un riferimento al valore dello `String`. Un *riferimento* è come un puntatore in quanto è un indirizzo che possiamo seguire per accedere ai dati memorizzati in quell'indirizzo; quei dati sono di proprietà di qualche altra variabile. A differenza di un puntatore, un riferimento è garantito per puntare a un valore valido di un particolare tipo per la durata di quel riferimento.

Ecco come definiremo e utilizzeremo una funzione `calculate_length` che ha un riferimento a un oggetto come parametro anziché prendere possesso del valore:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-07-reference/src/main.rs:all}}
```

Innanzitutto, nota che tutto il codice della tupla nella dichiarazione della variabile e il valore di ritorno della funzione è sparito. In secondo luogo, nota che passiamo `&s1` in `calculate_length` e, nella sua definizione, prendiamo `&String` anziché `String`. Questi simboli di e commerciale rappresentano i *riferimenti* e permettono di riferirsi a un valore senza prenderne possesso. La Figura 4-5 illustra questo concetto.

<img alt="Tre tabelle: la tabella per s contiene solo un puntatore alla tabella per s1. La tabella per s1 contiene i dati nello stack per s1 e punta ai dati della stringa nello heap." src="img/trpl04-05.svg" class="center" />

<span class="caption">Figura 4-5: Un diagramma di `&String s` che punta a `String s1`</span>

> Nota: L'opposto di riferirsi usando `&` è *dereferenziare*, che si ottiene con l'operatore di dereferenziazione, `*`. Vedremo alcuni usi dell'operatore di dereferenziazione nel Capitolo 8 e discuteremo i dettagli della dereferenziazione nel Capitolo 15.

Osserviamo più da vicino la chiamata della funzione qui:

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-07-reference/src/main.rs:here}}
```

La sintassi `&s1` ci consente di creare un riferimento che *si riferisce* al valore di `s1` ma non ne ha il possesso. Poiché non ne ha il possesso, il valore a cui punta non verrà eliminato quando il riferimento smette di essere utilizzato.

Allo stesso modo, la firma della funzione usa `&` per indicare che il tipo del parametro `s` è un riferimento. Aggiungiamo alcune annotazioni esplicative:

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-08-reference-with-annotations/src/main.rs:here}}
```

Lo scope in cui la variabile `s` è valida è lo stesso come per qualsiasi parametro di funzione, ma il valore puntato dal riferimento non viene eliminato quando `s` smette di essere utilizzato, perché `s` non ne ha il possesso. Quando le funzioni hanno riferimenti come parametri anziché i valori effettivi, non avremo bisogno di restituire i valori per restituire il possesso, perché non ne avevamo mai il possesso.

Chiamiamo l'azione di creare un riferimento *borrowing*. Come nella vita reale, se una persona possiede qualcosa, puoi prenderlo in prestito da loro. Quando hai finito, devi restituirlo. Non lo possiedi.

Quindi, cosa succede se proviamo a modificare qualcosa che abbiamo in prestito? Prova il codice in Listing 4-6. Spoiler: non funziona!

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch04-understanding-ownership/listing-04-06/src/main.rs}}
```

<span class="caption">Listing 4-6: Tentativo di modificare un valore preso in prestito</span>

Ecco l'errore:

```console
{{#include ../listings/ch04-understanding-ownership/listing-04-06/output.txt}}
```

Proprio come le variabili sono immutabili di default, anche i riferimenti lo sono. Non ci è permesso modificare qualcosa a cui abbiamo un riferimento.

### Riferimenti Mutabili

Possiamo correggere il codice da Listing 4-6 per permetterci di modificare un valore preso in prestito con solo pochi piccoli aggiustamenti che utilizzano, invece, un *riferimento mutabile*:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-09-fixes-listing-04-06/src/main.rs}}
```

Prima cambiamo `s` in `mut`. Poi creiamo un riferimento mutabile con `&mut s` dove chiamiamo la funzione `change`, e aggiorniamo la firma della funzione per accettare un riferimento mutabile con `some_string: &mut String`. Questo rende molto chiaro che la funzione `change` modificherà il valore che prende in prestito.

I riferimenti mutabili hanno una grande restrizione: se hai un riferimento mutabile a un valore, non puoi avere altri riferimenti a quel valore. Questo codice che tenta di creare due riferimenti mutabili a `s` fallirà:

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-10-multiple-mut-not-allowed/src/main.rs:here}}
```

Ecco l'errore:

```console
{{#include ../listings/ch04-understanding-ownership/no-listing-10-multiple-mut-not-allowed/output.txt}}
```

Questo errore dice che questo codice non è valido perché non possiamo prendere in prestito `s` come mutabile più di una volta alla volta. Il primo prestito mutabile è in `r1` e deve durare fino a quando viene utilizzato nel `println!`, ma tra la creazione di quel riferimento mutabile e il suo uso, abbiamo tentato di creare un altro riferimento mutabile in `r2` che prende in prestito gli stessi dati di `r1`.

La restrizione che impedisce molteplici riferimenti mutabili agli stessi dati contemporaneamente permette la mutazione ma in modo molto controllato. È qualcosa con cui i nuovi Rustaceans lottano perché la maggior parte delle lingue ti permette di mutare quando vuoi. Il vantaggio di avere questa restrizione è che Rust può prevenire le data races in fase di compilazione. Una data race è simile a una race condition e si verifica quando questi tre comportamenti si verificano:

* Due o più puntatori accedono agli stessi dati contemporaneamente.
* Almeno uno dei puntatori viene utilizzato per scrivere i dati.
* Non c'è nessun meccanismo che viene usato per sincronizzare l'accesso ai dati.

Le data races causano comportamenti indefiniti e possono essere difficili da diagnosticare e correggere quando si cerca di scovare i problemi a runtime; Rust previene questo problema rifiutandosi di compilare codice con data races!

Come sempre, possiamo usare le parentesi graffe per creare un nuovo scope, permettendo riferimenti mutabili multipli, ma non *simultanei*:

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-11-muts-in-separate-scopes/src/main.rs:here}}
```

Rust applica una regola simile per combinare riferimenti mutabili e immutabili. Questo codice produce un errore:

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-12-immutable-and-mutable-not-allowed/src/main.rs:here}}
```

Ecco l'errore:

```console
{{#include ../listings/ch04-understanding-ownership/no-listing-12-immutable-and-mutable-not-allowed/output.txt}}
```

Uffa! *Anche* non possiamo avere un riferimento mutabile mentre abbiamo uno immutabile allo stesso valore.

Gli utenti di un riferimento immutabile non si aspettano che il valore cambi improvvisamente! Tuttavia, sono permessi riferimenti immutabili multipli perché nessuno che sta solo leggendo i dati ha la capacità di influenzare la lettura dei dati di qualcun altro.

Nota che lo scope di un riferimento inizia da dove viene introdotto e continua fino all'ultima volta che quel riferimento viene utilizzato. Per esempio, questo codice compilerà perché l'ultimo utilizzo dei riferimenti immutabili, il `println!`, si verifica prima che il riferimento mutabile venga introdotto:

```rust,edition2021
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-13-reference-scope-ends/src/main.rs:here}}
```

Gli scope dei riferimenti immutabili `r1` e `r2` terminano dopo il `println!` dove vengono utilizzati per l'ultima volta, che è prima che il riferimento mutabile `r3` venga creato. Questi scope non si sovrappongono, quindi questo codice è permesso: il compilatore può dire che il riferimento non viene più utilizzato in un punto prima della fine dello scope.

Anche se gli errori di borrowing possono essere frustranti a volte, ricorda che è il compilatore di Rust a indicare un potenziale bug in anticipo (in fase di compilazione piuttosto che a runtime) e a mostrarti esattamente dove si trova il problema. Poi non devi rintracciare perché i tuoi dati non sono quelli che pensavi fossero.

### Riferimenti Pendenti

Nelle lingue con puntatori, è facile creare erroneamente un *puntatore pendente*—un puntatore che fa riferimento a una posizione in memoria che potrebbe essere stata assegnata a qualcun altro—liberando un po' di memoria mentre si conserva ancora un puntatore a quella memoria. In Rust, al contrario, il compilatore garantisce che i riferimenti non saranno mai riferimenti pendenti: se hai un riferimento a qualche dato, il compilatore assicurerà che i dati non usciranno dallo scope prima che il riferimento ai dati lo faccia.

Proviamo a creare un riferimento pendente per vedere come Rust li impedisce con un errore in fase di compilazione:

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-14-dangling-reference/src/main.rs}}
```

Ecco l'errore:

```console
{{#include ../listings/ch04-understanding-ownership/no-listing-14-dangling-reference/output.txt}}
```

Questo messaggio di errore si riferisce a una funzione che non abbiamo ancora trattato: lifetimes. Discuteremo i lifetimes in dettaglio nel Capitolo 10. Ma, se ignori le parti sui lifetimes, il messaggio contiene la chiave del perché questo codice è un problema:

```text
this function's return type contains a borrowed value, but there is no value
for it to be borrowed from
```

Osserviamo più da vicino cosa sta succedendo ad ogni fase del nostro codice `dangle`:

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-15-dangling-reference-annotated/src/main.rs:here}}
```

Poiché `s` è creato all'interno di `dangle`, quando il codice di `dangle` è terminato, `s` verrà deallocato. Ma abbiamo tentato di restituire un riferimento ad esso. Ciò significa che questo riferimento punterebbe a una `String` non valida. Non va bene! Rust non ce lo permette.

La soluzione qui è restituire direttamente la `String`:

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-16-no-dangle/src/main.rs:here}}
```

Questo funziona senza problemi. Il possesso viene spostato fuori, e niente viene deallocato.

### Le Regole dei Riferimenti

Riassumiamo ciò che abbiamo discusso riguardo ai riferimenti:

* In qualsiasi momento, è possibile avere *o* un riferimento mutabile *o* qualsiasi numero di riferimenti immutabili.
* I riferimenti devono essere sempre validi.

Successivamente, esamineremo un tipo diverso di riferimento: slices.
