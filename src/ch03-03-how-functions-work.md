## Funzioni

Le funzioni sono prevalenti nel codice Rust. Hai già visto una delle funzioni più
importanti nel linguaggio: la funzione `main`, che è il punto di ingresso di molti programmi. Hai anche visto la parola chiave `fn`, che ti permette di
dichiarare nuove funzioni.

Il codice Rust utilizza il *snake case* come stile convenzionale per i nomi delle funzioni e delle variabili
, in cui tutte le lettere sono minuscole e gli underscore separano le parole.
Ecco un programma che contiene una definizione di funzione di esempio:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-16-functions/src/main.rs}}
```

Definiamo una funzione in Rust inserendo `fn` seguito da un nome di funzione e un
insieme di parentesi. Le parentesi graffe indicano al compilatore dove inizia e finisce il corpo della funzione.

Possiamo chiamare qualsiasi funzione che abbiamo definito inserendo il suo nome seguito da un insieme
di parentesi. Poiché `another_function` è definita nel programma, può essere
chiamata all'interno della funzione `main`. Nota che abbiamo definito `another_function`
*dopo* la funzione `main` nel codice sorgente; avremmo potuto definirla prima
pure. A Rust non importa dove definisci le tue funzioni, solo che siano
definite da qualche parte in uno scope che può essere visto dal chiamante.

Iniziamo un nuovo progetto binario chiamato *functions* per esplorare ulteriormente le funzioni.
Inserisci l'esempio di `another_function` in *src/main.rs* ed eseguilo. Dovresti vedere l'output seguente:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-16-functions/output.txt}}
```

Le righe vengono eseguite nell'ordine in cui appaiono nella funzione `main`.
Prima viene stampato il messaggio "Hello, world!", e poi `another_function` viene chiamata
e il suo messaggio viene stampato.

### Parametri

Possiamo definire le funzioni per avere *parametri*, che sono variabili speciali che
fanno parte della firma di una funzione. Quando una funzione ha parametri, puoi
fornirle valori concreti per quei parametri. Tecnicamente, i valori concreti sono chiamati *argomenti*, ma nel linguaggio comune, le persone tendono a usare
le parole *parametro* e *argomento* in modo interscambiabile per le variabili
nella definizione di una funzione o i valori concreti passati quando si chiama una funzione.

In questa versione di `another_function` aggiungiamo un parametro:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-17-functions-with-parameters/src/main.rs}}
```

Prova a eseguire questo programma; dovresti ottenere l'output seguente:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-17-functions-with-parameters/output.txt}}
```

La dichiarazione di `another_function` ha un parametro chiamato `x`. Il tipo di
`x` è specificato come `i32`. Quando passiamo `5` a `another_function`, il
macro `println!` mette `5` dove la coppia di parentesi graffe contenente `x` era
nella stringa di formato.

Nelle firme delle funzioni, *devi* dichiarare il tipo di ogni parametro. Questa è
una scelta deliberata nel design di Rust: richiedere annotazioni di tipo nelle definizioni di funzione significa che il compilatore quasi mai ha bisogno che tu le usi altrove nel
codice per capire quale tipo intendi. Il compilatore è anche in grado di dare
messaggi di errore più utili se sa quali tipi la funzione si aspetta.

Quando si definiscono più parametri, separare le dichiarazioni di parametro con
virgole, così:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-18-functions-with-multiple-parameters/src/main.rs}}
```

Questo esempio crea una funzione chiamata `print_labeled_measurement` con due
parametri. Il primo parametro si chiama `value` ed è un `i32`. Il secondo si
chiama `unit_label` ed è di tipo `char`. La funzione poi stampa un testo contenente
sia il `value` che l'`unit_label`.

Proviamo a eseguire questo codice. Sostituisci il programma attualmente nel tuo progetto *functions*
nel file *src/main.rs* con l'esempio precedente ed eseguilo utilizzando `cargo
run`:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-18-functions-with-multiple-parameters/output.txt}}
```

Poiché abbiamo chiamato la funzione con `5` come valore per `value` e `'h'` come
il valore per `unit_label`, l'output del programma contiene quei valori.

### Istruzioni ed Espressioni

I corpi delle funzioni sono composti da una serie di istruzioni che terminano opzionalmente in un
espressione. Fino ad ora, le funzioni che abbiamo coperto non hanno incluso un' espressione finale, ma hai visto un'espressione come parte di un'istruzione. Poiché
Rust è un linguaggio basato su espressioni, questa è una distinzione importante da
capire. Altri linguaggi non hanno le stesse distinzioni, quindi vediamo cosa sono le istruzioni e le espressioni e come le loro differenze influenzano i corpi
delle funzioni.

* **Istruzioni** sono istruzioni che eseguono un'azione e non restituiscono
  un valore.
* **Espressioni** valutano a un valore risultante. Vediamo alcuni esempi.

Abbiamo effettivamente già usato istruzioni ed espressioni. Creare una variabile e
assegnare un valore ad essa con la parola chiave `let` è un'istruzione. Nell'Esempio 3-1,
`let y = 6;` è un'istruzione.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/listing-03-01/src/main.rs}}
```

<span class="caption">Esempio 3-1: Una dichiarazione di funzione `main` che contiene un'istruzione</span>

Anche le definizioni delle funzioni sono istruzioni; l'intero esempio precedente è un
istruzione in sé.

Le istruzioni non restituiscono valori. Pertanto, non è possibile assegnare un'istruzione `let`
a un'altra variabile, come prova a fare il codice seguente; otterrai un errore:

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-19-statements-vs-expressions/src/main.rs}}
```

Quando esegui questo programma, l'errore che otterrai apparirà così:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-19-statements-vs-expressions/output.txt}}
```

L'istruzione `let y = 6` non restituisce un valore, quindi non c'è nulla per
`x` da associare. Questo è diverso da ciò che accade in altri linguaggi, come
C e Ruby, dove l'assegnazione restituisce il valore dell'assegnazione. In quei
linguaggi, è possibile scrivere `x = y = 6` e avere sia `x` che `y` con il valore
`6`; questo non è il caso in Rust.

Le espressioni valutano a un valore e costituiscono la maggior parte del resto del codice che
scriverai in Rust. Considera un'operazione matematica, come `5 + 6`, che è un
espressione che valuta al valore `11`. Le espressioni possono far parte di
istruzioni: nell'Esempio 3-1, il `6` nell'istruzione `let y = 6;` è un
espressione che valuta al valore `6`. Chiamare una funzione è un'
espressione. Chiamare un macro è un'espressione. Un nuovo blocco di scope creato con
parentesi graffe è un'espressione, per esempio:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-20-blocks-are-expressions/src/main.rs}}
```

Questa espressione:

```rust,ignore
{
    let x = 3;
    x + 1
}
```

è un blocco che, in questo caso, valuta a `4`. Quel valore viene associato a `y`
come parte dell'istruzione `let`. Nota che la linea `x + 1` non ha un
punto e virgola alla fine, diversamente dalla maggior parte delle righe che hai visto fino ad ora.
Le espressioni non includono punti e virgola finali. Se aggiungi un punto e virgola alla fine
di un'espressione, la trasformi in un'istruzione, e quindi non restituirà un
valore. Tieni presente questo mentre esplori i valori di ritorno delle funzioni e le espressioni
prossime.

### Funzioni con Valori di Ritorno

Le funzioni possono restituire valori al codice che le chiama. Non nominiamo i ritorni
valori, ma dobbiamo dichiarare il loro tipo dopo una freccia (`->`). In Rust, il
valore di ritorno della funzione è sinonimo del valore dell'ultima
espressione nel blocco del corpo di una funzione. È possibile ritornare presto da una
funzione utilizzando la parola chiave `return` e specificando un valore, ma la maggior parte
delle funzioni restituiscono l'ultima espressione implicitamente. Ecco un esempio di una
funzione che restituisce un valore:

<span class="filename">Nome del file: src/main.rs</span>


```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-21-function-return-values/src/main.rs}}
```

Non ci sono chiamate di funzioni, macro, o nemmeno dichiarazioni `let` nella funzione `five` - solo il numero `5` da solo. Questa è una funzione perfettamente valida in Rust. Notare che viene specificato anche il tipo di ritorno della funzione, come `-> i32`. Prova a eseguire questo codice; l'output dovrebbe sembrare questo:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-21-function-return-values/output.txt}}
```

Il `5` in `five` è il valore di ritorno della funzione, ed è per questo che il tipo di ritorno è `i32`. Esaminiamo questo in maggiore dettaglio. Ci sono due punti importanti: primo, la riga `let x = five();` mostra che stiamo utilizzando il valore di ritorno di una funzione per inizializzare una variabile. Poiché la funzione `five` restituisce un `5`, quella riga è la stessa della seguente:

```rust
let x = 5;
```

Secondo, la funzione `five` non ha parametri e definisce il tipo del valore di ritorno, ma il corpo della funzione è un solitario `5` senza punto e virgola perché è un'espressione il cui valore vogliamo restituire.

Guardiamo un altro esempio:

<span class="filename">Nome File: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-22-function-parameter-and-return/src/main.rs}}
```

Eseguire questo codice stamperà `Il valore di x è: 6`. Ma se mettiamo un punto e virgola alla fine della riga contenente `x + 1`, trasformandola da espressione a dichiarazione, otterremo un errore:

<span class="filename">Nome File: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-23-statements-dont-return-values/src/main.rs}}
```

Compilare questo codice produce un errore, come segue:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-23-statements-dont-return-values/output.txt}}
```

Il messaggio di errore principale, `tipi incompatibili`, rivela il problema centrale con questo codice. La definizione della funzione `plus_one` dice che restituirà un `i32`, ma le dichiarazioni non valutano un valore, che è espresso da `()`, il tipo unità. Pertanto, non viene restituito nulla, il che contraddice la definizione della funzione e risulta in un errore. In questo output, Rust fornisce un messaggio per eventualmente aiutare a rettificare questo problema: suggerisce di rimuovere il punto e virgola, che risolverebbe l'errore.

