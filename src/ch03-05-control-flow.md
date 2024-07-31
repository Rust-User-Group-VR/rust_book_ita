## Flusso di Controllo

La capacità di eseguire un po' di codice a seconda se una condizione sia `true` e di
eseguire un po' di codice ripetutamente mentre una condizione è `true` sono blocchi di costruzione di base
nella maggior parte dei linguaggi di programmazione. I costrutti più comuni che ti permettono di controllare
il flusso di esecuzione del codice Rust sono le espressioni `if` e i cicli.

### Espressioni `if`

Un'espressione `if` ti permette di ramificare il tuo codice a seconda delle condizioni. Tu
fornisci una condizione e poi dichiari: "Se questa condizione è soddisfatta, esegui questo blocco
di codice. Se la condizione non è soddisfatta, non eseguire questo blocco di codice."

Crea un nuovo progetto chiamato *branches* nella tua directory *projects* per esplorare
l'espressione `if`. Nel file *src/main.rs*, inserisci il seguente codice:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-26-if-true/src/main.rs}}
```

Tutte le espressioni `if` iniziano con la parola chiave `if`, seguita da una condizione. In
questo caso, la condizione verifica se la variabile `number` ha un valore inferiore a 5. Poniamo
il blocco di codice da eseguire se la condizione è `true` immediatamente dopo la condizione all'interno delle
parentesi graffe. I blocchi di codice associati alle condizioni nelle espressioni `if` a volte sono chiamati *bracci*,
proprio come i bracci nelle espressioni `match` di cui abbiamo parlato nella sezione [“Comparare
la Predizione con il Numero Segreto”][comparing-the-guess-to-the-secret-number]<!--
ignore --> del Capitolo 2.

Facoltativamente, possiamo anche includere un'espressione `else`, come abbiamo scelto di fare
qui, per dare al programma un blocco alternativo di codice da eseguire se
la condizione risulta `false`. Se non si fornisce un'espressione `else` e
la condizione è `false`, il programma salterà semplicemente il blocco `if` e passerà
alla prossima porzione di codice.

Prova a eseguire questo codice; dovresti vedere il seguente output:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-26-if-true/output.txt}}
```

Proviamo a cambiare il valore di `number` a un valore che rende la condizione
`false` per vedere cosa succede:

```rust,ignore
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-27-if-false/src/main.rs:here}}
```

Esegui di nuovo il programma e guarda l'output:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-27-if-false/output.txt}}
```

Vale anche la pena notare che la condizione in questo codice *deve* essere un `bool`. Se
la condizione non è un `bool`, otterremo un errore. Ad esempio, prova a eseguire il
seguente codice:

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-28-if-condition-must-be-bool/src/main.rs}}
```

La condizione `if` questa volta valuta un valore di `3`, e Rust lancia un
errore:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-28-if-condition-must-be-bool/output.txt}}
```

L'errore indica che Rust si aspettava un `bool` ma ha ottenuto un integer. A differenza
di linguaggi come Ruby e JavaScript, Rust non tenterà automaticamente
di convertire tipi non booleani in un Booleano. Devi essere esplicito e fornire sempre
`if` con un Booleano come condizione. Se vogliamo che il blocco di codice `if` venga
eseguito solo quando un numero non è uguale a `0`, ad esempio, possiamo cambiare l'espressione `if`
nel modo seguente:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-29-if-not-equal-0/src/main.rs}}
```

Eseguire questo codice stamperà `number was something other than zero`.

#### Gestione di Più Condizioni con `else if`

Puoi usare più condizioni combinando `if` e `else` in un'espressione `else if`.
Ad esempio:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-30-else-if/src/main.rs}}
```

Questo programma ha quattro possibili percorsi che può seguire. Dopo averlo eseguito, dovresti
vedere il seguente output:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-30-else-if/output.txt}}
```

Quando questo programma viene eseguito, verifica ogni espressione `if` a turno ed esegue
il primo corpo per cui la condizione valuta `true`. Nota che anche se 6 è divisibile per 2, non vediamo l'output `number is divisible by 2`,
né vediamo il testo `number is not divisible by 4, 3, or 2` dal blocco `else`. Questo perché Rust esegue solo il blocco per la prima condizione `true`,
e una volta trovata una, non verifica nemmeno le restanti.

Usare troppe espressioni `else if` può rendere il tuo codice ingombrante, quindi se hai
più di una, potresti voler rifattorizzare il tuo codice. Il Capitolo 6 descrive un potente
costrutto di ramificazione di Rust chiamato `match` per questi casi.

#### Uso di `if` in una Dichiarazione `let`

Poiché `if` è un'espressione, possiamo usarla sul lato destro di una dichiarazione `let`
per assegnare il risultato a una variabile, come mostrato nell'Elenco 3-2.

<Listing number="3-2" file-name="src/main.rs" caption="Assegnare il risultato di un'espressione `if` a una variabile">

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/listing-03-02/src/main.rs}}
```

</Listing>

La variabile `number` sarà legata a un valore basato sul risultato dell'espressione `if`.
Esegui questo codice per vedere cosa succede:

```console
{{#include ../listings/ch03-common-programming-concepts/listing-03-02/output.txt}}
```

Ricorda che i blocchi di codice valutano l'ultima espressione al loro interno, e
i numeri da soli sono anche espressioni. In questo caso, il valore dell'intera espressione `if`
dipende da quale blocco di codice viene eseguito. Questo significa che i valori che hanno il potenziale di essere risultati di ogni braccio dell'espressione `if` devono essere
dello stesso tipo; nell'Elenco 3-2, i risultati di entrambi i bracci `if` e `else`
erano numeri interi `i32`. Se i tipi non corrispondono, come nel seguente
esempio, otterremo un errore:

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-31-arms-must-return-same-type/src/main.rs}}
```

Quando proveremo a compilare questo codice, otterremo un errore. I bracci `if` e `else`
hanno tipi di valore incompatibili, e Rust indica esattamente dove trovare il problema all'interno del programma:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-31-arms-must-return-same-type/output.txt}}
```

L'espressione nel blocco `if` valuta a un numero intero, e l'espressione nel
blocco `else` valuta a una stringa. Questo non funzionerà perché le variabili devono
avere un singolo tipo, e Rust ha bisogno di sapere al momento della compilazione di quale tipo
è la variabile `number`, in modo definitivo. Conoscere il tipo di `number` permette al
compilatore di verificare che il tipo sia valido ovunque utilizziamo `number`. Rust non sarebbe
in grado di farlo se il tipo di `number` fosse determinato solo a runtime; il
compilatore sarebbe più complesso e farebbe meno garanzie sul codice se
dovesse tenere traccia di più tipi ipotetici per qualsiasi variabile.

### Ripetizione con i Cicli

Spesso è utile eseguire un blocco di codice più di una volta. Per questo compito,
Rust fornisce diversi *cicli*, che eseguiranno il codice all'interno del corpo del ciclo
fino alla fine e poi ripartiranno immediatamente dall'inizio. Per sperimentare
con i cicli, creiamo un nuovo progetto chiamato *loops*.

Rust ha tre tipi di cicli: `loop`, `while`, e `for`. Proviamoli tutti.

#### Ripetere Codice con `loop`

La parola chiave `loop` dice a Rust di eseguire un blocco di codice più e più volte
per sempre o finché non gli dici esplicitamente di fermarsi.

Come esempio, cambia il file *src/main.rs* nella tua directory *loops* per assomigliare
a questo:

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-32-loop/src/main.rs}}
```

Quando eseguiamo questo programma, vedremo `again!` stampato più e più volte continuamente
finché non interrompiamo manualmente il programma. La maggior parte dei terminali supporta la scorciatoia da tastiera
<kbd>ctrl</kbd>-<kbd>c</kbd> per interrompere un programma che è bloccato in un ciclo continuo. Prova:

<!-- manual-regeneration
cd listings/ch03-common-programming-concepts/no-listing-32-loop
cargo run
CTRL-C
-->

```console
$ cargo run
   Compiling loops v0.1.0 (file:///projects/loops)
    Finished dev [unoptimized + debuginfo] target(s) in 0.29s
     Running `target/debug/loops`
again!
again!
again!
again!
^Cagain!
```

Il simbolo `^C` rappresenta dove hai premuto <kbd>ctrl</kbd>-<kbd>c</kbd>. Potresti
vedere o meno la parola `again!` stampata dopo il `^C`, a seconda di dove
il codice si trovava nel ciclo quando ha ricevuto il segnale di interruzione.

Fortunatamente, Rust fornisce anche un modo per uscire da un ciclo utilizzando il codice. Puoi
posizionare la parola chiave `break` all'interno del ciclo per dire al programma quando smettere
di eseguire il ciclo. Ricorda che abbiamo fatto questo nel gioco delle ipotesi nella
sezione [“Uscire Dopo un'Ipotesi Corretta”][quitting-after-a-correct-guess]<!-- ignore
--> del Capitolo 2 per uscire dal programma quando l'utente ha vinto il gioco indovinando
il numero corretto.

Abbiamo anche usato `continue` nel gioco delle ipotesi, che in un ciclo dice al programma
di saltare qualsiasi codice rimanente in questa iterazione del ciclo e andare alla
successiva iterazione.

#### Ritornare Valori dai Cicli

Uno degli usi di un `loop` è riprovare un'operazione che sai potrebbe fallire, come
verificare se un thread ha completato il suo lavoro. Potresti anche aver bisogno di passare
il risultato di quell'operazione fuori dal ciclo al resto del tuo codice. Per
fare ciò, puoi aggiungere il valore che vuoi ritornato dopo l'espressione `break` che usi
per fermare il ciclo; quel valore verrà restituito fuori dal ciclo in modo che tu possa
usarlo, come mostrato qui:

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-33-return-value-from-loop/src/main.rs}}
```

Prima del ciclo, dichiariamo una variabile chiamata `counter` e la inizializziamo a
`0`. Poi dichiariamo una variabile chiamata `result` per contenere il valore restituito
dal ciclo. Ad ogni iterazione del ciclo, aggiungiamo `1` alla variabile `counter`,
e poi verifichiamo se il `counter` è uguale a `10`. Quando lo è, usiamo la
parola chiave `break` con il valore `counter * 2`. Dopo il ciclo, utilizziamo un
punto e virgola per terminare l'istruzione che assegna il valore a `result`. Infine, stampiamo
il valore in `result`, che in questo caso è `20`.

Puoi anche utilizzare `return` all'interno di un ciclo. Mentre `break` esce solo dal ciclo corrente, `return` esce sempre dalla funzione corrente.

#### Etichette di Ciclo per Disambiguare tra Più Cicli

Se hai cicli all'interno di cicli, `break` e `continue` si applicano al ciclo più interno
in quel punto. Puoi facoltativamente specificare un'etichetta di ciclo su un ciclo che puoi
usare poi con `break` o `continue` per specificare che quelle parole chiave
si applicano al ciclo etichettato anziché al ciclo più interno. Le etichette di ciclo devono iniziare
con un singolo apostrofo. Ecco un esempio con due cicli innestati:

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-32-5-loop-labels/src/main.rs}}
```

Il ciclo esterno ha l'etichetta `'counting_up`, e conterà da 0 a 2.
Il ciclo interno senza etichetta conta a ritroso da 10 a 9. Il primo `break` che
non specifica un'etichetta uscirà solo dal ciclo interno. L'istruzione `break
'counting_up;` uscirà dal ciclo esterno. Questo codice stampa:

```console
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-32-5-loop-labels/output.txt}}
```

#### Cicli Condizionali con `while`

Un programma avrà spesso bisogno di valutare una condizione all'interno di un ciclo. Mentre
la condizione è `true`, il ciclo si esegue. Quando la condizione cessa di essere `true`, il
programma chiama `break`, interrompendo il ciclo. È possibile implementare un
comportamento come questo utilizzando una combinazione di `loop`, `if`, `else`, e `break`; puoi
provare a farlo ora in un programma, se vuoi. Tuttavia, questo pattern è così comune
che Rust ha un costrutto integrato per esso, chiamato ciclo `while`. Nell'Elenco 3-3,
usiamo `while` per eseguire il programma tre volte, contando ogni volta, e poi, dopo il ciclo, stampare un messaggio ed uscire.

<Listing number="3-3" file-name="src/main.rs" caption="Usare un ciclo `while` per eseguire codice mentre una condizione risulta vera">

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/listing-03-03/src/main.rs}}
```

</Listing>

Questo costrutto elimina molta nidificazione che sarebbe necessaria se avessi usato
`loop`, `if`, `else`, e `break`, ed è più chiaro. Mentre una condizione
valuta come `true`, il codice viene eseguito; altrimenti, esce dal ciclo.

#### Ciclare Attraverso una Collezione con `for`

Puoi anche usare il costrutto `while` per cicli sugli elementi di una
collezione, come un array. Ad esempio, il ciclo nell'Elenco 3-4 stampa ciascun
elemento nell'array `a`.

<Listing number="3-4" file-name="src/main.rs" caption="Ciclare attraverso ciascun elemento di una collezione usando un ciclo `while`">

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/listing-03-04/src/main.rs}}
```

</Listing>

Qui, il codice conta attraverso gli elementi nell'array. Inizia dall'indice
`0`, e quindi cicla finché non raggiunge l'indice finale nell'array (cioè,
quando `index < 5` non è più `true`). Eseguendo questo codice, stamperà ogni
elemento nell'array:

```console
{{#include ../listings/ch03-common-programming-concepts/listing-03-04/output.txt}}
```

Tutti e cinque i valori dell'array compaiono nel terminale, come previsto. Anche se `index`
raggiungerà un valore di `5` ad un certo punto, il ciclo smette di eseguire prima di tentare
di recuperare un sesto valore dall'array.

Tuttavia, questo approccio è incline a errori; potremmo far sì che il programma vada in panic se
il valore dell'indice o la condizione di verifica è errata. Ad esempio, se cambi il
radicamento dell'array `a` per avere quattro elementi ma ti dimentichi di aggiornare la
condizione a `while index < 4`, il codice andrebbe in panic. È anche lento, perché
il compilatore aggiunge runtime di codice per eseguire il controllo condizionale sel'indice è all'interno dei limiti dell'array ad ogni iterazione attraverso il ciclo.

Come alternativa più concisa, puoi utilizzare un ciclo `for` ed eseguire del codice
per ciascun elemento in una collezione. Un ciclo `for` sembra il codice nell'Elenco 3-5.

<Listing number="3-5" file-name="src/main.rs" caption="Ciclare attraverso ciascun elemento di una collezione utilizzando un ciclo `for`">

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/listing-03-05/src/main.rs}}
```

</Listing>

Quando eseguiamo questo codice, vedremo lo stesso output dell'Elenco 3-4. Più
importante, abbiamo ora aumentato la sicurezza del codice ed eliminato la
possibilità di bug che potrebbero derivare dall'andare oltre la fine dell'array o dal
non andare abbastanza lontano e perdere alcuni elementi.

Utilizzando il ciclo `for`, non devi ricordarti di cambiare alcun altro codice se
cambi il numero di valori nell'array, come faresti con il metodo
usato nell'Elenco 3-4.


La sicurezza e la concisione dei cicli `for` li rendono la struttura di ciclo più comunemente usata in Rust. Anche in situazioni in cui si desidera eseguire un certo numero di volte un certo codice, come nell'esempio del conto alla rovescia che utilizzava un ciclo `while` nel Listing 3-3, la maggior parte dei Rustaceans userebbero un ciclo `for`. Il modo per farlo è utilizzare un `Range`, fornito dalla libreria standard, che genera tutti i numeri in sequenza a partire da un numero e terminando prima di un altro numero.

Ecco come apparirebbe il conto alla rovescia usando un ciclo `for` e un altro metodo di cui non abbiamo ancora parlato, `rev`, per invertire l'intervallo:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-34-for-range/src/main.rs}}
```

Questo codice è un po' più bello, vero?

## Riepilogo

Ce l'hai fatta! Questo è stato un capitolo considerevole: hai imparato variabili, tipi di dati scalari e composti, funzioni, commenti, espressioni `if` e cicli! Per esercitarti con i concetti discussi in questo capitolo, prova a costruire dei programmi per fare quanto segue:

* Convertire le temperature tra Fahrenheit e Celsius.
* Generare il numero Fibonacci *n*-esimo.
* Stampare il testo della canzone natalizia “The Twelve Days of Christmas”, sfruttando la ripetizione nella canzone.

Quando sei pronto per andare avanti, parleremo di un concetto in Rust che *non* esiste comunemente in altri linguaggi di programmazione: ownership.

[comparing-the-guess-to-the-secret-number]:
ch02-00-guessing-game-tutorial.html#comparing-the-guess-to-the-secret-number
[quitting-after-a-correct-guess]:
ch02-00-guessing-game-tutorial.html#quitting-after-a-correct-guess

