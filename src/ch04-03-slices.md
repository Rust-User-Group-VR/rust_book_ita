## Il tipo Slice

I *Slices* ti permettono di fare riferimento a una sequenza contigua di elementi in una collezione piuttosto che all'intera collezione. Un slice è un tipo di riferimento, quindi non ha ownership.

Ecco un piccolo problema di programmazione: scrivi una funzione che prende una stringa di parole separate da spazi e restituisci la prima parola che trova in quella stringa. Se la funzione non trova uno spazio nella stringa, l'intera stringa deve essere una parola, quindi l'intera stringa dovrebbe essere restituita.

Lavoriamo su come scrivere la firma di questa funzione senza usare gli slice, per capire il problema che gli slice risolveranno:

```rust,ignore
fn first_word(s: &String) -> ?
```

La funzione `first_word` ha un `&String` come parametro. Non vogliamo l'ownership, quindi va bene così. Ma cosa dovremmo restituire? Non abbiamo realmente un modo per parlare di *parte* di una stringa. Tuttavia, potremmo restituire l'indice della fine della parola, indicato da uno spazio. Proviamo a fare così, come mostrato nella Lista 4-7.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/listing-04-07/src/main.rs:here}}
```

<span class="caption">Lista 4-7: La funzione `first_word` che restituisce un valore di indice byte nel parametro `String`</span>

Perché dobbiamo passare attraverso il `String` elemento per elemento e controllare se un valore è uno spazio, convertiremo il nostro `String` in un array di byte usando il metodo `as_bytes`.

```rust,ignore
{{#rustdoc_include ../listings/ch04-understanding-ownership/listing-04-07/src/main.rs:as_bytes}}
```

Successivamente, creiamo un iteratore sull'array di byte usando il metodo `iter`:

```rust,ignore
{{#rustdoc_include ../listings/ch04-understanding-ownership/listing-04-07/src/main.rs:iter}}
```

Discuteremo degli iteratori più in dettaglio nel [Capitolo 13][ch13]<!-- ignore -->. Per ora, sappi che `iter` è un metodo che restituisce ciascun elemento in una collezione e che `enumerate` avvolge il risultato di `iter` e restituisce ogni elemento come parte di una tuple invece. Il primo elemento della tuple restituita da `enumerate` è l'indice, e il secondo elemento è un riferimento all'elemento. È un po' più comodo calcolare l'indice da soli.

Poiché il metodo `enumerate` restituisce una tuple, possiamo usare i pattern per destrutturare quella tuple. Discuteremo più dei pattern nel [Capitolo 6][ch6]<!-- ignore -->. Nel ciclo `for`, specifichiamo un pattern che ha `i` per l'indice nella tuple e `&item` per il singolo byte nella tuple. Poiché otteniamo un riferimento all'elemento da `.iter().enumerate()`, usiamo `&` nel pattern.

All'interno del ciclo `for`, cerchiamo il byte che rappresenta lo spazio utilizzando la sintassi del byte letterale. Se troviamo uno spazio, restituiamo la posizione. Altrimenti, restituiamo la lunghezza della stringa usando `s.len()`.

```rust,ignore
{{#rustdoc_include ../listings/ch04-understanding-ownership/listing-04-07/src/main.rs:inside_for}}
```

Ora abbiamo un modo per scoprire l'indice della fine della prima parola nella stringa, ma c'è un problema. Stiamo restituendo un `usize` da solo, ma è solo un numero significativo nel contesto del `&String`. In altre parole, poiché è un valore separato dalla `String`, non c'è garanzia che sarà ancora valido in futuro. Considera il programma nella Lista 4-8 che usa la funzione `first_word` dalla Lista 4-7.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/listing-04-08/src/main.rs:here}}
```

<span class="caption">Lista 4-8: Salvataggio del risultato ottenuto chiamando la funzione `first_word` e poi cambiando il contenuto della `String`</span>

Questo programma si compila senza errori e lo farebbe anche se usassimo `word` dopo aver chiamato `s.clear()`. Poiché `word` non è collegato allo stato di `s` per niente, `word` contiene ancora il valore `5`. Potremmo usare quel valore `5` con la variabile `s` per cercare di estrarre la prima parola, ma questo sarebbe un bug perché il contenuto di `s` è cambiato da quando abbiamo salvato `5` in `word`.

Dover preoccuparsi dell'indice in `word` che va fuori sincrono con i dati in `s` è tedioso e incline agli errori! Gestire questi indici è ancora più fragile se scriviamo una funzione `second_word`. La sua firma dovrebbe essere così:

```rust,ignore
fn second_word(s: &String) -> (usize, usize) {
```

Ora stiamo tracciando un indice iniziale *e* uno finale, e abbiamo ancora più valori che sono stati calcolati dai dati in uno stato particolare ma non sono legati a quello stato per niente. Abbiamo tre variabili non correlate che fluttuano intorno e che devono essere mantenute sincronizzate.

Per fortuna, Rust ha una soluzione a questo problema: gli slice di stringa.

### Gli slice di Stringa

Uno *slice di stringa* è un riferimento a parte di una `String`, e sembra così:

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-17-slice/src/main.rs:here}}
```

Piuttosto che un riferimento all'intero `String`, `hello` è un riferimento a una porzione del `String`, specificato nell'ulteriore pezzo `[0..5]`. Creiamo gli slice utilizzando un intervallo tra parentesi quadre specificando `[starting_index..ending_index]`, dove `starting_index` è la prima posizione nello slice e `ending_index` è uno in più dell'ultima posizione nello slice. Internamente, la struttura dei dati dello slice memorizza la posizione iniziale e la lunghezza dello slice, che corrisponde a `ending_index` meno `starting_index`. Quindi, nel caso di `let world = &s[6..11];`, `world` sarebbe uno slice che contiene un puntatore al byte all'indice 6 di `s` con un valore di lunghezza di `5`.

La Figura 4-6 mostra questo in un diagramma.

<img alt="Tre tabelle: una tabella che rappresenta i dati stack di s, che punta
al byte all'indice 0 in una tabella dei dati della stringa &quot;ciao mondo&quot; sul
heap. La terza tabella rappresenta i dati stack dello slice mondo, che
ha un valore di lunghezza 5 e punta al byte 6 della tabella dei dati del heap."
src="img/trpl04-06.svg" class="center" style="width: 50%;" />

<span class="caption">Figura 4-6: Slice di stringa che si riferisce a una parte di una `String`</span>

Con la sintassi degli intervalli `..` di Rust, se vuoi iniziare all'indice 0, puoi eliminare il valore prima dei due punti. In altre parole, questi sono equivalenti:

```rust
let s = String::from("ciao");

let slice = &s[0..2];
let slice = &s[..2];
```

Allo stesso modo, se il tuo slice include l'ultimo byte della `String`, puoi eliminare il numero finale. Questi sono quindi uguali:

```rust
let s = String::from("ciao");

let len = s.len();

let slice = &s[3..len];
let slice = &s[3..];
```

Puoi anche eliminare entrambi i valori per prendere uno slice dell'intera stringa. Quindi questi sono uguali:

```rust
let s = String::from("ciao");

let len = s.len();

let slice = &s[0..len];
let slice = &s[..];
```

> Nota: Gli indici dell'intervallo dello slice di stringa devono trovarsi ai confini di caratteri UTF-8 validi. Se tenti di creare uno slice di stringa nel mezzo di un carattere multibyte, il tuo programma uscirà con un errore. Ai fini dell'introduzione degli slice di stringa, stiamo assumendo solo ASCII in questa sezione; una discussione più approfondita sulla gestione dell'UTF-8 si trova nella sezione [“Memorizzazione di testo codificato in UTF-8 con le stringhe”][strings]<!-- ignore --> del Capitolo 8.

Con tutte queste informazioni in mente, riscriviamo `first_word` per restituire uno slice. Il tipo che significa "slice di stringa" è scritto come `&str`:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-18-first-word-slice/src/main.rs:here}}
```
Otteniamo l'indice per la fine della parola nello stesso modo in cui abbiamo fatto in Listing 4-7, cercando la prima occorrenza di uno spazio. Quando troviamo uno spazio, restituimao uno slice di stringa utilizzando l'inizio della stringa e l'indice dello spazio come gli indici di inizio e fine.

Ora, quando chiamiamo `first_word`, otteniamo un singolo valore che è legato ai dati sottostanti. Il valore è composto da un riferimento al punto di inizio dello slice e dal numero di elementi nello slice.

Restituire uno slice funzionerebbe anche per una funzione `second_word`:

```rust,ignore
fn second_word(s: &String) -> &str {
```

Ora abbiamo un'API diretta che è molto più difficile da rovinare perché il compilatore garantirà che i riferimenti alla `String` rimangano validi. Ricordi il bug nel programma in Listing 4-8, quando abbiamo ottenuto l'indice alla fine della prima parola ma poi abbiamo svuotato la stringa così il nostro indice non era più valido? Quel codice era logicamente errato ma non mostrava errori immediati. I problemi sarebbero emersi più tardi se avessimo continuato a cercare di utilizzare l'indice della prima parola con una stringa svuotata. Gli slice rendono impossibile questo bug e ci fanno sapere molto prima che abbiamo un problema con il nostro codice. Usando la versione slice di `first_word` avremo un errore di compilazione:

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-19-slice-error/src/main.rs:here}}
```

Ecco l'errore del compilatore:

```console
{{#include ../listings/ch04-understanding-ownership/no-listing-19-slice-error/output.txt}}
```

Ricorda dalle regole del prestito che se abbiamo un riferimento immutabile a qualcosa, non possiamo prendere anche un riferimento mutabile. Poiché `clear` ha bisogno di troncare la `String`, ha bisogno di ottenere un riferimento mutabile. Il `println!` dopo la chiamata a `clear` utilizza il riferimento in `word`, quindi il riferimento immutabile deve essere ancora attivo a quel punto. Rust impedisce che il riferimento mutabile in `clear` e il riferimento immutabile in `word` esistano allo stesso tempo, e la compilazione fallisce. Non solo Rust ha reso la nostra API più facile da utilizzare, ma ha anche eliminato un'intera classe di errori al momento della compilazione!

<!-- Old heading. Do not remove or links may break. -->
<a id="string-literals-are-slices"></a>

#### I Literal Stringa sono Slice

Ricorda che abbiamo parlato dei literal stringa che sono memorizzati all'interno del binario. Ora che sappiamo gli slice, possiamo capire correttamente i literal stringa:

```rust
let s = "Hello, world!";
```

Il tipo di `s` qui è `&str`: è uno slice che punta a quel punto specifico del binario. Questo è anche il motivo per cui i literal stringa sono immutabili; `&str` è un riferimento immutabile.

#### Slice di Stringa come Parametri

Sapendo che puoi prendere slice di literal e valori `String` ci porta a un ulteriore miglioramento su `first_word`, che è la sua firma:

```rust,ignore
fn first_word(s: &String) -> &str {
```

Un Rustacean più esperto scriverebbe la firma mostrata in Listing 4-9 invece perché ci permette di usare la stessa funzione sia su valori `&String` che su valori `&str`.

```rust,ignore
{{#rustdoc_include ../listings/ch04-understanding-ownership/listing-04-09/src/main.rs:here}}
```

<span class="caption">Listing 4-9: Miglioramento della funzione `first_word` usando uno slice di stringa per il tipo del parametro `s`</span>

Se abbiamo uno slice di stringa, possiamo passare quello direttamente. Se abbiamo una `String`, possiamo passare uno slice della `String` o un riferimento alla `String`. Questa flessibilità sfrutta le *coercizioni deref*, una funzione che copriremo nella sezione [“Implicit Deref Coercions with Functions and Methods”][deref-coercions]<!--ignore--> del Capitolo 15.

Definire una funzione per accettare uno slice di stringa invece di un riferimento a una `String` rende la nostra API più generale e utile senza perdere nessuna funzionalità:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/listing-04-09/src/main.rs:usage}}
```

### Altri Slice

Gli slice di stringa, come potresti immaginare, sono specifici per le stringhe. Ma c'è anche un tipo di slice più generale. Considera questo array:

```rust
let a = [1, 2, 3, 4, 5];
```

Proprio come potremmo voler fare riferimento a parte di una stringa, potremmo voler fare riferimento a parte di un array. Lo faremmo in questo modo:

```rust
let a = [1, 2, 3, 4, 5];

let slice = &a[1..3];

assert_eq!(slice, &[2, 3]);
```

Questo slice ha il tipo `&[i32]`. Funziona allo stesso modo come fanno gli slice di stringa, memorizzando un riferimento al primo elemento e una lunghezza. Userai questo tipo di slice per ogni tipo di altre collezioni. Discuteremo queste collezioni nel dettaglio quando parleremo di vettori nel Capitolo 8.

## Sommario

I concetti di ownership, prestito e slice garantiscono la sicurezza della memoria nei programmi Rust al momento della compilazione. Il linguaggio Rust ti dà il controllo sul tuo utilizzo della memoria nello stesso modo di altri linguaggi di programmazione di sistema, ma avere il proprietario dei dati pulire automaticamente tali dati quando il proprietario esce dallo scope significa che non devi scrivere e correggere codice extra per ottenere questo controllo.

L'Ownership influisce su come funzionano molte altre parti di Rust, quindi parleremo di questi concetti ulteriormente durante il resto del libro. Passiamo al Capitolo 5 e guardiamo al raggruppamento di pezzi di dati insieme in un `struct`.

[ch13]: ch13-02-iterators.html
[ch6]: ch06-02-match.html#patterns-that-bind-to-values
[strings]: ch08-02-strings.html#storing-utf-8-encoded-text-with-strings
[deref-coercions]: ch15-02-deref.html#implicit-deref-coercions-with-functions-and-methods

