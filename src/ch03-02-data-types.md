## Tipi di Dati

Ogni valore in Rust appartiene a un certo *tipo di dato*, che dice a Rust che tipo di
dati viene specificato in modo che sappia come lavorare con tali dati. Esamineremo
due sottogruppi di tipo di dati: scalari e composti.

Ricorda che Rust è un linguaggio *staticamente tipizzato*, il che significa che deve
conoscere i tipi di tutte le variabili a tempo di compilazione. Il compilatore solitamente può
inferire quale tipo vogliamo utilizzare basandosi sul valore e su come lo usiamo. In casi
quando molti tipi sono possibili, come quando abbiamo convertito una `String` in un numerico
utilizzando `parse` nella sezione [“Comparando la Supposizione al Numero
Segreto”][comparing-the-guess-to-the-secret-number]<!-- ignore --> nel
Capitolo 2, dobbiamo aggiungere un'annotazione di tipo, come questa:

```rust
let guess: u32 = "42".parse().expect("Non è un numero!");
```

Se non aggiungiamo l'annotazione di tipo `: u32` mostrata nel codice precedente, Rust
mostrerà il seguente errore, che significa che il compilatore ha bisogno di più
informazioni da noi per sapere quale tipo vogliamo utilizzare:

```console
{{#include ../listings/ch03-common-programming-concepts/output-only-01-no-type-annotations/output.txt}}
```

Vedrai diverse annotazioni di tipo per altri tipi di dati.

### Tipi Scalari

Un tipo *scalare* rappresenta un singolo valore. Rust ha quattro tipi scalari principali:
interi, numeri a virgola mobile, booleani e caratteri. Potresti riconoscerli
da altri linguaggi di programmazione. Entriamo nel dettaglio di come funzionano in Rust.

#### Tipi Intero

Un *intero* è un numero senza una componente frazionale. Abbiamo usato un tipo intero
nel Capitolo 2, il tipo `u32`. Questa dichiarazione di tipo indica che il
valore a cui è associato dovrebbe essere un intero non firmato (i tipi interi firmati
iniziano con `i` invece che con `u`) che occupa 32 bit di spazio. La Tabella 3-1 mostra
i tipi interi predefiniti in Rust. Possiamo utilizzare una qualsiasi di queste varianti per dichiarare
il tipo di un valore intero.

<span class="caption">Tabella 3-1: Tipi Intero in Rust</span>

| Lunghezza | Firmato | Non Firmato |
|-----------|---------|-------------|
| 8-bit     | `i8`    | `u8`        |
| 16-bit    | `i16`   | `u16`       |
| 32-bit    | `i32`   | `u32`       |
| 64-bit    | `i64`   | `u64`       |
| 128-bit   | `i128`  | `u128`      |
| arch      | `isize` | `usize`     |

Ogni variante può essere firmata o non firmata e ha una dimensione esplicita.
*Firmato* e *non firmato* si riferiscono alla possibilità che il numero sia
negativo, in altre parole, se il numero deve avere un segno (firmato) o se sarà sempre positivo e quindi può essere
rappresentato senza un segno (non firmato). È come scrivere numeri su carta: quando
il segno importa, un numero è mostrato con un segno più o un segno meno; tuttavia,
quando è sicuro supporre che il numero sia positivo, viene mostrato senza segno.
I numeri firmati sono memorizzati utilizzando la rappresentazione [complementare a due][twos-complement]<!-- ignore
--> .

Ogni variante firmata può memorizzare numeri da -(2<sup>n - 1</sup>) a 2<sup>n -
1</sup> - 1 inclusi, dove *n* è il numero di bit che la variante utilizza. Quindi un
`i8` può memorizzare numeri da -(2<sup>7</sup>) a 2<sup>7</sup> - 1, che equivale
da -128 a 127. Le varianti non firmate possono memorizzare numeri da 0 a 2<sup>n</sup> - 1,
quindi un `u8` può memorizzare numeri da 0 a 2<sup>8</sup> - 1, che equivale da 0 a 255.

Inoltre, i tipi `isize` e `usize` dipendono dall'architettura del
computer sul quale il tuo programma sta girando, che è indicato nella tabella come “arch”:
64 bit se sei su un'architettura a 64 bit e 32 bit se sei su un'architettura a 32 bit.

Puoi scrivere letterali interi in una delle forme mostrate nella Tabella 3-2. Nota
che i letterali numerici che possono essere di tipi numerici multipli permettono un suffisso di tipo,
come `57u8`, per designare il tipo. I letterali numerici possono anche utilizzare `_` come
separatore visivo per rendere il numero più leggibile, come `1_000`, che avrà
lo stesso valore come se avessi specificato `1000`.

<span class="caption">Tabella 3-2: Letterali Intero in Rust</span>

| Letterali numerici | Esempio       |
|--------------------|---------------|
| Decimale           | `98_222`      |
| Esadecimale        | `0xff`        |
| Ottale             | `0o77`        |
| Binario            | `0b1111_0000` |
| Byte (`u8` solo)   | `b'A'`        |

Quindi come sai quale tipo di intero usare ? Se non sei sicuro, i default di Rust sono 
in genere un buon punto di partenza: i tipi intero di default sono `i32`.
La situazione primaria in cui userebbe `isize` o `usize` è quando stai facendo l'indicizzazione
di qualche tipo di collezione.

> ##### Overflow Intero
>
> Supponiamo che tu abbia una variabile di tipo `u8` che può tenere valori tra 0 e
> 255. Se provi a modificare la variabile in un valore fuori da quel range, come
> 256, avverrà un *overflow intero*, che può comportare uno dei due comportamenti.
> Quando stai compilando in modalità debug, Rust include controlli per l'overflow intero
> che fanno *panic* il tuo programma a runtime se questo comportamento si verifica. Rust
> usa il termine *panic* quando un programma esce con un errore; discuteremo
> di panico più in profondità nella sezione [“Errori Irrecuperabili con
> `panic!`”][unrecoverable-errors-with-panic]<!-- ignore --> nel Capitolo
> 9.
>
> Quando stai compilando in modalità release con il flag `--release`, Rust non
> include controlli per l'overflow intero che causano panici. Invece, se
> si verifica un overflow, Rust esegue un *wrap del complemento a due*. In breve, il valore
> che supera il valore massimo che il tipo può tenere “avvolge” al minimo
> dei valori che il tipo può tenere. Nel caso di un `u8`, il valore 256 diventa
> 0, il valore 257 diventa 1, e così via. Il programma non andrà in panico, ma la
> variabile avrà un valore che probabilmente non è quello che ti aspettavi avesse.
> Fare affidamento sul comportamento del wrapping dell'overflow intero è considerato un errore.
>
> Per gestire esplicitamente la possibilità di overflow, puoi utilizzare queste famiglie
> di metodi provvisti dalla libreria standard per i tipi numerici primitivi:
>
> * Wrap in tutte le modalità con i metodi `wrapping_*`, come `wrapping_add`.
> * Torna il valore `None` se c'è un overflow con i metodi `checked_*`.
> * Torna il valore e un booleano che indica se c'è stato un overflow con
>   i metodi `overflowing_*`.
> * Satura ai valori minimi o massimi del valore con i metodi `saturating_*`.

#### Tipi a Virgola Mobile

Rust ha anche due tipi primitivi per i *numeri a virgola mobile*, che sono
numeri con punti decimali. I tipi a virgola mobile di Rust sono `f32` e `f64`,
che sono rispettivamente di 32 bit e 64 bit. Il tipo di default è `f64`
perché sui moderni CPU, è circa della stessa velocità di `f32` ma è capace di
maggiore precisione. Tutti i tipi a virgola mobile sono firmati.

Ecco un esempio che mostra i numeri a virgola mobile in azione:

<span class="filename">Nome del File: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-06-floating-point/src/main.rs}}
```

I numeri a virgola mobile sono rappresentati secondo lo standard IEEE-754. Il
tipo `f32` è un float di precisione singola, e `f64` ha una doppia precisione.

#### Operazioni numeriche

Rust supporta le operazioni matematiche di base che ti aspetteresti per tutti i tipi di numeri: somma, sottrazione, moltiplicazione, divisione e resto. La divisione intera tronca verso lo zero all'intero più vicino. Il codice seguente mostra come utilizzeresti ogni operazione numerica in un'istruzione `let`:

<span class="filename">Nome file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-07-numeric-operations/src/main.rs}}
```

Ogni espressione in queste istruzioni utilizza un operatore matematico e valuta
a un singolo valore, che viene quindi vincolato a una variabile. L'[Appendix B][appendix_b]<!-- ignore --> contiene un elenco di tutti gli operatori che Rust
fornisce.

#### Il tipo Booleano

Come nella maggior parte degli altri linguaggi di programmazione, un tipo booleano in Rust ha due valori possibili: `true` e `false`. I booleani hanno una dimensione di un byte. Il tipo booleano in
Rust è specificato usando `bool`. Ad esempio:

<span class="filename">Nome file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-08-boolean/src/main.rs}}
```

Il modo principale per utilizzare i valori booleani è attraverso condizionali, come un'espressione `if`. Tratteremo come funzionano le espressioni `if` in Rust nella sezione [“Control Flow”][control-flow]<!-- ignore -->.

#### Il tipo Carattere

Il tipo `char` di Rust è il tipo alfabetico più primitivo del linguaggio. Ecco
alcuni esempi di dichiarazioni di valori `char`:

<span class="filename">Nome file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-09-char/src/main.rs}}
```

Nota che specificiamo i letterali `char` con singoli virgolette, a differenza dei
letterali stringa, che utilizzano le virgolette doppie. Il tipo `char` di Rust è di quattro byte in dimensione e
rappresenta un valore scalare Unicode, il che significa che può rappresentare molto più che
solo ASCII. Lettere accentate; caratteri cinesi, giapponesi e coreani; emoji;
e gli spazi di larghezza zero sono tutti valori `char` validi in Rust. I valori scalari Unicode
vanno da `U+0000` a `U+D7FF` e `U+E000` a `U+10FFFF` inclusi.
Tuttavia, un "carattere" non è realmente un concetto in Unicode, quindi la tua
intuizione umana per cosa è un "carattere" potrebbe non combaciare con ciò che un `char` è in
Rust. Discuteremo questo argomento in dettaglio in [“Storing UTF-8 Encoded Text with
Strings”][strings]<!-- ignore --> nel Capitolo 8.

### Tipi composti

I *Tipi composti* possono raggruppare più valori in un unico tipo. Rust ha due
tipi composti primitivi: tuple e array.

#### Il tipo Tupla

Una *tupla* è un modo generale di raggruppare insieme un numero di valori con una
varietà di tipi in un unico tipo composto. Le tuple hanno una lunghezza fissa: una volta
dichiarate, non possono crescere o diminuire in dimensione.

Creiamo una tupla scrivendo un elenco di valori separati da virgola all'interno
parentesi. Ogni posizione nella tupla ha un tipo, e i tipi dei
diversi valori nella tupla non devono essere gli stessi. Abbiamo aggiunto facoltativo
annotazioni di tipo in questo esempio:

<span class="filename">Nome file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-10-tuples/src/main.rs}}
```

La variabile `tup` si lega all'intera tupla perché una tupla viene considerata una
singolo elemento composto. Per ottenere i valori individuali da una tupla, possiamo
usa il pattern matching per destrutturare un valore di una tupla, in questo modo:

<span class="filename">Nome file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-11-destructuring-tuples/src/main.rs}}
```

Questo programma prima crea una tupla e la lega alla variabile `tup`. Quindi
usa un pattern con `let` per prendere `tup` e trasformarla in tre separate
variabili, `x`, `y`, e `z`. Questo viene chiamato *destrutturazione* perché rompe
la singola tupla in tre parti. Infine, il programma stampa il valore di
`y`, che è `6.4`.

Possiamo anche accedere direttamente a un elemento di una tupla utilizzando un punto (`.`) seguito dall'indice del valore che vogliamo accedere. Ad esempio:

<span class="filename">Nome file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-12-tuple-indexing/src/main.rs}}
```

Questo programma crea la tupla `x` e poi accede ad ogni elemento della tupla
utilizzando i rispettivi indici. Come nella maggior parte dei linguaggi di programmazione, il primo
indice in una tupla è 0.

La tupla senza valori ha un nome speciale, *unit*. Questo valore e il suo
corrispondente tipo sono entrambi scritti `()` e rappresentano un valore vuoto o un
tipo di ritorno vuoto. Le espressioni restituiscono implicitamente il valore unità se non lo fanno
restituire nessun altro valore.

#### Il tipo Array

Un altro modo per avere una raccolta di più valori è con un *array*. A differenza
di una tupla, ogni elemento di un array deve avere lo stesso tipo. A differenza degli array in
alcuni altri linguaggi, gli array in Rust hanno una lunghezza fissa.

Scriviamo i valori in un array come un elenco separato da virgola all'interno di parentesi quadre:

<span class="filename">Nome file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-13-arrays/src/main.rs}}
```

Gli array sono utili quando desideri che i tuoi dati vengano allocati nello stack piuttosto che
nello heap (discuteremo lo stack e lo heap più in [Chapter
4][stack-and-heap]<!-- ignore -->) o quando vuoi assicurarti di avere sempre un
numero fisso di elementi. Un array non è flessibile come il tipo di vettore,
però. Un *vettore* è un tipo di raccolta simile fornito dalla libreria standard che *è* consentito crescere o diminuire in dimensione. Se non sei sicuro se
utilizzare un array o un vettore, probabilmente dovresti usare un vettore. [Chapter
8][vectors]<!-- ignore --> discute i vettori in modo più dettagliato.

Tuttavia, gli array sono più utili quando sai che il numero di elementi non avrà bisogno di cambiare. Ad esempio, se stessi utilizzando i nomi del mese in a
programma, probabilmente useresti un array piuttosto che un vettore perché sai
che conterrà sempre 12 elementi:

```rust
let months = ["Gennaio", "Febbraio", "Marzo", "Aprile", "Maggio", "Giugno", "Luglio",
              "Agosto", "Settembre", "Ottobre", "Novembre", "Dicembre"];
```

Scrivi il tipo di un array utilizzando parentesi quadre con il tipo di ogni elemento,
un punto e virgola, e poi il numero di elementi nell'array, così:

```rust
let a: [i32; 5] = [1, 2, 3, 4, 5];
```

Qui, `i32` è il tipo di ogni elemento. Dopo il punto e virgola, il numero `5`
indica che l'array contiene cinque elementi.

Puoi anche inizializzare un array per contenere lo stesso valore per ogni elemento da
specificando il valore iniziale, seguito da un punto e virgola, e poi la lunghezza di
l'array in parentesi quadre, come mostrato qui:

```rust
let a = [3; 5];
```

L'array chiamato `a` conterrà `5` elementi che saranno tutti impostati al valore
`3` inizialmente. Questo è lo stesso di scrivere `let a = [3, 3, 3, 3, 3];` ma in un
modo più conciso.

##### Accesso agli elementi dell'array


Un array è un singolo pezzo di memoria di una dimensione conosciuta e fissa che può essere allocato nello stack. Puoi accedere agli elementi di un array utilizzando l'indicizzazione, così:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-14-array-indexing/src/main.rs}}
```

In questo esempio, la variabile chiamata `first` otterrà il valore `1` perché quello è il valore all'indice `[0]` nell'array. La variabile chiamata `second` otterrà il valore `2` dall'indice `[1]` nell'array.

##### Accesso ad un elemento di un array non valido

Vediamo cosa succede se si prova a accedere ad un elemento di un array che è oltre la fine dell'array. Supponiamo che tu esegua questo codice, simile al gioco di indovinare nel Capitolo 2, per ottenere un indice dell'array dall'utente:

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore,panics
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-15-invalid-array-access/src/main.rs}}
```

Questo codice viene compilato con successo. Se esegui questo codice usando `cargo run` e inserisci `0`, `1`, `2`, `3`, o `4`, il programma stamperà il valore corrispondente a quell'indice nell'array. Se invece inserisci un numero al di là della fine dell'array, come `10`, vedrai un output come questo:

<!-- manual-regeneration
cd listings/ch03-common-programming-concepts/no-listing-15-invalid-array-access
cargo run
10
-->

```console
thread 'main' panicked at 'index out of bounds: the len is 5 but the index is 10', src/main.rs:19:19
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace
```

Il programma ha causato un errore *runtime* nel momento in cui è stato utilizzato un valore non valido nell'operazione di indicizzazione. Il programma è uscito con un messaggio di errore e non ha eseguito l'ultima istruzione `println!`. Quando tenti di accedere a un elemento utilizzando l'indicizzazione, Rust controlla che l'indice che hai specificato sia minore della lunghezza dell'array. Se l'indice è maggiore o uguale alla lunghezza, Rust andrà in panic. Questo controllo deve avvenire a runtime, specialmente in questo caso, perché il compilatore non può sapere quale valore un utente inserirà quando eseguirà il codice in seguito.

Questo è un esempio dei principi di sicurezza della memoria di Rust in azione. In molte lingue a basso livello, questo tipo di controllo non viene fatto, e quando si fornisce un indice non corretto, si può accedere alla memoria non valida. Rust ti protegge da questo tipo di errore uscendo immediatamente invece di consentire l'accesso alla memoria e continuare. Il Capitolo 9 discute ulteriormente della gestione degli errori di Rust e di come puoi scrivere codice leggibile e sicuro che non va in panic e non consente l'accesso alla memoria non valida.

[comparing-the-guess-to-the-secret-number]:
ch02-00-guessing-game-tutorial.html#comparing-the-guess-to-the-secret-number
[twos-complement]: https://it.wikipedia.org/wiki/Complemento_a_due
[control-flow]: ch03-05-control-flow.html#control-flow
[strings]: ch08-02-strings.html#storing-utf-8-encoded-text-with-strings
[stack-and-heap]: ch04-01-what-is-ownership.html#the-stack-and-the-heap
[vectors]: ch08-01-vectors.html
[unrecoverable-errors-with-panic]: ch09-01-unrecoverable-errors-with-panic.html
[appendix_b]: appendix-02-operators.md

