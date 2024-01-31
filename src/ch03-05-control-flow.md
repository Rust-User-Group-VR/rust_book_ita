## Controllo del Flusso

La capacità di eseguire del codice a seconda che una condizione sia `true` e di
eseguire ripetutamente del codice mentre una condizione è `true` sono blocchi base
nella maggior parte dei linguaggi di programmazione. I costrutti più comuni che ti permettono di controllare
il flusso di esecuzione del codice Rust sono le espressioni `if` e i loop.

### Espressioni `if`

Un'espressione `if` ti permette di ramificare il tuo codice a seconda delle condizioni. Tu
fornisci una condizione e poi affermi, “Se questa condizione è soddisfatta, esegui questo blocco
di codice. Se la condizione non è soddisfatta, non eseguire questo blocco di codice."

Crea un nuovo progetto chiamato *branches* nella tua directory *projects* per esplorare
l'espressione `if`. Nel file *src/main.rs*, inserisci il seguente:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-26-if-true/src/main.rs}}
```

Tutte le espressioni `if` iniziano con la keyword `if`, seguita da una condizione. In
questo caso, la condizione controlla se il valore della variabile `number` sia
minore di 5. Piazziamo il blocco di codice da eseguire se la condizione è
`true` immediatamente dopo la condizione, tra parentesi graffe. I blocchi di codice
associati alle condizioni nelle espressioni `if` sono a volte chiamate *arms*,
proprio come le arms nelle espressioni `match` di cui abbiamo parlato nella sezione [“Comparare il tentativo con il Numero Segreto”][comparing-the-guess-to-the-secret-number]
del Capitolo 2.

Opzionalmente, possiamo includere anche un'espressione `else`, che abbiamo scelto di fare
qui, per fornire al programma un blocco di codice alternativo da eseguire nel caso la
condizione dia `false`. Se non fornisci un'espressione `else` e
la condizione è `false`, il programma salterà semplicemente il blocco `if` e procederà
con il prossimo pezzo di codice.

Prova ad eseguire questo codice; dovresti vedere il seguente output:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-26-if-true/output.txt}}
```

Proviamo a cambiare il valore di `number` con un valore che rende la condizione
`false` per vedere cosa succede:

```rust,ignore
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-27-if-false/src/main.rs:here}}
```

Esegui di nuovo il programma, e guarda l'output:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-27-if-false/output.txt}}
```

Vale anche la pena notare che la condizione in questo codice *deve* essere un `bool`. Se
la condizione non è un `bool`, otterremo un errore. Ad esempio, prova ad eseguire il
codice seguente:

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-28-if-condition-must-be-bool/src/main.rs}}
```

La condizione `if` valuta un valore di `3` questa volta, e Rust segnala un
errore:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-28-if-condition-must-be-bool/output.txt}}
```

L'errore indica che Rust si aspettava un `bool` ma ha ottenuto un intero. A differenza
dei linguaggi come Ruby e JavaScript, Rust non proverà automaticamente a
convertire i tipi non-Boolean in un Boolean. Devi essere esplicito e sempre fornire
`if` con un Boolean come sua condizione. Se vogliamo che il blocco di codice `if` sia eseguito
solo quando un numero non è uguale a `0`, ad esempio, possiamo cambiare l'espressione `if`
nella seguente:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-29-if-not-equal-0/src/main.rs}}
```

Eseguendo questo codice verrà stampato `number was something other than zero`.

#### Gestire Multiple Condizioni con `else if`

Puoi usare condizioni multiple combinando `if` e `else` in un'espressione `else if`.
For example:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-30-else-if/src/main.rs}}
```

Questo programma ha quattro possibili percorsi che può prendere. Dopo averlo eseguito, dovresti
vedere il seguente output:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-30-else-if/output.txt}}
```

Quando questo programma si esegue, controlla ogni espressione `if` di turno e esegue
il primo corpo per il quale la condizione dà `true`. Nota che anche se 6 è divisibile per 2, non vediamo l'output `number is divisible by 2`,
né vediamo il testo `number is not divisible by 4, 3, or 2` dal blocco `else`.
Questo è perché Rust esegue solo il blocco per la prima condizione `true`, e una volta che ne trova una, non controlla nemmeno le restanti.

Utilizzare troppe espressioni `else if` può rendere il tuo codice confuso, quindi se ne hai più
di uno, potresti voler rifattorizzare il tuo codice. Il Capitolo 6 descrive un potente
costrutto di branching Rust chiamato `match` per questi casi.

#### Usare `if` in un'istruzione `let`

Poiché `if` è un'espressione, possiamo usarlo sul lato destro di un'istruzione `let`
per assegnare l'esito a una variabile, come in Listing 3-2.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/listing-03-02/src/main.rs}}
```

<span class="caption">Listing 3-2: Assegnazione del risultato di un'espressione `if`
a una variabile</span>

La variabile `number` sarà vincolata a un valore basato sull'esito dell'espressione `if`.
Esegui questo codice per vedere cosa succede:

```console
{{#include ../listings/ch03-common-programming-concepts/listing-03-02/output.txt}}
```

Ricorda che i blocchi di codice valgono l'ultima espressione in essi, e
i numeri di per sé sono anche espressioni. In questo caso, il valore dell'intera espressione `if` dipende da quale blocco di codice viene eseguito. Questo significa che i
valori che hanno la possibilità di essere risultati da ciascuna arm dell'`if` devono essere
dello stesso tipo; nel Listing 3-2, i risultati sia dell'arm `if` che dell'arm `else`
erano interi `i32`. Se i tipi non corrispondono, come nell'esempio seguente, otteremo un errore:

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-31-arms-must-return-same-type/src/main.rs}}
```

Quando proviamo a compilare questo codice, otterremo un errore. Le arms `if` e `else`
hanno tipi di valori che sono incompatibili, e Rust indica esattamente dove reperire
il problema nel programma:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-31-arms-must-return-same-type/output.txt}}
```

L'espressione nel blocco `if` dà come risultato un intero, e l'espressione nel blocco `else` dà come risultato una stringa. Questo non funziona perché le variabili devono avere un singolo tipo, e Rust deve sapere al momento della compilazione quale tipo abbia la variabile `number`, definitivamente. Conoscere il tipo di `number` permette al compilatore di verificare che il tipo sia valido ovunque usiamo `number`. Rust non sarebbe in grado di farlo se il tipo di `number` fosse determinato solo a runtime; il compilatore sarebbe più complesso e avrebbe meno garanzie sul codice se avesse dovuto tenere traccia di molteplici tipi ipotetici per qualsiasi variabile.

### Ripetizione con Loop

È spesso utile eseguire un blocco di codice più di una volta. Per questo compito,
Rust fornisce diversi *loop*, che eseguiranno il codice all'interno del corpo del loop
fino alla fine e poi ricominceranno immediatamente dall'inizio. Per sperimentare
con i loop, creiamo un nuovo progetto chiamato *loop*.

Rust ha tre tipi di loop: `loop`, `while`, e `for`. Proviamo ciascuno di essi.

#### Ripetizione di Codice con `loop`

La keyword `loop` dice a Rust di eseguire un blocco di codice ancora e ancora
per sempre o fino a quando non gli dici esplicitamente di fermarsi.

Per esempio, cambia il file *src/main.rs* nella tua directory *loops* per farlo
assomigliare a questo:

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-32-loop/src/main.rs}}
```

Quando eseguiamo questo programma, vedremo `again!` stampato ripetutamente e ininterrottamente finché non fermiamo il programma manualmente. La maggior parte dei terminali supporta la scorciatoia da tastiera <span class="keystroke">ctrl-c</span> per interrompere un programma che è bloccato in un loop continuo. Provalo:

<!-- ricompilazione-manuale
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

Il simbolo `^C` rappresenta il punto in cui hai premuto <span class="keystroke">ctrl-c</span>. Potresti vedere o non vedere la parola `again!` stampata dopo il `^C`, a seconda di dove si trovava il codice nel loop quando ha ricevuto il segnale di interruzione.

Fortunatamente, Rust fornisce anche un modo per uscire da un loop tramite il codice. Puoi posizionare la parola chiave `break` all'interno del loop per dire al programma quando smettere di eseguire il loop. Ricorda che abbiamo fatto questo nel gioco di indovinare nel [“Quitting After a Correct Guess”][quitting-after-a-correct-guess]<!-- ignore --> del Capitolo 2 per uscire dal programma quando l'utente vinceva il gioco indovinando il numero corretto.

Abbiamo anche usato `continue` nel gioco di indovinare, che in un loop dice al programma di saltare tutto il codice rimanente in questa iterazione del loop e passare alla successiva iterazione.

#### Restituire Valori dai Loop

Uno degli usi di un `loop` è di ritentare un'operazione che sappiamo possa fallire, come verificare se un thread ha completato il suo lavoro. Potresti anche avere bisogno di passare il risultato di quell'operazione fuori dal loop al resto del tuo codice. Per fare ciò, puoi aggiungere il valore che desideri restituire dopo l'espressione `break` che usi per fermare il loop; quel valore verrà restituito fuori dal loop in modo da poterlo utilizzare, come mostrato qui:

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-33-return-value-from-loop/src/main.rs}}
```

Prima del loop, dichiariamo una variabile chiamata `counter` e la inizializziamo a `0`. Quindi dichiariamo una variabile chiamata `result` per contenere il valore restituito dal loop. Ad ogni iterazione del loop, aggiungiamo `1` alla variabile `counter`, e poi controlliamo se il `counter` è uguale a `10`. Quando lo è, usiamo la parola chiave `break` con il valore `counter * 2`. Dopo il loop, usiamo un punto e virgola per terminare l'istruzione che assegna il valore a `result`. Infine, stampiamo il valore in `result`, che in questo caso è `20`.

#### Etichette Loop per Disambiguare tra Multipli Loop

Se hai loop all'interno di loop, `break` e `continue` si applicano al loop più interno in quel punto. Puoi opzionalmente specificare un'etichetta di loop su un loop che puoi poi usare con `break` o `continue` per specificare che quelle parole chiave si applicano al loop etichettato invece che al loop più interno. Le etichette dei loop devono iniziare con un singolo apice. Ecco un esempio con due loop annidati:

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-32-5-loop-labels/src/main.rs}}
```

Il loop esterno ha l'etichetta `'counting_up`, e conterà da 0 a 2. Il loop interno senza etichetta conta al contrario da 10 a 9. Il primo `break` che non specifica un'etichetta uscirà solo dal loop interno. L'istruzione `break 'counting_up;` uscirà dal loop esterno. Questo codice stampa:

```console
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-32-5-loop-labels/output.txt}}
```

#### Loop Condizionali con `while`

Un programma avrà spesso bisogno di valutare una condizione all'interno di un loop. Mentre la condizione è `true`, il loop viene eseguito. Quando la condizione smette di essere `true`, il programma chiama `break`, fermando il loop. È possibile implementare un comportamento del genere utilizzando una combinazione di `loop`, `if`, `else`, e `break`; potresti provare a farlo ora in un programma, se lo desideri. Tuttavia, questo modello è così comune che Rust ha una costruzione di linguaggio integrata per esso, chiamata loop `while`. Nella Listing 3-3, usiamo `while` per ripetere il programma tre volte, contando al contrario ogni volta, e poi, dopo il loop, stampiamo un messaggio e usciamo.

<span class="filename">Nome file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/listing-03-03/src/main.rs}}
```

<span class="caption">Listing 3-3: Utilizzo di un loop `while` per eseguire del codice fino a quando una condizione rimane vera</span>

Questa costruzione elimina molte nidificazioni che sarebbero necessarie se tu usassi `loop`, `if`, `else`, e `break`, ed è più chiara. Mentre una condizione viene valutata come `true`, il codice viene eseguito; altrimenti, esce dal loop.

#### Ciclare Attraverso una Collezione con `for`

Puoi scegliere di usare la costruzione `while` per ciclare sugli elementi di una collezione, come un array. Ad esempio, il loop nella Listing 3-4 stampa ogni elemento nell'array `a`.

<span class="filename">Nome file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/listing-03-04/src/main.rs}}
```

<span class="caption">Listing 3-4: Ciclare attraverso ogni elemento di una collezione utilizzando un loop `while`</span>

Qui, il codice conta in ordine crescente attraverso gli elementi nell'array. Inizia dall'indice `0`, e poi continua fino a raggiungere l'indice finale nell'array (cioè, quando `index < 5` non è più `true`). Eseguendo questo codice verrà stampato ogni elemento dell'array:

```console
{{#include ../listings/ch03-common-programming-concepts/listing-03-04/output.txt}}
```

Come atteso, tutti e cinque i valori dell'array appaiono nel terminale. Anche se `index` raggiungerà un valore di `5` ad un certo punto, il loop si ferma prima di cercare di estrapolare un sesto valore dall'array.

Tuttavia, questo approccio è incline agli errori; potremmo causare il panico del programma se il valore dell'indice o la condizione di test fosse errata. Ad esempio, se cambiassi la definizione dell'array `a` per avere quattro elementi ma dimenticassi di aggiornare la condizione in `while index < 4`, il codice andrebbe in panico. È anche lento, perché il compilatore aggiunge del codice a runtime per eseguire il controllo condizionale su se l'indice è nei limiti dell'array ad ogni iterazione attraverso il loop.

Come alternativa più concisa, puoi utilizzare un loop `for` ed eseguire del codice per ogni elemento in una collezione. Un loop `for` somiglia al codice nella Listing 3-5.

<span class="filename">Nome file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/listing-03-05/src/main.rs}}
```

<span class="caption">Listing 3-5: Ciclare attraverso ogni elemento di una collezione utilizzando un loop `for`</span>

Quando eseguiamo questo codice, vedremo lo stesso output della Listing 3-4. Più importante, abbiamo ora aumentato la sicurezza del codice ed eliminato la possibilità di bug che potrebbero derivare dal superare la fine dell'array o dal non andare abbastanza lontano e mancare alcuni oggetti.

Utilizzando il loop `for`, non avresti bisogno di ricordare di cambiare altro codice se cambiassi il numero di valori nell'array, come avresti con il metodo utilizzato nella Listing 3-4.

La sicurezza e la concisione dei loop `for` li rendono il costrutto ad anello più comunemente usato in Rust. Anche in situazioni in cui vuoi eseguire del codice un certo numero di volte, come nell'esempio del conto alla rovescia che usava un loop `while` nella Listing 3-3, la maggior parte dei Rustaceans utilizzerebbe un loop `for`. Il modo per farlo sarebbe utilizzare un `Range`, fornito dalla libreria standard, che genera tutti i numeri in sequenza a partire da un numero e termina prima di un altro numero.

Ecco come apparirebbe il conto alla rovescia utilizzando un loop `for` e un altro metodo di cui non abbiamo ancora parlato, `rev`, per invertire l'intervallo:
<span class="filename">Nome file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-34-for-range/src/main.rs}}
```

Questo codice è un po' più gradevole, non è vero?

## Sommario

Ci sei riuscito! Questo è stato un capitolo sostanziale: hai appreso riguardo alle variabili, tipi di dati scalari e composti, funzioni, commenti, espressioni `if` e cicli! Per esercitarti con i concetti discussi in questo capitolo, prova a costruire programmi per fare il seguente:

* Convertire le temperature tra Fahrenheit e Celsius.
* Generare l'*n*-esimo numero di Fibonacci.
* Stampare il testo della canzone natalizia "The Twelve Days of Christmas",
  sfruttando la ripetizione nella canzone.

Quando sei pronto per proseguire, parleremo di un concetto in Rust che *non*
esiste comunemente in altri linguaggi di programmazione: Ownership.

[comparing-the-guess-to-the-secret-number]:
ch02-00-guessing-game-tutorial.html#comparando-il-tentativo-con-il-numero-segreto
[quitting-after-a-correct-guess]:
ch02-00-guessing-game-tutorial.html#uscire-dopo-un-tentativo-corretto


