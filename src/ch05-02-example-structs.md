## Un programma di esempio con l'uso di Structs

Per capire quando potremmo voler usare le strutture, scriviamo un programma che
calcola l'area di un rettangolo. Inizieremo a usare singole variabili,
e poi rifattorizzeremo il programma fino a quando usiamo le strutture.

Creiamo un nuovo progetto binario con Cargo chiamato *rectangles* che prenderà
la larghezza e l'altezza di un rettangolo specificato in pixel e calcolerà l'area
del rettangolo. La Lista 5-8 mostra un breve programma con un modo di fare
proprio questo nel *src/main.rs* del nostro progetto.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-08/src/main.rs:all}}
```

<span class="caption">Lista 5-8: Calcolo dell'area di un rettangolo
specificato da variabili separate per larghezza e altezza</span>

Ora, esegui questo programma utilizzando `cargo run`:

```console
{{#include ../listings/ch05-using-structs-to-structure-related-data/listing-05-08/output.txt}}
```

Questo codice riesce a calcolare l'area del rettangolo chiamando il
funzione `area` su ogni dimensione, ma possiamo fare di più per rendere questo codice chiaro
e leggibile.

Il problema con questo codice è evidente nella firma di `area`:

```rust,ignore
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-08/src/main.rs:here}}
```

La funzione `area` è pensata per calcolare l'area di un solo rettangolo, ma il
la funzione che abbiamo scritto ha due parametri, e non è chiaro in nessuna parte del nostro
programma che i parametri sono correlati. Sarebbe più leggibile e più
gestibile raggruppare larghezza e altezza insieme. Abbiamo già discusso un modo
in cui potremmo farlo nella sezione [“Il tipo Tuple”][il-tuple-type]<!-- ignore -->
del Capitolo 3: utilizzando le tuple.

### Rifattorizzazione con le Tuple

La Lista 5-9 mostra un'altra versione del nostro programma che usa le tuple.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-09/src/main.rs}}
```

<span class="caption">Lista 5-9: Specificare la larghezza e l'altezza del
rettangolo con una tupla</span>

In un certo senso, questo programma è migliore. Le tuple ci permettono di aggiungere un po' di struttura, e
ora stiamo passando un solo argomento. Ma in un altro modo, questa versione è meno
chiaro: le tuple non nominano i loro elementi, quindi dobbiamo indicizzare le parti di
la tupla, rendendo il nostro calcolo meno evidente.

Confondere la larghezza e l'altezza non sarebbe un problema per il calcolo dell'area, ma se
vogliamo disegnare il rettangolo sullo schermo, diventa importante! Dovremmo
ricordare che `width` è l'indice della tupla `0` e `height` è l'indice della tupla
`1`. Questo sarebbe ancora più difficile per qualcun altro da capire e da mantenere a
mente se dovessero usare il nostro codice. Poiché non abbiamo trasmesso il significato di
i nostri dati nel nostro codice, ora è più facile introdurre errori.

### Rifattorizzazione con Structs: Aggiungere più Significato

Usiamo le strutture per aggiungere significato etichettando i dati. Possiamo trasformare la tupla
che stiamo utilizzando in una struttura con un nome per il tutto così come nomi per le
parti, come mostrato nella Lista 5-10.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-10/src/main.rs}}
```

<span class="caption">Lista 5-10: Definizione di una struttura `Rectangle`</span>

Qui abbiamo definito una struttura e l'abbiamo chiamata `Rectangle`. All'interno delle parentesi graffe,
abbiamo definito i campi come `width` e `height`, entrambi di tipo `u32`. Poi, in `main`, abbiamo creato una particolare istanza di `Rectangle`
che ha una larghezza di `30` e un'altezza di `50`.

La nostra funzione `area` è ora definita con un parametro, che abbiamo chiamato
`rectangle`, il cui tipo è un prestito immutabile di una istanza struttura `Rectangle`
. Come menzionato nel Capitolo 4, vogliamo prendere in prestito la struttura piuttosto che
assumere la proprietà di essa. In questo modo, `main` mantiene la sua proprietà e può continuare
a usare `rect1`, che è il motivo per cui usiamo il `&` nella firma della funzione e
dove chiamiamo la funzione.

La funzione `area` accede ai campi `width` e `height` dell'istanza `Rectangle`
(notare che l'accesso ai campi di una istanza struttura presa in prestito non
sposta i valori dei campi, motivo per cui si vedono spesso prestiti di strutture). Il nostro
firma della funzione per `area` ora dice esattamente cosa intendiamo: calcolare l'area
di `Rectangle`, utilizzando i suoi campi `width` e `height`. Questo trasmette che il
larghezza e altezza sono correlate tra di loro, e dà nomi descrittivi a
i valori invece di utilizzare i valori dell'indice della tupla `0` e `1`. Questo è un
vittoria per la chiarezza.

### Aggiunta di Funzionalità Utile con Traits Derivate

Sarebbe utile essere in grado di stampare un'istanza di `Rectangle` mentre stiamo
eseguendo il debug del nostro programma e vedere i valori per tutti i suoi campi. La Lista 5-11 prova
a utilizzare la macro [`println!` macro][println]<!-- ignore --> come abbiamo usato in
precedenti capitoli. Questo, comunque, non funzionerà.

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-11/src/main.rs}}
```

<span class="caption">Lista 5-11: Tentativo di stampare un'istanza `Rectangle`
</span>

Quando compiliamo questo codice, otteniamo un errore con questo messaggio principale:

```text
{{#include ../listings/ch05-using-structs-to-structure-related-data/listing-05-11/output.txt:3}}
```

La macro `println!` può fare molti tipi di formattazione, e di default, le parentesi graffe dicono a `println!` di utilizzare la formattazione conosciuta come `Display`: output destinato
per la diretta fruizione dell'utente finale. I tipi primitivi che abbiamo visto fino ad ora
implementare `Display` per impostazione predefinita perché c'è solo un modo in cui vorresti mostrare
un `1` o qualsiasi altro tipo primitivo a un utente. Ma con le strutture, il modo
`println!` dovrebbe formattare l'output è meno chiaro perché ci sono più
possibilità di visualizzazione: Vuoi virgole o no? Si vuole stampare le
parentesi graffe? Dovrebbero essere mostrati tutti i campi? A causa di questa ambiguità, Rust
non cerca di indovinare cosa vogliamo, e le strutture non hanno una fornita
implementazione di `Display` da utilizzare con `println!` e il segnaposto `{}`.

Se continuiamo a leggere gli errori, troveremo questa nota utile:

```text
{{#include ../listings/ch05-using-structs-to-structure-related-data/listing-05-11/output.txt:9:10}}
```

Proviamoci! La chiamata alla macro `println!` ora sembrerà `println!("rect1 è
{:?}", rect1);`. Mettere il specificatore `:?` all'interno delle parentesi graffe dice
a `println!` che vogliamo utilizzare un formato di output chiamato `Debug`. Il `Debug` trait
ci permette di stampare la nostra struttura in un modo utile per gli sviluppatori così possiamo
vedere il suo valore mentre stiamo eseguendo il debug del nostro codice.

Compila il codice con questa modifica. Dannazione! Otteniamo ancora un errore:

```text
{{#include ../listings/ch05-using-structs-to-structure-related-data/output-only-01-debug/output.txt:3}}
```

Ma ancora una volta, il compilatore ci dà una nota utile:

```text
{{#include ../listings/ch05-using-structs-to-structure-related-data/output-only-01-debug/output.txt:9:10}}
```

Rust *include* la funzionalità per stampare le informazioni di debug, ma
dobbiamo esplicitamente optare per rendere questa funzionalità disponibile per la nostra struttura.
Per fare questo, aggiungiamo l'attributo esterno `#[derive(Debug)]` proprio prima del
definizione della struttura, come mostrato nella Lista 5-12.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-12/src/main.rs}}
```

<span class="caption">Lista 5-12: Aggiunta dell'attributo per derivare il `Debug`
trait e stampa dell'istanza `Rectangle` utilizzando la formattazione per il debug</span>

Ora quando eseguiamo il programma, non otterremo errori, e vedremo il
seguente output:

```console
{{#include ../listings/ch05-using-structs-to-structure-related-data/listing-05-12/output.txt}}
```
Ben fatto! Il risultato non è il più bello da vedere, ma mostra i valori di tutti i campi
per questa istanza, il che sarebbe sicuramente utile durante il debugging. Quando abbiamo
struct più grandi, è utile avere un output un po' più facile da leggere; in
quei casi, possiamo usare `{:#?}` invece di `{:?}` nella stringa di `println!`. In
questo esempio, l'uso dello stile `{:#?}` produrrà il seguente output:

```console
{{#include ../listings/ch05-using-structs-to-structure-related-data/output-only-02-pretty-debug/output.txt}}
```

Un altro modo per stampare un valore utilizzando il formato `Debug` è usare il
macro [`dbg!`][dbg]<!-- ignore -->, che prende il proprietario di un'espressione (a differenza 
di `println!`, che prende un riferimento), stampa il file e il numero di riga dove 
si verifica quella chiamata al macro `dbg!` nel tuo codice insieme al risultato 
di quell'espressione, e restituisce l'ownership del valore.

> Nota: La chiamata al macro `dbg!` stampa sullo standard error console stream
> (`stderr`), a differenza di `println!`, che stampa sullo standard output
> console stream (`stdout`). Parleremo di più su `stderr` e `stdout` nel
> [“Writing Error Messages to Standard Error Instead of Standard Output”
> sezione nel Capitolo 12][err]<!-- ignore -->.

Ecco un esempio in cui siamo interessati al valore assegnato al campo
`width`, così come al valore dell'intera struct in `rect1`:

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/no-listing-05-dbg-macro/src/main.rs}}
```

Possiamo mettere `dbg!` attorno all'espressione `30 * scale` e, poiché `dbg!`
restituisce l'ownership del valore dell'espressione, il campo `width` otterrà lo
stesso valore come se non avessimo la chiamata a `dbg!` lì. Non vogliamo che `dbg!`
prenda l'ownership di `rect1`, quindi usiamo un riferimento a `rect1` nella chiamata successiva.
Ecco come appare l'output di questo esempio:

```console
{{#include ../listings/ch05-using-structs-to-structure-related-data/no-listing-05-dbg-macro/output.txt}}
```

Possiamo vedere che il primo pezzo di output proviene da *src/main.rs* linea 10 dove stiamo
facendo il debug dell'espressione `30 * scale`, e il suo valore risultante è `60` (il
formattazione `Debug` implementata per gli interi è di stampare solo il loro valore). La
chiamata a `dbg!` alla riga 14 di *src/main.rs* restituisce il valore di `&rect1`, che è
la struct `Rectangle`. Questo output utilizza la bella formattazione `Debug` del
tipo `Rectangle`. Il macro `dbg!` può essere davvero utile quando stai cercando di
capire cosa sta facendo il tuo codice!

Oltre al trait `Debug`, Rust ha fornito un certo numero di trait per noi
da usare con l'attributo `derive` che può aggiungere comportamenti utili ai nostri tipi personalizzati. Quei trait e i loro comportamenti sono elencati in [Appendice C][app-c]<!--
ignore -->. Vedremo come implementare questi trait con un comportamento personalizzato oltre a come creare i tuoi propri trait nel Capitolo 10. Ci sono anche tanti
attributi oltre a `derive`; per maggiori informazioni, consultare [la sezione "Attributi"
della Referenza Rust][attributes].

La nostra funzione `area` è molto specifica: calcola solo l'area dei rettangoli.
Sarebbe utile legare questo comportamento più strettamente alla nostra struct `Rectangle`
perché non funzionerà con nessun altro tipo. Vediamo come possiamo continuare a
rifattorizzare questo codice trasformando la funzione `area` in un metodo `area`
definito sul nostro tipo `Rectangle`.

[the-tuple-type]: ch03-02-data-types.html#the-tuple-type
[app-c]: appendix-03-derivable-traits.md
[println]: ../std/macro.println.html
[dbg]: ../std/macro.dbg.html
[err]: ch12-06-writing-to-stderr-instead-of-stdout.html
[attributes]: ../reference/attributes.html

