## Un esempio di programma che usa Structs

Per comprendere quando potremmo voler utilizzare le strutture, scriviamo un programma che
calcola l'area di un rettangolo. Inizieremo utilizzando singole variabili, e
poi rifattorizzeremo il programma fino a quando useremo le strutture.

Creiamo un nuovo progetto binario con Cargo chiamato *rectangles* che prenderà
la larghezza e l'altezza di un rettangolo specificate in pixel e calcolerà l'area
del rettangolo. L'elenco 5-8 mostra un breve programma con un modo di fare
esattamente questo nel nostro progetto *src/main.rs*.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-08/src/main.rs:all}}
```

<span class="caption">Elenco 5-8: Calcolare l'area di un rettangolo
specificato dalle variabili larghezza e altezza separate</span>

Ora, esegui questo programma usando `cargo run`:

```console
{{#include ../listings/ch05-using-structs-to-structure-related-data/listing-05-08/output.txt}}
```

Questo codice riesce a calcolare l'area del rettangolo chiamando la funzione
`area` con ogni dimensione, ma possiamo fare di più per rendere questo codice chiaro
e leggibile.

Il problema con questo codice è evidente nella firma de `area`:

```rust,ignore
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-08/src/main.rs:here}}
```

La funzione `area` dovrebbe calcolare l'area di un rettangolo, ma la
la funzione che abbiamo scritto ha due parametri, e non è chiaro da nessuna parte nel nostro
programma che i parametri sono correlati. Sarebbe più leggibile e più
gestibile raggruppare larghezza e altezza. Abbiamo già discusso un modo
potremmo farlo in ["Il tipo Tupla"][the-tuple-type]<!-- ignore --> sezione
del Capitolo 3: utilizzando le tuple.

### Rifattorizzazione con le Tuple

L'elenco 5-9 mostra un'altra versione del nostro programma che utilizza le tuple.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-09/src/main.rs}}
```

<span class="caption">Elenco 5-9: Specificare la larghezza e l'altezza del
rettangolo con una tupla</span>

In un certo modo, questo programma è migliore. Le tuple ci permettono di aggiungere un po' di struttura, e
ora passiamo solo un argomento. Ma in un altro modo, questa versione è meno
chiaro: le tuple non nominano i loro elementi, quindi abbiamo che indicizzare nelle parti della
tupla, rendendo meno ovvio il nostro calcolo.

Mescolare la larghezza e l'altezza non avrebbe importanza per il calcolo dell'area, ma se
vogliamo disegnare il rettangolo sullo schermo, avrebbe importanza! Avremmo dovuto
tenere a mente che `width` è l'indice di tupla `0` e `height` è l'indice di tupla
`1`. Questo sarebbe ancora più difficile per qualcun altro da capire e tenere in
mente se fossero per usare il nostro codice. Poiché non abbiamo trasmesso il significato del
nostri dati nel nostro codice, ora è più facile introdurre errori.

### Rifattorizzazione con Structs: Aggiungendo più significato

Utilizziamo le strutture per aggiungere significato etichettando i dati. Possiamo trasformare la tupla
stiamo usando in una struttura con un nome per l'intero così come i nomi per la
parti, come mostrato nell'Elenco 5-10.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-10/src/main.rs}}
```

<span class="caption">Elenco 5-10: Definire una struttura `Rectangle`</span>

Qui abbiamo definito una struttura e l'abbiamo chiamata `Rectangle`. Dentro le parentesi
graffe, abbiamo definito i campi come `width` e `height`, entrambi di tipo `u32`. Quindi, in `main`, abbiamo creato un particolare istanza di `Rectangle`
che ha una larghezza di `30` e un'altezza di `50`.

La nostra funzione `area` è ora definita con un parametro, che abbiamo chiamato
`rectangle`, il cui tipo è un prestito non modificabile di una struttura `Rectangle`
istanza. Come accennato nel Capitolo 4, vogliamo prendere in prestito la struttura piuttosto che
assumere la proprietà di essa. In questo modo,`main` mantiene la sua proprietà e può continuare
usando `rect1`, che è il motivo per cui usiamo l' `&` nella firma della funzione e
dove chiamiamo la funzione.

La funzione `area` accede ai campi `width` e `height` dell'istanza `Rectangle`
(nota che l'accesso ai campi di un'istanza di struct in prestito non
sposta i valori del campo, motivo per cui si vedono spesso prestiti di strutture). Il nostro
La firma della funzione per `area` ora dice esattamente quello che intendiamo: calcola l'area
di `Rectangle`, utilizzando i suoi campi `width` e `height`. Questo trasmette che il
larghezza e altezza sono correlate tra loro, e dà nomi descrittivi a
i valori piuttosto che utilizzare i valori di indice di tupla di `0` e `1`. Questo è un
vittoria per la chiarezza.

### Aggiungendo funzionalità utili con i Traits Derivati

Sarebbe utile poter stampare un'istanza di `Rectangle` mentre stiamo
eseguendo il debug del nostro programma e visualizzare i valori per tutti i suoi campi. L'elenco 5-11 prova
utilizzando la macro [`println!`][println]<!-- ignore --> come abbiamo usato in
capitoli precedenti. Questo, comunque, non funzionerà.

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-11/src/main.rs}}
```

<span class="caption">Elenco 5-11: Tentativo di stampare un'istanza `Rectangle`
</span>

Quando compiliamo questo codice, otteniamo un errore con questo messaggio principale:

```text
{{#include ../listings/ch05-using-structs-to-structure-related-data/listing-05-11/output.txt:3}}
```

La macro `println!` può fare molti tipi di formattazione, e di default, le parentesi graffe dicono a `println!` di usare una formattazione conosciuta come `Display`: output destinato
per il consumo diretto dell'utente finale. I tipi primitivi che abbiamo visto finora
implementano `Display` di default perché c'è solo un modo in cui vorresti mostrare
a `1` o qualsiasi altro tipo primitivo a un utente. Ma con le strutture, il modo
`println!` dovrebbe formattare l'output è meno chiaro perché ci sono più
possibilità di visualizzazione: vuoi virgole o no? Vuoi stampare le
parentesi graffe? Dovrebbero essere mostrati tutti i campi? A causa di questa ambiguità, Rust
non cerca di indovinare cosa vogliamo, e le strutture non hanno una fornita
implementazione di `Display` da usare con `println!` e il segnaposto `{}`.

Se continuiamo a leggere gli errori, troveremo questa nota utile:

```text
{{#include ../listings/ch05-using-structs-to-structure-related-data/listing-05-11/output.txt:9:10}}
```

Proviamoci! La chiamata alla macro `println!` ora sembrerà `println!("rect1 è
{:?}", rect1);`. Mettendo il selettore `:?` all'interno delle parentesi graffe dice
`println!` vogliamo usare un formato di output chiamato `Debug`. Il trait `Debug`
ci consente di stampare la nostra struttura in un modo che è utile per gli sviluppatori quindi possiamo
vedere il suo valore mentre stiamo eseguendo il debug del nostro codice.

Compila il codice con questa modifica. Accidenti! Otteniamo ancora un errore:

```text
{{#include ../listings/ch05-using-structs-to-structure-related-data/output-only-01-debug/output.txt:3}}
```

Ma ancora una volta, il compilatore ci dà una nota utile:

```text
{{#include ../listings/ch05-using-structs-to-structure-related-data/output-only-01-debug/output.txt:9:10}}
```

Rust *include* una funzionalità per stampare le informazioni di debug, ma dobbiamo
decidere esplicitamente di rendere quella funzionalità disponibile per il nostro struct.
Per fare ciò, aggiungiamo l'attributo esterno `#[derive(Debug)]` proprio prima della
definizione del struct, come mostrato nell'Elenco 5-12.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-12/src/main.rs}}
```

<span class="caption">Elenco 5-12: Aggiunta dell'attributo per derivare il `Debug`
trait e stampa dell'istanza `Rectangle` utilizzando la formattazione di debug</span>

Ora quando eseguiamo il programma, non avremo alcun errore, e vedremo il
seguente output:

```console
{{#include ../listings/ch05-using-structs-to-structure-related-data/listing-05-12/output.txt}}
```

Bene! Non è l'output più bello, ma mostra i valori di tutti i campi
per questa istanza, che sarebbe sicuramente utile durante il debugging. Quando abbiamo
struct più grandi, è utile avere un output che sia un po' più facile da leggere; in
quei casi, possiamo usare `{:#?}` invece di `{:?}` nella stringa `println!`. In
questo esempio, utilizzando lo stile `{:#?}` produrrà il seguente output:

```console
{{#include ../listings/ch05-using-structs-to-structure-related-data/output-only-02-pretty-debug/output.txt}}
```

Un altro modo per stampare un valore usando il formato `Debug` è usare il [`dbg!`
macro][dbg]<!-- ignore -->, che prende l'ownership di un'espressione (a differenza di
`println!`, che prende un riferimento), stampa il file e il numero di riga di
dove quella chiamata `dbg!` macro si verifica nel tuo codice insieme al valore risultante
di quell'espressione, e restituisce l'ownership del valore.

> Nota: Chiamare la macro `dbg!` stampa sul flusso della console di errore standard
> (`stderr`), a differenza di `println!`, che stampa sul flusso della console di output standard
> (`stdout`). Parleremo di più su `stderr` e `stdout` nel
> [“Scrivere messaggi di errore su standard error invece di standard output”
> sezione nel Capitolo 12][err]<!-- ignore -->.

Ecco un esempio in cui siamo interessati al valore che viene assegnato al campo 
`width`, così come al valore dell'intero struct in `rect1`:

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/no-listing-05-dbg-macro/src/main.rs}}
```

Possiamo mettere `dbg!` attorno all'espressione `30 * scale` e, poiché `dbg!`
restituisce l'ownership del valore dell'espressione, il campo `width` avrà lo
stesso valore come se non avessimo la chiamata `dbg!` lì. Non vogliamo che `dbg!` prenda
l'ownership di `rect1`, quindi usiamo un riferimento a `rect1` nella chiamata successiva.
Ecco come appare l'output di questo esempio:

```console
{{#include ../listings/ch05-using-structs-to-structure-related-data/no-listing-05-dbg-macro/output.txt}}
```

Possiamo vedere che il primo pezzo di output proviene da *src/main.rs* riga 10 dove stiamo
facendo il debug dell'espressione `30 * scale`, e il suo valore risultante è `60` (il
`Debug` la formattazione implementata per gli interi è stampare solo il loro valore). Il
`dbg!` chiamata alla riga 14 di *src/main.rs* restituisce il valore di `&rect1`, che è
il struct `Rectangle`. Questo output usa la bella formattazione `Debug` del `Rectangle`
tipo. La macro `dbg!` può essere davvero utile quando stai cercando di capire cosa sta facendo 
il tuo codice!

Oltre al trait `Debug`, Rust ha fornito un certo numero di traits per noi
da usare con l'attributo `derive` che può aggiungere un comportamento utile ai nostri tipi
personalizzati. Quei trait e i loro comportamenti sono elencati in [Appendice C][app-c]<!--
ignore -->. Tratteremo come implementare questi trait con comportamento personalizzato così
come come creare i tuoi trait nel Capitolo 10. Ci sono anche molti attributi diversi da `derive`;
per ulteriori informazioni, consultare la sezione “Attributi” del Rust Reference[attributes].

La nostra funzione `area` è molto specifica: calcola solo l'area dei rettangoli.
Sarebbe utile legare questo comportamento più strettamente al nostro struct `Rectangle`
perché non funzionerà con nessun altro tipo. Vediamo come possiamo continuare a
rifattorizzare questo codice trasformando la funzione `area` in un metodo `area`
definito sul nostro tipo `Rectangle`.

[the-tuple-type]: ch03-02-data-types.html#the-tuple-type
[app-c]: appendix-03-derivable-traits.md
[println]: ../std/macro.println.html
[dbg]: ../std/macro.dbg.html
[err]: ch12-06-writing-to-stderr-instead-of-stdout.html
[attributes]: ../reference/attributes.html


