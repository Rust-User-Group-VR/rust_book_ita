## Errori Recuperabili con `Result`

La maggior parte degli errori non sono così gravi da richiedere l'arresto completo del programma. A volte, quando una funzione fallisce è per una ragione che puoi facilmente interpretare e a cui puoi rispondere. Ad esempio, se provi ad aprire un file e quell'operazione fallisce perché il file non esiste, potresti voler creare il file invece di terminare il processo.

Ricorda da [“Gestione del Potenziale Fallimento con `Result`”][handle_failure]<!--
ignore --> nel Capitolo 2 che l'enum `Result` è definito come avente due varianti, `Ok` e `Err`, come segue:

```rust
enum Result<T, E> {
    Ok(T),
    Err(E),
}
```

I `T` e `E` sono parametri di tipi generici: discuteremo i generici più in dettaglio nel Capitolo 10. Quello che devi sapere ora è che `T` rappresenta il tipo del valore che verrà restituito in caso di successo all'interno della variante `Ok`, e `E` rappresenta il tipo dell'errore che verrà restituito in caso di fallimento all'interno della variante `Err`. Poiché `Result` ha questi parametri di tipo generico, possiamo usare il tipo `Result` e le funzioni definite su di esso in molte situazioni diverse in cui i valori di successo e di errore che vogliamo restituire possono differire.

Chiamiamo una funzione che restituisce un valore `Result` perché la funzione potrebbe fallire. Nel Listing 9-3 proviamo ad aprire un file.

<span class="filename">Nome File: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch09-error-handling/listing-09-03/src/main.rs}}
```

<span class="caption">Listing 9-3: Apertura di un file</span>

Il tipo di ritorno di `File::open` è un `Result<T, E>`. Il parametro generico `T` è stato riempito dall'implementazione di `File::open` con il tipo del valore di successo, `std::fs::File`, che è un handle del file. Il tipo di `E` utilizzato nel valore di errore è `std::io::Error`. Questo tipo di ritorno significa che la chiamata a `File::open` potrebbe avere successo e restituire un handle del file da cui possiamo leggere o scrivere. La chiamata alla funzione potrebbe anche fallire: ad esempio, il file potrebbe non esistere, o potremmo non avere i permessi per accedere al file. La funzione `File::open` ha bisogno di un modo per dirci se ha avuto successo o fallito e, contemporaneamente, darci l'handle del file o le informazioni sull'errore. Questa informazione è esattamente ciò che l'enum `Result` trasmette.

Nel caso in cui `File::open` abbia successo, il valore nella variabile `greeting_file_result` sarà un'istanza di `Ok` che contiene un handle del file. Nel caso in cui fallisca, il valore in `greeting_file_result` sarà un'istanza di `Err` che contiene più informazioni sul tipo di errore che si è verificato.

Dobbiamo aggiungere al codice nel Listing 9-3 per intraprendere azioni diverse a seconda del valore restituito da `File::open`. Il Listing 9-4 mostra un modo per gestire il `Result` utilizzando uno strumento di base, l'espressione `match` di cui abbiamo discusso nel Capitolo 6.

<span class="filename">Nome File: src/main.rs</span>

```rust,should_panic
{{#rustdoc_include ../listings/ch09-error-handling/listing-09-04/src/main.rs}}
```

<span class="caption">Listing 9-4: Utilizzo di un'espressione `match` per gestire le varianti di `Result` che potrebbero essere restituite</span>

Nota che, come l'enum `Option`, anche l'enum `Result` e le sue varianti sono stati portati in ambito dal preambolo, quindi non è necessario specificare `Result::` prima delle varianti `Ok` e `Err` nei bracci del `match`.

Quando il risultato è `Ok`, questo codice restituirà il valore interno `file` dalla variante `Ok`, e assegneremo dunque quell'handle del file alla variabile `greeting_file`. Dopo il `match`, possiamo usare l'handle del file per leggere o scrivere.

L'altro braccio del `match` gestisce il caso in cui otteniamo un valore `Err` da `File::open`. In questo esempio, abbiamo scelto di chiamare la macro `panic!`. Se non esiste un file chiamato *hello.txt* nella nostra attuale directory e eseguiamo questo codice, vedremo il seguente output dalla macro `panic!`:

```console
{{#include ../listings/ch09-error-handling/listing-09-04/output.txt}}
```

Come al solito, questo output ci dice esattamente cosa è andato storto.

### Gestione di Errori Diversi

Il codice nel Listing 9-4 eseguirà `panic!` indipendentemente dal motivo per cui `File::open` ha fallito. Tuttavia, vogliamo intraprendere azioni diverse per motivi di fallimento diversi. Se `File::open` ha fallito perché il file non esiste, vogliamo creare il file e restituire l'handle al nuovo file. Se `File::open` ha fallito per qualsiasi altra ragione—per esempio, perché non avevamo i permessi per aprire il file—vogliamo comunque che il codice esegua `panic!` nello stesso modo in cui ha fatto nel Listing 9-4. Per questo, aggiungiamo un'espressione `match` interna, mostrata nel Listing 9-5.

<span class="filename">Nome File: src/main.rs</span>

<!-- ignore this test because otherwise it creates hello.txt which causes other
tests to fail lol -->

```rust,ignore
{{#rustdoc_include ../listings/ch09-error-handling/listing-09-05/src/main.rs}}
```

<span class="caption">Listing 9-5: Gestione di diversi tipi di errori in modi diversi</span>

Il tipo del valore che `File::open` restituisce all'interno della variante `Err` è `io::Error`, che è una struct fornita dalla libreria standard. Questa struct ha un metodo `kind` che possiamo chiamare per ottenere un valore `io::ErrorKind`. L'enum `io::ErrorKind` è fornito dalla libreria standard e ha varianti che rappresentano i diversi tipi di errori che potrebbero derivare da un'operazione `io`. La variante che vogliamo usare è `ErrorKind::NotFound`, che indica che il file che stiamo tentando di aprire non esiste ancora. Quindi facciamo `match` su `greeting_file_result`, ma abbiamo anche un inner match su `error.kind()`.

La condizione che vogliamo verificare nell'inner match è se il valore restituito da `error.kind()` è la variante `NotFound` dell'enum `ErrorKind`. Se lo è, proviamo a creare il file con `File::create`. Tuttavia, poiché anche `File::create` potrebbe fallire, abbiamo bisogno di un secondo braccio nell'inner match expression. Quando il file non può essere creato, viene stampato un messaggio di errore diverso. Il secondo braccio dell'outer match rimane lo stesso, quindi il programma va in panico su qualsiasi errore diverso dall'errore di file mancante.

> #### Alternative all'uso di `match` con `Result<T, E>`
>
> Questo è un sacco di `match`! L'espressione `match` è molto utile ma anche molto primitiva. Nel Capitolo 13, imparerai riguardo ai closure, che vengono usati con molti dei metodi definiti su `Result<T, E>`. Questi metodi possono essere più concisi rispetto all'uso di `match` quando si gestiscono valori `Result<T, E>` nel tuo codice.
>
> Ad esempio, ecco un altro modo per scrivere la stessa logica mostrata nel Listing 9-5, questa volta usando closure e il metodo `unwrap_or_else`:
>
> <!-- CAN'T EXTRACT SEE https://github.com/rust-lang/mdBook/issues/1127 -->
>
> ```rust,ignore
> use std::fs::File;
> use std::io::ErrorKind;
>
> fn main() {
>     let greeting_file = File::open("hello.txt").unwrap_or_else(|error| {
>         if error.kind() == ErrorKind::NotFound {
>             File::create("hello.txt").unwrap_or_else(|error| {
>                 panic!("Problem creating the file: {error:?}");
>             })
>         } else {
>             panic!("Problem opening the file: {error:?}");
>         }
>     });
> }
> ```
>
> Anche se questo codice ha lo stesso comportamento del Listing 9-5, non contiene alcuna espressione `match` ed è più pulito da leggere. Torna a questo esempio dopo aver letto il Capitolo 13 e cerca il metodo `unwrap_or_else` nella documentazione della libreria standard. Molti altri di questi metodi possono ripulire enormi espressioni `match` annidate quando stai gestendo errori.

#### Scorciatoie per il Panico su Errore: `unwrap` e `expect`

L'uso di `match` funziona abbastanza bene, ma può essere un po' prolisso e non sempre comunica bene l'intento. Il tipo `Result<T, E>` ha molti metodi helper definiti su di esso per fare varie operazioni più specifiche. Il metodo `unwrap` è un metodo shortcut implementato proprio come l'espressione `match` che abbiamo scritto nel Listing 9-4. Se il valore `Result` è la variante `Ok`, `unwrap` restituirà il valore all'interno dell'`Ok`. Se il `Result` è la variante `Err`, `unwrap` chiamerà la macro `panic!` per noi. Ecco un esempio di `unwrap` in azione:

<span class="filename">Nome File: src/main.rs</span>

```rust,should_panic
{{#rustdoc_include ../listings/ch09-error-handling/no-listing-04-unwrap/src/main.rs}}
```

Se eseguiamo questo codice senza un file *hello.txt*, vedremo un messaggio di errore dalla chiamata `panic!` che il metodo `unwrap` esegue:

<!-- manual-regeneration
cd listings/ch09-error-handling/no-listing-04-unwrap
cargo run
copy and paste relevant text
-->

```text
thread 'main' panicked at src/main.rs:4:49:
called `Result::unwrap()` on an `Err` value: Os { code: 2, kind: NotFound, message: "No such file or directory" }
```

Allo stesso modo, il metodo `expect` ci permette anche di scegliere il messaggio di errore `panic!`. Utilizzare `expect` invece di `unwrap` e fornire buoni messaggi di errore può trasmettere il tuo intento e rendere più facile rintracciare la fonte di un panico. La sintassi di `expect` è simile a questa:

<span class="filename">Nome File: src/main.rs</span>

```rust,should_panic
{{#rustdoc_include ../listings/ch09-error-handling/no-listing-05-expect/src/main.rs}}
```

Usiamo `expect` nello stesso modo di `unwrap`: per restituire l'handle del file o chiamare la macro `panic!`. Il messaggio di errore utilizzato da `expect` nella sua chiamata a `panic!` sarà il parametro che passiamo a `expect`, piuttosto che il messaggio predefinito di `panic!` che `unwrap` utilizza. Ecco come appare:

<!-- manual-regeneration
cd listings/ch09-error-handling/no-listing-05-expect
cargo run
copy and paste relevant text
-->

```text
thread 'main' panicked at src/main.rs:5:10:
hello.txt dovrebbe essere incluso in questo progetto: Os { code: 2, kind: NotFound, message: "No such file or directory" }
```

Nel codice di qualità per la produzione, la maggior parte dei Rustacean sceglie `expect` piuttosto che `unwrap` e fornisce più contesto sul perché l'operazione è attesa per avere sempre successo. In questo modo, se le tue assunzioni si rivelano mai sbagliate, avrai più informazioni disponibili per eseguire il debug.

### Propagazione degli Errori

Quando l'implementazione di una funzione chiama qualcosa che potrebbe fallire, invece di gestire l'errore all'interno della funzione stessa puoi restituire l'errore al codice chiamante in modo che possa decidere cosa fare. Questo è conosciuto come *propagazione* dell'errore e dà più controllo al codice chiamante, dove potrebbe esserci più informazione o logica che detta come l'errore dovrebbe essere gestito rispetto a quello che hai disponibile nel contesto del tuo codice.

Ad esempio, il Listing 9-6 mostra una funzione che legge un nome utente da un file. Se il file non esiste o non può essere letto, questa funzione restituirà quegli errori al codice che ha chiamato la funzione.

<span class="filename">Nome File: src/main.rs</span>

<!-- Deliberately not using rustdoc_include here; the `main` function in the
file panics. We do want to include it for reader experimentation purposes, but
don't want to include it for rustdoc testing purposes. -->

```rust
{{#include ../listings/ch09-error-handling/listing-09-06/src/main.rs:here}}
```

<span class="caption">Listing 9-6: Una funzione che restituisce errori al codice chiamante utilizzando `match`</span>

Questa funzione può essere scritta in modo molto più breve, ma inizieremo facendo molte operazioni manualmente per esplorare la gestione degli errori; alla fine, mostreremo il modo più breve. Guardiamo prima il tipo di ritorno della funzione: `Result<String, io::Error>`. Questo significa che la funzione restituisce un valore del tipo `Result<T, E>`, dove il parametro generico `T` è stato riempito con il tipo concreto `String` e il tipo generico `E` è stato riempito con il tipo concreto `io::Error`.

Se questa funzione ha successo senza nessun problema, il codice che chiama questa funzione riceverà un valore `Ok` che contiene una `String`—il `username` che questa funzione ha letto dal file. Se questa funzione riscontra problemi, il codice chiamante riceverà un valore `Err` che contiene un'istanza di `io::Error` che contiene maggiori informazioni sui problemi riscontrati. Abbiamo scelto `io::Error` come tipo di ritorno di questa funzione perché succede che sia il tipo del valore di errore restituito da entrambe le operazioni che stiamo chiamando nel corpo di questa funzione che potrebbero fallire: la funzione `File::open` e il metodo `read_to_string`.

Il corpo della funzione inizia chiamando la funzione `File::open`. Poi gestiamo il valore `Result` con un `match` simile al `match` nel Listing 9-4. Se `File::open` ha successo, l'handle del file nella variabile pattern `file` diventa il valore nella variabile mutabile `username_file` e la funzione continua. Nel caso di `Err`, invece di chiamare `panic!`, usiamo la parola chiave `return` per ritornare anticipatamente dalla funzione completamente e passare il valore di errore da `File::open`, ora nella variabile pattern `e`, al codice chiamante come valore di errore di questa funzione.

Quindi, se abbiamo un handle del file in `username_file`, la funzione crea poi una nuova `String` nella variabile `username` e chiama il metodo `read_to_string` sull'handle del file in `username_file` per leggere il contenuto del file in `username`. Il metodo `read_to_string` restituisce anche un `Result` perché potrebbe fallire, anche se `File::open` ha avuto successo. Quindi abbiamo bisogno di un altro `match` per gestire quel `Result`: se `read_to_string` ha successo, allora la nostra funzione ha avuto successo, e restituiamo il nome utente dal file che ora è in `username` avvolto in un `Ok`. Se `read_to_string` fallisce, restituiamo il valore di errore nello stesso modo in cui abbiamo restituito il valore di errore nel `match` che ha gestito il valore di ritorno di `File::open`. Tuttavia, non abbiamo bisogno di dire esplicitamente `return`, perché questa è l'ultima espressione nella funzione.

Il codice che chiama questo codice gestirà quindi l'ottenimento di un valore `Ok` che contiene un nome utente o un valore `Err` che contiene un `io::Error`. Sta al codice chiamante decidere cosa fare con quei valori. Se il codice chiamante ottiene un valore `Err`, potrebbe chiamare `panic!` e far collassare il programma, usare un nome utente di default, o cercare il nome utente da qualche altra parte che non sia un file, ad esempio. Non abbiamo abbastanza informazioni su ciò che il codice chiamante sta effettivamente tentando di fare, quindi propaghiamo tutte le informazioni di successo o di errore verso l'alto affinché siano gestite adeguatamente.

Questo pattern di propagazione degli errori è così comune in Rust che Rust fornisce l'operatore punto interrogativo `?` per renderlo più facile.

#### Una Scorciatoia per Propagare gli Errori: l'Operatore `?`

Il Listing 9-7 mostra un'implementazione di `read_username_from_file` che ha la stessa funzionalità del Listing 9-6, ma questa implementazione utilizza l'operatore `?`.

<span class="filename">Nome File: src/main.rs</span>

<!-- Deliberately not using rustdoc_include here; the `main` function in the
file panics. We do want to include it for reader experimentation purposes, but
don't want to include it for rustdoc testing purposes. -->

```rust
{{#include ../listings/ch09-error-handling/listing-09-07/src/main.rs:here}}
```

<span class="caption">Listing 9-7: Una funzioneche restituisce errori al codice chiamante utilizzando l'operatore `?`</span>
Il `?` posto dopo un valore `Result` è definito per funzionare quasi nello stesso modo
delle espressioni `match` che abbiamo definito per gestire i valori `Result` nel Listato
9-6. Se il valore del `Result` è un `Ok`, il valore all'interno dell'`Ok` verrà
restituito da questa espressione e il programma continuerà. Se il valore è un `Err`, il `Err` verrà restituito da tutta la funzione come se avessimo 
usato la parola chiave `return` in modo che il valore di errore venga propagato al codice chiamante.

C'è una differenza tra ciò che l'espressione `match` dal Listato 9-6 fa
e ciò che fa l'operatore `?`: i valori di errore a cui viene chiamato l'operatore `?` passano attraverso la funzione `from`, definita nel trait `From` nella libreria standard, che viene usata per convertire i valori da un tipo a un altro.
Quando l'operatore `?` chiama la funzione `from`, il tipo di errore ricevuto è
convertito nel tipo di errore definito nel tipo di ritorno della funzione corrente. Questo è utile quando una funzione ritorna un tipo di errore per rappresentare
tutti i modi in cui una funzione potrebbe fallire, anche se parti potrebbero fallire per molti motivi diversi.

Per esempio, potremmo cambiare la funzione `read_username_from_file` nel Listato
9-7 per restituire un tipo di errore personalizzato chiamato `OurError` che definiamo. Se definiamo anche `impl From<io::Error> for OurError` per costruire un'istanza di
`OurError` da un `io::Error`, allora le chiamate dell'operatore `?` nel corpo di 
`read_username_from_file` chiameranno `from` e convertiranno i tipi di errore senza
bisogno di aggiungere altro codice alla funzione.

Nel contesto del Listato 9-7, il `?` alla fine della chiamata `File::open` restituirà
il valore all'interno di un `Ok` alla variabile `username_file`. Se si verifica un errore, l'operatore `?` restituirà anticipatamente l'intera funzione e fornirà
qualsiasi valore `Err` al codice chiamante. La stessa cosa vale per il `?` alla fine della chiamata `read_to_string`.

L'operatore `?` elimina molte boilerplate e rende l'implementazione di questa funzione più semplice. Potremmo anche abbreviarlo ulteriormente concatenando 
le chiamate ai metodi immediatamente dopo il `?`, come mostrato nel Listato 9-8.

<span class="filename">Nome del file: src/main.rs</span>

<!-- Deliberately not using rustdoc_include here; the `main` function in the
file panics. We do want to include it for reader experimentation purposes, but
don't want to include it for rustdoc testing purposes. -->

```rust
{{#include ../listings/ch09-error-handling/listing-09-08/src/main.rs:here}}
```

<span class="caption">Listato 9-8: Concatenazione di chiamate ai metodi dopo l'operatore `?`</span>

Abbiamo spostato la creazione del nuovo `String` in `username` all'inizio della
funzione; quella parte non è cambiata. Invece di creare una variabile
`username_file`, abbiamo concatenato la chiamata a `read_to_string` direttamente 
al risultato di `File::open("hello.txt")?`. Abbiamo ancora un `?` alla fine della
chiamata `read_to_string`, e rimanderemo ancora un valore `Ok` contenente `username`
quando sia `File::open` che `read_to_string` riescono invece di restituire
errori. La funzionalità è di nuovo la stessa del Listato 9-6 e del Listato 9-7; questo è solo un modo diverso e più ergonomico di scriverlo.

Il Listato 9-9 mostra un modo per rendere questo ancora più breve utilizzando `fs::read_to_string`.

<span class="filename">Nome del file: src/main.rs</span>

<!-- Deliberately not using rustdoc_include here; the `main` function in the
file panics. We do want to include it for reader experimentation purposes, but
don't want to include it for rustdoc testing purposes. -->

```rust
{{#include ../listings/ch09-error-handling/listing-09-09/src/main.rs:here}}
```

<span class="caption">Listato 9-9: Utilizzo di `fs::read_to_string` invece di
aprire e poi leggere il file</span>

Leggere un file in una stringa è un'operazione piuttosto comune, quindi la libreria
standard fornisce la funzione comoda `fs::read_to_string` che apre il file,
crea un nuovo `String`, legge il contenuto del file, mette il contenuto
in quella `String`, e la restituisce. Naturalmente, l'uso di `fs::read_to_string`
non ci dà la possibilità di spiegare tutta la gestione degli errori, quindi lo abbiamo fatto
nel modo più lungo prima.

#### Dove l'Operatore `?` Può Essere Utilizzato

L'operatore `?` può essere utilizzato solo in funzioni il cui tipo di ritorno è compatibile
con il valore su cui viene usato il `?`. Questo perché l'operatore `?` è definito
per eseguire un ritorno anticipato di un valore fuori dalla funzione, nello stesso modo
dell'espressione `match` che abbiamo definito nel Listato 9-6. Nel Listato 9-6,
il `match` stava usando un valore `Result`, e il ramo di ritorno anticipato restituiva un
valore `Err(e)`. Il tipo di ritorno della funzione deve essere un `Result` così che
sia compatibile con questo `return`.

Nel Listato 9-10, vediamo l'errore che otterremo se usiamo l'operatore `?`
in una funzione `main` con un tipo di ritorno che non è compatibile con il tipo del valore su cui usiamo `?`.

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch09-error-handling/listing-09-10/src/main.rs}}
```

<span class="caption">Listato 9-10: Tentativo di utilizzo del `?` nella funzione `main` che restituisce `()` non compila.</span>

Questo codice apre un file, che potrebbe fallire. L'operatore `?` segue il valore `Result`
ritornato da `File::open`, ma questa funzione `main` ha il tipo di ritorno
`()`, non `Result`. Quando compiliamo questo codice, otteniamo il seguente messaggio di errore:

```console
{{#include ../listings/ch09-error-handling/listing-09-10/output.txt}}
```

Questo errore sottolinea che siamo autorizzati a usare l'operatore `?` solo in
una funzione che restituisce `Result`, `Option`, o un altro tipo che implementa
`FromResidual`.

Per correggere l'errore, hai due scelte. Una scelta è cambiare il tipo di ritorno
della tua funzione per essere compatibile con il valore su cui stai usando l'operatore `?`
finché non hai restrizioni che lo impediscono. L'altra scelta è utilizzare un `match` o uno dei metodi `Result<T, E>` per gestire il `Result<T, E>`
in qualunque modo sia appropriato.

Il messaggio di errore menzionava anche che `?` può essere utilizzato con i valori `Option<T>`.
Come con l'uso di `?` su `Result`, puoi usare `?` su `Option` solo in una funzione che ritorna un `Option`. Il comportamento dell'operatore `?` quando viene chiamato
su un `Option<T>` è simile al suo comportamento quando viene chiamato su un `Result<T, E>`:
se il valore è `None`, il `None` verrà restituito anticipatamente dalla funzione a
quel punto. Se il valore è `Some`, il valore all'interno del `Some` è il
valore risultante dell'espressione, e la funzione continua. Il Listato 9-11 ha
un esempio di una funzione che trova l'ultimo carattere della prima riga nel testo dato.

```rust
{{#rustdoc_include ../listings/ch09-error-handling/listing-09-11/src/main.rs:here}}
```

<span class="caption">Listato 9-11: Uso dell'operatore `?` su un valore `Option<T>`</span>

Questa funzione restituisce `Option<char>` perché è possibile che ci sia un
carattere lì, ma è anche possibile che non ci sia. Questo codice prende la fetta di stringa `text` come argomento e chiama il metodo `lines` su di essa, che restituisce
un iteratore sulle righe nella stringa. Poiché questa funzione vuole esaminare la
prima riga, chiama `next` sull'iteratore per ottenere il primo valore dell'iteratore.
Se `text` è la stringa vuota, questa chiamata a `next` restituirà `None`, nel qual caso usiamo `?` per fermarci e restituire `None` da
`last_char_of_first_line`. Se `text` non è la stringa vuota, `next` restituirà un valore
`Some` contenente una fetta di stringa della prima riga in `text`.

Il `?` estrae la fetta di stringa e possiamo chiamare `chars` su quella fetta di stringa
per ottenere un iteratore dei suoi caratteri. Siamo interessati all'ultimo carattere di questa prima riga, quindi chiamiamo `last` per restituire l'ultimo elemento nell'iteratore.
Questo è un `Opzione` perché è possibile che la prima riga sia la stringa vuota; ad esempio, se `text` inizia con una riga vuota ma ha caratteri su
altre righe, come in `"\nhi"`. Tuttavia, se c'è un ultimo carattere sulla prima 
riga, verrà restituito nella variante `Some`. L'operatore `?` nel mezzo ci dà un modo
conciso di esprimere questa logica, permettendoci di implementare la
funzione in una sola riga. Se non potessimo usare l'operatore `?` su `Option`, dovremmo
implementare questa logica utilizzando più chiamate ai metodi o un'espressione `match`.

Nota che puoi usare l'operatore `?` su un `Result` in una funzione che restituisce
`Result`, e puoi usare l'operatore `?` su un `Option` in una funzione che restituisce `Option`, ma non puoi mescolarli. L'operatore `?` non
converterà automaticamente un `Result` in un `Option` o viceversa; in quei casi,
puoi utilizzare metodi come il metodo `ok` su `Result` o il metodo `ok_or` su `Option`
per fare la conversione esplicitamente.

Finora, tutte le funzioni `main` che abbiamo usato restituiscono `()`. La funzione `main` è speciale perché è il punto d'ingresso e il punto d'uscita di un programma eseguibile,
e ci sono restrizioni su quale possa essere il suo tipo di ritorno affinché il programma
funzioni come previsto.

Fortunatamente, `main` può anche restituire un `Result<(), E>`. Il Listato 9-12 ha il codice
del Listato 9-10, ma abbiamo cambiato il tipo di ritorno di `main` in
`Result<(), Box<dyn Error>>` e aggiunto un valore di ritorno `Ok(())` alla fine. Questo
codice ora compilerà.

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch09-error-handling/listing-09-12/src/main.rs}}
```

<span class="caption">Listato 9-12: Cambiamento di `main` per restituire `Result<(), E>` consente l'uso dell'operatore `?` su valori `Result`.</span>

Il tipo `Box<dyn Error>` è un *oggetto trait*, di cui parleremo nella sezione
[“Usare oggetti trait che consentono valori di tipi diversi”][trait-objects]<!-- ignore --> nel Capitolo 17. Per ora, puoi
leggere `Box<dyn Error>` come “qualsiasi tipo di errore”. Usare `?` su un valore `Result`
in una funzione `main` con il tipo di errore `Box<dyn Error>` è consentito
perché permette qualsiasi valore `Err` di essere restituito anticipatamente. Anche se il corpo di questa funzione `main` restituirà solo errori del tipo `std::io::Error`, specificando `Box<dyn Error>`, questa firma rimarrà corretta anche se nella funzione `main` verrà aggiunto altro codice che restituisce altri errori.

Quando una funzione `main` restituisce un `Result<(), E>`, l'eseguibile si chiuderà con
un valore di `0` se `main` restituisce `Ok(())` e si chiuderà con un valore diverso da zero se `main` restituisce un valore `Err`. Gli eseguibili scritti in C restituiranno interi
quando si chiudono: i programmi che si chiudono con successo restituiscono l'intero `0`, e i programmi che si chiudono con errore restituiscono un qualche intero diverso da `0`.
Anche Rust restituisce interi dagli eseguibili per essere compatibili con questa convenzione.

La funzione `main` può restituire qualsiasi tipo che implementa [il trait
`std::process::Termination`][termination]<!-- ignore -->, che contiene
una funzione `report` che restituisce un `ExitCode`. Consulta la documentazione della libreria standard per ulteriori informazioni sull'implementazione del trait `Termination` per i tuoi tipi.

Ora che abbiamo discusso i dettagli della chiamata `panic!` o del ritorno di `Result`, ritorniamo all'argomento su come decidere quale sia appropriato usare in quali
casi.

[handle_failure]: ch02-00-guessing-game-tutorial.html#handling-potential-failure-with-result
[trait-objects]: ch17-02-trait-objects.html#using-trait-objects-that-allow-for-values-of-different-types
[termination]: ../std/process/trait.Termination.html
