## Variabili e mutabilità

Come menzionato nella sezione [“Memorizzazione di valori con
variabili”][storing-values-with-variables]<!-- ignore -->, di default,
le variabili sono immutabili. Questo è uno dei tanti suggerimenti che Rust fornisce per scrivere
il tuo codice in modo tale da sfruttare la sicurezza e la facile concorrenza che
Rust offre. Tuttavia, hai ancora la possibilità di rendere le tue variabili mutabili.
Esploriamo come e perché Rust incoraggia a preferire l'immutabilità e perché
a volte potresti voler fare una scelta diversa.

Quando una variabile è immutabile, una volta che un valore è legato a un nome, non puoi cambiare
quel valore. Per illustrare questo, genera un nuovo progetto chiamato *variables* in
la tua directory *projects* usando `cargo new variables`.

Poi, nella tua nuova directory *variables*, apri *src/main.rs* e sostituisci il suo
codice con il seguente codice, che allo stato attuale non compila:

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-01-variables-are-immutable/src/main.rs}}
```

Salva ed esegui il programma usando `cargo run`. Dovresti ricevere un messaggio di errore riguardo un errore di immutabilità, come mostrato in questo output:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-01-variables-are-immutable/output.txt}}
```

Questo esempio mostra come il compilatore ti aiuta a trovare gli errori nei tuoi programmi.
Gli errori del compilatore possono essere frustranti, ma in realtà significano solo che il tuo programma
non sta facendo in modo sicuro quello che vuoi che faccia; non significano che non sei un bravo programmatore! Anche i programmatori Rust esperti ricevono errori del compilatore.

Hai ricevuto il messaggio di errore ``cannot assign twice to immutable variable `x``
`` perché hai cercato di assegnare un secondo valore alla variabile `x` immutabile.

È importante che otteniamo errori a tempo di compilazione quando tentiamo di cambiare un
valore che è designato come immutabile perché questa stessa situazione può portare a
bug. Se una parte del nostro codice opera con l'assunzione che un valore non cambierà mai e un'altra parte del nostro codice cambia quel valore, è possibile
che la prima parte del codice non faccia quello per cui è stata progettata. La causa
di questo tipo di bug può essere difficile da rintracciare a posteriori, soprattutto
quando la seconda parte del codice cambia il valore solo *a volte*. Il compilatore Rust garantisce che quando affermi che un valore non cambierà, in realtà
non cambierà, così non devi tenerne traccia da solo. Il tuo codice è quindi
più facile da ragionare.

Ma la mutabilità può essere molto utile e può rendere il codice più comodo da scrivere.
Sebbene le variabili siano immutabili di default, è possibile renderle mutabili aggiungendo `mut` di fronte al nome della variabile come hai fatto nel Capitolo
2][storing-values-with-variables]<!-- ignore -->. Aggiungere `mut` trasmette
anche l'intenzione ai futuri lettori del codice indicando che altre parti del codice
cambieranno il valore di questa variabile.

Ad esempio, modifichiamo *src/main.rs* nel seguente modo:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-02-adding-mut/src/main.rs}}
```

Quando eseguiamo il programma ora, otteniamo questo:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-02-adding-mut/output.txt}}
```

Siamo autorizzati a cambiare il valore legato a `x` da `5` a `6` quando viene
usato `mut`. In definitiva, decidere se utilizzare o meno la mutabilità dipende da te e
dipende da quello che ritieni più chiaro in quella particolare situazione.

### Costanti

Come le variabili immutabili, le *constanti* sono valori che sono legati a un nome e
non possono cambiare, ma ci sono alcune differenze tra costanti e variabili.

Prima di tutto, non è permesso usare `mut` con le costanti. Le costanti non sono solo
immutabili di default - sono sempre immutabili. Dichiarare costanti usando la
parola chiave `const` invece di `let`, e il tipo del valore *deve*
essere annotato. Copriremo i tipi e le annotazioni dei tipi nella prossima sezione,
[“Tipi di dati”][data-types]<!-- ignore -->, quindi non preoccuparti dei dettagli
adesso. Sappi solo che devi sempre annotare il tipo.

Le costanti possono essere dichiarate in qualsiasi ambito, incluso l'ambito globale, il che le rende utili per i valori che molte parti del codice devono conoscere.

L'ultima differenza è che le costanti possono essere impostate solo su un'espressione costante,
non il risultato di un valore che potrebbe essere calcolato solo a runtime.

Ecco un esempio di dichiarazione di una costante:

```rust
const THREE_HOURS_IN_SECONDS: u32 = 60 * 60 * 3;
```

Il nome della costante è `THREE_HOURS_IN_SECONDS` e il suo valore è impostato sul
risultato della moltiplicazione di 60 (il numero di secondi in un minuto) per 60 (il numero
di minuti in un ora) per 3 (il numero di ore che vogliamo contare in questo
programma). La convenzione di denominazione di Rust per le costanti è utilizzare tutti i caratteri maiuscoli con
gli underscore tra le parole. Il compilatore è in grado di valutare un numero limitato di
operazioni a tempo di compilazione, il che ci permette di scegliere di scrivere questo valore in un
modo che sia più facile da comprendere e verificare, piuttosto che impostare questa costante
al valore 10,800. Vedi la sezione sulle valutazioni costanti delle [Referenze di Rust][const-eval] per maggiori informazioni sulle operazioni che possono essere utilizzate
quando si dichiarano costanti.

Le costanti sono valide per l'intero tempo di esecuzione di un programma, all'interno dell'ambito in
cui sono state dichiarate. Questa proprietà rende le costanti utili per i valori nel
ambito di applicazione del tuo programma di cui molte parti possono aver bisogno di sapere,
come il numero massimo di punti che qualsiasi giocatore di un gioco è autorizzato a
ottenere, o la velocità della luce.

Denominare i valori codificati utilizzati in tutto il tuo programma come costanti è utile nel
trasmettere il significato di quel valore ai futuri manutentori del codice. È anche
utile avere un solo posto nel tuo codice a cui dovrai apportare modifiche se il
valore codificato dovesse esser aggiornato in futuro.

### Shadowing

Come hai già visto nel tutorial del gioco di indovinanza al Capitolo
2][comparing-the-guess-to-the-secret-number]<!-- ignore -->, puoi dichiarare una
nuova variabile con lo stesso nome di una variabile precedente. I Rustacei dicono che la
prima variabile è *oscurata* dalla seconda, il che significa che la seconda
variabile sarà quella che il compilatore vedrà quando utilizzi il nome della variabile.
In effetti, la seconda variabile fa ombra alla prima, prendendo qualsiasi uso del nome della variabile per sé fino a quando non viene a sua volta oscurata o finisce l'ambito.
Possiamo oscurare una variabile utilizzando lo stesso nome della variabile e ripetendo l'uso della parola chiave `let` come segue:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-03-shadowing/src/main.rs}}
```

Questo programma lega prima `x` a un valore di `5`. Poi crea una nuova variabile
`x` ripetendo `let x =`, prendendo il valore originale e aggiungendo `1` così il
valore di `x` è poi `6`. Poi, all'interno di un ambito interno creato con le parentesi graffe, la terza dichiarazione `let` oscura anche `x` e crea una nuova
variabile, moltiplicando il valore precedente per `2` per dare a `x` un valore di `12`.
Quando quell'ambito è finito, l'oscuramento interno termina e `x` ritorna ad essere `6`.
Quando eseguiamo questo programma, avrà il seguente output:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-03-shadowing/output.txt}}
```

Il shadowing è diverso dall'etichettare una variabile come `mut` perché otterremo a
errore a tempo di compilazione se proviamo accidentalmente a riassegnare a questa variabile senza
usare la parola chiave `let`. Usando `let`, possiamo eseguire alcune trasformazioni
su un valore ma avere la variabile immutabile dopo che queste trasformazioni sono state completate.

L'altra differenza tra `mut` e shadowing è che poiché stiamo
effettivamente creando una nuova variabile quando usiamo di nuovo la parola chiave `let`, possiamo
cambiare il tipo del valore ma riutilizzare lo stesso nome. Ad esempio, supponiamo che il nostro
programma chieda a un utente di indicare quanti spazi vuole tra del testo inserendo caratteri spazio, e poi vogliamo memorizzare quell'input come un numero:

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-04-shadowing-can-change-types/src/main.rs:here}}
```
La prima variabile `spaces` è di tipo stringa e la seconda variabile `spaces` è di tipo numerico. Grazie all'ombreggiamento, non dobbiamo inventarci nomi diversi, come `spaces_str` e `spaces_num`; invece, possiamo riutilizzare il più semplice nome `spaces`. Tuttavia, se proviamo ad usare `mut` per questo, come mostrato qui, avremo un errore di compilazione:

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-05-mut-cant-change-types/src/main.rs:here}}
```

L'errore indica che non ci è permesso mutare il tipo di una variabile:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-05-mut-cant-change-types/output.txt}}
```

Ora che abbiamo esplorato come funzionano le variabili, diamo un'occhiata ad altri tipi di dati che possono avere.

[comparing-the-guess-to-the-secret-number]:
ch02-00-guessing-game-tutorial.html#comparing-the-guess-to-the-secret-number
[data-types]: ch03-02-data-types.html#data-types
[storing-values-with-variables]: ch02-00-guessing-game-tutorial.html#storing-values-with-variables
[const-eval]: ../reference/const_eval.html

