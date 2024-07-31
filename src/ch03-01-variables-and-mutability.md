## Variabili e Mutabilità

Come menzionato nella sezione [“Storing Values with
Variables”][storing-values-with-variables]<!-- ignore -->, per impostazione predefinita,
le variabili sono immutabili. Questo è uno dei tanti suggerimenti che Rust ti offre per scrivere
il tuo codice in un modo che sfrutta la sicurezza e la facile concorrenza che
Rust offre. Tuttavia, hai comunque l'opzione di rendere le tue variabili mutabili.
Esploriamo come e perché Rust ti incoraggia a favorire l'immutabilità e perché
a volte potresti voler rinunciare a questa caratteristica.

Quando una variabile è immutabile, una volta che un valore è assegnato a un nome, non puoi cambiare
quel valore. Per illustrarlo, genera un nuovo progetto chiamato *variables* nella tua directory *projects* usando `cargo new variables`.

Poi, nella tua nuova directory *variables*, apri *src/main.rs* e sostituisci il suo
codice con il seguente codice, che non compilerà ancora:

<span class="filename">Filename: src/main.rs</span>

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
ancora non sta facendo in modo sicuro ciò che vuoi che faccia; non significano *affatto* che tu non sia
un bravo programmatore! Anche i Rustaceans esperti ricevono errori dal compilatore.

Hai ricevuto il messaggio di errore `` cannot assign twice to immutable variable `x`
`` perché hai cercato di assegnare un secondo valore alla variabile `x` immutabile.

È importante che riceviamo errori di compilazione quando tentiamo di cambiare un
valore designato come immutabile perché questa stessa situazione può portare
a bug. Se una parte del nostro codice opera sull'assunto che un valore non cambierà mai e un'altra parte del nostro codice cambia quel valore, è possibile
che la prima parte del codice non faccia ciò per cui è stata progettata. La causa
di questo tipo di bug può essere difficile da rintracciare retroattivamente, specialmente
quando la seconda parte di codice cambia il valore solo *a volte*. Il compilatore di Rust
garantisce che quando dichiari che un valore non cambierà, non cambierà davvero, così
non devi tenerne traccia da solo. Il tuo codice è quindi più facile da ragionare.

Ma la mutabilità può essere molto utile e può rendere il codice più conveniente da scrivere.
Anche se le variabili sono immutabili per impostazione predefinita, puoi renderle mutabili aggiungendo `mut` davanti al nome della variabile come hai fatto nel [Capitolo
2][storing-values-with-variables]<!-- ignore -->. Aggiungere `mut` trasmette anche
intenzione ai futuri lettori del codice, indicando che altre parti del codice
cambieranno il valore di questa variabile.

Per esempio, cambiamo *src/main.rs* come segue:

<span class="filename">Filename: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-02-adding-mut/src/main.rs}}
```

Quando eseguiamo il programma ora, otteniamo questo:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-02-adding-mut/output.txt}}
```

Ci è permesso cambiare il valore assegnato a `x` da `5` a `6` quando `mut` è
usato. In definitiva, decidere se usare la mutabilità o meno spetta a te e
dipende da ciò che ritieni sia più chiaro in quella particolare situazione.

### Costanti

Come le variabili immutabili, le *costanti* sono valori che sono assegnati a un nome e
non possono essere cambiati, ma ci sono alcune differenze tra costanti e variabili.

Prima di tutto, non è permesso usare `mut` con le costanti. Le costanti non sono solo
immutabili per impostazione predefinita—sono sempre immutabili. Dichiari le costanti usando la
parola chiave `const` invece della parola chiave `let`, e il tipo del valore *deve*
essere annotato. Tratteremo tipi e annotazioni dei tipi nella prossima sezione,
[“Data Types”][data-types]<!-- ignore -->, quindi non preoccuparti dei dettagli
adesso. Sappi solo che devi sempre annotare il tipo.

Le costanti possono essere dichiarate in qualsiasi ambito, incluso l'ambito globale, il che le rende utili per valori che molte parti del codice devono conoscere.

L'ultima differenza è che le costanti possono essere impostate solo su un'espressione costante,
non sul risultato di un valore che potrebbe essere computato solo a runtime.

Ecco un esempio di dichiarazione di una costante:

```rust
const THREE_HOURS_IN_SECONDS: u32 = 60 * 60 * 3;
```

Il nome della costante è `THREE_HOURS_IN_SECONDS` e il suo valore è impostato sul
risultato della moltiplicazione di 60 (il numero di secondi in un minuto) per 60 (il numero
di minuti in un'ora) per 3 (il numero di ore che vogliamo contare in questo
programma). La convenzione di denominazione di Rust per le costanti è usare tutte le lettere maiuscole con
trattini bassi tra le parole. Il compilatore è in grado di valutare un set limitato di
operazioni a tempo di compilazione, il che ci consente di scegliere di scrivere questo valore in un modo che sia più facile da capire e verificare, piuttosto che impostare questa costante
al valore 10,800. Consulta la [sezione del Riferimento Rust sull'evaluazione delle costanti][const-eval] per ulteriori informazioni sulle operazioni che
possono essere utilizzate quando si dichiarano le costanti.

Le costanti sono valide per tutto il tempo in cui un programma è in esecuzione, all'interno dell'ambito in cui sono state dichiarate. Questa proprietà rende le costanti utili per valori nel tuo dominio
applicativo di cui più parti del programma potrebbero aver bisogno, come il numero massimo di punti che qualsiasi giocatore di un gioco è autorizzato a guadagnare, o la velocità della luce.

Denominare i valori hardcoded usati in tutto il tuo programma come costanti è utile per
trasmettere il significato di quel valore ai futuri manutentori del codice. Inoltre,
aiuta ad avere un solo posto nel tuo codice che avresti bisogno di cambiare se il
valore hardcoded dovesse essere aggiornato in futuro.

### Shadowing

Come hai visto nel tutorial del gioco di indovinare nel [Capitolo
2][comparing-the-guess-to-the-secret-number]<!-- ignore -->, puoi dichiarare una
nuova variabile con lo stesso nome di una variabile precedente. I Rustaceans dicono che la
prima variabile è *shadowed* dalla seconda, il che significa che la seconda
variabile è ciò che il compilatore vedrà quando usi il nome della variabile.
In effetti, la seconda variabile offusca la prima, andando a sostituire ogni uso del
nome della variabile finché non viene essa stessa offuscata o l'ambito termina.
Possiamo eseguire un’operazione di shadowing su una variabile usando lo stesso nome della variabile e ripetendo l'uso della parola chiave `let` come segue:

<span class="filename">Filename: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-03-shadowing/src/main.rs}}
```

Questo programma prima assegna `x` ad un valore di `5`. Poi crea una nuova variabile
`x` ripetendo `let x =`, prendendo il valore originale e aggiungendo `1` quindi
il valore di `x` diventa `6`. Poi, all'interno di un ambito interno creato con
le parentesi graffe, la terza dichiarazione `let` sovrasta anche `x` e crea una nuova
variabile, moltiplicando il valore precedente per `2` per assegnare a `x` un valore di
`12`. Quando quell'ambito finisce, il shadowing interno termina e `x` torna ad essere `6`.
Quando eseguiamo questo programma, produrrà il seguente output:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-03-shadowing/output.txt}}
```

Lo shadowing è diverso dal marcare una variabile come `mut` perché otterremo un
errore a tempo di compilazione se accidentalmente tentiamo di riassegnare a questa variabile senza
usare la parola chiave `let`. Usando `let`, possiamo effettuare alcune trasformazioni
su un valore ma far sì che la variabile sia immutabile dopo che tali trasformazioni
sono state completate.

L'altra differenza tra `mut` e shadowing è che, visto che stiamo
effettivamente creando una nuova variabile quando utilizziamo nuovamente la parola chiave `let`, possiamo
cambiare il tipo del valore ma riutilizzare lo stesso nome. Per esempio, supponiamo
che il nostro programma chieda a un utente di mostrare quante spaziature desidera tra un po' di testo
immettendo spazi, e poi vogliamo memorizzare quell'input come un numero:

```rust
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-04-shadowing-can-change-types/src/main.rs:here}}
```

La prima variabile `spaces` è di tipo stringa e la seconda variabile `spaces` è di tipo
numerico. Lo shadowing ci risparmia quindi dal dover inventare
nomi diversi, come `spaces_str` e `spaces_num`; invece, possiamo riutilizzare
il più semplice nome `spaces`. Tuttavia, se proviamo a usare `mut` per questo, come mostrato
qui, otterremo un errore a tempo di compilazione:

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch03-common-programming-concepts/no-listing-05-mut-cant-change-types/src/main.rs:here}}
```

L'errore dice che non ci è permesso di mutare il tipo di una variabile:

```console
{{#include ../listings/ch03-common-programming-concepts/no-listing-05-mut-cant-change-types/output.txt}}
```

Ora che abbiamo esplorato come funzionano le variabili, diamo un'occhiata a più tipi di dati che possono
avere.

[comparing-the-guess-to-the-secret-number]:
ch02-00-guessing-game-tutorial.html#comparing-the-guess-to-the-secret-number
[data-types]: ch03-02-data-types.html#data-types
[storing-values-with-variables]: ch02-00-guessing-game-tutorial.html#storing-values-with-variables
[const-eval]: ../reference/const_eval.html
