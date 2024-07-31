## Cos'è la Ownership?

*Ownership* è un insieme di regole che governano come un programma Rust gestisce la memoria.
Tutti i programmi devono gestire il modo in cui utilizzano la memoria di un computer mentre sono in esecuzione.
Alcuni linguaggi hanno la raccolta automatica della memoria (garbage collection) che regolarmente cerca la memoria non più utilizzata
mentre il programma è in esecuzione; in altri linguaggi, il programmatore deve allocare e liberare esplicitamente la memoria. Rust usa un terzo approccio: la memoria viene gestita
attraverso un sistema di ownership con un insieme di regole che il compilatore verifica. Se
una qualsiasi delle regole viene violata, il programma non verrà compilato. Nessuna delle caratteristiche
dell'ownership rallenterà il tuo programma mentre è in esecuzione.

Poiché l'ownership è un concetto nuovo per molti programmatori, richiede un po' di tempo per abituarsi.
La buona notizia è che più acquisisci esperienza con Rust e le regole del sistema di ownership, più
facilmente svilupperai naturalmente del codice sicuro ed efficiente. Continua a provarci!

Quando capirai l'ownership, avrai una solida base per comprendere le caratteristiche che rendono Rust unico. In questo capitolo, imparerai l'ownership attraverso alcuni esempi che si concentrano su una struttura dati molto comune: le stringhe.

> ### Lo Stack e l'Heap
>
> Molti linguaggi di programmazione non richiedono di pensare spesso allo stack e all'heap. Ma in un linguaggio di programmazione di sistema come Rust, se un valore è nello stack o nell'heap influisce su come si comporta il linguaggio e perché
> devi prendere determinate decisioni. Parti dell'ownership verranno descritte in
> relazione allo stack e all'heap più avanti in questo capitolo, quindi ecco una breve
> spiegazione per prepararti.
>
> Sia lo stack che l'heap sono parti della memoria disponibili per il tuo codice da usare
> durante l'esecuzione, ma sono strutturati in modi diversi. Lo stack memorizza
> valori nell'ordine in cui li riceve e rimuove i valori nell'ordine opposto.
> Questo è chiamato *last in, first out*. Pensa a una pila di piatti: quando aggiungi più piatti, li metti in cima alla pila, e quando hai bisogno di un piatto, ne prendi uno dalla cima. Aggiungere o rimuovere piatti dal centro o dal fondo non funzionerebbe altrettanto bene! Aggiungere dati è chiamato *pushing onto the stack*, e rimuovere dati è chiamato *popping off the stack*. Tutti i dati memorizzati nello stack devono avere una dimensione nota e fissa. I dati con una dimensione sconosciuta durante la compilazione o con una dimensione che potrebbe cambiare devono essere memorizzati nell'heap.
>
> L'heap è meno organizzato: quando metti dati nell'heap, richiedi una
> certa quantità di spazio. Il memory allocator trova uno spazio vuoto nell'heap
> abbastanza grande, lo segna come in uso e restituisce un *puntatore*, che è l'indirizzo di quella posizione. Questo processo è chiamato *allocating on the heap* ed è
> talvolta abbreviato in *allocating* (pushare i valori nello stack non è considerato allocare). Poiché il puntatore all'heap è di una dimensione nota e fissa, puoi memorizzare il
> puntatore nello stack, ma quando vuoi i dati effettivi, devi seguire il puntatore. Pensa a essere seduto in un ristorante. Quando entri, dichiarala il numero di persone nel tuo gruppo, e l'host trova un tavolo vuoto che si adatti a tutti e ti ci accompagna. Se qualcuno del tuo gruppo arriva in ritardo, può chiedere dove siete stati seduti per trovarvi.
>
> Pushare nello stack è più veloce rispetto ad allocare nell'heap perché il
> allocatore non deve mai cercare un posto dove memorizzare i nuovi dati; quella posizione è sempre in cima allo stack. Comparativamente, allocare spazio nell'heap richiede più lavoro perché l'allocatore deve prima trovare uno spazio abbastanza grande da contenere i dati e poi eseguire operazioni di bookkeeping per prepararsi alla prossima allocazione.
>
> Accedere ai dati nell'heap è più lento rispetto ad accedere ai dati nello stack perché
> devi seguire un puntatore per arrivarci. I processori contemporanei sono più veloci
> se saltano meno in memoria. Continuando l'analogia, considera un cameriere
> in un ristorante che prende ordini da molti tavoli. È più efficiente raccogliere tutti gli ordini a un tavolo prima di passare al prossimo. Prendere un ordine dal tavolo A, quindi un ordine dal tavolo B, quindi un altro ordine da A e poi un altro da B sarebbe un processo molto più lento. Allo stesso modo, un processore può fare meglio il suo lavoro se lavora su dati che sono vicini ad altri dati (come nello stack) piuttosto che più lontani (come può essere nell'heap).
>
> Quando il tuo codice chiama una funzione, i valori passati nella funzione
> (compresi, potenzialmente, i puntatori ai dati nell'heap) e le variabili locali della funzione vengono pushate nello stack. Quando la funzione termina, quei valori vengono poppati dallo stack.
>
> Tenere traccia di quali parti del codice stanno utilizzando quali dati nell'heap,
> minimizzare la quantità di dati duplicati nell'heap, e pulire i dati non utilizzati
> nell'heap in modo da non esaurire lo spazio sono tutti problemi che l'ownership
> affronta. Una volta che capirai l'ownership, non dovrai pensare spesso allo
> stack e all'heap, ma sapere che l'obiettivo principale dell'ownership
> è gestire i dati nell'heap può aiutare a spiegare perché funziona in questo modo.

### Regole dell'Ownership

Per prima cosa, diamo un'occhiata alle regole dell'ownership. Tieni a mente queste regole mentre
procediamo attraverso gli esempi che le illustrano:

* Ogni valore in Rust ha un *owner*.
* Può esserci solo un owner alla volta.
* Quando l'owner esce dallo scope, il valore verrà rilasciato.

### Scope delle Variabili

Ora che abbiamo superato la sintassi base di Rust, non includeremo tutto il codice `fn main() {`
negli esempi, quindi se stai seguendo, assicurati di inserire i seguenti
esempi manualmente all'interno di una funzione `main`. Di conseguenza, i nostri esempi saranno
un po' più concisi, permettendoci di concentrarci sui dettagli effettivi piuttosto che
sul codice boilerplate.

Come primo esempio di ownership, daremo un'occhiata allo *scope* di alcune variabili. Uno
scope è l'intervallo all'interno di un programma per il quale un elemento è valido. Prendi la
seguente variabile:

```rust
let s = "hello";
```

La variabile `s` si riferisce a un literal di stringa, dove il valore della stringa è
codificato nel testo del nostro programma. La variabile è valida dal momento in cui
viene dichiarata fino alla fine dell'attuale *scope*. Listing 4-1 mostra un programma con commenti che annotano dove la variabile `s` sarebbe valida.

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/listing-04-01/src/main.rs:here}}
```

<span class="caption">Listing 4-1: Una variabile e lo scope in cui è
valida</span>

In altre parole, ci sono due importanti punti nel tempo qui:

* Quando `s` entra nello *scope*, è valida.
* Rimane valida fino a quando esce dallo *scope*.

A questo punto, la relazione tra gli scope e quando le variabili sono valide è
simile a quella di altri linguaggi di programmazione. Ora costruiremo su questa
comprensione introducendo il tipo `String`.

### Il Tipo `String`

Per illustrare le regole dell'ownership, abbiamo bisogno di un tipo di dato più complesso
di quelli trattati nella sezione [“Tipi di Dato”][data-types]<!-- ignore --> del Capitolo 3. I tipi trattati in precedenza sono di dimensioni conosciute, possono essere memorizzati
sullo stack e poppati dallo stack quando il loro scope è finito, e possono essere
rapidamente e facilmente copiati per creare una nuova istanza indipendente se un'altra
parte del codice ha bisogno di utilizzare lo stesso valore in un diverso scope. Ma vogliamo
esaminare i dati che sono memorizzati nell'heap ed esplorare come Rust sa quando
pulire quei dati, e il tipo `String` è un ottimo esempio.

Ci concentreremo sulle parti di `String` che riguardano l'ownership. Questi
aspetti si applicano anche ad altri tipi di dati complessi, siano essi forniti dalla
libreria standard o creati da te. Discuteremo `String` più in dettaglio nel
[Capitolo 8][ch8]<!-- ignore -->.

Abbiamo già visto i literal di stringa, dove un valore di stringa è codificato nel nostro
programma. I literal di stringa sono convenienti, ma non sono adatti a ogni
situazione in cui potremmo voler usare il testo. Un motivo è che sono
immutabili. Un altro è che non tutti i valori delle stringhe possono essere conosciuti quando scriviamo il nostro
codice: per esempio, cosa succede se vogliamo prendere l'input dell'utente e memorizzarlo? Per
queste situazioni, Rust ha un secondo tipo di stringa, `String`. Questo tipo gestisce
dati allocati nell'heap e come tale è in grado di memorizzare una quantità di testo che
non conosciamo in fase di compilazione. Puoi creare un `String` da un literal di stringa
usando la funzione `from`, in questo modo:

```rust
let s = String::from("hello");
```

Il doppio due punti `::` dell'operatore ci consente di usare questo particolare `from`
all'interno del tipo `String` anziché utilizzare un qualche tipo di nome come
`string_from`. Discuteremo questa sintassi più nella sezione [“Metodo
Sintassi”][method-syntax]<!-- ignore --> del Capitolo 5 e quando parleremo della creazione di namespace con i moduli in [“Percorsi per riferirsi a un elemento nell'albero dei moduli”][paths-module-tree]<!-- ignore --> nel Capitolo 7.

Questo tipo di stringa *può* essere mutato:

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-01-can-mutate-string/src/main.rs:here}}
```

Quindi, qual è la differenza qui? Perché `String` può essere mutata ma i literal
no? La differenza sta in come questi due tipi gestiscono la memoria.

### Memoria e Allocazione

Nel caso di un literal di stringa, conosciamo il contenuto in fase di compilazione, quindi il
testo è codificato direttamente nel file eseguibile finale. Questo è il motivo per cui i literal di stringa sono rapidi ed efficienti. Ma queste proprietà derivano solo dall'immutabilità del literal di stringa. Sfortunatamente, non possiamo mettere una quantità indefinita di memoria nel binario per ogni pezzo di testo la cui dimensione è sconosciuta in fase di compilazione e la cui dimensione potrebbe cambiare durante l'esecuzione del programma.

Con il tipo `String`, al fine di supportare un pezzo di testo mutabile e che
può crescere, dobbiamo allocare una quantità di memoria nell'heap, sconosciuta in fase di compilazione, per
contenere il contenuto. Questo significa:

* La memoria deve essere richiesta dal memory allocator a runtime.
* Abbiamo bisogno di un modo per restituire questa memoria all'allocator quando abbiamo finito con
  il nostro `String`.

Quella prima parte è fatta da noi: quando chiamiamo `String::from`, la sua implementazione richiede
la memoria di cui ha bisogno. Questo è abbastanza universale nei linguaggi di
programmazione.

Tuttavia, la seconda parte è diversa. Nei linguaggi con un *garbage collector
(GC)*, il GC tiene traccia e pulisce la memoria che non viene più utilizzata,
e noi non dobbiamo pensarci. Nella maggior parte dei linguaggi senza un GC,
è nostra responsabilità identificare quando la memoria non viene più utilizzata e
chiamare del codice per liberarla esplicitamente, proprio come abbiamo fatto per richiederla. Fare questo in modo corretto è storicamente stato un problema di programmazione difficile.
Se ce ne dimentichiamo, sprecheremo memoria. Se lo facciamo troppo presto, avremo una variabile non valida. Se lo facciamo due volte, è anche un bug. Abbiamo bisogno di abbinare esattamente un `allocate` con
esattamente un `free`.

Rust prende un percorso diverso: la memoria viene automaticamente restituita una volta che la
variabile che la possiede esce dallo scope. Ecco una versione del nostro esempio di scope
dal Listing 4-1 usando una `String` anziché un literal di stringa:

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-02-string-scope/src/main.rs:here}}
```

C'è un punto naturale in cui possiamo restituire la memoria di cui il nostro `String` ha bisogno
all'allocator: quando `s` esce dallo scope. Quando una variabile esce dallo scope,
Rust chiama una funzione speciale per noi. Questa funzione si chiama
[`drop`][drop]<!-- ignore -->, ed è dove l'autore di `String` può mettere
il codice per restituire la memoria. Rust chiama `drop` automaticamente alla chiusura
della parentesi graffa.

> Nota: In C++, questo pattern di deallocare risorse alla fine del ciclo di vita di un elemento è talvolta chiamato *Resource Acquisition Is Initialization (RAII)*.
> La funzione `drop` in Rust sarà familiare se hai usato pattern RAII.

Questo pattern ha un impatto profondo sul modo in cui viene scritto il codice Rust. Potrebbe sembrare
semplice ora, ma il comportamento del codice può essere inaspettato in situazioni più
complicate quando vogliamo che più variabili utilizzino i dati che abbiamo
allocato nell'heap. Esploriamo alcune di queste situazioni ora.

<!-- Vecchio titolo. Non rimuovere o i link potrebbero rompersi. -->
<a id="ways-variables-and-data-interact-move"></a>

#### Variabili e Dati che Interagiscono con il Move

Più variabili possono interagire con gli stessi dati in modi diversi in Rust.
Diamo un'occhiata a un esempio usando un intero nel Listing 4-2.

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/listing-04-02/src/main.rs:here}}
```

<span class="caption">Listing 4-2: Assegnare il valore intero della variabile `x` a `y`</span>

Probabilmente possiamo immaginare cosa sta facendo: “associa il valore `5` a `x`; quindi fai
una copia del valore in `x` e associala a `y`.” Ora abbiamo due variabili, `x`
e `y`, e entrambi valgono `5`. Questo è effettivamente ciò che sta accadendo, perché gli interi
sono valori semplici di dimensioni conosciute e fisse, e questi due valori `5` vengono pushati
nello stack.

Ora vediamo la versione con `String`:

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-03-string-move/src/main.rs:here}}
```

Questo sembra molto simile, quindi potremmo supporre che funzioni allo stesso modo: vale a dire, la seconda riga farebbe una copia del valore in `s1` e lo assocerebbe a `s2`. Ma non è proprio quello che succede.

Dai un'occhiata alla Figura 4-1 per vedere cosa sta succedendo a `String` sotto il cofano. Una `String` è composta da tre parti, mostrate a sinistra: un puntatore alla memoria che contiene il contenuto della stringa, una lunghezza e una capacità. Questo gruppo di dati viene memorizzato nello stack. A destra c'è la memoria sull'heap che contiene i contenuti.

<img alt="Due tabelle: la prima tabella contiene la rappresentazione di s1 nello stack, composta dalla sua lunghezza (5), capacità (5), e un puntatore al primo valore nella seconda tabella. La seconda tabella contiene la rappresentazione dei dati della stringa nell'heap, byte per byte." src="img/trpl04-01.svg" class="center"
style="width: 50%;" />

<span class="caption">Figura 4-1: Rappresentazione in memoria di una `String`
che contiene il valore `"hello"` associato a `s1`</span>

La lunghezza è la quantità di memoria, in byte, che il contenuto della `String` sta
attualmente utilizzando. La capacità è la quantità totale di memoria, in byte, che la
`String` ha ricevuto dall'allocator. La differenza tra lunghezza e
capacità è importante, ma non in questo contesto, quindi per ora, va bene ignorare la
capacità.

Quando assegnamo `s1` a `s2`, i dati della `String` vengono copiati, il che significa che
copia il puntatore, la lunghezza e la capacità che sono nello stack. Non copiamo i
dati nell'heap a cui il puntatore si riferisce. In altre parole, la rappresentazione in memoria sembra simile a quella della Figura 4-2.

<img alt="Tre tabelle: tabella s1 e s2 che rappresentano quelle stringhe nello stack, rispettivamente, e entrambe puntano ai stessi dati della stringa nell'heap." src="img/trpl04-02.svg" class="center"
style="width: 50%;" />

<span class="caption">Figura 4-2: Rappresentazione in memoria della variabile `s2` che ha una copia del puntatore, lunghezza e capacità di `s1`</span>

La rappresentazione *non* sembra come nella Figura 4-3, che è ciò che la memoria mostrerebbe se Rust copiasse anche i dati nell'heap. Se Rust facesse questo, l'operazione `s2 = s1` potrebbe essere molto costosa in termini di prestazioni runtime se i dati nell'heap fossero grandi.

<img alt="Quattro tabelle: due tabelle che rappresentano i dati dello stack per s1 e s2, e ciascuna punta alla propria copia dei dati della stringa nell'heap." src="img/trpl04-03.svg" class="center"
style="width: 50%;" />

<span class="caption">Figura 4-3: Un'altra possibilità di ciò che `s2 = s1` potrebbe fare se Rust copiasse anche i dati nell'heap</span>

In precedenza, abbiamo detto che quando una variabile esce dallo scope, Rust chiama automaticamente la funzione `drop` e pulisce la memoria heap per quella variabile. Ma la Figura 4-2 mostra che entrambi i puntatori dati puntano alla stessa posizione. Questo è un problema: quando `s2` e `s1` escono dallo scope, entrambi tenteranno di liberare la stessa memoria. Questo è noto come un errore di *doppia liberazione* ed è uno dei bug di sicurezza della memoria che abbiamo menzionato in precedenza. La liberazione della memoria due volte può portare alla corruzione della memoria, il che può potenzialmente portare a vulnerabilità di sicurezza.

Per garantire la sicurezza della memoria, dopo la linea `let s2 = s1;`, Rust considera `s1` non più valido. Pertanto, Rust non ha bisogno di liberare nulla quando `s1` esce dallo scope. Guarda cosa succede quando provi a usare `s1` dopo che `s2` è stato creato; non funzionerà:

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-04-cant-use-after-move/src/main.rs:here}}
```

Riceverai un errore simile a questo perché Rust ti impedisce di usare il riferimento invalidato:

```console
{{#include ../listings/ch04-understanding-ownership/no-listing-04-cant-use-after-move/output.txt}}
```

Se hai sentito i termini *shallow copy* e *deep copy* mentre lavori con altri linguaggi, il concetto di copiare il puntatore, la lunghezza e la capacità senza copiare i dati probabilmente ti sembra quello di fare una shallow copy. Ma poiché Rust invalida anche la prima variabile, anziché essere chiamata una shallow copy, è conosciuta come una *move*. In questo esempio, diremmo che `s1` è stato *spostato* in `s2`. Quindi, ciò che accade effettivamente è mostrato nella Figura 4-4.

<img alt="Tre tabelle: le tabelle s1 e s2 rappresentano quelle stringhe nello stack, rispettivamente, e puntano entrambe alla stessa stringa di dati nell'heap. La tabella s1 è grigliata perché s1 non è più valida; solo s2 può essere usato per accedere ai dati dell'heap." src="img/trpl04-04.svg" class="center" style="width: 50%;" />

<span class="caption">Figura 4-4: Rappresentazione in memoria dopo che `s1` è stato invalidato</span>

Questo risolve il nostro problema! Con solo `s2` valido, quando esce dallo scope libererà da solo la memoria, e avremo finito.

Inoltre, c'è una scelta di progettazione implicita in questo: Rust non creerà mai automaticamente copie "profonde" dei tuoi dati. Pertanto, qualsiasi copia *automatica* può essere considerata poco costosa in termini di prestazioni di runtime.

<!-- Vecchia intestazione. Non rimuovere o i link potrebbero rompersi. -->
<a id="ways-variables-and-data-interact-clone"></a>

#### Variabili e dati che interagiscono con Clone

Se *vogliamo* eseguire una copia profonda dei dati heap del `String`, non solo dei dati dello stack, possiamo utilizzare un metodo comune chiamato `clone`. Discuteremo la sintassi dei metodi nel Capitolo 5, ma poiché i metodi sono una caratteristica comune in molti linguaggi di programmazione, probabilmente li hai già visti.

Ecco un esempio del metodo `clone` in azione:

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-05-clone/src/main.rs:here}}
```

Questo funziona perfettamente e produce esplicitamente il comportamento mostrato nella Figura 4-3, dove i dati dell'heap *vengono* copiati.

Quando vedi una chiamata a `clone`, saprai che è in esecuzione qualche codice arbitrario e che quel codice potrebbe essere costoso. È un indicatore visivo che qualcosa di diverso sta accadendo.

#### Dati solo dello stack: Copy

C'è un'altra piega di cui non abbiamo ancora parlato. Questo codice che utilizza numeri interi—parte del quale è mostrata nel Listing 4-2—funziona ed è valido:

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/no-listing-06-copy/src/main.rs:here}}
```

Ma questo codice sembra contraddire ciò che abbiamo appena imparato: non abbiamo una chiamata a `clone`, ma `x` è ancora valido e non è stato spostato in `y`.

La ragione è che tipi come gli interi che hanno una dimensione nota a tempo di compilazione sono conservati interamente nello stack, quindi le copie dei valori effettivi sono rapide da fare. Ciò significa che non c'è motivo per cui vorremmo impedire che `x` sia valido dopo aver creato la variabile `y`. In altre parole, non c'è differenza tra copia profonda e superficiale qui, quindi chiamare `clone` non farebbe nulla di diverso dalla copia superficiale abituale, e possiamo lasciarlo fuori.

Rust ha un'annotazione speciale chiamata il trait `Copy` che possiamo applicare ai tipi che sono conservati nello stack, come gli interi (parleremo più dei traits nel [Capitolo 10][traits]<!-- ignore -->). Se un tipo implementa il trait `Copy`, le variabili che lo utilizzano non si spostano, ma vengono copiate in modo banale, rendendole ancora valide dopo l'assegnazione ad un'altra variabile.

Rust non ci permetterà di annotare un tipo con `Copy` se il tipo, o una qualsiasi delle sue parti, ha implementato il trait `Drop`. Se il tipo necessita di qualcosa di speciale quando il valore esce dallo scope e aggiungiamo l'annotazione `Copy` a quel tipo, otterremo un errore a tempo di compilazione. Per imparare come aggiungere l'annotazione `Copy` al tuo tipo per implementare il trait, vedi [“Derivable Traits”][derivable-traits]<!-- ignore --> nell'Appendice C.

Quindi, quali tipi implementano il trait `Copy`? Puoi controllare la documentazione per il tipo dato per esserne sicuro, ma come regola generale, qualsiasi gruppo di valori scalari semplici può implementare `Copy`, e nulla che richiede allocazione o è una qualche forma di risorsa può implementare `Copy`. Ecco alcuni dei tipi che implementano `Copy`:

* Tutti i tipi interi, come `u32`.
* Il tipo booleano, `bool`, con valori `true` e `false`.
* Tutti i tipi a virgola mobile, come `f64`.
* Il tipo carattere, `char`.
* Tuple, se contengono solo tipi che implementano anche `Copy`. Ad esempio, `(i32, i32)` implementa `Copy`, ma `(i32, String)` no.

### Ownership e funzioni

La meccanica del passare un valore a una funzione è simile a quella dell'assegnare un valore a una variabile. Passare una variabile a una funzione la sposterà o copierà, proprio come fa l'assegnazione. Il Listing 4-3 contiene un esempio con alcune annotazioni che mostrano dove le variabili entrano ed escono dallo scope.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/listing-04-03/src/main.rs}}
```

<span class="caption">Listing 4-3: Funzioni con ownership e scope annotati</span>

Se proviamo a usare `s` dopo la chiamata a `takes_ownership`, Rust restituirà un errore a tempo di compilazione. Questi controlli statici ci proteggono dagli errori. Prova ad aggiungere codice a `main` che utilizza `s` e `x` per vedere dove puoi usarli e dove le regole di ownership ti impediscono di farlo.

### Valori di ritorno e scope

Restituire valori può anche trasferire l'ownership. Il Listing 4-4 mostra un esempio di una funzione che restituisce un valore, con annotazioni simili a quelle del Listing 4-3.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/listing-04-04/src/main.rs}}
```

<span class="caption">Listing 4-4: Trasferimento dell'ownership dei valori di ritorno</span>

L'ownership di una variabile segue lo stesso schema ogni volta: assegnare un valore a un'altra variabile lo sposta. Quando una variabile che include dati nell'heap esce dallo scope, il valore verrà pulito da `drop` a meno che l'ownership dei dati non sia stata trasferita a un'altra variabile.

Anche se questo funziona, prendere l'ownership e poi restituire l'ownership con ogni funzione è un po' tedioso. Cosa succederebbe se volessimo permettere a una funzione di usare un valore ma non prenderne l'ownership? È piuttosto fastidioso che qualsiasi cosa passiamo debba anche essere restituita se vogliamo usarla di nuovo, oltre a qualsiasi dato risultante dal corpo della funzione che potremmo voler restituire.

Rust ci permette di restituire valori multipli usando una tupla, come mostrato nel Listing 4-5.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch04-understanding-ownership/listing-04-05/src/main.rs}}
```

<span class="caption">Listing 4-5: Restituzione dell'ownership dei parametri</span>

Ma questo è troppo cerimoniale e molto lavoro per un concetto che dovrebbe essere comune. Fortunatamente per noi, Rust ha una caratteristica per utilizzare un valore senza trasferire l'ownership, chiamata *references*.

[data-types]: ch03-02-data-types.html#data-types
[ch8]: ch08-02-strings.html
[traits]: ch10-02-traits.html
[derivable-traits]: appendix-03-derivable-traits.html
[method-syntax]: ch05-03-method-syntax.html#method-syntax
[paths-module-tree]: ch07-03-paths-for-referring-to-an-item-in-the-module-tree.html
[drop]: ../std/ops/trait.Drop.html#tymethod.drop
