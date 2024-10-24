## Traits: Definire un Comportamento Condiviso

Un *trait* definisce la funzionalità che un particolare tipo possiede e può condividere con
altri tipi. Possiamo utilizzare i traits per definire un comportamento condiviso in modo astratto. Possiamo usare i *vincoli dei trait* per specificare che un tipo generico può essere qualsiasi tipo che ha un certo comportamento.

> Nota: I traits sono simili a una funzionalità spesso chiamata *interfacce* in altri
> linguaggi, anche se con alcune differenze.

### Definire un Trait

Il comportamento di un tipo consiste nei metodi che possiamo chiamare su quel tipo. Tipi diversi condividono lo stesso comportamento se possiamo chiamare gli stessi metodi su tutti quei tipi. Le definizioni dei traits sono un modo per raggruppare insieme le firme dei metodi per definire un insieme di comportamenti necessari a raggiungere un certo scopo.

Per esempio, supponiamo di avere diverse structs che contengono vari tipi e
quantità di testo: una struct `NewsArticle` che contiene una notizia archiviata in un
particolare luogo e un `Tweet` che può avere, al massimo, 280 caratteri insieme a metadati che indicano se era un nuovo tweet, un retweet, o una risposta
a un altro tweet.

Vogliamo creare una libreria crate di aggregazione di media chiamata `aggregator` che può
mostrare sommari dei dati che potrebbero essere memorizzati in un'istanza `NewsArticle` o `Tweet`. Per fare questo, abbiamo bisogno di un sommario da ciascun tipo, e chiederemo tale sommario chiamando un metodo `summarize` su un'istanza. Il Listing 10-12 mostra la definizione di un trait pubblico `Summary` che esprime questo comportamento.

<span class="filename">File: src/lib.rs</span>

```rust,noplayground
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-12/src/lib.rs}}
```

<span class="caption">Listing 10-12: Un trait `Summary` che consiste nel
comportamento fornito da un metodo `summarize`</span>

Qui, dichiariamo un trait utilizzando la parola chiave `trait` e poi il nome del trait,
che in questo caso è `Summary`. Dichiariamo anche il trait come `pub` in modo che
anche i crates che dipendono da questo crate possano utilizzare questo trait, come vedremo
in alcuni esempi. All'interno delle parentesi graffe, dichiariamo le firme dei metodi
che descrivono i comportamenti dei tipi che implementano questo trait, che in
questo caso è `fn summarize(&self) -> String`.

Dopo la firma del metodo, invece di fornire un'implementazione tra parentesi
graffe, usiamo un punto e virgola. Ogni tipo che implementa questo trait deve fornire
il proprio comportamento personalizzato per il blocco del metodo. Il compilatore imporrà
che qualsiasi tipo che abbia il trait `Summary` avrà il metodo `summarize` definito con questa firma esatta.

Un trait può avere più metodi nel suo corpo: le firme dei metodi
sono elencate una per riga, e ogni riga termina con un punto e virgola.

### Implementare un Trait su un Tipo

Ora che abbiamo definito le firme desiderate dei metodi del trait `Summary`,
possiamo implementarlo sui tipi nel nostro aggregatore di media. Il Listing 10-13 mostra
un'implementazione del trait `Summary` sulla struct `NewsArticle` che utilizza
il titolo, l'autore e la localizzazione per creare il valore di ritorno di
`summarize`. Per la struct `Tweet`, definiamo `summarize` come il nome utente
seguito dall'intero testo del tweet, assumendo che il contenuto del tweet sia già
limitato a 280 caratteri.

<span class="filename">File: src/lib.rs</span>

```rust,noplayground
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-13/src/lib.rs:here}}
```

<span class="caption">Listing 10-13: Implementare il trait `Summary` sui
tipi `NewsArticle` e `Tweet`</span>

Implementare un trait su un tipo è simile a implementare metodi regolari. La
differenza è che dopo `impl`, mettiamo il nome del trait che vogliamo implementare,
poi usiamo la parola chiave `for`, e poi specifichiamo il nome del tipo per cui vogliamo
implementare il trait. All'interno del blocco `impl`, mettiamo le firme dei metodi
che la definizione del trait ha definito. Invece di aggiungere un punto e virgola dopo ogni
firma, usiamo le parentesi graffe e riempiamo il corpo del metodo con il comportamento
specifico che vogliamo che i metodi del trait abbiano per il tipo particolare.

Ora che la libreria ha implementato il trait `Summary` su `NewsArticle` e
`Tweet`, gli utenti del crate possono chiamare i metodi del trait su istanze di
`NewsArticle` e `Tweet` nello stesso modo in cui chiamiamo i metodi regolari. L'unica
differenza è che l'utente deve portare il trait a Scope così come i
tipi. Ecco un esempio di come un crate binario potrebbe utilizzare la nostra libreria
`aggregator`:

```rust,ignore
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/no-listing-01-calling-trait-method/src/main.rs}}
```

Questo codice stampa `1 new tweet: horse_ebooks: of course, as you probably already
know, people`.

Altri crates che dipendono dal crate `aggregator` possono anche portare il trait `Summary`
a Scope per implementare `Summary` sui propri tipi. Una restrizione da notare è che
possiamo implementare un trait su un tipo solo se o il trait o il tipo, o entrambi, sono
locali al nostro crate. Per esempio, possiamo implementare i traits della libreria standard come
`Display` su un tipo personalizzato come `Tweet` come parte della nostra
funzionalità del crate `aggregator` perché il tipo `Tweet` è locale al nostro
crate `aggregator`. Possiamo anche implementare `Summary` su `Vec<T>` nel nostro
crate `aggregator` perché il trait `Summary` è locale al nostro crate
`aggregator`.

Ma non possiamo implementare trait esterni su tipi esterni. Per esempio, non possiamo
implementare il trait `Display` su `Vec<T>` all'interno del nostro crate `aggregator` perché
`Display` e `Vec<T>` sono entrambi definiti nella libreria standard e non sono
locali al nostro crate `aggregator`. Questa restrizione fa parte di una proprietà chiamata
*coerenza*, e più specificamente la *regola dell'orfano*, così chiamata perché il
tipo padre non è presente. Questa regola assicura che il codice degli altri non possa
rompere il tuo codice e viceversa. Senza la regola, due crates potrebbero implementare
lo stesso trait per lo stesso tipo, e Rust non saprebbe quale implementazione
utilizzare.

### Implementazioni Predefinite

A volte è utile avere un comportamento predefinito per alcuni o per tutti i metodi
in un trait invece di richiedere implementazioni per tutti i metodi su ogni tipo.
Poi, mentre implementiamo il trait su un tipo particolare, possiamo mantenere o sovrascrivere
il comportamento predefinito di ciascun metodo.

Nel Listing 10-14, specifichiamo una stringa predefinita per il metodo `summarize` del
trait `Summary` invece di definire solo la firma del metodo, come abbiamo fatto nel
Listing 10-12.

<span class="filename">File: src/lib.rs</span>

```rust,noplayground
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-14/src/lib.rs:here}}
```

<span class="caption">Listing 10-14: Definire un trait `Summary` con un'implementazione
predefinita del metodo `summarize`</span>

Per utilizzare una implementazione predefinita per riassumere le istanze di `NewsArticle`, specifichiamo un blocco `impl` vuoto con `impl Summary for NewsArticle {}`.

Anche se non definiamo più il metodo `summarize` su `NewsArticle`
direttamente, abbiamo fornito un'implementazione predefinita e specificato che
`NewsArticle` implementa il trait `Summary`. Di conseguenza, possiamo continuare a chiamare
il metodo `summarize` su un'istanza di `NewsArticle`, in questo modo:

```rust,ignore
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/no-listing-02-calling-default-impl/src/main.rs:here}}
```

Questo codice stampa `New article available! (Read more...)`.

Creare un'implementazione predefinita non ci richiede di cambiare nulla sull'implementazione
di `Summary` su `Tweet` nel Listing 10-13. Il motivo è che la sintassi per sovrascrivere
un'implementazione predefinita è la stessa sintassi per implementare un metodo del trait che
non ha un'implementazione predefinita.

Le implementazioni predefinite possono chiamare altri metodi nello stesso trait, anche se quegli
altri metodi non hanno un'implementazione predefinita. In questo modo, un trait può
fornire molta funzionalità utile e richiedere solo che gli implementatori specifichino
una piccola parte di essa. Per esempio, potremmo definire il trait `Summary` per avere un
metodo `summarize_author` la cui implementazione è richiesta, per poi definire un
metodo `summarize` che ha un'implementazione predefinita che chiama il metodo
`summarize_author`:

```rust,noplayground
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/no-listing-03-default-impl-calls-other-methods/src/lib.rs:here}}
```

Per utilizzare questa versione di `Summary`, dobbiamo solo definire `summarize_author`
quando implementiamo il trait su un tipo:

```rust,ignore
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/no-listing-03-default-impl-calls-other-methods/src/lib.rs:impl}}
```

Dopo aver definito `summarize_author`, possiamo chiamare `summarize` su istanze della
struct `Tweet`, e l'implementazione predefinita di `summarize` chiamerà la
definizione di `summarize_author` che abbiamo fornito. Poiché abbiamo implementato
`summarize_author`, il trait `Summary` ci ha fornito il comportamento del
metodo `summarize` senza richiederci di scrivere più codice. Ecco come appare:

```rust,ignore
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/no-listing-03-default-impl-calls-other-methods/src/main.rs:here}}
```

Questo codice stampa `1 new tweet: (Read more from @horse_ebooks...)`.

Nota che non è possibile chiamare l'implementazione predefinita da un'
implementazione di override di quello stesso metodo.

### Traits come Parametri

Ora che sai come definire e implementare i traits, possiamo esplorare come
utilizzare i traits per definire funzioni che accettano molti tipi diversi. Useremo il
trait `Summary` che abbiamo implementato sui tipi `NewsArticle` e `Tweet` nel
Listing 10-13 per definire una funzione `notify` che chiama il metodo `summarize`
sul suo parametro `item`, che è di un tipo che implementa il trait `Summary`.
Per fare questo, utilizziamo la sintassi `impl Trait`, come questa:

```rust,ignore
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/no-listing-04-traits-as-parameters/src/lib.rs:here}}
```

Invece di un tipo concreto per il parametro `item`, specifichiamo la parola chiave `impl`
e il nome del trait. Questo parametro accetta qualsiasi tipo che implementa il
trait specificato. Nel Blocco di `notify`, possiamo chiamare qualsiasi metodo su `item`
che provenga dal trait `Summary`, come `summarize`. Possiamo chiamare `notify`
e passare qualsiasi istanza di `NewsArticle` o `Tweet`. Il codice che chiama la
funzione con qualsiasi altro tipo, come una `String` o un `i32`, non sarà compilato
perché quei tipi non implementano `Summary`.

<!-- Vecchie intestazioni. Non rimuovere o i link potrebbero rompersi. -->
<a id="fixing-the-largest-function-with-trait-bounds"></a>

#### Sintassi del Vincolo di Trait

La sintassi `impl Trait` funziona per casi semplici ma è in realtà una scorciatoia
sintattica per una forma più lunga conosciuta come *vincolo di trait*; si presenta così:

```rust,ignore
pub fn notify<T: Summary>(item: &T) {
    println!("Breaking news! {}", item.summarize());
}
```

Questa forma più lunga è equivalente all'esempio nella sezione precedente ma è
più verbosa. Poniamo i vincoli di trait con la dichiarazione del tipo generico
di parametro dopo un due punti e all'interno di parentesi angolari.

La sintassi `impl Trait` è comoda e rende il codice più conciso in casi semplici,
mentre la sintassi più completa del vincolo di trait può esprimere più
complessità in altri casi. Per esempio, possiamo avere due parametri che implementano
`Summary`. Farlo con la sintassi `impl Trait` appare così:

```rust,ignore
pub fn notify(item1: &impl Summary, item2: &impl Summary) {
```

Usare `impl Trait` è appropriato se vogliamo che questa funzione permetta a `item1` e
`item2` di avere tipi diversi (a condizione che entrambi i tipi implementino `Summary`). Se
vogliamo forzare entrambi i parametri ad avere lo stesso tipo, tuttavia, dobbiamo usare un
vincolo di trait, come questo:

```rust,ignore
pub fn notify<T: Summary>(item1: &T, item2: &T) {
```

Il tipo generico `T` specificato come tipo dei parametri `item1` e `item2`
limita la funzione in modo tale che il tipo concreto del valore passato come argomento
per `item1` e `item2` deve essere lo stesso.

#### Specificare Vincoli di Trait Multipli con la Sintassi `+`

Possiamo anche specificare più di un vincolo di trait. Supponiamo di voler utilizzare
la formattazione del display così come `summarize` su `item`: specifichiamo nella definizione
di `notify` che `item` deve implementare sia `Display` che `Summary`. Possiamo farlo usando la sintassi `+`:

```rust,ignore
pub fn notify(item: &(impl Summary + Display)) {
```

La sintassi `+` è valida anche con vincoli di trait su tipi generici:

```rust,ignore
pub fn notify<T: Summary + Display>(item: &T) {
```

Con i due vincoli di trait specificati, il blocco di `notify` può chiamare
`summarize` e utilizzare `{}` per formattare `item`.

#### Vincoli di Trait Più Chiari con le Clauses `where`

Utilizzare troppi vincoli di trait ha i suoi svantaggi. Ogni generico ha i propri
vincoli di trait, quindi le funzioni con più parametri di tipo generico possono
contenere molte informazioni sui vincoli di trait tra il nome della funzione e la lista
dei suoi parametri, rendendo la firma della funzione difficile da leggere. Per questo motivo, Rust
ha una sintassi alternativa per specificare i vincoli di trait all'interno di una clause
`where` dopo la firma della funzione. Quindi, invece di scrivere questo:

```rust,ignore
fn some_function<T: Display + Clone, U: Clone + Debug>(t: &T, u: &U) -> i32 {
```

possiamo usare una clause `where`, come questa:

```rust,ignore
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/no-listing-07-where-clause/src/lib.rs:here}}
```

La firma di questa funzione è meno ingombra: il nome della funzione, la lista dei parametri,
e il tipo di ritorno sono vicini, simili a una funzione senza molti vincoli di trait.

### Restituire Tipi che Implementano Traits

Possiamo anche utilizzare la sintassi `impl Trait` nella posizione di ritorno per restituire
un valore di qualche tipo che implementa un trait, come mostrato qui:

```rust,ignore
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/no-listing-05-returning-impl-trait/src/lib.rs:here}}
```

Utilizzando `impl Summary` per il tipo di ritorno, specifichiamo che la
funzione `returns_summarizable` restituisce un qualche tipo che implementa il trait `Summary`
senza nominare il tipo concreto. In questo caso, `returns_summarizable` restituisce un
`Tweet`, ma il codice che chiama questa funzione non ha bisogno di saperlo.

La capacità di specificare un tipo di ritorno solo tramite il trait che implementa è
particolarmente utile nel contesto delle closures e degli iteratori, che trattiamo
nel Capitolo 13. Le closures e gli iteratori creano tipi che solo il compilatore conosce o tipi
che sono molto lunghi da specificare. La sintassi `impl Trait` ti permette di specificare
concettualmente che una funzione restituisce qualche tipo che implementa il trait `Iterator`
senza dover scrivere un tipo molto lungo.

Tuttavia, puoi utilizzare `impl Trait` solo se stai restituendo un singolo tipo. Per
esempio, questo codice che restituisce o un `NewsArticle` o un `Tweet` con il
tipo di ritorno specificato come `impl Summary` non funzionerebbe:

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/no-listing-06-impl-trait-returns-one-type/src/lib.rs:here}}
```

Restituire o un `NewsArticle` o un `Tweet` non è permesso a causa delle restrizioni su come
la sintassi `impl Trait` è implementata nel compilatore. Tratteremo come scrivere una funzione
con questo comportamento nella sezione [“Usare Oggetti Trait che Consentono Valori di Tipi Diversi”][using-trait-objects-that-allow-for-values-of-different-types]<!-- ignore --> del Capitolo 17.

### Usare Vincoli di Trait per Implementare Condizionatamente Metodi


Utilizzando un bound di trait con un blocco `impl` che utilizza parametri di tipo generici, possiamo implementare metodi in modo condizionale per i tipi che implementano i trait specificati. Ad esempio, il tipo `Pair<T>` nel Listing 10-15 implementa sempre la funzione `new` per restituire una nuova istanza di `Pair<T>` (ricorda dalla sezione [“Definire i Metodi”][methods]<!-- ignore --> del Capitolo 5 che `Self` è un alias di tipo per il tipo del blocco `impl`, che in questo caso è `Pair<T>`). Ma nel successivo blocco `impl`, `Pair<T>` implementa il metodo `cmp_display` solo se il suo tipo interno `T` implementa il trait `PartialOrd` che abilita il confronto *e* il trait `Display` che abilita la stampa.

<span class="filename">Nome file: src/lib.rs</span>

```rust,noplayground
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-15/src/lib.rs}}
```

<span class="caption">Listing 10-15: Implementazione condizionale di metodi su un tipo generico a seconda dei bound di trait</span>

Possiamo anche implementare condizionalmente un trait per qualsiasi tipo che implementa un altro trait. Le implementazioni di un trait su qualsiasi tipo che soddisfa i bound del trait sono chiamate *implementazioni blanket* e sono usate ampiamente nella libreria standard di Rust. Ad esempio, la libreria standard implementa il trait `ToString` su qualsiasi tipo che implementa il trait `Display`. Il blocco `impl` nella libreria standard appare simile a questo codice:

```rust,ignore
impl<T: Display> ToString for T {
    // --snip--
}
```

Poiché la libreria standard ha questa implementazione blanket, possiamo chiamare il metodo `to_string` definito dal trait `ToString` su qualsiasi tipo che implementa il trait `Display`. Ad esempio, possiamo trasformare gli interi nei loro valori `String` corrispondenti in questo modo perché gli interi implementano `Display`:

```rust
let s = 3.to_string();
```

Le implementazioni blanket appaiono nella documentazione per il trait nella sezione “Implementatori”.

I trait e i bound di trait ci permettono di scrivere codice che utilizza parametri di tipo generici per ridurre la duplicazione ma anche di specificare al compilatore che vogliamo che il tipo generico abbia un comportamento particolare. Il compilatore può quindi utilizzare le informazioni sul bound di trait per verificare che tutti i tipi concreti utilizzati con il nostro codice forniscano il comportamento corretto. Nei linguaggi tipizzati dinamicamente, riceveremmo un errore a runtime se chiamassimo un metodo su un tipo che non definisce il metodo. Ma Rust sposta questi errori al tempo di compilazione, quindi siamo costretti a risolvere i problemi prima ancora che il nostro codice possa essere eseguito. Inoltre, non dobbiamo scrivere codice che controlli il comportamento a runtime perché abbiamo già controllato al tempo di compilazione. Fare ciò migliora le prestazioni senza dover rinunciare alla flessibilità dei generici.

[using-trait-objects-that-allow-for-values-of-different-types]: ch17-02-trait-objects.html#using-trait-objects-that-allow-for-values-of-different-types
[methods]: ch05-03-method-syntax.html#defining-methods
