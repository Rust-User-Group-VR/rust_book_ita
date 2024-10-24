## Il Tipo Slice

Le *Slices* ti permettono di fare riferimento a una sequenza contigua di elementi in una
[collezione](ch08-00-common-collections.md) anziché all'intera collezione. Una
slice è un tipo di riferimento, quindi non ha ownership.

Ecco un piccolo problema di programmazione: scrivi una funzione che prenda una stringa di
parole separate da spazi e restituisca la prima parola trovata in quella stringa.
Se la funzione non trova uno spazio nella stringa, l'intera stringa deve essere
una parola, quindi l'intera stringa dovrebbe essere restituita.

Vediamo come scriveremmo la firma di questa funzione senza usare
slices, per capire il problema che le slices risolveranno:

```rust,ignore
fn first_word(s: &String) -> ?
```

La funzione `first_word` ha un `&String` come parametro. Non vogliamo
ownership, quindi questo va bene. Ma cosa dovremmo restituire? Non abbiamo davvero un
modo per parlare di *parte* di una stringa. Tuttavia, potremmo restituire l'indice della
fine della parola, indicato da uno spazio. Proviamoci, come mostrato nell'Elenco 4-7.

<span class="filename">Nome file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/listing-04-07/src/main.rs:here}}
```

<span class="caption">Elenco 4-7: La funzione `first_word` che restituisce un
valore di indice di byte nel parametro `String`</span>

Poiché dobbiamo attraversare il `String` elemento per elemento e verificare se
un valore è uno spazio, convertiremo il nostro `String` in un array di byte usando il
metodo `as_bytes`.

```rust,ignore
{{#rustdoc_include ../listings/ch04-understanding-ownership/listing-04-07/src/main.rs:as_bytes}}
```

Successivamente, creiamo un iteratore sull'array di byte usando il metodo `iter`:

```rust,ignore
{{#rustdoc_include ../listings/ch04-understanding-ownership/listing-04-07/src/main.rs:iter}}
```

Discuteremo degli iteratori in maggior dettaglio nel [Capitolo 13][ch13]<!-- ignore -->.
Per ora, sappi che `iter` è un metodo che restituisce ciascun elemento in una collezione
e che `enumerate` avvolge il risultato di `iter` e restituisce ciascun elemento come
parte di una tupla invece. Il primo elemento della tupla restituita da
`enumerate` è l'indice, e il secondo elemento è un riferimento all'elemento.
Questo è un po' più conveniente rispetto a calcolare l'indice noi stessi.

Poiché il metodo `enumerate` restituisce una tupla, possiamo usare le patterns per
distruggere quella tupla. Discuteremo di più sui patterns nel [Capitolo
6][ch6]<!-- ignore -->. Nel `for` loop, specifichiamo un pattern che ha `i`
per l'indice nella tupla e `&item` per il singolo byte nella tupla.
Poiché otteniamo un riferimento all'elemento da `.iter().enumerate()`, usiamo
`&` nel pattern.

All'interno del `for` loop, cerchiamo il byte che rappresenta lo spazio usando
la sintassi del byte letterale. Se troviamo uno spazio, restituiamo la posizione.
Altrimenti, restituiamo la lunghezza della stringa usando `s.len()`.

```rust,ignore
{{#rustdoc_include ../listings/ch04-understanding-ownership/listing-04-07/src/main.rs:inside_for}}
```

Ora abbiamo un modo per scoprire l'indice della fine della prima parola nella
stringa, ma c'è un problema. Stiamo restituendo un `usize` da solo, ma è
solo un numero significativo nel contesto del `&String`. In altre parole,
poiché è un valore separato dalla `String`, non c'è garanzia che
sarà ancora valido in futuro. Considera il programma nell'Elenco 4-8 che
usa la funzione `first_word` dell'Elenco 4-7.

<span class="filename">Nome file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/listing-04-08/src/main.rs:here}}
```

<span class="caption">Elenco 4-8: Memorizzare il risultato della chiamata alla
funzione `first_word` e poi cambiare i contenuti del `String`</span>

Questo programma compila senza errori e lo farebbe anche se usassimo `word`
dopo aver chiamato `s.clear()`. Poiché `word` non è collegato allo stato di `s`
affatto, `word` contiene ancora il valore `5`. Potremmo usare quel valore `5` con
la variabile `s` per provare a estrarre la prima parola, ma questo sarebbe un bug
poiché i contenuti di `s` sono cambiati da quando abbiamo salvato `5` in `word`.

Doversi preoccupare che l'indice in `word` non sia sincronizzato con i dati in `s`
è noioso e soggetto a errori! Gestire questi indici è ancora più fragile se
scriviamo una funzione `second_word`. La sua firma dovrebbe avere questo aspetto:

```rust,ignore
fn second_word(s: &String) -> (usize, usize) {
```

Ora stiamo tenendo traccia di un indice di inizio *e* uno di fine, e abbiamo ancora più
valori che sono stati calcolati dai dati in uno stato particolare ma non sono legati
a quello stato. Abbiamo tre variabili non correlate in giro che devono essere
mantenute sincronizzate.

Fortunatamente, Rust ha una soluzione a questo problema: le string slice.

### Le String Slice

Una *string slice* è un riferimento a parte di una `String`, e appare così:

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-17-slice/src/main.rs:here}}
```

Piuttosto che un riferimento all'intero `String`, `hello` è un riferimento a una
porzione del `String`, specificato nella parte extra `[0..5]`. Creiamo slices
usando un intervallo all'interno delle parentesi specificando `[starting_index..ending_index]`,
dove `starting_index` è la prima posizione nella slice e `ending_index` è
un numero maggiore dell'ultima posizione nella slice. Internamente, la struttura di dati della
slice memorizza la posizione di inizio e la lunghezza della slice, che
corrisponde a `ending_index` meno `starting_index`. Quindi, nel caso di `let
world = &s[6..11];`, `world` sarebbe una slice che contiene un puntatore al
byte all'indice 6 di `s` con una lunghezza di `5`.

La Figura 4-6 mostra questo in un diagramma.

<img alt="Tre tabelle: una tabella che rappresenta i dati dello stack di s, che punta
al byte all'indice 0 in una tabella dei dati della stringa &quot;hello world&quot; nello
heap. La terza tabella rappresenta i dati dello stack della slice world, che
ha un valore di lunghezza di 5 e punta al byte 6 della tabella dei dati dell'heap."
src="img/trpl04-06.svg" class="center" style="width: 50%;" />

<span class="caption">Figura 4-6: String slice riferendosi a parte di una
`String`</span>

Con la sintassi di intervallo `..` di Rust, se vuoi iniziare all'indice 0, puoi omettere
il valore prima dei due punti. In altre parole, questi sono uguali:

```rust
let s = String::from("hello");

let slice = &s[0..2];
let slice = &s[..2];
```

Allo stesso modo, se la tua slice include l'ultimo byte del `String`, puoi omettere
il numero finale. Ciò significa che questi sono uguali:

```rust
let s = String::from("hello");

let len = s.len();

let slice = &s[3..len];
let slice = &s[3..];
```

Puoi anche omettere entrambi i valori per prendere una slice dell'intera stringa. Quindi questi
sono uguali:

```rust
let s = String::from("hello");

let len = s.len();

let slice = &s[0..len];
let slice = &s[..];
```

> Nota: Gli indici di intervallo delle String slice devono trovarsi a confini di caratteri UTF-8 validi. Se tenti di creare una string slice nel mezzo di un
> carattere multibyte, il tuo programma terminerà con un errore. Ai fini di
> introdurre le string slice, stiamo assumendo solo ASCII in questa sezione; una
> discussione più approfondita sulla gestione UTF-8 è nella sezione [“Memorizzare Testo Codificato UTF-8 con Stringhe”][strings]<!-- ignore --> del Capitolo 8.

Con tutte queste informazioni in mente, riscriviamo `first_word` per restituire una
slice. Il tipo che indica “string slice” è scritto come `&str`:

<span class="filename">Nome file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-18-first-word-slice/src/main.rs:here}}
```

Otteniamo l'indice per la fine della parola allo stesso modo in cui abbiamo fatto nell'Elenco 4-7, cercando la prima ocorrenza di spazio. Quando troviamo uno spazio, restituiamo una string slice usando l'inizio della stringa e l'indice dello spazio come indici di inizio e fine.

Ora, quando chiamiamo `first_word`, otteniamo un singolo valore che è legato ai dati sottostanti. Il valore è composto da un riferimento al punto di inizio della slice e il numero di elementi nella slice.

Restituire una slice funzionerebbe anche per una funzione `second_word`:

```rust,ignore
fn second_word(s: &String) -> &str {
```

Abbiamo ora un'API semplice che è molto più difficile da mettere male perché
il compilatore assicurerà che i riferimenti nella `String` rimangano validi. Ricorda
il bug nel programma nell'Elenco 4-8, quando abbiamo ottenuto l'indice alla fine
della prima parola ma poi abbiamo svuotato la stringa, quindi il nostro indice non era più valido? Quel codice era logicamente scorretto ma non mostrava errori immediati. I problemi
si manifesterebbero più tardi se avessimo continuato a usare l'indice della prima parola
con una stringa vuota. Le slices rendono impossibile questo bug e ci fanno sapere
che abbiamo un problema con il nostro codice molto prima. Usare la versione con slice di `first_word` genererà un errore di compilazione:

<span class="filename">Nome file: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-19-slice-error/src/main.rs:here}}
```

Ecco l'errore del compilatore:

```console
{{#include ../listings/ch04-understanding-ownership/no-listing-19-slice-error/output.txt}}
```

Ricorda dalle regole del borrowing che se abbiamo un riferimento immutabile a
qualcosa, non possiamo anche prendere un riferimento mutable. Poiché `clear` ha bisogno
di troncare il `String`, ha bisogno di ottenere un riferimento mutable. Il `println!`
dopo la chiamata a `clear` usa il riferimento in `word`, quindi il riferimento
immutabile deve essere ancora attivo a quel punto. Rust non permette che esistano
allo stesso tempo il riferimento mutable in `clear` e il riferimento immutabile in `word`,
e la compilazione fallisce. Non solo Rust ha reso la nostra API più facile da usare,
ma ha anche eliminato un'intera classe di errori al momento della compilazione!

<!-- Vecchio titolo. Non rimuovere o i link potrebbero rompersi. -->
<a id="string-literals-are-slices"></a>

#### I Letterali di Stringa come Slices

Ricorda che abbiamo parlato di letterali di stringa memorizzati all'interno del binary. Ora che conosciamo le slices, possiamo capire correttamente i letterali di stringa:

```rust
let s = "Hello, world!";
```

Il tipo di `s` qui è `&str`: è una slice che punta a quel preciso punto del
binary. Questo è anche il motivo per cui i letterali di stringa sono immutabili; `&str` è un
riferimento immutabile.

#### Le String Slices come Parametri

Sapere che puoi prendere slices di letterali e valori di `String` ci porta a
un miglioramento su `first_word`, e questa è la sua firma:

```rust,ignore
fn first_word(s: &String) -> &str {
```

Un Rustacean più esperto scriverebbe la firma mostrata nell'Elenco 4-9
invece perché ci permette di usare la stessa funzione sia sui valori `&String`
che sui valori `&str`.

```rust,ignore
{{#rustdoc_include ../listings/ch04-understanding-ownership/listing-04-09/src/main.rs:here}}
```

<span class="caption">Elenco 4-9: Miglioramento della funzione `first_word` usando
una string slice per il tipo del parametro `s`</span>

Se abbiamo una string slice, possiamo passarla direttamente. Se abbiamo una `String`, possiamo passare una slice della `String` o un riferimento alla `String`. Questa
flessibilità sfrutta le *deref coercions*, una caratteristica che tratteremo nella
sezione [“Le Coercioni Deref Implicite con Funzioni e Metodi”][deref-coercions]<!--ignore--> del Capitolo 15.

Definire una funzione per prendere una string slice invece di un riferimento a una `String`
rende la nostra API più generale e utile senza perdere nessuna funzionalità:

<span class="filename">Nome file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/listing-04-09/src/main.rs:usage}}
```

### Altre Slices

Le string slice, come potresti immaginare, sono specifiche per le stringhe. Ma c'è un
tipo più generale di slice. Considera questo array:

```rust
let a = [1, 2, 3, 4, 5];
```

Proprio come potremmo voler fare riferimento a parte di una stringa, potremmo voler fare
riferimento a parte di un array. Lo faremmo così:

```rust
let a = [1, 2, 3, 4, 5];

let slice = &a[1..3];

assert_eq!(slice, &[2, 3]);
```

Questa slice ha il tipo `&[i32]`. Funziona allo stesso modo delle slices di stringa, memorizzando un riferimento al primo elemento e una lunghezza. Userai questo tipo di
slice per ogni sorta di altre collezioni. Discuteremo queste collezioni in
dettaglio quando parleremo dei vettori nel Capitolo 8.

## Sommario

I concetti di ownership, borrowing, e slices assicurano la sicurezza della memoria nei programmi Rust al momento della compilazione. Il linguaggio Rust ti dà il controllo sull'uso della memoria nella stessa maniera di altri linguaggi di programmazione di sistema, ma avere il proprietario dei dati che elimina automaticamente quei dati quando il proprietario esce dallo scope significa che non devi scrivere e debugare codice extra per ottenere questo controllo.

L'ownership influenza come funzionano molte altre parti di Rust, quindi parleremo di
questi concetti ulteriormente nel resto del libro. Passiamo ora al
Capitolo 5 e guardiamo come raggruppare pezzi di dati insieme in uno `Struct`.

[ch13]: ch13-02-iterators.html
[ch6]: ch06-02-match.html#patterns-that-bind-to-values
[strings]: ch08-02-strings.html#storing-utf-8-encoded-text-with-strings
[deref-coercions]: ch15-02-deref.html#implicit-deref-coercions-with-functions-and-methods
