## Convalida delle Reference con i Lifetime

I Lifetime sono un altro tipo di generico che abbiamo già utilizzato. Piuttosto
che garantire che un tipo abbia il comportamento che vogliamo, i lifetime garantiscono che
le reference siano valide finché ne abbiamo bisogno.

Un dettaglio di cui non abbiamo discusso nella sezione [“Reference e
Borrowing”][references-and-borrowing]<!-- ignore --> nel Capitolo 4 è
che ogni reference in Rust ha un *lifetime*, che è lo Scope per cui
quella reference è valida. La maggior parte delle volte, i lifetime sono impliciti e dedotti,
proprio come la maggior parte delle volte, i tipi sono dedotti. Dobbiamo annotare i tipi solo
quando sono possibili più tipi. In modo simile, dobbiamo annotare i lifetime
quando i lifetime delle reference potrebbero essere correlati in più modi. Rust
ci richiede di annotare le relazioni usando parametri di lifetime generici per
assicurarsi che le reference effettive utilizzate a runtime siano sicuramente valide.

Annotare i lifetime non è un concetto che la maggior parte degli altri linguaggi di programmazione ha, quindi
questo risulterà estraneo. Sebbene non copriremo i lifetime nella loro
interezza in questo capitolo, discuteremo i modi comuni in cui potresti incontrare
la sintassi dei lifetime in modo che tu possa familiarizzare con il concetto.

### Prevenire le Reference Pendenti con i Lifetime

Lo scopo principale dei lifetime è prevenire le *reference pendenti*, che causano un
programma a fare riferimento a dati diversi da quelli a cui intende fare riferimento.
Consideriamo il programma nel Listing 10-16, che ha uno Scope esterno e uno Scope interno.

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-16/src/main.rs}}
```

<span class="caption">Listing 10-16: Un tentativo di usare una reference il cui valore
è uscito dallo scope</span>

> Nota: Gli esempi nel Listing 10-16, 10-17 e 10-23 dichiarano variabili
> senza dare loro un valore iniziale, quindi il nome della variabile esiste nello Scope esterno.
> A prima vista, questo potrebbe sembrare in conflitto con il fatto che Rust non abbia
> valori null. Tuttavia, se proviamo a usare una variabile prima di assegnarle un valore,
> otterremo un errore di compilazione, il che dimostra che Rust non consente
> effettivamente valori null.

Lo Scope esterno dichiara una variabile chiamata `r` senza valore iniziale, e lo
Scope interno dichiara una variabile chiamata `x` con il valore iniziale di `5`. All'interno
dello Scope interno, tentiamo di impostare il valore di `r` come una reference a `x`. Quindi
lo Scope interno termina e tentiamo di stampare il valore in `r`. Questo codice non
compila perché il valore a cui `r` fa riferimento è uscito dallo scope prima
che proviamo a utilizzarlo. Ecco il messaggio di errore:

```console
{{#include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-16/output.txt}}
```

Il messaggio di errore dice che la variabile `x` “non vive abbastanza a lungo.” Il
motivo è che `x` sarà fuori dallo scope quando lo Scope interno termina sulla riga 7.
Ma `r` è ancora valido per lo Scope esterno; poiché il suo scope è più grande, diciamo
che “vive più a lungo.” Se Rust permettesse a questo codice di funzionare, `r`
farebbe riferimento a memoria che è stata deallocata quando `x` è andato fuori dallo scope, e
qualsiasi cosa provassimo a fare con `r` non funzionerebbe correttamente. Quindi come fa Rust
a determinare che questo codice non è valido? Utilizza un borrow checker.

### Il Borrow Checker

Il compilatore di Rust ha un *borrow checker* che confronta gli scope per determinare
se tutti i borrow sono validi. Il Listing 10-17 mostra lo stesso codice del Listing
10-16 ma con annotazioni che mostrano i lifetime delle variabili.

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-17/src/main.rs}}
```

<span class="caption">Listing 10-17: Annotazioni dei lifetime di `r` e
`x`, denominati rispettivamente `'a` e `'b`</span>

Qui, abbiamo annotato il lifetime di `r` con `'a` e il lifetime di `x`
con `'b`. Come puoi vedere, il blocco interno `'b` è molto più piccolo del blocco
di lifetime esterno `'a`. A tempo di compilazione, Rust confronta la dimensione dei due
lifetime e vede che `r` ha un lifetime di `'a` ma si riferisce a memoria
con un lifetime di `'b`. Il programma viene rifiutato perché `'b` è più corto di
`'a`: il soggetto della reference non vive tanto quanto la reference.

Il Listing 10-18 risolve il codice in modo che non ci sia una reference pendente e
compila senza errori.

```rust
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-18/src/main.rs}}
```

<span class="caption">Listing 10-18: Una reference valida perché i dati hanno un
lifetime più lungo rispetto alla reference</span>

Qui, `x` ha il lifetime `'b`, che in questo caso è maggiore di `'a`. Questo
significa che `r` può riferirsi a `x` perché Rust sa che la reference in `r` sarà
sempre valida mentre `x` è valido.

Ora che sai cosa sono i lifetime delle reference e come Rust analizza
i lifetime per garantire che le reference saranno sempre valide, esploriamo i
lifetime generici di parametri e valori di ritorno nel contesto delle funzioni.

### Lifetime Generici nelle Funzioni

Scriveremo una funzione che restituisce la più lunga di due string slices. Questa
funzione prenderà due string slices e restituirà un singolo string slice. Dopo
aver implementato la funzione `longest`, il codice nel Listing 10-19 dovrebbe
stampare `The longest string is abcd`.

<span class="filename">Nome file: src/main.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-19/src/main.rs}}
```

<span class="caption">Listing 10-19: Una funzione `main` che chiama la funzione `longest`
per trovare la più lunga di due string slices</span>

Nota che vogliamo che la funzione prenda string slices, che sono reference,
invece di string, perché non vogliamo che la funzione `longest` prenda
Ownership dei suoi parametri. Consulta la sezione [“String Slices come
Parametri”][string-slices-as-parameters]<!-- ignore --> nel Capitolo 4
per ulteriori discussioni sul perché i parametri che usiamo nel Listing 10-19 sono quelli
che vogliamo.

Se proviamo a implementare la funzione `longest` come mostrato nel Listing 10-20, non
compilerà.

<span class="filename">Nome file: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-20/src/main.rs:here}}
```

<span class="caption">Listing 10-20: Un'implementazione della funzione `longest`
che restituisce la più lunga di due string slices ma che non compila ancora</span>

Invece, otteniamo il seguente errore che parla di lifetime:

```console
{{#include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-20/output.txt}}
```

Il testo di aiuto rivela che il tipo di ritorno ha bisogno di un parametro di lifetime
generico perché Rust non riesce a capire se la reference restituita si riferisca a
`x` o `y`. In realtà, non lo sappiamo nemmeno noi, perché il blocco `if` nel Blocco
di questa funzione restituisce una reference a `x` e il blocco `else` restituisce una
reference a `y`!

Quando stiamo definendo questa funzione, non conosciamo i valori concreti che verranno
passati a questa funzione, quindi non sappiamo se verrà eseguito il caso `if` o il
caso `else`. Non conosciamo neanche i lifetime concreti delle reference che verranno passate,
quindi non possiamo analizzare gli scope come abbiamo fatto nei Listing 10-17 e 10-18
per determinare se la reference che restituiamo sarà sempre valida. Neanche il borrow checker
può determinarlo, perché non sa come i lifetime di `x` e `y` si devono rapportare al lifetime
del valore di ritorno. Per risolvere questo errore, aggiungeremo parametri di lifetime generici
che definiscano la relazione tra le reference in modo che il borrow checker possa
effettuare la sua analisi.

### Sintassi dell'Annotazione dei Lifetime

Le annotazioni dei lifetime non cambiano quanto tempo vivono le reference. Piuttosto,
descrivono le relazioni tra i lifetime di più reference l'una con l'altra senza influire sui lifetime.
Come le funzioni possono accettare qualsiasi tipo quando la firma specifica un parametro di tipo generico,
le funzioni possono accettare reference con qualsiasi lifetime specificando un parametro di lifetime generico.

Le annotazioni dei lifetime hanno una sintassi leggermente insolita: i nomi dei parametri di lifetime devono iniziare con un apostrofo (`'`) e sono solitamente tutte in minuscolo e molto brevi,
come i tipi generici. La maggior parte delle persone usa il nome `'a` per la prima annotazione di lifetime. Poniamo le annotazioni di parametro di lifetime dopo `&` di una
reference, usando uno spazio per separare l'annotazione dal tipo della reference.

Ecco alcuni esempi: una reference a un `i32` senza un parametro di lifetime, una
reference a un `i32` che ha un parametro di lifetime chiamato `'a`, e una
reference mutable a un `i32` che ha anch'esso il lifetime `'a`.

```rust,ignore
&i32        // una reference
&'a i32     // una reference con un lifetime esplicito
&'a mut i32 // una reference mutable con un lifetime esplicito
```

Un'annotazione di lifetime da sola non ha molto significato perché
le annotazioni sono pensate per indicare a Rust come i parametri di lifetime generici di più
reference si relazionano tra loro. Esaminiamo come le annotazioni di lifetime
si relazionano tra loro nel contesto della funzione `longest`.

### Annotazioni di Lifetime nelle Signature delle Funzioni

Per usare le annotazioni di lifetime nelle signature delle funzioni, dobbiamo dichiarare i
parametri di *lifetime* generici all'interno di parentesi angolari tra il nome della funzione
e l'elenco dei parametri, proprio come abbiamo fatto con i parametri di tipo
generici.

Vogliamo che la signature esprima il seguente vincolo: la reference restituita
sarà valida fintanto che entrambi i parametri saranno validi. Questa è la
relazione tra i lifetime dei parametri e il valore di ritorno. Daremo il nome
al lifetime `'a` e poi lo aggiungeremo a ciascuna reference, come mostrato nel Listing
10-21.

<span class="filename">Nome file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-21/src/main.rs:here}}
```

<span class="caption">Listing 10-21: La definizione della funzione `longest`
che specifica che tutte le reference nella signature devono avere lo stesso lifetime
`'a`</span>

Questo codice dovrebbe compilare e produrre il risultato desiderato quando lo usiamo con la
funzione `main` nel Listing 10-19.

La firma della funzione ora dice a Rust che per qualche lifetime `'a`, la funzione
prende due parametri, entrambi i quali sono string slices che vivono almeno
quanto il lifetime `'a`. La firma della funzione dice anche a Rust che lo slice
di stringa restituito dalla funzione vivrà almeno quanto il lifetime `'a`.
In pratica, significa che il lifetime della reference restituita dalla
funzione `longest` è lo stesso del minore dei lifetime dei valori
indicati dagli argomenti della funzione. Queste relazioni sono ciò che desideriamo
che Rust utilizzi quando analizza questo codice.

Ricorda, quando specifichiamo i parametri di lifetime nella firma della funzione,
non stiamo cambiando i lifetime di nessun valore passato o ritornato. Piuttosto,
stiamo specificando che il borrow checker dovrebbe rifiutare qualsiasi valore che non
aderisce a questi vincoli. Nota che la funzione `longest` non ha bisogno di
sapere esattamente quanto `x` e `y` vivranno, solo che qualche scope può essere
sostituito per `'a` che soddisferà questa signature.

Quando annotiamo i lifetime nelle funzioni, le annotazioni vanno nella signature della funzione,
non nel Blocco della funzione. Le annotazioni dei lifetime diventano parte del
contratto della funzione, molto simile ai tipi nella signature. Avere
signature di funzione che contengono il contratto dei lifetime significa che l'analisi
che il compilatore Rust fa può essere più semplice. Se c'è un problema con il modo in cui una
funzione è annotata o il modo in cui è chiamata, gli errori del compilatore possono
indicare la parte del nostro codice e i vincoli in modo più preciso. Se, invece,
il compilatore Rust facesse più inferenze su quali intendessimo le relazioni
tra i lifetime, il compilatore potrebbe solo essere in grado di indicare un uso
del nostro codice molti passi lontano dalla causa del problema.

Quando passiamo reference concrete a `longest`, il lifetime concreto
che viene sostituito per `'a` è la parte di scope di `x` che si sovrappone con lo
scope di `y`. In altre parole, il lifetime generico `'a` avrà il lifetime concreto
che è uguale al minore dei lifetime di `x` e `y`. Poiché abbiamo
annotato la reference restituita con lo stesso parametro di lifetime `'a`,
la reference restituita sarà anche valida per la durata del minore
dei lifetime di `x` e `y`.

Guardiamo come le annotazioni dei lifetime limitano la funzione `longest` passando
reference che hanno lifetime concreti diversi. Il Listing 10-22 è un esempio diretto.

<span class="filename">Nome file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-22/src/main.rs:here}}
```

<span class="caption">Listing 10-22: Usare la funzione `longest` con
reference a valori `String` che hanno lifetime concreti diversi</span>

In questo esempio, `string1` è valido fino alla fine dello scope esterno, `string2`
è valido fino alla fine dello scope interno, e `result` fa riferimento a qualcosa
che è valido fino alla fine dello scope interno. Esegui questo codice e vedrai
che il borrow checker approva; compilerà e stamperà `The longest string
is long string is long`.

Passiamo ora a un esempio che mostra che il lifetime della reference in
`result` deve essere il lifetime minore dei due argomenti. Sposteremo
la dichiarazione della variabile `result` al di fuori dello scope interno ma lasceremo
l'assegnazione del valore alla variabile `result` all'interno dello scope con
`string2`. Poi sposteremo il `println!` che utilizza `result` fuori dallo
scope interno, dopo che lo scope interno è terminato. Il codice nel Listing 10-23
non compilerà.

<span class="filename">Nome file: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-23/src/main.rs:here}}
```

<span class="caption">Listing 10-23: Tentativo di usare `result` dopo che `string2`
è uscito dallo scope</span>

Quando proviamo a compilare questo codice, otteniamo questo errore:

```console
{{#include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-23/output.txt}}
```

L'errore mostra che affinché `result` sia valido per la dichiarazione `println!`,
`string2` dovrebbe essere valido fino alla fine dello scope esterno. Rust lo sa
perché abbiamo annotato i lifetime dei parametri della funzione e del valore di ritorno
usando lo stesso parametro di lifetime `'a`.

Come esseri umani, possiamo guardare questo codice e vedere che `string1` è più lungo di
`string2`, e quindi, `result` conterrà una reference a `string1`.
Poiché `string1` non è ancora uscito dallo scope, una reference a `string1` sarà
ancora valida per la dichiarazione `println!`. Tuttavia, il compilatore non può
vedere che la reference è valida in questo caso. Abbiamo detto a Rust che il lifetime
della reference restituita dalla funzione `longest` è lo stesso del minore dei
lifetime delle reference passate. Pertanto, il borrow checker
disapprova il codice nel Listing 10-23 come potenzialmente avente una reference non valida.

Prova a progettare più esperimenti che variano i valori e i lifetime delle
reference passate alla funzione `longest` e come la reference restituita
viene utilizzata. Fai ipotesi su se i tuoi esperimenti supereranno il
borrow checker prima di compilare; poi verifica se hai ragione!

### Pensare in Termini di Lifetime

Il modo in cui devi specificare i parametri di lifetime dipende da cosa fa la tua
funzione. Ad esempio, se cambiassimo l'implementazione della
funzione `longest` per restituire sempre il primo parametro invece della più lunga
string slice, non avremmo bisogno di specificare un lifetime sul parametro `y`. Il
seguente codice compilerà:

<span class="filename">Nome file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/no-listing-08-only-one-reference-with-lifetime/src/main.rs:here}}
```


Abbiamo specificato un parametro di lifetime `'a` per il parametro `x` e il tipo di ritorno, ma non per il parametro `y`, perché il lifetime di `y` non ha alcuna relazione con il lifetime di `x` o il valore restituito.

Quando si ritorna una reference da una funzione, il parametro di lifetime per il tipo di ritorno deve corrispondere al parametro di lifetime di uno dei parametri. Se la reference restituita *non* si riferisce a uno dei parametri, deve riferirsi a un valore creato all'interno di questa funzione. Tuttavia, questa sarebbe una reference dangling perché il valore andrà fuori Scope alla fine della funzione. Considera questa implementazione tentata della funzione `longest` che non verrà compilata:

<span class="filename">Nome file: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/no-listing-09-unrelated-lifetime/src/main.rs:here}}
```

Qui, anche se abbiamo specificato un parametro di lifetime `'a` per il tipo di ritorno, questa implementazione non verrà compilata perché il lifetime del valore di ritorno non è affatto correlato al lifetime dei parametri. Ecco il messaggio di errore che riceviamo:

```console
{{#include ../listings/ch10-generic-types-traits-and-lifetimes/no-listing-09-unrelated-lifetime/output.txt}}
```

Il problema è che `result` va fuori Scope e viene eliminato alla fine della funzione `longest`. Stiamo anche cercando di restituire una reference a `result` dalla funzione. Non possiamo specificare parametri di lifetime che modificherebbero la reference dangling, e Rust non ci permette di creare una reference dangling. In questo caso, la soluzione migliore sarebbe restituire un tipo di dato posseduto piuttosto che una reference in modo che la funzione chiamante sia poi responsabile dell'eliminazione del valore.

In definitiva, la sintassi del lifetime riguarda il collegamento dei lifetimes di vari parametri e valori di ritorno delle funzioni. Una volta collegati, Rust ha abbastanza informazioni per consentire operazioni sicure per la memoria e disabilitare operazioni che creerebbero puntatori dangling o altrimenti violerebbero la sicurezza della memoria.

### Annotazioni dei Lifetime nelle Definizioni di Struct

Finora, le structs che abbiamo definito contengono tutti tipi posseduti. Possiamo definire structs per contenere references, ma in tal caso dovremmo aggiungere un'annotazione di lifetime su ogni reference nella definizione della struct. Il Listing 10-24 ha una struct chiamata `ImportantExcerpt` che contiene una string slice.

<span class="filename">Nome file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-24/src/main.rs}}
```

<span class="caption">Listing 10-24: Una struct che contiene una reference, richiedendo
un'annotazione di lifetime</span>

Questa struct ha il solo campo `part` che contiene una string slice, che è una reference. Come per i tipi di dati generici, dichiariamo il nome del parametro di lifetime generico all'interno delle parentesi angolari dopo il nome della struct in modo da poter usare il parametro di lifetime nel blocco della definizione della struct. Questa annotazione significa che un'istanza di `ImportantExcerpt` non può durare più a lungo della reference che contiene nel suo campo `part`.

La funzione `main` qui crea un'istanza della struct `ImportantExcerpt` che contiene una reference alla prima frase della `String` posseduta dalla variabile `novel`. I dati in `novel` esistono prima che l'istanza `ImportantExcerpt` sia creata. Inoltre, `novel` non va fuori Scope fino a dopo che `ImportantExcerpt` è uscito fuori Scope, quindi la reference nell'istanza `ImportantExcerpt` è valida.

### Eliminazione dei Lifetime

Hai imparato che ogni reference ha un lifetime e che è necessario specificare parametri di lifetime per le funzioni o structs che usano references. Tuttavia, avevamo una funzione nel Listing 4-9, mostrata nuovamente nel Listing 10-25, che si è compilata senza annotazioni di lifetime.

<span class="filename">Nome file: src/lib.rs</span>

```rust
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-25/src/main.rs:here}}
```

<span class="caption">Listing 10-25: Una funzione che abbiamo definito nel Listing 4-9 che
si è compilata senza annotazioni di lifetime, anche se il parametro e il
tipo di ritorno sono references</span>

La ragione per cui questa funzione si compila senza annotazioni di lifetime è storica: nelle prime versioni (pre-1.0) di Rust, questo codice non si sarebbe compilato perché ogni reference richiedeva un lifetime esplicito. All'epoca, la firma della funzione sarebbe stata scritta così:

```rust,ignore
fn first_word<'a>(s: &'a str) -> &'a str {
```

Dopo aver scritto molto codice in Rust, il team di Rust ha scoperto che i programmatori Rust inserivano le stesse annotazioni di lifetime più e più volte in situazioni particolari. Queste situazioni erano prevedibili e seguivano alcuni schemi deterministici. Gli sviluppatori hanno programmato questi schemi nel codice del compilatore in modo che il borrow checker potesse dedurre i lifetimes in queste situazioni e non avesse bisogno di annotazioni esplicite.

Questo pezzo di storia di Rust è rilevante perché è possibile che emergano più schemi deterministici e vengano aggiunti al compilatore. In futuro, potrebbero essere necessarie ancora meno annotazioni di lifetime.

Gli schemi programmati nell'analisi di References di Rust sono chiamati *regole di eliminazione dei lifetime*. Queste non sono regole che i programmatori devono seguire; sono un insieme di casi particolari che il compilatore considererà, e se il tuo codice si adatta a questi casi, non hai bisogno di scrivere i lifetimes esplicitamente.

Le regole di eliminazione non forniscono un'inferenza completa. Se c'è ancora ambiguità su quali lifetimes abbiano le references dopo che Rust ha applicato le regole, il compilatore non indovinerà quale dovrebbe essere il lifetime delle references rimanenti. Invece di indovinare, il compilatore ti darà un errore che puoi risolvere aggiungendo le annotazioni di lifetime.

I lifetimes sui parametri di funzione o metodo si chiamano *input lifetimes*, e i lifetimes sui valori di ritorno si chiamano *output lifetimes*.

Il compilatore usa tre regole per determinare i lifetimes delle references quando non ci sono annotazioni esplicite. La prima regola si applica agli input lifetimes, e la seconda e la terza regola si applicano agli output lifetimes. Se il compilatore arriva alla fine delle tre regole e ci sono ancora references per le quali non riesce a determinare i lifetimes, il compilatore si fermerà con un errore. Queste regole si applicano alle definizioni `fn` così come ai blocchi `impl`.

La prima regola è che il compilatore assegna un parametro di lifetime a ciascun parametro che è una reference. In altre parole, una funzione con un parametro ottiene un parametro di lifetime: `fn foo<'a>(x: &'a i32)`; una funzione con due parametri ottiene due parametri di lifetime separati: `fn foo<'a, 'b>(x: &'a i32, y: &'b i32)`; e così via.

La seconda regola è che, se c'è esattamente un parametro di input lifetime, quel lifetime viene assegnato a tutti gli output lifetime: `fn foo<'a>(x: &'a i32) -> &'a i32`.

La terza regola è che, se ci sono più parametri di input lifetime, ma uno di essi è `&self` o `&mut self` perché questo è un metodo, il lifetime di `self` è assegnato a tutti gli output lifetime. Questa terza regola rende i metodi molto più semplici da leggere e scrivere perché sono necessari meno simboli.

Facciamo finta di essere il compilatore. Applicheremo queste regole per determinare i lifetimes delle references nella firma della funzione `first_word` nel Listing 10-25. La firma inizia senza alcun lifetime associato alle references:

```rust,ignore
fn first_word(s: &str) -> &str {
```

Poi il compilatore applica la prima regola, che specifica che ogni parametro ottiene il proprio lifetime. Lo chiameremo `'a` come di consueto, quindi ora la firma è questa:

```rust,ignore
fn first_word<'a>(s: &'a str) -> &str {
```

La seconda regola si applica perché c'è esattamente un input lifetime. La seconda regola specifica che il lifetime dell'unico parametro di input viene assegnato al lifetime di output, quindi la firma ora è questa:

```rust,ignore
fn first_word<'a>(s: &'a str) -> &'a str {
```

Ora tutte le references in questa firma di funzione hanno lifetimes, e il compilatore può continuare la sua analisi senza richiedere al programmatore di annotare i lifetimes in questa firma di funzione.

Guardiamo un altro esempio, questa volta usando la funzione `longest` che non ha avuto parametri di lifetime quando abbiamo iniziato a lavorarci sopra nel Listing 10-20:

```rust,ignore
fn longest(x: &str, y: &str) -> &str {
```

Applichiamo la prima regola: ogni parametro ottiene il proprio lifetime. Questa volta abbiamo due parametri al posto di uno, quindi abbiamo due lifetimes:

```rust,ignore
fn longest<'a, 'b>(x: &'a str, y: &'b str) -> &str {
```

Si può vedere che la seconda regola non si applica perché ci sono più di un input lifetime. Neanche la terza regola si applica, perché `longest` è una funzione piuttosto che un metodo, quindi nessuno dei parametri è `self`. Dopo aver lavorato su tutte e tre le regole, non abbiamo ancora determinato qual è il lifetime del tipo di ritorno. Questo è il motivo per cui abbiamo ottenuto un errore cercando di compilare il codice nel Listing 10-20: il compilatore ha lavorato attraverso le regole di eliminazione del lifetime ma non è riuscito a determinare tutti i lifetimes delle references nella firma.

Poiché la terza regola si applica davvero solo nelle firme dei metodi, esamineremo i lifetimes in quel contesto successivo per vedere perché la terza regola significa che non dobbiamo spesso annotare i lifetimes nelle firme dei metodi.

### Annotazioni dei Lifetime nelle Definizioni dei Metodi

Quando implementiamo metodi su una struct con lifetimes, usiamo la stessa sintassi dei parametri di tipo generico mostrata nel Listing 10-11. Dove dichiariamo e usiamo i parametri di lifetime dipende dal fatto che siano correlati ai campi della struct o ai parametri del metodo e ai valori di ritorno.

I nomi dei lifetime per i campi della struct devono sempre essere dichiarati dopo la parola chiave `impl` e poi usati dopo il nome della struct perché quei lifetimes fanno parte del tipo della struct.

Nelle firme dei metodi all'interno del blocco `impl`, le references potrebbero essere legate al lifetime delle references nei campi della struct, oppure potrebbero essere indipendenti. Inoltre, le regole di eliminazione del lifetime spesso fanno sì che le annotazioni di lifetime non siano necessarie nelle firme dei metodi. Guardiamo alcuni esempi usando la struct chiamata `ImportantExcerpt` che abbiamo definito nel Listing 10-24.

Per prima cosa useremo un metodo chiamato `level` il cui unico parametro è una reference a `self` e il cui valore di ritorno è un `i32`, che non è una reference a nulla:

```rust
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/no-listing-10-lifetimes-on-methods/src/main.rs:1st}}
```

Le dichiarazioni di parametri di lifetime dopo `impl` e il loro uso dopo il nome del tipo sono obbligatorie, ma non siamo tenuti ad annotare il lifetime della reference a `self` grazie alla prima regola di eliminazione.

Ecco un esempio in cui si applica la terza regola di eliminazione del lifetime:

```rust
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/no-listing-10-lifetimes-on-methods/src/main.rs:3rd}}
```

Ci sono due lifetimes di input, quindi Rust applica la prima regola di eliminazione del lifetime e assegna a entrambi `&self` e `announcement` i propri lifetimes. Poi, poiché uno dei parametri è `&self`, il tipo di ritorno ottiene il lifetime di `&self`, e tutti i lifetimes sono stati considerati.

### Il Lifetime Static

Un lifetime speciale di cui dobbiamo discutere è `'static`, che denota che la reference interessata *può* vivere per l'intera durata del programma. Tutti i letterali stringa hanno il lifetime `'static`, che possiamo annotare come segue:

```rust
let s: &'static str = "I have a static lifetime.";
```

Il testo di questa stringa è memorizzato direttamente nel binario del programma, che è sempre disponibile. Pertanto, il lifetime di tutti i letterali stringa è `'static`.

Potresti vedere suggerimenti per utilizzare il lifetime `'static` nei messaggi di errore. Ma prima di specificare `'static` come il lifetime per una reference, pensa se la reference che hai vive davvero per l'intero lifetime del tuo programma o no, e se vuoi che lo faccia. La maggior parte delle volte, un messaggio di errore che suggerisce il lifetime `'static` risulta dal tentativo di creare una reference dangling o un disallineamento dei lifetimes disponibili. In questi casi, la soluzione è risolvere quei problemi, non specificare il lifetime `'static`.

## Parametri di Tipo Generici, Vincoli di Trait, e Lifetimes Insieme

Diamo un breve sguardo alla sintassi di specificare parametri di tipi generici, vincoli di trait e lifetimes tutti in una funzione!

```rust
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/no-listing-11-generics-traits-and-lifetimes/src/main.rs:here}}
```

Questa è la funzione `longest` dal Listing 10-21 che restituisce il più lungo di due string slice. Ma ora ha un parametro extra chiamato `ann` del tipo generico `T`, che può essere riempito con qualsiasi tipo che implementi il trait `Display` come specificato dalla clausola `where`. Questo parametro extra verrà stampato utilizzando `{}`, motivo per cui il constraint del trait `Display` è necessario. Poiché i lifetimes sono un tipo di generico, le dichiarazioni del parametro di lifetime `'a` e del parametro di tipo generico `T` vanno nella stessa lista all'interno delle parentesi angolari dopo il nome della funzione.

## Riepilogo

Abbiamo trattato molto in questo capitolo! Ora che sai dei parametri di tipo generici, traits e vincoli di trait, e parametri di lifetime generici, sei pronto per scrivere codice senza ripetizione che funziona in molte situazioni diverse. I parametri di tipo generico ti permettono di applicare il codice a tipi diversi. I traits e i vincoli di trait assicurano che anche se i tipi sono generici, avranno il comportamento di cui il codice ha bisogno. Hai imparato come usare le annotazioni di lifetime per garantire che questo codice flessibile non abbia alcuna reference dangling. E tutta questa analisi avviene al momento della compilazione, il che non influenza le prestazioni del runtime!

Che tu ci creda o no, c'è molto altro da imparare sugli argomenti che abbiamo discusso in questo capitolo: il Capitolo 17 discute gli oggetti trait, che sono un altro modo di usare i traits. Ci sono anche scenari più complessi che coinvolgono le annotazioni di lifetime che avrai bisogno solo in scenari molto avanzati; per quelli, dovresti leggere il [Rust Reference][reference]. Ma ora imparerai come scrivere test in Rust per assicurarti che il tuo codice funzioni come dovrebbe.

[references-and-borrowing]:
ch04-02-references-and-borrowing.html#references-and-borrowing
[string-slices-as-parameters]:
ch04-03-slices.html#string-slices-as-parameters
[reference]: ../reference/index.html
