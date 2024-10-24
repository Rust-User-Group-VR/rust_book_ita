## Tipi di Dati

Ogni valore in Rust è di un certo *tipo di dato*, il quale indica a Rust che tipo di 
dato viene specificato in modo che sappia come lavorare con esso. Esamineremo 
due sottoinsiemi di tipi di dato: scalari e composti.

Tieni presente che Rust è un linguaggio *a tipizzazione statica*, il che significa che 
deve conoscere i tipi di tutte le variabili al momento della compilazione. Il compilatore 
può solitamente dedurre quale tipo vogliamo usare basandosi sul valore e su come lo 
usiamo. Nei casi in cui sono possibili molti tipi, come quando abbiamo convertito una 
`String` a un tipo numerico usando `parse` nella sezione [“Confrontare il Guess con il Numero Segreto”][comparing-the-guess-to-the-secret-number]<!-- ignore --> nel Capitolo 2, dobbiamo aggiungere un'annotazione di tipo, come segue:

```rust
let guess: u32 = "42".parse().expect("Not a number!");
```

Se non aggiungiamo l'annotazione di tipo `: u32` mostrata nel codice precedente, Rust
mostrerà il seguente errore, il che significa che il compilatore ha bisogno di più 
informazioni da noi per sapere quale tipo vogliamo usare:

```console
{{#include ../listings/ch03-common-programming-concepts/output-only-01-no-type-annotations/output.txt}}
```

Vedrai annotazioni di tipo differenti per altri tipi di dati.

### Tipi Scalari

Un tipo *scalare* rappresenta un singolo valore. Rust ha quattro tipi scalari principali: 
interi, numeri in virgola mobile, booleani e caratteri. Probabilmente li riconosci da altri 
linguaggi di programmazione. Scopriamo come funzionano in Rust.

#### Tipi Interi

Un *intero* è un numero senza componente frazionaria. Abbiamo usato un tipo intero 
nel Capitolo 2, il tipo `u32`. Questa dichiarazione di tipo indica che il valore associato 
dovrebbe essere un intero non firmato (i tipi interi firmati iniziano con `i` anziché `u`) 
che occupa 32 bit di spazio. La Tabella 3-1 mostra i tipi interi predefiniti in Rust. 
Possiamo usare una qualsiasi di queste varianti per dichiarare il tipo di un valore intero.

<span class="caption">Tabella 3-1: Tipi Interi in Rust</span>

| Lunghezza | Firmato | Non firmato |
|-----------|---------|-------------|
| 8-bit     | `i8`    | `u8`        |
| 16-bit    | `i16`   | `u16`       |
| 32-bit    | `i32`   | `u32`       |
| 64-bit    | `i64`   | `u64`       |
| 128-bit   | `i128`  | `u128`      |
| arch      | `isize` | `usize`     |

Ogni variante può essere firmata o non firmata e ha una dimensione esplicita.
*Firmato* e *non firmato* si riferiscono alla possibilità che il numero sia 
negativo, in altre parole, se il numero ha bisogno di avere un segno con esso 
(firmato) o se sarà sempre positivo e può quindi essere rappresentato senza un segno (non firmato). È come scrivere numeri su carta: quando il segno è importante, 
un numero è mostrato con un segno più o un segno meno; tuttavia, quando è sicuro 
assumere che il numero sia positivo, è mostrato senza segni. I numeri segno sono 
memorizzati utilizzando la rappresentazione in [complemento a due][twos-complement]<!-- ignore -->.

Ogni variante segno può memorizzare numeri da -(2<sup>n - 1</sup>) a 2<sup>n - 
1</sup> - 1 inclusi, dove *n* è il numero di bit che la variante usa. Quindi un 
`i8` può memorizzare numeri da -(2<sup>7</sup>) a 2<sup>7</sup> - 1, che equivale 
a -128 a 127. Le varianti non firmate possono memorizzare numeri da 0 a 2<sup>n</sup> - 1, quindi un `u8` può memorizzare numeri da 0 a 2<sup>8</sup> - 1, 
che equivale a 0 a 255.

Inoltre, i tipi `isize` e `usize` dipendono dall'architettura del computer su 
cui il tuo programma viene eseguito, che è denotato nella tabella come 
“arch”: 64 bit se sei su un'architettura a 64 bit e 32 bit se sei su un'architettura a 32 bit.

Puoi scrivere numeri interi letterali in una qualsiasi delle forme mostrate 
nella Tabella 3-2. Nota che i numeri letterali che possono essere di più tipi numerici 
consentono un suffisso di tipo, come `57u8`, per designare il tipo. I numeri letterali 
possono anche usare `_` come separatore visivo per rendere il numero più facile da leggere, come `1_000`, che avrà lo stesso valore di se avessi specificato `1000`.

<span class="caption">Tabella 3-2: Numeri Interi Letterali in Rust</span>

| Numeri letterali  | Esempio       |
|-------------------|---------------|
| Decimale          | `98_222`      |
| Esadecimale       | `0xff`        |
| Ottale            | `0o77`        |
| Binario           | `0b1111_0000` |
| Byte (`u8` solo)  | `b'A'`        |

Quindi come sai quale tipo di intero usare? Se non sei sicuro, i valori
predefiniti di Rust sono generalmente buoni punti di partenza: i tipi di interi 
predefiniti sono `i32`. La principale situazione in cui useresti `isize` o 
`usize` è quando vengono indicizzati tipi di collezioni.

> ##### Overflow degli Interi
>
> Supponiamo di avere una variabile di tipo `u8` che può contenere valori tra 0 
> e 255. Se provi a cambiare la variabile in un valore al di fuori di quel 
> range, come 256, si verificherà un *overflow intero*, che può risultare in uno 
> di due comportamenti. Quando stai compilando in modalità debug, Rust include 
> controlli per l'overflow intero che causano il *panic* del programma a 
> runtime se si verifica questo comportamento. Rust usa il termine *panicking* 
> quando un programma termina con un errore; discuteremo i panic in modo più 
> approfondito nella sezione [“Errori Irrecuperabili con `panic!`”][unrecoverable-errors-with-panic]<!-- ignore --> nel Capitolo 9.
>
> Quando stai compilando in modalità release con il flag `--release`, Rust 
> non include controlli per l'overflow intero che causano panic. Invece, se si 
> verifica un overflow, Rust esegue un *Wrappando complemento a due*. In 
> breve, valori maggiori rispetto al valore massimo che il tipo può contenere 
> si “wrappano” al minimo dei valori che il tipo può contenere. Nel caso di un `u8`, il 
> valore 256 diventa 0, il valore 257 diventa 1, e così via. Il programma non 
> andrà in panic, ma la variabile avrà un valore che probabilmente non è quello  che ci aspettavamo. Fare affidamento sul comportamento del Wrappando degli 
> overflow interi è considerato un errore.
>
> Per gestire esplicitamente la possibilità di overflow, puoi utilizzare le 
> famiglie di metodi fornite dalla libreria standard per i tipi numerici 
> primitivi:
>
> * Wrappa in tutte le modalità con i metodi `wrapping_*`, come `wrapping_add`.
> * Restituisci il valore `None` se c'è overflow con i metodi `checked_*`.
> * Restituisci il valore e un booleano che indica se c'è stato overflow con 
>   i metodi `overflowing_*`.
> * Saturati ai valori minimi o massimi con i metodi `saturating_*`.

#### Tipi in Virgola Mobile

Rust ha anche due tipi primitivi per i *numeri in virgola mobile*, che sono 
numeri con punti decimali. I tipi in virgola mobile di Rust sono `f32` e `f64`,
che sono rispettivamente di 32 bit e 64 bit. Il tipo predefinito è `f64` perché
sui moderni CPU, è grosso modo della stessa velocità di `f32` ma è capace di
più precisione. Tutti i tipi in virgola mobile sono firmati.

Ecco un esempio che mostra numeri in virgola mobile in azione:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-06-floating-point/src/main.rs}}
```

I numeri in virgola mobile sono rappresentati secondo lo standard IEEE-754. Il
tipo `f32` è un float a singola precisione, e `f64` ha precisione doppia.

#### Operazioni Numeriche

Rust supporta le operazioni matematiche di base che ti aspetteresti per tutti i
tipi numerici: addizione, sottrazione, moltiplicazione, divisione e resto. La
divisione intera tronca verso zero al numero intero più vicino. Il seguente
codice mostra come useresti ciascuna operazione numerica in un'istruzione
`let`:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-07-numeric-operations/src/main.rs}}
```

Ogni espressione in queste istruzioni utilizza un operatore matematico e
risolve in un singolo valore, che viene quindi assegnato a una variabile.
[L’Appendice B][appendix_b]<!-- ignore --> contiene un elenco di tutti gli
operatori che Rust fornisce.

#### Il Tipo Booleano

Come nella maggior parte degli altri linguaggi di programmazione, un tipo
booleano in Rust ha due possibili valori: `true` e `false`. I booleani sono di
un byte. Il tipo booleano in Rust è specificato usando `bool`. Per esempio:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-08-boolean/src/main.rs}}
```

Il modo principale di usare i valori booleani è attraverso i costrutti
condizionali, come un'espressione `if`. Discuteremo come funzionano le
espressioni `if` in Rust nella sezione [“Flusso di Controllo”][control-flow]<!-- ignore -->.

#### Il Tipo Carattere

Il tipo `char` di Rust è il tipo alfabetico più primitivo del linguaggio. Ecco
alcuni esempi di dichiarazione di valori `char`:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-09-char/src/main.rs}}
```

Nota che specifichiamo i letterali `char` con virgolette singole, al contrario
dei letterali di stringa, che usano virgolette doppie. Il tipo `char` di Rust è
di quattro byte e rappresenta un Valore Scalare Unicode, il che significa che
può rappresentare molto più di semplici codici ASCII. Lettere accentate;
caratteri cinesi, giapponesi e coreani; emoji; e spazi di larghezza zero sono
tutti valori `char` validi in Rust. I Valori Scalare Unicode vanno da `U+0000`
a `U+D7FF` e da `U+E000` a `U+10FFFF` inclusi. Tuttavia, un “carattere” non è
davvero un concetto in Unicode, quindi la tua intuizione umana di cosa sia un
“carattere” potrebbe non corrispondere a ciò che è un `char` in Rust.
Discuteremo questo argomento in dettaglio in [“Memorizzare Testo Codificato in
UTF-8 con le Stringhe”][strings]<!-- ignore --> nel Capitolo 8.

### Tipi Composti

I *tipi composti* possono raggruppare più valori in un unico tipo. Rust ha due
tipi composti primitivi: tuple e array.

#### Il Tipo Tuple

Una *tupla* è un modo generale di raggruppare un certo numero di valori con una
varietà di tipi in un solo tipo composto. Le tuple hanno una lunghezza fissa:
una volta dichiarate, non possono crescere o ridursi in dimensione.

Creiamo una tupla scrivendo un elenco di valori separati da virgole tra
parentesi. Ogni posizione nella tupla ha un tipo, e i tipi dei diversi valori
nella tupla non devono essere uguali. Abbiamo aggiunto annotazioni di tipo
opzionali in questo esempio:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-10-tuples/src/main.rs}}
```

La variabile `tup` associa all'intera tupla perché una tupla è considerata un
singolo elemento composto. Per ottenere i singoli valori da una tupla,
possiamo usare il pattern matching per destrutturare un valore tupla, come
questo:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-11-destructuring-tuples/src/main.rs}}
```

Questo programma prima crea una tupla e la associa alla variabile `tup`. Poi
usa un pattern con `let` per prendere `tup` e trasformarlo in tre variabili
separate, `x`, `y`, e `z`. Questo è chiamato *destrutturare* perché divide la
singola tupla in tre parti. Infine, il programma stampa il valore di `y`, che è
`6.4`.

Possiamo anche accedere direttamente a un elemento di una tupla usando un
punto (`.`) seguito dall'indice del valore che vogliamo accedere. Per esempio:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-12-tuple-indexing/src/main.rs}}
```

Questo programma crea la tupla `x` e poi accede a ciascun elemento della tupla
usando i loro rispettivi indici. Come nella maggior parte dei linguaggi di
programmazione, il primo indice in una tupla è 0.

La tupla senza alcun valore ha un nome speciale, *unità*. Questo valore e il suo
corrispondente tipo sono entrambi scritti `()` e rappresentano un valore
vuoto o un tipo di ritorno vuoto. Le espressioni restituiscono implicitamente
il valore unità se non restituiscono alcun altro valore.

#### Il Tipo Array

Un altro modo per avere una collezione di più valori è con un *array*. A
differenza di una tupla, ogni elemento di un array deve avere lo stesso tipo. A
differenza degli array in alcuni altri linguaggi, gli array in Rust hanno una
lunghezza fissa.

Scriviamo i valori in un array come un elenco separato da virgole tra
parentesi quadre:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-13-arrays/src/main.rs}}
```

Gli array sono utili quando si desidera che i tuoi dati siano allocati nello
stack piuttosto che nell'heap (discuteremo maggiormente lo stack e l'heap nel
[Capitolo 4][stack-and-heap]<!-- ignore -->) o quando vuoi garantire di avere
sempre un numero fisso di elementi. Tuttavia, un array non è flessibile come il
tipo vettoriale. Un *vettore* è un tipo di collezione simile fornito dalla
libreria standard che *è* consentito crescere o ridursi in dimensione. Se non
sei sicuro se usare un array o un vettore, è probabile che dovresti usare un
vettore. [Il Capitolo 8][vectors]<!-- ignore --> discute i vettori in maggiore
dettaglio.

Tuttavia, gli array sono più utili quando sai che il numero di elementi non
cambierà. Per esempio, se stai usando i nomi dei mesi in un programma, useresti
probabilmente un array piuttosto che un vettore perché sai che conterrà sempre
12 elementi:

```rust
let months = ["January", "February", "March", "April", "May", "June", "July",
              "August", "September", "October", "November", "December"];
```

Scrivi il tipo di un array usando parentesi quadre con il tipo di ciascun
elemento, un punto e virgola, e poi il numero di elementi nell'array, in
questo modo:

```rust
let a: [i32; 5] = [1, 2, 3, 4, 5];
```

Qui, `i32` è il tipo di ciascun elemento. Dopo il punto e virgola, il numero
`5` indica che l'array contiene cinque elementi.

Puoi anche inizializzare un array per contenere lo stesso valore per ciascun
elemento specificando il valore iniziale, seguito da un punto e virgola, e poi
la lunghezza dell'array tra parentesi quadre, come mostrato qui:

```rust
let a = [3; 5];
```

L'array chiamato `a` conterrà `5` elementi che saranno inizialmente tutti
impostati al valore `3`. Questo è lo stesso che scrivere `let a = [3, 3, 3, 3,
3];` ma in un modo più conciso.

##### Accedere agli Elementi di un Array

Un array è un blocco unico di memoria di dimensione nota e fissa che può essere
allocato nello stack. Puoi accedere agli elementi di un array usando
l'indicizzazione, come questo:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-14-array-indexing/src/main.rs}}
```

In questo esempio, la variabile chiamata `first` otterrà il valore `1` perché
questo è il valore all'indice `[0]` nell'array. La variabile chiamata `second`
otterrà il valore `2` dall'indice `[1]` nell'array.

##### Accesso non Valido all'Elemento di un Array

Vediamo cosa succede se provi ad accedere a un elemento di un array che è oltre
la fine dell'array. Supponiamo di eseguire questo codice, simile al gioco
Guessing del Capitolo 2, per ottenere un indice di array dall'utente:

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore,panics
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-15-invalid-array-access/src/main.rs}}
```
Questo codice si compila con successo. Se esegui questo codice utilizzando `cargo run` e inserisci `0`, `1`, `2`, `3` o `4`, il programma stamperà il valore corrispondente a quell'indice nell'array. Se invece inserisci un numero oltre la fine dell'array, come `10`, vedrai un output simile a questo:

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

Il programma ha generato un errore *runtime* al momento dell'utilizzo di un valore non valido nell'operazione di indicizzazione. Il programma è terminato con un messaggio di errore e non ha eseguito l'istruzione finale `println!`. Quando tenti di accedere a un elemento utilizzando l'indicizzazione, Rust controllerà che l'indice specificato sia minore della lunghezza dell'array. Se l'indice è maggiore o uguale alla lunghezza, Rust andrà in panic. Questo controllo deve avvenire a runtime, specialmente in questo caso, perché il compilatore non può sapere a priori quale valore inserirà un utente quando eseguirà il codice più tardi.

Questo è un esempio dei principi di sicurezza della memoria di Rust in azione. In molti linguaggi di basso livello, questo tipo di controllo non viene eseguito, e quando fornisci un indice errato, è possibile accedere a memoria non valida. Rust ti protegge da questo tipo di errore terminando immediatamente l'esecuzione invece di consentire l'accesso alla memoria e continuare. Il Capitolo 9 discute più approfonditamente la gestione degli errori in Rust e come puoi scrivere codice leggibile e sicuro che non va in panic né consente l'accesso a memoria non valida.

[comparing-the-guess-to-the-secret-number]:
ch02-00-guessing-game-tutorial.html#comparing-the-guess-to-the-secret-number
[twos-complement]: https://en.wikipedia.org/wiki/Two%27s_complement
[control-flow]: ch03-05-control-flow.html#control-flow
[strings]: ch08-02-strings.html#storing-utf-8-encoded-text-with-strings
[stack-and-heap]: ch04-01-what-is-ownership.html#the-stack-and-the-heap
[vectors]: ch08-01-vectors.html
[unrecoverable-errors-with-panic]: ch09-01-unrecoverable-errors-with-panic.html
[appendix_b]: appendix-02-operators.md
