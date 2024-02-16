## Definire un Enum

Laddove le Struct ti permettono di raggruppare campi e dati correlati, come 
un `Rectangle` con la sua `width` e `height`, gli enum ti permettono di dire che 
un valore è uno di un insieme possibile di valori. Ad esempio, potremmo voler dire che 
`Rectangle` è uno di un insieme di possibili forme che include anche `Circle` e
`Triangle`. Per fare questo, Rust ci permette di codificare queste possibilità come un enum.

Diamo un'occhiata a una situazione che potremmo voler esprimere in codice e vediamo perché gli enum
sono utili e più appropriati delle Struct in questo caso. Supponiamo che abbiamo bisogno di lavorare
con indirizzi IP. Attualmente, per gli indirizzi IP si utilizzano due principali standard: 
la versione quattro e la versione sei. Poiché queste sono le uniche possibilità per un 
indirizzo IP che il nostro programma incontrerà, possiamo *enumerare* tutte le possibili
varianti, da qui il nome enumerazione.

Qualsiasi indirizzo IP può essere o versione quattro o versione sei, ma non 
entrambi allo stesso tempo. Questa proprietà degli indirizzi IP rende la struttura dati enum
appropriata perché un valore enum può essere solo una delle sue varianti.
Sia la versione quattro che la versione sei sono comunque fondamentalmente IP
indirizzi, quindi dovrebbero essere considerati dello stesso tipo quando il codice sta gestendo
situazioni che si applicano a qualsiasi tipo di indirizzo IP.

Possiamo esprimere questo concetto nel codice definendo una enumerazione `IpAddrKind` e
elencando i possibili tipi che un indirizzo IP può avere, `V4` e `V6`. Queste sono le
varianti dell'enum:

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-01-defining-enums/src/main.rs:def}}
```

`IpAddrKind` è ora un tipo di dati personalizzato che possiamo utilizzare altrove nel nostro codice.

### Valori Enum

Possiamo creare istanze di ciascuna delle due varianti di `IpAddrKind` in questo modo:

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-01-defining-enums/src/main.rs:instance}}
```

Nota che le varianti dell'enum sono raggruppate sotto il suo identificatore, e noi
usiamo il doppio punto per separare i due. Questo è utile perché ora entrambi i valori
`IpAddrKind::V4` e `IpAddrKind::V6` sono dello stesso tipo: `IpAddrKind`. Possiamo
quindi, ad esempio, definire una funzione che accetta qualsiasi `IpAddrKind`:

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-01-defining-enums/src/main.rs:fn}}
```

E possiamo chiamare questa funzione con ogni variante:

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-01-defining-enums/src/main.rs:fn_call}}
```

L'uso di enum ha ancora più vantaggi. Pensando ancora di più al nostro tipo di indirizzo IP,
al momento non abbiamo un modo per memorizzare i reali *dati* dell'indirizzo IP; noi
sappiamo solo che tipo è. Dato che hai appena imparato sulle Struct nel
Capitolo 5, potresti essere tentato di affrontare questo problema con le Struct come mostrato in
Elenco 6-1.

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/listing-06-01/src/main.rs:here}}
```

<span class="caption">Elenco 6-1: Memorizzazione dei dati e della variante `IpAddrKind` di
un indirizzo IP utilizzando una `struct`</span>

Qui, abbiamo definito una struttura `IpAddr` che ha due campi: un campo `kind` che
è di tipo `IpAddrKind` (l'enum che abbiamo precedentemente definito) e un campo `address` di tipo `String`. Abbiamo due istanze di questa struttura. La prima è `home`,
e ha il valore `IpAddrKind::V4` come suo `kind` con dati di indirizzo associati
dati di `127.0.0.1`. La seconda istanza è `loopback`. Ha l'altra
variante di `IpAddrKind` come suo valore `kind`, `V6`, e ha l'indirizzo `::1`
associato ad essa. Abbiamo utilizzato una struttura per raggruppare i valori `kind` e `address`
insieme, quindi ora la variante è associata al valore.

Comunque, rappresentare lo stesso concetto utilizzando solo un enum è più conciso:
piuttosto che un enum all'interno di una struttura, possiamo mettere i dati direttamente in ciascuna variante enum. Questa nuova definizione dell'enum `IpAddr` dice che entrambe le varianti `V4` e `V6` avranno valori `String` associati:

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-02-enum-with-data/src/main.rs:here}}
```

Associamo i dati a ciascuna variante dell'enum direttamente, quindi non c'è bisogno di una
struttura extra. Qui, è anche più facile vedere un altro dettaglio di come funzionano gli enum:
il nome di ogni variante enum che definiamo diventa anche una funzione che
costruisce un'istanza dell'enum. Ovvero, `IpAddr::V4()` è una chiamata di funzione
che prende un argomento `String` e restituisce un'istanza del tipo `IpAddr`. Noi
otteniamo automaticamente questa funzione costruttore definita come risultato della definizione dell'enum.

C'è un altro vantaggio nell'uso di un enum piuttosto che una struct: ogni variante
può avere tipi differenti e quantità di dati associati. Gli indirizzi IP versione quattro avranno sempre quattro componenti numerici che avranno valori
compresi tra 0 e 255. Se volessimo memorizzare gli indirizzi `V4` come quattro valori `u8` ma
esprimere ancora gli indirizzi `V6` come un valore `String`, non saremmo in grado di farlo con
una struct. Gli Enum gestiscono questo caso con facilità:

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-03-variants-with-different-data/src/main.rs:here}}
```

Abbiamo mostrato diversi modi differenti per definire strutture di dati per memorizzare le versioni
quattro e sei degli indirizzi IP. Comunque, come si scopre, voler memorizzare
gli indirizzi IP e codificare quale tipo siano è così comune che [la libreria standard
ha una definizione che possiamo utilizzare!][IpAddr] <!-- ignore --> Diamo un'occhiata a come
la libreria standard definisce `IpAddr`: ha lo stesso enum e varianti che
abbiamo definito e utilizzato, ma incorpora i dati dell'indirizzo all'interno delle varianti sotto forma di due diverse strutture, che sono definite in modo diverso per ciascuna
variante:

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

Questo codice illustra che si può mettere qualsiasi tipo di dati all'interno di una variante enum:
stringhe, tipi numerici, o struct, ad esempio. Puoi anche includere un altro
enum! Inoltre, i tipi di libreria standard non sono spesso molto più complicati di
quello che potresti ideare.

Nota che anche se la libreria standard contiene una definizione per `IpAddr`,
possiamo ancora creare e utilizzare la nostra definizione senza conflitti perché noi
non abbiamo portato la definizione della libreria standard nel nostro scope. Parleremo
di più sul portare i tipi nello scope nel Capitolo 7.

Diamo un'occhiata a un altro esempio di un enum nell'Elenco 6-2: questo ha una grande
varietà di tipi incorporati nelle sue varianti.

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/listing-06-02/src/main.rs:here}}
```

<span class="caption">Elenco 6-2: Un `Message` enum le cui varianti memorizzano
diverse quantità e tipi di valori</span>

Questo enum ha quattro varianti con tipi differenti:

* `Quit` non ha dati associati ad esso affatto.
* `Move` ha campi nominati, come una struct.
* `Write` include una singola `String`.
* `ChangeColor` include tre valori `i32`.
Definire un enum con varianti come quelle nella Listare 6-2 è simile alla definizione di vari tipi di strut, tranne che l'enum non usa la parola chiave `struct` e tutte le varianti sono raggruppate sotto il tipo `Message`. I seguenti strut potrebbero contenere gli stessi dati che contengono le varianti enum precedenti:

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-04-structs-similar-to-message-enum/src/main.rs:here}}
```

Ma se usassimo strut diversi, ognuno con il proprio tipo, non potremmo definire facilmente una funzione per accettare uno qualsiasi di questi tipi di messaggi come potremmo con l'enum `Message` definito nella Listare 6-2, che è un unico tipo.

C'è un'altra somiglianza tra enum e strut: così come siamo in grado di definire i metodi sugli strut usando `impl`, siamo anche in grado di definire metodi sugli enum. Ecco un metodo chiamato `call` che potremmo definire sul nostro enum `Message`:

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-05-methods-on-enums/src/main.rs:here}}
```

Il corpo del metodo userebbe `self` per ottenere il valore sul quale abbiamo chiamato il metodo. In questo esempio, abbiamo creato una variabile `m` che ha il valore `Message::Write(String::from("hello"))`, e questo è ciò che `self` sarà nel corpo del metodo `call` quando viene eseguito `m.call()`.

Diamo un'occhiata ad un altro enum nella libreria standard che è molto comune e utile: `Option`.

### L'Enum `Option` e i suoi vantaggi rispetto ai valori Null

Questa sezione esplora uno studio di caso di `Option`, che è un altro enum definito dalla libreria standard. Il tipo `Option` codifica lo scenario molto comune in cui un valore potrebbe essere qualcosa o potrebbe non essere nulla.

Ad esempio, se richiedi il primo elemento di un elenco non vuoto, otterresti un valore. Se richiedi il primo elemento di un elenco vuoto, non otterresti nulla. Esprimere questo concetto in termini del sistema di tipi significa che il compilatore può controllare se hai gestito tutti i casi che dovresti essere gestendo; questa funzionalità può prevenire errori che sono estremamente comuni in altri linguaggi di programmazione.

La progettazione dei linguaggi di programmazione è spesso pensata in termini di quali caratteristiche includi, ma le caratteristiche che escludi sono importanti anche. Rust non ha la caratteristica null che molti altri linguaggi hanno. *Null* è un valore che significa che non c'è valore lì. Nei linguaggi con null, le variabili possono sempre essere in uno dei due stati: null o non-null.

Nella sua presentazione del 2009 "Null References: The Billion Dollar Mistake," Tony Hoare, l'inventore del null, ha questo da dire:

> Lo chiamo il mio errore da miliardi di dollari. In quel momento, stavo progettando il primo sistema di tipo completo per i riferimenti in un linguaggio orientato agli oggetti. Il mio obiettivo era di garantire che tutto l'uso dei riferimenti fosse assolutamente sicuro, con la verifica eseguita automaticamente dal compilatore. Ma non ho potuto resistere alla tentazione di inserire un riferimento nullo, semplicemente perché era così facile da implementare. Questo ha portato a innumerevoli errori, vulnerabilità e crash del sistema, che probabilmente hanno causato un miliardo di dollari di dolore e danni negli ultimi quaranta anni.

Il problema con i valori null è che se provi a usare un valore null come un valore non-null, otterrai un errore di qualche tipo. Poiché questa proprietà null o non-null è pervasiva, è estremamente facile commettere questo tipo di errore.

Tuttavia, il concetto che il null sta cercando di esprimere è ancora utile: un null è un valore che attualmente non è valido o assente per qualche motivo.

Il problema non è realmente con il concetto ma con la particolare implementazione. Come tale, Rust non ha null, ma ha un enum che può codificare il concetto di un valore presente o assente. Questo enum è `Option<T>`, ed è [definito dalla libreria standard][option]<!-- ignore --> come segue:

```rust
enum Option<T> {
    None,
    Some(T),
}
```

L'enum `Option<T>` è così utile che è incluso anche nel preludio; non c'è bisogno di portarlo esplicitamente nell'ambito. Anche le sue varianti sono incluse nel preludio: è possibile utilizzare direttamente `Some` e `None` senza il prefisso `Option::`. L'enum `Option<T>` è ancora solo un enum normale, e `Some(T)` e `None` sono ancora varianti del tipo `Option<T>`.

La sintassi `<T>` è una caratteristica di Rust di cui non abbiamo ancora parlato. È un parametro di tipo generico, e tratteremo i generici più in dettaglio nel Capitolo 10. Per ora, tutto ciò che devi sapere è che `<T>` significa che la variante `Some` dell'enum `Option` può contenere un pezzo di dati di qualsiasi tipo, e che ogni tipo concreto che viene usato al posto di `T` rende il tipo globale `Option<T>` un tipo diverso. Ecco alcuni esempi di utilizzo dei valori `Option` per contenere tipi di numeri e tipi di stringhe:

```rust
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-06-option-examples/src/main.rs:here}}
```

Il tipo di `some_number` è `Option<i32>`. Il tipo di `some_char` è `Option<char>`, che è un tipo diverso. Rust può inferire questi tipi perché abbiamo specificato un valore all'interno della variante `Some`. Per `absent_number`, Rust richiede che annotiamo il tipo totale `Option`: il compilatore non può inferire il tipo che la variante `Some` corrispondente conterrà guardando solo un valore `None`. Qui, diciamo a Rust che intendiamo che `absent_number` sia di tipo `Option<i32>`.

Quando abbiamo un valore `Some`, sappiamo che un valore è presente e il valore è contenuto all'interno del `Some`. Quando abbiamo un valore `None`, in un certo senso significa la stessa cosa di null: non abbiamo un valore valido. Quindi perché avere `Option<T>` è migliore di avere null?

In breve, perché `Option<T>` e `T` (dove `T` può essere qualsiasi tipo) sono tipi diversi, il compilatore non ci permetterà di usare un valore `Option<T>` come se fosse sicuramente un valore valido. Ad esempio, questo codice non compilerà, perché sta cercando di aggiungere un `i8` a un `Option<i8>`:

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch06-enums-and-pattern-matching/no-listing-07-cant-use-option-directly/src/main.rs:here}}
```

Se eseguiamo questo codice, otteniamo un messaggio di errore come questo:

```console
{{#include ../listings/ch06-enums-and-pattern-matching/no-listing-07-cant-use-option-directly/output.txt}}
```

Intenso! Di fatto, questo messaggio di errore significa che Rust non capisce come aggiungere un `i8` e un `Option<i8>`, perché sono tipi diversi. Quando abbiamo un valore di un tipo come `i8` in Rust, il compilatore farà in modo che abbiamo sempre un valore valido. Possiamo procedere con fiducia senza dover controllare per null prima di usare quel valore. Solo quando abbiamo un `Option<i8>` (o qualsiasi tipo di valore con cui stiamo lavorando) dobbiamo preoccuparci del fatto che potremmo non avere un valore, e il compilatore si assicurerà che gestiamo quel caso prima di usare il valore.

In altre parole, devi convertire un `Option<T>` in un `T` prima di poter eseguire operazioni `T` con esso. Generalmente, questo aiuta a cogliere uno dei problemi più comuni con il null: presumere che qualcosa non sia nulla quando in realtà lo è.
Eliminare il rischio di assumere erroneamente un valore non-null ti aiuta ad avere più fiducia nel tuo codice. Per avere un valore che potrebbe essere null, devi scegliere esplicitamente di farlo rendendo il tipo di quel valore `Option<T>`. Quindi, quando usi quel valore, sei obbligato a gestire esplicitamente il caso in cui il valore è null. Ovunque un valore abbia un tipo che non è un `Option<T>`, *puoi* assumere con sicurezza che il valore non sia null. Questa è stata una decisione di progettazione intenzionale per Rust per limitare la pervasività di null e aumentare la sicurezza del codice Rust.

Quindi, come ottieni il valore `T` da una variante `Some` quando hai un valore di tipo `Option<T>` in modo da poter utilizzare quel valore? L'enum `Option<T>` ha un grande numero di metodi che sono utili in una varietà di situazioni; puoi dare un'occhiata nella relativa [documentazione][docs]<!-- ignore -->. Familiarizzare con i metodi su `Option<T>` sarà estremamente utile nel tuo percorso con Rust.

In generale, per utilizzare un valore `Option<T>`, vorresti avere del codice che gestisca ciascuna variante. Vorresti del codice che si esegue solo quando hai un valore `Some(T)`, e questo codice è autorizzato a utilizzare il `T` interno. Vorresti che un altro codice si eseguisse solo se hai un valore `None`, e quel codice non ha disponibile un valore `T`. L'espressione `match` è un costrutto di controllo del flusso che fa proprio questo quando usato con gli enum: eseguirà un codice diverso a seconda della variante dell'enum che ha, e quel codice può utilizzare i dati all'interno del valore corrispondente.

[IpAddr]: ../std/net/enum.IpAddr.html
[option]: ../std/option/enum.Option.html
[docs]: ../std/option/enum.Option.html
