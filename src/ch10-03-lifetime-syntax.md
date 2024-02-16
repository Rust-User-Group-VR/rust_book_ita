## Convalidazione dei References con le Lifetimes

Le Lifetimes sono un altro tipo di generico che abbiamo già utilizzato. Piuttosto
che garantire che un tipo abbia il comportamento che desideriamo, le Lifetimes assicurano che
i references siano validi per tutto il tempo di cui abbiamo bisogno.

Un dettaglio che non abbiamo discusso nella sezione [“References and
Borrowing”][references-and-borrowing]<!-- ignore --> nel Capitolo 4 è
che ogni reference in Rust ha una *Lifetime*, che è l'ambito per il quale
quel reference è valido. La maggior parte del tempo, le Lifetimes sono implicite e inferite,
proprio come la maggior parte del tempo, i tipi sono inferiti. Dobbiamo solo annotare i tipi
quando sono possibili più tipi. Allo stesso modo, dobbiamo annotare le Lifetimes
quando le Lifetimes dei references potrebbero essere correlate in diversi modi. Rust
ci richiede di annotare le relazioni utilizzando parametri Lifetime generici per
assicurare che i references effettivamente usati a runtime saranno sicuramente validi.

L'annotazione delle Lifetimes non è un concetto che la maggior parte degli altri linguaggi di programmazione
hanno, quindi questo sembrerà non familiare. Anche se non tratteremo le Lifetimes in
la loro interezza in questo capitolo, discuteremo i modi comuni in cui potreste incontrare
la sintassi delle Lifetime in modo da potervi familiarizzare con il concetto.

### Prevenzione dei Dangling References con le Lifetimes

L'obiettivo principale delle Lifetimes è prevenire i *dangling references*, che causano a
un programma di fare riferimento a dati diversi da quelli a cui è destinato a fare riferimento.
Considera il programma in Listing 10-16, che ha un ambito esterno e uno interno.

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-16/src/main.rs}}
```

<span class="caption">Listing 10-16: Un tentativo di utilizzare un reference il cui valore
è uscito dall'ambito</span>

> Nota: Gli esempi nei Listings 10-16, 10-17, e 10-23 dichiarano variabili
> senza dare loro un valore iniziale, quindi il nome della variabile esiste nell'
> ambito esterno. A prima vista, questo potrebbe sembrare in conflitto con il fatto che Rust
> non abbia valori nulli. Tuttavia, se proviamo ad usare una variabile prima di dargli un
> valore, otterremo un errore a tempo di compilazione, il che dimostra che Rust infatti non
> permette valori nulli.

L'ambito esterno dichiara una variabile chiamata `r` senza valore iniziale, e il
ambito interno dichiara una variabile chiamata `x` con il valore iniziale di 5. All'interno
dell'ambito interno, tentiamo di impostare il valore di `r` come un reference a `x`. Poi
l'ambito interno termina, e tentiamo di stampare il valore in `r`. Questo codice non
vorrà compilare perché ciò a cui il valore `r` si riferisce è uscito dall'ambito prima che proviamo
ad usarlo. Ecco il messaggio di errore:

```console
{{#include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-16/output.txt}}
```

La variabile `x` non "vive abbastanza a lungo." Il motivo è che `x` sarà fuori
dall'ambito quando l'ambito interno termina alla linea 7. Ma `r`è ancora valido per l'
ambito esterno; perché il suo ambito è più grande, diciamo che "vive più a lungo". Se
Rust permettesse a questo codice di funzionare, `r` farebbe riferimento alla memoria che è stata
deallocata quando `x` è uscito dall'ambito, e tutto ciò che avremmo provato a fare con `r`
non funzionerebbe correttamente. Quindi come fa Rust a determinare che questo codice è invalido?
Utilizza un borrow checker.

### Il Borrow Checker

Il compilatore di Rust ha un *borrow checker* che confronta gli ambiti per determinare
se tutti i prestiti sono validi. Il Listing 10-17 mostra lo stesso codice del Listing
10-16 ma con le annotazioni che mostrano le Lifetimes delle variabili.

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-17/src/main.rs}}
```

<span class="caption">Listing 10-17: Annotazioni delle Lifetimes di `r` e di
`x`, chiamate rispettivamente `'a` e `'b`</span>

Qui, abbiamo annotato la Lifetime di `r` con `'a` e la Lifetime di `x`
con `'b`. Come potete vedere, il blocco interno `'b` è molto più piccolo del blocco di Lifetime esterno
`'a`. Al momento della compilazione, Rust confronta le dimensioni delle due
Lifetimes e vede che `r` ha una Lifetime di `'a` ma che si riferisce alla memoria con una Lifetime di `'b`. Il programma viene respinto perché `'b` è più corto di `'a`:
il soggetto del reference non vive tanto quanto il reference.

Il Listing 10-18 corregge il codice in modo che non abbia un dangling reference e
compila senza alcun errore.

```rust
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-18/src/main.rs}}
```

<span class="caption">Listing 10-18: Un reference valido perché i dati hanno una
Lifetime più lunga del reference</span>

Qui, `x` ha la Lifetime `'b`, che in questo caso è più grande di `'a`. Questo significa `r` può fare riferimento a `x` perché Rust sa che il reference in `r` sarà sempre valido mentre `x` è valido.

Ora che sapete dove si trovano le Lifetimes dei references e come Rust analizza
le Lifetimes per garantire che i references saranno sempre validi, esploriamo le Lifetimes generiche
dei parametri e dei valori di ritorno nel contesto delle funzioni.

### Lifetimes Generiche nelle Funzioni

Scriveremo una funzione che restituisce la più lunga di due string slices. Questa
funzione prenderà due string slices e restituirà una sola string slice. Dopo
che avremo implementato la funzione `longest`, il codice nel Listing 10-19 dovrebbe
stampare `The longest string is abcd`.

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-19/src/main.rs}}
```

<span class="caption">Listing 10-19: Una funzione `main` che chiama la funzione `longest`
per trovare la più lunga tra due string slices</span>

Nota che vogliamo che la funzione prenda string slices, che sono references,
anziché strings, perché non vogliamo che la funzione `longest` prenda
ownership dei suoi parametri. Fare riferimento alla sezione [“String Slices as
Parameters”][string-slices-as-parameters]<!-- ignore --> nel Capitolo 4
per una discussione più approfondita su perché i parametri che usiamo nel Listing 10-19 sono quelli
che vogliamo.

Se proviamo ad implementare la funzione `longest` come mostrato nel Listing 10-20, non
vorrà compilare.

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-20/src/main.rs:here}}
```

<span class="caption">Listing 10-20: Un'implementazione della funzione `longest`
che restituisce la più lunga tra due string slices, ma che ancora non
compila</span>

Invece, otteniamo il seguente errore che parla di Lifetimes:

```console
{{#include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-20/output.txt}}
```

Il testo di aiuto rivela che il tipo di ritorno ha bisogno di un parametro Lifetime generico
su di esso perché Rust non può dire se il reference che viene restituito si riferisce a
`x` o `y`. In realtà, nemmeno noi lo sappiamo, perché il blocco `if` nel corpo
di questa funzione restituisce un reference a `x` e il blocco `else` restituisce un
reference a `y`!
Quando stiamo definendo questa funzione, non conosciamo i valori concreti che saranno passati a questa funzione, quindi non sappiamo se verrà eseguito il caso `if` o il caso `else`. Non conosciamo nemmeno le durate concrete dei riferimenti che saranno passati, quindi non possiamo guardare gli scope come abbiamo fatto nelle Liste 10-17 e 10-18 per determinare se il riferimento che restituiamo sarà sempre valido. Il borrow checker non può determinare nemmeno questo, perché non sa come le duration di `x` e `y` si relazionano con la durata del valore restituito. Per correggere questo errore, aggiungeremo parametri di durata generici che definiscono la relazione tra i riferimenti in modo che il borrow checker possa eseguire la sua analisi.

### Sintassi delle annotazioni di durata

Le annotazioni di durata non cambiano quanto tempo vivono i riferimenti. Piuttosto, descrivono le relazioni delle durate di molti riferimenti tra loro senza influenzare le durate. Proprio come le funzioni possono accettare qualsiasi tipo quando la firma specifica un parametro di tipo generico, le funzioni possono accettare riferimenti con qualsiasi durata specificando un parametro di durata generico.

Le annotazioni di durata hanno una sintassi leggermente insolita: i nomi dei parametri di durata devono iniziare con un apostrofo (`'`) e sono solitamente tutti in minuscolo e molto corti, come i tipi generici. La maggior parte delle persone usa il nome `'a` per la prima annotazione di durata. Inseriamo le annotazioni del parametro di durata dopo l'`&` di un riferimento, usando uno spazio per separare l'annotazione dal tipo del riferimento.

Ecco alcuni esempi: un riferimento a un `i32` senza un parametro di durata, un riferimento a un `i32` che ha un parametro di durata chiamato `'a`, e un riferimento mutabile a un `i32` che ha anche la durata `'a`.

```rust,ignore
&i32        // un riferimento
&'a i32     // un riferimento con una durata esplicita
&'a mut i32 // un riferimento mutabile con una durata esplicita
```

Una sola annotazione di durata di per sé non ha molto significato, perché le annotazioni servono a dire a Rust come i parametri di durata generici di molti riferimenti si relazionano tra loro. Esaminiamo come le annotazioni di durata si relazionano tra loro nel contesto della funzione `longest`.

### Annotazioni di durata nelle firme delle funzioni

Per utilizzare le annotazioni di durata nelle firme delle funzioni, dobbiamo dichiarare i parametri di *durata* generici all'interno di parentesi angolari tra il nome della funzione e l'elenco dei parametri, proprio come abbiamo fatto con i parametri di *tipo* generici.

Vogliamo che la firma esprima la seguente limitazione: il riferimento restituito sarà valido finché entrambi i parametri sono validi. Questa è la relazione tra le durate dei parametri e il valore restituito. Chiameremo la durata `'a` e poi la aggiungeremo a ciascun riferimento, come mostrato nella Lista 10-21.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-21/src/main.rs:here}}
```

<span class="caption">Lista 10-21: La definizione della funzione `longest` specifica che tutti i riferimenti nella firma devono avere la stessa durata `'a`</span>

Questo codice dovrebbe compilarsi e produrre il risultato che vogliamo quando lo usiamo con la funzione `main` nella Lista 10-19.

La firma della funzione ora dice a Rust che per una certa durata `'a`, la funzione prende due parametri, entrambi dei quali sono string slices che vivono almeno tanto quanto la durata `'a`. La firma della funzione dice anche a Rust che la string slice restituita dalla funzione vivrà almeno tanto quanto la durata `'a`. In pratica, significa che la durata del riferimento restituito dalla funzione `longest` è la stessa della durata più piccola dei valori a cui si riferiscono gli argomenti della funzione. Queste relazioni sono quelle che vogliamo che Rust usi quando analizza questo codice.

Ricorda, quando specificiamo i parametri di durata in questa firma della funzione, non stiamo cambiando le durate di nessun valore passato o restituito. Piuttosto, stiamo specificando che il borrow checker dovrebbe rigettare qualsiasi valore che non aderisce a questi vincoli. Notate che la funzione `longest` non ha bisogno di sapere esattamente quanto tempo vivranno `x` e `y`, solo che per `'a` può essere sostituito uno scope che soddisfi questa firma.

Quando annotiamo le durate nelle funzioni, le annotazioni vanno nella firma della funzione, non nel corpo della funzione. Le annotazioni di durata diventano parte del contratto della funzione, molto come i tipi nella firma. Avere le firme delle funzioni che contengono il contratto di durata significa che l'analisi che fa il compilatore Rust può essere più semplice. Se c'è un problema con il modo in cui una funzione è annotata o con il modo in cui è chiamata, gli errori del compilatore possono puntare alla parte del nostro codice e ai vincoli più precisamente. Se, invece, il compilatore Rust facesse più inferenze su quello che intendevamo fossero le relazioni delle durate, il compilatore potrebbe solo essere in grado di puntare a un uso del nostro codice molti passi lontano dalla causa del problema.

Quando passiamo riferimenti concreti a `longest`, la durata concreta che viene sostituita per `'a` è la parte dello scope di `x` che si sovrappone allo scope di `y`. In altre parole, la durata generica `'a` otterrà la durata concreta che è uguale alla più piccola delle durate di `x` e `y`. Poiché abbiamo annotato il riferimento restituito con lo stesso parametro di durata `'a`, il riferimento restituito sarà anche valido per la lunghezza della più piccola delle durate di `x` e `y`.

Diamo un'occhiata a come le annotazioni di durata limitano la funzione `longest` passando riferimenti che hanno durate concrete diverse. La Lista 10-22 è un esempio semplice.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-22/src/main.rs:here}}
```

<span class="caption">Lista 10-22: Uso della funzione `longest` con riferimenti a valori `String` che hanno durate concrete diverse</span>

In questo esempio, `string1` è valido fino alla fine dello scope esterno, `string2` è valido fino alla fine dello scope interno, e `result` fa riferimento a qualcosa che è valido fino alla fine dello scope interno. Esegui questo codice, e vedrai che il borrow checker approva; si compila e stampa `La stringa più lunga è lunga stringa è lunga`.

Prossimo, proviamo un esempio che mostra che la durata del riferimento in `result` deve essere la durata più piccola dei due argomenti. Spostiamo la dichiarazione della variabile `result` fuori dallo scope interno, ma lasciamo l'assegnazione del valore alla variabile `result` all'interno dello scope con `string2`. Poi spostiamo la `println!` che usa `result` all'esterno dello scope interno, dopo che lo scope interno è finito. Il codice nella Lista 10-23 non si compilerà.

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-23/src/main.rs:here}}
```

<span class="caption">Lista 10-23: Tentativo di utilizzare `result` dopo che `string2` è uscito dallo scope</span>

Quando proviamo a compilare questo codice, otteniamo questo errore:

```console
{{#include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-23/output.txt}}
```

L'errore mostra che per `result` per essere valido per l'affermazione `println!`, `string2` dovrebbe essere valido fino alla fine dello scope esterno. Rust lo sa perché abbiamo annotato le durate dei parametri della funzione e i valori di ritorno usando lo stesso parametro di durata `'a`.

Come esseri umani, possiamo guardare questo codice e vedere che `string1` è più lunga di
`string2` e quindi `result` conterrà un riferimento a `string1`.
Poiché `string1` non è ancora fuori ambito, un riferimento a `string1` sarà
ancora valido per l'istruzione `println!`. Tuttavia, il compilatore non può vedere
che il riferimento è valido in questo caso. Abbiamo detto a Rust che la durata della
il riferimento restituito dalla funzione `longest` è lo stesso del minore dei
vite dei riferimenti passati. Pertanto, il Borrow Checker
non consente il codice in Listing 10-23 come possibilmente avendo un riferimento non valido.

Prova a progettare altri esperimenti che variano i valori e le durate di vita dei
riferimenti passati alla funzione `longest` e come viene utilizzato il riferimento restituito.
Fai ipotesi su se i tuoi esperimenti supereranno il Borrow Checker prima di compilare; quindi verifica per vedere se hai ragione!

### Pensare in termini di Lifetime

Il modo in cui è necessario specificare i parametri di durata della vita dipende da ciò che fa la tua
funzione sta facendo. Ad esempio, se cambiamo l'implementazione del
funzione `longest` per restituire sempre il primo parametro piuttosto che il più lungo
String Slice, non avremmo bisogno di specificare una durata della vita sul parametro `y`. Il
il seguente codice compila:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/no-listing-08-only-one-reference-with-lifetime/src/main.rs:here}}
```

Abbiamo specificato un parametro di durata della vita `'a` per il parametro `x` e il ritorno
tipo, ma non per il parametro `y`, perché la durata della vita di `y` non ha
nessuna relazione con la durata della vita di `x` o il valore di ritorno.

Quando si restituisce un riferimento da una funzione, il parametro di durata della vita per il
il tipo di ritorno deve corrispondere al parametro di durata della vita per uno dei parametri. Se
il riferimento restituito non si riferisce a uno dei parametri, deve fare riferimento
a un valore creato all'interno di questa funzione. Tuttavia, questo sarebbe un appeso
riferimento perché il valore andrà fuori ambito alla fine della funzione.
Considera questa tentativa di implementazione della funzione `longest` che non lo farà
compilare:

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/no-listing-09-unrelated-lifetime/src/main.rs:here}}
```

Qui, anche se abbiamo specificato un parametro di durata della vita `'a` per il ritorno
tipo, questa implementazione non compilerà perché la durata della vita del valore di ritorno
non è affatto correlato alla durata della vita dei parametri. Ecco il
messaggio di errore che otteniamo:

```console
{{#include ../listings/ch10-generic-types-traits-and-lifetimes/no-listing-09-unrelated-lifetime/output.txt}}
```

Il problema è che `result` esce dall'ambito e viene pulito alla fine
della funzione `longest`. Stiamo anche cercando di restituire un riferimento a `result`
dalla funzione. Non c'è modo in cui possiamo specificare i parametri di durata della vita che
cambierebbe il riferimento appeso, e Rust non ci permetterà di creare un appeso
riferimento. In questo caso, la migliore soluzione sarebbe restituire un posseduto tipo di dati
piuttosto che un riferimento in modo che la funzione chiamante sia poi responsabile per
pulire il valore.

In definitiva, la sintassi di durata della vita riguarda la connessione delle durata della vita di vari
parametri e valori di ritorno delle funzioni. Una volta che sono connessi, Rust ha
abbastanza informazioni per consentire operazioni sicure sulla memoria e non consentire operazioni che
creerebbe puntatori appesi o altrimenti violerebbe la sicurezza della memoria.

### Annotazioni di Lifetime nelle definizioni di Struct

Finora, gli Struct che abbiamo definito contengono tutti tipi di proprietà. Possiamo definire Struct per
tenere riferimenti, ma in quel caso dovremmo aggiungere un'annotazione di durata della vita su ogni riferimento nella definizione dello Struct. Listing 10-24 ha uno Struct chiamato
`ImportantExcerpt` che contiene una string slice.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-24/src/main.rs}}
```

<span class="caption">Listing 10-24: Un Struct che contiene un riferimento, richiedendo
una annotazione di durata della vita</span>

Questo Struct ha il singolo campo `part` che contiene una string slice, che è un
riferimento. Come per i tipi di dati generici, dichiariamo il nome del generico
parametro di durata della vita all'interno delle parentesi angolari dopo il nome dello Struct quindi possiamo
utilizzare il parametro di durata della vita nel corpo della definizione dello Struct. Questo
l'annotazione significa che un'istanza di `ImportantExcerpt` non può sopravvivere al riferimento
che detiene nel suo campo `part`.

La funzione `main` qui crea un'istanza dello Struct `ImportantExcerpt`
che contiene un riferimento alla prima frase del `String` posseduto dal
variabile `novel`. I dati in `novel` esistono prima della `ImportantExcerpt`
l'istanza viene creata. Inoltre, `novel` non esce dall'ambito fino a dopo
l'`ImportantExcerpt` esce dall'ambito, quindi il riferimento nel
l'istanza `ImportantExcerpt` è valida.

### Elisione di Lifetime

Hai imparato che ogni riferimento ha una durata della vita e che devi specificare
parametri di durata della vita per funzioni o Struct che usano riferimenti. Tuttavia, in
Capitolo 4 abbiamo avuto una funzione in Listing 4-9, mostrata di nuovo in Listing 10-25, che
compilato senza annotazioni di durata della vita.

<span class="filename">Nome del file: src/lib.rs</span>

```rust
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/listing-10-25/src/main.rs:here}}
```

<span class="caption">Listing 10-25: Una funzione che abbiamo definito in Listing 4-9 che
compilato senza annotazioni di durata della vita, anche se il parametro e il ritorno
tipo sono riferimenti</span>

Il motivo per cui questa funzione compila senza annotazioni di durata della vita è storico:
nelle prime versioni (pre-1.0) di Rust, questo codice non avrebbe compilato perché
ogni riferimento aveva bisogno di una durata della vita esplicita. A quel tempo, la firma della funzione
sarebbe stato scritto così:

```rust,ignore
fn first_word<'a>(s: &'a str) -> &'a str {
```

Dopo aver scritto molto codice Rust, il team Rust ha scoperto che i programmatori Rust
inserivano le stesse annotazioni di durata della vita ancora e ancora in particolari
situazioni. Queste situazioni erano prevedibili e seguivano alcuni modelli deterministici.
Gli sviluppatori hanno programmato questi modelli nel codice del compilatore in modo tale
il Borrow Checker potrebbe dedurre le durata della vita in queste situazioni e non avrebbe
necessitava di annotazioni esplicite.

Questo pezzo di storia Rust è rilevante perché è possibile che più
i modelli deterministici emergeranno e saranno aggiunti al compilatore. In futuro,
potrebbero essere richieste ancora meno annotazioni di durata della vita.

I modelli programmato nell'analisi dei riferimenti di Rust sono chiamati
*regole di elisione della durata della vita*. Queste non sono regole per i programmatori da seguire; sono
un insieme di casi particolari che il compilatore considererà, e se il tuo codice
si adatta a questi casi, non devi scrivere le durata della vita esplicitamente.

Le regole di elisione non forniscono inferenza completa. Se Rust applica deterministicamente
le regole ma c'è ancora ambiguità sulle durata della vita che
i riferimenti hanno, il compilatore non indovinerà quale dovrebbe essere la durata della vita dei restanti
riferimenti. Invece di indovinare, il compilatore ti darà un errore
che puoi risolvere aggiungendo le annotazioni di durata della vita.

Le durate della vita sui parametri della funzione o del metodo sono chiamate *durata della vita in entrata*, e
le durate della vita sui valori di ritorno sono chiamate *durata della vita in uscita*.

Il compilatore utilizza tre regole per capire le durata della vita dei riferimenti
quando non ci sono annotazioni esplicite. La prima regola si applica a in entrata
durata della vita, e la seconda e terza regola si applicano a durata della vita in uscita. Se il
il compilatore arriva alla fine delle tre regole e ci sono ancora riferimenti per
per i quali non riesce a capire le durate della vita, il compilatore si fermerà con un errore.
Queste regole si applicano alle definizioni di `fn` così come ai blocchi `impl`.

La prima regola è che il compilatore assegna un parametro di durata a ciascun
parametro che è un riferimento. In altre parole, una funzione con un parametro ottiene
un parametro di durata: `fn foo<'a>(x: &'a i32)`; una funzione con due
parametri ottiene due parametri di durata separati: `fn foo<'a, 'b>(x: &'a i32,
y: &'b i32)`; e così via.

La seconda regola è che, se esiste esattamente un parametro di durata di input, quella
durata viene assegnata a tutti i parametri di durata di output: `fn foo<'a>(x: &'a i32)
-> &'a i32`.

La terza regola è che, se ci sono più parametri di durata di input, ma
uno di essi è `&self` o `&mut self` perché si tratta di un metodo, la durata di
`self` viene assegnata a tutti i parametri di durata di output. Questa terza regola rende
i metodi molto più piacevoli da leggere e scrivere perché sono necessari meno simboli.

Facciamo finta di essere il compilatore. Applicheremo queste regole per capire le
durate dei riferimenti nella firma della funzione `first_word` in
Elenco 10-25. La firma inizia senza alcuna durata associata con i
riferimenti:

```rust,ignore
fn first_word(s: &str) -> &str {
```

Quindi il compilatore applica la prima regola, che specifica che ogni parametro
ottiene la sua durata. La chiameremo `'a` come al solito, quindi ora la firma è
questa:

```rust,ignore
fn first_word<'a>(s: &'a str) -> &str {
```

La seconda regola si applica perché c'è esattamente una durata di input. La seconda
regola specifica che la durata del parametro di input viene assegnata a
la durata di output, quindi la firma è ora questa:

```rust,ignore
fn first_word<'a>(s: &'a str) -> &'a str {
```

Ora tutti i riferimenti in questa firma di funzione hanno durate, e il
il compilatore può continuare la sua analisi senza bisogno che il programmatore annoti
le durate in questa firma di funzione.

Guardiamo un altro esempio, questa volta utilizzando la funzione `longest` che aveva
nessun parametro di durata quando abbiamo iniziato a lavorarci in Elenco 10-20:

```rust,ignore
fn longest(x: &str, y: &str) -> &str {
```

Applichiamo la prima regola: ogni parametro ottiene la sua durata. Questa volta noi
abbiamo due parametri invece di uno, quindi abbiamo due durate:

```rust,ignore
fn longest<'a, 'b>(x: &'a str, y: &'b str) -> &str {
```

Puoi vedere che la seconda regola non si applica perché c'è più di una
durata di input. Neanche la terza regola si applica, perché `longest` è un
funzione piuttosto che un metodo, quindi nessuno dei parametri è `self`. Dopo
aver lavorato attraverso tutte e tre le regole, non abbiamo ancora capito quale sia la durata del
tipo di ritorno. Questo è il motivo per cui abbiamo ottenuto un errore cercando di compilare il codice in
Elenco 10-20: il compilatore ha lavorato attraverso le regole di elisione della durata ma ancora
non riusciva a capire tutte le durate dei riferimenti nella firma.

Poiché la terza regola si applica realmente solo nelle firme dei metodi, guarderemo
le durate in quel contesto successivamente per vedere perché la terza regola significa che non dobbiamo
annotare le durate nelle firme dei metodi molto spesso.

### Annotazioni della durata nelle definizioni dei metodi

Quando implementiamo metodi su una struttura con durate, usiamo la stessa sintassi come
quella dei parametri di tipo generico mostrati nell'Elenco 10-11. Dove dichiariamo e
usiamo i parametri di durata dipende da se sono correlati ai campi della struttura
o ai parametri e valori di ritorno del metodo.

I nomi della durata per i campi della struttura devono sempre essere dichiarati dopo il `impl`
parola chiave e poi usata dopo il nome della struttura, perché quelle durate fanno parte del tipo della struttura.

Nelle firme dei metodi all'interno del blocco `impl`, i riferimenti potrebbero essere legati alla
durata dei riferimenti nei campi della struttura, o potrebbero essere indipendenti. In
aggiunta, le regole di elisione della durata spesso rendono inutile l'annotazione delle durate
nelle firme dei metodi. Vediamo alcuni esempi utilizzando la
struttura denominata `ImportantExcerpt` che abbiamo definito nell'Elenco 10-24.

Prima, useremo un metodo chiamato `level` il cui unico parametro è un riferimento a
`self` e il cui valore di ritorno è un `i32`, che non è un riferimento a nulla:

```rust
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/no-listing-10-lifetimes-on-methods/src/main.rs:1st}}
```

La dichiarazione del parametro di durata dopo `impl` e il suo uso dopo il nome del tipo
sono necessari, ma non siamo obbligati a annotare la durata del riferimento
a `self` a causa della prima regola di elisione.

Ecco un esempio in cui si applica la terza regola di elisione della durata:

```rust
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/no-listing-10-lifetimes-on-methods/src/main.rs:3rd}}
```

Ci sono due durate di input, quindi Rust applica la prima regola di elisione della durata
e danno sia a `&self` che a `announcement` le loro durate. Poi, perché
uno dei parametri è `&self`, il tipo di ritorno ottiene la durata di `&self`,
e tutte le durate sono state contabilizzate.

### La durata statica

Una durata speciale di cui dobbiamo discutere è `'static`, che denota che il
riferimento interessato *può* vivere per l'intera durata del programma. Tutti
le stringhe letterali hanno la durata `'static`, che possiamo annotare come segue:

```rust
let s: &'static str = "Ho una durata statica.";
```

Il testo di questa stringa è memorizzato direttamente nel binario del programma, che
è sempre disponibile. Di conseguenza, la durata di tutte le stringhe letterali è
`'static`.

Potresti vedere suggerimenti per utilizzare la durata `'static` nei messaggi di errore. Ma
prima di specificare `'static` come la durata per un riferimento, pensa a
se il riferimento che hai vive effettivamente per tutta la durata del tuo
programma o no, e se lo desideri o no. La maggior parte delle volte, un messaggio di errore
che suggerisce la durata `'static` deriva dal tentativo di creare un dangling
riferimento o una non corrispondenza delle durate disponibili. In tali casi, la soluzione
è risolvere questi problemi, non specificare la durata `'static`.

## Parametri di tipo generico, limiti del trait e durate insieme

Diamo un'occhiata breve alla sintassi di specificazione dei parametri di tipo generico, limiti dei trait,
e durate tutte in una funzione!

```rust
{{#rustdoc_include ../listings/ch10-generic-types-traits-and-lifetimes/no-listing-11-generics-traits-and-lifetimes/src/main.rs:here}}
```

Questa è la funzione `longest` dall'Elenco 10-21 che restituisce il più lungo di
due stringhe. Ma ora ha un parametro extra chiamato `ann` del generico
tipo `T`, che può essere riempito da qualsiasi tipo che implementa il `Display`
trait come specificato dalla clausola `where`. Questo parametro extra sarà stampato
utilizzando `{}`, motivo per cui il limite del trait `Display` è necessario. Perché
le durate sono un tipo di parametro generico, le dichiarazioni del parametro di durata
`'a` e del parametro di tipo generico `T` vanno nello stesso elenco all'interno del angolo
parentesi dopo il nome della funzione.

## Sommario

Abbiamo coperto molto in questo capitolo! Ora che conosci i parametri di tipo generico,
i trait e i limiti dei trait, e i parametri generici di durata, sei
pronto a scrivere codice senza ripetizioni che funziona in molte situazioni diverse.
I parametri di tipo generico ti permettono di applicare il codice a tipi diversi. I trait e i
limiti dei trait assicurano che, anche se i tipi sono generici, avranno il
comportamento necessario dal codice. Hai imparato come usare le annotazioni di durata per garantire
che questo codice flessibile non avrà alcun riferimento pendente. E tutto questo
analisi avviene a tempo di compilazione, il che non influisce sulle prestazioni di runtime!
Che tu ci creda o no, c'è molto altro da imparare sui temi che abbiamo discusso in
questo capitolo: il Capitolo 17 discute gli oggetti trait, che sono un altro modo di utilizzare
i traits. Ci sono anche scenari più complessi che coinvolgono le annotazioni di Lifetime
che avrai bisogno solo in scenari molto avanzati; per quanto riguarda, dovresti leggere
il [Rust Reference][reference]. Ma dopo, imparerai a scrivere test in
Rust in modo da poter essere sicuro che il tuo codice funzioni come dovrebbe.

[references-and-borrowing]:
ch04-02-references-and-borrowing.html#references-and-borrowing
[string-slices-as-parameters]:
ch04-03-slices.html#string-slices-as-parameters
[reference]: ../reference/index.html

