## Controllo del flusso

La capacità di eseguire del codice a seconda se una condizione è `true` (vera) e di eseguire ripetutivamente del codice mentre una condizione è `true` sono elementi fondamentali in molti linguaggi di programmazione. Le strutture più comuni che ti permettono di controllare il flusso di esecuzione del codice Rust sono le espressioni `if` e i loop.

### Espressioni `if`

Un'espressione `if` ti permette di ramificare il tuo codice in base alle condizioni. Fornisci una condizione e poi affermi: "Se questa condizione è soddisfatta, esegui questo blocco di codice. Se la condizione non è soddisfatta, non eseguire questo blocco di codice."

Crea un nuovo progetto chiamato *branches* nella tua directory *projects* per esplorare l'espressione `if`. Nel file *src/main.rs*, inserisci il seguente:

<span class="filename">Nome file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-26-if-true/src/main.rs}}
```

Tutte le espressioni `if` iniziano con la keyword `if`, seguita da una condizione. In questo caso, la condizione controlla se o meno la variabile `number` ha un valore minore di 5. Applichiamo il blocco di codice da eseguire se la condizione è `true` immediatamente dopo la condizione tra parentesi graffe. I blocchi di codice associati alle condizioni nelle espressioni `if` sono a volte chiamati *arms* (bracci), proprio come i bracci nelle espressioni `match` che abbiamo discusso nella sezione [“Comparing the Guess to the Secret Number”][comparing-the-guess-to-the-secret-number]<!--
ignore --> del Capitolo 2.

Facoltativamente, possiamo anche includere un'espressione `else`, che abbiamo scelto di fare qui, per dare al programma un blocco di codice alternativo da eseguire nel caso in cui la condizione sia valutata come `false`. Se non fornisci un'espressione `else` e la condizione è `false`, il programma salterà semplicemente il blocco `if` e passerà al prossimo pezzo di codice.

Prova a eseguire questo codice; dovresti vedere il seguente output:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-26-if-true/output.txt}}
```

Proviamo a cambiare il valore di `number` con un valore che rende la condizione `false` per vedere cosa succede:

```rust,ignore
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-27-if-false/src/main.rs:here}}
```

Esegui di nuovo il programma, e guarda l'output:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-27-if-false/output.txt}}
```

È anche importante notare che la condizione in questo codice *deve* essere un `bool`. Se la condizione non è un `bool`, avremo un errore. Ad esempio, prova a eseguire il seguente codice:

<span class="filename">Nome file: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-28-if-condition-must-be-bool/src/main.rs}}
```

La condizione `if` valuta un valore di `3` questa volta, e Rust genera un errore:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-28-if-condition-must-be-bool/output.txt}}
```

L'errore indica che Rust si aspettava un `bool` ma ha ottenuto un intero. A differenza di linguaggi come Ruby e JavaScript, Rust non cercherà automaticamente di convertire tipi non Booleani in un Booleano. Devi essere esplicito e fornire sempre `if` con un Booleano come sua condizione. Se vogliamo che il blocco di codice `if` venga eseguito solo quando un numero non è uguale a `0`, ad esempio, possiamo cambiare l'espressione `if` nel seguente modo:

<span class="filename">Nome file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-29-if-not-equal-0/src/main.rs}}
```

Eseguendo questo codice verrà stampato `number was something other than zero` (il numero era qualcosa di diverso da zero).

#### Gestione di Multiple Condizioni con `else if`

Puoi usare multiple condizioni combinando `if` ed `else` in un'espressione `else if`. Ad esempio:

<span class="filename">Nome file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-30-else-if/src/main.rs}}
```

Questo programma ha quattro percorsi possibili che può prendere. Dopo averlo eseguito, dovresti vedere il seguente output:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-30-else-if/output.txt}}
```

Quando questo programma viene eseguito, verifica ciascuna espressione `if` in turno ed esegue il primo corpo per cui la condizione valuta `true`. Nota che anche se 6 è divisibile per 2, non vediamo l'output `number is divisible by 2` (il numero è divisibile per 2), né vediamo il testo `number is not divisible by 4, 3, or 2` (il numero non è divisibile per 4, 3 o 2) del blocco `else`. Questo perché Rust esegue solo il blocco per la prima condizione `true`, e una volta che trova uno, non controlla nemmeno il resto.

Usare troppe espressioni `else if` può appesantire il tuo codice, quindi se ne hai più di una, potresti voler rifattorizzare il tuo codice. Il Capitolo 6 descrive una potente struttura di ramificazione Rust chiamata `match` per questi casi.

#### Usando `if` in un'istruzione `let`

Poiché `if` è un'espressione, possiamo usarla sul lato destro di un'istruzione `let` per assegnare il risultato a una variabile, come nell'Elencazione 3-2.

<span class="filename">Nome file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/listing-03-02/src/main.rs}}
```

<span class="caption">Elencazione 3-2: Assegnare il risultato di un'espressione `if`
a una variabile</span>

La variabile `number` sarà legata a un valore basato sul risultato dell'espressione `if`. Esegui questo codice per vedere cosa succede:

```console
{{#include ../listings/ch03-common-programming-concepts/listing-03-02/output.txt}}
```

Ricorda che i blocchi di codice valutano l'ultima espressione in essi, e i numeri di per sé sono anche espressioni. In questo caso, il valore dell'intera espressione `if` dipende da quale blocco di codice esegue. Ciò significa che i valori che hanno il potenziale per essere risultati da ciascun braccio dell'`if` devono essere dello stesso tipo; nell'Elencazione 3-2, i risultati sia del braccio `if` che del braccio `else` erano interi `i32`. Se i tipi non coincidono, come nell'esempio seguente, avremo un errore:

<span class="filename">Nome file: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-31-arms-must-return-same-type/src/main.rs}}
```

Quando cerchiamo di compilare questo codice, otterremo un errore. I bracci `if` ed `else` hanno tipi di valore che sono incompatibili, e Rust indica esattamente dove trovare il problema nel programma:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-31-arms-must-return-same-type/output.txt}}
```

L'espressione nel blocco `if` valuta un intero, e l'espressione nel blocco `else` valuta una stringa. Questo non funzionerà perché le variabili devono avere un singolo tipo, e Rust ha bisogno di sapere a tempo di compilazione quale tipo la variabile `number` è, definitivamente. Conoscere il tipo di `number` permette al compilatore di verificare che il tipo sia valido ovunque usiamo `number`. Rust non sarebbe in grado di farlo se il tipo di `number` fosse solo determinato a runtime; il compilatore sarebbe più complesso e farebbe meno garanzie sul codice se dovesse tenere traccia di più tipi ipotetici per qualsiasi variabile.

### Ripetizione con Loop


È spesso utile eseguire un blocco di codice più di una volta. Per questo compito,
Rust fornisce diversi *loop*, che eseguiranno il codice all'interno del corpo del loop
fino alla fine, per poi ricominciare immediatamente dall'inizio. Per sperimentare
con i loop, creiamo un nuovo progetto chiamato *loops*.

Rust dispone di tre tipi di loop: `loop`, `while` e `for`. Proviamo ciascuno di essi.

#### Ripetizione del Codice con `loop`

La keyword `loop` dice a Rust di eseguire un blocco di codice ancora e ancora 
all'infinito o fino a quando non gli dici esplicitamente di fermarsi.

Come esempio, modifica il file *src/main.rs* nella tua cartella *loops* per farlo
sembrare a questo:

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-32-loop/src/main.rs}}
```

Quando eseguiamo questo programma, vedremo `again!` stampato continuamente
fino a quando non interrompiamo il programma manualmente. La maggior parte dei terminali supporta la 
scorciatoia da tastiera <span class="keystroke">ctrl-c</span> per interrompere un programma che è
intrappolato in un loop continuo. Prova:

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

Il simbolo `^C` rappresenta dove hai premuto <span
class="keystroke">ctrl-c</span>. Potresti o non vedere la parola `again!`
stampata dopo il `^C`, a seconda di dove si trovava il codice nel loop quando ha
ricevuto il segnale di interruzione.

Fortunatamente, Rust fornisce anche un modo per uscire da un loop utilizzando il codice. Tu
puoi posizionare la keyword `break` all'interno del loop per dire al programma quando smettere
di eseguire il loop. Ricorda che abbiamo fatto questo nel gioco della supposizione nella
[“Uscita Dopo una Supposizione Corretta”][quitting-after-a-correct-guess]<!-- ignore
--> sezione del Capitolo 2 per uscire dal programma quando l'utente vinceva il gioco
indovinando il numero corretto.

Abbiamo anche usato `continue` nel gioco di indovinare, che in un loop dice al programma
di saltare il resto del codice in questa iterazione del loop e andare all'iterazione
successiva.

#### Restituzione di Valori dai Loop

Uno degli usi di un `loop` è di riprovare una operazione che si sa può fallire, come
controllare se un thread ha completato il suo lavoro. Potresti anche avere bisogno di passare
il risultato di quell'operazione fuori dal loop al resto del tuo codice. Per fare
questo, puoi aggiungere il valore che vuoi restituire dopo l'espressione `break` che
usi per fermare il loop; quel valore sarà restituito dal loop in modo da poterlo
utilizzare, come mostrato qui:

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-33-return-value-from-loop/src/main.rs}}
```

Prima del loop, dichiariamo una variabile chiamata `counter` e la inizializziamo a
`0`. Quindi dichiariamo una variabile chiamata `result` per contenere il valore restituito da
il loop. Ad ogni iterazione del loop, aggiungiamo `1` alla variabile `counter`,
e poi controlliamo se il `counter` è uguale a `10`. Quando lo è, usiamo la
keyword `break` con il valore `counter * 2`. Dopo il loop, usiamo un
punto e virgola per terminare l'istruzione che assegna il valore a `result`. Infine, noi
stampiamo il valore in `result`, che in questo caso è `20`.

#### Etichette dei Loop per Disambiguare tra Loop Multipli

Se hai loop all'interno dei loop, `break` e `continue` si applicano al loop più interno
in quel punto. È possibile specificare opzionalmente un'etichetta di loop su un loop che
poi puoi usare con `break` o `continue` per specificare che quelle parole chiave
si applicano al loop etichettato invece che al loop più interno. Le etichette dei loop devono iniziare
con un singolo apice. Ecco un esempio con due loop annidati:

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-32-5-loop-labels/src/main.rs}}
```

Il loop esterno ha l'etichetta `'counting_up`, e conterà da 0 a 2.
Il loop interno senza etichetta conta a ritroso da 10 a 9. La prima `break` che
non specifica un'etichetta uscirà solo dal loop interno. L'istruzione `break
'counting_up;` uscirà dal loop esterno. Questo codice stampa:

```console
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-32-5-loop-labels/output.txt}}
```

#### Loop Condizionali con `while`

Un programma ha spesso bisogno di valutare una condizione all'interno di un loop. Mentre la
condizione è `true`, il loop gira. Quando la condizione smette di essere `true`, il
programma chiama `break`, fermando il loop. È possibile implementare un comportamento
come questo usando una combinazione di `loop`, `if`, `else`, e `break`; potresti
provare ora in un programma, se ti piace. Tuttavia, questo pattern è così comune
che Rust ha una costruzione di linguaggio incorporata per esso, chiamata loop `while`. In
elenco 3-3, usiamo `while` per loopare il programma tre volte, contando ogni volta, e poi, dopo il loop, stampiamo un messaggio e usciamo.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/listing-03-03/src/main.rs}}
```

<span class="caption">Elencazione 3-3: Utilizzo di un loop `while` per eseguire il codice mentre una
condizione rimane vera</span>

Questa costruzione elimina un sacco di annidamento che sarebbe necessario se hai usato
`loop`, `if`, `else`, e `break`, ed è più chiara. Mentre una condizione
si valuta a `true`, il codice viene eseguito; altrimenti, esce dal loop.

#### Looping Attraverso una Collezione con `for`

Puoi scegliere di usare la costruzione `while` per loopare attraverso gli elementi di una
collezione, come un array. Ad esempio, il loop nell'elenco 3-4 stampa ciascuno
elemento nell'array `a`.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/listing-03-04/src/main.rs}}
```

<span class="caption">Elenco 3-4: Loop attraverso ogni elemento di una collezione
utilizzando un loop `while`</span>

Qui, il codice conta attraverso gli elementi nell'array. Inizia all'indice
`0`, e poi loop fino a raggiungere l'indice finale nell'array (cioè,
quando `index < 5` non è più `true`). Eseguendo questo codice, verrà stampato ogni
elemento nell'array:

```console
{{#include ../listings/ch03-common-programming-concepts/listing-03-04/output.txt}}
```

Tutti e cinque i valori dell'array appaiono nel terminale, come previsto. Anche se `index`
raggiungerà un valore di `5` ad un certo punto, il loop si ferma di eseguire prima di provare
a prelevare un sesto valore dall'array.

Tuttavia, questo approccio è incline agli errori; potremmo causare il panico del programma se
il valore dell'indice o la condizione di test sono errati. Ad esempio, se hai cambiato la
definizione dell'array `a` per avere quattro elementi ma dimenticato di aggiornare la
condizione a `while index < 4`, il codice andrebbe nel panico. È anche lento, perché
il compilatore aggiunge codice di runtime per eseguire il controllo condizionale di se l'
l'indice è all'interno dei limiti dell'array ad ogni iterazione attraverso il loop.


Come alternativa più concisa, puoi utilizzare un ciclo `for` ed eseguire del codice
per ogni elemento di una collezione. Un ciclo `for` assomiglia al codice in Elenco 3-5.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/listing-03-05/src/main.rs}}
```

<span class="caption">Elenco 3-5: Esecuzione di un ciclo attraverso ciascun elemento di una collezione
utilizzando un ciclo `for`</span>

Quando eseguiamo questo codice, vedremo lo stesso output come in Elenco 3-4. Ancora più
importante, ora abbiamo aumentato la sicurezza del codice ed eliminato la
possibilità di bug che potrebbero derivare dal superamento della fine dell'array o dal non
andare abbastanza lontano e perdere alcuni elementi.

Utilizzando il ciclo `for`, non avresti bisogno di ricordare di cambiare altro codice se
hai cambiato il numero di valori nell'array, come faresti con il metodo
usato in Elenco 3-4.

La sicurezza e la concisione dei cicli `for` li rendono la costruzione di loop più comunemente usata
in Rust. Anche nelle situazioni in cui vuoi eseguire del codice un
certo numero di volte, come nell'esempio del conto alla rovescia che ha usato un ciclo `while`
in Elenco 3-3, la maggior parte dei Rustaceans utilizzerebbero un ciclo `for`. Il modo per fare ciò
sarebbe utilizzare un `Range`, fornito dalla libreria standard, che genera
tutti i numeri in sequenza a partire da un numero e terminando prima di un altro
numero.

Ecco come apparirebbe il conto alla rovescia utilizzando un ciclo `for` e un altro metodo
di cui non abbiamo ancora parlato, `rev`, per invertire l'intervallo:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-34-for-range/src/main.rs}}
```

Questo codice è un po' più bello, vero?

## Riassunto

Ce l'hai fatta! Questo è stato un capitolo consistente: hai appreso riguardo le variabili, i tipi di dati
scalari e composti, le funzioni, i commenti, le espressioni `if` e i cicli! Per
esercitarti con i concetti discussi in questo capitolo, prova a costruire programmi per
fare quanto segue:

* Convertire le temperature tra Fahrenheit e Celsius.
* Generare l'*n*-esimo numero di Fibonacci.
* Stampare i testi del canto natalizio “The Twelve Days of Christmas”,
  sfruttando la ripetizione nel brano.

Quando sei pronto per proseguire, parleremo di un concetto in Rust che *non*
esiste comunemente in altri linguaggi di programmazione: l'ownership.

[comparing-the-guess-to-the-secret-number]:
ch02-00-guessing-game-tutorial.html#comparing-the-guess-to-the-secret-number
[quitting-after-a-correct-guess]:
ch02-00-guessing-game-tutorial.html#quitting-after-a-correct-guess

