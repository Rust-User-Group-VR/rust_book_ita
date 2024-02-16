## Riferimenti e Prestito

Il problema con il codice delle tuple in Listing 4-5 è che dobbiamo restituire la
`String` alla funzione chiamante in modo da poter ancora utilizzare la `String` dopo la
chiamata a `calculate_length`, perché la `String` è stata spostata in
`calculate_length`. Invece, possiamo fornire un riferimento al valore `String`. 
Un *riferimento* è come un puntatore in quanto è un indirizzo a cui possiamo fare riferimento per accedere
ai dati memorizzati a quell'indirizzo; tali dati sono di proprietà di un'altra variabile.
A differenza di un puntatore, un riferimento garantisce di puntare a un valore valido di un
tipo particolare per la durata di quel riferimento.

Ecco come si definirebbe e utilizzerebbe una funzione `calculate_length` che ha un
riferimento a un oggetto come parametro invece di prendere la proprietà del valore:

<span class="filename">Nome file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-07-reference/src/main.rs:all}}
```

Innanzitutto, notare che tutto il codice delle tuple nella dichiarazione della variabile e nel
valore di ritorno della funzione è sparito. Secondo, notare che passiamo `&s1` in
`calculate_length` e, nella sua definizione, prendiamo `&String` anziché
`String`. Questi "e commerciale" rappresentano *riferimenti*, e ti permettono di fare riferimento
a un valore senza prenderne la proprietà. La Figura 4-5 rappresenta questo concetto.

<img alt="Tre tavoli: il tavolo per s contiene solo un puntatore alla tavola
per s1. La tavola per s1 contiene i dati stack per s1 e punta ai
dati stringa sulla pila." src="img/trpl04-05.svg" class="center" />

<span class="caption">Figura 4-5: Un diagramma di `&String s` che punta a `String
s1`</span>

> Nota: L'opposto del riferimento utilizzando `&` è *dereferenziare*, che è
> realizzato con l'operatore di dereferenziazione, `*`. Vedremo alcuni usi di
> l'operatore di dereferenziazione nel Capitolo 8 e discuteremo dettagli di dereferenziazione in
> Capitolo 15.

Diamo un'occhiata più da vicino alla chiamata di funzione qui:

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-07-reference/src/main.rs:here}}
```

La sintassi `&s1` ci permette di creare un riferimento che *si riferisce* al valore di `s1`
ma non lo possiede. Poiché non lo possiede, il valore a cui punta non sarà
lasciato cadere quando il riferimento smetterà di essere utilizzato.

Allo stesso modo, la firma della funzione usa `&` per indicare che il tipo di
il parametro `s` è un riferimento. Aggiamo alcune annotazioni esplicative:

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-08-reference-with-annotations/src/main.rs:here}}
```

L'ambito in cui la variabile `s` è valida è lo stesso di qualsiasi funzione
parametro, ma il valore puntato dal riferimento non viene lasciato cadere
quando `s` smette di essere utilizzato, perché `s` non ha la proprietà. Quando le funzioni
hanno referenze come parametri invece dei valori effettivi, non avremo bisogno di
restituire i valori per restituirne la proprietà, perché non abbiamo mai avuto
la proprietà di esso.

Chiamiamo l'azione di creare un riferimento *prendere in prestito*. Come nella vita reale, se una
persona possiede qualcosa, puoi prenderla in prestito da loro. Quando hai finito, devi restituirla. Non la possiedi.

Quindi, cosa succede se proviamo a modificare qualcosa che stiamo prendendo in prestito? Prova il codice in
Listing 4-6. Attenzione spoiler: non funziona!

<span class="filename">Nome file: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch04-understanding-ownership/listing-04-06/src/main.rs}}
```

<span class="caption">Listing 4-6: Tentativo di modificare un valore preso in prestito</span>

Ecco l'errore:

```console
{{#include ../listings/ch04-understanding-ownership/listing-04-06/output.txt}}
```

Proprio come le variabili sono immutabili per impostazione predefinita, così lo sono anche i riferimenti. Non ci è
permesso di modificare qualcosa a cui abbiamo un riferimento.

### Riferimenti Mutabili

Possiamo correggere il codice di Listing 4-6 per consentirci di modificare un valore preso in prestito
con solo alcune piccole modifiche che utilizzano, invece, un *riferimento mutabile*:

<span class="filename">Nome file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-09-fixes-listing-04-06/src/main.rs}}
```

Prima cambiamo `s` per essere `mut`. Poi creiamo un riferimento mutabile con `&mut
s` dove chiamiamo la funzione `change`, e aggiorniamo la firma della funzione per accettare un riferimento mutabile con `some_string: &mut String`. Questo rende molto chiaro che la funzione `change` muterà il valore che prende in prestito.

I riferimenti mutabili hanno una grande restrizione: se hai un riferimento mutabile a
un valore, non puoi avere altri riferimenti a quel valore. Questo codice che
cerca di creare due riferimenti mutabili a `s` fallirà:

<span class="filename">Nome file: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-10-multiple-mut-not-allowed/src/main.rs:here}}
```

Ecco l'errore:

```console
{{#include ../listings/ch04-understanding-ownership/no-listing-10-multiple-mut-not-allowed/output.txt}}
```

Questo errore dice che questo codice è non valido perché non possiamo prendere in prestito `s` come
mutabile più di una volta alla volta. Il primo prestito mutabile è in `r1` e deve
durare fino a quando è usato nel `println!`, ma tra la creazione di quel
riferimento mutabile e il suo utilizzo, abbiamo cercato di creare un altro riferimento mutabile
in `r2` che prende in prestito gli stessi dati di `r1`.

La restrizione che impedisce più riferimenti mutabili agli stessi dati al
stesso tempo consente la mutazione ma in modo molto controllato. È qualcosa
che i nuovi Rustacean faticano perché la maggior parte delle lingue ti permette di mutare
quando vuoi. Il vantaggio di avere questa restrizione è che Rust può
prevenire le gare sui dati a tempo di compilazione. Una *gara dati* è simile a una gara
condizione e succede quando queste tre condizioni si verificano:

* Due o più puntatori accedono agli stessi dati allo stesso tempo.
* Almeno uno dei puntatori viene utilizzato per scrivere sui dati.
* Non c'è nessun meccanismo utilizzato per sincronizzare l'accesso ai dati.

Le gare di dati causano un comportamento non definito e possono essere difficili da diagnosticare e correggere
quando stai cercando di rintracciarli a runtime; Rust previene questo problema da
rifiutando di compilare codice con gare di dati!

Come sempre, possiamo utilizzare le parentesi graffe per creare un nuovo ambito, consentendo
più riferimenti mutabili, ma non *simultanei*:

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-11-muts-in-separate-scopes/src/main.rs:here}}
```

Rust impone una regola simile per la combinazione di riferimenti mutabili e immutabili.
Questo codice provoca un errore:

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-12-immutable-and-mutable-not-allowed/src/main.rs:here}}
```

Ecco l'errore:

```console
{{#include ../listings/ch04-understanding-ownership/no-listing-12-immutable-and-mutable-not-allowed/output.txt}}
```

Whew! *Anche* non possiamo avere un riferimento mutabile mentre abbiamo un riferimento immutabile
allo stesso valore.

Gli utenti di un riferimento immutabile non si aspettano il valore di cambiare improvvisamente sotto
loro! Tuttavia, sono consentiti più riferimenti immutabili perché nessuno
che stia solo leggendo i dati ha la capacità di influenzare la lettura degli altri
dei dati.
Nota che l'ambito di un riferimento inizia da dove viene introdotto e continua
fino all'ultima volta che quel riferimento viene utilizzato. Ad esempio, questo codice sarà
compilato perché l'ultimo utilizzo dei riferimenti immutabili, il `println!`,
si verifica prima che il riferimento mutabile sia introdotto:

```rust,edition2021
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-13-reference-scope-ends/src/main.rs:here}}
```

Gli ambiti dei riferimenti immutabili `r1` e `r2` terminano dopo il `println!`
dove vengono utilizzati per l'ultima volta, che è prima che il riferimento mutabile `r3` sia
creato. Questi ambiti non si sovrappongono, quindi questo codice è consentito: il compilatore può
dire che il riferimento non viene più utilizzato in un punto prima della fine
dello scope.

Anche se gli errori di prestito possono essere frustranti a volte, ricorda che è
il compilatore Rust che indica un potenziale bug in anticipo (al momento della compilazione piuttosto che al runtime) e ti mostra esattamente dove si trova il problema. Quindi non devi
cercare di capire perché i tuoi dati non sono quello che pensavi fossero.

### Riferimenti Dangling

Nei linguaggi con puntatori, è facile creare erroneamente un *puntatore dangling*—un puntatore che fa riferimento a una posizione in memoria che potrebbe essere stata
concessa a qualcun altro—liberando un po' di memoria mentre si conserva un puntatore a quella
memoria. In Rust, al contrario, il compilatore garantisce che i riferimenti non saranno mai riferimenti dangling: se hai un riferimento a alcuni dati, il compilatore si assicurerà che i dati non andranno fuori scope prima del riferimento ai dati.

Proviamo a creare un riferimento dangling per vedere come Rust li previene con un errore di compilazione:

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-14-dangling-reference/src/main.rs}}
```

Ecco l'errore:

```console
{{#include ../listings/ch04-understanding-ownership/no-listing-14-dangling-reference/output.txt}}
```

Questo messaggio di errore si riferisce a una funzionalità che non abbiamo ancora coperto: lifetimes. Ne parleremo in dettaglio nel Capitolo 10. Ma, se si ignorano le parti riguardanti i lifetimes, il messaggio contiene la chiave per capire perché questo codice è un problema:

```text
il tipo di ritorno di questa funzione contiene un valore preso in prestito, ma non c'è nessun valore da cui prenderlo in prestito
```

Diamo uno sguardo più da vicino a cosa succede esattamente in ogni fase del nostro codice `dangle`:

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-15-dangling-reference-annotated/src/main.rs:here}}
```

Poiché `s` è creato all'interno di `dangle`, quando il codice di `dangle` è finito,
`s` verrà deallocato. Ma abbiamo cercato di restituire un riferimento ad esso. Ciò significa
che questo riferimento puntava a una `String` non valida. Non va bene! Rust
non ci permetterà di farlo.

La soluzione qui è restituire la `String` direttamente:

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-16-no-dangle/src/main.rs:here}}
```

Questo funziona senza problemi. La proprietà viene trasferita, e nulla viene deallocato.

### Le Regole dei Riferimenti

Ricapitoliamo ciò che abbiamo discusso sui riferimenti:

* In ogni momento, si può avere *o* un solo riferimento mutabile *o* un qualsiasi
  numero di riferimenti immutabili.
* I riferimenti devono sempre essere validi.

Poi, esamineremo un diverso tipo di riferimento: le slices.

