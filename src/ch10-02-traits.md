## Traits: Definizione di Comportamento Condiviso

Un *trait* definisce le funzionalità che un particolare tipo ha e può condividere con altri
tipi. Possiamo usare i trait per definire un comportamento condiviso in modo astratto. Possiamo
usare i *limiti dei trait* per specificare che un tipo generico può essere qualsiasi tipo che ha
un certo comportamento.

> Nota: I Traits sono simili a una caratteristica spesso chiamata *interface* in altri
> linguaggi, sebbene con alcune differenze.

### Definizione di un Trait

Il comportamento di un tipo consiste nei metodi che possiamo chiamare su quel tipo. Diversi
tipi condividono lo stesso comportamento se possiamo chiamare gli stessi metodi su tutti quei
tipi. Le definizioni dei trait sono un modo per raggruppare insieme le firme dei metodi per
definire un insieme di comportamenti necessari per realizzare qualche scopo.

Ad esempio, diciamo che abbiamo molte strutture che contengono vari tipi e
quantità di testo: una struttura `NewsArticle` che contiene una storia di news inviate in una
particolare posizione e un `Tweet` che può contenere al massimo 280 caratteri insieme ai metadati che indicano se era un nuovo tweet, un retweet, o una risposta
a un altro tweet.

Vogliamo creare una libreria crate di aggregazione dei media chiamata `aggregator` che può
visualizzare i riepiloghi dei dati che potrebbero essere memorizzati in un `NewsArticle` o un'istanza di `Tweet`
. Per fare questo, abbiamo bisogno di un riepilogo da ogni tipo, e richiederemo
quel riepilogo chiamando un metodo `summarize` su un'istanza. L'elenco 10-12
mostra la definizione di un trait pubblico `Summary` che esprime questo comportamento.

<span class="filename">Nome del file: src/lib.rs</span>

```rust,noplayground
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-12/src/lib.rs}}
```

<span class="caption">Elenco 10-12: Un trait `Summary` che consiste nel
comportamento fornito da un metodo `summarize` </span>

Qui, dichiariamo un trait usando la parola chiave `trait` e poi il nome del trait,
che è `Summary` in questo caso. Abbiamo anche dichiarato il trait come `pub` in modo che
le crate che dipendono da questa crate possano fare uso di questo trait anche, come vedremo in
pochi esempi. All'interno delle parentesi graffe, dichiariamo le firme dei metodi
che descrivono i comportamenti dei tipi che implementano questo trait, che in
questo caso è `fn summarize(&self) -> String`.

Dopo la firma del metodo, invece di fornire un'implementazione all'interno delle parentesi graffe,
usiamo un punto e virgola. Ogni tipo che implementa questo trait deve fornire
il suo comportamento personalizzato per il corpo del metodo. Il compilatore farà rispettare
che qualsiasi tipo che ha il trait `Summary` avrà il metodo `summarize`
definito con esattamente questa firma.

Un trait può avere più metodi nel suo corpo: le firme dei metodi sono elencate
una per riga e ogni riga termina con un punto e virgola.

### Implementazione di un Trait su un Tipo

Ora che abbiamo definito le firme desiderate dei metodi del trait `Summary`,
possiamo implementarlo sui tipi nel nostro aggregatore di media. L'elenco 10-13 mostra
un'implementazione del trait `Summary` sulla struttura `NewsArticle` che utilizza
il titolo, l'autore e la località per creare il valore di ritorno di
`summarize`. Per la struttura `Tweet`, definiamo `summarize` come il nome utente
seguito dall'intero testo del tweet, supponendo che il contenuto del tweet sia
già limitato a 280 caratteri.

<span class="filename">Nome del file: src/lib.rs</span>

```rust,noplayground
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-13/src/lib.rs:here}}
```

<span class="caption">Elenco 10-13: Implementazione del trait `Summary` su i
tipi `NewsArticle` e `Tweet` </span>

Implementare un trait su un tipo è simile all'implementazione di metodi regolari. La
differenza è che dopo `impl`, mettiamo il nome del trait che vogliamo implementare,
poi usiamo la parola chiave `for`, e poi specifichiamo il nome del tipo per il quale vogliamo
implementare il trait. All'interno del blocco `impl`, mettiamo le firme dei metodi
che la definizione del trait ha definito. Invece di aggiungere un punto e virgola dopo ciascuna
firma, usiamo le parentesi graffe e riempiamo il corpo del metodo con il comportamento specifico
che vogliamo che i metodi del trait abbiano per il tipo particolare.

Ora che la libreria ha implementato il trait `Summary` su `NewsArticle` e
`Tweet`, gli utenti della crate possono chiamare i metodi del trait su istanze di
`NewsArticle` e `Tweet` allo stesso modo in cui chiamiamo metodi regolari. L'unica
differenza è che l'utente deve portare il trait nello scope così come i
tipi. Ecco un esempio di come una crate binaria potrebbe utilizzare la nostra
libreria crate `aggregator`:

```rust,ignore
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/no-listing-01-calling-trait-method/src/main.rs}}
```

Questo codice stampa `1 new tweet: horse_ebooks: of course, as you probably already
know, people`.

Altre crate che dipendono dalla crate `aggregator` possono anche portare il `Summary`
trait nello scope per implementare `Summary` sui propri tipi. Una restrizione da
notare è che possiamo implementare un trait su un tipo solo se almeno uno dei
trait o il tipo è locale alla nostra crate. Ad esempio, possiamo implementare standard
library traits come `Display` su un tipo personalizzato come `Tweet` come parte del nostro
funzionalità della crate `aggregator`, perché il tipo `Tweet` è locale alla nostra
crate `aggregator`. Possiamo anche implementare `Summary` su `Vec<T>` nel nostro
crate `aggregator`, perché il trait `Summary` è locale alla nostra crate `aggregator`.

Ma non possiamo implementare traits esterni su tipi esterni. Ad esempio, non possiamo
implementare il trait `Display` su `Vec<T>` all'interno della nostra crate `aggregator`,
perché `Display` e `Vec<T>` sono entrambi definiti nella libreria standard e
non sono locali alla nostra crate `aggregator`. Questa restrizione fa parte di una proprietà
chiamata *coerenza*, e più specificamente la *orphan rule*, così chiamata perché
il tipo genitore non è presente. Questa regola garantisce che il codice di altre persone
non può rompere il tuo codice e viceversa. Senza la regola, due crate potrebbero
implementare lo stesso trait per lo stesso tipo, e Rust non saprebbe quale
implementazione usare.

### Implementazioni Predefinite

A volte è utile avere un comportamento predefinito per alcuni o tutti i metodi
in un trait invece di richiedere implementazioni per tutti i metodi su ogni tipo.
Quindi, mentre implementiamo il trait su un tipo particolare, possiamo mantenere o sovrascrivere
ogni comportamento predefinito del metodo.

Nell'Elenco 10-14 specifichiamo una stringa predefinita per il metodo `summarize` del
trait `Summary` invece di definire solo la firma del metodo, come abbiamo fatto in
Elenco 10-12.

<span class="filename">Nome del file: src/lib.rs</span>

```rust,noplayground
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-14/src/lib.rs:here}}
```

<span class="caption">Elenco 10-14: Definizione di un trait `Summary` con un default
implementazione del metodo `summarize` </span>

Per utilizzare un'implementazione predefinita per riassumere le istanze di `NewsArticle`, noi
specifichiamo un blocco `impl` vuoto con `impl Summary for NewsArticle {}`.

Anche se non stiamo più definendo il metodo `summarize` su `NewsArticle`
direttamente, abbiamo fornito un'implementazione predefinita e specificato che
`NewsArticle` implementa il trait `Summary`. Di conseguenza, possiamo ancora chiamare
il metodo `summarize` su un'istanza di `NewsArticle`, così:

```rust,ignore
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/no-listing-02-calling-default-impl/src/main.rs:here}}
```

Questo codice stampa `New article available! (Read more...)`.

Creare un'implementazione predefinita non richiede che cambiamo qualcosa riguardo
all'implementazione di `Summary` su `Tweet` in Listing 10-13. Il motivo è che
la sintassi per sovrascrivere un'implementazione predefinita è la stessa della sintassi
per implementare un metodo trait che non ha un'implementazione predefinita.

Le implementazioni predefinite possono chiamare altri metodi nello stesso trait, anche se quei
altri metodi non hanno un'implementazione predefinita. In questo modo, un trait può
fornire molte funzionalità utili e richiedere solo agli implementatori di specificare
una piccola parte di esso. Ad esempio, potremmo definire il trait `Summary` per avere un
metodo `summarize_author` la cui implementazione è richiesta, quindi definire un
metodo `summarize` che ha un'implementazione predefinita che chiama il
metodo `summarize_author`:

```rust,noplayground
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/no-listing-03-default-impl-calls-other-methods/src/lib.rs:here}}
```

Per utilizzare questa versione di `Summary`, abbiamo solo bisogno di definire `summarize_author`
quando implementiamo il trait su un tipo:

```rust,ignore
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/no-listing-03-default-impl-calls-other-methods/src/lib.rs:impl}}
```

Dopo aver definito `summarize_author`, possiamo chiamare `summarize` su istanze del
struct `Tweet`, e l'implementazione predefinita di `summarize` chiamerà il
definizione di `summarize_author` che abbiamo fornito. Poiché abbiamo implementato
`summarize_author`, il trait `Summary` ci ha dato il comportamento del
metodo `summarize` senza obbligarci a scrivere altro codice.

```rust,ignore
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/no-listing-03-default-impl-calls-other-methods/src/main.rs:here}}
```

Questo codice stampa `1 nuovo tweet: (Leggi altro da @horse_ebooks...)`.

Notare che non è possibile chiamare l'implementazione predefinita da un
implementazione di sovrascrittura dello stesso metodo.

### I Traits come Parametri

Ora che sai come definire e implementare i trait, possiamo esplorare come usare
i trait per definire funzioni che accettano molti tipi diversi. Useremo il
trait `Summary` che abbiamo implementato sui tipi `NewsArticle` e `Tweet` in
Listing 10-13 per definire una funzione `notify` che chiama il metodo `summarize`
sul suo parametro `item`, che è di un tipo che implementa il trait `Summary`.
Per fare questo, usiamo la sintassi `impl Trait`, così:

```rust,ignore
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/no-listing-04-traits-as-parameters/src/lib.rs:here}}
```

Invece di un tipo concreto per il parametro `item`, specificiamo la parola chiave `impl`
e il nome del trait. Questo parametro accetta qualsiasi tipo che implementa il
trait specificato. Nel corpo di `notify`, possiamo chiamare qualsiasi metodo su `item`
che proviene dal trait `Summary`, come `summarize`. Possiamo chiamare `notify`
e passare qualsiasi istanza di `NewsArticle` o `Tweet`. Un codice che chiama la
funzione con qualsiasi altro tipo, come una `String` o un `i32`, non sarà compilato
perché quei tipi non implementano `Summary`.

<!-- Vecchie intestazioni. Non rimuovere o i link potrebbero rompersi. -->
<a id="fixing-the-largest-function-with-trait-bounds"></a>

#### Sintassi di Trait Bound

La sintassi `impl Trait` funziona per casi semplici ma è in realtà sintassi
zucchero per una forma più lunga nota come un *trait bound*; sembra così:

```rust,ignore
pub fn notify<T: Summary>(item: &T) {
    println!("Notizie in anteprima! {}", item.summarize());
}
```

Questa forma più lunga è equivalente all'esempio nella sezione precedente ma è
più verboso. Posizioniamo i trait bounds con la dichiarazione del parametro di tipo generico
dopo due punti e all'interno delle parentesi angolari.

La sintassi `impl Trait` è comoda e rende il codice più conciso in casi semplici,
mentre la sintassi completa del trait bound può esprimere più complessità in altri
casi. Ad esempio, possiamo avere due parametri che implementano `Summary`. Fare
come con la sintassi `impl Trait` sembra così:

```rust,ignore
pub fn notify(item1: &impl Summary, item2: &impl Summary) {
```

Utilizzare `impl Trait` è appropriato se vogliamo che questa funzione permetta `item1` e
`item2` di avere tipi diversi (purché entrambi i tipi implementino `Summary`). Se
invece vogliamo forzare entrambi i parametri ad avere lo stesso tipo, dobbiamo usare un
trait bound, così:

```rust,ignore
pub fn notify<T: Summary>(item1: &T, item2: &T) {
```

Il tipo generico `T` specificato come tipo dei parametri `item1` e `item2`
costringe la funzione in modo che il tipo concreto del valore
passato come argomento per `item1` e `item2` debba essere lo stesso.

#### Specificare Più Trait Bounds con la Sintassi `+`

Possiamo anche specificare più di un trait bound. Supponiamo che vogliamo `notify` per l'uso
formattazione del display così come `summarize` su `item`: noi specifichiamo nella definizione di `notify` che `item` deve
implementare sia `Display` che `Summary`. Possiamo farlo usando la sintassi `+`:

```rust,ignore
pub fn notify(item: &(impl Summary + Display)) {
```

La sintassi `+` è anche valida con trait bounds su tipi generici:

```rust,ignore
pub fn notify<T: Summary + Display>(item: &T) {
```

Con i due trait bounds specificati, il corpo di `notify` può chiamare `summarize`
e usare `{}` per formattare `item`.

#### Clearer Trait Bounds con Clausole `where`

Usare troppi limiti dei trait ha i suoi svantaggi. Ogni generico ha i suoi trait
bounds, quindi le funzioni con molti parametri di tipo generico possono contenere un sacco di
informazioni sui trait bound tra il nome della funzione e la sua lista di parametri,
rendendo difficile da leggere la firma della funzione. Per questo motivo, Rust ha alternativa
sintassi per specificare i trait bounds all'interno di una clausola `where` dopo la firma della funzione. Quindi invece di scrivere questo:

```rust,ignore
fn some_function<T: Display + Clone, U: Clone + Debug>(t: &T, u: &U) -> i32 {
```

possiamo usare una clausola `where`, così:

```rust,ignore
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/no-listing-07-where-clause/src/lib.rs:here}}
```

La firma di questa funzione è meno ingombra: il nome della funzione, la lista dei parametri,
e il tipo di ritorno sono vicini, simili a una funzione senza un sacco di trait
bounds.

### Restituire Tipi che Implementano Traits

Possiamo anche usare la sintassi `impl Trait` nella posizione di ritorno per restituire un
valore di un tipo che implementa un trait, come mostrato qui:

```rust,ignore
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/no-listing-05-returning-impl-trait/src/lib.rs:here}}
```

Utilizzando `impl Summary` per il tipo di ritorno, specificiamo che il
la funzione `returns_summarizable` restituisce un tipo che implementa il trait `Summary`
senza nominare il tipo concreto. In questo caso, `returns_summarizable`
restituisce un `Tweet`, ma il codice che chiama questa funzione non ha bisogno di saperlo.

La possibilità di specificare un tipo di ritorno solo dal trait che implementa è
particolarmente utile nel contesto delle closure e degli iteratori, che copriamo in
Capitolo 13. Le closure e gli iteratori creano tipi che solo il compilatore conosce o
tipi che sono molto lunghi da specificare. La sintassi `impl Trait` ti permette di specificare concisamente
che una funzione restituisce un qualche tipo che implementa il trait `Iterator`
senza dover scrivere un tipo molto lungo.

Tuttavia, puoi utilizzare `impl Trait` solo se stai restituendo un singolo tipo. Per
esempio, questo codice che restituisce o un `NewsArticle` o un `Tweet` con il
tipo di ritorno specificato come `impl Summary` non funzionerebbe:

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/no-listing-06-impl-trait-returns-one-type/src/lib.rs:here}}
```

Restituire sia un `NewsArticle` che un `Tweet` non è permesso a causa delle restrizioni
intorno a come la sintassi `impl Trait` è implementata nel compilatore. Tratteremo
come scrivere una funzione con questo comportamento nella sezione ["Utilizzo degli oggetti Trait che
Permettono valori di diversi
tipi"][using-trait-objects-that-allow-for-values-of-different-types]<!--
ignore --> del Capitolo 17.

### Usare i limiti dei Trait per implementare condizionatamente i metodi

Utilizzando un limite di trait con un blocco `impl` che usa parametri di tipo generico,
possiamo implementare metodi condizionatamente per i tipi che implementano i trait
specificati. Ad esempio, il tipo `Pair<T>` nel Listato 10-15 implementa sempre la
funzione `new` per restituire una nuova istanza di `Pair<T>` (ricorda dalla
sezione ["Definizione dei metodi"][metodi]<!-- ignore --> del Capitolo 5 che `Self`
è un alias di tipo per il tipo del blocco `impl`, che in questo caso è
`Pair<T>`). Ma nel prossimo blocco `impl`, `Pair<T>` implementa solo il
metodo `cmp_display` se il suo tipo interno `T` implementa il trait `PartialOrd`
che abilita il confronto *e* il trait `Display` che abilita la stampa.

<span class="filename">Nome del file: src/lib.rs</span>

```rust,noplayground
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-15/src/lib.rs}}
```

<span class="caption">Listato 10-15: Implementazione condizionata dei metodi su un
tipo generico in base ai limiti dei trait</span>

Possiamo anche implementare condizionatamente un trait per qualsiasi tipo che implementa
un altro trait. Le implementazioni di un trait su qualsiasi tipo che soddisfa i limiti del trait
sono chiamate *implementazioni generali* e sono ampiamente utilizzate nella
libreria standard di Rust. Ad esempio, la libreria standard implementa il
trait `ToString` su qualsiasi tipo che implementa il trait `Display`. Il blocco `impl`
nella libreria standard assomiglia a questo codice:

```rust,ignore
impl<T: Display> ToString for T {
    // --snip--
}
```

Poiché la libreria standard ha questa implementazione generale, possiamo chiamare il
metodo `to_string` definito dal trait `ToString` su qualsiasi tipo che implementa
il trait `Display`. Ad esempio, possiamo trasformare gli interi nei loro corrispondenti
valori `String` in questo modo perché gli interi implementano `Display`:

```rust
let s = 3.to_string();
```

Le implementazioni generiche appaiono nella documentazione del trait nella
sezione "Implementatori".

I trait e i limiti dei trait ci permettono di scrivere codice che utilizza parametri di tipo generico per
ridurre la duplicazione ma anche specificare al compilatore che vogliamo che il tipo generico abbia un comportamento particolare. Il compilatore può quindi utilizzare le informazioni del limite del trait
per controllare che tutti i tipi concreti utilizzati con il nostro codice forniscono il
comportamento corretto. Nei linguaggi tipizzati dinamicamente, riceveremmo un errore al
runtime se chiamassimo un metodo su un tipo che non definisce il metodo. Ma Rust
sposta questi errori al tempo di compilazione in modo da costringerci a risolvere i problemi prima
che il nostro codice sia persino in grado di funzionare. Inoltre, non dobbiamo scrivere codice che
controlla il comportamento a runtime perché l'abbiamo già controllato al tempo di compilazione.
Così si migliora le prestazioni senza dover rinunciare alla flessibilità dei
generici.

[using-trait-objects-that-allow-for-values-of-different-types]: ch17-02-trait-objects.html#utilizzo-di-oggetti-trait-che-permettono-valori-di-diversi-tipi
[metodi]: ch05-03-method-syntax.html#definizione-dei-metodi



