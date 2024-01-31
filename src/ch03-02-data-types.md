## Tipi di Dati

Ogni valore in Rust ha un certo *tipo di dato*, che indica a Rust che tipo di
dati viene specificato così sa come lavorare con essi. Guarderemo a
due sottoinsiemi di tipo di dati: scalare e composto.

Ricorda che Rust è un linguaggio *tipizzato staticamente*, il che significa
che deve conoscere i tipi di tutte le variabili al momento della compilazione.
Il compilatore di solito può inferire il tipo che vogliamo usare in base al valore
e al modo in cui lo usiamo. In casi in cui sono possibili molti tipi, come quando abbiamo convertito una `String` in un tipo numerico usando `parse` nella sezione [“Comparando il tentativo con il numero segreto”][comparando-il-tentativo-al-numero-segreto]<!-- ignore --> nel
Capitolo 2, dobbiamo aggiungere un'annotazione di tipo, come questa:

```rust
let guess: u32 = "42".parse().expect("Non un numero!");
```

Se non aggiungiamo l'annotazione di tipo `: u32` mostrata nel codice precedente, Rust
mostrerà il seguente errore, il quale indica che il compilatore ha bisogno di più
informazioni da noi per sapere quale tipo vogliamo usare:

```console
{{#include ../listings/ch03-common-programming-concepts/output-only-01-no-type-annotations/output.txt}}
```

Vedrai annotazioni di tipo diverse per altri tipi di dati.

### Tipi Scalari

Un tipo *scalare* rappresenta un singolo valore. Rust ha quattro tipi scalari principali:
interi, numeri a virgola mobile, booleani e caratteri. Potresti riconoscere
questi da altri linguaggi di programmazione. Saltiamo su come funzionano in Rust.

#### Tipi Intero

Un *intero* è un numero senza una componente frazionaria. Abbiamo usato un tipo intero
nel Capitolo 2, il tipo `u32`. Questa dichiarazione di tipo indica che il
valore ad essa associato dovrebbe essere un intero non firmato (i tipi di interi
firmati iniziano con `i` invece di `u`) che occupa 32 bit di spazio. La Tabella 3-1 mostra
i tipi di interi incorporati in Rust. Possiamo usare qualsiasi di queste varianti per dichiarare
il tipo di un valore intero.

<span class="caption">Tabella 3-1: Tipi Intero in Rust</span>

| Lunghezza | Firmato | Non firmato |
|----------|---------|-------------|
| 8-bit    | `i8`    | `u8`        |
| 16-bit   | `i16`   | `u16`       |
| 32-bit   | `i32`   | `u32`       |
| 64-bit   | `i64`   | `u64`       |
| 128-bit  | `i128`  | `u128`      |
| arch     | `isize` | `usize`     |

Ogni variante può essere firmata o non firmata e ha una dimensione esplicita.
*Firmato* e *non firmato* si riferiscono alla possibilità che il numero sia
negativo—in altre parole, se il numero deve avere un segno con esso
(firmato) o se sará sempre positivo e quindi può essere
rappresentato senza un segno (non firmato). È come scrivere numeri su carta: quando
il segno conta, un numero viene mostrato con un segno più o un segno meno; tuttavia,
quando è sicuro assumere che il numero è positivo, viene mostrato senza segno.
I numeri firmati sono memorizzati usando la rappresentazione a [complemento a due][complemento-a-due]<!-- ignore -->.

Ogni variante firmata può memorizzare numeri da -(2<sup>n - 1</sup>) a 2<sup>n -
1</sup> - 1 incluso, dove *n* è il numero di bit che quella variante usa. Quindi un
`i8` può memorizzare numeri da -(2<sup>7</sup>) a 2<sup>7</sup> - 1, che equivale
da -128 a 127. Le varianti non firmate possono memorizzare numeri da 0 a 2<sup>n</sup> - 1,
quindi un `u8` può memorizzare numeri da 0 a 2<sup>8</sup> - 1, che equivale da 0 a 255.

Inoltre, i tipi `isize` e `usize` dipendono dall'architettura del
computer su cui il tuo programma sta girando, che viene denotata nella tabella come “arch”:
64 bit se sei su una architettura a 64 bit e 32 bit se sei su una architettura a 32 bit.

Puoi scrivere letterali interi in uno dei formati mostrati nella Tabella 3-2. Nota
che i letterali numerici che possono essere di molti tipi numerici consentono un suffisso di tipo,
come `57u8`, per designare il tipo. I letterali numerici possono anche utilizzare `_` come
separatore visivo per rendere il numero più facile da leggere, come `1_000`, che avrà
lo stesso valore come se tu avessi specificato `1000`.

<span class="caption">Tabella 3-2: Letterali Intero in Rust</span>

| Letterali numerici | Esempio      |
|--------------------|--------------|
| Decimale           | `98_222`     |
| Hex                | `0xff`       |
| Ottale             | `0o77`       |
| Binario            | `0b1111_0000`|
| Byte (solo `u8`)   | `b'A'`       |

Quindi come sai quale tipo di intero usare? Se non sei sicuro, i default di Rust
sono generalmente buoni punti di partenza: i tipi interi sono impostati di default su `i32`.
La situazione principale in cui useresti `isize` o `usize` è quando stai indicizzando
un certo tipo di collezione.

> ##### Overflow Intero
>
> Poniamo il caso tu abbia una variabile di tipo `u8` che può contenere valori tra 0 e
> 255. Se provi a cambiare la variabile in un valore al di fuori di quel range, come
> 256, si verificherà un *overflow intero*, che può risultare in uno dei due comportamenti.
> Quando stai compilando in modalità debug, Rust include controlli per l'overflow intero
> che causano un *panico* nel tuo programma a runtime se questo comportamento si verifica. Rust
> usa il termine *panico* quando un programma esce con un errore; discuteremo
> i panici più approfonditamente nella sezione [“Errori irreversibili con
> `panic!`”][errori-irrecuperabili-con-panic]<!-- ignore --> nel Capitolo
> 9.
>
> Quando stai compilando in modalità rilascio con il flag `--release`, Rust *non*
> include controlli per l'overflow intero che causano panici. Invece, se
> si verifica un overflow, Rust esegue una *complementazione a due*. In parole povere, i valori
> maggiori del valore massimo che il tipo può contenere "circolano" al minimo
> dei valori che il tipo può contenere. Nel caso di un `u8`, il valore 256 diventa
> 0, il valore 257 diventa 1, e così via. Il programma non andrà in panico, ma la
> variabile avrà un valore che probabilmente non ti aspettavi avesse. Fare affidamento sul comportamento avvolgente dell'overflow intero è considerato un errore.
>
> Per gestire esplicitamente la possibilità di overflow, puoi utilizzare queste famiglie
> di metodi fornite dalla libreria standard per i tipi numerici primitivi:
>
> * Avvolgere in tutte le modalità con i metodi `wrapping_*`, come `wrapping_add`.
> * Ritorna il valore `None` se c'è overflow con i metodi `checked_*`.
> * Ritorna il valore e un booleano che indica se c'era overflow con
>   i metodi `overflowing_*`.
> * Satura ai valori minimi o massimi del valore con i metodi `saturating_*`.

#### Tipi a Virgola Mobile

Rust ha anche due tipi primitivi per i numeri *a virgola mobile*, che sono
numeri con punti decimali. I tipi a virgola mobile di Rust sono `f32` e `f64`,
che sono rispettivamente di 32 bit e 64 bit. Il tipo di default è `f64`
perché sui moderni CPU, è circa della stessa velocità di `f32` ma è capace di
più precisione. Tutti i tipi a virgola mobile sono firmati.

Ecco un esempio che mostra i numeri a virgola mobile in azione:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-06-floating-point/src/main.rs}}
```

I numeri a virgola mobile sono rappresentati secondo lo standard IEEE-754. Il
tipo `f32` è un float a singola precisione, e `f64` ha doppia precisione.

#### Operazioni Numeriche

Rust supporta le operazioni matematiche di base che ti aspetteresti per tutti i numeri
tipi: somma, sottrazione, moltiplicazione, divisione e resto. La divisione intera tronca verso zero al più vicino intero. Il seguente codice mostra
come usaresti ogni operazione numerica in un'istruzione `let`:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-07-numeric-operations/src/main.rs}}
```
Ogni espressione in queste dichiarazioni utilizza un operatore matematico e restituisce
un singolo valore, che viene poi associato a una variabile. [Appendice
B][appendix_b]<!-- ignore --> contiene un elenco di tutti gli operatori che Rust
fornisce.

#### Il Tipo Booleano

Come nella maggior parte degli altri linguaggi di programmazione, un tipo booleano in Rust ha due possibili
valori: `true` e `false`. I booleani occupano un byte di dimensione. Il tipo booleano in
Rust è specificato usando `bool`. Ad esempio:

<span class="filename">Nome_file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-08-boolean/src/main.rs}}
```

Il modo principale per utilizzare i valori booleani è attraverso condizionali, come un' espressione `if`.
Tratteremo il modo in cui le espressioni `if` funzionano in Rust nella sezione [“Control
Flow”][control-flow]<!-- ignore -->.

#### Il Tipo Carattere

Il tipo `char` di Rust è il tipo alfabetico più primitivo del linguaggio. Ecco
alcuni esempi di dichiarazione di valori `char`:

<span class="filename">Nome_file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-09-char/src/main.rs}}
```

Si noti che specificiamo i letterali `char` con singole virgolette, a differenza dei letterali di stringa,
che usano le virgolette doppie. Il tipo `char` di Rust ha quattro byte di dimensione e
rappresenta un valore scalare Unicode, il che significa che può rappresentare molto più che
solo ASCII. Lettere accentate; caratteri cinesi, giapponesi e coreani; emoji;
e gli spazi di larghezza zero sono tutti validi valori `char` in Rust. I valori scalari Unicode
vanno da `U+0000` a `U+D7FF` e da `U+E000` a `U+10FFFF` inclusi.
Tuttavia, un "carattere" non è realmente un concetto in Unicode, quindi la tua
intuizione umana per quello che è un "carattere" potrebbe non coincidere con quello che è un `char` in
Rust. Discuteremo di questo argomento in dettaglio in [“Storing UTF-8 Encoded Text with
Strings”][strings]<!-- ignore --> nel capitolo 8.

### Tipi Composti

I *tipi composti* possono raggruppare più valori in un solo tipo. Rust ha due
tipi composti primitivi: le tuple e gli array.

#### Il Tipo Tuple

Una *tupla* è un modo generale di raggruppare un numero di valori con una
varietà di tipi in un singolo tipo composto. Le tuple hanno una lunghezza fissa: una volta
dichiarate, non possono crescere né diminuire di dimensione.

Creiamo una tupla scrivendo un elenco di valori separati da virgole all'interno
delle parentesi. Ogni posizione nella tupla ha un tipo, e i tipi dei
diversi valori nella tupla non devono essere uguali. Abbiamo aggiunto opzionali
annotazioni di tipo in questo esempio:

<span class="filename">Nome_file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-10-tuples/src/main.rs}}
```

La variabile `tup` si riferisce all'intera tupla perché una tupla è considerata un
singolo elemento composto. Per ottenere i valori individuali da una tupla, possiamo
utilizzare il pattern matching per destrutturare un valore della tupla, come in questo caso:

<span class="filename">Nome_file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-11-destructuring-tuples/src/main.rs}}
```

Questo programma crea prima una tupla e la collega alla variabile `tup`. Quindi
usa un pattern con `let` per prendere `tup` e trasformarlo in tre separate
variabili, `x`, `y`, e `z`. Questo è chiamato *destrutturazione* perché rompe
la singola tupla in tre parti. Infine, il programma stampa il valore di
`y`, che è `6.4`.

Possiamo anche accedere direttamente a un elemento di una tupla utilizzando un punto (`.`) seguito da
l'indice del valore che vogliamo accedere. Ad esempio:

<span class="filename">Nome_file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-12-tuple-indexing/src/main.rs}}
```

Questo programma crea la tupla `x` e poi accede a ciascun elemento della tupla
utilizzando i loro rispettivi indici. Come nella maggior parte dei linguaggi di programmazione, il primo
indice in una tupla è 0.

La tupla senza alcun valore ha un nome speciale, *unit*. Questo valore e il suo
tipo corrispondente sono entrambi scritti `()` e rappresentano un valore vuoto o un
tipo di ritorno vuoto. Le espressioni restituiscono implicitamente il valore unit se non restituiscono nessun altro valore.

#### Il Tipo Array

Un altro modo per avere una raccolta di più valori è con un *array*. A differenza
di una tupla, ogni elemento di un array deve avere lo stesso tipo. A differenza degli array in
alcuni altri linguaggi, gli array in Rust hanno una lunghezza fissa.

Scriviamo i valori in un array come un elenco separato da virgole all'interno di parentesi quadre:

<span class="filename">Nome_file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-13-arrays/src/main.rs}}
```

Gli array sono utili quando si vuole che i dati siano allocati nello stack piuttosto che
nell'heap (discuteremo di più lo stack e l'heap in [Capitolo
4][stack-and-heap]<!-- ignore -->) o quando si vuole assicurarsi di avere sempre un
numero fisso di elementi. Un array non è flessibile come il tipo vettoriale,
tuttavia. Un *vettore* è un tipo di raccolta simile fornita dalla libreria standard che *può* essere permesso di crescere o diminuire di dimensione. Se non sei sicuro se
utilizzare un array o un vettore, molto probabilmente dovresti utilizzare un vettore. [Capitolo
8][vectors]<!-- ignore --> tratta in più dettaglio i vettori.

Tuttavia, gli array sono più utili quando sai che il numero di elementi non avrà bisogno di cambiare. Ad esempio, se stessi utilizzando i nomi dei mesi in un
programma, probabilmente useresti un array piuttosto che un vettore perché sai
che conterrà sempre 12 elementi:

```rust
let months = ["January", "February", "March", "April", "May", "June", "July",
              "August", "September", "October", "November", "December"];
```

Si scrive il tipo di un array utilizzando parentesi quadre con il tipo di ogni elemento,
un punto e virgola, e poi il numero di elementi nell'array, così:

```rust
let a: [i32; 5] = [1, 2, 3, 4, 5];
```

Qui, `i32` è il tipo di ogni elemento. Dopo il punto e virgola, il numero `5`
indica che l'array contiene cinque elementi.

Puoi anche inizializzare un array per contenere lo stesso valore per ogni elemento specificando il valore iniziale, seguito da un punto e virgola, e poi la lunghezza dell'array tra parentesi quadre, come mostrato qui:

```rust
let a = [3; 5];
```

L'array chiamato `a` conterrà `5` elementi che saranno impostati inizialmente al valore
`3`. Questo è lo stesso di scrivere `let a = [3, 3, 3, 3, 3];` ma in un
modo più conciso.

##### Accesso agli Elementi dell'Array

Un array è un singolo blocco di memoria di dimensione nota e fissa che può essere
allocato nello stack. Puoi accedere agli elementi di un array utilizzando l'indicizzazione,
come questo:

<span class="filename">Nome_file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-14-array-indexing/src/main.rs}}
```

In questo esempio, la variabile chiamata `first` otterrà il valore `1` perché quello
è il valore all'indice `[0]` nell'array. La variabile chiamata `second` otterrà il valore `2` dall'indice `[1]` nell'array.

##### Accesso a un Elemento dell'Array Non Valido

Vediamo cosa succede se si prova ad accedere a un elemento di un array che è oltre
la fine dell'array. Diciamo che esegui questo codice, simile al gioco di indovinare nel
Capitolo 2, per ottenere un indice dell'array dall'utente:

<span class="filename">Nome_file: src/main.rs</span>

```rust,ignore,panics
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-15-invalid-array-access/src/main.rs}}
```

Questo codice viene compilato con successo. Se esegui questo codice usando `cargo run` e
inserisci `0`, `1`, `2`, `3`, o `4`, il programma stamperà il corrispondente
valore a quell'indice nell'array. Se invece inserisci un numero oltre la fine dell'array, come `10`, vedrai un output come questo:

<!-- manual-regeneration
cd listings/ch03-common-programming-concepts/no-listing-15-invalid-array-access
cargo run
10
-->
```console
thread 'main' ha avuto un panico a 'indice fuori dai limiti: la len è 5 ma l'indice è 10', src/main.rs:19:19
nota: esegui con la variabile di ambiente `RUST_BACKTRACE=1` per visualizzare una traccia inversa
```

Il programma ha generato un errore *runtime* nel momento in cui ha utilizzato un
valore non valido nell'operazione di indicizzazione. Il programma è uscito con un messaggio di errore e
non ha eseguito l'ultima istruzione `println!`. Quando tenti di accedere a un
elemento utilizzando l'indicizzazione, Rust verificherà che l'indice che hai specificato sia minore
della lunghezza dell'array. Se l'indice è maggiore o uguale alla lunghezza,
Rust avrà un panico. Questo controllo deve avvenire a runtime, soprattutto in questo caso,
perché il compilatore non può possibilmente sapere quale valore un utente inserirà quando
eseguirà il codice in seguito.

Questo è un esempio dei principi di sicurezza della memoria di Rust in azione. In molti
linguaggi a basso livello, questo tipo di controllo non viene effettuato, e quando fornisci un
indice incorretto, può essere accessa la memoria non valida. Rust ti protegge da questo
tipo di errore uscendo immediatamente invece di permettere l'accesso alla memoria e
continuare. Il Capitolo 9 discute di più sul gestione degli errori in Rust e su come puoi
scrivere codice leggibile e sicuro che né panica né permette l'accesso alla memoria non valida.

[confrontando-la-supposizione-con-il-numero-segreto]:
ch02-00-guessing-game-tutorial.html#confrontando-la-supposizione-con-il-numero-segreto
[complemento-a-due]: https://it.wikipedia.org/wiki/Complemento_a_due
[controllo-del-flusso]: ch03-05-control-flow.html#controllo-del-flusso
[stringhe]: ch08-02-strings.html#stoccaggio-del-testo-codificato-utf-8-con-le-stringhe
[stack-e-heap]: ch04-01-what-is-ownership.html#lo-stack-e-l'heap
[vettori]: ch08-01-vectors.html
[errori-irrecuperabili-con-panic]: ch09-01-unrecoverable-errors-with-panic.html
[appendice_b]: appendix-02-operators.md

