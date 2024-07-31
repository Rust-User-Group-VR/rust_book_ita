## Tipi di Dati

Ogni valore in Rust appartiene a un certo *tipo di dato*, il che indica a Rust che tipo di dati sono specificati in modo che sappia come lavorare con quei dati. Esamineremo due sottoinsiemi di tipi di dati: scalari e composti.

Tieni presente che Rust è un linguaggio *tipizzato staticamente*, il che significa che deve conoscere i tipi di tutte le variabili durante la compilazione. Di solito, il compilatore può inferire quale tipo vogliamo utilizzare in base al valore e a come lo utilizziamo. Nei casi in cui sono possibili molti tipi, come quando abbiamo convertito una `String` in un tipo numerico utilizzando `parse` nella sezione ["Confronto del Presupposto con il Numero Segreto"][comparing-the-guess-to-the-secret-number]<!-- ignore --> nel Capitolo 2, dobbiamo aggiungere un'annotazione del tipo, come questa:

```rust
let guess: u32 = "42".parse().expect("Non è un numero!");
```

Se non aggiungiamo l'annotazione del tipo `: u32` mostrata nel codice precedente, Rust visualizzerà il seguente errore, il che significa che il compilatore ha bisogno di ulteriori informazioni da noi per capire quale tipo vogliamo utilizzare:

```console
{{#include ../listings/ch03-common-programming-concepts/output-only-01-no-type-annotations/output.txt}}
```

Vedrai annotazioni di tipo diverse per altri tipi di dati.

### Tipi Scalari

Un tipo *scalare* rappresenta un singolo valore. Rust ha quattro tipi scalari principali: interi, numeri a virgola mobile, booleani e caratteri. Potresti riconoscerli da altri linguaggi di programmazione. Vediamo come funzionano in Rust.

#### Tipi Interi

Un *intero* è un numero senza componente frazionaria. Abbiamo utilizzato un tipo intero nel Capitolo 2, il tipo `u32`. Questa dichiarazione di tipo indica che il valore associato deve essere un intero senza segno (i tipi interi con segno iniziano con `i` invece di `u`) che occupa 32 bit di spazio. La Tabella 3-1 mostra i tipi di interi integrati in Rust. Possiamo utilizzare qualsiasi di queste varianti per dichiarare il tipo di un valore intero.

<span class="caption">Tabella 3-1: Tipi Interi in Rust</span>

| Lunghezza | Con Segno | Senza Segno |
|-----------|-----------|-------------|
| 8-bit     | `i8`      | `u8`        |
| 16-bit    | `i16`     | `u16`       |
| 32-bit    | `i32`     | `u32`       |
| 64-bit    | `i64`     | `u64`       |
| 128-bit   | `i128`    | `u128`      |
| arch      | `isize`   | `usize`     |

Ogni variante può essere con segno o senza segno e ha una dimensione esplicita.
*Con segno* e *senza segno* si riferiscono alla possibilità che il numero sia negativo, in altre parole, se il numero deve avere un segno associato (con segno) o se sarà sempre positivo e può quindi essere rappresentato senza un segno (senza segno). È come scrivere numeri su carta: quando il segno è importante, un numero viene mostrato con un segno positivo o negativo; tuttavia, quando è sicuro presumere che il numero sia positivo, viene mostrato senza segno.
I numeri con segno sono memorizzati utilizzando la rappresentazione [complemento a due][twos-complement]<!-- ignore -->.

Ogni variante con segno può memorizzare numeri da -(2<sup>n - 1</sup>) a 2<sup>n - 1</sup> - 1 inclusi, dove *n* è il numero di bit che quella variante utilizza. Quindi un `i8` può memorizzare numeri da -(2<sup>7</sup>) a 2<sup>7</sup> - 1, che equivale a -128 a 127. Le varianti senza segno possono memorizzare numeri da 0 a 2<sup>n</sup> - 1, quindi un `u8` può memorizzare numeri da 0 a 2<sup>8</sup> - 1, che equivale a 0 a 255.

Inoltre, i tipi `isize` e `usize` dipendono dall'architettura del computer su cui è in esecuzione il programma, che è indicata nella tabella come "arch": 64 bit se si è su un'architettura a 64 bit e 32 bit se si è su un'architettura a 32 bit.

Puoi scrivere letterali interi in una qualsiasi delle forme mostrate nella Tabella 3-2. Nota che i letterali numerici che possono essere di più tipi numerici consentono un suffisso di tipo, come `57u8`, per designare il tipo. I letterali numerici possono anche utilizzare `_` come separatore visivo per rendere il numero più facile da leggere, come `1_000`, che avrà lo stesso valore come se avessi specificato `1000`.

<span class="caption">Tabella 3-2: Letterali Interi in Rust</span>

| Letterali Numerici | Esempio         |
|--------------------|-----------------|
| Decimale           | `98_222`        |
| Esadecimale        | `0xff`          |
| Ottale             | `0o77`          |
| Binario            | `0b1111_0000`   |
| Byte (`u8` only)   | `b'A'`          |

Quindi, come sapere quale tipo di intero utilizzare? Se non sei sicuro, i predefiniti di Rust sono generalmente buoni punti di partenza: i tipi interi predefiniti sono `i32`.
La situazione principale in cui utilizzeresti `isize` o `usize` è quando si indicizza una sorta di collezione.

> ##### Overflow degli Interi
>
> Supponiamo di avere una variabile di tipo `u8` che può contenere valori tra 0 e 255. Se provi a cambiare la variabile a un valore al di fuori di quel range, come 256, si verificherà un *overflow degli interi*, il che può portare a uno dei due comportamenti. Quando compili in modalità debug, Rust include controlli per l'overflow degli interi che causano il *panic* del programma a runtime se si verifica questo comportamento. Rust usa il termine *panico* quando un programma termina con un errore; discuteremo dei panici in dettaglio nella sezione ["Errori irrecuperabili con `panic!`"][unrecoverable-errors-with-panic]<!-- ignore --> del Capitolo 9.
>
> Quando compili in modalità release con il flag `--release`, Rust *non* include controlli per l'overflow degli interi che causano panici. Invece, se si verifica un overflow, Rust esegue il *wrapping complementare a due*. In breve, i valori superiori al massimo valore che il tipo può contenere "avvolgono" al minimo dei valori che il tipo può contenere. Nel caso di un `u8`, il valore 256 diventa 0, il valore 257 diventa 1, e così via. Il programma non andrà in panico, ma la variabile avrà un valore che probabilmente non è quello che ti aspettavi di avere. Fare affidamento sul comportamento di wrapping per l'overflow degli interi è considerato un errore.
>
> Per gestire esplicitamente la possibilità di overflow, puoi utilizzare queste famiglie di metodi forniti dalla libreria standard per i tipi numerici primitivi:
>
> * Wrapping in tutte le modalità con i metodi `wrapping_*`, come `wrapping_add`.
> * Restituire il valore `None` se si verifica overflow con i metodi `checked_*`.
> * Restituire il valore e un booleano che indica se si è verificato overflow con i metodi `overflowing_*`.
> * Saturare ai valori minimo o massimo con i metodi `saturating_*`.

#### Tipi a Virgola Mobile

Rust ha anche due tipi primitivi per i *numeri a virgola mobile*, che sono numeri con punti decimali. I tipi a virgola mobile di Rust sono `f32` e `f64`, che sono rispettivamente di 32 bit e 64 bit. Il tipo predefinito è `f64` perché sui moderni CPU è approssimativamente della stessa velocità di `f32` ma è capace di maggiore precisione. Tutti i tipi a virgola mobile sono con segno.

Ecco un esempio che mostra i numeri a virgola mobile in azione:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-06-floating-point/src/main.rs}}
```

I numeri a virgola mobile sono rappresentati secondo lo standard IEEE-754. Il tipo `f32` è un float a precisione singola, e `f64` ha doppia precisione.

#### Operazioni Numeriche

Rust supporta le operazioni matematiche di base che ci si aspetta per tutti i tipi di numero: addizione, sottrazione, moltiplicazione, divisione e resto. La divisione intera tronca verso zero al numero intero più vicino. Il codice seguente mostra come utilizzeresti ciascuna operazione numerica in un'istruzione `let`:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-07-numeric-operations/src/main.rs}}
```

Ogni espressione in queste istruzioni utilizza un operatore matematico e valuta un singolo valore, che viene quindi associato a una variabile. [Appendice B][appendix_b]<!-- ignore --> contiene un elenco di tutti gli operatori forniti da Rust.

#### Il Tipo Booleano

Come nella maggior parte degli altri linguaggi di programmazione, un tipo booleano in Rust ha due possibili valori: `true` e `false`. I booleani sono di un byte. Il tipo booleano in Rust è specificato usando `bool`. Per esempio:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-08-boolean/src/main.rs}}
```

Il modo principale per usare i valori booleani è tramite le espressioni condizionali, come un'espressione `if`. Copriremo come funzionano le espressioni `if` in Rust nella sezione ["Controllo del Flusso"][control-flow]<!-- ignore -->.

#### Il Tipo Carattere

Il tipo `char` di Rust è il tipo alfabetico più primitivo del linguaggio. Ecco alcuni esempi di dichiarazione di valori `char`:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-09-char/src/main.rs}}
```

Nota che specifichiamo i letterali `char` con virgolette singole, a differenza dei letterali stringa, che usano virgolette doppie. Il tipo `char` di Rust è di quattro byte e rappresenta un valore scalare Unicode, il che significa che può rappresentare molto più del semplice ASCII. Lettere accentate; caratteri cinesi, giapponesi e coreani; emoji; e spazi a larghezza zero sono tutti valori `char` validi in Rust. I valori scalari Unicode vanno da `U+0000` a `U+D7FF` e da `U+E000` a `U+10FFFF` inclusi. Tuttavia, un “carattere” non è realmente un concetto in Unicode, quindi la tua intuizione umana su cosa sia un “carattere” potrebbe non corrispondere a ciò che un `char` è in Rust. Discuteremo di questo argomento in dettaglio in ["Memorizzazione del Testo Codificato UTF-8 con Stringhe"][strings]<!-- ignore --> nel Capitolo 8.

### Tipi Composti

I *tipi composti* possono raggruppare più valori in un unico tipo. Rust ha due tipi composti primitivi: tuple e array.

#### Il Tipo Tuple

Una *tupla* è un modo generale per raggruppare un numero di valori con una varietà di tipi in un unico tipo composto. Le tuple hanno una lunghezza fissa: una volta dichiarate, non possono crescere o diminuire in dimensioni.

Creiamo una tupla scrivendo un elenco di valori separati da virgole all'interno di parentesi. Ogni posizione nella tupla ha un tipo, e i tipi dei diversi valori nella tupla non devono essere uguali. Abbiamo aggiunto delle annotazioni di tipo facoltative in questo esempio:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-10-tuples/src/main.rs}}
```

La variabile `tup` si associa all'intera tupla perché una tupla è considerata un singolo elemento composto. Per ottenere i singoli valori di una tupla, possiamo utilizzare il pattern matching per destrutturare un valore tupla, come questo:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-11-destructuring-tuples/src/main.rs}}
```

Questo programma crea prima una tupla e la associa alla variabile `tup`. Utilizza quindi un modello con `let` per prendere `tup` e trasformarla in tre variabili separate, `x`, `y` e `z`. Questo è chiamato *destrutturazione* perché scompone la singola tupla in tre parti. Infine, il programma stampa il valore di `y`, che è `6.4`.

Possiamo anche accedere a un elemento di una tupla direttamente utilizzando un punto (`.`) seguito dall'indice del valore a cui vogliamo accedere. Per esempio:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-12-tuple-indexing/src/main.rs}}
```

Questo programma crea la tupla `x` e poi accede a ciascun elemento della tupla utilizzando i loro rispettivi indici. Come nella maggior parte dei linguaggi di programmazione, il primo indice in una tupla è 0.

La tupla senza alcun valore ha un nome speciale, *unità*. Questo valore e il suo tipo corrispondente sono entrambi scritti `()` e rappresentano un valore vuoto o un tipo di ritorno vuoto. Le espressioni restituiscono implicitamente il valore unità se non restituiscono alcun altro valore.

#### Il Tipo Array

Un altro modo per avere una raccolta di più valori è con un *array*. A differenza di una tupla, ogni elemento di un array deve avere lo stesso tipo. A differenza degli array in alcuni altri linguaggi, gli array in Rust hanno una lunghezza fissa.

Scriviamo i valori in un array come un elenco separato da virgole all'interno di parentesi quadre:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-13-arrays/src/main.rs}}
```

Gli array sono utili quando vuoi che i tuoi dati siano allocati nello stack piuttosto che nello heap (discuteremo dello stack e dello heap più nel dettaglio nel [Capitolo 4][stack-and-heap]<!-- ignore -->) o quando vuoi assicurarti di avere sempre un numero fisso di elementi. Un array non è flessibile come il tipo vettore, però. Un *vettore* è un tipo di raccolta simile fornito dalla libreria standard che *è* consentito crescere o ridursi in dimensioni. Se non sei sicuro se utilizzare un array o un vettore, è probabile che dovresti usare un vettore. [Capitolo 8][vectors]<!-- ignore --> tratta i vettori più in dettaglio.

Tuttavia, gli array sono più utili quando sai che il numero di elementi non dovrà cambiare. Ad esempio, se stavi usando i nomi dei mesi in un programma, probabilmente useresti un array anziché un vettore perché sai che conterrà sempre 12 elementi:

```rust
let months = ["Gennaio", "Febbraio", "Marzo", "Aprile", "Maggio", "Giugno", "Luglio",
              "Agosto", "Settembre", "Ottobre", "Novembre", "Dicembre"];
```

Scrivi il tipo di un array utilizzando le parentesi quadre con il tipo di ogni elemento, un punto e virgola, e quindi il numero di elementi nell'array, in questo modo:

```rust
let a: [i32; 5] = [1, 2, 3, 4, 5];
```

Qui, `i32` è il tipo di ogni elemento. Dopo il punto e virgola, il numero `5` indica che l'array contiene cinque elementi.

Puoi anche inizializzare un array per contenere lo stesso valore per ciascun elemento specificando il valore iniziale, seguito da un punto e virgola, e poi la lunghezza dell'array tra parentesi quadre, come mostrato qui:

```rust
let a = [3; 5];
```

L'array chiamato `a` conterrà `5` elementi che saranno inizialmente impostati al valore `3`. Questo è lo stesso che scrivere `let a = [3, 3, 3, 3, 3];` ma in modo più conciso.

##### Accesso agli Elementi dell'Array

Un array è un singolo blocco di memoria di dimensioni note e fisse che può essere allocato nello stack. Puoi accedere agli elementi di un array utilizzando l'indicizzazione, come questo:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-14-array-indexing/src/main.rs}}
```

In questo esempio, la variabile chiamata `first` otterrà il valore `1` perché quello è il valore all'indice `[0]` nell'array. La variabile chiamata `second` otterrà il valore `2` dall'indice `[1]` nell'array.

##### Accesso Non Valido agli Elementi dell'Array

Vediamo cosa succede se provi ad accedere a un elemento di un array che è oltre la fine dell'array. Diciamo che esegui questo codice, simile al gioco di indovinelli nel Capitolo 2, per ottenere un indice di un array dall'utente:

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore,panics
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-15-invalid-array-access/src/main.rs}}
Questo codice viene compilato correttamente. Se esegui questo codice utilizzando `cargo run` e inserisci `0`, `1`, `2`, `3` o `4`, il programma stamperà il valore corrispondente a quell'indice nell'array. Se invece inserisci un numero oltre la fine dell'array, come `10`, vedrai un output simile a questo:

<!-- manual-regeneration
cd listings/ch03-common-programming-concepts/no-listing-15-invalid-array-access
cargo run
10
-->

```console
thread 'main' panicked at src/main.rs:19:19:
index out of bounds: the len is 5 but the index is 10
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace
```

Il programma ha causato un errore di *runtime* nel momento in cui si è utilizzato un valore non valido nell'operazione di indicizzazione. Il programma è terminato con un messaggio di errore e non ha eseguito l'istruzione finale `println!`. Quando tenti di accedere a un elemento utilizzando l'indicizzazione, Rust controllerà che l'indice specificato sia inferiore alla lunghezza dell'array. Se l'indice è maggiore o uguale alla lunghezza, Rust entrerà in panico. Questo controllo deve avvenire a runtime, specialmente in questo caso, poiché il compilatore non può sapere quale valore l'utente inserirà quando eseguirà il codice successivamente.

Questo è un esempio dei principi di sicurezza della memoria di Rust in azione. In molti linguaggi di basso livello, questo tipo di controllo non viene eseguito, e quando si fornisce un indice errato, è possibile accedere a memoria non valida. Rust ti protegge da questo tipo di errore uscendo immediatamente invece di consentire l'accesso alla memoria e continuare. Il Capitolo 9 discute ulteriormente la gestione degli errori in Rust e come è possibile scrivere codice leggibile e sicuro che non vada in panico né permetta l'accesso a memoria non valida.

[comparing-the-guess-to-the-secret-number]:
ch02-00-guessing-game-tutorial.html#comparing-the-guess-to-the-secret-number
[twos-complement]: https://en.wikipedia.org/wiki/Two%27s_complement
[control-flow]: ch03-05-control-flow.html#control-flow
[strings]: ch08-02-strings.html#storing-utf-8-encoded-text-with-strings
[stack-and-heap]: ch04-01-what-is-ownership.html#the-stack-and-the-heap
[vectors]: ch08-01-vectors.html
[unrecoverable-errors-with-panic]: ch09-01-unrecoverable-errors-with-panic.html
[appendix_b]: appendix-02-operators.md

