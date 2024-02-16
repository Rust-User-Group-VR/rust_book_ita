## Cos'è l'Ownership?

*Ownership* è un insieme di regole che governano come un programma Rust gestisce la memoria.
Tutti i programmi devono gestire il modo in cui usano la memoria di un computer mentre eseguono.
Alcuni linguaggi hanno la garbage collection che cerca regolarmente la memoria non più utilizzata
mentre il programma è in esecuzione; in altri linguaggi, il programmatore deve esplicitamente
allocare e liberare la memoria. Rust utilizza un terzo approccio: la memoria è gestita
attraverso un sistema di ownership con un insieme di regole che vengono controllate dal compilatore. Se
quìalsiasi di queste regole viene violata, il programma non verrà compilato. Nessuna delle caratteristiche
dell'ownership rallenterà il tuo programma mentre è in esecuzione.

Poiché l'ownership è un concetto nuovo per molti programmatori, richiede un po' di tempo
per abituarsi. La buona notizia è che più diventi esperto con Rust
e le regole del sistema di ownership, più troverai naturale
sviluppare codice che è sicuro ed efficiente. Continua così!

Quando capisci l'ownership, avrai una solida base per capire
le caratteristiche che rendono unico Rust. In questo capitolo, imparerai l'ownership lavorando
attraverso alcuni esempi che si concentrano su una struttura dati molto comune:
le stringhe.

> ### Lo Stack e l'Heap
>
> Molti linguaggi di programmazione non richiedono di pensare molto allo stack e all'
> heap. Ma in un linguaggio di programmazione di sistema come Rust, se un
> valore è nello stack o nell'heap influisce sul modo in cui il linguaggio  si comporta e perché
> devi fare alcune decisioni. Parti dell'ownership verranno descritte in
> relazione allo stack e all'heap più avanti in questo capitolo, quindi ecco una breve
> spiegazione per preparazione.
>
> Sia lo stack che l'heap sono parti di memoria disponibili al tuo codice da usare
> in runtime, ma sono strutturati in modi diversi. Lo stack memorizza i
> valori nell'ordine in cui li riceve e rimuove i valori nell'ordine
> opposto. Questo viene chiamato *ultimo entrato, primo uscito*. Pensa ad un mucchio di
> piatti: quando ne aggiungi altri, li metti in cima alla pila, e quando
> hai bisogno di un piatto, ne prendi uno dalla cima. Aggiungere o rimuovere piatti dal
> mezzo o dal fondo non funzionerebbe altrettanto bene! Aggiungere dati viene chiamato *pushing
> nello stack*, e rimuovere i dati viene chiamato *popping dallo stack*. Tutti
> i dati memorizzati nello stack devono avere una dimensione conosciuta e fissa. I dati con una dimensione
> sconosciuta a tempo di compilazione o una dimensione che potrebbe cambiare devono essere memorizzati nell' heap
> invece.
>
> L'heap è meno organizzato: quando metti i dati nell'heap, richiedi un
> certa quantità di spazio. Il memory allocator trova uno spazio vuoto nell'heap
> che è abbastanza grande, lo segna come in uso, e restituisce un *puntatore*, che
> è l'indirizzo di quella posizione. Questo processo è chiamato *allocating on the
> heap* e a volte viene abbreviato come solo *allocating* (spingere i valori nello
> stack non è considerato allocare). Poiché il puntatore all'heap è un
> dimensione conosciuta e fissa, puoi memorizzare il puntatore nello stack, ma quando vuoi
> i dati effettivi, devi seguire il puntatore. Pensate di essere seduti in un
> ristorante. Quando entri, dichiari il numero di persone nel tuo gruppo, e
> l'host trova un tavolo vuoto che può ospitare tutti e ti ci conduce. Se
> qualcuno nel tuo gruppo arriva in ritardo, può chiedere dove sei stato seduto
> per trovarti.
>
> Spingere nello stack è più veloce dell'allocare nell'heap perché l'
> allocator non deve mai cercare un posto dove memorizzare i nuovi dati; quella posizione è
> sempre in cima allo stack. In confronto, allocare spazio nell'heap
> richiede più lavoro perché l'allocator deve prima trovare uno spazio abbastanza grande
> per contenere i dati e poi fare attività amministrative per prepararsi per il prossimo
> allocamento.
>
> Accedere ai dati nell'heap è più lento che accedere ai dati nello stack perché
> devi seguire un puntatore per arrivarci. I processori contemporanei sono più veloci
> se saltano meno nella memoria. Continuando l'analogia, considera un cameriere
> in un ristorante che prende ordini da molti tavoli. È più efficiente ottenere
> tutti gli ordini da un tavolo prima di passare al prossimo. Prendere un
> ordine da tavolo A, poi un ordine da tavolo B, poi uno da A di nuovo, e
> poi uno da B di nuovo sarebbe un processo molto più lento. Allo stesso modo, un
> processore può fare meglio il suo lavoro se lavora su dati che sono vicini ad altri
> dati (come lo sono nello stack) piuttosto che più lontani (come possono essere sull'
> heap).
>
> Quando il tuo codice chiama una funzione, i valori passati alla funzione
> (inclusi, potenzialmente, i puntatori ai dati nell'heap) e le variabili locali della funzione vengono spinte nello stack. Quando la funzione è finita, quei
> valori vengono rimossi dallo stack.
>
> Tenere traccia di quali parti del codice stanno utilizzando quali dati sull'heap,
> minimizzando la quantità di dati duplicati sull'heap, e pulendo i dati non utilizzati
> sull'heap in modo da non rimanere senza spazio sono tutti problemi che ownership
> affronta. Una volta che capisci l'ownership, non avrai bisogno di pensare allo
> stack e all'heap molto spesso, ma sapere che il principale scopo dell'ownership
> è gestire i dati dell'heap può aiutare a spiegare perché funziona nel modo in cui lo fa.

### Regole dell'Ownership

Prima, diamo un'occhiata alle regole dell'ownership. Tieni a mente queste regole mentre lavoriamo
attraverso gli esempi che le illustrano:

* Ogni valore in Rust ha un *proprietario*.
* Ci può essere solo un proprietario alla volta.
* Quando il proprietario esce dallo scope, il valore verrà eliminato.

### Scope della Variabile

Ora che abbiamo superato la sintassi base di Rust, non includeremo tutto il codice `fn main() {`
negli esempi, quindi se stai seguendo, assicurati di mettere i seguenti
esempi all'interno di una funzione `main` manualmente. Di conseguenza, i nostri esempi saranno un
po' più concisi, permettendoci di concentrarci sui dettagli effettivi piuttosto che
sul codice boilerplate.

Come primo esempio di ownership, esamineremo lo *scope* di alcune variabili. A
scope è l'intervallo all'interno di un programma per il quale un elemento è valido. Prendi il
seguente variabile:

```rust
let s = "hello";
```

La variabile `s` si riferisce a una stringa letterale, dove il valore della stringa è
inserito nel testo del nostro programma. La variabile è valida dal punto in cui è dichiarata fino alla fine del corrente *scope*. La Lista 4-1 mostra un
programma con commenti che annotano dove la variabile `s` sarebbe valida.

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/listing-04-01/src/main.rs:here}}
```

<span class="caption">Listing 4-1: Una variabile e lo scope in cui è
valida</span>

In altre parole, ci sono due momenti importanti qui:

* Quando `s` entra *in* scope, è valida.
* Rimane valida fino a quando esce *dal* scope.

A questo punto, la relazione tra scope e quando le variabili sono valide è
simile a quella che si ha in altri linguaggi di programmazione. Ora costruiremo su questa
comprensione introducendo il tipo `String`.

### Il Tipo `String`

Per illustrare le regole dell'ownership, abbiamo bisogno di un tipo di dato che sia più complesso
di quelli che abbiamo affrontato nella sezione [“Tipi di Dati”][data-types]<!-- ignore --> del Capitolo 3. I tipi trattati in precedenza sono di una dimensione conosciuta, possono essere memorizzati
nello stack e tolti dallo stack quando il loro scope è finito, e possono essere
rapidamente e banalmente copiati per creare una nuova istanza indipendente se un'altra
parte del codice ha bisogno di usare lo stesso valore in un diverso scope. Ma vogliamo
analizzare i dati che sono memorizzati nell'heap e esplorare come Rust sa quando
pulire quei dati, e il tipo `String` è un ottimo esempio.

Ci concentreremo sulle parti di `String` che riguardano l'ownership. Questi
aspetti si applicano anche ad altri tipi di dati complessi, sia che siano forniti da 
la libreria standard, sia che siano creati da te. Discuteremo `String` in modo più approfondito a 
[Capitolo 8][ch8]<!-- ignore -->.

Abbiamo già visto le stringhe letterali, dove un valore stringa è incorporato nel nostro
programma. Le stringhe letterali sono comode, ma non sono adatte per ogni
situazione in cui potremmo voler usare del testo. Un motivo è che sono
immutabili. Un altro è che non tutti i valori stringa possono essere noti quando scriviamo
il nostro codice: ad esempio, cosa succede se vogliamo prendere l'input dell'utente e memorizzarlo? Per
queste situazioni, Rust ha un secondo tipo di stringa, `String`. Questo tipo gestisce
dati allocati sul heap e come tale è in grado di memorizzare una quantità di testo che
è sconosciuto a noi al momento della compilazione. Puoi creare una `String` da una stringa
literale utilizzando la funzione `from`, in questo modo:

```rust
let s = String::from("ciao");
```

L'operatore doppio due punti `::` ci consente di impostare questo particolare `from`
funzione sotto il tipo `String` piuttosto che utilizzare una sorta di nome come
`stringa_da`. Discuteremo questa sintassi più avanti nella sezione ["Sintassi del
metodo"][method-syntax]<!-- ignore --> del Capitolo 5, e quando parleremo
di impostazione dei namespace con i moduli in ["Percorsi per fare riferimento a un elemento nella
Albero del modulo"][paths-module-tree]<!-- ignore --> nel Capitolo 7.

Questo tipo di stringa *può* essere modificato:

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-01-can-mutate-string/src/main.rs:here}}
```

Quindi, qual è la differenza qui? Perché `String` può essere modificato ma i letterali
no? La differenza sta nel modo in cui questi due tipi trattano la memoria.

### Memoria e allocazione

Nel caso di una stringa letterale, conosciamo i contenuti al momento della compilazione, quindi il
testo è inserito direttamente nell'eseguibile finale. Questo è il motivo per cui le stringhe
letterali sono veloci ed efficienti. Ma queste proprietà derivano solo dall'immobilità della stringa
letteral. Sfortunatamente, non possiamo inserire un blocco di memoria nel
binario per ciascun pezzo di testo la cui dimensione è sconosciuta al momento della compilazione e la cui
dimensione potrebbe cambiare durante l'esecuzione del programma.

Con il tipo `String`, per supportare un pezzo di testo mutabile e in grado di crescere,
abbiamo bisogno di allocare una quantità di memoria sul heap, sconosciuta al momento della compilazione,
per contenere i contenuti. Questo significa:

* La memoria deve essere richiesta all'allocatore di memoria al momento dell'esecuzione.
* Abbiamo bisogno di un modo per restituire questa memoria all'allocatore quando abbiamo finito con
  la nostra `String`.

La prima parte è fatta da noi: quando chiamiamo `String::from`, la sua implementazione
richiede la memoria di cui ha bisogno. Questo è praticamente universale nelle lingue di programmazione.

Tuttavia, la seconda parte è diversa. In lingue con un *garbage collector
(GC)*, il GC tiene traccia delle pulizie e della memoria che non viene più utilizzata
poi, e non dobbiamo pensarci. Nella maggior parte delle lingue senza un GC,
è nostra responsabilità identificare quando la memoria non viene più utilizzata e chiamare
codice per liberarlo esplicitamente, proprio come abbiamo fatto per richiederlo. Fare questo
correttamente è storicamente un problema di programmazione difficile. Se dimentichiamo,
sprecheremo memoria. Se lo facciamo troppo presto, avremo una variabile non valida. Se lo facciamo
due volte, è anche un bug. Dobbiamo abbinare esattamente un `allocazione` con
esattamente un `rilascio`.

Rust prende una strada diversa: la memoria viene restituita automaticamente una volta 
che la variabile che lo possiede esce dallo scope. Ecco una versione del nostro esempio di scope
dal Listing 4-1 che utilizza una `String` invece di un letterale stringa:

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-02-string-scope/src/main.rs:here}}
```

C'è un punto naturale in cui possiamo restituire la memoria richiesta dalla nostra `String`
all'allocatore: quando `s` esce dallo scope. Quando una variabile esce dallo scope, Rust chiama una funzione speciale per noi. Questa funzione si chiama
[`drop`][drop]<!-- ignore -->, ed è qui che l'autore di `String` può mettere
il codice per restituire la memoria. Rust chiama `drop` automaticamente alla parentesi graffa di chiusura.

> Nota: In C++, questo modello di desallocazione delle risorse alla fine della durata di un elemento è
> a volte chiamato *Resource Acquisition Is Initialization (RAII)*.
> La funzione `drop` in Rust ti sarà familiare se hai usato
> schemi RAII.

Questo modello ha un impatto profondo sul modo in cui viene scritto il codice Rust. Potrebbe sembrare
semplice adesso, ma il comportamento del codice può essere inaspettato in situazioni più
complesse quando vogliamo avere più variabili che utilizzano i dati
che abbiamo allocato sul heap. Esploriamo alcune di queste situazioni ora.

<!-- Vecchia intestazione. Non rimuovere o i collegamenti potrebbero interrompersi. -->
<a id="ways-variables-and-data-interact-move"></a>

#### Variabili e dati che interagiscono con Move

Più variabili possono interagire con gli stessi dati in modi diversi in Rust.
Diamo un'occhiata a un esempio utilizzando un intero nel Listing 4-2.

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/listing-04-02/src/main.rs:here}}
```

<span class="caption">Listing 4-2: Assegnamento del valore intero della variabile `x`
a `y`</span>

Probabilmente possiamo indovinare cosa sta facendo: "lega il valore `5` a `x`; poi fai
una copia del valore in `x` e legalo a `y`." Ora abbiamo due variabili, `x`
e `y`, e entrambe sono uguali a `5`. Questo è effettivamente ciò che sta succedendo, perché gli interi
sono valori semplici con una dimensione nota, fissa, e questi due valori `5` vengono messi
sullo stack.

Ora diamo un'occhiata alla versione `String`:

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-03-string-move/src/main.rs:here}}
```

Questo sembra molto simile, quindi potremmo supporre che il modo in cui funziona sarebbe lo stesso: cioè, la seconda linea farebbe una copia del valore in `s1` e lo lega a `s2`. Ma questo non è proprio quello che succede.

Dai un'occhiata alla Figura 4-1 per vedere cosa sta succedendo a `String` sotto le linee. Un `String` è composto da tre parti, mostrate a sinistra: un puntatore alla memoria che contiene i contenuti della stringa, una lunghezza e una capacità. Questo gruppo di dati è memorizzato nello stack. A destra c'è la memoria sul heap che contiene i contenuti.

<img alt="Due tabelle: la prima tabella contiene la rappresentazione di s1 sullo stack, costituita dalla sua lunghezza (5), capacità (5) e un puntatore al primo valore nella seconda tabella. La seconda tabella contiene la rappresentazione dei dati della stringa sul heap, byte per byte." src="img/trpl04-01.svg" class="center" style="width: 50%;" />

<span class="caption">Figura 4-1: Rappresentazione in memoria di una `String` che contiene il valore `"ciao"` legato a `s1`</span>

La lunghezza è quanta memoria, in byte, i contenuti di `String` stanno
attualmente utilizzando. La capacità è la quantità totale di memoria, in byte, che la 
`String` ha ricevuto dall'allocatore. La differenza tra lunghezza e
capacità è importante, ma non in questo contesto, quindi per ora è ok
ignora la capacità.

Quando assegniamo `s1` a `s2`, i dati di `String` vengono copiati, il che significa che copiamo il
puntatore, la lunghezza e la capacità che sono nello stack. Noi non copiamo il
dati sul heap a cui il puntatore si riferisce. In altre parole, la rappresentazione dei dati
in memoria assomiglia alla Figura 4-2.

<img alt="Tre tabelle: le tabelle s1 e s2 rappresentano rispettivamente queste stringhe nello
stack, ed entrambe puntano agli stessi dati della stringa nell'heap."
src="img/trpl04-02.svg" class="center" style="width: 50%;" />

<span class="caption">Figura 4-2: Rappresentazione in memoria della variabile `s2`
che ha una copia del puntatore, della lunghezza e della capacità di `s1`</span>

La rappresentazione *non* sembra la Figura 4-3, che è come sarebbe la memoria
se Rust copiasse anche i dati dell'heap. Se Rust facesse questo, l'operazione
`s2 = s1` potrebbe essere molto costosa in termini di performance a runtime se
i dati nell'heap fossero grandi.

<img alt="Quattro tabelle: due tabelle rappresentano i dati del stack per s1 e s2,
e ciascuna punta alla sua copia dei dati della stringa nell'heap."
src="img/trpl04-03.svg" class="center" style="width: 50%;" />

<span class="caption">Figura 4-3: Un'altra possibilità per ciò che `s2 = s1` potrebbe
fare se Rust copiasse anche i dati dell'heap</span>

Prima, abbiamo detto che quando una variabile esce dal suo scope, Rust chiama automaticamente
la funzione `drop` e pulisce la memoria dell'heap per quella variabile. Ma
la Figura 4-2 mostra entrambi i puntatori ai dati che puntano allo stesso luogo. Questo è un
problema: quando `s2` e `s1` escono dal loro scope, entrambi proveranno a liberare la
stessa memoria. Questo è noto come errore di *doppia liberazione* ed è uno dei bug di sicurezza della memoria
di cui abbiamo parlato in precedenza. Liberare la memoria due volte può portare a corruzione della memoria, 
che può potenzialmente portare a vulnerabilità di sicurezza.

Per garantire la sicurezza della memoria, dopo la linea `let s2 = s1;`, Rust considera `s1` come
non più valido. Pertanto, Rust non ha bisogno di liberare nulla quando `s1` esce dal suo scope. Guarda cosa succede quando provi ad usare `s1` dopo che `s2` è
stato creato; non funzionerà:

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-04-cant-use-after-move/src/main.rs:here}}
```

Otterrai un errore come questo perché Rust ti impedisce di usare tale
riferimento invalidato:

```console
{{#include ../listings/ch04-understanding-ownership/no-listing-04-cant-use-after-move/output.txt}}
```

Se hai sentito i termini *copia superficiale* e *copia profonda* mentre lavori con
altre lingue, il concetto di copia del puntatore, lunghezza e capacità
senza copiare i dati probabilmente suona come fare una copia superficiale. Ma
perché Rust invalida anche la prima variabile, invece di essere chiamata una
copia superficiale, è conosciuta come *move*. In questo esempio, diremmo che `s1`
è stata *spostata* in `s2`. Quindi, quello che succede realmente è mostrato nella Figura 4-4.

<img alt="Tre tabelle: le tabelle s1 e s2 rappresentano rispettivamente queste stringhe nello
stack, ed entrambe puntano agli stessi dati della stringa nell'heap.
La tabella s1 è sfumata perché s1 non è più valido; solo s2 può essere utilizzato per
accedere ai dati dell'heap." src="img/trpl04-04.svg" class="center" style="width:
50%;" />

<span class="caption">Figura 4-4: Rappresentazione in memoria dopo che `s1` è stato
invalidato</span>

Questo risolve il nostro problema! Con solo `s2` valido, quando esce dal suo scope 
sarà da solo a liberare la memoria, e abbiamo finito.

Inoltre, c'è una scelta di progettazione che è implicata da questo: Rust non creerà mai
automaticamente copie "profonde" dei tuoi dati. Pertanto, qualsiasi copia *automatica*
può essere assunta come economica in termini di prestazioni a runtime.

<!-- Vecchia intestazione. Non rimuovere o i link potrebbero rompersi. -->
<a id="ways-variables-and-data-interact-clone"></a>

#### Variabili e dati che interagiscono con Clone

Se vogliamo *veramente* copiare in profondità i dati dell'heap della `String`, non solo i
dati dello stack, possiamo utilizzare un metodo comune chiamato `clone`. Discuteremo della
sintassi del metodo nel Capitolo 5, ma poiché i metodi sono una caratteristica comune in molte
linguaggi di programmazione, probabilmente li hai già visti prima.

Ecco un esempio del metodo `clone` in azione:

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-05-clone/src/main.rs:here}}
```

Questo funziona benissimo e produce esplicitamente il comportamento mostrato nella Figura 4-3,
dove i dati dell'heap *vengono* copiati.

Quando vedi una chiamata a `clone`, sai che sta venendo eseguito un codice arbitrario e che quel codice potrebbe essere costoso. È un indicatore visivo che sta succedendo qualcosa di diverso.

#### Dati solo in Stack: Copy

C'è un altro dettaglio di cui non abbiamo ancora parlato. Questo codice utilizza gli
interi - parte del quale è stato mostrato nella Listing 4-2 - funziona ed è valido:

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-06-copy/src/main.rs:here}}
```

Ma questo codice sembra contraddire ciò che abbiamo appena appreso: non abbiamo una chiamata a
`clone`, ma `x` è ancora valido e non è stato spostato in `y`.

Il motivo è che tipi come gli interi che hanno una dimensione nota a tempo di compilazione
sono memorizzati interamente nello stack, quindi le copie dei valori effettivi sono veloci
da fare. Ciò significa che non c'è motivo che vorremmo impedire a `x` di essere
valido dopo aver creato la variabile `y`. In altre parole, non c'è differenza
tra copia profonda e copia superficiale qui, quindi chiamare `clone` non farebbe nulla
di diverso dalla solita copia superficiale, e possiamo ometterlo.

Rust ha una speciale annotazione chiamata `Copy` trait che possiamo posizionare sui
tipi che sono memorizzati nello stack, come gli interi lo sono (parleremo di più su
traits nel [Capitolo 10][traits]<!-- ignore -->). Se un tipo implementa il trait `Copy`,
le variabili che lo usano non vengono mosse, ma invece vengono facilmente copiate,
rendendole ancora valide dopo l'assegnazione ad un'altra variabile.

Rust non ci permetterà di annotare un tipo con `Copy` se il tipo, o qualunque delle sue parti,
ha implementato il trait `Drop`. Se il tipo ha bisogno che accada qualcosa di speciale
quando il valore esce dal suo scope e noi aggiungiamo l'annotazione `Copy` a quel tipo,
otterremo un errore a tempo di compilazione. Per saperne di più su come aggiungere l'annotazione `Copy`
al tuo tipo per implementare il trait, vedi [“Traits derivabili”][derivable-traits]<!-- ignore --> nell'Appendice C.

Quindi, quali tipi implementano il trait `Copy`? Puoi controllare la documentazione per
il dato tipo per esserne sicuro, ma come regola generale, qualsiasi gruppo di semplici valori scalari
può implementare `Copy`, e niente che richiede l'allocazione o è una
forma di risorsa può implementare `Copy`. Ecco alcuni dei tipi che
implementano `Copy`:

* Tutti i tipi di interi, come `u32`.
* Il tipo Booleano, `bool`, con i valori `true` e `false`.
* Tutti i tipi a virgola mobile, come `f64`.
* Il tipo carattere, `char`.
* Le tuple, se contengono solo tipi che implementano anche `Copy`. Per esempio,
  `(i32, i32)` implementa `Copy`, ma `(i32, String)` no.

### Ownership e Funzioni

La meccanica del passaggio di un valore a una funzione è simile a quella dell'assegnazione di un valore a una variabile. Passare una variabile a una funzione comporterà un move o una copia, proprio come fa l'assegnazione. La Listing 4-3 ha un esempio con alcune annotazioni che mostrano dove le variabili entrano ed escono dal loro scope.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/listing-04-03/src/main.rs}}
```
<span class="caption">Elencazione 4-3: Funzioni con proprietà e ambito
annotati</span>

Se provassimo a usare `s` dopo la chiamata a `takes_ownership`, Rust genererebbe un
errore di compilazione. Questi controlli statici ci proteggono dagli errori. Prova ad aggiungere
codice al `main` che utilizza `s` e `x` per vedere dove puoi usarli e dove
le regole di proprietà ti impediscono di farlo.

### Valori di ritorno e Ambito

Anche il ritorno di valori può trasferire la proprietà. L'elenco 4-4 mostra un esempio di una
funzione che restituisce un valore, con annotazioni simili a quelle nell'elenco 4-3.

<span class="filename">Nome file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/listing-04-04/src/main.rs}}
```

<span class="caption">Elencazione 4-4: Trasferimento della proprietà dei valori di ritorno</span>

La proprietà di una variabile segue lo stesso schema ogni volta: l'assegnazione di un
valore a un'altra variabile lo sposta. Quando una variabile che include dati sulla
heap esce dallo scope, il valore sarà pulito da `drop` a meno che la proprietà
dei dati non sia stata spostata su un'altra variabile.

Nonostante ciò funzioni, prendere la proprietà e poi restituirla con ogni
funzione è un po' noioso. E se volessimo far usare un valore a una funzione ma
non prendere la proprietà? È piuttosto fastidioso che tutto ciò che passiamo deve anche
essere restituito se vogliamo usarlo di nuovo, oltre a tutti i dati risultanti
dal corpo della funzione che potremmo voler restituire.

Rust ci consente di restituire valori multipli usando una tupla, come mostrato nell'Elencazione 4-5.

<span class="filename">Nome file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/listing-04-05/src/main.rs}}
```

<span class="caption">Elencazione 4-5: Restituzione della proprietà dei parametri</span>

Ma tutto ciò è troppo cerimoniale e richiede molto lavoro per un concetto che dovrebbe essere
comune. Fortunatamente per noi, Rust ha una funzionalità per utilizzare un valore senza
trasferire la proprietà, chiamata *riferimenti*.

[data-types]: ch03-02-data-types.html#data-types
[ch8]: ch08-02-strings.html
[traits]: ch10-02-traits.html
[derivable-traits]: appendix-03-derivable-traits.html
[method-syntax]: ch05-03-method-syntax.html#method-syntax
[paths-module-tree]: ch07-03-paths-for-referring-to-an-item-in-the-module-tree.html
[drop]: ../std/ops/trait.Drop.html#tymethod.drop

