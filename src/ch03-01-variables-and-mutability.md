## Variabili e Mutabilità

Come menzionato nella sezione ["Memorizzare Valori con
Variabili"][storing-values-with-variables]<!-- ignore -->, di default,
le variabili sono immutabili. Questo è uno dei numerosi suggerimenti che Rust ti fornisce per scrivere
il tuo codice in modo che sfrutti la sicurezza e la facile concorrenza che
Rust offre. Tuttavia, hai ancora l'opzione di rendere le tue variabili mutabili.
Esploriamo come e perché Rust ti incoraggia a favorire l'immutabilità e perché
a volte potresti voler optare per la mutabilità.

Quando una variabile è immutabile, una volta che un valore è associato a un nome, non puoi cambiare
quel valore. Per illustrare ciò, genera un nuovo progetto chiamato *variables* nel
tua cartella *projects* utilizzando `cargo new variables`.

Poi, nella tua nuova cartella *variables*, apri *src/main.rs* e sostituisci il suo
codice con il seguente codice, che non compilerà ancora:

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-01-variables-are-immutable/src/main.rs}}
```

Salva ed esegui il programma usando `cargo run`. Dovresti ricevere un messaggio di errore
riguardante un errore di immutabilità, come mostrato in questo output:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-01-variables-are-immutable/output.txt}}
```

Questo esempio mostra come il compilatore ti aiuta a trovare errori nei tuoi programmi.
Gli errori del compilatore possono essere frustranti, ma in realtà significano solo che il tuo programma
non sta facendo in sicurezza quello che vuoi che faccia ancora; NON significa che non sei
un bravo programmatore! Anche i Rustaceans esperti ricevono ancora errori del compilatore.

Hai ricevuto il messaggio di errore ``non posso assegnare due volte alla variabile immutabile `x``
perché hai cercato di assegnare un secondo valore alla variabile immutabile `x`.

È importante che otteniamo errori a tempo di compilazione quando tentiamo di cambiare un
valore che è designato come immutabile perché questa situazione può portare a
bug. Se una parte del nostro codice opera sotto l'assunzione che un valore non cambierà mai e un'altra parte del nostro codice cambia quel valore, è possibile
che la prima parte del codice non faccia ciò che era stata progettata per fare. La causa
di questo tipo di bug può essere difficile da rintracciare dopo il fatto, soprattutto
quando la seconda parte del codice cambia il valore solo *a volte*. Il
compilatore Rust garantisce che quando affermi che un valore non cambierà, non lo farà davvero
cambiare, quindi non devi tenerne traccia tu stesso. Il tuo codice è quindi
più facile da ragionare.

Ma la mutabilità può essere molto utile e può rendere il codice più comodo da scrivere.
Sebbene le variabili siano immutabili di default, puoi renderle mutabili aggiungendo `mut` di fronte al nome della variabile come hai fatto nel [Capitolo 2][storing-values-with-variables]<!-- ignore -->. Aggiungendo `mut` trasmetti anche
intento ai futuri lettori del codice indicando che altre parti del codice
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

Siamo autorizzati a cambiare il valore associato a `x` da `5` a `6` quando viene
usato `mut`. In definitiva, decidere se utilizzare la mutabilità o no dipende da te e
dipende da ciò che ritieni più chiaro in quella particolare situazione.

### Costanti

Come le variabili immutabili, le *costanti* sono valori che sono associati a un nome e
non sono autorizzati a cambiare, ma ci sono alcune differenze tra costanti
e variabili.

Prima di tutto, non è consentito usare `mut` con le costanti. Le costanti non sono solo
immutabili di default - sono sempre immutabili. Dichiarate le costanti utilizzando il
parola chiave `const` invece della parola chiave `let`, e il tipo del valore *deve*
essere annotato. Affronteremo i tipi e le annotazioni di tipo nella prossima sezione,
["Tipi di Dati"][data-types]<!-- ignore -->, quindi non preoccuparti dei dettagli
per adesso. Sappi solo che devi sempre annotare il tipo.

Le costanti possono essere dichiarate in qualsiasi ambito, incluso l'ambito globale, il che le rende
utili per i valori che molte parti del codice devono conoscere.

L'ultima differenza è che le costanti possono essere impostate solo su un'espressione costante,
non il risultato di un valore che potrebbe essere calcolato solo a runtime.

Ecco un esempio di dichiarazione di una costante:

```rust
const THREE_HOURS_IN_SECONDS: u32 = 60 * 60 * 3;
```

Il nome della costante è `THREE_HOURS_IN_SECONDS` e il suo valore è impostato al
risultato della moltiplicazione di 60 (il numero di secondi in un minuto) per 60 (il numero
di minuti in un'ora) per 3 (il numero di ore che vogliamo contare in questo
programma). La convenzione di denominazione di Rust per le costanti è utilizzare tutti i caratteri maiuscoli con
gli underscore tra le parole. Il compilatore è in grado di valutare un set limitato di
operazioni a tempo di compilazione, il che ci consente di scegliere di scrivere questo valore in un
modo che sia più facile da capire e verificare, piuttosto che impostare questa costante
al valore 10.800. Vedi la sezione sulla valutazione costante nel [Riferimento Rust][const-eval] per ulteriori informazioni sulle operazioni che possono essere utilizzate
quando si dichiarano costanti.

Le costanti sono valide per tutto il tempo in cui un programma viene eseguito, all'interno dell'ambito in
cui sono state dichiarate. Questa proprietà rende le costanti utili per i valori nel
il tuo dominio dell'applicazione di cui potrebbero aver bisogno molte parti del programma, come il numero massimo di punti che qualsiasi giocatore di un gioco è autorizzato a
guadagnare, o la velocità della luce.

Nominare i valori predefiniti utilizzati in tutto il tuo programma come costanti è utile in
trasmettendo il significato di quel valore ai futuri manutentori del codice. È anche
utile avere un solo posto nel tuo codice che dovrai cambiare se il
il valore predefinito doveva essere aggiornato in futuro.

### Shadowing

Come hai visto nel tutorial del gioco di indovinare nel [Capitolo
2][comparing-the-guess-to-the-secret-number]<!-- ignore -->, puoi dichiarare un
nuova variabile con lo stesso nome di una variabile precedente. I Rustaceans dicono che la
la prima variabile viene *oscurata* dalla seconda, il che significa che la seconda
variabile è quella che il compilatore vedrà quando usi il nome della variabile.
In effetti, la seconda variabile oscura la prima, prendendo qualsiasi utilizzo del nome della variabile per se stessa fino a quando non viene oscurato a sua volta o finisce l'ambito.
Possiamo oscurare una variabile usando lo stesso nome della variabile e ripetendo l'
uso della parola chiave `let` come segue:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-03-shadowing/src/main.rs}}
```

Questo programma lega prima `x` a un valore di `5`. Poi crea una nuova variabile
`x` ripetendo `let x =`, prendendo il valore originale e aggiungendo `1` così il
valore di `x` è poi `6`. Poi, all'interno di un ambito interno creato con le parentesi graffe,
la terza dichiarazione `let` oscura anche `x` e crea una nuova
variabile, moltiplicando il valore precedente per `2` per dare a `x` un valore di `12`.
Quando quel ambito è finito, l'oscuramento interno termina e `x` torna ad essere `6`.
Quando eseguiamo questo programma, produrrà il seguente output:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-03-shadowing/output.txt}}
```

L'ombratura è diversa dal segnare una variabile come `mut` perché otterremmo un
errore a tempo di compilazione se accidentalmente proviamo a riassegnare a questa variabile senza
utilizzare la parola chiave `let`. Usando `let`, possiamo eseguire alcune trasformazioni
su un valore ma avere la variabile come immutabile dopo che tali trasformazioni sono state completate.

L'altra differenza tra `mut` e l'ombratura è che dal momento che stiamo
effettivamente creando una nuova variabile quando usiamo di nuovo la parola chiave `let`, possiamo
cambiare il tipo del valore ma riutilizzare lo stesso nome. Ad esempio, diciamo che il nostro
programma chiede a un utente di mostrare quanti spazi vogliono tra del testo
inserendo caratteri spaziali, e poi vogliamo memorizzare quel input come un numero:

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-04-shadowing-can-change-types/src/main.rs:here}}
```

La prima variabile `spaces` è un tipo stringa e la seconda variabile `spaces`
è un tipo numero. L'ombratura ci risparmia quindi dall'avere a che fare con
nomi diversi, come `spaces_str` e `spaces_num`; invece, possiamo riutilizzare
il più semplice nome `spaces`. Tuttavia, se proviamo ad usare `mut` per questo, come mostrato
qui, otterremo un errore a tempo di compilazione:

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-05-mut-cant-change-types/src/main.rs:here}}
```

L'errore dice che non ci è permesso mutare il tipo di una variabile:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-05-mut-cant-change-types/output.txt}}
```

Ora che abbiamo esplorato come funzionano le variabili, diamo un'occhiata ad altri tipi di dati che
possono avere.

[comparing-the-guess-to-the-secret-number]:
ch02-00-guessing-game-tutorial.html#comparing-the-guess-to-the-secret-number
[data-types]: ch03-02-data-types.html#data-types
[storing-values-with-variables]: ch02-00-guessing-game-tutorial.html#storing-values-with-variables
[const-eval]: ../reference/const_eval.html

