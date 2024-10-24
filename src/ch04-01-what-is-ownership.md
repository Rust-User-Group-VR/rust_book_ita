## Che cos'è l'Ownership?

*L'Ownership* è un insieme di regole che governano come un programma Rust gestisce la memoria.
Tutti i programmi devono gestire il modo in cui usano la memoria del computer mentre sono in esecuzione.
Alcuni linguaggi hanno il garbage collection che cerca regolarmente la memoria non più utilizzata mentre il programma è in esecuzione; in altri linguaggi, il programmatore deve allocare ed eliminare esplicitamente la memoria. Rust utilizza un terzo approccio: la memoria è gestita attraverso un sistema di ownership con un insieme di regole che il compilatore verifica. Se una di queste regole viene violata, il programma non verrà compilato. Nessuna delle caratteristiche dell'ownership rallenterà il tuo programma mentre è in esecuzione.

Poiché l'ownership è un concetto nuovo per molti programmatori, ci vuole un po' di tempo per abituarsi. La buona notizia è che più diventi esperto con Rust e le regole del sistema di ownership, più facile sarà sviluppare naturalmente codice sicuro ed efficiente. Continua così!

Quando comprenderai l'ownership, avrai una solida base per comprendere le caratteristiche che rendono Rust unico. In questo capitolo, imparerai l'ownership lavorando su alcuni esempi che si concentrano su una struttura di dati molto comune: le stringhe.

> ### Lo Stack e l'Heap
>
> Molti linguaggi di programmazione non richiedono di pensare spesso allo stack e all'heap. Ma in un linguaggio di programmazione di sistemi come Rust, se un valore è nello stack o nell'heap, influenza il modo in cui il linguaggio si comporta e perché devi prendere certe decisioni. Parti di ownership verranno descritte in relazione allo stack e all'heap più avanti in questo capitolo, quindi ecco una breve spiegazione di preparazione.
>
> Sia lo stack che l'heap sono parti di memoria a disposizione del tuo codice durante l'esecuzione, ma sono strutturati in modi diversi. Lo stack memorizza i valori nell'ordine in cui li riceve e rimuove i valori nell'ordine opposto. Questo è detto *ultimo ad entrare, primo ad uscire*. Pensa a una pila di piatti: quando aggiungi più piatti, li metti in cima alla pila, e quando hai bisogno di un piatto, lo prendi dal sopra. Aggiungere o rimuovere piatti dal centro o dal fondo non funzionerebbe altrettanto bene! Aggiungere dati è chiamato *push nello stack*, e rimuovere dati è chiamato *pop dallo stack*. Tutti i dati memorizzati nello stack devono avere una dimensione nota e fissa. I dati con una dimensione sconosciuta al momento della compilazione o una dimensione che potrebbe cambiare devono essere memorizzati nell'heap.
>
> L'heap è meno organizzato: quando metti dati nell'heap, richiedi una certa quantità di spazio. L'allocatore di memoria trova un posto vuoto nell'heap abbastanza grande, lo segna come in uso e restituisce un *puntatore*, che è l'indirizzo di quella posizione. Questo processo è chiamato *allocazione nell'heap* ed è a volte abbreviato in *allocazione* (inserire valori nello stack non è considerato allocazione). Poiché il puntatore all'heap è di dimensione fissa e nota, puoi memorizzare il puntatore nello stack, ma quando vuoi i dati effettivi, devi seguire il puntatore. Pensa a quando sei seduto in un ristorante. Quando entri, dichiari il numero di persone nel tuo gruppo, e l'host trova un tavolo vuoto che si adatta a tutti e ti accompagna lì. Se qualcuno nel tuo gruppo arriva tardi, può chiedere dove sei stato seduto per trovarti.
>
> Inserire dati nello stack è più veloce che allocare nell'heap perché l'allocatore non deve mai cercare un posto dove memorizzare nuovi dati; quella posizione è sempre in cima allo stack. Comparativamente, allocare spazio nell'heap richiede più lavoro perché l'allocatore deve prima trovare uno spazio abbastanza grande per contenere i dati e poi eseguire la registrazione per prepararsi alla prossima allocazione.
>
> Accedere ai dati nell'heap è più lento che accedere ai dati nello stack perché devi seguire un puntatore per arrivarci. I processori contemporanei sono più veloci se saltano meno nella memoria. Continuando con l'analogia, considera un cameriere in un ristorante che prende ordini da molti tavoli. È più efficiente prendere tutti gli ordini a un tavolo prima di passare al prossimo. Prendere un ordine dal tavolo A, poi un ordine dal tavolo B, poi di nuovo uno da A, e poi di nuovo uno da B sarebbe un processo molto più lento. Allo stesso modo, un processore può svolgere meglio il suo lavoro se lavora su dati vicini ad altri dati (come nello stack) piuttosto che più lontani (come possono essere nell'heap).
>
> Quando il tuo codice chiama una funzione, i valori passati alla funzione (incluse, potenzialmente, i puntatori ai dati nell'heap) e le variabili locali della funzione vengono inseriti nello stack. Quando la funzione è finita, quei valori vengono rimossi dallo stack.
>
> Tenere traccia di quali parti del codice stanno usando quali dati nell'heap, minimizzare la quantità di dati duplicati nell'heap, e ripulire i dati non utilizzati nell'heap in modo da non esaurire lo spazio sono tutti problemi che l'ownership affronta. Una volta compreso l'ownership, non dovrai pensare spesso allo stack e all'heap, ma sapere che lo scopo principale dell'ownership è gestire i dati nell'heap può aiutare a spiegare perché funziona nel modo in cui funziona.

### Regole dell'Ownership

Innanzitutto, diamo un'occhiata alle regole dell'ownership. Tieni a mente queste regole mentre lavoriamo sugli esempi che le illustrano:

* Ogni valore in Rust ha un *proprietario*.
* Ci può essere solo un proprietario alla volta.
* Quando il proprietario esce dallo Scope, il valore verrà eliminato.

### Variable Scope

Ora che abbiamo superato la sintassi base di Rust, non includeremo tutto il codice `fn main() {` negli esempi, quindi se stai seguendo, assicurati di inserire i seguenti esempi all'interno di una funzione `main` manualmente. Di conseguenza, i nostri esempi saranno un po' più concisi, permettendoci di concentrarci sui dettagli effettivi piuttosto che sul codice di contorno.

Come primo esempio di ownership, guarderemo lo *scope* di alcune variabili. Uno scope è l'intervallo all'interno di un programma in cui un elemento è valido. Prendi la seguente variabile:

```rust
let s = "hello";
```

La variabile `s` si riferisce a un literal di stringa, dove il valore della stringa è codificato nel testo del nostro programma. La variabile è valida dal punto in cui viene dichiarata fino alla fine dello *scope* corrente. Il Listato 4-1 mostra un programma con commenti che annotano dove sarebbe valida la variabile `s`.

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/listing-04-01/src/main.rs:here}}
```

<span class="caption">Listato 4-1: Una variabile e lo scope in cui è valida</span>

In altre parole, ci sono due punti temporali importanti qui:

* Quando `s` entra nello *scope*, è valida.
* Rimane valida fino a quando esce dallo *scope*.

A questo punto, la relazione tra gli scope e quando le variabili sono valide è simile a quella di altri linguaggi di programmazione. Ora costruiremo su questa comprensione introducendo il tipo `String`.

### Il Tipo `String`

Per illustrare le regole dell'ownership, abbiamo bisogno di un tipo di dato che sia più complesso di quelli trattati nella sezione [“Data Types”][data-types]<!-- ignore --> del Capitolo 3. I tipi trattati in precedenza hanno una dimensione nota, possono essere memorizzati nello stack e rimossi dallo stack quando lo scope è terminato, e possono essere copiati rapidamente e facilmente per creare una nuova istanza indipendente se un'altra parte del codice deve utilizzare lo stesso valore in uno scope diverso. Ma vogliamo esaminare i dati che vengono memorizzati nell'heap ed esplorare come Rust sa quando pulire quei dati, e il tipo `String` è un ottimo esempio.

Ci concentreremo sulle parti di `String` che riguardano l'ownership. Questi aspetti si applicano anche ad altri tipi di dati complessi, sia che siano forniti dalla libreria standard sia che siano creati da te. Parleremo di `String` in maggiore dettaglio nel [Capitolo 8][ch8]<!-- ignore -->.

Abbiamo già visto i literal di stringa, dove il valore di una stringa è incorporato nel nostro programma. I literal di stringa sono convenienti, ma non sono adatti per ogni situazione in cui potremmo voler usare del testo. Un motivo è che sono immutabili. Un altro è che non tutti i valori di stringa possono essere noti quando scriviamo il nostro codice: per esempio, cosa succede se vogliamo prendere l'input dell'utente e memorizzarlo? Per queste situazioni, Rust ha un secondo tipo di stringa, `String`. Questo tipo gestisce i dati allocati nell'heap ed è in grado di memorizzare una quantità di testo che non è nota a noi in fase di compilazione. Puoi creare una `String` a partire da un literal di stringa usando la funzione `from`, in questo modo:

```rust
let s = String::from("hello");
```

L'operatore doppio due punti `::` ci permette di riservare questa particolare funzione `from` al tipo `String` piuttosto che utilizzare qualche nome come `string_from`. Discuteremo di più su questa sintassi nella sezione [“Method Syntax”][method-syntax]<!-- ignore --> nel Capitolo 5 e quando parleremo di spazi dei nomi con i moduli in [“Paths for Referring to an Item in the Module Tree”][paths-module-tree]<!-- ignore --> nel Capitolo 7.

Questo tipo di stringa *può* essere mutato:

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-01-can-mutate-string/src/main.rs:here}}
```

Quindi, qual è la differenza qui? Perché `String` può essere mutata ma i literal no? La differenza sta in come questi due tipi trattano la memoria.

### Memoria e Allocazione

Nel caso di un literal di stringa, conosciamo il contenuto in fase di compilazione, quindi il testo è incorporato direttamente nell'eseguibile finale. Questo è il motivo per cui i literal di stringa sono veloci ed efficienti. Ma queste proprietà derivano solo dall'immutabilità del literal di stringa. Purtroppo, non possiamo mettere un blocco di memoria nel binario per ogni pezzo di testo la cui dimensione è sconosciuta in fase di compilazione e la cui dimensione potrebbe cambiare mentre il programma è in esecuzione.

Con il tipo `String`, per supportare un pezzo di testo mutabile ed espandibile, abbiamo bisogno di allocare una quantità di memoria nell'heap, sconosciuta al tempo di compilazione, per contenere il contenuto. Questo significa:

* La memoria deve essere richiesta dall'allocatore di memoria al momento dell'esecuzione.
* Abbiamo bisogno di un modo per restituire questa memoria all'allocatore quando abbiamo finito con la nostra `String`.

La prima parte è fatta da noi: quando chiamiamo `String::from`, la sua implementazione richiede la memoria di cui ha bisogno. Questo è abbastanza universale nei linguaggi di programmazione.

Tuttavia, la seconda parte è diversa. Nei linguaggi con un *garbage collector (GC)*, il GC tiene traccia e pulisce la memoria che non è più utilizzata, e non dobbiamo pensarci. Nella maggior parte dei linguaggi senza un GC, è nostra responsabilità identificare quando la memoria non è più utilizzata e chiamare il codice per liberarla esplicitamente, proprio come abbiamo fatto per richiederla. Farlo correttamente è stato storicamente un problema di programmazione difficile. Se ci dimentichiamo, sprecheremo memoria. Se lo facciamo troppo presto, avremo una variabile non valida. Se lo facciamo due volte, è un bug anche quello. Dobbiamo accoppiare esattamente un `allocate` con esattamente un `free`.

Rust prende una strada diversa: la memoria viene automaticamente restituita una volta che la variabile che la possiede esce dallo scope. Ecco una versione del nostro esempio di scope dal Listato 4-1 che utilizza una `String` invece di un literal di stringa:

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-02-string-scope/src/main.rs:here}}
```

C'è un punto naturale in cui possiamo restituire la memoria di cui la nostra `String` ha bisogno all'allocatore: quando `s` esce dallo scope. Quando una variabile esce dallo scope, Rust chiama una funzione speciale per noi. Questa funzione è chiamata [`drop`][drop]<!-- ignore -->, ed è dove l'autore di `String` può inserire il codice per restituire la memoria. Rust chiama `drop` automaticamente alla chiusura della parentesi graffa.

> Nota: In C++, questo modello di deallocazione delle risorse alla fine della vita di un elemento è a volte chiamato *Resource Acquisition Is Initialization (RAII)*. La funzione `drop` in Rust sarà familiare a te se hai utilizzato modelli RAII.

Questo modello ha un impatto profondo sul modo in cui il codice Rust è scritto. Potrebbe sembrare semplice al momento, ma il comportamento del codice può essere inaspettato in situazioni più complicate quando vogliamo che più variabili utilizzino i dati che abbiamo allocato nell'heap. Esploriamo ora alcune di queste situazioni.

<!-- Old heading. Do not remove or links may break. -->
<a id="ways-variables-and-data-interact-move"></a>

#### Variabili e Dati Interagenti con Move

Più variabili possono interagire con gli stessi dati in modi diversi in Rust.
Vediamo un esempio usando un intero nel Listato 4-2.

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/listing-04-02/src/main.rs:here}}
```

<span class="caption">Listato 4-2: Assegnazione del valore intero della variabile `x` a `y`</span>

Probabilmente possiamo indovinare cosa sta facendo: “collega il valore `5` a `x`; poi fai una copia del valore in `x` e collegalo a `y`.” Ora abbiamo due variabili, `x` e `y`, e entrambe sono uguali a `5`. Questo è effettivamente ciò che sta accadendo, perché gli interi sono valori semplici con una dimensione nota e fissa, e questi due valori `5` sono inseriti nello stack.

Ora guardiamo la versione con `String`:

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-03-string-move/src/main.rs:here}}
```

Questo sembra molto simile, quindi potremmo supporre che il modo in cui funziona sia lo stesso: cioè, la seconda riga farebbe una copia del valore in `s1` e lo colleghi a `s2`. Ma questo non è esattamente ciò che accade.

Dai un'occhiata alla Figura 4-1 per vedere cosa sta accadendo a `String` sotto il cofano. Una `String` è composta da tre parti, mostrato a sinistra: un puntatore alla memoria che contiene il contenuto della stringa, una lunghezza e una capacità. Questo gruppo di dati è memorizzato nello stack. Alla destra c'è la memoria sull'heap che contiene il contenuto.

<img alt="Due tabelle: la prima tabella contiene la rappresentazione di s1 sullo stack, composta dalla sua lunghezza (5), capacità (5) e un puntatore al primo valore nella seconda tabella. La seconda tabella contiene la rappresentazione dei dati della stringa nell'heap, byte per byte." src="img/trpl04-01.svg" class="center" style="width: 50%;" />

<span class="caption">Figura 4-1: Rappresentazione in memoria di una `String` contenente il valore `"hello"` associato a `s1`</span>

La lunghezza è quanto memoria, in byte, il contenuto della `String` sta attualmente utilizzando. La capacità è la quantità totale di memoria, in byte, che la `String` ha ricevuto dall'allocatore. La differenza tra lunghezza e capacità importa, ma non in questo contesto, quindi per ora, va bene ignorare la capacità.

Quando assegnamo `s1` a `s2`, i dati `String` vengono copiati, il che significa che copiamo il puntatore, la lunghezza e la capacità che sono nello stack. Non copiamo i dati nell'heap ai quali il puntatore si riferisce. In altre parole, la rappresentazione in memoria appare come la Figura 4-2.

<img alt="Tre tabelle: le tabelle s1 e s2 che rappresentano tali stringhe nello stack, rispettivamente, e entrambe puntano ai dati della stringa nello stesso heap." src="img/trpl04-02.svg" class="center" style="width: 50%;" />

<span class="caption">Figura 4-2: Rappresentazione in memoria della variabile `s2` che ha una copia del puntatore, lunghezza e capacità di `s1`</span>

La rappresentazione non appare come la Figura 4-3, che è come apparirebbe la memoria se Rust copiasse anche i dati dell'heap. Se Rust facesse questo, l'operazione `s2 = s1` potrebbe essere molto costosa in termini di prestazioni se i dati nell'heap fossero grandi.

<img alt="Quattro tabelle: due tabelle che rappresentano i dati dello stack per s1 e s2, e ciascuna punta a una propria copia dei dati della stringa nell'heap." src="img/trpl04-03.svg" class="center" style="width: 50%;" />

<span class="caption">Figura 4-3: Un'altra possibilità per ciò che potrebbe fare `s2 = s1` se Rust copiasse anche i dati dell'heap</span>
In precedenza abbiamo detto che quando una variabile esce dallo Scope, Rust chiama automaticamente la funzione `drop` e ripulisce la memoria heap per quella variabile. Ma la figura 4-2 mostra entrambi i puntatori di dati che puntano alla stessa posizione. Questo è un problema: quando `s2` e `s1` escono dallo Scope, entrambi tenteranno di liberare la stessa memoria. Questo è noto come errore di *double free* ed è uno dei bug di sicurezza della memoria che abbiamo menzionato in precedenza. Liberare la memoria due volte può portare a corruzione della memoria, che può potenzialmente causare vulnerabilità di sicurezza.

Per garantire la sicurezza della memoria, dopo la riga `let s2 = s1;`, Rust considera `s1` come non più valido. Pertanto, Rust non ha bisogno di liberare nulla quando `s1` esce dallo Scope. Guarda cosa succede quando si tenta di utilizzare `s1` dopo che `s2` è stato creato; non funzionerà:

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-04-cant-use-after-move/src/main.rs:here}}
```

Si otterrà un errore come questo perché Rust impedisce di usare il riferimento invalidato:

```console
{{#include ../listings/ch04-understanding-ownership/no-listing-04-cant-use-after-move/output.txt}}
```

Se hai sentito i termini *shallow copy* e *deep copy* mentre lavoravi con altri linguaggi, il concetto di copiare il puntatore, la lunghezza e la capacità senza copiare i dati probabilmente suona come un shallow copy. Ma poiché Rust invalida anche la prima variabile, invece di essere chiamata una shallow copy, è conosciuta come un *move*. In questo esempio, diremmo che `s1` è stato *spostato* in `s2`. Quindi, ciò che accade effettivamente è mostrato nella figura 4-4.

<img alt="Tre tabelle: tabelle s1 e s2 che rappresentano quelle stringhe nello stack, rispettivamente, e entrambe puntano agli stessi dati della stringa sull'heap. La tabella s1 è grigiata perché s1 non è più valida; solo s2 può essere usato per accedere ai dati dell'heap." src="img/trpl04-04.svg" class="center" style="width: 50%;" />

<span class="caption">Figura 4-4: Rappresentazione in memoria dopo che `s1` è stato invalidato</span>

Questo risolve il nostro problema! Con solo `s2` valido, quando esce dallo Scope libererà da solo la memoria, e abbiamo finito.

Inoltre, è presente una scelta progettuale implicita da ciò: Rust non creerà mai automaticamente copie “deep” dei tuoi dati. Pertanto, qualsiasi copia *automatica* può essere considerata poco costosa in termini di prestazioni a runtime.

<!-- Vecchia intestazione. Non rimuovere o i link potrebbero rompersi. -->
<a id="ways-variables-and-data-interact-clone"></a>

#### Variabili e dati che interagiscono con Clone

Se vogliamo *davvero* copiare in modo profondo i dati sull'heap della `String`, non solo i dati dello stack, possiamo utilizzare un metodo comune chiamato `clone`. Discuteremo la sintassi dei metodi nel Capitolo 5, ma poiché i metodi sono una caratteristica comune in molti linguaggi di programmazione, probabilmente li hai già visti.

Ecco un esempio del metodo `clone` in azione:

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-05-clone/src/main.rs:here}}
```

Questo funziona bene e produce esplicitamente il comportamento mostrato nella figura 4-3, dove i dati dell'heap *vengono* copiati.

Quando vedi una chiamata a `clone`, sai che viene eseguito del codice arbitrario e quel codice potrebbe essere costoso. È un indicatore visivo che sta accadendo qualcosa di diverso.

#### Dati solo nello stack: Copy

C'è un'altra sfumatura di cui non abbiamo ancora parlato. Questo codice che utilizza interi, parte del quale è stato mostrato nel Listing 4-2, funziona ed è valido:

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-06-copy/src/main.rs:here}}
```

Ma questo codice sembra contraddire ciò che abbiamo appena appreso: non abbiamo una chiamata a `clone`, ma `x` è ancora valido e non è stato spostato in `y`.

Il motivo è che tipi come interi che hanno una dimensione nota a tempo di compilazione sono memorizzati interamente nello stack, quindi le copie dei valori effettivi sono rapide da effettuare. Ciò significa che non c'è motivo per cui vorremmo impedire che `x` sia valido dopo aver creato la variabile `y`. In altre parole, non c'è differenza tra copia profonda e superficiale qui, quindi chiamare `clone` non farebbe nulla di diverso dalla solita copia superficiale, e possiamo ometterlo.

Rust ha un'annotazione speciale chiamata `Copy` trait che possiamo posizionare sui tipi che sono memorizzati nello stack, come gli interi (parleremo di trait nel [Capitolo 10][traits]<!-- ignore -->). Se un tipo implementa il `Copy` trait, le variabili che lo utilizzano non si spostano, ma vengono copiate in modo triviale, rendendole ancora valide dopo l'assegnazione a un'altra variabile.

Rust non ci permetterà di annotare un tipo con `Copy` se il tipo, o una delle sue parti, ha implementato il `Drop` trait. Se il tipo ha bisogno di qualcosa di speciale quando il valore esce dallo Scope e aggiungiamo l'annotazione `Copy` a quel tipo, otterremo un errore a tempo di compilazione. Per sapere come aggiungere l'annotazione `Copy` al tuo tipo per implementare il trait, vedi [“Derivable Traits”][derivable-traits]<!-- ignore --> in Appendice C.

Quindi, quali tipi implementano il `Copy` trait? Puoi controllare la documentazione per il tipo dato per esserne sicuro, ma come regola generale, qualsiasi gruppo di valori scalari semplici può implementare `Copy`, e nulla che richiede allocazione o è una qualche forma di risorsa può implementare `Copy`. Ecco alcuni dei tipi che implementano `Copy`:

* Tutti i tipi interi, come `u32`.
* Il tipo Booleano, `bool`, con valori `true` e `false`.
* Tutti i tipi a virgola mobile, come `f64`.
* Il tipo carattere, `char`.
* Tuple, se contengono solo tipi che implementano anche `Copy`. Ad esempio, `(i32, i32)` implementa `Copy`, ma `(i32, String)` no.

### Ownership e Funzioni

Le meccaniche di passaggio di un valore a una funzione sono simili a quelle quando si assegna un valore a una variabile. Passare una variabile a una funzione farà eseguire un move o una copia, proprio come l'assegnazione. Il Listing 4-3 ha un esempio con alcune annotazioni che mostrano dove le variabili entrano ed escono dallo Scope.

<span class="filename">Filename: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/listing-04-03/src/main.rs}}
```

<span class="caption">Listing 4-3: Funzioni con ownership e scope annotati</span>

Se provassimo a usare `s` dopo la chiamata a `takes_ownership`, Rust genererebbe un errore a tempo di compilazione. Questi controlli statici ci proteggono dagli errori. Prova ad aggiungere codice a `main` che utilizzi `s` e `x` per vedere dove puoi usarli e dove le regole dell'ownership ti impediscono di farlo.

### Valori di Ritorno e Scope

Restituire valori può anche trasferire l'ownership. Il Listing 4-4 mostra un esempio di una funzione che restituisce un valore, con annotazioni simili a quelle nel Listing 4-3.

<span class="filename">Filename: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/listing-04-04/src/main.rs}}
```

<span class="caption">Listing 4-4: Trasferimento dell'ownership dei valori di ritorno</span>

L'ownership di una variabile segue lo stesso schema ogni volta: assegnare un valore a un'altra variabile lo sposta. Quando una variabile che include dati sull'heap esce dallo Scope, il valore verrà ripulito da `drop` a meno che l'ownership dei dati non sia stata trasferita a un'altra variabile.

Anche se questo funziona, prendere ownership e poi restituire ownership con ogni funzione è un po' noioso. Cosa succede se vogliamo permettere a una funzione di usare un valore ma non prendere ownership? È piuttosto fastidioso che qualsiasi cosa passiamo debba essere anche restituita se vogliamo usarla di nuovo, oltre a qualsiasi dato risultante dal blocco che potremmo voler restituire.

Rust ci permette di restituire valori multipli usando una tupla, come mostrato nel Listing 4-5.

<span class="filename">Filename: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/listing-04-05/src/main.rs}}
```

<span class="caption">Listing 4-5: Restituzione dell'ownership dei parametri</span>

Ma questo è troppa cerimonia e troppo lavoro per un concetto che dovrebbe essere comune. Fortunatamente per noi, Rust ha una caratteristica per utilizzare un valore senza trasferire ownership, chiamata *references*.

[data-types]: ch03-02-data-types.html#data-types
[ch8]: ch08-02-strings.html
[traits]: ch10-02-traits.html
[derivable-traits]: appendix-03-derivable-traits.html
[method-syntax]: ch05-03-method-syntax.html#method-syntax
[paths-module-tree]: ch07-03-paths-for-referring-to-an-item-in-the-module-tree.html
[drop]: ../std/ops/trait.Drop.html#tymethod.drop
