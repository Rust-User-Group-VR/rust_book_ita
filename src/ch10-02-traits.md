## Trait: Definire Comportamenti Condivisi

Un *trait* definisce la funzionalità che un determinato tipo ha e che può condividere con
altri tipi. Possiamo usare i trait per definire comportamenti condivisi in modo astratto. Possiamo usare i *trait bounds* per specificare che un tipo generico può essere qualsiasi tipo che ha certi comportamenti.

> Nota: I trait sono simili a una funzione spesso chiamata *interfacce* in altri
> linguaggi, sebbene con alcune differenze.

### Definire un Trait

Il comportamento di un tipo consiste nei metodi che possiamo chiamare su quel tipo. Tipi diversi condividono lo stesso comportamento se possiamo chiamare gli stessi metodi su tutti questi tipi. Le definizioni dei trait sono un modo per raggruppare insieme le firme dei metodi per definire un insieme di comportamenti necessari per raggiungere uno scopo.

Per esempio, diciamo che abbiamo più struct che contengono vari tipi e quantità di testo: una struct `NewsArticle` che contiene una notizia archiviata in una posizione particolare e un `Tweet` che può avere, al massimo, 280 caratteri assieme a metadati che indicano se era un nuovo tweet, un retweet, o una risposta a un altro tweet.

Vogliamo creare una crate libreria aggregatrice di media chiamata `aggregator` che possa mostrare riassunti di dati che potrebbero essere archiviati in un`istanza di `NewsArticle` o `Tweet`. Per fare questo, abbiamo bisogno di un sommario da ogni tipo, e richiederemo quel sommario chiamando un metodo `summarize` su un'istanza. Listing 10-12 mostra la definizione di un trait pubblico `Summary` che esprime questo comportamento.

<span class="filename">Nome del file: src/lib.rs</span>

```rust,noplayground
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-12/src/lib.rs}}
```

<span class="caption">Listing 10-12: Un trait `Summary` che consiste nei
comportamenti forniti da un metodo `summarize`</span>

Qui dichiariamo un trait usando la parola chiave `trait` e poi il nome del trait, che in questo caso è `Summary`. Dichiariamo anche il trait come `pub` affinché i crate che dipendono da questo crate possano utilizzare questo trait, come vedremo in alcuni esempi. Dentro le parentesi graffe, dichiariamo le firme dei metodi che descrivono i comportamenti dei tipi che implementano questo trait, che in questo caso è `fn summarize(&self) -> String`.

Dopo la firma del metodo, invece di fornire una implementazione dentro parentesi graffe, usiamo un punto e virgola. Ogni tipo che implementa questo trait deve fornire il proprio comportamento personalizzato per il corpo del metodo. Il compilatore imporrà che qualsiasi tipo che ha il trait `Summary` avrà il metodo `summarize` definito con esattamente questa firma.

Un trait può avere più metodi nel suo corpo: le firme dei metodi sono elencate una per linea, e ogni linea termina in un punto e virgola.

### Implementare un Trait su un Tipo

Ora che abbiamo definito le firme desiderate dei metodi del trait `Summary`, possiamo implementarlo sui tipi nel nostro aggregatore di media. Listing 10-13 mostra un'implementazione del trait `Summary` sulla struct `NewsArticle` che utilizza il titolo, l'autore e la località per creare il valore di ritorno di `summarize`. Per la struct `Tweet`, definiamo `summarize` come il nome utente seguito dall'intero testo del tweet, assumendo che il contenuto del tweet sia già limitato a 280 caratteri.

<span class="filename">Nome del file: src/lib.rs</span>

```rust,noplayground
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-13/src/lib.rs:here}}
```

<span class="caption">Listing 10-13: Implementazione del trait `Summary` sui tipi
`NewsArticle` e `Tweet`</span>

Implementare un trait su un tipo è simile a implementare metodi regolari. La differenza è che dopo `impl`, mettiamo il nome del trait che vogliamo implementare, usiamo la parola chiave `for`, e poi specifichiamo il nome del tipo per cui vogliamo implementare il trait. All'interno del blocco `impl`, mettiamo le firme dei metodi che la definizione del trait ha definito. Invece di aggiungere un punto e virgola dopo ogni firma, utilizziamo parentesi graffe e riempiamo il corpo del metodo con il comportamento specifico che vogliamo che i metodi del trait abbiano per il tipo particolare.

Ora che la libreria ha implementato il trait `Summary` su `NewsArticle` e `Tweet`, gli utenti del crate possono chiamare i metodi del trait sulle istanze di `NewsArticle` e `Tweet` nello stesso modo in cui chiamiamo metodi regolari. L'unica differenza è che l'utente deve portare il trait nello scope così come i tipi. Ecco un esempio di come un crate binario potrebbe utilizzare il nostro crate di libreria `aggregator`:

```rust,ignore
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/no-listing-01-calling-trait-method/src/main.rs}}
```

Questo codice stampa `1 new tweet: horse_ebooks: of course, as you probably already know, people`.

Altri crate che dipendono dal crate `aggregator` possono anche portare il trait `Summary` nello scope per implementare `Summary` sui propri tipi. Una limitazione da notare è che possiamo implementare un trait su un tipo solo se o il trait o il tipo, o entrambi, sono locali al nostro crate. Per esempio, possiamo implementare trait della libreria standard come `Display` su un tipo personalizzato come `Tweet` come parte della funzionalità del nostro crate `aggregator` perché il tipo `Tweet` è locale al nostro crate `aggregator`. Possiamo anche implementare `Summary` su `Vec<T>` nel nostro crate `aggregator` perché il trait `Summary` è locale al nostro crate `aggregator`.

Ma non possiamo implementare trait esterni su tipi esterni. Per esempio, non possiamo implementare il trait `Display` su `Vec<T>` nel nostro crate `aggregator` perché sia `Display` che `Vec<T>` sono definiti nella libreria standard e non sono locali al nostro crate `aggregator`. Questa restrizione è parte di una proprietà chiamata *coesione*, e più specificamente la *regola dell'orfano*, così chiamata perché il tipo padre non è presente. Questa regola garantisce che il codice di altre persone non possa rompere il tuo codice e viceversa. Senza la regola, due crate potrebbero implementare lo stesso trait per lo stesso tipo, e Rust non saprebbe quale implementazione usare.

### Implementazioni Predefinite

A volte è utile avere un comportamento predefinito per alcuni o tutti i metodi in un trait invece di richiedere implementazioni per tutti i metodi su ogni tipo. Poi, mentre implementiamo il trait su un particolare tipo, possiamo mantenere o sovrascrivere il comportamento predefinito di ogni metodo.

Nel Listing 10-14, specifichiamo una stringa predefinita per il metodo `summarize` del trait
`Summary` invece di definire solo la firma del metodo, come abbiamo fatto nel Listing 10-12.

<span class="filename">Nome del file: src/lib.rs</span>

```rust,noplayground
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-14/src/lib.rs:here}}
```

<span class="caption">Listing 10-14: Definizione di un trait `Summary` con una
implementazione predefinita del metodo `summarize`</span>

Per utilizzare un’implementazione predefinita per riassumere le istanze di `NewsArticle`,
specifichiamo un blocco `impl` vuoto con `impl Summary for NewsArticle {}`.

Anche se non stiamo più definendo direttamente il metodo `summarize` su `NewsArticle`,
abbiamo fornito un'implementazione predefinita e specificato che `NewsArticle` implementa il trait `Summary`. Di conseguenza, possiamo ancora chiamare il metodo `summarize` su un'istanza di `NewsArticle`, così:

```rust,ignore
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/no-listing-02-calling-default-impl/src/main.rs:here}}
```

Questo codice stampa `New article available! (Read more...)`.

Creare un'implementazione predefinita non richiede di cambiare nulla sull'implementazione di `Summary` su `Tweet` nel Listing 10-13. Il motivo è che la sintassi per sovrascrivere un’implementazione predefinita è la stessa della sintassi per implementare un metodo di trait che non ha un'implementazione predefinita.

Le implementazioni predefinite possono chiamare altri metodi nello stesso trait, anche se quegli altri metodi non hanno un'implementazione predefinita. In questo modo, un trait può fornire molta funzionalità utile e richiedere solo che gli implementatori specifichino una piccola parte di essa. Per esempio, potremmo definire il trait `Summary` per avere un metodo `summarize_author` la cui implementazione è richiesta, e poi definire un metodo `summarize` che ha un'implementazione predefinita che chiama il metodo `summarize_author`:

```rust,noplayground
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/no-listing-03-default-impl-calls-other-methods/src/lib.rs:here}}
```

Per utilizzare questa versione di `Summary`, dobbiamo solo definire `summarize_author` quando implementiamo il trait su un tipo:

```rust,ignore
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/no-listing-03-default-impl-calls-other-methods/src/lib.rs:impl}}
```

Dopo aver definito `summarize_author`, possiamo chiamare `summarize` sulle istanze della
struct `Tweet`, e l'implementazione predefinita di `summarize` chiamerà la definizione di `summarize_author` che abbiamo fornito. Poiché abbiamo implementato `summarize_author`, il trait `Summary` ci ha dato il comportamento del metodo `summarize` senza richiederci di scrivere altro codice. Ecco come appare:

```rust,ignore
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/no-listing-03-default-impl-calls-other-methods/src/main.rs:here}}
```

Questo codice stampa `1 new tweet: (Read more from @horse_ebooks...)`.

Nota che non è possibile chiamare l'implementazione predefinita da un'implementazione sovrascritta di quello stesso metodo.

### Trait come Parametri

Ora che sai come definire e implementare i trait, possiamo esplorare come usare i trait per definire funzioni che accettano molti tipi diversi. Useremo il trait `Summary` che abbiamo implementato sui tipi `NewsArticle` e `Tweet` nel Listing 10-13 per definire una funzione `notify` che chiama il metodo `summarize` sul suo parametro `item`, che è di un tipo che implementa il trait `Summary`. Per farlo, usiamo la sintassi `impl Trait`, come questo:

```rust,ignore
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/no-listing-04-traits-as-parameters/src/lib.rs:here}}
```

Invece di un tipo concreto per il parametro `item`, specifichiamo la parola chiave `impl` e il nome del trait. Questo parametro accetta qualsiasi tipo che implementi il trait specificato. Nel corpo di `notify`, possiamo chiamare qualsiasi metodo su `item` che proviene dal trait `Summary`, come `summarize`. Possiamo chiamare `notify` e passare qualsiasi istanza di `NewsArticle` o `Tweet`. Il codice che chiama la funzione con qualsiasi altro tipo, come una `String` o un `i32`, non compila perché quei tipi non implementano `Summary`.

<!-- Vecchie intestazioni. Non rimuovere altrimenti i link possono rompersi. -->
<a id="fixing-the-largest-function-with-trait-bounds"></a>

#### Sintassi Trait Bound

La sintassi `impl Trait` funziona per casi semplici ma è effettivamente una semplificazione sintattica per una forma più lunga conosciuta come *trait bound*; sembra così:

```rust,ignore
pub fn notify<T: Summary>(item: &T) {
    println!("Breaking news! {}", item.summarize());
}
```

Questa forma più lunga è equivalente all'esempio nella sezione precedente ma è più verbosa. Inseriamo i bound trait con la dichiarazione del parametro di tipo generico dopo un due punti e all'interno di parentesi angolari.

La sintassi `impl Trait` è conveniente e rende il codice più conciso in casi semplici, mentre la sintassi completa dei trait bound può esprimere maggiore complessità in altri casi. Per esempio, possiamo avere due parametri che implementano `Summary`. Farlo con la sintassi `impl Trait` sembra così:

```rust,ignore
pub fn notify(item1: &impl Summary, item2: &impl Summary) {
```

Usare `impl Trait` è appropriato se vogliamo che questa funzione permetta a `item1` e `item2` di avere tipi diversi (purché entrambi i tipi implementino `Summary`). Se vogliamo costringere entrambi i parametri ad avere lo stesso tipo, tuttavia, dobbiamo usare un trait bound, così:

```rust,ignore
pub fn notify<T: Summary>(item1: &T, item2: &T) {
```

Il tipo generico `T` specificato come tipo dei parametri `item1` e `item2` vincola la funzione in modo tale che il tipo concreto del valore passato come argomento per `item1` e `item2` debba essere lo stesso.

#### Specificare Più Trait Bound con la Sintassi `+`

Possiamo anche specificare più di un trait bound. Supponiamo di voler utilizzare la formattazione display oltre a `summarize` su `item`: specifichiamo nella definizione di `notify` che `item` deve implementare sia `Display` che `Summary`. Possiamo farlo usando la sintassi `+`:

```rust,ignore
pub fn notify(item: &(impl Summary + Display)) {
```

La sintassi `+` è valida anche con i trait bound sui tipi generici:

```rust,ignore
pub fn notify<T: Summary + Display>(item: &T) {
```

Con i due trait bound specificati, il corpo di `notify` può chiamare `summarize`
e usare `{}` per formattare `item`.

#### Trait Bound più Chiari con Le Clausole `where`

Utilizzare troppi trait bound ha aspetti negativi. Ogni generico ha i suoi trait bound, quindi le funzioni con più parametri di tipo generico possono contenere molte informazioni sui trait bound tra il nome della funzione e la sua lista di parametri, rendendo difficile la lettura della firma della funzione. Per questo motivo, Rust ha una sintassi alternativa per specificare i trait bound all'interno di una clausola `where` dopo la firma della funzione. Quindi, invece di scrivere questo:

```rust,ignore
fn some_function<T: Display + Clone, U: Clone + Debug>(t: &T, u: &U) -> i32 {
```

possiamo usare una clausola `where`, così:

```rust,ignore
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/no-listing-07-where-clause/src/lib.rs:here}}
```

La firma di questa funzione è meno affollata: il nome della funzione, la lista dei parametri e il tipo di ritorno sono vicini tra loro, simili a una funzione senza numerosi trait bound.

### Restituire Tipi che Implementano Trait

Possiamo anche usare la sintassi `impl Trait` nella posizione di ritorno per restituire un valore di un tipo che implementa un trait, come mostrato qui:

```rust,ignore
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/no-listing-05-returning-impl-trait/src/lib.rs:here}}
```

Usando `impl Summary` come tipo di ritorno, specifichiamo che la funzione
`returns_summarizable` restituisce un tipo che implementa il trait `Summary`
senza nominare il tipo concreto. In questo caso, `returns_summarizable`
restituisce un `Tweet`, ma il codice che chiama questa funzione non ha bisogno di saperlo.

La capacità di specificare un tipo di ritorno solo tramite il trait che implementa è particolarmente utile nel contesto delle closure e degli iteratori, che copriamo nel Capitolo 13. Le closure e gli iteratori creano tipi che solo il compilatore conosce o tipi che sono molto lunghi da specificare. La sintassi `impl Trait` ti permette di specificare concisamente che una funzione restituisce un tipo che implementa il trait `Iterator` senza bisogno di scrivere un tipo molto lungo.

Tuttavia, puoi usare `impl Trait` solo se stai restituendo un singolo tipo. Ad esempio, questo codice che restituisce un `NewsArticle` o un `Tweet` con il tipo di ritorno specificato come `impl Summary` non funzionerebbe:

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/no-listing-06-impl-trait-returns-one-type/src/lib.rs:here}}
```

Restituire sia un `NewsArticle` che un `Tweet` non è consentito a causa delle restrizioni su come la sintassi `impl Trait` è implementata nel compilatore. Copriremo come scrivere una funzione con questo comportamento nella sezione [“Usare Oggetti Trait che Consentono Valori di Diversi Tipi”][using-trait-objects-that-allow-for-values-of-different-types]<!--
ignore --> del Capitolo 17.

### Utilizzare i Trait Bound per Implementare Condizionalmente Met# Definizioni di Metodi


Utilizzando un `trait bound` con un blocco `impl` che usa parametri di tipo generico,
possiamo implementare metodi condizionalmente per tipi che implementano i `trait` specificati.
Ad esempio, il tipo `Pair<T>` in Listing 10-15 implementa sempre la funzione `new` per restituire una nuova istanza di `Pair<T>` (ricorda dalla sezione [“Defining Methods”][methods]<!-- ignore --> del Capitolo 5 che `Self` è un alias di tipo per il tipo del blocco `impl`, che in questo caso è `Pair<T>`). Ma nel prossimo blocco `impl`, `Pair<T>` implementa il metodo `cmp_display` solo se il suo tipo interno `T` implementa il `PartialOrd` trait che abilita il confronto *e* il `Display` trait che abilita la stampa.

<span class="filename">Filename: src/lib.rs</span>

```rust,noplayground
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-15/src/lib.rs}}
```

<span class="caption">Listing 10-15: Implementazione condizionale di metodi su un tipo generico a seconda dei trait bounds</span>

Possiamo anche implementare condizionatamente un trait per qualsiasi tipo che ne implementi un altro. Le implementazioni di un trait su qualsiasi tipo che soddisfi i trait bounds sono chiamate *implementazioni globali* e sono ampiamente utilizzate nella libreria standard di Rust. Ad esempio, la libreria standard implementa il `ToString` trait su qualsiasi tipo che implementi il `Display` trait. Il blocco `impl` nella libreria standard è simile a questo codice:

```rust,ignore
impl<T: Display> ToString for T {
    // --snip--
}
```

Poiché la libreria standard ha questa implementazione globale, possiamo chiamare il metodo `to_string` definito dal `ToString` trait su qualsiasi tipo che implementi il `Display` trait. Ad esempio, possiamo trasformare gli interi nei loro corrispondenti valori `String` in questo modo perché gli interi implementano `Display`:

```rust
let s = 3.to_string();
```

Le implementazioni globali compaiono nella documentazione del trait nella sezione "Implementors".

I trait e i trait bounds ci permettono di scrivere codice che usa parametri di tipo generico per ridurre la duplicazione ma specificare anche al compilatore che vogliamo che il tipo generico abbia un particolare comportamento. Il compilatore può quindi utilizzare le informazioni del trait bound per verificare che tutti i tipi concreti utilizzati con il nostro codice forniscano il comportamento corretto. Nei linguaggi dinamicamente tipizzati, otterremmo un errore a runtime se chiamassimo un metodo su un tipo che non ha definito il metodo. Ma Rust sposta questi errori al tempo di compilazione, quindi siamo costretti a risolvere i problemi prima che il nostro codice possa essere eseguito. Inoltre, non dobbiamo scrivere codice che controlla il comportamento a tempo di esecuzione perché l'abbiamo già verificato a tempo di compilazione. Fare così migliora le prestazioni senza dover rinunciare alla flessibilità dei generici.

[using-trait-objects-that-allow-for-values-of-different-types]: ch17-02-trait-objects.html#using-trait-objects-that-allow-for-values-of-different-types
[methods]: ch05-03-method-syntax.html#defining-methods
