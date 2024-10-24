## Un Programma di Esempio Usando le Struct

Per capire quando potremmo voler usare le struct, scriviamo un programma che
calcola l'area di un rettangolo. Inizieremo usando variabili singole e poi faremo refactoring del programma fino a usare le struct.

Creiamo un nuovo progetto binario con Cargo chiamato *rectangles* che prenderà
la larghezza e l'altezza di un rettangolo specificate in pixel e calcolerà l'area
del rettangolo. Il Listato 5-8 mostra un breve programma in un modo di farlo
esattamente nel file *src/main.rs* del nostro progetto.

<span class="filename">Nome file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-08/src/main.rs:all}}
```

<span class="caption">Listato 5-8: Calcolare l'area di un rettangolo
specificato da variabili larghezza e altezza separate</span>

Ora, esegui questo programma usando `cargo run`:

```console
{{#include ../listings/ch05-using-structs-to-structure-related-data/listing-05-08/output.txt}}
```

Questo codice riesce a determinare l'area del rettangolo chiamando la
funzione `area` con ciascuna dimensione, ma possiamo fare di più per rendere
questo codice chiaro e leggibile.

Il problema con questo codice è evidente nella firma di `area`:

```rust,ignore
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-08/src/main.rs:here}}
```

La funzione `area` dovrebbe calcolare l'area di un solo rettangolo, ma la
funzione che abbiamo scritto ha due parametri, e non è chiaro da nessuna parte nel
nostro programma che i parametri siano correlati. Sarebbe più leggibile e più
gestibile raggruppare larghezza e altezza insieme. Abbiamo già discusso un modo
per farlo nella sezione [“Il Tipo Tuple”][the-tuple-type]<!-- ignore --> del Capitolo 3: usando le tuple.

### Refactoring con Tuple

Il Listato 5-9 mostra un'altra versione del nostro programma che utilizza tuple.

<span class="filename">Nome file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-09/src/main.rs}}
```

<span class="caption">Listato 5-9: Specificare la larghezza e l'altezza del
rettangolo con una tuple</span>

In un certo senso, questo programma è migliore. Le tuple ci permettono di aggiungere una struttura leggermente maggiore, e ora passiamo un solo argomento. Ma in un altro, questa versione è meno chiara: le tuple non nominano i loro elementi, quindi dobbiamo indicizzare nei componenti della tuple, rendendo il nostro calcolo meno ovvio.

Confondere larghezza e altezza non sarebbe un problema per il calcolo dell'area, ma se volessimo disegnare il rettangolo sullo schermo, sarebbe un problema! Dovremmo tenere a mente che `width` è l'indice tuple `0` e `height` è l'indice tuple `1`. Questo sarebbe ancora più difficile da capire e tenere a mente per qualcun altro se dovessero usare il nostro codice. Dal momento che non abbiamo trasmesso il significato dei nostri dati nel nostro codice, ora è più facile introdurre errori.

### Refactoring con le Struct: Aggiungere Maggior Significato

Usiamo le struct per aggiungere significato etichettando i dati. Possiamo trasformare la tuple che stiamo usando in una struct con un nome per l'insieme così come nomi per le parti, come mostrato nel Listato 5-10.

<span class="filename">Nome file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-10/src/main.rs}}
```

<span class="caption">Listato 5-10: Definire una struct `Rectangle`</span>

Qui abbiamo definito una struct e l'abbiamo chiamata `Rectangle`. All'interno delle parentesi graffe, abbiamo definito i campi come `width` e `height`, entrambi di tipo `u32`. Poi, in `main`, abbiamo creato un'istanza specifica di `Rectangle` che ha una larghezza di `30` e un'altezza di `50`.

La nostra funzione `area` ora è definita con un solo parametro, che abbiamo chiamato
`rectangle`, il cui tipo è un borrow immutabile di un'istanza struct `Rectangle`.
Come accennato nel Capitolo 4, vogliamo prendere in prestito la struct piuttosto che
prendere Ownership di essa. In questo modo, `main` mantiene il suo Ownership e può continuare
a usare `rect1`, che è il motivo per cui usiamo il `&` nella firma della funzione e
dove chiamiamo la funzione.

La funzione `area` accede ai campi `width` e `height` dell'istanza `Rectangle`
(notare che accedere ai campi di un'istanza struct in prestito non
sposta i valori dei campi, motivo per cui spesso si vedono borrow di struct). La nostra
firma della funzione per `area` ora dice esattamente cosa intendiamo: calcolare l'area
di `Rectangle`, usando i suoi campi `width` e `height`. Questo trasmette che
larghezza e altezza sono correlate tra loro e dà nomi descrittivi ai
valori piuttosto che usare gli indici 0 e 1 della tuple. Questo è un vantaggio
per la chiarezza.

### Aggiungere Funzionalità Utile con i Trait Derivati

Sarebbe utile essere in grado di stampare un'istanza di `Rectangle` mentre stiamo
debuggando il nostro programma e vedere i valori di tutti i suoi campi. Il Listato 5-11
prova a usare la macro [`println!`][println]<!-- ignore --> come abbiamo usato nei
capitoli precedenti. Questo, tuttavia, non funzionerà.

<span class="filename">Nome file: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-11/src/main.rs}}
```

<span class="caption">Listato 5-11: Tentativo di stampare un'istanza `Rectangle`</span>

Quando compiliamo questo codice, otteniamo un errore con questo messaggio principale:

```text
{{#include ../listings/ch05-using-structs-to-structure-related-data/listing-05-11/output.txt:3}}
```

La macro `println!` può fare molti tipi di formattazione e, per impostazione predefinita, le
parentesi graffe dicono a `println!` di usare la formattazione conosciuta come `Display`:
output destinato al consumo finale diretto dall'utente. I tipi primitivi che abbiamo visto finora
implementano `Display` per impostazione predefinita perché c'è solo un modo in cui vorresti mostrare
un `1` o qualsiasi altro tipo primitivo a un utente. Ma con le struct, il modo
in cui `println!` dovrebbe formattare l'output è meno chiaro perché ci sono più
possibilità di visualizzazione: Vuoi le virgole o no? Vuoi stampare
le parentesi graffe? Devono essere mostrati tutti i campi? A causa di questa ambiguità, Rust
non cerca di immaginare cosa vogliamo, e le struct non hanno un'implementazione
fornita di `Display` da usare con `println!` e il segnaposto `{}`.

Se continuiamo a leggere gli errori, troveremo questa nota utile:

```text
{{#include ../listings/ch05-using-structs-to-structure-related-data/listing-05-11/output.txt:9:10}}
```

Proviamoci! La chiamata alla macro `println!` ora sembrerà `println!("rect1 is
{rect1:?}");`. Mettere lo specificatore `:?` all'interno delle parentesi graffe dice a
`println!` che vogliamo usare un formato di output chiamato `Debug`. Il Trait `Debug`
ci consente di stampare la nostra struct in modo utile per gli sviluppatori, così possiamo
vederne il valore mentre stiamo facendo debug del nostro codice.

Compila il codice con questa modifica. Accidenti! Riceviamo ancora un errore:

```text
{{#include ../listings/ch05-using-structs-to-structure-related-data/output-only-01-debug/output.txt:3}}
```

Ma ancora una volta, il compilatore ci fornisce una nota utile:

```text
{{#include ../listings/ch05-using-structs-to-structure-related-data/output-only-01-debug/output.txt:9:10}}
```

Rust *include* una funzionalità per stampare informazioni di debug, ma dobbiamo
scegliere esplicitamente di rendere disponibile tale funzionalità per la nostra struct.
Per farlo, aggiungiamo l'attributo esterno `#[derive(Debug)]` subito prima del
la definizione della struct, come mostrato nel Listato 5-12.

<span class="filename">Nome file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-12/src/main.rs}}
```

<span class="caption">Listato 5-12: Aggiungere l'attributo per derivare il Trait
`Debug` e stampare l'istanza di `Rectangle` usando la formattazione di debug</span>

Ora quando eseguiamo il programma, non riceveremo alcun errore e vedremo il
seguente output:

```console
{{#include ../listings/ch05-using-structs-to-structure-related-data/listing-05-12/output.txt}}
```

Bene! Non è l'output più bello, ma mostra i valori di tutti i campi
per questa istanza, che sarebbe sicuramente d'aiuto durante il debug. Quando abbiamo
strutture più grandi, è utile avere un output un po' più facile
da leggere; in quei casi, possiamo usare `{:#?}` invece di `{:?}` nella stringa
`println!`. In questo esempio, usare lo stile `{:#?}` produrrà il seguente output:

```console
{{#include ../listings/ch05-using-structs-to-structure-related-data/output-only-02-pretty-debug/output.txt}}
```

Un altro modo per stampare un valore usando il formato `Debug` è usare la macro [`dbg!`
][dbg]<!-- ignore -->, che prende Ownership di un'espressione (al contrario di
`println!`, che prende un Reference), stampa il file e il numero di riga di
dove quella chiamata di macro `dbg!` si verifica nel tuo codice insieme al valore risultante
di quell'espressione, e restituisce l'Ownership del valore.

> Nota: Chiamare la macro `dbg!` stampa sul flusso console di errore standard
> (`stderr`), al contrario di `println!`, che stampa sul flusso console di output standard (`stdout`).
> Ne parleremo di più su `stderr` e `stdout` nella
> [“Scrivere Messaggi di Errore sull'Errore Standard Anziché sull'Output Standard”
> sezione nel Capitolo 12][err]<!-- ignore -->.

Ecco un esempio in cui siamo interessati al valore che viene assegnato al
campo `width`, così come il valore dell'intera struct in `rect1`:

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/no-listing-05-dbg-macro/src/main.rs}}
```

Possiamo mettere `dbg!` intorno all'espressione `30 * scale` e, poiché `dbg!`
restituisce Ownership del valore dell'espressione, il campo `width` avrà lo
stesso valore come se non avessimo la chiamata `dbg!` lì. Non vogliamo che `dbg!`
prenda Ownership di `rect1`, quindi usiamo un Reference a `rect1` nella chiamata
successiva. Ecco come appare l'output di questo esempio:

```console
{{#include ../listings/ch05-using-structs-to-structure-related-data/no-listing-05-dbg-macro/output.txt}}
```

Possiamo vedere che la prima parte dell'output viene da *src/main.rs* riga 10, dove stiamo
facendo debug dell'espressione `30 * scale`, e il suo valore risultante è `60` (la
formattazione di `Debug` implementata per i numeri interi è di stampare solo il loro valore). La
chiamata `dbg!` sulla riga 14 di *src/main.rs* stampa il valore di `&rect1`, che è
la struct `Rectangle`. Questo output utilizza la formattazione di `Debug` bella del
tipo `Rectangle`. La macro `dbg!` può essere davvero utile quando stai cercando di
capire cosa fa il tuo codice!

Oltre al Trait `Debug`, Rust ci ha fornito una serie di Trait da
usare con l'attributo `derive` che possono aggiungere comportamenti utili ai nostri tipi
personalizzati. Quei Trait e i loro comportamenti sono elencati nell'[Appendice C][app-c]<!--
ignore -->. Tratteremo come implementare questi Trait con comportamenti personalizzati così
come come crearne di propri nel Capitolo 10. Ci sono anche molti
attributi diversi da `derive`; per ulteriori informazioni, vedere
[la sezione “Attributi” della Rust Reference][attributes].

La nostra funzione `area` è molto specifica: calcola solo l'area dei rettangoli.
Sarebbe utile legare questo comportamento più strettamente alla nostra struct `Rectangle`
poiché non funzionerà con nessun altro tipo. Vediamo come possiamo continuare a
rifattorizzare questo codice trasformando la funzione `area` in un metodo `area`
definito sul nostro tipo `Rectangle`.

[the-tuple-type]: ch03-02-data-types.html#the-tuple-type
[app-c]: appendix-03-derivable-traits.md
[println]: ../std/macro.println.html
[dbg]: ../std/macro.dbg.html
[err]: ch12-06-writing-to-stderr-instead-of-stdout.html
[attributes]: ../reference/attributes.html
