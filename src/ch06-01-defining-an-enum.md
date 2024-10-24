## Definire un Enum

Mentre gli structs ti offrono un modo per raggruppare campi e dati correlati, come un `Rectangle` con la sua `width` e `height`, gli enum ti offrono un modo per dire che un valore è uno di un possibile set di valori. Ad esempio, potremmo voler dire che `Rectangle` è una delle forme possibili che include anche `Circle` e `Triangle`. Per fare ciò, Rust ci permette di codificare queste possibilità come un enum.

Vediamo una situazione che potremmo voler esprimere nel codice e capire perché gli enum sono utili e più appropriati degli structs in questo caso. Supponiamo di dover lavorare con indirizzi IP. Attualmente, due standard principali sono utilizzati per gli indirizzi IP: versione quattro e versione sei. Poiché queste sono le uniche possibilità per un indirizzo IP che il nostro programma incontrerà, possiamo *enumerare* tutte le varianti possibili, da cui il nome enumeration.

Qualsiasi indirizzo IP può essere o un indirizzo di versione quattro o di versione sei, ma non entrambi allo stesso tempo. Questa proprietà degli indirizzi IP rende la struttura dati enum appropriata perché un valore enum può essere solo una delle sue varianti. Entrambi gli indirizzi di versione quattro e quelli di versione sei sono ancora fondamentalmente indirizzi IP, quindi dovrebbero essere trattati come lo stesso tipo quando il codice gestisce situazioni applicabili a qualsiasi tipo di indirizzo IP.

Possiamo esprimere questo concetto nel codice definendo un'enumerazione `IpAddrKind` ed elencando i possibili tipi che un indirizzo IP può assumere, `V4` e `V6`. Queste sono le varianti dell'enum:

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-01-defining-enums/src/main.rs:def}}
```

`IpAddrKind` è ora un tipo di dato personalizzato che possiamo utilizzare altrove nel nostro codice.

### Valori Enum

Possiamo creare istanze di ciascuna delle due varianti di `IpAddrKind` in questo modo:

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-01-defining-enums/src/main.rs:instance}}
```

Nota che le varianti dell'enum sono nello stesso namespace del suo identificatore, e usiamo un doppio due punti per separarli. Questo è utile perché ora entrambi i valori `IpAddrKind::V4` e `IpAddrKind::V6` sono dello stesso tipo: `IpAddrKind`. Possiamo quindi, per esempio, definire una funzione che accetta qualsiasi `IpAddrKind`:

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-01-defining-enums/src/main.rs:fn}}
```

E possiamo chiamare questa funzione con entrambe le varianti:

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-01-defining-enums/src/main.rs:fn_call}}
```

Utilizzare gli enum ha ulteriori vantaggi. Pensando di più al nostro tipo di indirizzo IP, al momento non abbiamo un modo per memorizzare i dati effettivi dell'indirizzo IP; sappiamo solo di che *tipo* si tratta. Dato che hai appena imparato gli structs nel Capitolo 5, potresti essere tentato di affrontare questo problema con gli structs come mostrato in Listing 6-1.

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/listing-06-01/src/main.rs:here}}
```

<span class="caption">Listing 6-1: Memorizzare i dati e la variante `IpAddrKind` di un indirizzo IP utilizzando uno `struct`</span>

Qui, abbiamo definito uno struct `IpAddr` che ha due campi: un campo `kind` che è del tipo `IpAddrKind` (l'enum che abbiamo definito in precedenza) e un campo `address` di tipo `String`. Abbiamo due istanze di questo struct. La prima è `home`, e ha il valore `IpAddrKind::V4` come suo `kind` con dati dell'indirizzo associati di `127.0.0.1`. La seconda istanza è `loopback`. Ha l'altra variante di `IpAddrKind` come suo valore `kind`, `V6`, e ha l'indirizzo `::1` associato. Abbiamo usato uno struct per raggruppare i valori `kind` e `address` insieme, quindi ora la variante è associata al valore.

Tuttavia, rappresentare lo stesso concetto usando solo un enum è più conciso: piuttosto che un enum dentro uno struct, possiamo inserire i dati direttamente in ciascuna variante dell'enum. Questa nuova definizione dell'enum `IpAddr` dice che entrambe le varianti `V4` e `V6` avranno valori `String` associati:

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-02-enum-with-data/src/main.rs:here}}
```

Associare i dati a ciascuna variante dell'enum direttamente, quindi non c'è bisogno di uno struct extra. Qui, è anche più facile vedere un altro dettaglio di come funzionano gli enum: il nome di ciascuna variante dell'enum che definiamo diventa anche una funzione che costruisce un'istanza dell'enum. Cioè, `IpAddr::V4()` è una chiamata di funzione che accetta un argomento `String` e restituisce un'istanza del tipo `IpAddr`. Otteniamo automaticamente questa funzione costruttrice come risultato della definizione dell'enum.

C'è un altro vantaggio nell'usare un enum piuttosto che uno struct: ogni variante può avere tipi e quantità di dati associati diversi. Gli indirizzi IP di versione quattro avranno sempre quattro componenti numerici che avranno valori tra 0 e 255. Se volessimo memorizzare gli indirizzi `V4` come quattro valori `u8` ma esprimere comunque gli indirizzi `V6` come un valore `String`, non potremmo farlo con uno struct. Gli enum gestiscono questo caso con facilità:

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-03-variants-with-different-data/src/main.rs:here}}
```

Abbiamo mostrato diversi modi per definire strutture dati per memorizzare indirizzi IP di versione quattro e sei. Tuttavia, come si scopre, voler memorizzare indirizzi IP e codificare di quale tipo si tratta è così comune che [la libreria standard ha una definizione che possiamo usare!][IpAddr]<!-- ignore --> Vediamo come la libreria standard definisce `IpAddr`: ha l'esatto enum e le varianti che abbiamo definito e utilizzato, ma incorpora i dati dell'indirizzo all'interno delle varianti sotto forma di due struct diversi, che sono definiti diversamente per ciascuna variante:

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

Questo codice illustra che puoi inserire qualsiasi tipo di dato all'interno di una variante di un enum: stringhe, tipi numerici o struct, per esempio. Puoi anche includere un altro enum! Inoltre, i tipi della libreria standard spesso non sono molto più complicati di ciò che potresti inventare tu stesso.

Nota che anche se la libreria standard contiene una definizione per `IpAddr`, possiamo comunque creare e usare la nostra definizione senza conflitto perché non abbiamo portato la definizione della libreria standard nel nostro Scope. Parleremo di più su come portare i tipi nello Scope nel Capitolo 7.

Guardiamo un altro esempio di un enum in Listing 6-2: questo ha una varietà di tipi incorporati nelle sue varianti.

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/listing-06-02/src/main.rs:here}}
```

<span class="caption">Listing 6-2: Un enum `Message` le cui varianti memorizzano ciascuna quantità e tipi di valori differenti</span>

Questo enum ha quattro varianti con tipi diversi:

* `Quit` non ha dati associati.
* `Move` ha campi con nome, come uno struct.
* `Write` include un singolo `String`.
* `ChangeColor` include tre valori `i32`.

Definire un enum con varianti come quelle in Listing 6-2 è simile a definire diversi tipi di definizioni struct, tranne che l'enum non usa la parola chiave `struct` e tutte le varianti sono raggruppate insieme sotto il tipo `Message`. I seguenti struct potrebbero contenere gli stessi dati che contengono le precedenti varianti dell'enum:

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-04-structs-similar-to-message-enum/src/main.rs:here}}
```

Ma se utilizzassimo gli struct diversi, ognuno dei quali ha il proprio tipo, non potremmo definire una funzione che accetti facilmente uno di questi tipi di messaggi come potremmo con l'enum `Message` definito in Listing 6-2, che è un unico tipo.

C'è un'altra somiglianza tra enum e structs: proprio come possiamo definire metodi sugli structs usando `impl`, siamo anche in grado di definire metodi sugli enum. Ecco un metodo chiamato `call` che potremmo definire sul nostro enum `Message`:

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-05-methods-on-enums/src/main.rs:here}}
```

Il Blocco del metodo userebbe `self` per ottenere il valore su cui abbiamo chiamato il metodo. In questo esempio, abbiamo creato una variabile `m` che ha il valore `Message::Write(String::from("hello"))`, e questo è ciò che `self` sarà nel Blocco del metodo `call` quando `m.call()` viene eseguito.

Guardiamo un altro enum nella libreria standard che è molto comune e utile: `Option`.

### L'Enum `Option` e i Suoi Vantaggi Rispetto ai Valori Nulli

Questa sezione esplora un caso di studio di `Option`, che è un altro enum definito dalla libreria standard. Il tipo `Option` codifica lo scenario molto comune in cui un valore potrebbe essere presente o assente.

Ad esempio, se richiedi il primo elemento in una lista non vuota, otterrai un valore. Se richiedi il primo elemento in una lista vuota, non otterrai nulla. Esprimere questo concetto in termini di sistema di tipi significa che il compilatore può verificare se hai gestito tutti i casi che dovresti gestire; questa funzionalità può prevenire bug che sono estremamente comuni in altri linguaggi di programmazione.

Il design di un linguaggio di programmazione è spesso considerato in termini di quali funzionalità includi, ma anche le funzionalità che escludi sono importanti. Rust non ha la funzionalità null che molti altri linguaggi hanno. *Null* è un valore che significa che non c'è valore lì. Nei linguaggi con null, le variabili possono sempre essere in uno dei due stati: null o non-null.

Nella sua presentazione del 2009 "Null References: The Billion Dollar Mistake", Tony Hoare, l'inventore di null, ha detto:

> Lo chiamo il mio errore da un miliardo di dollari. A quel tempo, stavo progettando il primo sistema di tipi completo per riferimenti in un linguaggio orientato agli oggetti. Il mio obiettivo era garantire che tutti gli usi dei riferimenti fossero assolutamente sicuri, con controlli eseguiti automaticamente dal compilatore. Ma non potevo resistere alla tentazione di inserire un riferimento nullo, semplicemente perché era così facile da implementare. Questo ha portato a innumerevoli errori, vulnerabilità e crash di sistema, che probabilmente hanno causato un miliardo di dollari di sofferenza e danni negli ultimi quarant'anni.

Il problema con i valori nulli è che se provi a usare un valore nullo come un valore non-nullo, otterrai un errore di qualche tipo. Poiché questa proprietà di null o non-null è pervasiva, è estremamente facile commettere questo tipo di errore.

Tuttavia, il concetto che null sta cercando di esprimere è ancora utile: un null è un valore che è attualmente non valido o assente per qualche motivo.

Il problema non è davvero con il concetto ma con l'implementazione particolare. Pertanto, Rust non ha null, ma ha un enum che può codificare il concetto di un valore che è presente o assente. Questo enum è `Option<T>`, ed è [definito dalla libreria standard][option]<!-- ignore --> come segue:

```rust
enum Option<T> {
    None,
    Some(T),
}
```

L'enum `Option<T>` è così utile che è addirittura incluso nel prelude; non è necessario portarlo nel Scope esplicitamente. Anche le sue varianti sono incluse nel prelude: puoi usare `Some` e `None` direttamente senza il prefisso `Option::`. L'enum `Option<T>` è comunque solo un enum regolare, e `Some(T)` e `None` sono ancora varianti del tipo `Option<T>`.

La sintassi `<T>` è una caratteristica di Rust di cui non abbiamo ancora parlato. È un parametro di tipo generico, e copriremo i generici in dettaglio nel Capitolo 10. Per ora, tutto ciò che devi sapere è che `<T>` significa che la variante `Some` dell'enum `Option` può contenere un pezzo di dati di qualsiasi tipo, e che ogni tipo concreto che viene usato al posto di `T` rende il tipo complessivo `Option<T>` un tipo diverso. Qui ci sono alcuni esempi di utilizzo dei valori `Option` per contenere tipi di numeri e tipi di stringhe:

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-06-option-examples/src/main.rs:here}}
```

Il tipo di `some_number` è `Option<i32>`. Il tipo di `some_char` è `Option<char>`, che è un tipo diverso. Rust può dedurre questi tipi perché abbiamo specificato un valore all'interno della variante `Some`. Per `absent_number`, Rust ci richiede di annotare il tipo complessivo `Option`: il compilatore non può dedurre il tipo che la corrispondente variante `Some` conterrà guardando solo un valore `None`. Qui, diciamo a Rust che intendiamo che `absent_number` sia di tipo `Option<i32>`.

Quando abbiamo un valore `Some`, sappiamo che un valore è presente e il valore è contenuto all'interno del `Some`. Quando abbiamo un valore `None`, in qualche senso significa la stessa cosa di null: non abbiamo un valore valido. Allora perché avere `Option<T>` è meglio che avere null?

In breve, perché `Option<T>` e `T` (dove `T` può essere qualsiasi tipo) sono tipi diversi, il compilatore non ci permetterà di usare un valore `Option<T>` come se fosse sicuramente un valore valido. Ad esempio, questo codice non compilerà, perché sta cercando di aggiungere un `i8` a un `Option<i8>`:

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-07-cant-use-option-directly/src/main.rs:here}}
```

Se eseguiamo questo codice, otteniamo un messaggio di errore come questo:

```console
{{#include ../listings/ch06-enums-and-pattern-matching/no-listing-07-cant-use-option-directly/output.txt}}
```

Intenso! In effetti, questo messaggio di errore significa che Rust non capisce come aggiungere un `i8` e un `Option<i8>`, perché sono tipi diversi. Quando abbiamo un valore di un tipo come `i8` in Rust, il compilatore si assicurerà che abbiamo sempre un valore valido. Possiamo procedere con fiducia senza dover controllare null prima di usare quel valore. Solo quando abbiamo un `Option<i8>` (o qualsiasi tipo di valore con cui stiamo lavorando) dobbiamo preoccuparci di non avere un valore, e il compilatore si assicurerà che gestiamo quel caso prima di usare il valore.

In altre parole, devi convertire un `Option<T>` in un `T` prima di poter eseguire operazioni su di esso. In genere, questo aiuta a catturare uno dei problemi più comuni con null: assumere che qualcosa non sia nullo quando in realtà lo è.

Eliminare il rischio di presumere erroneamente un valore non nullo ti aiuta ad essere più sicuro nel tuo codice. Per avere un valore che può eventualmente essere nullo, devi optare esplicitamente creando il tipo di quel valore `Option<T>`. Quindi, quando usi quel valore, sei tenuto a gestire esplicitamente il caso in cui il valore è nullo. Ovunque un valore abbia un tipo che non è un `Option<T>`, puoi assumere in sicurezza che il valore non sia nullo. Questa è stata una decisione di design deliberata per Rust per limitare la pervasività di null e aumentare la sicurezza del codice Rust.

Allora come si ottiene il valore `T` da una variante `Some` quando si dispone di un valore di tipo `Option<T>` in modo da poter utilizzare quel valore? L'enum `Option<T>` ha un gran numero di metodi utili in una varietà di situazioni; puoi controllarli nella [sua documentazione][docs]<!-- ignore -->. Familiarizzare con i metodi su `Option<T>` sarà estremamente utile nel tuo viaggio con Rust.
In generale, per utilizzare un valore `Option<T>`, vuoi avere del codice che gestisca ciascuna variante. Vuoi del codice che venga eseguito solo quando hai un valore `Some(T)`, e questo codice è autorizzato a usare l'interno `T`. Vuoi un altro codice che venga eseguito solo se hai un valore `None`, e quel codice non ha un valore `T` disponibile. L'espressione `match` è una costruzione di controllo del flusso che fa proprio questo quando viene usata con gli enum: eseguirà codice diverso a seconda di quale variante dell'enum ha, e quel codice può utilizzare i dati all'interno del valore corrispondente.

[IpAddr]: ../std/net/enum.IpAddr.html
[option]: ../std/option/enum.Option.html
[docs]: ../std/option/enum.Option.html
