## Definire un Enum

Dove le struct ti offrono un modo per raggruppare campi e dati correlati, come un `Rettangolo` con la sua `larghezza` e `altezza`, gli enum ti danno un modo di dire che un valore è uno di un possibile insieme di valori. Ad esempio, potremmo voler dire che `Rettangolo` è una di una serie di forme possibili che include anche `Cerchio` e `Triangolo`. Per fare questo, Rust ci permette di codificare queste possibilità come un enum.

Vediamo una situazione che potremmo voler esprimere nel codice e capire perché gli enum sono utili e più appropriati delle struct in questo caso. Supponiamo di dover lavorare con indirizzi IP. Al momento, due standard principali sono utilizzati per gli indirizzi IP: versione quattro e versione sei. Poiché queste sono le uniche possibilità che il nostro programma incontrerà per un indirizzo IP, possiamo *enumerare* tutte le varianti possibili, che è da dove deriva il nome di enumerazione.

Qualsiasi indirizzo IP può essere sia un indirizzo di versione quattro che un indirizzo di versione sei, ma non entrambi contemporaneamente. Questa proprietà degli indirizzi IP rende appropriata la struttura dati enum poiché un valore enum può essere solo una delle sue varianti. Sia gli indirizzi di versione quattro che quelli di versione sei sono comunque fondamentalmente indirizzi IP, quindi dovrebbero essere trattati come lo stesso tipo quando il codice gestisce situazioni che si applicano a qualsiasi tipo di indirizzo IP.

Possiamo esprimere questo concetto nel codice definendo un'enumerazione `IpAddrKind` e elencando i tipi possibili di un indirizzo IP, `V4` e `V6`. Queste sono le varianti dell'enum:

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-01-defining-enums/src/main.rs:def}}
```

`IpAddrKind` è ora un tipo di dati personalizzato che possiamo usare altrove nel nostro codice.

### Valori Enum

Possiamo creare istanze di ciascuna delle due varianti di `IpAddrKind` in questo modo:

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-01-defining-enums/src/main.rs:instance}}
```

Nota che le varianti dell'enum sono spazialmente nominate sotto il suo identificatore e usiamo un doppio due punti per separare i due. Questo è utile perché ora entrambi i valori `IpAddrKind::V4` e `IpAddrKind::V6` sono dello stesso tipo: `IpAddrKind`. Possiamo quindi, ad esempio, definire una funzione che accetta qualsiasi `IpAddrKind`:

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-01-defining-enums/src/main.rs:fn}}
```

E possiamo chiamare questa funzione con entrambe le varianti:

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-01-defining-enums/src/main.rs:fn_call}}
```

Usare gli enum ha ancora più vantaggi. Pensando al nostro tipo di indirizzo IP, al momento non abbiamo modo di memorizzare i dati dell'effettivo indirizzo IP; sappiamo solo che *tipo* è. Poiché hai appena appreso delle struct nel Capitolo 5, potresti essere tentato di affrontare questo problema con le struct come mostrato nel Listing 6-1.

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/listing-06-01/src/main.rs:here}}
```

<span class="caption">Listing 6-1: Memorizzare i dati e la variante `IpAddrKind` di un indirizzo IP usando una `struct`</span>

Qui, abbiamo definito una struct `IpAddr` che ha due campi: un campo `kind` che è di tipo `IpAddrKind` (l'enum che abbiamo definito in precedenza) e un campo `address` di tipo `String`. Abbiamo due istanze di questa struct. La prima è `home`, e ha il valore `IpAddrKind::V4` come suo `kind` con dati di indirizzo associati `127.0.0.1`. La seconda istanza è `loopback`. Ha l'altra variante di `IpAddrKind` come valore del suo `kind`, `V6`, e ha l'indirizzo `::1` associato. Abbiamo usato una struct per raggruppare insieme i valori `kind` e `address`, quindi ora la variante è associata al valore.

Tuttavia, rappresentare lo stesso concetto usando solo un enum è più conciso: piuttosto che un enum all'interno di una struct, possiamo mettere i dati direttamente in ciascuna variante dell'enum. Questa nuova definizione dell'enum `IpAddr` dice che entrambi i varianti `V4` e `V6` avranno valori `String` associati:

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-02-enum-with-data/src/main.rs:here}}
```

Colleghiamo i dati direttamente a ciascuna variante dell'enum, quindi non c'è bisogno di una struct aggiuntiva. Qui, è anche più facile vedere un altro dettaglio di come funzionano gli enum: il nome di ciascuna variante di enum che definiamo diventa anche una funzione che costruisce un'istanza dell'enum. Cioè, `IpAddr::V4()` è una chiamata di funzione che prende un argomento `String` e restituisce un'istanza del tipo `IpAddr`. Otteniamo automaticamente questa funzione costruttore come risultato della definizione dell'enum.

C'è un altro vantaggio nell'usare un enum piuttosto che una struct: ogni variante può avere tipi e quantità di dati associati diversi. Gli indirizzi IP di versione quattro avranno sempre quattro componenti numeriche che avranno valori compresi tra 0 e 255. Se volessimo memorizzare gli indirizzi `V4` come quattro valori `u8` ma esprimere comunque gli indirizzi `V6` come un unico valore `String`, non potremmo farlo con una struct. Gli enum gestiscono facilmente questo caso:

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-03-variants-with-different-data/src/main.rs:here}}
```

Abbiamo mostrato diversi modi per definire strutture dati per memorizzare indirizzi IP di versione quattro e di versione sei. Tuttavia, come si scopre, voler memorizzare indirizzi IP e codificare di che tipo sono è così comune che [la libreria standard ha una definizione che possiamo usare!][IpAddr]<!-- ignore --> Vediamo come la libreria standard definisce `IpAddr`: ha l'esatto enum e le varianti che abbiamo definito e usato, ma inserisce i dati dell'indirizzo all'interno delle varianti sotto forma di due struct diverse, che sono definite diversamente per ciascuna variante:

```rust
struct Ipv4Addr {
    // --snip--
}

struct Ipv6Addr {
    // --snip--
}

enum IpAddr {
    V4(Ipv4Addr),
    V6(Ipv6Addr),
}
```

Questo codice illustra che puoi mettere qualsiasi tipo di dati all'interno di una variante di enum: stringhe, tipi numerici o struct, per esempio. Puoi anche includere un altro enum! Inoltre, i tipi della libreria standard spesso non sono molto più complicati di quanto potresti inventare.

Nota che anche se la libreria standard contiene una definizione per `IpAddr`, possiamo ancora creare e usare la nostra definizione senza conflitti poiché non abbiamo portato la definizione della libreria standard nel nostro ambito. Parleremo di più su come portare i tipi in ambito nel Capitolo 7.

Vediamo un altro esempio di un enum nel Listing 6-2: questo ha una vasta gamma di tipi incorporati nelle sue varianti.

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/listing-06-02/src/main.rs:here}}
```

<span class="caption">Listing 6-2: Un enum `Message` le cui varianti ciascuna memorizza quantità e tipi di valori diversi</span>

Questo enum ha quattro varianti con tipi diversi:

* `Quit` non ha dati associati.
* `Move` ha campi denominati, come fa una struct.
* `Write` include un singolo `String`.
* `ChangeColor` include tre valori `i32`.

Definire un enum con varianti come quelle nel Listing 6-2 è simile a definire diversi tipi di definizioni di struct, tranne che l'enum non usa la parola chiave `struct` e tutte le varianti sono raggruppate insieme sotto il tipo `Message`. Le seguenti struct potrebbero contenere gli stessi dati che contengono le varianti di enum precedenti:

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-04-structs-similar-to-message-enum/src/main.rs:here}}
```

Ma se usassimo le diverse struct, ciascuna delle quali ha il proprio tipo, non potremmo definire facilmente una funzione per accettare uno qualsiasi di questi tipi di messaggi come potremmo fare con l'enum `Message` definito nel Listing 6-2, che è un tipo unico.

C'è un'altra somiglianza tra enum e struct: proprio come possiamo definire metodi sulle struct usando `impl`, possiamo anche definire metodi sugli enum. Ecco un metodo chiamato `call` che potremmo definire sul nostro enum `Message`:

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-05-methods-on-enums/src/main.rs:here}}
```

Il corpo del metodo userebbe `self` per ottenere il valore su cui abbiamo chiamato il metodo. In questo esempio, abbiamo creato una variabile `m` che ha il valore `Message::Write(String::from("hello"))`, e questo è ciò che `self` sarà nel corpo del metodo `call` quando `m.call()` viene eseguito.

Vediamo un altro enum nella libreria standard che è molto comune e utile: `Option`.

### L'Enum `Option` e i Suoi Vantaggi Rispetto ai Valori Nulli

Questa sezione esplora uno studio di caso di `Option`, un altro enum definito dalla libreria standard. Il tipo `Option` codifica lo scenario molto comune in cui un valore potrebbe essere qualcosa o potrebbe essere nulla.

Ad esempio, se richiedi il primo elemento in una lista non vuota, otterrai un valore. Se richiedi il primo elemento in una lista vuota, non otterrai nulla. Esprimere questo concetto in termini di sistema di tipi significa che il compilatore può verificare se hai gestito tutti i casi che dovresti gestire; questa funzionalità può prevenire bug che sono estremamente comuni in altri linguaggi di programmazione.

Il design del linguaggio di programmazione viene spesso considerato in termini delle funzionalità che includi, ma le funzionalità che escludi sono ugualmente importanti. Rust non ha la funzionalità null che molti altri linguaggi hanno. *Null* è un valore che significa che non esiste un valore lì. Nei linguaggi con null, le variabili possono sempre essere in uno dei due stati: null o non-null.

Nella sua presentazione del 2009 "Null References: The Billion Dollar Mistake", Tony Hoare, l'inventore di null, ha detto questo:

> La chiamo il mio errore da miliardi di dollari. A quel tempo, stavo progettando il primo
> sistema di tipi completo per i riferimenti in un linguaggio orientato agli oggetti. Il mio
> obiettivo era assicurarmi che tutto l'uso dei riferimenti fosse assolutamente sicuro,
> con controlli eseguiti automaticamente dal compilatore. Ma non potevo resistere
> alla tentazione di inserire un riferimento null, semplicemente perché era così facile da
> implementare. Questo ha portato a innumerevoli errori, vulnerabilità e crash di sistema,
> che probabilmente hanno causato miliardi di dollari di dolore e danni negli ultimi
> quarant'anni.

Il problema con i valori nulli è che se provi a usare un valore nullo come se fosse un valore non nullo, otterrai un errore di qualche tipo. Poiché questa proprietà di null o non-null è pervasiva, è estremamente facile commettere questo tipo di errore.

Tuttavia, il concetto che null cerca di esprimere è ancora utile: un null è un valore che è attualmente non valido o assente per qualche motivo.

Il problema non è davvero con il concetto, ma con l'implementazione particolare. Di conseguenza, Rust non ha null, ma ha un enum che può codificare il concetto di un valore presente o assente. Questo enum è `Option<T>`, ed è [definito dalla libreria standard][option]<!-- ignore --> come segue:

```rust
enum Option<T> {
    None,
    Some(T),
}
```

L'enum `Option<T>` è così utile che è persino incluso nel prelude; non è necessario portarlo in ambito esplicitamente. Le sue varianti sono anche incluse nel prelude: puoi usare `Some` e `None` direttamente senza il prefisso `Option::`. L'enum `Option<T>` è comunque solo un enum regolare, e `Some(T)` e `None` sono ancora varianti del tipo `Option<T>`.

La sintassi `<T>` è una funzione di Rust di cui non abbiamo ancora parlato. È un parametro di tipo generico, e ne parleremo più in dettaglio nel Capitolo 10. Per ora, tutto ciò che devi sapere è che `<T>` significa che la variante `Some` dell'enum `Option` può contenere un dato pezzo di dato di qualsiasi tipo, e che ogni tipo concreto che viene usato al posto di `T` rende il tipo complessivo `Option<T>` un tipo diverso. Ecco alcuni esempi di utilizzo dei valori `Option` per contenere tipi numerici e tipi di stringa:

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-06-option-examples/src/main.rs:here}}
```

Il tipo di `some_number` è `Option<i32>`. Il tipo di `some_char` è `Option<char>`, che è un tipo diverso. Rust può inferire questi tipi perché abbiamo specificato un valore all'interno della variante `Some`. Per `absent_number`, Rust richiede di annotare il tipo complessivo `Option`: il compilatore non può inferire il tipo che la variante `Some` corrispondente conterrà guardando solo un valore `None`. Qui, diciamo a Rust che intendiamo che `absent_number` sia di tipo `Option<i32>`.

Quando abbiamo un valore `Some`, sappiamo che un valore è presente e che il valore è contenuto all'interno del `Some`. Quando abbiamo un valore `None`, in un certo senso significa la stessa cosa di null: non abbiamo un valore valido. Quindi perché avere `Option<T>` è migliore di avere null?

In breve, poiché `Option<T>` e `T` (dove `T` può essere qualsiasi tipo) sono tipi diversi, il compilatore non ci permetterà di usare un valore `Option<T>` come se fosse sicuramente un valore valido. Ad esempio, questo codice non compila, perché sta cercando di aggiungere un `i8` a un `Option<i8>`:

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-07-cant-use-option-directly/src/main.rs:here}}
```

Se eseguiamo questo codice, otteniamo un messaggio di errore come questo:

```console
{{#include ../listings/ch06-enums-and-pattern-matching/no-listing-07-cant-use-option-directly/output.txt}}
```

Intenso! In effetti, questo messaggio di errore significa che Rust non sa come aggiungere un `i8` e un `Option<i8>`, perché sono tipi diversi. Quando abbiamo un valore di un tipo come `i8` in Rust, il compilatore si assicurerà che abbiamo sempre un valore valido. Possiamo proseguire con fiducia senza dover controllare il null prima di usare quel valore. Solo quando abbiamo un `Option<i8>` (o qualsiasi altro tipo di valore con cui stiamo lavorando) dobbiamo preoccuparci di non avere un valore, e il compilatore si assicurerà che gestiamo quel caso prima di usare il valore.

In altre parole, devi convertire un `Option<T>` in un `T` prima di poter eseguire operazioni sul `T`. In generale, questo aiuta a catturare uno dei problemi più comuni con il null: supporre che qualcosa non sia null quando invece lo è.

Eliminare il rischio di supporre erroneamente un valore non nullo ti aiuta a essere più sicuro del tuo codice. Per avere un valore che potrebbe essere null, devi esplicitamente optare per quella possibilità rendendo il tipo di quel valore `Option<T>`. Poi, quando usi quel valore, sei tenuto a gestire esplicitamente il caso in cui il valore è null. Ovunque un valore abbia un tipo che non è un `Option<T>`, puoi tranquillamente supporre che il valore non sia null. Questa è stata una decisione di design deliberata per Rust al fine di limitare la pervasività del null e aumentare la sicurezza del codice Rust.

Quindi, come ottieni il valore `T` da una variante `Some` quando hai un valore di tipo `Option<T>` in modo da poter usare quel valore? L'enum `Option<T>` ha un gran numero di metodi utili in una varietà di situazioni; puoi controllarli nella [sua documentazione][docs]<!-- ignore -->. Familiarizzare con i metodi su `Option<T>` sarà estremamente utile nel tuo percorso con Rust.
In generale, per utilizzare un valore `Option<T>`, si desidera avere del codice che gestisca ogni variante. Si desidera del codice che verrà eseguito solo quando si ha un valore `Some(T)`, e questo codice è autorizzato a utilizzare l'interno `T`. Si desidera un altro codice che verrà eseguito solo se si ha un valore `None`, e tale codice non ha un valore `T` disponibile. L'espressione `match` è una struttura di controllo del flusso che fa proprio questo quando utilizzata con gli enum: eseguirà codice diverso a seconda della variante dell'enum che ha, e quel codice può utilizzare i dati all'interno del valore corrispondente.

[IpAddr]: ../std/net/enum.IpAddr.html
[option]: ../std/option/enum.Option.html
[docs]: ../std/option/enum.Option.html
