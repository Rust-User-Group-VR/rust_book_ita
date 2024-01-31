## Variabili e Mutabilità

Come menzionato nella sezione ["Memorizzazione dei Valori con Variabili"][storing-values-with-variables]<!-- ignore -->, di default, le variabili sono immutabili. Questo è uno dei molti suggerimenti che Rust ti dà per scrivere il tuo codice in un modo che sfrutta la sicurezza e la semplice concorrenza offerte da Rust. Tuttavia, hai ancora la possibilità di rendere le tue variabili mutabili. Esploriamo come e perché Rust ti incoraggia a preferire l'immutabilità e perché a volte potresti voler optare per l'opposto.

Quando una variabile è immutabile, una volta che un valore è legato a un nome, non puoi cambiare quel valore. Per illustrare questo, genera un nuovo progetto chiamato *variables* nella tua directory *projects* utilizzando `cargo new variables`.

Successivamente, nella tua nuova directory *variables*, apri *src/main.rs* e sostituisci il suo codice con il seguente codice, che per ora non compilerà:

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-01-variables-are-immutable/src/main.rs}}
```

Salva ed esegui il programma usando `cargo run`. Dovresti ricevere un messaggio di errore riguardante un errore di immutabilità, come mostrato in questo output:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-01-variables-are-immutable/output.txt}}
```

Questo esempio mostra come il compilatore ti aiuta a trovare gli errori nei tuoi programmi. Gli errori del compilatore possono essere frustranti, ma in realtà significano solo che il tuo programma non sta facendo in modo sicuro quello che vuoi che faccia; NON significano che non sei un buon programmatore! Anche gli esperti di Rust ricevono ancora errori del compilatore.

Hai ricevuto il messaggio di errore ``non posso assegnare due volte alla variabile immutabile `x` `` perché hai provato ad assegnare un secondo valore alla variabile `x` immutabile.

È importante che riceviamo errori a tempo di compilazione quando tentiamo di cambiare un valore designato come immutabile perché questa situazione può portare a bug. Se una parte del nostro codice funziona con l'assunto che un valore non cambierà mai e un'altra parte del nostro codice cambia quel valore, è possibile che la prima parte del codice non faccia quello che è stata progettata per fare. La causa di questo tipo di bug può essere difficile da rintracciare dopo, specialmente quando il secondo pezzo di codice cambia il valore solo *a volte*. Il compilatore di Rust garantisce che quando affermi che un valore non cambierà, realmente non cambierà, quindi non devi tenerne traccia tu stesso. Il tuo codice è quindi più facile da capire.

Ma la mutabilità può essere molto utile e può rendere il codice più comodo da scrivere. Nonostante le variabili siano immutabili di default, puoi renderle mutabili aggiungendo `mut` davanti al nome della variabile come hai fatto nel [Capitolo 2][storing-values-with-variables]<!-- ignore -->. Aggiungere `mut` trasmette anche l'intento ai futuri lettori del codice indicando che altre parti del codice cambieranno il valore di questa variabile.

Ad esempio, cambiamo *src/main.rs* nel seguente modo:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-02-adding-mut/src/main.rs}}
```

Quando eseguiamo il programma ora, otteniamo questo:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-02-adding-mut/output.txt}}
```

Ci viene permesso di cambiare il valore legato a `x` da `5` a `6` quando viene usato `mut`. In definitiva, la scelta di utilizzare la mutabilità o meno dipende da te e da quello che ritieni più chiaro in quella particolare situazione.

### Costanti

Come le variabili immutabili, le *costanti* sono valori che vengono legati a un nome e a cui non è permesso cambiare, ma ci sono alcune differenze tra costanti e variabili.

Prima di tutto, non ti è permesso usare `mut` con le costanti. Le costanti non sono solo immutabili di default: sono sempre immutabili. Dichiarati le costanti usando la parola chiave `const` invece di `let`, e il tipo del valore *deve* essere annotato. Affronteremo i tipi e le annotazioni di tipo nella prossima sezione, ["Tipi di Dati"][data-types]<!-- ignore -->, quindi non preoccuparti dei dettagli per ora. Sappi solo che devi sempre annotare il tipo.

Le costanti possono essere dichiarate in qualsiasi scope, inclusa la global scope, il che le rende utili per valori che molte parti del codice devono conoscere.

L'ultima differenza è che le costanti possono essere impostate solo su una espressione costante, non sul risultato di un valore che potrebbe essere calcolato solo a runtime.

Ecco un esempio di dichiarazione di costante:

```rust
const TRE_ORE_IN_SECONDI: u32 = 60 * 60 * 3;
```

Il nome della costante è `TRE_ORE_IN_SECONDI` e il suo valore è impostato sul risultato della moltiplicazione di 60 (il numero di secondi in un minuto) per 60 (il numero di minuti in un'ora) per 3 (il numero di ore che vogliamo contare in questo programma). La convenzione di denominazione di Rust per le costanti è quella di utilizzare tutte le lettere maiuscole con gli underscore tra le parole. Il compilatore è in grado di valutare un insieme limitato di operazioni a tempo di compilazione, il che ci permette di scrivere questo valore in un modo più facile da capire e verificare, piuttosto che impostare questa costante al valore 10.800. Consulta la sezione della [Rust Reference’s sulla valutazione costante][const-eval] per maggiori informazioni su quali operazioni possono essere utilizzate durante la dichiarazione delle costanti.

Le costanti sono valide per l'intero tempo di esecuzione di un programma, entro lo scope in cui sono state dichiarate. Questa proprietà rende le costanti utili per valori nel tuo dominio applicativo di cui potrebbero aver bisogno più parti del programma, come il numero massimo di punti che qualsiasi giocatore di un gioco è autorizzato a guadagnare, o la velocità della luce.

Nominare i valori hardcoded utilizzati in tutto il tuo programma come costanti è utile per trasmettere il significato di quel valore ai futuri manutentori del codice. È inoltre utile avere un solo posto nel tuo codice che dovresti cambiare se il valore hardcoded avesse bisogno di essere aggiornato in futuro.

### Shadowing

Come hai visto nel tutorial del gioco di indovinello nel [Capitolo 2][comparing-the-guess-to-the-secret-number]<!-- ignore -->, puoi dichiarare una nuova variabile con lo stesso nome di una variabile precedente. I Rustaceans dicono che la prima variabile è *shadowed* dalla seconda, il che significa che la seconda variabile è quella che il compilatore vedrà quando usi il nome della variabile. Di fatto, la seconda variabile oscura la prima, prendendo qualsiasi uso del nome della variabile a sé stessa finché essa stessa non viene oscurata o finisce lo scope. Possiamo fare l'ombra a una variabile utilizzando lo stesso nome della variabile e ripetendo l'uso della parola chiave `let` come segue:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-03-shadowing/src/main.rs}}
```

Questo programma lega prima `x` a un valore di `5`. Poi crea una nuova variabile `x` ripetendo `let x =`, prendendo il valore originale e aggiungendo `1` così il valore di `x` è quindi `6`. Poi, all'interno di uno scope interno creato con le parentesi graffe, la terza dichiarazione `let` ombrega anche `x` e crea una nuova variabile, moltiplicando il valore precedente per `2` per dare a `x` un valore di `12`. Quando quel scope è terminato, l'ombreggiatura interna termina e `x` ritorna ad essere `6`. Quando eseguiamo questo programma, darà il seguente output:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-03-shadowing/output.txt}}
```

L'ombreggiatura è diversa dal segnare una variabile come `mut` perché otterremo un errore a tempo di compilazione se cerchiamo accidentalmente di riassegnare a questa variabile senza usare la parola chiave `let`. Usando `let`, possiamo eseguire alcune trasformazioni su un valore ma avere la variabile immutabile dopo che queste trasformazioni sono state completate.

L'altra differenza tra `mut` e ombreggiatura è che dato che stiamo effettivamente creando una nuova variabile quando usiamo di nuovo la parola chiave `let`, possiamo cambiare il tipo del valore ma riutilizzare lo stesso nome. Per esempio, diciamo che il nostro programma chiede a un utente di mostrare quanti spazi vogliono tra un testo inserendo caratteri dello spazio, e poi vogliamo memorizzare quel input come numero:

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-04-shadowing-can-change-types/src/main.rs:here}}
```
La prima variabile `spaces` è di tipo stringa e la seconda variabile `spaces`
è di tipo numero. L'ombramento quindi ci risparmia di dover inventare
nomi differenti, come `spaces_str` e `spaces_num`; invece, possiamo riutilizzare
il nome più semplice `spaces`. Tuttavia, se cerchiamo di usare `mut` per questo, come mostrato
qui, otterremo un errore a tempo di compilazione:

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-05-mut-cant-change-types/src/main.rs:here}}
```

L'errore dice che non ci è permesso cambiare il tipo di una variabile:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-05-mut-cant-change-types/output.txt}}
```

Ora che abbiamo esplorato come funzionano le variabili, diamo un'occhiata ai più tipi di dati che
possono avere.

[comparing-the-guess-to-the-secret-number]:
ch02-00-guessing-game-tutorial.html#comparing-the-guess-to-the-secret-number
[data-types]: ch03-02-data-types.html#data-types
[storing-values-with-variables]: ch02-00-guessing-game-tutorial.html#storing-values-with-variables
[const-eval]: ../reference/const_eval.html

