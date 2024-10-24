## Controllo del Flusso

La capacità di eseguire del codice in base al fatto che una condizione sia `true` e di eseguire del codice ripetutamente mentre una condizione è `true` sono blocchi di costruzione di base nella maggior parte dei linguaggi di programmazione. I costrutti più comuni che ti permettono di controllare il flusso di esecuzione del codice in Rust sono le espressioni `if` e i loop.

### Espressioni `if`

Un'espressione `if` ti permette di diramare il tuo codice a seconda delle condizioni. Fornisci una condizione e poi dichiari: "Se questa condizione è soddisfatta, esegui questo blocco di codice. Se la condizione non è soddisfatta, non eseguire questo blocco di codice."

Crea un nuovo progetto chiamato *branches* nella tua cartella *projects* per esplorare l'espressione `if`. Nel file *src/main.rs*, inserisci il seguente:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-26-if-true/src/main.rs}}
```

Tutte le espressioni `if` iniziano con la parola chiave `if`, seguita da una condizione. In questo caso, la condizione verifica se la variabile `number` ha un valore inferiore a 5. Mettiamo il blocco di codice da eseguire se la condizione è `true` immediatamente dopo la condizione tra parentesi graffe. I blocchi di codice associati alle condizioni nelle espressioni `if` sono talvolta chiamati *rami*, proprio come i rami nelle espressioni `match` di cui abbiamo discusso nella sezione [“Confrontare il Guess con il Numero Segreto”][comparing-the-guess-to-the-secret-number]<!-- ignore --> del Capitolo 2.

Facoltativamente, possiamo anche includere un'espressione `else`, cosa che abbiamo scelto di fare qui, per dare al programma un blocco di codice alternativo da eseguire nel caso in cui la condizione venga valutata come `false`. Se non fornisci un'espressione `else` e la condizione è `false`, il programma semplicemente salterà il blocco `if` e passerà alla prossima porzione di codice.

Prova a eseguire questo codice; dovresti vedere il seguente output:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-26-if-true/output.txt}}
```

Proviamo a cambiare il valore di `number` in un valore che rende la condizione `false` per vedere cosa succede:

```rust,ignore
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-27-if-false/src/main.rs:here}}
```

Esegui di nuovo il programma e guarda l'output:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-27-if-false/output.txt}}
```

Vale anche la pena notare che la condizione in questo codice *deve* essere un `bool`. Se la condizione non è un `bool`, riceveremo un errore. Ad esempio, prova a eseguire il seguente codice:

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-28-if-condition-must-be-bool/src/main.rs}}
```

La condizione `if` si valuta come un valore di `3` questa volta, e Rust genera un errore:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-28-if-condition-must-be-bool/output.txt}}
```

L'errore indica che Rust si aspettava un `bool` ma ha ottenuto un intero. A differenza di linguaggi come Ruby e JavaScript, Rust non tenterà automaticamente di convertire tipi non booleani in booleani. Devi essere esplicito e fornire sempre `if` con un booleano come condizione. Se vogliamo che il blocco di codice `if` venga eseguito solo quando un numero non è uguale a `0`, ad esempio, possiamo cambiare l'espressione `if` nel seguente modo:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-29-if-not-equal-0/src/main.rs}}
```

Eseguendo questo codice stamperà `number was something other than zero`.

#### Gestire Condizioni Multiple con `else if`

Puoi usare condizioni multiple combinando `if` e `else` in un'espressione `else if`. Ad esempio:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-30-else-if/src/main.rs}}
```

Questo programma ha quattro percorsi possibili che può seguire. Dopo averlo eseguito, dovresti vedere il seguente output:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-30-else-if/output.txt}}
```

Quando questo programma viene eseguito, verifica ogni espressione `if` a turno ed esegue il primo blocco per cui la condizione si valuta come `true`. Nota che anche se 6 è divisibile per 2, non vediamo l'output `number is divisible by 2`, né vediamo il testo `number is not divisible by 4, 3, or 2` dal blocco `else`. Questo perché Rust esegue solo il blocco per la prima condizione `true`, e una volta trovata una, non controlla nemmeno le altre.

Usare troppe espressioni `else if` può ingombrare il tuo codice, quindi se ne hai più di una, potresti voler rifattorizzare il tuo codice. Il Capitolo 6 descrive un potente costrutto di diramazione di Rust chiamato `match` per questi casi.

#### Uso di `if` in una Dichiarazione `let`

Poiché `if` è un'espressione, possiamo usarlo sul lato destro di una dichiarazione `let` per assegnare il risultato a una variabile, come nella Listing 3-2.

<Listing number="3-2" file-name="src/main.rs" caption="Assegnare il risultato di un'espressione `if` a una variabile">

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/listing-03-02/src/main.rs}}
```

</Listing>

La variabile `number` sarà vincolata a un valore in base al risultato dell'espressione `if`. Esegui questo codice per vedere cosa succede:

```console
{{#include ../listings/ch03-common-programming-concepts/listing-03-02/output.txt}}
```

Ricorda che i blocchi di codice si valutano con l'ultima espressione in essi, e anche i numeri da soli sono espressioni. In questo caso, il valore dell'intera espressione `if` dipende da quale blocco di codice viene eseguito. Ciò significa che i valori che hanno il potenziale di essere risultati da ciascun ramo dell'`if` devono essere dello stesso tipo; nella Listing 3-2, i risultati sia del ramo `if` sia del ramo `else` erano interi `i32`. Se i tipi non corrispondono, come nel seguente esempio, otterremo un errore:

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-31-arms-must-return-same-type/src/main.rs}}
```

Quando proviamo a compilare questo codice, otterremo un errore. I tipi di valore dei rami `if` e `else` sono incompatibili, e Rust indica esattamente dove trovare il problema nel programma:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-31-arms-must-return-same-type/output.txt}}
```

L'espressione nel blocco `if` si valuta come un intero, e l'espressione nel blocco `else` si valuta come una stringa. Questo non funziona perché le variabili devono avere un tipo unico, e Rust deve sapere in fase di compilazione quale tipo è la variabile `number`, in modo definitivo. Conoscere il tipo di `number` permette al compilatore di verificare che il tipo sia valido ovunque usiamo `number`. Rust non potrebbe farlo se il tipo di `number` fosse determinato solo a runtime; il compilatore sarebbe più complesso e farebbe meno garanzie sul codice se dovesse tenere traccia di più tipi ipotetici per qualsiasi variabile.

### Ripetizione con Loops

È spesso utile eseguire un blocco di codice più di una volta. Per questo compito, Rust fornisce diversi *loops*, che eseguiranno il codice all'interno del Blocco fino alla fine e poi ricominceranno immediatamente dall'inizio. Per sperimentare con i loop, creiamo un nuovo progetto chiamato *loops*.

Rust ha tre tipi di loop: `loop`, `while`, e `for`. Proviamo ciascuno di essi.

#### Ripetere il Codice con `loop`

La parola chiave `loop` dice a Rust di eseguire un blocco di codice in modo continuo per sempre o fino a quando non gli dici esplicitamente di fermarsi.

Come esempio, modifica il file *src/main.rs* nella tua cartella *loops* in questo modo:

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-32-loop/src/main.rs}}
```

Quando eseguiamo questo programma, vedremo `again!` stampato continuamente fino a quando non fermiamo il programma manualmente. La maggior parte dei terminali supporta la scorciatoia da tastiera <kbd>ctrl</kbd>-<kbd>c</kbd> per interrompere un programma bloccato in un loop continuo. Provalo:

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

Il simbolo `^C` rappresenta dove hai premuto <kbd>ctrl</kbd>-<kbd>c</kbd>. Potresti vedere o meno la parola `again!` stampata dopo il `^C`, a seconda di dove si trovava il codice nel ciclo quando ha ricevuto il segnale di interruzione.

Fortunatamente, Rust offre anche un modo per uscire da un loop usando il codice. Puoi posizionare la parola chiave `break` all'interno del loop per dire al programma quando smettere di eseguire il loop. Ricorda che abbiamo fatto questo nel gioco del guessing nella sezione [“Uscire Dopo un Indovinato Corretto”][quitting-after-a-correct-guess]<!-- ignore --> del Capitolo 2 per uscire dal programma quando l'utente ha vinto il gioco indovinando il numero corretto.

Abbiamo anche usato `continue` nel gioco del guessing, che in un loop dice al programma di ignorare qualsiasi codice rimanente in questa iterazione del loop e passare alla prossima iterazione.

#### Restituire Valori dai Loops

Uno degli usi di un `loop` è riprovare un'operazione che sai potrebbe fallire, come controllare se un thread ha completato il suo lavoro. Potresti anche avere bisogno di passare il risultato di quell'operazione fuori dal loop al resto del tuo codice. Per fare questo, puoi aggiungere il valore che vuoi restituire dopo l'espressione `break` che usi per fermare il loop; quel valore sarà restituito dal loop in modo che tu possa usarlo, come mostrato qui:

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-33-return-value-from-loop/src/main.rs}}
```

Prima del loop, dichiariamo una variabile chiamata `counter` e la inizializziamo a `0`. Poi dichiariamo una variabile chiamata `result` per contenere il valore restituito dal loop. Ad ogni iterazione del loop, aggiungiamo `1` alla variabile `counter`, e poi verifichiamo se `counter` è uguale a `10`. Quando lo è, usiamo la parola chiave `break` con il valore `counter * 2`. Dopo il loop, usiamo un punto e virgola per terminare l'istruzione che assegna il valore a `result`. Infine, stampiamo il valore in `result`, che in questo caso è `20`.

Puoi anche usare `return` dall'interno di un loop. Mentre `break` esce solo dal loop corrente, `return` esce sempre dalla funzione attuale.

#### Etichette di Loop per Disambiguare Tra Più Loop

Se hai loop all'interno di loop, `break` e `continue` si riferiscono al loop più interno in quel punto. Puoi opzionalmente specificare un'etichetta di *loop* su un loop che puoi poi utilizzare con `break` o `continue` per specificare che quelle parole chiave si applicano al loop etichettato invece del loop più interno. Le etichette di loop devono iniziare con un singolo apostrofo. Ecco un esempio con due loop annidati:

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-32-5-loop-labels/src/main.rs}}
```

Il loop esterno ha l'etichetta `'counting_up`, e conterà da 0 a 2. Il loop interno senza etichetta conta da 10 a 9. Il primo `break` che non specifica un'etichetta uscirà solo dal loop interno. L'istruzione `break 'counting_up;` uscirà dal loop esterno. Questo codice stampa:

```console
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-32-5-loop-labels/output.txt}}
```

#### Loops Condizionali con `while`

Un programma avrà spesso bisogno di valutare una condizione all'interno di un loop. Finché la condizione è `true`, il loop si esegue. Quando la condizione cessa di essere `true`, il programma chiama `break`, interrompendo il loop. È possibile implementare un comportamento del genere usando una combinazione di `loop`, `if`, `else`, e `break`; puoi provarlo ora in un programma, se vuoi. Tuttavia, questo schema è così comune che Rust ha un costrutto linguistico incorporato per esso, chiamato loop `while`. Nella Listing 3-3, usiamo `while` per eseguire il programma tre volte, riducendo il conteggio ogni volta, e poi, dopo il loop, stampare un messaggio e uscire.

<Listing number="3-3" file-name="src/main.rs" caption="Usare un loop `while` per eseguire del codice mentre una condizione è vera">

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/listing-03-03/src/main.rs}}
```

</Listing>

Questo costrutto elimina molta annidamento che sarebbe necessario se si utilizzasse `loop`, `if`, `else`, e `break`, ed è più chiaro. Finché una condizione viene valutata come `true`, il codice viene eseguito; altrimenti, esce dal loop.

#### Looping Attraverso una Collezione con `for`

Puoi anche usare il costrutto `while` per iterare sugli elementi di una collezione, come un array. Ad esempio, il loop nella Listing 3-4 stampa ogni elemento dell'array `a`.

<Listing number="3-4" file-name="src/main.rs" caption="Iterare su ciascun elemento di una collezione usando un ciclo `while`">

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/listing-03-04/src/main.rs}}
```

</Listing>

Qui, il codice conta attraverso gli elementi nell'array. Inizia all'indice `0`, e poi itera fino a raggiungere l'indice finale nell'array (cioè, quando `index < 5` non è più `true`). Eseguendo questo codice stamperà ogni elemento dell'array:

```console
{{#include ../listings/ch03-common-programming-concepts/listing-03-04/output.txt}}
```

Tutti e cinque i valori dell'array appaiono nel terminale, come previsto. Anche se `index` raggiungerà un valore di `5` ad un certo punto, il loop smette di eseguire prima di cercare di estrarre un sesto valore dall'array.

Tuttavia, questo approccio è soggetto a errori; potremmo causare il crash del programma se il valore dell'indice o la condizione del test sono errati. Ad esempio, se cambiassi la definizione dell'array `a` per avere quattro elementi ma dimenticassi di aggiornare la condizione a `while index < 4`, il codice si bloccherebbe. È anche lento, perché il compilatore aggiunge codice runtime per eseguire il controllo condizionale se l'indice è entro i limiti dell'array ad ogni iterazione attraverso il loop.

Come alternativa più concisa, puoi usare un ciclo `for` ed eseguire del codice per ogni elemento in una collezione. Un ciclo `for` appare come il codice nella Listing 3-5.

<Listing number="3-5" file-name="src/main.rs" caption="Iterare su ciascun elemento di una collezione usando un ciclo `for`">

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/listing-03-05/src/main.rs}}
```

</Listing>

Quando eseguiamo questo codice, vedremo lo stesso output della Listing 3-4. Più importante, ora abbiamo aumentato la sicurezza del codice ed eliminato la possibilità di bug che potrebbero derivare dall'andare oltre la fine dell'array o non andare abbastanza lontano e perdere alcuni elementi.

Utilizzando il ciclo `for`, non avresti bisogno di ricordarti di cambiare nessun altro codice se cambiassi il numero di valori nell'array, come faresti con il metodo usato nella Listing 3-4.
La sicurezza e la concisione dei cicli `for` li rendono la struttura di ciclo più comunemente utilizzata in Rust. Anche in situazioni in cui vuoi eseguire del codice un certo numero di volte, come nell'esempio del conto alla rovescia che utilizzava un ciclo `while` nel Listing 3-3, la maggior parte dei Rustaceans utilizzerebbe un ciclo `for`. Il modo per farlo sarebbe utilizzare un `Range`, fornito dalla libreria standard, che genera tutti i numeri in sequenza a partire da un numero e terminando prima di un altro numero.

Ecco come apparirebbe il conto alla rovescia utilizzando un ciclo `for` e un altro metodo di cui non abbiamo ancora parlato, `rev`, per invertire il range:

<span class="filename">Filename: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-34-for-range/src/main.rs}}
```

Questo codice è un po' più carino, non è vero?

## Riassunto

Ce l'hai fatta! Questo è stato un capitolo considerevole: hai imparato sulle variabili, sui tipi di dati scalari e composti, sulle funzioni, sui commenti, sulle espressioni `if` e sui cicli! Per esercitarti con i concetti discussi in questo capitolo, prova a costruire programmi per fare quanto segue:

* Converti le temperature tra Fahrenheit e Celsius.
* Genera l'ennesimo numero di Fibonacci.
* Stampa il testo della canzone di Natale “I Dodici Giorni di Natale”, approfittando della ripetizione nella canzone.

Quando sarai pronto a procedere, parleremo di un concetto in Rust che *non* esiste comunemente in altri linguaggi di programmazione: ownership.

[comparing-the-guess-to-the-secret-number]:
ch02-00-guessing-game-tutorial.html#comparing-the-guess-to-the-secret-number
[quitting-after-a-correct-guess]:
ch02-00-guessing-game-tutorial.html#quitting-after-a-correct-guess
