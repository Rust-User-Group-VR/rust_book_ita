## Validare le Riferimenti con i Lifetimes

I Lifetimes sono un altro tipo di generico che abbiamo già utilizzato. Piuttosto
che garantire che un tipo abbia il comportamento desiderato, i lifetimes garantiscono che
i riferimenti siano validi tanto a lungo quanto necessario.

Un dettaglio che non abbiamo discusso nella sezione ["References and
Borrowing"][references-and-borrowing]<!-- ignore --> nel Capitolo 4 è
che ogni riferimento in Rust ha un *lifetime*, che è l'ambito per cui
quel riferimento è valido. La maggior parte delle volte, i lifetimes sono impliciti e dedotti,
proprio come la maggior parte delle volte, i tipi sono dedotti. Dobbiamo annotare i tipi solo
quando sono possibili tipi multipli. In modo simile, dobbiamo annotare i lifetimes
quando i lifetimes dei riferimenti potrebbero essere correlati in alcuni modi diversi. Rust
ci richiede di annotare le relazioni usando parametri lifetime generici per
garantire che i riferimenti effettivi utilizzati a runtime saranno sicuramente validi.

Annotare i lifetimes non è un concetto che la maggior parte degli altri linguaggi di programmazione ha, quindi
questo sembrerà poco familiare. Sebbene non copriremo i lifetimes nella loro
interezza in questo capitolo, discuteremo dei modi comuni in cui potresti incontrare
la sintassi dei lifetimes così che tu possa familiarizzare con il concetto.

### Prevenire Riferimenti Pendenti con i Lifetimes

Lo scopo principale dei lifetimes è prevenire i *riferimenti pendenti*, che causano a
program di riferirsi a dati diversi dai dati che intende referenziare.
Considera il programma in Listing 10-16, che ha un ambito esterno e un ambito
interno.

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-16/src/main.rs}}
```

<span class="caption">Listing 10-16: Un tentativo di usare un riferimento il cui valore
è uscito dall'ambito</span>

> Nota: Gli esempi nei Listing 10-16, 10-17, e 10-23 dichiarano variabili
> senza assegnare loro un valore iniziale, così il nome della variabile esiste nell'ambito esterno.
> A prima vista, questo potrebbe sembrare in conflitto con il fatto che Rust non abbia
> valori nulli. Tuttavia, se proviamo a utilizzare una variabile prima di assegnarle un valore,
> otterremo un errore a tempo di compilazione, il che dimostra che Rust non permette
> effettivamente valori nulli.

L'ambito esterno dichiara una variabile chiamata `r` senza valore iniziale, e l'ambito
interno dichiara una variabile chiamata `x` con valore iniziale di `5`. All'interno
dell'ambito interno, tentiamo di assegnare il valore di `r` come riferimento a `x`. Poi
l'ambito interno termina, e tentiamo di stampare il valore in `r`. Questo codice non
compila perché il valore a cui `r` si riferisce è uscito dall'ambito prima
che proviamo a usarlo. Ecco il messaggio di errore:

```console
{{#include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-16/output.txt}}
```

Il messaggio di errore dice che la variabile `x` "non vive abbastanza a lungo". La
ragione è che `x` sarà fuori dall'ambito quando l'ambito interno termina alla linea 7.
Ma `r` è ancora valido per l'ambito esterno; poiché il suo ambito è più ampio, diciamo
che "vive più a lungo". Se Rust permettesse a questo codice di funzionare, `r` 
farebbe riferimento a memoria che è stata deallocata quando `x` è uscito dall'ambito, e
qualsiasi cosa provassimo a fare con `r` non funzionerebbe correttamente. Quindi come fa
Rust a determinare che questo codice non è valido? Utilizza un borrow checker.

### Il Borrow Checker

Il compilatore Rust ha un *borrow checker* che confronta gli ambiti per determinare
se tutti i prestiti sono validi. Il Listing 10-17 mostra lo stesso codice del
Listing 10-16 ma con annotazioni che mostrano i lifetimes delle variabili.

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-17/src/main.rs}}
```

<span class="caption">Listing 10-17: Annotazioni dei lifetimes di `r` e
`x`, rispettivamente chiamati `'a` e `'b`</span>

Qui, abbiamo annotato il lifetime di `r` con `'a` e il lifetime di `x`
con `'b`. Come puoi vedere, l'ambito interno `'b` è molto più piccolo dell'ambito
lifetime esterno `'a`. A tempo di compilazione, Rust confronta la dimensione dei due
lifetimes e vede che `r` ha un lifetime di `'a` ma fa riferimento a memoria
con un lifetime di `'b`. Il programma viene rigettato perché `'b` è inferiore a
`'a`: il soggetto del riferimento non vive quanto il riferimento.

Il Listing 10-18 risolve il codice così che non ha un riferimento pendente e
compila senza errori.

```rust
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-18/src/main.rs}}
```

<span class="caption">Listing 10-18: Un riferimento valido perché i dati hanno un
lifetime più lungo del riferimento</span>

Qui, `x` ha il lifetime `'b`, che in questo caso è più grande di `'a`. Questo
significa che `r` può riferirsi a `x` perché Rust sa che il riferimento in `r` sarà
sempre valido mentre `x` è valido.

Ora che sai quali sono i lifetimes dei riferimenti e come Rust analizza i
lifetimes per garantire che i riferimenti saranno sempre validi, esploriamo i
lifetimes generici dei parametri e dei valori di ritorno nel contesto delle funzioni.

### Lifetimes Generici nelle Funzioni

Scriveremo una funzione che restituisce la più lunga di due stringhe slices. Questa
funzione prenderà due stringhe slices e restituirà una singola stringa slice. Dopo
aver implementato la funzione `longest`, il codice nel Listing 10-19 dovrebbe
stampare `The longest string is abcd`.

<span class="filename">File: src/main.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-19/src/main.rs}}
```

<span class="caption">Listing 10-19: Una funzione `main` che chiama la funzione `longest`
per trovare la più lunga di due stringhe slices</span>

Nota che vogliamo che la funzione prenda stringhe slices, che sono riferimenti,
piuttosto che stringhe, perché non vogliamo che la funzione `longest` prenda
ownership dei suoi parametri. Consulta la sezione ["String Slices as
Parameters"][string-slices-as-parameters]<!-- ignore --> nel Capitolo 4
per una discussione più dettagliata sul motivo per cui i parametri che utilizziamo nel Listing 10-19 sono
quelli che vogliamo.

Se proviamo a implementare la funzione `longest` come mostrato nel Listing 10-20, essa non
compilerà.

<span class="filename">File: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-20/src/main.rs:here}}
```

<span class="caption">Listing 10-20: Un'implementazione della funzione `longest`
che restituisce la più lunga di due stringhe slices ma non compila ancora</span>

Invece, otteniamo il seguente errore che parla di lifetimes:

```console
{{#include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-20/output.txt}}
```

Il messaggio di aiuto rivela che il tipo di ritorno ha bisogno di un parametro lifetime generico
perché Rust non può dire se il riferimento restituito si riferisce a
`x` o `y`. In realtà, non lo sappiamo nemmeno noi, perché il blocco `if` nel corpo
di questa funzione restituisce un riferimento a `x` e il blocco `else` restituisce un
riferimento a `y`!

Quando stiamo definendo questa funzione, non conosciamo i valori concreti che saranno
passati in questa funzione, quindi non sappiamo se il caso `if` o il
caso `else` sarà eseguito. Non conosciamo nemmeno i lifetimes concreti dei
riferimenti che saranno passati, quindi non possiamo guardare agli ambiti come abbiamo fatto nei
Listings 10-17 e 10-18 per determinare se il riferimento che restituiamo sarà
sempre valido. Neppure il borrow checker può determinarlo, perché non
conosce come i lifetimes di `x` e `y` si relazionano con il lifetime del
valore restituito. Per risolvere questo errore, aggiungeremo parametri lifetime generici che
definiranno la relazione tra i riferimenti in modo che il borrow checker possa
eseguire la sua analisi.

### Sintassi delle Annotazioni dei Lifetimes

Le annotazioni dei lifetimes non cambiano quanto a lungo nessuno dei riferimenti vive. Piuttosto,
descrivono le relazioni dei lifetimes di più riferimenti tra
loro senza influenzare i lifetimes. Proprio come le funzioni possono accettare qualsiasi tipo
quando la firma specifica un parametro tipo generico, le funzioni possono accettare
riferimenti con qualsiasi lifetime specificando un parametro lifetime generico.

Le annotazioni dei lifetimes hanno una sintassi leggermente insolita: i nomi dei parametri
lifetime devono iniziare con un apostrofo (`'`) e solitamente sono tutti in minuscolo
e molto brevi, come i tipi generici. La maggior parte delle persone utilizza il nome `'a`
per la prima annotazione di lifetime. Mettiamo le annotazioni del parametro lifetime dopo il `&` di un
riferimento, utilizzando uno spazio per separare l'annotazione dal tipo del riferimento.

Ecco alcuni esempi: un riferimento a un `i32` senza un parametro lifetime, un
riferimento a un `i32` che ha un parametro lifetime chiamato `'a`, e un riferimento
mutabile a un `i32` che ha anche il lifetime `'a`.

```rust,ignore
&i32        // un riferimento
&'a i32     // un riferimento con un lifetime esplicito
&'a mut i32 // un riferimento mutabile con un lifetime esplicito
```

Un'annotazione di lifetime da sola non ha molto significato perché le
annotazioni sono destinate a dire a Rust come i parametri lifetime generici di più
riferimenti si relazionano tra loro. Esaminiamo come le annotazioni di lifetime
si relazionano tra loro nel contesto della funzione `longest`.

### Annotazioni dei Lifetimes nelle Signature delle Funzioni

Per utilizzare le annotazioni dei lifetimes nelle signature delle funzioni, dobbiamo dichiarare i
parametri generici *lifetime* all'interno delle parentesi angolari tra il nome della funzione
e l'elenco dei parametri, proprio come abbiamo fatto con i parametri generici *tipo*.

Vogliamo che la firma esprima il seguente vincolo: il riferimento restituito sarà
valido fintanto che entrambi i parametri sono validi. Questa è la
relazione tra i lifetimes dei parametri e il valore di ritorno. 
Nomineremo il lifetime `'a` e poi lo aggiungeremo a ciascun riferimento, come mostrato nel Listing
10-21.

<span class="filename">File: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-21/src/main.rs:here}}
```

<span class="caption">Listing 10-21: La definizione della funzione `longest`
che specifica che tutti i riferimenti nella signature devono avere lo stesso lifetime
`'a`</span>

Questo codice dovrebbe compilare e produrre il risultato desiderato quando lo usiamo con la
funzione `main` nel Listing 10-19.

La signature della funzione ora dice a Rust che per un qualche lifetime `'a`, la funzione
prende due parametri, entrambi dei quali sono stringhe slices che vivono almeno tanto quanto
il lifetime `'a`. La signature della funzione dice anche a Rust che la stringa
slice restituita dalla funzione vivrà almeno tanto quanto il lifetime `'a`.
In pratica, significa che il lifetime del riferimento restituito dalla
funzione `longest` è lo stesso del minore tra i lifetimes dei valori riferiti dai
parametri della funzione. Queste relazioni sono quelle che vogliamo
che Rust utilizzi quando analizza questo codice.

Ricorda, quando specifichiamo i parametri lifetime in questa signatura di funzione,
non stiamo cambiando i lifetimes di nessun valore passato o restituito. Piuttosto,
stiamo specificando che il borrow checker dovrebbe rigettare qualsiasi valore che non
aderisce a questi vincoli. Nota che la funzione `longest` non ha bisogno di
sapere esattamente quanto a lungo `x` e `y` vivranno, solo che qualche ambito
può essere sostituito per `'a` che soddisferà questa signatura.

Quando annotiamo i lifetimes nelle funzioni, le annotazioni vanno nella signatura
della funzione, non nel corpo della funzione. Le annotazioni dei lifetimes diventano parte del
contratto della funzione, proprio come i tipi nella signatura. Avere
le signatura delle funzioni che contengono il contratto lifetime significa che
l'analisi che il compilatore Rust fa può essere più semplice. Se c'è un problema con
il modo in cui una funzione è annotata o il modo in cui viene chiamata, gli errori del compilatore possono
puntare con più precisione alla parte del nostro codice che causa i vincoli. Se,
invece, il compilatore Rust facesse più inferenze su ciò che intendiamo che fossero le relazioni
tra i lifetimes, il compilatore potrebbe essere in grado di puntare solo a un uso del nostro
codice molti passaggi lontano dalla causa del problema.

Quando passiamo riferimenti concreti a `longest`, il lifetime concreto che viene
sostituito per `'a` è la parte dell'ambito di `x` che si sovrappone con l'ambito di `y`.
In altre parole, il generic lifetime `'a` avrà il lifetime concreto che è uguale al
minore dei lifetimes di `x` e `y`. Poiché abbiamo annotato il riferimento restituito con
lo stesso parametro lifetime `'a`, il riferimento restituito sarà anche valido per la
durata del minore dei lifetimes di `x` e `y`.

Vediamo come le annotazioni di lifetime limitano la funzione `longest` passando
riferimenti che hanno diversi lifetimes concreti. Il Listing 10-22 è un esempio
semplice.

<span class="filename">File: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-22/src/main.rs:here}}
```

<span class="caption">Listing 10-22: Utilizzare la funzione `longest` con
riferimenti a valori `String` che hanno diversi lifetimes concreti</span>

In questo esempio, `string1` è valido fino alla fine dell'ambito esterno, `string2`
è valido fino alla fine dell'ambito interno, e `result` fa riferimento a qualcosa che
è valido fino alla fine dell'ambito interno. Esegui questo codice e vedrai
che il borrow checker approva; compilerà e stamperà `The longest string
is long string is long`.

Successivamente, proviamo un esempio che mostra che il lifetime del riferimento in
`result` deve essere il minore dei due lifetimes degli argomenti. Sposteremo la
dichiarazione della variabile `result` fuori dall'ambito interno, ma lasceremo
l'assegnazione del valore alla variabile `result` all'interno dell'ambito con
`string2`. Poi sposteremo il `println!` che usa `result` fuori
dall'ambito interno, dopo che l'ambito interno è terminato. Il codice nel Listing 10-23
non compilerà.

<span class="filename">File: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-23/src/main.rs:here}}
```

<span class="caption">Listing 10-23: Tentativo di utilizzare `result` dopo che `string2`
è uscito dall'ambito</span>

Quando proviamo a compilare questo codice, otteniamo questo errore:

```console
{{#include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-23/output.txt}}
```

L'errore mostra che per `result` essere valido per l'istruzione `println!`,
`string2` dovrebbe essere valido fino alla fine dell'ambito esterno. Rust lo
sa perché abbiamo annotato i lifetimes dei parametri della funzione e dei valori di ritorno
utilizzando lo stesso parametro lifetime `'a`.

Come esseri umani, possiamo guardare questo codice e vedere che `string1` è più lunga di
`string2`, quindi `result` conterrà un riferimento a `string1`.
Poiché `string1` non è ancora uscito dall'ambito, un riferimento a `string1` sarà
ancora valido per l'istruzione `println!`. Tuttavia, il compilatore non può vedere
che il riferimento è valido in questo caso. Abbiamo detto a Rust che il lifetime del
riferimento restituito dalla funzione `longest` è lo stesso del minore dei
lifetimes dei riferimenti passati. Pertanto, il borrow checker
disapprova il codicenel Listing 10-23 come potenzialmente contenente un riferimento non valido.

Prova a progettare ulteriori esperimenti che variano i valori e i lifetimes dei
riferimenti passati alla funzione `longest` e come viene utilizzato il riferimento
restituito. Fai ipotesi sul fatto che i tuoi esperimenti supereranno il borrow checker
prima di compilare; poi controlla se hai ragione!

### Pensare in Termini di Lifetimes

Il modo in cui devi specificare i parametri lifetime dipende da ciò che
la tua funzione sta facendo. Ad esempio, se modifichiamo l'implementazione della
funzione `longest` per restituire sempre il primo parametro anziché la stringa slice più lunga,
non avremmo bisogno di specificare un lifetime sul parametro `y`. Il seguente
codice compilerà:

<span class="filename">File: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/no-listing-08-only-one-reference-with-lifetime/src/main.rs:here}}
```


Abbiamo specificato un parametro lifetime `'a` per il parametro `x` e per il tipo di ritorno, ma non per il parametro `y`, perché il lifetime di `y` non ha alcuna relazione con il lifetime di `x` o con il valore di ritorno.

Quando si restituisce un riferimento da una funzione, il parametro lifetime per il tipo di ritorno deve corrispondere al parametro lifetime di uno dei parametri. Se il riferimento restituito non si riferisce a uno dei parametri, deve riferirsi a un valore creato all'interno di questa funzione. Tuttavia, questo sarebbe un riferimento dangling (pendente) perché il valore uscirà dallo scope alla fine della funzione. Considera questa implementazione tentata della funzione `longest` che non compilerà:

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/no-listing-09-unrelated-lifetime/src/main.rs:here}}
```

Qui, anche se abbiamo specificato un parametro lifetime `'a` per il tipo di ritorno, questa implementazione non compilerà perché il lifetime del valore di ritorno non è affatto correlato al lifetime dei parametri. Ecco il messaggio di errore che otteniamo:

```console
{{#include ../listings/ch10-generic-types-traits-and-lifetimes/no-listing-09-unrelated-lifetime/output.txt}}
```

Il problema è che `result` esce dallo scope e viene pulito alla fine della funzione `longest`. Stiamo inoltre cercando di restituire un riferimento a `result` dalla funzione. Non c'è modo di specificare parametri lifetime che cambierebbero il riferimento dangling, e Rust non ci permetterà di creare un riferimento dangling. In questo caso, la migliore correzione sarebbe restituire un tipo di dato posseduto piuttosto che un riferimento, in modo che la funzione chiamante sia poi responsabile della pulizia del valore.

In definitiva, la sintassi dei lifetime riguarda connettere i lifetime dei vari parametri e valori di ritorno delle funzioni. Una volta connessi, Rust ha abbastanza informazioni per consentire operazioni sicure in memoria e disabilitare operazioni che creerebbero puntatori dangling o violerebbero in altro modo la sicurezza della memoria.

### Annotazioni di Lifetime nelle Definizioni delle Struct

Finora, le struct che abbiamo definito contengono tutti tipi posseduti. Possiamo definire struct per contenere riferimenti, ma in tal caso dovremmo aggiungere un'annotazione di lifetime su ogni riferimento nella definizione della struct. Listing 10-24 contiene una struct chiamata `ImportantExcerpt` che contiene una string slice.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-24/src/main.rs}}
```

<span class="caption">Listing 10-24: Una struct che contiene un riferimento, richiedendo una annotazione di lifetime</span>

Questa struct ha il campo unico `part` che contiene una string slice, che è un riferimento. Come con i tipi di dati generici, dichiariamo il nome del parametro lifetime generico tra parentesi angolari dopo il nome della struct in modo da poter usare il parametro lifetime nel corpo della definizione della struct. Questa annotazione significa che un'istanza di `ImportantExcerpt` non può vivere più a lungo del riferimento che contiene nel campo `part`.

La funzione `main` qui crea un'istanza della struct `ImportantExcerpt` che contiene un riferimento alla prima frase del `String` posseduto dalla variabile `novel`. I dati in `novel` esistono prima della creazione dell'istanza di `ImportantExcerpt`. Inoltre, `novel` non esce dallo scope fino a quando anche `ImportantExcerpt` non esce dallo scope, quindi il riferimento nell'istanza di `ImportantExcerpt` è valido.

### Omissione del Lifetime

Hai appreso che ogni riferimento ha un lifetime e che devi specificare parametri lifetime per funzioni o struct che usano riferimenti. Tuttavia, avevamo una funzione nel Listing 4-9, mostrata di nuovo nel Listing 10-25, che compilava senza annotazioni di lifetime.

<span class="filename">Nome del file: src/lib.rs</span>

```rust
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-25/src/main.rs:here}}
```

<span class="caption">Listing 10-25: Una funzione che abbiamo definito nel Listing 4-9 che compilava senza annotazioni di lifetime, anche se il parametro e il tipo di ritorno sono riferimenti</span>

Il motivo per cui questa funzione compila senza annotazioni di lifetime è storico: nelle prime versioni (pre-1.0) di Rust, questo codice non avrebbe compilato perché ogni riferimento necessitava di un lifetime esplicito. A quel tempo, la firma della funzione sarebbe stata scritta così:

```rust,ignore
fn first_word<'a>(s: &'a str) -> &'a str {
```

Dopo aver scritto molto codice Rust, il team di Rust ha scoperto che i programmatori Rust inserivano ripetutamente le stesse annotazioni di lifetime in particolari situazioni. Queste situazioni erano prevedibili e seguivano alcuni schemi deterministici. Gli sviluppatori hanno programmato questi schemi nel codice del compilatore in modo che il borrow checker potesse inferire i lifetime in queste situazioni e non avrebbe bisogno di annotazioni esplicite.

Questo pezzo di storia di Rust è rilevante perché è possibile che emergano più schemi deterministici e vengano aggiunti al compilatore. In futuro, potrebbero essere richieste ancora meno annotazioni di lifetime.

Gli schemi programmati nell'analisi dei riferimenti di Rust sono chiamati *regole di omissione del lifetime*. Queste non sono regole che i programmatori devono seguire; sono un insieme di casi particolari che il compilatore considererà, e se il tuo codice si adatta a questi casi, non devi scrivere esplicitamente i lifetime.

Le regole di omissione non forniscono un'inferenza completa. Se l’ambiguità rimane riguardo ai lifetime dei riferimenti dopo che Rust ha applicato le regole, il compilatore non indovinerà quale debba essere il lifetime dei riferimenti rimanenti. Invece di indovinare, il compilatore ti darà un errore che puoi risolvere aggiungendo le annotazioni di lifetime.

I lifetime sui parametri delle funzioni o dei metodi sono chiamati *input lifetimes*, e i lifetime sui valori di ritorno sono chiamati *output lifetimes*.

Il compilatore utilizza tre regole per determinare i lifetime dei riferimenti quando non ci sono annotazioni esplicite. La prima regola si applica ai lifetime di input, e la seconda e terza regola si applicano agli output lifetimes. Se il compilatore arriva alla fine delle tre regole e ci sono ancora riferimenti per i quali non può determinare i lifetime, il compilatore si interromperà con un errore. Queste regole si applicano sia alle definizioni `fn` che ai blocchi `impl`.

La prima regola è che il compilatore assegna un parametro lifetime a ciascun parametro che è un riferimento. In altre parole, una funzione con un parametro ottiene un parametro lifetime: `fn foo<'a>(x: &'a i32)`; una funzione con due parametri ottiene due parametri lifetime separati: `fn foo<'a, 'b>(x: &'a i32, y: &'b i32)`; e così via.

La seconda regola è che, se c’è esattamente un parametro di input lifetime, quel lifetime viene assegnato a tutti i parametri output lifetime: `fn foo<'a>(x: &'a i32) -> &'a i32`.

La terza regola è che, se ci sono più parametri di input lifetime, ma uno di questi è `&self` o `&mut self` perché questo è un metodo, il lifetime di `self` viene assegnato a tutti i parametri output lifetime. Questa terza regola rende molto più leggibili e scrivibili i metodi perché sono necessari meno simboli.

Facciamo finta di essere il compilatore. Applicheremo queste regole per determinare i lifetime dei riferimenti nella firma della funzione `first_word` nel Listing 10-25. La firma inizia senza lifetime associati ai riferimenti:

```rust,ignore
fn first_word(s: &str) -> &str {
```

Poi il compilatore applica la prima regola, che specifica che ogni parametro ottiene il proprio lifetime. Lo chiameremo `'a` come al solito, quindi ora la firma è questa:

```rust,ignore
fn first_word<'a>(s: &'a str) -> &str {
```

La seconda regola si applica perché c’è esattamente un parametro di input lifetime. La seconda regola specifica che il lifetime dell’unico parametro di input viene assegnato all'output lifetime, quindi la firma è ora questa:

```rust,ignore
fn first_word<'a>(s: &'a str) -> &'a str {
```

Ora tutti i riferimenti in questa firma di funzione hanno lifetime, e il compilatore può continuare la sua analisi senza bisogno che il programmatore annoti i lifetime in questa firma di funzione.

Guardiamo un altro esempio, questa volta usando la funzione `longest` che non aveva parametri lifetime quando abbiamo iniziato a lavorare con essa nel Listing 10-20:

```rust,ignore
fn longest(x: &str, y: &str) -> &str {
```

Applichiamo la prima regola: ogni parametro ottiene il proprio lifetime. Stavolta abbiamo due parametri invece di uno, quindi abbiamo due lifetime:

```rust,ignore
fn longest<'a, 'b>(x: &'a str, y: &'b str) -> &str {
```

Puoi vedere che la seconda regola non si applica perché ci sono più di un lifetime di input. La terza regola non si applica nemmeno, perché `longest` è una funzione piuttosto che un metodo, quindi nessuno dei parametri è `self`. Dopo aver esaminato tutte e tre le regole, non abbiamo ancora determinato quale sia il lifetime del tipo di ritorno. Questo è il motivo per cui abbiamo avuto un errore tentando di compilare il codice nel Listing 10-20: il compilatore ha applicato le regole di omissione del lifetime ma non è riuscito a determinare tutti i lifetime dei riferimenti nella firma.

Poiché la terza regola si applica realmente solo alle firme dei metodi, esamineremo i lifetime in quel contesto successivamente per vedere perché la terza regola significa che non dobbiamo spesso annotare i lifetime nelle firme dei metodi.

### Annotazioni di Lifetime nelle Definizioni dei Metodi

Quando implementiamo metodi su una struct con dei lifetime, usiamo la stessa sintassi dei parametri di tipo generico mostrati nel Listing 10-11. Dove dichiariamo e utilizziamo i parametri lifetime dipende dal fatto che siano correlati ai campi della struct o ai parametri e valori di ritorno del metodo.

I nomi dei lifetime per i campi delle struct devono sempre essere dichiarati dopo la parola chiave `impl` e poi utilizzati dopo il nome della struct perché quei lifetime fanno parte del tipo della struct.

Nelle firme dei metodi all'interno del blocco `impl`, i riferimenti potrebbero essere legati al lifetime dei riferimenti nei campi della struct, oppure potrebbero essere indipendenti. Inoltre, le regole di omissione del lifetime spesso fanno sì che le annotazioni di lifetime non siano necessarie nelle firme dei metodi. Esaminiamo alcuni esempi usando la struct chiamata `ImportantExcerpt` che abbiamo definito nel Listing 10-24.

Per prima cosa useremo un metodo chiamato `level` il cui unico parametro è un riferimento a `self` e il cui valore di ritorno è un `i32`, che non è un riferimento a nulla:

```rust
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/no-listing-10-lifetimes-on-methods/src/main.rs:1st}}
```

La dichiarazione del parametro lifetime dopo `impl` e il suo uso dopo il nome del tipo sono richiesti, ma non siamo obbligati ad annotare il lifetime del riferimento a `self` a causa della prima regola di omissione.

Ecco un esempio in cui si applica la terza regola di omissione del lifetime:

```rust
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/no-listing-10-lifetimes-on-methods/src/main.rs:3rd}}
```

Ci sono due lifetime di input, quindi Rust applica la prima regola di omissione del lifetime e assegna a entrambe `&self` e `announcement` i loro lifetime. Poi, poiché uno dei parametri è `&self`, il tipo di ritorno ottiene il lifetime di `&self`, e tutti i lifetime sono stati contabilizzati.

### Il Lifetime Statico

Un lifetime speciale di cui dobbiamo discutere è `'static`, che indica che il riferimento interessato può vivere per l'intera durata del programma. Tutti i letterali di stringa hanno il lifetime `'static`, che possiamo annotare come segue:

```rust
let s: &'static str = "I have a static lifetime.";
```

Il testo di questa stringa è memorizzato direttamente nel binario del programma, che è sempre disponibile. Pertanto, il lifetime di tutti i letterali di stringa è `'static`.

Potresti vedere suggerimenti per usare il lifetime `'static` nei messaggi di errore. Ma prima di specificare `'static` come lifetime per un riferimento, pensa se il riferimento che hai effettivamente vive per l'intera durata del tuo programma o no, e se lo vuoi. La maggior parte delle volte, un messaggio di errore che suggerisce il lifetime `'static` risulta dal tentativo di creare un riferimento pendente o un mismatch dei lifetime disponibili. In tali casi, la soluzione è risolvere questi problemi, non specificare il lifetime `'static`.

## Parametri di Tipo Generico, Trait Bounds, e Lifetimes Insieme

Diamo una breve occhiata alla sintassi di specificare parametri di tipo generico, trait bounds e lifetimes tutti in una funzione!

```rust
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/no-listing-11-generics-traits-and-lifetimes/src/main.rs:here}}
```

Questa è la funzione `longest` del Listing 10-21 che restituisce la slice di stringa più lunga. Ma ora ha un parametro extra chiamato `ann` del tipo generico `T`, che può essere riempito da qualsiasi tipo che implementa il trait `Display` come specificato dalla clausola `where`. Questo parametro extra sarà stampato usando `{}`, motivo per cui il trait bound `Display` è necessario. Poiché i lifetime sono un tipo di generico, le dichiarazioni del parametro lifetime `'a` e del parametro di tipo generico `T` vanno nella stessa lista all'interno delle parentesi angolari dopo il nome della funzione.

## Riepilogo

Abbiamo coperto molto in questo capitolo! Ora che sai sui parametri di tipo generico, trait e trait bounds, e parametri di lifetime generici, sei pronto a scrivere codice senza ripetizioni che funziona in molte situazioni diverse. I parametri di tipo generico ti permettono di applicare il codice a tipi differenti. I trait e trait bounds assicurano che anche se i tipi sono generici, avranno il comportamento che il codice richiede. Hai imparato come utilizzare le annotazioni di lifetime per assicurarti che questo codice flessibile non avrà riferimenti pendenti. E tutta questa analisi avviene in fase di compilazione, il che non influisce sulle prestazioni runtime!

Credici o no, c'è molto di più da imparare sugli argomenti discussi in questo capitolo: il Capitolo 17 discute degli oggetti trait, che sono un altro modo per usare i trait. Ci sono anche scenari più complessi che coinvolgono annotazioni di lifetime che avrai bisogno solo in scenari molto avanzati; per quelli, dovresti leggere il [Riferimento Rust][reference]. Ma ora, imparerai come scrivere test in Rust in modo da poter assicurarti che il tuo codice funzioni come dovrebbe.

[references-and-borrowing]:
ch04-02-references-and-borrowing.html#references-and-borrowing
[string-slices-as-parameters]:
ch04-03-slices.html#string-slices-as-parameters
[reference]: ../reference/index.html
