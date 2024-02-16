## Funzioni

Le funzioni sono molto presenti nel codice Rust. Hai già visto una delle funzioni più
importanti del linguaggio: la funzione `main`, che è il punto di ingresso di molti programmi. Hai anche visto la parola chiave `fn`, che ti consente di
dichiarare nuove funzioni.

Il codice Rust utilizza lo *snake case* come stile convenzionale per i nomi delle funzioni e delle variabili,
in cui tutte le lettere sono minuscole e gli underscore separano le parole.
Ecco un programma che contiene un esempio di definizione di funzione:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-16-functions/src/main.rs}}
```

In Rust definiamo una funzione inserendo `fn` seguito da un nome di funzione e un
insieme di parentesi. Le parentesi graffe indicano al compilatore dove inizia e finisce il corpo della funzione.

Possiamo chiamare qualsiasi funzione che abbiamo definito inserendo il suo nome seguito da un insieme
di parentesi. Poiché `another_function` è definita nel programma, può essere
chiamata dall'interno della funzione `main`. Nota che abbiamo definito `another_function`
*dopo* la funzione `main` nel codice sorgente; avremmo potuto definirla prima
così. A Rust non importa dove definisci le tue funzioni, solo che siano definite da qualche parte in un ambito che può essere visto dal chiamante.

Apriamo un nuovo progetto binario chiamato *functions* per esplorare le funzioni
ulteriormente. Inseriamo l'esempio di `another_function` in *src/main.rs* e lo eseguiamo. Dovresti vedere il seguente output:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-16-functions/output.txt}}
```

Le linee vengono eseguite nell'ordine in cui appaiono nella funzione `main`.
Prima va in stampa il messaggio "Hello, world!", e poi viene chiamata `another_function` e viene stampato il suo messaggio.

### Parametri

Possiamo definire funzioni per avere *parametri*, che sono variabili speciali che
fanno parte della firma di una funzione. Quando una funzione ha dei parametri, è possibile
fornirgli valori concreti per quei parametri. Tecnicamente, i valori concreti vengono chiamati *argomenti*, ma nella conversazione informale, le persone tendono a utilizzare
le parole *parametro* e *argomento* in modo intercambiabile sia per le variabili
nella definizione di una funzione sia per i valori concreti passati quando si chiama una funzione.

In questa versione di `another_function` aggiungiamo un parametro:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-17-functions-with-parameters/src/main.rs}}
```

Prova a eseguire questo programma; dovresti ottenere il seguente output:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-17-functions-with-parameters/output.txt}}
```

La dichiarazione di `another_function` ha un parametro chiamato `x`. Il tipo di
`x` è specificato come `i32`. Quando passiamo `5` a `another_function`, il
macro `println!` inserisce `5` dove la coppia di parentesi graffe contenente `x` era
nella stringa di formato.

Nelle firme di funzioni, *devi* dichiarare il tipo di ogni parametro. Questa decisione è
intenzionale nel design di Rust: richiedendo annotazioni di tipo nelle definizioni delle funzioni, il compilatore quasi mai ha bisogno che tu le usi altrove nel
codice per capire a quale tipo ti riferisci. Il compilatore è anche in grado di dare
messaggi di errore più utili se sa quali tipi si aspetta la funzione.

Quando definisci più parametri, separa le dichiarazioni dei parametri con
virgole, così:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-18-functions-with-multiple-parameters/src/main.rs}}
```

Questo esempio crea una funzione chiamata `print_labeled_measurement` con due
parametri. Il primo parametro si chiama `value` ed è un `i32`. Il secondo si chiama `unit_label` ed è di tipo `char`. La funzione poi stampa un testo contenente sia il `value` che il `unit_label`.

Proviamo a eseguire questo codice. Sostituisci il programma attualmente nel tuo progetto *functions* nel file *src/main.rs* con l'esempio precedente e eseguilo usando `cargo
run`:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-18-functions-with-multiple-parameters/output.txt}}
```

Poiché abbiamo chiamato la funzione con `5` come valore per `value` e `'h'` come
il valore per `unit_label`, l'output del programma contiene questi valori.

### Istruzioni ed Espressioni

I corpi di funzione sono composti da una serie di istruzioni che terminano opzionalmente in un
espressione. Finora, le funzioni che abbiamo coperto non hanno incluso un'espressione finale, ma avete visto un'espressione come parte di un'istruzione. Poiché
Rust è un linguaggio basato su espressioni, questa è una distinzione importante da
capire. Altri linguaggi non hanno le stesse distinzioni, quindi diamo un'occhiata a
cosa sono le istruzioni e le espressioni e come le loro differenze influenzano i corpi
delle funzioni.

* Le **Istruzioni** sono istruzioni che eseguono un'azione e non restituiscono
  un valore.
* Le **Espressioni** valutano un valore risultante. Vediamo alcuni esempi.

Abbiamo effettivamente già usato istruzioni ed espressioni. Creare una variabile e
assegnare un valore ad essa con la parola chiave `let` è un'istruzione. Nella Listing 3-1,
`let y = 6;` è un'istruzione.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/listing-03-01/src/main.rs}}
```

<span class="caption">Listing 3-1: Una dichiarazione della funzione `main` che contiene una sola istruzione</span>

Anche le definizioni di funzioni sono istruzioni; l'intero esempio precedente è un
istruzione di per sé.

Le istruzioni non restituiscono valori. Pertanto, non è possibile assegnare un'istruzione `let`
a un'altra variabile, come il seguente codice cerca di fare; otterrai un errore:

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-19-statements-vs-expressions/src/main.rs}}
```

Quando esegui questo programma, l'errore che otterrai sarà simile a questo:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-19-statements-vs-expressions/output.txt}}
```

L'istruzione `let y = 6` non restituisce un valore, quindi non c'è niente per
a cui `x` può collegarsi. Questo è diverso da ciò che accade in altri linguaggi, come
C e Ruby, dove l'assegnazione restituisce il valore dell'assegnazione. In quei
linguaggi, potresti scrivere `x = y = 6` e sia `x` che `y` avrebbero il valore
`6`; questo non è il caso in Rust.

Le espressioni valutano un valore e costituiscono la maggior parte del resto del codice che
scriverai in Rust. Considera un'operazione matematica, come `5 + 6`, che è un
espressione che valuta il valore `11`. Le espressioni possono far parte di
istruzioni: nella Listing 3-1, il `6` nell'istruzione `let y = 6;` è un
espressione che valuta il valore `6`. Chiamare una funzione è un
espressione. Chiamare un macro è un'espressione. Un nuovo blocco di ambito creato con
le parentesi graffe è un'espressione, per esempio:

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
è un blocco che, in questo caso, si valuta a `4`. Quel valore viene legato a `y`
come parte dell'istruzione `let`. Nota che la riga `x + 1` non ha un punto e virgola
alla fine, a differenza della maggior parte delle righe che hai visto finora.
Le espressioni non includono il punto e virgola finale. Se aggiungere un punto e virgola alla fine
di un'espressione, la trasformi in un'istruzione e non restituirà un valore. Tieni questo a mente mentre esplori i valori di ritorno delle funzioni e le espressioni.

### Funzioni con valori di ritorno

Le funzioni possono restituire valori al codice che le chiama. Non diamo un nome ai valori di ritorno,
ma dobbiamo dichiarare il loro tipo dopo una freccia (`->`). In Rust, il
valore di ritorno della funzione è sinonimo del valore dell'ultima espressione nel blocco del corpo di una funzione. Puoi ritornare prima dal funzione utilizzando la parola chiave `return` e specificando un value, ma la maggior parte delle funzioni ritorna l'ultima espressione implicitamente. Ecco un esempio di una funzione che ritorna un valore:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-21-function-return-values/src/main.rs}}
```

Non ci sono chiamate di funzione, macro o addirittura istruzioni `let`  nella funzione `five`, solo il numero `5` da solo. Questo è una funzione validissima in Rust. Nota che viene specificato anche il tipo di ritorno della funzione, come `-> i32`. Prova a eseguire questo codice; l'output dovrebbe essere così:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-21-function-return-values/output.txt}}
```

Il `5` in `five` è il valore di ritorno della funzione, motivo per cui il tipo di ritorno è `i32`. Esaminiamo questo in maggior dettaglio. Ci sono due parti importanti: prima, la riga `let x = five();` mostra che stiamo utilizzando il valore di ritorno di una funzione per inizializzare una variabile. Poiché la funzione `five` ritorna un `5`, quella riga equivale alla seguente:

```rust
let x = 5;
```

Secondo, la funzione `five` non ha parametri e definisce il tipo del valore di ritorno, ma il corpo della funzione è un solitario `5` senza punto e virgola perché è un'espressione il cui valore vogliamo restituire.

Diamo un'occhiata a un altro esempio:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-22-function-parameter-and-return/src/main.rs}}
```

Eseguendo questo codice stampa `Il valore di x è: 6`. Ma se mettiamo un punto e virgola alla fine della riga contenente `x + 1`, trasformandola da un'espressione in un'istruzione, otterremo un errore:

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-23-statements-dont-return-values/src/main.rs}}
```

Compilare questo codice produce un errore, come segue:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-23-statements-dont-return-values/output.txt}}
```

Il messaggio di errore principale, `tipi incompatibili`, rivela il problema centrale di questo codice. La definizione della funzione `plus_one` afferma che restituirà un `i32`, ma le istruzioni non si valutano in un valore, che è espresso da `()`, il tipo unita. Pertanto, non viene restituito nulla, il che contraddice la definizione della funzione e provoca un errore. In questo output, Rust fornisce un messaggio per aiutare a rettificare possibilmente questo problema: suggerisce di rimuovere il punto e virgola, che risolverebbe l'errore.

