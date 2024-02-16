## Errori correggibili con `Result`

La maggior parte degli errori non sono abbastanza gravi da richiedere l'arresto completo del programma.
A volte, quando una funzione fallisce, è per una ragione che puoi facilmente
interpretare e a cui rispondere. Ad esempio, se provi ad aprire un file e quella
operazione fallisce perché il file non esiste, potresti voler creare il
file invece di terminare il processo.

Ricorda da [“Gestire un Potenziale Fallimento con `Result`”][handle_failure]<!--
ignore --> nel Capitolo 2 che l'enum `Result` è definito come avente due
varianti, `Ok` e `Err`, come segue:

```rust
enum Result<T, E> {
    Ok(T),
    Err(E),
}
```

`T` ed `E` sono parametri generici di tipo: parleremo dei generici più in dettaglio nel Capitolo 10. Ciò che devi sapere adesso è che `T` rappresenta il tipo del valore che sarà restituito in un caso di successo all'interno della variante `Ok`, e `E` rappresenta il tipo dell'errore che sarà restituito in un caso di fallimento all'interno della variante `Err`. Poiché `Result` ha questi parametri generici di tipo, possiamo usare il tipo `Result` e le funzioni definite su di esso in molte situazioni diverse nella quali il valore di successo e il valore di errore che vogliamo restituire possono differire.

Proviamo a chiamare una funzione che restituisce un valore `Result` perché la funzione potrebbe fallire. Nell'Esempio 9-3 proviamo ad aprire un file.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch09-error-handling/listing-09-03/src/main.rs}}
```

<span class="caption">Esempio 9-3: Apertura di un file</span>

Il tipo di ritorno di `File::open` è un `Result<T, E>`. Il parametro generico `T` è stato riempito dall'implementazione di `File::open` con il tipo del valore di successo, `std::fs::File`, che è un handle del file. Il tipo di `E` usato nel valore dell'errore è `std::io::Error`. Questo tipo di ritorno significa che la chiamata a `File::open` potrebbe riuscire e restituire un handle del file da cui possiamo leggere o scrivere. La chiamata della funzione potrebbe anche fallire: ad esempio, il file potrebbe non esistere, o potrebbe non avere il permesso di accedere al file. La funzione `File::open` ha bisogno di poterci dire se ha avuto successo o meno e allo stesso tempo darci o l'handle del file o le informazioni sull'errore. Queste informazioni sono esattamente ciò che viene comunicato dall'enum `Result`.

Nel caso in cui `File::open` abbia successo, il valore nella variabile `greeting_file_result` sarà un'istanza di `Ok` che contiene un handle del file. Nel caso in cui fallisca, il valore in `greeting_file_result` sarà un'istanza di `Err` che contiene più informazioni sul tipo di errore che si è verificato.

Dobbiamo aggiungere al codice nell'Esempio 9-3 per prendere azioni diverse a seconda del valore che `File::open` restituisce. L'Esempio 9-4 mostra un modo per gestire il `Result` usando uno strumento di base, l'espressione `match` che abbiamo discusso nel Capitolo 6.

<span class="filename">Nome del file: src/main.rs</span>

```rust,should_panic
{{#rustdoc_include ../listings/ch09-error-handling/listing-09-04/src/main.rs}}
```

<span class="caption">Esempio 9-4: Utilizzo di un'espressione `match` per gestire le
varianti `Result` che potrebbero essere restituite</span>

Nota che, come l'enum `Option`, l'enum `Result` e le sue varianti sono stati
importati nello scope dal preludio, quindi non ci serve specificare `Result::`
prima delle varianti `Ok` e `Err` nelle espressioni `match`.

Quando il risultato è `Ok`, questo codice restituirà il valore `file` interno alla variante `Ok`, e poi assegnerà quel valore dell'handle del file alla variabile `greeting_file`. Dopo il `match`, possiamo usare l'handle del file per leggere o scrivere.

L'altro braccio del `match` gestisce il caso in cui otteniamo un valore `Err` da `File::open`. In questo esempio, abbiamo scelto di chiamare la macro `panic!`. Se non c'è un file chiamato *hello.txt* nella nostra directory corrente e eseguiamo questo codice, vedremo il seguente output dalla macro `panic!`:

```console
{{#include ../listings/ch09-error-handling/listing-09-04/output.txt}}
```

Come al solito, questo output ci dice esattamente cosa è andato storto.

### Match su diversi errori

Il codice nell'Esempio 9-4 farà `panic!` indipendentemente dal motivo per cui `File::open` è fallito.
Tuttavia, vogliamo fare azioni diverse per diverse ragioni di fallimento: se
`File::open` fallisce perché il file non esiste, vogliamo creare il file
e restituire l'handle al nuovo file. Se `File::open` fallisce per qualsiasi altra
ragione, ad esempio, perché non abbiamo il permesso di aprire il file, vogliamo comunque
che il codice faccia `panic!` allo stesso modo in cui lo faceva nell'Esempio 9-4. Per questo aggiungiamo un'espressione `match` interna, mostrata nell'Esempio 9-5.

<span class="filename">Nome del file: src/main.rs</span>

<!-- ignore this test because otherwise it creates hello.txt which causes other
tests to fail lol -->

```rust,ignore
{{#rustdoc_include ../listings/ch09-error-handling/listing-09-05/src/main.rs}}
```

<span class="caption">Esempio 9-5: Gestione di diversi tipi di errori in
modi diversi</span>

Il tipo del valore che `File::open` restituisce all'interno della variante `Err` è
`io::Error`, che è una struct fornita dalla libreria standard. Questa struct
ha un metodo `kind` che possiamo chiamare per ottenere un valore `io::ErrorKind`. L'enum
`io::ErrorKind` è fornito dalla libreria standard e ha varianti
rappresentanti i diversi tipi di errori che potrebbero derivare da un'operazione `io`. La variante che vogliamo usare è `ErrorKind::NotFound`, che indica che il file che stiamo cercando di aprire non esiste ancora. Quindi facciamo match su `greeting_file_result`, ma abbiamo anche un match interno su `error.kind()`.

La condizione che vogliamo verificare nel match interno è se il valore restituito da `error.kind()` è la variante `NotFound` dell'enum `ErrorKind`. Se lo è, proviamo a creare il file con `File::create`. Tuttavia, dato che `File::create` potrebbe anche fallire, abbiamo bisogno di un secondo braccio nell'espressione `match` interna. Quando il file non può essere creato, viene stampato un messaggio di errore diverso. Il secondo braccio del `match` esterno rimane lo stesso, quindi il programma va in panic per qualsiasi errore a parte l'errore del file mancante.
> ### Alternative all'utilizzo di `match` con `Result<T, E>`
>
> Questo implica un gran numero di `match`! L'espressione `match` è molto utile ma è anche molto
> un primitivo. Nel Capitolo 13, imparerai a conoscere le closure, che vengono utilizzate
> con molti dei metodi definiti su `Result<T, E>`. Questi metodi possono essere più
> concisi dell'uso di `match` quando si manipolano valori `Result<T, E>` nel tuo codice.
>
> Per esempio, ecco un altro modo per scrivere la stessa logica mostrata in Lista
> 9-5, questa volta utilizzando le closure e il metodo `unwrap_or_else`:
>
> <!-- NON È POSSIBILE ESTRARRE VEDI https://github.com/rust-lang/mdBook/issues/1127 -->
>
> ```rust,ignore
> use std::fs::File;
> use std::io::ErrorKind;
>
> fn main() {
>     let greeting_file = File::open("hello.txt").unwrap_or_else(|error| {
>         if error.kind() == ErrorKind::NotFound {
>             File::create("hello.txt").unwrap_or_else(|error| {
>                 panic!("Problema durante la creazione del file: {:?}", error);
>             })
>         } else {
>             panic!("Problema durante l'apertura del file: {:?}", error);
>         }
>     });
> }
> ```
>
> Anche se questo codice ha lo stesso comportamento della Lista 9-5, non contiene
> nessuna espressione `match` ed è più semplice da leggere. Torna su questo esempio
> dopo aver letto il Capitolo 13, e consulta il metodo `unwrap_or_else` nella
> documentazione di libreria standard. Molti più di questi metodi possono semplificare enormemente le espressioni `match` annidate quando stai trattando con errori.
 
### Scorciatoie per Panic in caso di errore: `unwrap` e `expect`

L'uso di `match` funziona abbastanza bene, ma può essere un po' prolisso e non sempre
comunica bene l'intento. Il tipo `Result<T, E>` ha molti metodi helper
definiti su di esso per eseguire varie operazioni più specifiche. Il metodo `unwrap` è un
metodo di scorciatoia implementato proprio come l'espressione `match` che abbiamo scritto in
Lista 9-4. Se il valore di `Result` è la variante `Ok`, `unwrap` restituirà
il valore all'interno di `Ok`. Se il `Result` è la variante `Err`, `unwrap` chiamerà
la macro `panic!` per noi. Ecco un esempio di `unwrap` in azione:

<span class="filename">Nome del file: src/main.rs</span>

```rust,should_panic
{{#rustdoc_include ../listings/ch09-error-handling/no-listing-04-unwrap/src/main.rs}}
```

Se eseguiamo questo codice senza un file *hello.txt*, vedremo un messaggio di errore da
la chiamata alla `panic!` che il metodo `unwrap` fa:

<!-- rigenerazione manuale
cd listings/ch09-error-handling/no-listing-04-unwrap
cargo run
copia e incolla il testo rilevante
-->

```text
thread 'main' panicked at 'chiamato `Result::unwrap()` su un valore `Err`: Os {
code: 2, kind: NotFound, message: "Nessun file o directory" }',
src/main.rs:4:49
```

Allo stesso modo, il metodo `expect` ci permette di scegliere anche il messaggio di errore di `panic!`.
Usando `expect` invece di `unwrap` e fornendo buoni messaggi di errore può trasmettere
il tuo intento e rendere più facile rintracciare la fonte di un panico. La sintassi di
`expect` è la seguente:

<span class="filename">Nome del file: src/main.rs</span>

```rust,should_panic
{{#rustdoc_include ../listings/ch09-error-handling/no-listing-05-expect/src/main.rs}}
```

Usiamo `expect` nello stesso modo di `unwrap`: per restituire il gestore del file o chiamare
la macro `panic!`. Il messaggio di errore utilizzato da `expect` nella sua chiamata a `panic!`
sarà il parametro che passiamo a `expect`, piuttosto che il messaggio di default
`panic!` che `unwrap` utilizza. Eccolo in azione:

<!-- manual-regeneration
cd listings/ch09-error-handling/no-listing-05-expect
cargo run
copy and paste relevant text
-->

```text
thread 'main' panicked at 'hello.txt should be included in this project: Os {
code: 2, kind: NotFound, message: "Nessun file o directory" }',
src/main.rs:5:10
```

Nel codice di produzione, la maggior parte dei Rustacei sceglie `expect` piuttosto che
`unwrap` e fornisce più contesto su perché l'operazione dovrebbe sempre
avere successo. In questo modo, se le tue ipotesi vengono mai smentite, avrai di più
informazioni da usare nel debugging.

### Propagare gli errori

Quando l'implementazione di una funzione chiama qualcosa che potrebbe fallire, invece di
Gestire l'errore all'interno della funzione stessa, puoi restituire l'errore al codice chiamante in modo che possa decidere cosa fare. Questo è noto come *propagare*
l'errore e dà più controllo al codice chiamante, dove potrebbe esserci di più
informazioni o logica che dettano come l'errore dovrebbe essere gestito rispetto a quello
che hai a disposizione nel contesto del tuo codice.

Per esempio, la Lista 9-6 mostra una funzione che legge un username da un file. Se
il file non esiste o non può essere letto, questa funzione restituirà quegli errori
al codice che ha chiamato la funzione.

<span class="filename">Nome del file: src/main.rs</span>

<!-- Deliberatamente non usando rustdoc_include qui; la funzione `main` nel
file va in panico. Vogliamo includerla per gli scopi di sperimentazione del lettore, ma non vogliamo includerla per i scopi di test di rustdoc. -->

```rust
{{#include ../listings/ch09-error-handling/listing-09-06/src/main.rs:here}}
```

<span class="caption">Lista 9-6: Una funzione che restituisce errori al
codice chiamante usando `match`</span>

Questa funzione può essere scritta in un modo molto più breve, ma stiamo per iniziare a
fare molti passaggi manualmente per esplorare la gestione degli errori; alla fine,
mostreremo il modo più breve. Diamo un'occhiata al tipo di ritorno della funzione
prima: `Result<String, io::Error>`. Questo significa che la funzione sta restituendo un
valore del tipo `Result<T, E>` dove il parametro generico `T` è stato
riempito con il tipo concreto `String`, e il tipo generico `E` è stato
riempito con il tipo concreto `io::Error`.

Se questa funzione riesce senza problemi, il codice che chiama questo
funzione riceverà un valore `Ok` che contiene una `String`—il nome utente che
questa funzione ha letto dal file. Se questa funzione incontra dei problemi, il
il codice chiamante riceverà un valore `Err` che contiene un'istanza di `io::Error`
che contiene ulteriori informazioni su quali sono stati i problemi. Abbiamo scelto
`io::Error` come tipo di ritorno di questa funzione perché questo è il
tipo del valore di errore restituito da entrambe le operazioni stiamo chiamando in
il corpo di questa funzione che potrebbe fallire: la funzione `File::open` e la
metodo `read_to_string`.

Il corpo della funzione inizia chiamando la funzione `File::open`. Poi noi
gestiamo il valore di `Result` con un `match` simile al `match` nella Lista 9-4.
Se `File::open` ha successo, il gestore del file nella variabile di pattern `file`
diventa il valore nella variabile mutabile `username_file` e la funzione
continua. Nel caso `Err`, invece di chiamare `panic!`, usiamo la `return`
parola chiave per uscire anticipatamente dall'intera funzione e passare il valore di errore
di `File::open`, ora nella variabile di pattern `e`, indietro al codice chiamante come
qual è il valore dell'errore di questa funzione.

Quindi, se abbiamo un handle del file in `username_file`, la funzione crea quindi una nuova
`String` nella variabile `username` e chiama il metodo `read_to_string` su
l'handle del file in `username_file` per leggere il contenuto del file in
`username`. Il metodo `read_to_string` restituisce anche un `Result` perché potrebbe
fallire, anche se `File::open` ha avuto successo. Quindi abbiamo bisogno di un altro `match` per
gestire quel `Result`: se `read_to_string` ha successo, allora la nostra funzione ha
avuto successo, e restituiamo il nome utente dal file che ora è in `username`
racchiuso in un `Ok`. Se `read_to_string` fallisce, restituiamo il valore dell'errore allo stesso modo in cui abbiamo restituito il valore dell'errore nel `match` che ha gestito il
valore di ritorno di `File::open`. Tuttavia, non abbiamo bisogno di dire esplicitamente
`return`, perché questa è l'ultima espressione nella funzione.

Il codice che chiama questo codice gestirà quindi l'ottenimento di un valore `Ok`
che contiene un nome utente o un valore `Err` che contiene un `io::Error`. Spetta
al codice di chiamata decidere cosa fare con questi valori. Se il codice di chiamata
ottiene un valore `Err`, potrebbe chiamare `panic!` e far crashare il programma, usare un
nome utente predefinito, o cercare il nome utente da qualche parte diversa da un file, per
esempio. Non abbiamo abbastanza informazioni su ciò che il codice di chiamata sta effettivamente
tentando di fare, quindi propaghiamo tutte le informazioni di successo o errore verso l'alto per
che possa gestirle in modo appropriato.

Questo schema di propagazione degli errori è così comune in Rust che Rust fornisce l'
operatore punto interrogativo `?` per rendere ciò più facile.

#### Una scorciatoia per propagare gli errori: l'operatore `?`

La Lista 9-7 mostra un'implementazione di `read_username_from_file` che ha la
stessa funzionalità della Lista 9-6, ma questa implementazione utilizza l'
operatore `?`.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#include ../listings/ch09-error-handling/listing-09-07/src/main.rs:here}}
```

<span class="caption">Listing 9-7: Una funzione che restituisce errori al
codice di chiamata utilizzando l'operatore `?`</span>

Il `?` posto dopo un valore `Result` è definito per funzionare quasi allo stesso modo
delle espressioni `match` che abbiamo definito per gestire i valori `Result` nella Lista
9-6. Se il valore del `Result` è un `Ok`, il valore all'interno dell'`Ok` verrà
restituito da questa espressione, e il programma continuerà. Se il valore
è un `Err`, l'`Err` verrà restituito dall'intera funzione come se avessimo
usato la parola chiave `return` così il valore dell'errore viene propagato al codice di chiamata.

C'è una differenza tra ciò che fa l'espressione `match` della Lista 9-6
e cosa fa l'operatore `?`: i valori di errore che hanno l'operatore `?` chiamato
su di essi passano attraverso la funzione `from`, definita nel `From` trait nella
libreria standard, che viene utilizzato per convertire valori da un tipo in un altro.
Quando l'operatore `?` chiama la funzione `from`, il tipo di errore ricevuto si
converte nel tipo di errore definito nel tipo di ritorno della funzione corrente. Questo è utile quando una funzione restituisce un tipo di errore per rappresentare
tutti i modi in cui una funzione potrebbe fallire, anche se parti potrebbero fallire per molte diverse
ragioni.

Per esempio, potremmo cambiare la funzione `read_username_from_file` nella Lista
9-7 a restituire un tipo di errore personalizzato chiamato `OurError` che definiamo. Se definiamo anche
`impl From<io::Error> for OurError` per costruire un'istanza di
`OurError` da un `io::Error`, allora le chiamate dell'operatore `?` nel corpo di
`read_username_from_file` chiameranno `from` e convertiranno i tipi di errore senza
bisogno di aggiungere altro codice alla funzione.

Nel contesto della Lista 9-7, il `?` alla fine della chiamata `File::open` restituirà
il valore all'interno di un `Ok` alla variabile `username_file`. Se si verifica un errore
l'operatore `?` uscirà presto dall'intera funzione e darà qualsiasi valore `Err` al codice di chiamata. La stessa cosa si applica al `?` alla fine della chiamata `read_to_string`.

L'operatore `?` elimina un sacco di codice superfluo e rende più semplice l'implementazione di questa funzione.
Potremmo addirittura ridurre ulteriormente questo codice concatenando
le chiamate al metodo immediatamente dopo il `?`, come mostrato nella Lista 9-8.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#include ../listings/ch09-error-handling/listing-09-08/src/main.rs:here}}
```

<span class="caption">Listing 9-8: Concatenazione delle chiamate al metodo dopo l'operatore `?`</span>

Abbiamo spostato la creazione della nuova `String` in `username` all'inizio della
funzione; quella parte non è cambiata. Invece di creare una variabile
`username_file`, abbiamo concatenato la chiamata a `read_to_string` direttamente sul risultato di `File::open("hello.txt")?`. Abbiamo ancora un `?` alla fine della
chiamata a `read_to_string`, e restituiamo ancora un valore `Ok` contenente `username`
quando sia `File::open` che `read_to_string` hanno successo piuttosto che restituire
errori. La funzionalità è ancora la stessa della Lista 9-6 e Lista 9-7;
questo è solo un modo diverso, più ergonomico, per scriverlo.

La Lista 9-9 mostra un modo per rendere questo ancora più breve usando `fs::read_to_string`.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#include ../listings/ch09-error-handling/listing-09-09/src/main.rs:here}}
```

<span class="caption">Listing 9-9: Utilizzo di `fs::read_to_string` al posto di
aprire e poi leggere il file</span>

Leggere un file in una stringa è un'operazione abbastanza comune, quindi la libreria standard
fornisce la comoda funzione `fs::read_to_string` che apre il
file, crea una nuova `String`, legge il contenuto del file, mette il contenuto
in quella `String`, e lo restituisce. Naturalmente, l'uso di `fs::read_to_string`
non ci dà l'opportunità di spiegare tutta la gestione degli errori, quindi l'abbiamo fatto
nel modo più lungo prima.

#### Dove l'operatore `?` può essere utilizzato

L'operatore `?` può essere utilizzato solo in funzioni il cui tipo di ritorno è compatibile
con il valore su cui viene usato il `?`. Questo perché l'operatore `?` è definito
per eseguire un ritorno anticipato di un valore fuori dalla funzione, nello stesso modo
come l'espressione `match` che abbiamo definito nella Lista 9-6. Nella Lista 9-6, il
`match` stava usando un valore `Result`, e il braccio di ritorno anticipato restituiva un
valore `Err(e)`. Il tipo di ritorno della funzione deve essere un `Result` in modo che
sia compatibile con questo `return`.

Nella Lista 9-10, vediamo l'errore che otterremo se usiamo l'operatore `?`
in una funzione `main` con un tipo di ritorno incompatibile con il tipo del valore
su cui usiamo `?`:


<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch09-error-handling/listing-09-10/src/main.rs}}
```

<span class="caption">Listato 9-10: Tentativo di utilizzare l'operatore `?` nella funzione `main`
che restituisce `()` non avrà successo durante la compilazione</span>

Questo codice apre un file, che potrebbe fallire. L'operatore `?` segue il valore `Result`
restituito da `File::open`, ma questa funzione `main` ha il tipo di ritorno
`()`, non `Result`. Quando compiliamo questo codice, otteniamo il seguente messaggio di errore:

```console
{{#include ../listings/ch09-error-handling/listing-09-10/output.txt}}
```

Questo errore sottolinea che siamo solo autorizzati a utilizzare l'operatore `?` in una
funzione che restituisce `Result`, `Option`, o un altro tipo che implementa
`FromResidual`.

Per correggere l'errore, hai due opzioni. Una scelta è cambiare il tipo di ritorno
della tua funzione per renderlo compatibile con il valore su cui stai utilizzando l'operatore `?` a patto che non ci siano restrizioni che lo impediscono. L'altra tecnica è
utilizzare un `match` o uno dei metodi `Result<T, E>` per gestire il `Result<T,
E>` nel modo più appropriato.

Il messaggio di errore ha anche menzionato che l'operatore `?` può essere utilizzato con i valori `Option<T>`
così come con `Result`. Come con l'uso di `?` su `Result`, puoi solo usare `?` su `Option` in una
funzione che restituisce un `Option`. Il comportamento dell'operatore `?` quando chiamato
su un `Option<T>` è simile al suo comportamento quando chiamato su un `Result<T, E>`:
se il valore è `None`, il `None` verrà restituito anticipatamente dalla funzione in quel punto. Se il valore è `Some`, il valore dentro `Some` è il
risultato dell'espressione e la funzione prosegue. Il listato 9-11 ha
un esempio di una funzione che trova l'ultimo carattere della prima riga nel testo dato:

```rust
{{#rustdoc_include ../listings/ch09-error-handling/listing-09-11/src/main.rs:here}}
```

<span class="caption">Listato 9-11: Utilizzo dell'operatore `?` su un valore `Option<T>`
</span>

Questa funzione restituisce `Option<char>` perché è possibile che ci sia un
carattere lì, ma è anche possibile che non ci sia. Questo codice prende l'argomento slice di stringa `text` e chiama il metodo `lines` su di esso, che restituisce
un iteratore sulle righe nella stringa. Poiché questa funzione vuole
esaminare la prima riga, chiama `next` sull'iteratore per ottenere il primo valore
dall'iteratore. Se `text` è la stringa vuota, questa chiamata a `next` restituirà 
`None`, nel qual caso usiamo `?` per interrompere e restituire `None` da
`last_char_of_first_line`. Se `text` non è la stringa vuota, `next` restituirà un valore `Some` contenente una slice stringa della prima riga in `text`.

L'operatore `?` estrae la slice stringa, e possiamo chiamare `chars` su quella slice stringa
per ottenere un iteratore dei suoi caratteri. Siamo interessati all'ultimo carattere di questa prima riga, quindi chiamiamo `last` per restituire l'ultimo elemento nell'iteratore.
Questo è un `Option` perché è possibile che la prima riga sia la stringa
vuota, per esempio se `text` inizia con una riga vuota ma ha caratteri su
altre righe, come in `"\nhi"`. Tuttavia, se c'è un ultimo carattere sulla prima
riga, verrà restituito nella variante `Some`. L'operatore `?` nel mezzo
ci dà un modo conciso per esprimere questa logica, permettendoci di implementare la
funzione in una sola riga. Se non potessimo usare l'operatore `?` su `Option`, avremmo
dovuto implementare questa logica usando più chiamate di metodo o un'espressione `match`.

Notate che potete usare l'operatore `?` su un `Result` in una funzione che restituisce
`Result`, e potete usare l'operatore `?` su un `Option` in una funzione che
restituisce `Option`, ma non potete mischiare. L'operatore `?` non
converterà automaticamente un `Result` in un `Option` o viceversa; in quei casi,
potete usare metodi come il metodo `ok` su `Result` o il metodo `ok_or` su
`Option` per fare la conversione esplicitamente.

Finora, tutte le funzioni `main` che abbiamo usato restituiscono `()`. La funzione `main` è
speciale perché è il punto di entrata e di uscita dei programmi eseguibili, e ci sono restrizioni su quale può essere il suo tipo di ritorno perché i programmi si comportino come previsto.

Fortunatamente, `main` può anche restituire un `Result<(), E>`. Il listato 9-12 ha il
codice dal listato 9-10 ma abbiamo cambiato il tipo di ritorno di `main` in
`Result<(), Box<dyn Error>>` e abbiamo aggiunto un valore di ritorno `Ok(())` alla fine. Questo
codice compilerà ora:

```rust,ignore
{{#rustdoc_include ../listings/ch09-error-handling/listing-09-12/src/main.rs}}
```

<span class="caption">Listato 9-12: Cambiamento di `main` per restituire `Result<(), E>`
permette l'uso dell'operatore `?` su valori `Result`</span>

Il tipo `Box<dyn Error>` è un *trait object*, di cui parleremo nella
sezione ["Usando Trait Objects che Permettono Valori di Diversi 
Tipi"][trait-objects]<!-- ignore --> nel Capitolo 17. Per ora, puoi
leggere `Box<dyn Error>` come "qualsiasi tipo di errore". Usar `?` su un valore `Result`
in una funzione `main` con il tipo di errore `Box<dyn Error>` è permesso,
perché permette a qualsiasi valore `Err` di essere restituito anticipatamente. Anche se il corpo di
questa funzione `main` restituirà solo errori di tipo `std::io::Error`, specificando `Box<dyn Error>`, questa firma continuerà ad essere corretta anche se
vengono aggiunti al corpo di `main` altri codici che restituiscono altri errori.

Quando una funzione `main` restituisce un `Result<(), E>`, l'eseguibile uscirà
con un valore di `0` se `main` restituisce `Ok(())` e uscirà con un
valore non zero se `main` restituisce un valore `Err`. Gli eseguibili scritti in C restituiscono
interi quando escono: i programmi che escono con successo restituiscono l'intero
`0`, e i programmi che danno errore restituiscono un intero diverso da `0`. Anche Rust
restituisce interi dagli eseguibili per essere compatibile con questa convenzione.

La funzione `main` può restituire qualsiasi tipo che implementa il trait [`std::process::Termination`][termination]<!-- ignore -->, che contiene
una funzione `report` che restituisce un `ExitCode`. Consulta la documentazione della libreria standard
per ulteriori informazioni sull'implementazione del trait `Termination` per
i tuoi tipi.

Ora che abbiamo discusso i dettagli della chiamata a `panic!` o della restituzione di `Result`,
torniamo al tema di come decidere quale sia appropriato usare in quali
casi.

[handle_failure]: ch02-00-guessing-game-tutorial.html#handling-potential-failure-with-result
[trait-objects]: ch17-02-trait-objects.html#using-trait-objects-that-allow-for-values-of-different-types
[termination]: ../std/process/trait.Termination.html

