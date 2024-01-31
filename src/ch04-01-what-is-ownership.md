## Cos'è l'Ownership?

*L'Ownership* è un insieme di regole che governano come un programma Rust gestisce la memoria.
Tutti i programmi devono gestire il modo in cui utilizzano la memoria del computer durante l'esecuzione.
Alcuni linguaggi hanno il garbage collection che cerca regolarmente la memoria non più utilizzata
mentre il programma si esegue; in altri linguaggi, il programmatore deve esplicitamente
allocare e liberare la memoria. Rust utilizza un terzo approccio: la memoria è gestita
attraverso un sistema di ownership con un insieme di regole che il compilatore controlla. Se
vengono violate una qualsiasi delle regole, il programma non si compilerà. Nessuna delle caratteristiche
dell' ownership rallenterà il tuo programma durante l'esecuzione.

Poiché l'ownership è un nuovo concetto per molti programmatori, ci vuole un po' di tempo
per abituarsi. La buona notizia è che più diventi esperto con Rust
e le regole del sistema di ownership, troverai più facile sviluppare naturalmente
codice che è sicuro ed efficiente. Continua a farlo!

Quando capisci l'ownership, avrai una solida base per capire
le caratteristiche che rendono Rust unico. In questo capitolo, imparerai l'ownership lavorando
attraverso alcuni esempi che si concentrano su una struttura dati molto comune:
le stringhe.

> ### Lo Stack e l'Heap
>
> Molti linguaggi di programmazione non richiedono che tu pensi molto allo stack e all'heap.
> Ma in un linguaggio di programmazione di sistema come Rust, se un
> valore è nello stack o nell'heap influisce su come il linguaggio si comporta e su perché
> devi prendere certe decisioni. Parti dell'ownership saranno descritte in
> relazione allo stack e all'heap più avanti in questo capitolo, quindi ecco una breve
> spiegazione in preparazione.
>
> Sia lo stack che l'heap sono parti di memoria disponibili per il tuo codice da usare
> al runtime, ma sono strutturati in modi diversi. Lo stack memorizza
> i valori nell'ordine in cui li riceve e rimuove i valori nell'ordine opposto.
> Questo è chiamato *last in, first out*. Pensa a una pila di
> piatti: quando aggiungi più piatti, li metti in cima alla pila, e quando
> hai bisogno di un piatto, lo togli dalla cima. Aggiungere o rimuovere piatti da
> al centro o in fondo non sarebbe altrettanto efficace! Aggiungere dati viene chiamato *pushing
> onto the stack*, e rimuovere dati viene chiamato *popping off the stack*. Tutti
> i dati memorizzati nello stack devono avere una dimensione conosciuta e fissa. I dati con una dimensione sconosciuta
> al momento della compilazione o una dimensione che potrebbe cambiare devono essere memorizzati nell'heap
> invece.
>
> L'heap è meno organizzato: quando metti dati sull'heap, richiedi un
> certa quantità di spazio. L'allocatore di memoria trova uno spot vuoto nell'heap
> che è abbastanza grande, lo segna come in uso, e restituisce un *puntatore*, che
> è l'indirizzo di quella posizione. Questo processo è chiamato *allocating on the
> heap* e a volte è abbreviato come semplice *allocating* (pushare valori nello stack non è considerato come allocating). Poiché il puntatore all'heap è un
> dimensione conosciuta, fissa, puoi memorizzare il puntatore nello stack, ma quando vuoi
> i dati effettivi, devi seguire il puntatore. Pensa di essere seduto a un
> ristorante. Quando entri, dichiari il numero di persone nel tuo gruppo, e
> l'host trova un tavolo vuoto che può ospitare tutti e ti conduce lì. Se
> qualcuno nel tuo gruppo arriva in ritardo, può chiedere dove sei stato seduto
> per trovarti.
>
> Fare push nello stack è più veloce che allocare sull'heap perché il
> allocatore non deve mai cercare un posto dove memorizzare nuovi dati; quella posizione è
> sempre in cima allo stack. Paragonatamente, allocare uno spazio sull'heap
> richiede più lavoro perché l'allocatore deve prima trovare uno spazio abbastanza grande
> per contenere i dati e poi fare del bookkeeping per prepararsi per la prossima
> allocazione.
>
> L'accesso ai dati nell'heap è più lento dell'accesso ai dati nello stack perché
> devi seguire un puntatore per arrivarci. I processori contemporanei sono più veloci
> se saltano meno nella memoria. Continuando l'analogia, considera un cameriere
> al ristorante che prende gli ordini da molti tavoli. È più efficiente
> prendere tutti gli ordini da un tavolo prima di passare al tavolo successivo.
> Prendere un ordine dal tavolo A, poi un ordine dal tavolo B, poi uno da A di nuovo, e
> poi uno da B di nuovo sarebbe un processo molto più lento. Seguendo lo stesso ragionamento, un
> processore può fare meglio il suo lavoro se lavora su dati che sono vicini ad altri
> dati (come sono nello stack) piuttosto che più lontani (come possono essere sull'heap).
>
> Quando il tuo codice chiama una funzione, i valori passati nella funzione
> (inclusi, potenzialmente, puntatori a dati sull'heap) e le variabili locali della funzione vengono pushate nello stack. Quando la funzione è finita, quei
> valori vengono poppati fuori dallo stack.
>
> Tenere traccia di quali parti di codice usano quali dati sull'heap,
> minimizzando la quantità di dati duplicati sull'heap, e pulendo i dati non utilizzati
> sull'heap in modo da non rimanere senza spazio sono tutte problematiche che l'ownership
> risolve. Una volta che capisci l'ownership, non avrai bisogno di pensare allo stack e all'heap molto spesso, ma sapere che lo scopo principale dell'ownership è gestire i dati dell'heap può aiutare a spiegare perché funziona nel modo in cui lo fa.

### Regole dell'Ownership

Prima, diamo un'occhiata alle regole dell'ownership. Tieni a mente queste regole mentre lavoriamo attraverso gli esempi che le illustrano:

* Ogni valore in Rust ha un *proprietario*.
* Ci può essere solo un proprietario alla volta.
* Quando il proprietario esce dallo scope, il valore verrà rilasciato.

### Ambito delle Variabili 

Ora che abbiamo superato la sintassi di base di Rust, non includeremo più tutto il codice `fn main() {`
negli esempi, quindi se stai seguendo insieme, assicurati di inserire i seguenti
esempi all'interno di una funzione `main` manualmente. Di conseguenza, i nostri esempi saranno un po'
più concisi, permettendoci di concentrarci sui dettagli reali piuttosto che
sul codice boilerplate.

Come primo esempio di ownership, guarderemo l'*ambito* di alcune variabili. Un
ambito è l'intervallo all'interno di un programma per il quale un elemento è valido. Prendi la
seguente variabile:

```rust
let s = "ciao";
```

La variabile `s` si riferisce a un literal di stringa, dove il valore della stringa è
codificato nel testo del nostro programma. La variabile è valida dal punto in cui è dichiarata fino alla fine dell'attuale *ambito*. Listing 4-1 mostra un
programma con commenti che annotano dove la variabile `s` sarebbe valida.

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/listing-04-01/src/main.rs:here}}
```

<span class="caption">Listing 4-1: Una variabile e l'ambito in cui è
valida</span>

In altre parole, ci sono due momenti importanti qui:

* Quando `s` entra *in* ambito, è valida.
* Rimane valida fino a quando non esce *dallo* ambito.

A questo punto, la relazione tra gli ambiti e quando le variabili sono valide è
simile a quella di altri linguaggi di programmazione. Ora costruiremo su questa
comprensione introducendo il tipo `String`.

### Il tipo `String`

Per illustrare le regole dell'ownership, abbiamo bisogno di un tipo di dati che sia più complesso
di quelli che abbiamo coperto nella sezione [“Tipi di dati”][data-types]<!-- ignore --> del Capitolo 3. I tipi coperti in precedenza hanno una dimensione conosciuta, possono essere memorizzati
nello stack e rimossi dallo stack quando il loro ambito è finito, e possono essere
rapidamente e banalmente copiati per creare una nuova istanza indipendente se un'altra
parte del codice ha bisogno di usare lo stesso valore in un ambito diverso. Ma vogliamo
guardare ai dati che sono memorizzati nell'heap e esplorare come Rust sa quando pulire
quei dati, e il tipo `String` è un ottimo esempio.

Ci concentreremo sulle parti di `String` che riguardano l'ownership. Questi
aspetti si applicano anche ad altri tipi di dati complessi, che siano forniti dalla
libreria standard o creati da te. Discuteremo `String` più approfonditamente in
[Capitolo 8][ch8]<!-- ignore -->.

Abbiamo già visto i literals di stringa, dove un valore di stringa è hardcoded nel nostro
programma. I literals di stringa sono comodi, ma non sono adatti per ogni
situazione in cui potremmo voler usare del testo. Un motivo è che sono
immutabili. Un altro è che non ogni valore di stringa può essere conosciuto quando scriviamo
il nostro codice: per esempio, cosa succede se vogliamo prendere l'input dell'utente e memorizzarlo? Per
queste situazioni, Rust ha un secondo tipo di stringa, `String`. Questo tipo gestisce
dati allocati sull'heap e come tale è in grado di memorizzare una quantità di testo che
non ci è nota al momento della compilazione. Puoi creare una `String` da un literal di stringa utilizzando la funzione `from`, così:


```rust
let s = String::from("ciao");
```

L'operatore doppio due punti `::` ci permette di mettere in un namespace questa particolare funzione `from`
sotto il tipo `String` piuttosto che utilizzare qualche tipo di nome come
`string_from`. Discuteremo di più su questa sintassi nel [“Metodo
Sintassi”][method-syntax]<!-- ignore --> sezione del Capitolo 5, e quando parleremo
di namespacing con i moduli in [“Percorsi per Riferirsi a un Elemento in the
Module Tree”][paths-module-tree]<!-- ignore --> nel Capitolo 7.

Questo tipo di stringa *può* essere mutato:

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-01-can-mutate-string/src/main.rs:here}}
```

Allora, qual è la differenza qui? Perché `String` può essere mutata mentre i letterali
non possono? La differenza è nel modo in cui questi due tipi gestiscono la memoria.

### Memoria e Allocazione

Nel caso di un letterale di stringa, ne conosciamo il contenuto al momento della compilazione, quindi il
testo è codificato direttamente nell'eseguibile finale. Ecco perché i letterali di stringa
sono veloci ed efficienti. Ma queste proprietà derivano solo dall'immutabilità del letterale di stringa.
Sfortunatamente, non possiamo inserire un blob di memoria nel binario per ogni pezzo
di testo la cui dimensione non è nota al momento della compilazione e la cui
dimensione potrebbe cambiare durante l'esecuzione del programma.

Con il tipo `String`, al fine di supportare un pezzo di testo mutabile e crescibile,
abbiamo bisogno di allocare una quantità di memoria sul heap, sconosciuta al momento della compilazione,
per contenere il contenuto. Questo significa:

* La memoria deve essere richiesta all'allocatore di memoria a runtime.
* Abbiamo bisogno di un modo per restituire questa memoria all'allocatore quando abbiamo finito con
  la nostra `String`.

La prima parte è fatta da noi: quando chiamiamo `String::from`, la sua implementazione
richiede la memoria di cui ha bisogno. Questo è praticamente universale nei linguaggi di programmazione.

Tuttavia, la seconda parte è diversa. Nei linguaggi con un *garbage collector
(GC)*, il GC tiene traccia di e pulisce la memoria che non viene utilizzata
più, e non dobbiamo pensarci. Nella maggior parte dei linguaggi senza un GC,
è nostra responsabilità identificare quando la memoria non viene più utilizzata e chiamare
codice per liberarla esplicitamente, proprio come abbiamo fatto per richiederla. Fare questo
correttamente è storicamente un problema di programmazione difficile. Se dimentichiamo,
sprecheremo memoria. Se lo facciamo troppo presto, avremo una variabile non valida. Se
lo facciamo due volte, anche quello è un bug. Abbiamo bisogno di abbinare esattamente un `allocate` con
esattamente un `free`.

Rust prende una strada diversa: la memoria viene restituita automaticamente una volta che
la variabile che la possiede esce dallo scope. Ecco una versione del nostro esempio di scope
dal Listato 4-1 utilizzando una `String` invece di un letterale di stringa:

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-02-string-scope/src/main.rs:here}}
```

C'è un punto naturale in cui possiamo restituire la memoria di cui la nostra `String` ha bisogno
all'allocatore: quando `s` esce dallo scope. Quando una variabile esce dallo
scope, Rust chiama una funzione speciale per noi. Questa funzione si chiama
[`drop`][drop]<!-- ignore -->, ed è dove l'autore di `String` può mettere
il codice per restituire la memoria. Rust chiama `drop` automaticamente alla parentesi graffa di chiusura.

> Nota: In C++, questo pattern di deallocare risorse alla fine del ciclo di vita di un elemento è
> a volte chiamato *Resource Acquisition Is Initialization (RAII)*.
> La funzione `drop` in Rust ti sarà familiare se hai usato
> i pattern RAII.

Questo pattern ha un impatto profondo sul modo in cui viene scritto il codice Rust. Potrebbe sembrare
semplice adesso, ma il comportamento del codice può essere inaspettato in situazioni più
complicate quando vogliamo avere più variabili che utilizzano i dati
che abbiamo allocato sul heap. Esploriamo alcune di quelle situazioni adesso.

<!-- Old heading. Do not remove or links may break. -->
<a id="ways-variables-and-data-interact-move"></a>

#### Variabili e Dati che Interagiscono con il Trasferimento

Più variabili possono interagire con gli stessi dati in modi diversi in Rust.
Diamo un'occhiata ad un esempio utilizzando un intero nel Listato 4-2.

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/listing-04-02/src/main.rs:here}}
```

<span class="caption">Listato 4-2: Assegnazione del valore intero della variabile `x`
a `y`</span>

Possiamo probabilmente indovinare cosa sta facendo: "lega il valore `5` a `x`; poi fai
una copia del valore in `x` e legala a `y`." Ora abbiamo due variabili, `x`
e `y`, e entrambe valgono `5`. Questo è effettivamente ciò che sta succedendo, perché gli interi
sono valori semplici con una dimensione nota, fissa, e questi due valori `5` vengono spinti
nello stack.

Ora diamo un'occhiata alla versione `String`:

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-03-string-move/src/main.rs:here}}
```

Questo sembra molto simile, quindi potremmo pensare che il modo in cui funziona sarebbe lo
stesso: cioè, la seconda riga farebbe una copia del valore in `s1` e lo legherebbe a `s2`. Ma questo non è proprio quello che succede.

Dai un'occhiata alla Figura 4-1 per vedere cosa succede alla `String` under the
covers. Una `String` è composta da tre parti, mostrate a sinistra: un puntatore alla
memoria che contiene i contenuti della stringa, una lunghezza, e una capacità. 
Questo gruppo di dati è memorizzato nello stack. A destra c'è la memoria sul
heap che contiene i contenuti.

<img alt="Due tabelle: la prima tabella contiene la rappresentazione di s1 sullo
stack, composta dalla sua lunghezza (5), capacità (5), e un puntatore al primo
valore nella seconda tabella. La seconda tabella contiene la rappresentazione dei
dati della stringa sul heap, byte per byte." src="img/trpl04-01.svg" class="center"
style="width: 50%;" />

<span class="caption">Figura 4-1: Rappresentazione in memoria di una `String`
che contiene il valore `"ciao"` legato a `s1`</span>

La lunghezza è quanto memoria, in byte, i contenuti della `String` stanno
attualmente utilizzando. La capacità è la quantità totale di memoria, in byte, che la 
`String` ha ricevuto dall'allocatore. La differenza tra lunghezza e capacità è importante, 
ma non in questo contesto, quindi per ora, va bene ignorare la capacità.

Quando assegnamo `s1` a `s2`, i dati della `String` vengono copiati, il che significa che copiamo il puntatore,
la lunghezza, e la capacità che sono nello stack. Non copiamo i dati sul heap a cui il puntatore si riferisce.
In altre parole, la rappresentazione dei dati in memoria assomiglia alla Figura 4-2.

<img alt="Tre tabelle: le tabelle s1 e s2 che rappresentano quelle stringhe sullo
stack, rispettivamente, e entrambe puntano agli stessi dati stringa sul heap."
src="img/trpl04-02.svg" class="center" style="width: 50%;" />

<span class="caption">Figure 4-2: Rappresentazione in memoria della variabile `s2`
che ha una copia del puntatore, lunghezza e capacità di `s1`</span>

La rappresentazione *non* assomiglia alla Figura 4-3, che è come sarebbe la memoria
se Rust copiasse anche i dati del heap. Se Rust facesse questo, l'operazione `s2 = s1` potrebbe essere molto costosa in termini
di prestazioni a runtime se i dati sul heap fossero grandi.

<img alt="Four tables: due tabelle rappresentano i dati dello stack per s1 e s2,
e ognuna punta alla sua propria copia di dati stringa sul heap."
src="img/trpl04-03.svg" class="center" style="width: 50%;" />

<span class="caption">Figura 4-3: Un'altra possibilità per quello che `s2 = s1` potrebbe
fare se Rust copiasse i dati del heap anche</span>

Prima abbiamo detto che quando una variabile esce dallo scope, Rust chiama automaticamente
la funzione `drop` e pulisce la memoria del heap per quella variabile. Ma
la Figura 4-2 mostra entrambi i puntatori dati che puntano allo stesso luogo. Questo è un
problema: quando `s2` e `s1` escono dallo scope, entrambi cercheranno di liberare lo
stessa memoria. Questo è noto come un errore di *doppia liberazione* ed è uno dei bug di sicurezza
della memoria di cui abbiamo parlato in precedenza. Liberare la memoria due volte può portare a corruzione
della memoria, che può potenzialmente portare a vulnerabilità di sicurezza.
Per garantire la sicurezza della memoria, dopo la riga `let s2 = s1;`, Rust considera `s1` come
non più valido. Pertanto, Rust non ha bisogno di liberare nulla quando `s1` esce
dallo scope. Controlla cosa succede quando provi a usare `s1` dopo che `s2` è
stato creato; non funzionerà:

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-04-cant-use-after-move/src/main.rs:here}}
```

Riceverai un errore come questo perché Rust ti impedisce di usare un
riferimento invalidato:

```console
{{#include ../listings/ch04-understanding-ownership/no-listing-04-cant-use-after-move/output.txt}}
```

Se hai sentito i termini *copia superficiale* e *copia profonda* mentre lavoravi con
altri linguaggi, il concetto di copiare il puntatore, la lunghezza e la capacità
senza copiare i dati probabilmente suona come fare una copia superficiale. Ma
perché Rust invalida anche la prima variabile, invece di essere chiamata a
copia superficiale, è conosciuto come *spostamento*. In questo esempio, diremmo che `s1`
è stato *spostato* in `s2`. Pertanto, quello che realmente succede è mostrato nella Figura 4-4.

<img alt="Tre tabelle: tabelle s1 e s2 che rappresentano quelle stringhe sul
stack, rispettivamente, e entrambe puntano agli stessi dati stringa nell'heap.
La tabella s1 è in grigio perché s1 non è più valido; solo s2 può essere utilizzato per
accedere ai dati nell'heap." src="img/trpl04-04.svg" class="center" style="width:
50%;" />

<span class="caption">Figura 4-4: Rappresentazione in memoria dopo che `s1` è stato
invalidato</span>

Questo risolve il nostro problema! Con solo `s2` valido, quando esce dallo scope
sarà lui da solo a liberare la memoria, e abbiamo finito.

Inoltre, c'è una scelta di design che è implicita in questo: Rust non creerà mai
automaticamente "copie profonde" dei tuoi dati. Pertanto, qualsiasi *copia*
automatizzata può essere considerata poco costosa in termini di prestazioni di runtime.

<!-- Old heading. Do not remove or links may break. -->
<a id="ways-variables-and-data-interact-clone"></a>

#### Variabili e Dati che Interagiscono con Clone

Se *vogliamo* copiare profondamente i dati nell'heap della `String`, non solo i
dati nello stack, possiamo usare un metodo comune chiamato `clone`. Discuteremo della sintassi del metodo nel Capitolo 5, ma poiché i metodi sono una caratteristica comune in molti
linguaggi di programmazione, probabilmente li hai già visti prima.

Ecco un esempio del metodo `clone` in azione:

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-05-clone/src/main.rs:here}}
```

Questo funziona bene e produce esplicitamente il comportamento mostrato nella Figura 4-3,
dove i dati nell'heap *vengono* copiati.

Quando vedi una chiamata a `clone`, sai che viene eseguito del codice arbitrario e che quel codice potrebbe essere costoso. È un indicatore visivo che qualcosa diverso sta accadendo.

#### Dati Solo-Stack: Copy

C'è un'altra sfumatura di cui non abbiamo ancora parlato. Questo codice usando
interi—parte del quale è stato mostrato nella Lista 4-2—funziona ed è valido:

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-06-copy/src/main.rs:here}}
```

Ma questo codice sembra contraddire ciò che abbiamo appena imparato: non abbiamo una chiamata a
`clone`, ma `x` è ancora valido e non è stato spostato in `y`.

Il motivo è che i tipi come gli interi che hanno una dimensione conosciuta a tempo di compilazione
vengono archiviati interamente sullo stack, quindi le copie dei valori effettivi sono velocissime
da fare. Questo significa che non c'è ragione perché vorremmo impedire a `x` di essere
valido dopo aver creato la variabile `y`. In altre parole, non c'è differenza
tra copia profonda e superficiale qui, quindi chiamare `clone` non farebbe nulla
diverso dalla solita copia superficiale, e possiamo ometterlo.

Rust ha un'annotazione speciale chiamata trait `Copy` che possiamo posizionare su
tipi che sono archiviati sullo stack, come lo sono gli interi (ne parleremo di più sui
traits nel [Capitolo 10][traits]<!-- ignore -->). Se un tipo implementa il trait `Copy`,
le variabili che lo usano non si spostano, ma vengono copiate in modo banale,
rimanendo quindi valide dopo l'assegnazione a un'altra variabile.

Rust non ci permetterà di annotare un tipo con `Copy` se il tipo, o una qualsiasi delle sue parti,
ha implementato il trait `Drop`. Se il tipo ha bisogno che succeda qualcosa di speciale quando il valore esce dallo scope e aggiungiamo l'annotazione `Copy` a quel tipo,
otterremo un errore a tempo di compilazione. Per scoprire come aggiungere l'annotazione `Copy` al tuo tipo per implementare il trait, vedi [“Tratti Derivabili”][derivable-traits]<!-- ignore --> in Appendice C.

Quindi, quali tipi implementano il trait `Copy`? Puoi controllare la documentazione per
il tipo dato per essere sicuro, ma come regola generale, qualsiasi gruppo di semplici valori scalari
può implementare `Copy`, e nulla che richiede l'allocazione o è una sorta di risorsa può implementare `Copy`. Ecco alcuni dei tipi che
implementano `Copy`:

* Tutti i tipi di intero, come `u32`.
* Il tipo Booleano, `bool`, con i valori `true` e `false`.
* Tutti i tipi di punto flottante, come `f64`.
* Il tipo carattere, `char`.
* Le tuple, se contengono solo tipi che implementano anche `Copy`. Ad esempio,
  `(i32, i32)` implementa `Copy`, ma `(i32, String)` no.

### Ownership e Funzioni

I meccanismi per passare un valore a una funzione sono simili a quelli quando
si assegna un valore a una variabile. Passare una variabile a una funzione comporterà uno spostamento o una copia, proprio come fa l'assegnazione. La Lista 4-3 ha un esempio con alcune annotazioni
che mostrano dove le variabili entrano e escono dallo scope.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/listing-04-03/src/main.rs}}
```

<span class="caption">Lista 4-3: Funzioni con ownership e scope
annotati</span>

Se provassimo a usare `s` dopo la chiamata a `takes_ownership`, Rust lancerebbe un
errore a tempo di compilazione. Questi controlli statici ci proteggono dagli errori. Prova ad aggiungere
un codice a `main` che usa `s` e `x` per vedere dove puoi usarli e dove le regole dell'ownership ti impediscono di farlo.

### Valori di ritorno e Scope

Anche i valori restituiti possono trasferire l'ownership. La Lista 4-4 mostra un esempio di una
funzione che restituisce un valore, con annotazioni simili a quelle nella Lista
4-3.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/listing-04-04/src/main.rs}}
```

<span class="caption">Lista 4-4: Trasferimento dell'ownership dei valori di ritorno</span>

L'ownership di una variabile segue lo stesso schema ogni volta: assegnare un
valore a un'altra variabile lo sposta. Quando una variabile che include dati nell'heap esce dallo scope, il valore verrà ripulito da `drop` a meno che l'ownership dei dati non sia stata spostata in un'altra variabile.

Anche se questo funziona, prendere l'ownership e poi restituire l'ownership con ogni
funzione è un po' noioso. E se vogliamo permettere a una funzione di utilizzare un valore ma
non prendere l'ownership? È piuttosto fastidioso che qualsiasi cosa passiamo dentro debba anche essere passata indietro se vogliamo usarla di nuovo, oltre a eventuali dati risultanti
dal corpo della funzione che potremmo voler restituire allo stesso tempo.

Rust ci permette di restituire più valori usando una tupla, come mostrato nella Lista 4-5.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/listing-04-05/src/main.rs}}
```

<span class="caption">Lista 4-5: Restituzione dell'ownership dei parametri</span>

Ma questo è troppo cerimoniale e un sacco di lavoro per un concetto che dovrebbe essere
comune. Fortunatamente per noi, Rust ha una funzionalità per usare un valore senza
trasferire l'ownership, chiamata *riferimenti*.

[data-types]: ch03-02-data-types.html#data-types
[ch8]: ch08-02-strings.html
[traits]: ch10-02-traits.html
[derivable-traits]: appendix-03-derivable-traits.html
[method-syntax]: ch05-03-method-syntax.html#method-syntax
[paths-module-tree]: ch07-03-paths-for-referring-to-an-item-in-the-module-tree.html
[drop]: ../std/ops/trait.Drop.html#tymethod.drop

