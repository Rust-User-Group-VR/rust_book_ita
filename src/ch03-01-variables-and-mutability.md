## Variabili e Mutabilità

Come menzionato nella sezione [“Memorizzare i Valori con le Variabili”][storing-values-with-variables]<!-- ignore -->, di default, le variabili sono immutabili. Questo è uno dei tanti suggerimenti che Rust ti offre per scrivere il codice in un modo che sfrutti la sicurezza e la facilità di concurrency che Rust offre. Tuttavia, hai ancora l'opzione di rendere le tue variabili mutabili. Esploriamo come e perché Rust ti incoraggia a preferire l'immutabilità e perché a volte potresti voler rinunciare a questa preferenza.

Quando una variabile è immutabile, una volta che un valore è legato a un nome, non puoi cambiare quel valore. Per illustrarlo, genera un nuovo progetto chiamato *variables* nella tua directory *projects* utilizzando `cargo new variables`.

Poi, nella tua nuova directory *variables*, apri *src/main.rs* e sostituisci il suo codice con il seguente codice, che non sarà ancora compilabile:

<span class="filename">Nome file: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-01-variables-are-immutable/src/main.rs}}
```

Salva ed esegui il programma utilizzando `cargo run`. Dovresti ricevere un messaggio di errore relativo ad un errore di immutabilità, come mostrato in questo output:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-01-variables-are-immutable/output.txt}}
```

Questo esempio mostra come il compilatore ti aiuti a trovare errori nei tuoi programmi. Gli errori del compilatore possono essere frustranti, ma in realtà significano solo che il tuo programma non sta ancora facendo in sicurezza ciò che vuoi che faccia; non significano che tu non sia un buon programmatore! Anche i Rustaceans esperti ricevono errori dal compilatore.

Hai ricevuto il messaggio di errore `` cannot assign twice to immutable variable `x` `` perché hai cercato di assegnare un secondo valore alla variabile immutable `x`.

È importante che otteniamo errori al momento della compilazione quando tentiamo di cambiare un valore designato come immutabile perché questa situazione può portare a bug. Se una parte del nostro codice opera con l'assunzione che un valore non cambierà mai e un'altra parte del nostro codice cambia quel valore, è possibile che la prima parte del codice non faccia ciò per cui è stata progettata. La causa di questo tipo di bug può essere difficile da individuare dopo il fatto, specialmente quando la seconda parte del codice cambia il valore solo *a volte*. Il compilatore Rust garantisce che quando si dichiara che un valore non cambierà, realmente non cambierà, così non devi tenerne traccia da solo. Il tuo codice è quindi più facile da ragionare.

Ma la mutabilità può essere molto utile, e può rendere il codice più conveniente da scrivere. Anche se le variabili sono immutabili per default, puoi renderle mutabili aggiungendo `mut` davanti al nome della variabile come hai fatto nel [Capitolo 2][storing-values-with-variables]<!-- ignore -->. Aggiungendo `mut` si esprime anche l'intento ai futuri lettori del codice, indicando che altre parti del codice cambieranno il valore di questa variabile.

Per esempio, cambiamo *src/main.rs* con il seguente:

<span class="filename">Nome file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-02-adding-mut/src/main.rs}}
```

Quando eseguiamo il programma ora, otteniamo questo:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-02-adding-mut/output.txt}}
```

Ci è permesso cambiare il valore legato a `x` da `5` a `6` quando viene usato `mut`. Alla fine, decidere se usare la mutabilità o meno dipende da te e dipende da ciò che pensi sia più chiaro in quella particolare situazione.

### Costanti

Come le variabili immutabili, le *costanti* sono valori che sono legati a un nome e non sono permessi cambiamenti, ma ci sono alcune differenze tra costanti e variabili.

Per prima cosa, non è permesso usare `mut` con le costanti. Le costanti non sono solo immutabili per default, sono sempre immutabili. Dichiarare costanti utilizzando la parola chiave `const` invece di `let`, e il tipo del valore *deve* essere annotato. Copriremo i tipi e le annotazioni di tipo nella prossima sezione, [“Tipi di Dati”][data-types]<!-- ignore -->, quindi non preoccuparti dei dettagli al momento. Sappi solo che devi sempre annotare il tipo.

Le costanti possono essere dichiarate in qualsiasi Scope, incluso lo Scope globale, il che le rende utili per valori che molte parti del codice devono conoscere.

L'ultima differenza è che le costanti possono essere impostate solo su un'espressione costante, non sul risultato di un valore che può essere calcolato solo a runtime.

Ecco un esempio di dichiarazione di una costante:

```rust
const THREE_HOURS_IN_SECONDS: u32 = 60 * 60 * 3;
```

Il nome della costante è `THREE_HOURS_IN_SECONDS` e il suo valore è impostato sul risultato di una moltiplicazione di 60 (il numero di secondi in un minuto) per 60 (il numero di minuti in un'ora) per 3 (il numero di ore che vogliamo contare in questo programma). La convenzione dei nomi di Rust per le costanti è di usare tutte le lettere maiuscole con trattini bassi tra le parole. Il compilatore è in grado di valutare un set limitato di operazioni al momento della compilazione, il che ci permette di scegliere di scrivere questo valore in modo che sia più facile da comprendere e verificare, piuttosto che impostare questa costante al valore 10,800. Vedere la [sezione di valutazione delle costanti del riferimento Rust][const-eval] per ulteriori informazioni su quali operazioni possono essere utilizzate quando si dichiarano costanti.

Le costanti sono valide per tutto il tempo in cui un programma è in esecuzione, all'interno dello Scope in cui sono state dichiarate. Questa proprietà rende le costanti utili per i valori nel tuo dominio applicativo di cui più parti del programma potrebbero avere bisogno di sapere, come il numero massimo di punti che qualsiasi giocatore di un gioco è autorizzato a guadagnare, o la velocità della luce.

Dare nomi ai valori hardcoded utilizzati in tutto il tuo programma come costanti è utile per trasmettere il significato di quel valore ai futuri manutentori del codice. Aiuta anche a avere un solo punto nel tuo codice che avresti bisogno di cambiare se il valore hardcoded dovesse essere aggiornato in futuro.

### Shadowing

Come hai visto nel tutorial del gioco di indovina in [Capitolo 2][comparing-the-guess-to-the-secret-number]<!-- ignore -->, puoi dichiarare una nuova variabile con lo stesso nome di una variabile precedente. I Rustaceans dicono che la prima variabile è *shadowed* dalla seconda, il che significa che la seconda variabile è ciò che il compilatore vedrà quando usi il nome della variabile. In pratica, la seconda variabile oscura la prima, prendendo per sé qualsiasi utilizzo del nome della variabile fino a quando o essa stessa viene shadowed o lo Scope termina. Possiamo fare shadowing di una variabile usando il nome della variabile stesso e ripetendo l'uso del keyword `let` come segue:

<span class="filename">Nome file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-03-shadowing/src/main.rs}}
```

Questo programma lega prima `x` a un valore di `5`. Poi crea una nuova variabile `x` ripetendo `let x =`, prendendo il valore originale e aggiungendo `1` così che il valore di `x` diventa `6`. Poi, all'interno di un ambito interno creato con le parentesi graffe, la terza dichiarazione `let` fa anche shadowing di `x` e crea una nuova variabile, moltiplicando il valore precedente per `2` per dare a `x` un valore di `12`. Quando quell'ambito è finito, lo shadowing interno termina e `x` torna a essere `6`. Quando eseguiamo questo programma, stamperà il seguente output:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-03-shadowing/output.txt}}
```

Lo shadowing è diverso dal marcare una variabile come `mut` perché otterremo un errore al momento della compilazione se proviamo accidentalmente a riassegnare a questa variabile senza usare il keyword `let`. Usando `let`, possiamo eseguire alcune trasformazioni su un valore ma avere la variabile immutabile dopo che tali trasformazioni sono state completate.

L'altra differenza tra `mut` e lo shadowing è che poiché stiamo effettivamente creando una nuova variabile quando utilizziamo nuovamente il keyword `let`, possiamo cambiare il tipo del valore ma riutilizzare lo stesso nome. Per esempio, supponiamo che il nostro programma chieda a un utente di mostrare quanti spazi vogliono tra un testo inserendo caratteri di spazio, e poi vogliamo memorizzare quell'input come numero:

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-04-shadowing-can-change-types/src/main.rs:here}}
```

La prima variabile `spaces` è di tipo stringa e la seconda variabile `spaces` è di tipo numero. Lo shadowing ci risparmia quindi dal dover inventare nomi diversi, come `spaces_str` e `spaces_num`; invece, possiamo riutilizzare il nome più semplice `spaces`. Tuttavia, se proviamo a utilizzare `mut` per questo, come mostrato qui, otterremo un errore al momento della compilazione:

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-05-mut-cant-change-types/src/main.rs:here}}
```

L'errore dice che non ci è permesso mutare il tipo di una variabile:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-05-mut-cant-change-types/output.txt}}
```

Ora che abbiamo esplorato come funzionano le variabili, diamo uno sguardo a più tipi di dati che possono avere.

[comparing-the-guess-to-the-secret-number]: ch02-00-guessing-game-tutorial.html#comparing-the-guess-to-the-secret-number
[data-types]: ch03-02-data-types.html#data-types
[storing-values-with-variables]: ch02-00-guessing-game-tutorial.html#storing-values-with-variables
[const-eval]: ../reference/const_eval.html
