## Funzioni

Le funzioni sono prevalenti nel codice Rust. Hai già visto una delle funzioni più importanti del linguaggio: la funzione `main`, che è il punto di ingresso di molti programmi. Hai anche visto la parola chiave `fn`, che ti permette di dichiarare nuove funzioni.

Il codice Rust usa il *snake case* come stile convenzionale per i nomi di funzioni e variabili, in cui tutte le lettere sono minuscole e gli underscore separano le parole. Ecco un programma che contiene un esempio di definizione di funzione:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-16-functions/src/main.rs}}
```

Definiamo una funzione in Rust inserendo `fn` seguito da un nome di funzione e un set di parentesi. Le parentesi graffe indicano al compilatore dove inizia e finisce il blocco della funzione.

Possiamo chiamare una qualsiasi funzione che abbiamo definito inserendo il suo nome seguito da un set di parentesi. Poiché `another_function` è definita nel programma, può essere chiamata dall'interno della funzione `main`. Nota che abbiamo definito `another_function` *dopo* la funzione `main` nel codice sorgente; avremmo potuto definirla anche prima. A Rust non importa dove definisci le tue funzioni, l'importante è che siano definite da qualche parte in uno Scope visibile dal chiamante.

Iniziamo un nuovo progetto binario denominato *functions* per esplorare ulteriormente le funzioni. Inserisci l'esempio `another_function` in *src/main.rs* ed eseguilo. Dovresti vedere il seguente output:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-16-functions/output.txt}}
```

Le righe vengono eseguite nell'ordine in cui appaiono nella funzione `main`. Prima viene stampato il messaggio “Hello, world!” e poi viene chiamata `another_function` e viene stampato il suo messaggio.

### Parametri

Possiamo definire funzioni che hanno *parametri*, che sono variabili speciali parte della firma di una funzione. Quando una funzione ha parametri, puoi fornirle valori concreti per quei parametri. Tecnicamente, i valori concreti sono chiamati *argomenti*, ma in conversazioni informali, la gente tende a usare le parole *parametro* e *argomento* in modo intercambiabile sia per le variabili nella definizione di una funzione sia per i valori concreti passati quando chiami una funzione.

In questa versione di `another_function` aggiungiamo un parametro:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-17-functions-with-parameters/src/main.rs}}
```

Prova a eseguire questo programma; dovresti ottenere il seguente output:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-17-functions-with-parameters/output.txt}}
```

La dichiarazione di `another_function` ha un parametro chiamato `x`. Il tipo di `x` è specificato come `i32`. Quando passiamo `5` a `another_function`, la macro `println!` mette `5` dove la coppia di parentesi graffe contenente `x` si trovava nella stringa di formato.

Nelle firme delle funzioni, *devi* dichiarare il tipo di ciascun parametro. Questa è una decisione deliberata nel design di Rust: richiedere annotazioni di tipo nelle definizioni di funzione significa che il compilatore quasi mai ha bisogno che tu le usi altrove nel codice per capire a che tipo ti riferisci. Il compilatore è anche in grado di fornire messaggi di errore più utili se sa quali tipi la funzione si aspetta.

Quando definiamo più parametri, separiamo le dichiarazioni dei parametri con delle virgole, come segue:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-18-functions-with-multiple-parameters/src/main.rs}}
```

Questo esempio crea una funzione chiamata `print_labeled_measurement` con due parametri. Il primo parametro si chiama `value` ed è un `i32`. Il secondo si chiama `unit_label` ed è di tipo `char`. La funzione quindi stampa un testo contenente sia il `value` sia l'`unit_label`.

Proviamo a eseguire questo codice. Sostituisci il programma attualmente nel file *src/main.rs* del progetto *functions* con l'esempio precedente ed eseguilo usando `cargo run`:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-18-functions-with-multiple-parameters/output.txt}}
```

Poiché abbiamo chiamato la funzione con `5` come valore per `value` e `'h'` come valore per `unit_label`, l'output del programma contiene quei valori.

### Istruzioni ed Espressioni

I blocchi delle funzioni sono composti da una serie di istruzioni che terminano facoltativamente con un'espressione. Finora, le funzioni che abbiamo coperto non hanno incluso un'espressione finale, ma hai visto un'espressione come parte di un'istruzione. Poiché Rust è un linguaggio basato su espressioni, questa è una distinzione importante da comprendere. Altri linguaggi non hanno le stesse distinzioni, quindi vediamo cosa sono le istruzioni e le espressioni e come le loro differenze influenzano i blocchi delle funzioni.

* **Istruzioni** sono istruzioni che eseguono un'azione e non restituiscono un valore.
* **Espressioni** vengono valutate in un valore risultante. Vediamo alcuni esempi.

Abbiamo effettivamente già utilizzato istruzioni ed espressioni. Creare una variabile e assegnarle un valore con la parola chiave `let` è un'istruzione. Nel Listato 3-1, `let y = 6;` è un'istruzione.

<Listing number="3-1" file-name="src/main.rs" caption="Una dichiarazione di funzione `main` contenente un'istruzione">

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/listing-03-01/src/main.rs}}
```

</Listing>

Anche le definizioni delle funzioni sono istruzioni; l'intero esempio precedente è un'istruzione in sé. (Come vedremo sotto, *chiamare* una funzione non è un'istruzione.)

Le istruzioni non restituiscono valori. Pertanto, non puoi assegnare un'istruzione `let` a un'altra variabile, come il codice seguente cerca di fare; otterrai un errore:

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-19-statements-vs-expressions/src/main.rs}}
```

Quando esegui questo programma, l'errore che otterrai è il seguente:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-19-statements-vs-expressions/output.txt}}
```

L'istruzione `let y = 6` non restituisce un valore, quindi non c'è nulla a cui `x` possa vincolarsi. Questo è diverso da quanto accade in altri linguaggi, come C e Ruby, dove l'assegnazione restituisce il valore dell'assegnazione. In quei linguaggi, puoi scrivere `x = y = 6` e far avere sia a `x` sia a `y` il valore `6`; questo non è il caso in Rust.

Le espressioni vengono valutate in un valore e costituiscono la maggior parte del resto del codice che scriverai in Rust. Considera un'operazione matematica, come `5 + 6`, che è un'espressione che viene valutata al valore `11`. Le espressioni possono essere parte di istruzioni: nel Listato 3-1, il `6` nell'istruzione `let y = 6;` è un'espressione che viene valutata al valore `6`. Chiamare una funzione è un'espressione. Chiamare una macro è un'espressione. Un nuovo blocco Scope creato con parentesi graffe è un'espressione, per esempio:

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

è un blocco che, in questo caso, viene valutato in `4`. Quel valore viene vincolato a `y` come parte dell'istruzione `let`. Nota che la riga `x + 1` non ha un punto e virgola alla fine, il che è diverso dalla maggior parte delle righe che hai visto finora. Le espressioni non includono i punti e virgola finali. Se aggiungi un punto e virgola alla fine di un'espressione, la trasformi in un'istruzione, e quindi non restituirà un valore. Tieni a mente questo mentre esplori i valori di ritorno delle funzioni e le espressioni in seguito.

### Funzioni con Valori di Ritorno

Le funzioni possono restituire valori al codice che le chiama. Non assegniamo nomi ai valori di ritorno, ma dobbiamo dichiararne il tipo dopo una freccia (`->`). In Rust, il valore di ritorno della funzione è sinonimo del valore dell'espressione finale nel blocco del corpo di una funzione. Puoi restituire anticipatamente da una funzione usando la parola chiave `return` e specificando un valore, ma la maggior parte delle funzioni restituisce l'ultima espressione implicitamente. Ecco un esempio di una funzione che restituisce un valore:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-21-function-return-values/src/main.rs}}
```

Non ci sono chiamate di funzione, macro, o persino istruzioni `let` nella funzione `five`—solo il numero `5` da solo. È una funzione perfettamente valida in Rust. Nota anche che il tipo di ritorno della funzione è specificato come `-> i32`. Prova a eseguire questo codice; l'output dovrebbe apparire così:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-21-function-return-values/output.txt}}
```

Il `5` in `five` è il valore di ritorno della funzione, motivo per cui il tipo di ritorno è `i32`. Esaminiamo questo in più dettaglio. Ci sono due punti importanti: primo, la riga `let x = five();` mostra che stiamo usando il valore di ritorno di una funzione per inizializzare una variabile. Poiché la funzione `five` restituisce un `5`, quella riga è la stessa della seguente:

```rust
let x = 5;
```

Secondo, la funzione `five` non ha parametri e definisce il tipo del valore di ritorno, ma il corpo della funzione è un semplice `5` senza punto e virgola perché è un'espressione il cui valore vogliamo restituire.

Vediamo un altro esempio:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-22-function-parameter-and-return/src/main.rs}}
```

Eseguendo questo codice verrà stampato `The value of x is: 6`. Ma se mettiamo un punto e virgola alla fine della riga contenente `x + 1`, cambiandola da espressione a istruzione, otterremo un errore:

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-23-statements-dont-return-values/src/main.rs}}
```

Compilando questo codice viene generato un errore, come segue:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-23-statements-dont-return-values/output.txt}}
```

Il messaggio di errore principale, `mismatched types`, rivela il problema fondamentale di questo codice. La definizione della funzione `plus_one` dice che restituirà un `i32`, ma le istruzioni non si valutano in un valore, che è espresso da `()`, il tipo unitario. Pertanto, non viene restituito nulla, il che contraddice la definizione della funzione e risulta in un errore. In questo output, Rust fornisce un messaggio per possibilmente aiutare a rettificare questo problema: suggerisce di rimuovere il punto e virgola, il che risolverebbe l'errore.
