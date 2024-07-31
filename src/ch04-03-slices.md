## Il Tipo Slice

Le *Slices* ti permettono di riferirti a una sequenza contigua di elementi in una
[collezione](ch08-00-common-collections.md) piuttosto che a tutta la collezione. Una
slice è un tipo di riferimento, quindi non ha ownership.

Ecco un piccolo problema di programmazione: scrivi una funzione che prende una stringa di
parole separate da spazi e restituisce la prima parola che trova in quella stringa.
Se la funzione non trova uno spazio nella stringa, tutta la stringa deve essere
una parola, quindi deve restituire l'intera stringa.

Vediamo come scrivere la firma di questa funzione senza usare slices, per comprendere il problema che le slices risolvono:

```rust,ignore
fn first_word(s: &String) -> ?
```

La funzione `first_word` ha un parametro `&String`. Non vogliamo ownership, quindi questo va bene. Ma cosa dovremmo restituire? Non abbiamo davvero un modo per parlare di *parte* di una stringa. Tuttavia, potremmo restituire l'indice della fine della parola, indicato da uno spazio. Proviamoci, come mostrato nel Listing 4-7.

<span class="filename">Filename: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/listing-04-07/src/main.rs:here}}
```

<span class="caption">Listing 4-7: La funzione `first_word` che restituisce un
valore di indice in byte nel parametro `String`</span>

Poiché dobbiamo attraversare l'elemento `String` elemento per elemento e controllare se
un valore è uno spazio, convertiremo la nostra `String` in un array di byte usando il
metodo `as_bytes`.

```rust,ignore
{{#rustdoc_include ../listings/ch04-understanding-ownership/listing-04-07/src/main.rs:as_bytes}}
```

Successivamente, creiamo un iteratore sull'array di byte usando il metodo `iter`:

```rust,ignore
{{#rustdoc_include ../listings/ch04-understanding-ownership/listing-04-07/src/main.rs:iter}}
```

Discuteremo gli iteratori in maggior dettaglio nel [Capitolo 13][ch13]<!-- ignore -->.
Per ora, sappi che `iter` è un metodo che restituisce ogni elemento in una collezione
e che `enumerate` avvolge il risultato di `iter` e restituisce ciascun elemento come
parte di una tupla invece. Il primo elemento della tupla restituita da
`enumerate` è l'indice, e il secondo elemento è un riferimento all'elemento.
Questo è un po' più conveniente che calcolare l'indice da soli.

Poiché il metodo `enumerate` restituisce una tupla, possiamo usare i pattern per
decomporre quella tupla. Discuteremo i pattern più dettagliatamente nel [Capitolo
6][ch6]<!-- ignore -->. Nel ciclo `for`, specifichiamo un pattern che ha `i`
per l'indice nella tupla e `&item` per il singolo byte nella tupla.
Poiché otteniamo un riferimento all'elemento da `.iter().enumerate()`, usiamo
`&` nel pattern.

All'interno del ciclo `for`, cerchiamo il byte che rappresenta lo spazio usando
la sintassi del byte letterale. Se troviamo uno spazio, restituiamo la posizione.
Altrimenti, restituiamo la lunghezza della stringa usando `s.len()`.

```rust,ignore
{{#rustdoc_include ../listings/ch04-understanding-ownership/listing-04-07/src/main.rs:inside_for}}
```

Ora abbiamo un modo per trovare l'indice della fine della prima parola nella
stringa, ma c'è un problema. Stiamo restituendo un `usize` da solo, ma è solo
un numero significativo nel contesto di `&String`. In altre parole,
poiché è un valore separato dalla `String`, non c'è garanzia che sarà ancora
valido in futuro. Considera il programma nel Listing 4-8 che
usa la funzione `first_word` dal Listing 4-7.

<span class="filename">Filename: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/listing-04-08/src/main.rs:here}}
```

<span class="caption">Listing 4-8: Memorizzare il risultato della chiamata alla
funzione `first_word` e poi cambiare il contenuto della `String`</span>

Questo programma compila senza errori e lo farebbe anche se usassimo `word`
dopo aver chiamato `s.clear()`. Poiché `word` non è collegato affatto allo stato di `s`,
`word` contiene ancora il valore `5`. Potremmo usare quel valore `5` con la
variabile `s` per cercare di estrarre la prima parola, ma questo sarebbe un bug
perché il contenuto di `s` è cambiato da quando abbiamo salvato `5` in `word`.

Doversi preoccupare dell'indice in `word` che si disallinea con i dati in
`s` è tedioso e soggetto a errori! La gestione di questi indici è ancora
più fragile se scriviamo una funzione `second_word`. La sua firma dovrebbe assomigliare a questa:

```rust,ignore
fn second_word(s: &String) -> (usize, usize) {
```

Ora stiamo tracciando un indice di inizio *e* un indice di fine, e abbiamo ancora più
valori che sono stati calcolati da dati in uno stato particolare ma non sono affatto legati
a quello stato. Abbiamo tre variabili non correlate che devono essere mantenute sincronizzate.

Per fortuna, Rust ha una soluzione a questo problema: le slices di stringa.

### Slices di Stringa

Una *string slice* è un riferimento a una parte di una `String`, e appare così:

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-17-slice/src/main.rs:here}}
```

Piuttosto che un riferimento all'intera `String`, `hello` è un riferimento a una
porzione della `String`, specificato nella parte aggiuntiva `[0..5]`. Creiamo le slices
utilizzando un intervallo tra parentesi specificando `[starting_index..ending_index]`,
dove `starting_index` è la prima posizione nella slice e `ending_index` è uno
in più rispetto all'ultima posizione nella slice. Internamente, la struttura dati della slice
memorizza la posizione iniziale e la lunghezza della slice, che
corrisponde a `ending_index` meno `starting_index`. Quindi, nel caso di `let
world = &s[6..11];`, `world` sarebbe una slice che contiene un puntatore al
byte all'indice 6 di `s` con un valore di lunghezza di `5`.

Figura 4-6 mostra questo in un diagramma.

<img alt="Tre tabelle: una tabella che rappresenta i dati nello stack di s, che punta
al byte all'indice 0 in una tabella dei dati della stringa &quot;hello world&quot; sul heap. La terza tabella
rappresenta i dati nello stack della slice world, che ha un valore di lunghezza di 5 e punta al byte 6
della tabella dei dati sul heap." src="img/trpl04-06.svg" class="center" style="width: 50%;" />

<span class="caption">Figura 4-6: Slice di stringa che si riferisce a una parte di una
`String`</span>

Con la sintassi di intervallo `..` di Rust, se vuoi iniziare dall'indice 0, puoi omettere
il valore prima dei due punti. In altre parole, questi sono uguali:

```rust
let s = String::from("hello");

let slice = &s[0..2];
let slice = &s[..2];
```

Allo stesso modo, se la tua slice include l'ultimo byte della `String`, puoi
omettere il numero finale. Questo significa che questi sono uguali:

```rust
let s = String::from("hello");

let len = s.len();

let slice = &s[3..len];
let slice = &s[3..];
```

Puoi anche omettere entrambi i valori per prendere una slice dell'intera stringa.
Quindi questi sono uguali:

```rust
let s = String::from("hello");

let len = s.len();

let slice = &s[0..len];
let slice = &s[..];
```

> Nota: Gli indici di intervallo delle slices devono trovarsi ai confini di caratteri
> validi UTF-8. Se tenti di creare una slice di stringa nel mezzo di un
> carattere multibyte, il tuo programma terminerà con un errore. Ai fini di
> introdurre le slices di stringa, stiamo assumendo solo ASCII in questa sezione; una
> discussione più approfondita della gestione di UTF-8 si trova nella sezione
> [“Memorizzare Testo Codificato UTF-8 con le Stringhe”][strings]<!-- ignore --> del Capitolo 8.

Con tutte queste informazioni in mente, riscriviamo `first_word` per restituire una
slice. Il tipo che rappresenta “slice di stringa” è scritto come `&str`:

<span class="filename">Filename: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-18-first-word-slice/src/main.rs:here}}
```

Otteniamo l'indice per la fine della parola allo stesso modo in cui abbiamo fatto nel Listing 4-7, cercando la prima occorrenza di uno spazio. Quando troviamo uno spazio, restituiamo una slice di stringa utilizzando l'inizio della stringa e l'indice dello spazio come indici iniziale e finale.

Ora, quando chiamiamo `first_word`, otteniamo un singolo valore che è legato ai dati sottostanti. Il valore è composto da un riferimento al punto di partenza della slice e dal numero di elementi nella slice.

Restituire una slice funzionerebbe anche per una funzione `second_word`:

```rust,ignore
fn second_word(s: &String) -> &str {
```

Ora abbiamo un'API semplice che è molto più difficile da sbagliare perché
il compilatore garantirà che i riferimenti nella `String` rimangano validi. Ricorda
il bug nel programma nel Listing 4-8, quando abbiamo ottenuto l'indice per la fine della
prima parola ma poi abbiamo svuotato la stringa così il nostro indice era invalido? Quel codice era
logicamente errato ma non mostrava errori immediati. I problemi si sarebbero presentati
più tardi se avessimo continuato a usare l'indice della prima parola con una stringa svuotata.
Le slices rendono impossibile questo bug e ci fanno sapere di avere un problema con
il nostro codice molto prima. Utilizzare la versione a slice di `first_word` lancerà un
errore in fase di compilazione:

<span class="filename">Filename: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-19-slice-error/src/main.rs:here}}
```

Ecco l'errore del compilatore:

```console
{{#include ../listings/ch04-understanding-ownership/no-listing-19-slice-error/output.txt}}
```

Ricorda dalle regole del borrowing che se abbiamo un riferimento immutabile a
qualcosa, non possiamo anche prendere un riferimento mutabile. Poiché `clear` deve
truncare la `String`, ha bisogno di ottenere un riferimento mutabile. Il `println!`
dopo la chiamata a `clear` usa il riferimento in `word`, quindi il riferimento
immutabile deve essere ancora attivo a quel punto. Rust non permette che il riferimento mutabile in `clear` e il riferimento immutabile in `word` esistano
contemporaneamente, e la compilazione fallisce. Non solo Rust ha reso la nostra API più facile da usare,
ma ha anche eliminato un'intera classe di errori in fase di compilazione!

<!-- Vecchio titolo. Non rimuovere altrimenti i link potrebbero rompersi. -->
<a id="string-literals-are-slices"></a>

#### String Literals come Slices

Ricorda che abbiamo parlato di stringhe letterali memorizzate all'interno del binario. Ora che sappiamo delle slices, possiamo comprendere correttamente le stringhe letterali:

```rust
let s = "Hello, world!";
```

Il tipo di `s` qui è `&str`: è una slice che punta a quel punto specifico del binario. Questo è anche il motivo per il quale le stringhe letterali sono immutabili; `&str` è un
riferimento immutabile.

#### Slices di Stringa come Parametri

Sapere che puoi prendere slices di letterali e valori `String` ci porta
a un altro miglioramento su `first_word`, ed è la sua firma:

```rust,ignore
fn first_word(s: &String) -> &str {
```

Un Rustacean più esperto scriverebbe la firma mostrata nel Listing 4-9
invece perché ci permette di usare la stessa funzione sia su valori `&String`
che `&str`.

```rust,ignore
{{#rustdoc_include ../listings/ch04-understanding-ownership/listing-04-09/src/main.rs:here}}
```

<span class="caption">Listing 4-9: Miglioramento della funzione `first_word` usando
una slice di stringa per il tipo del parametro `s`</span>

Se abbiamo una slice di stringa, possiamo passarla direttamente. Se abbiamo una `String`, possiamo passare una slice della `String` o un riferimento alla `String`. Questa
flessibilità sfrutta le *deref coercions*, una caratteristica che copriremo nella sezione
[“Coercizioni Deref Implicite con Funzioni e Metodi”][deref-coercions]<!--ignore--> del Capitolo 15.

Definire una funzione per prendere una slice di stringa invece di un riferimento a una `String`
rende la nostra API più generale e utile senza perdere alcuna funzionalità:

<span class="filename">Filename: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/listing-04-09/src/main.rs:usage}}
```

### Altre Slices

Le slices di stringa, come puoi immaginare, sono specifiche per le stringhe. Ma esiste anche un tipo di slice più generale. Considera questo array:

```rust
let a = [1, 2, 3, 4, 5];
```

Così come potremmo voler riferirci a una parte di una stringa, potremmo voler riferirci a una parte di un array. Lo faremmo così:

```rust
let a = [1, 2, 3, 4, 5];

let slice = &a[1..3];

assert_eq!(slice, &[2, 3]);
```

Questa slice ha il tipo `&[i32]`. Funziona allo stesso modo delle slices di stringa, memorizzando un riferimento al primo elemento e una lunghezza. Userai questo tipo di slice per tutti i tipi di altre collezioni. Discuteremo queste collezioni in
dettaglio quando parleremo dei vettori nel Capitolo 8.

## Riepilogo

I concetti di ownership, borrowing e slices garantiscono la sicurezza della memoria nei programmi Rust in fase di compilazione. Il linguaggio Rust ti dà il controllo sull'uso della memoria allo stesso modo di altri linguaggi di programmazione di sistemi, ma avere il proprietario dei dati che automaticamente ripulisce quei dati quando il proprietario esce dallo Scope significa che non devi scrivere e debugare codice extra per ottenere questo controllo.

L'ownership influisce sul funzionamento di molte altre parti di Rust, quindi parleremo di
questi concetti ulteriormente nel resto del libro. Passiamo al
Capitolo 5 e vediamo come raggruppare pezzi di dati insieme in uno `struct`.

[ch13]: ch13-02-iterators.html
[ch6]: ch06-02-match.html#patterns-that-bind-to-values
[strings]: ch08-02-strings.html#storing-utf-8-encoded-text-with-strings
[deref-coercions]: ch15-02-deref.html#implicit-deref-coercions-with-functions-and-methods
