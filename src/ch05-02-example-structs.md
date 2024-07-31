## Un Programma Esempio Usando Struct

Per capire quando potremmo voler usare Struct, scriviamo un programma che
calcola l'area di un rettangolo. Inizieremo usando variabili singole e
poi rifattoreremo il programma fino a usare Struct.

Creiamo un nuovo progetto binario con Cargo chiamato *rectangles* che prenderà
la larghezza e l'altezza di un rettangolo specificato in pixel e calcolerà l'area
del rettangolo. Il Listing 5-8 mostra un breve programma con un modo per fare
esattamente ciò nel file *src/main.rs* del nostro progetto.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-08/src/main.rs:all}}
```

<span class="caption">Listing 5-8: Calcolare l'area di un rettangolo
specificato da variabili larghezza e altezza separate</span>

Ora esegui questo programma usando `cargo run`:

```console
{{#include ../listings/ch05-using-structs-to-structure-related-data/listing-05-08/output.txt}}
```

Questo codice riesce a calcolare l'area del rettangolo chiamando la
funzione `area` con ciascuna dimensione, ma possiamo fare di più per rendere questo codice chiaro
e leggibile.

Il problema con questo codice è evidente nella firma della funzione `area`:

```rust,ignore
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-08/src/main.rs:here}}
```

La funzione `area` dovrebbe calcolare l'area di un solo rettangolo, ma la
funzione che abbiamo scritto ha due parametri, e non è chiaro da nessuna parte nel nostro
programma che i parametri siano correlati. Sarebbe più leggibile e più
gestibile raggruppare larghezza e altezza insieme. Abbiamo già discusso un modo
per farlo nella sezione ["Il Tipo Tuple"](ch03-02-data-types.html#the-tuple-type) del Capitolo 3: usando le tuple.

### Rifattorizzare con Tuple

Il Listing 5-9 mostra un'altra versione del nostro programma che utilizza le tuple.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-09/src/main.rs}}
```

<span class="caption">Listing 5-9: Specificare la larghezza e l'altezza del
rettangolo con una tupla</span>

In un certo senso, questo programma è migliore. Le tuple ci permettono di aggiungere un po' di struttura, e
ora stiamo passando solo un argomento. Ma in un altro modo, questa versione è meno
chiara: le tuple non nominano i loro elementi, quindi dobbiamo indicizzare le parti della
tupla, rendendo il nostro calcolo meno ovvio.

Confondere la larghezza e l'altezza non importerebbe per il calcolo dell'area, ma se
vogliamo disegnare il rettangolo sullo schermo, importerebbe! Dovremmo tener a mente che `width` è
l'indice di tupla `0` e `height` è l'indice di tupla `1`. Questo sarebbe ancora più difficile per qualcun altro da capire e tenere a mente se usasse il nostro codice. Poiché non abbiamo trasmesso il significato dei nostri dati nel codice, è ora più facile introdurre errori.

### Rifattorizzare con Struct: Aggiungere Più Significato

Usiamo Struct per aggiungere significato etichettando i dati. Possiamo trasformare la tupla
che stiamo usando in una Struct con un nome per l'intero così come nomi per le
parti, come mostrato nel Listing 5-10.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-10/src/main.rs}}
```

<span class="caption">Listing 5-10: Definire una Struct `Rectangle`</span>

Qui abbiamo definito una Struct e l'abbiamo chiamata `Rectangle`. Dentro le parentesi graffe,
abbiamo definito i campi come `width` e `height`, entrambi di tipo `u32`. Poi, in `main`, abbiamo creato una particolare istanza di `Rectangle` che ha una larghezza di `30` e un'altezza di `50`.

La nostra funzione `area` è ora definita con un parametro, che abbiamo chiamato
`rectangle`, il cui tipo è un prestito immutabile di una istanza di `Rectangle`.
Come menzionato nel Capitolo 4, vogliamo prendere in prestito la Struct piuttosto che prendere proprietà di essa. In questo modo, `main` mantiene la sua proprietà e può continuare a usare `rect1`, il che è il motivo per cui usiamo `&` nella firma della funzione e
dove chiamiamo la funzione.

La funzione `area` accede ai campi `width` e `height` della
istanza `Rectangle` (nota che accedere ai campi di una istanza di Struct presa in prestito non
sposta i valori dei campi, motivo per cui spesso si vedono prestiti di Struct). La nostra
firma della funzione per `area` ora dice esattamente cosa intendiamo: calcolare l'area
di `Rectangle`, usando i suoi campi `width` e `height`. Questo comunica che
la larghezza e l'altezza sono correlate tra loro, e dà nomi descrittivi ai
valori piuttosto che usare i valori di indice della tupla `0` e `1`. È una vittoria
per la chiarezza.

### Aggiungere Funzionalità Utili con i Trait Derivati

Sarebbe utile poter stampare un'istanza di `Rectangle` mentre stiamo
debuggando il nostro programma e vedere i valori di tutti i suoi campi. Il Listing 5-11 cerca
di usare la [macro `println!`][println]<!-- ignore --> come abbiamo fatto nei
capitoli precedenti. Questo però non funzionerà.

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-11/src/main.rs}}
```

<span class="caption">Listing 5-11: Tentativo di stampare un'istanza di `Rectangle`</span>

Quando compiliamo questo codice, otteniamo un errore con questo messaggio centrale:

```text
{{#include ../listings/ch05-using-structs-to-structure-related-data/listing-05-11/output.txt:3}}
```

La macro `println!` può fare molti tipi di formattazione, e per impostazione predefinita, le parentesi
graffe indicano a `println!` di usare formattazione nota come `Display`: output previsto
per il consumo diretto dell'utente finale. I tipi primitivi che abbiamo visto finora
implementano `Display` per impostazione predefinita perché c'è solo un modo in cui si vorrebbe
mostrare un `1` o qualsiasi altro tipo primitivo a un utente. Ma con le Struct, il modo in cui
`println!` dovrebbe formattare l'output è meno chiaro perché ci sono più
possibilità di visualizzazione: vuoi virgole o no? Vuoi stampare le parentesi
graffe? Dovrebbero essere mostrati tutti i campi? A causa di questa ambiguità, Rust
non cerca di indovinare cosa vogliamo, e le Struct non hanno un'implementazione
fornita di `Display` da usare con `println!` e il segnaposto `{}`.

Se continuiamo a leggere gli errori, troveremo questa nota utile:

```text
{{#include ../listings/ch05-using-structs-to-structure-related-data/listing-05-11/output.txt:9:10}}
```

Proviamolo! La chiamata alla macro `println!` sembrerà ora `println!("rect1 è
{rect1:?}");`. Mettere lo specificatore `:?` dentro le parentesi graffe indica a
`println!` che vogliamo usare un formato di output chiamato `Debug`. Il Trait `Debug`
ci consente di stampare la nostra Struct in un modo utile per gli sviluppatori, così possiamo
vedere il suo valore mentre stiamo debugando il nostro codice.

Compila il codice con questo cambiamento. Maledizione! Riceviamo ancora un errore:

```text
{{#include ../listings/ch05-using-structs-to-structure-related-data/output-only-01-debug/output.txt:3}}
```

Ma ancora, il compilatore ci dà una nota utile:

```text
{{#include ../listings/ch05-using-structs-to-structure-related-data/output-only-01-debug/output.txt:9:10}}
```

Rust *inclus* la funzionalità per stampare informazioni di debugging, ma dobbiamo
optare esplicitamente per rendere disponibile quella funzionalità per la nostra Struct.
Per farlo, aggiungiamo l'attributo esterno `#[derive(Debug)]` appena prima della
definizione della Struct, come mostrato nel Listing 5-12.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-12/src/main.rs}}
```

<span class="caption">Listing 5-12: Aggiunta dell'attributo per derivare il Trait `Debug` e stampa dell'istanza di `Rectangle` usando la formattazione per il debug</span>

Ora quando eseguiamo il programma, non otterremo errori, e vedremo il
seguente output:

```console
{{#include ../listings/ch05-using-structs-to-structure-related-data/listing-05-12/output.txt}}
```

Bello! Non è l'output più bello, ma mostra i valori di tutti i campi
di questa istanza, il che sarebbe sicuramente utile durante il debugging. Quando abbiamo
Struct più grandi, è utile avere un output un po' più facile da leggere; in
questi casi, possiamo usare `{:#?}` invece di `{:?}` nella stringa di `println!`. In
questo esempio, usando lo stile `{:#?}` si otterrà il seguente output:

```console
{{#include ../listings/ch05-using-structs-to-structure-related-data/output-only-02-pretty-debug/output.txt}}
```

Un altro modo per stampare un valore usando il formato `Debug` è usare la [macro `dbg!`][dbg]<!-- ignore -->, che prende proprietà di un'espressione (a differenza di `println!`, che prende un riferimento), stampa il file e il numero di riga dove quella chiamata alla macro `dbg!` si verifica nel codice insieme al valore risultante
di quella espressione, e restituisce la proprietà del valore.

> Nota: Chiamare la macro `dbg!` stampa allo stream del console error standard (stderr), al contrario di `println!`, che stampa allo stream del console output standard (stdout). Parleremo di più di `stderr` e `stdout` nella [sezione "Scrittura di Messaggi di Errore su Error Standard invece di Output Standard" nel Capitolo 12][err]<!-- ignore -->.

Ecco un esempio dove siamo interessati al valore che viene assegnato al campo `width`, così come il valore della intera Struct in `rect1`:

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/no-listing-05-dbg-macro/src/main.rs}}
```

Possiamo mettere `dbg!` intorno all'espressione `30 * scale` e, poiché `dbg!`
restituisce la proprietà del valore dell'espressione, il campo `width` otterrà lo
stesso valore come se non avessimo la chiamata `dbg!` lì. Non vogliamo che `dbg!`
prenda la proprietà di `rect1`, quindi usiamo un riferimento a `rect1` nella chiamata successiva.
Ecco come appare l'output di questo esempio:

```console
{{#include ../listings/ch05-using-structs-to-structure-related-data/no-listing-05-dbg-macro/output.txt}}
```

Possiamo vedere che il primo pezzo di output viene da *src/main.rs* linea 10 dove stiamo
debuggando l'espressione `30 * scale`, e il suo valore risultante è `60` (la formattazione `Debug` implementata per gli interi è stampare solo il loro valore). La chiamata a `dbg!` sulla linea 14 di *src/main.rs* stampa il valore di `&rect1`, che è
la Struct `Rectangle`. Questo output usa la formattazione `Debug` "pretty" del tipo
`Rectangle`. La macro `dbg!` può essere molto utile quando stai cercando di
capire cosa sta facendo il tuo codice!

Oltre al Trait `Debug`, Rust ha fornito diversi Traits da usare con l'attributo `derive` che possono aggiungere comportamento utile ai nostri tipi personalizzati. Quei Traits e i loro comportamenti sono elencati in [Appendice C][app-c]<!-- ignore -->. Tratteremo come implementare questi Traits con comportamento personalizzato così come come creare i tuoi Traits nel Capitolo 10. Ci sono anche molti attributi diversi da `derive`; per ulteriori informazioni, consulta la [sezione "Attributi" del Riferimento Rust][attributes].

La nostra funzione `area` è molto specifica: calcola solo l'area dei rettangoli.
Sarebbe utile legare questo comportamento più strettamente alla nostra Struct `Rectangle`
perché non funzionerà con nessun altro tipo. Vediamo come possiamo continuare a
refattorizzare questo codice trasformando la funzione `area` in un metodo *area*
definito sul nostro tipo `Rectangle`.

[the-tuple-type]: ch03-02-data-types.html#the-tuple-type
[app-c]: appendix-03-derivable-traits.md
[println]: ../std/macro.println.html
[dbg]: ../std/macro.dbg.html
[err]: ch12-06-writing-to-stderr-instead-of-stdout.html
[attributes]: ../reference/attributes.html
