## Errori recuperabili con `Result`

La maggior parte degli errori non è abbastanza grave da richiedere l'arresto completo del programma. A volte, quando una funzione fallisce, è per un motivo che puoi facilmente interpretare e affrontare. Ad esempio, se provi ad aprire un file e l'operazione fallisce perché il file non esiste, potresti voler creare il file invece di terminare il processo.

Ricorda da [“Gestione del potenziale fallimento con `Result`”][handle_failure]<!--
ignore --> nel Capitolo 2 che l'enum `Result` è definito come avente due varianti, `Ok` ed `Err`, come segue:

```rust
enum Result<T, E> {
    Ok(T),
    Err(E),
}
```

`T` ed `E` sono parametri di tipo generico: discuteremo i generici in modo più dettagliato nel Capitolo 10. Quello che devi sapere ora è che `T` rappresenta il tipo del valore che verrà restituito in caso di successo all'interno della variante `Ok`, ed `E` rappresenta il tipo dell'errore che verrà restituito in caso di fallimento all'interno della variante `Err`. Poiché `Result` ha questi parametri di tipo generico, possiamo utilizzare il tipo `Result` e le funzioni definite su di esso in molte situazioni diverse in cui il valore di successo e il valore di errore che vogliamo restituire possono differire.

Chiamiamo una funzione che restituisce un valore `Result` perché la funzione potrebbe fallire. Nel Listato 9-3 proviamo ad aprire un file.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch09-error-handling/listing-09-03/src/main.rs}}
```

<span class="caption">Listato 9-3: Apertura di un file</span>

Il tipo di ritorno di `File::open` è un `Result<T, E>`. Il parametro generico `T` è stato riempito dall'implementazione di `File::open` con il tipo del valore di successo, `std::fs::File`, che è un handle del file. Il tipo di `E` utilizzato nel valore di errore è `std::io::Error`. Questo tipo di ritorno significa che la chiamata a `File::open` potrebbe avere successo e restituire un handle del file da cui possiamo leggere o scrivere. La chiamata della funzione potrebbe anche fallire: ad esempio, il file potrebbe non esistere, oppure potremmo non avere il permesso di accedere al file. La funzione `File::open` deve avere un modo per dirci se è riuscita o fallita e allo stesso tempo darci o l'handle del file o le informazioni sull'errore. Queste informazioni sono esattamente ciò che l'enum `Result` trasmette.

Nel caso in cui `File::open` abbia successo, il valore nella variabile `greeting_file_result` sarà un'istanza di `Ok` che contiene un handle del file. Nel caso in cui fallisca, il valore in `greeting_file_result` sarà un'istanza di `Err` che contiene maggiori informazioni sul tipo di errore che si è verificato.

Dobbiamo aggiungere al codice nel Listato 9-3 per intraprendere azioni diverse a seconda del valore che `File::open` restituisce. Il Listato 9-4 mostra un modo per gestire il `Result` usando uno strumento base, l'espressione `match` di cui abbiamo discusso nel Capitolo 6.

<span class="filename">Nome del file: src/main.rs</span>

```rust,should_panic
{{#rustdoc_include ../listings/ch09-error-handling/listing-09-04/src/main.rs}}
```

<span class="caption">Listato 9-4: Utilizzo di un'espressione `match` per gestire le varianti `Result` che potrebbero essere restituite</span>

Nota che, come l'enum `Option`, l'enum `Result` e le sue varianti sono stati portati nel Scope dal prelude, quindi non abbiamo bisogno di specificare `Result::` prima delle varianti `Ok` ed `Err` nei rami del `match`.

Quando il risultato è `Ok`, questo codice restituirà il valore `file` interno dalla variante `Ok`, e poi assegniamo quel valore dell'handle del file alla variabile `greeting_file`. Dopo il `match`, possiamo usare l'handle del file per leggere o scrivere.

L'altro ramo del `match` gestisce il caso in cui otteniamo un valore `Err` da `File::open`. In questo esempio, abbiamo scelto di chiamare la macro `panic!`. Se nel nostro direttorio corrente non c'è un file chiamato *hello.txt* e eseguiamo questo codice, vedremo il seguente output dalla macro `panic!`:

```console
{{#include ../listings/ch09-error-handling/listing-09-04/output.txt}}
```

Come al solito, questo output ci dice esattamente cosa è andato storto.

### Confrontare diversi errori

Il codice nel Listato 9-4 farà `panic!` indipendentemente dal motivo per cui `File::open` ha fallito. Tuttavia, vogliamo intraprendere azioni diverse per diversi motivi di fallimento. Se `File::open` ha fallito perché il file non esiste, vogliamo creare il file e restituire l'handle del nuovo file. Se `File::open` ha fallito per qualsiasi altro motivo, ad esempio, perché non avevamo il permesso di aprire il file, vogliamo comunque che il codice faccia `panic!` nello stesso modo in cui faceva nel Listato 9-4. Per questo, aggiungiamo un'espressione `match` interna, mostrata nel Listato 9-5.

<span class="filename">Nome del file: src/main.rs</span>

<!-- ignore this test because otherwise it creates hello.txt which causes other
tests to fail lol -->

```rust,ignore
{{#rustdoc_include ../listings/ch09-error-handling/listing-09-05/src/main.rs}}
```

<span class="caption">Listato 9-5: Gestione in modi diversi di diversi tipi di errori</span>

Il tipo del valore che `File::open` restituisce all'interno della variante `Err` è `io::Error`, che è una struct fornita dalla libreria standard. Questa struct ha un metodo `kind` che possiamo chiamare per ottenere un valore `io::ErrorKind`. L'enum `io::ErrorKind` è fornito dalla libreria standard e ha delle varianti che rappresentano i diversi tipi di errori che possono risultare da un'operazione di `io`. La variante che vogliamo usare è `ErrorKind::NotFound`, che indica che il file che stiamo cercando di aprire non esiste ancora. Quindi confrontiamo `greeting_file_result`, ma abbiamo anche un match interno su `error.kind()`.

La condizione che vogliamo verificare nel match interno è se il valore restituito da `error.kind()` è la variante `NotFound` dell'enum `ErrorKind`. Se lo è, proviamo a creare il file con `File::create`. Tuttavia, poiché anche `File::create` potrebbe fallire, abbiamo bisogno di un secondo ramo nell'espressione `match` interna. Quando il file non può essere creato, viene stampato un messaggio di errore diverso. Il secondo ramo del `match` esterno rimane lo stesso, quindi il programma fa panic su qualsiasi errore oltre all'errore di file mancante.

> #### Alternative all'utilizzo di `match` con `Result<T, E>`
>
> È un sacco di `match`! L'espressione `match` è molto utile ma anche molto primitiva. Nel Capitolo 13 imparerai le closure, che vengono utilizzate con molti dei metodi definiti su `Result<T, E>`. Questi metodi possono essere più concisi rispetto all'utilizzo di `match` quando gestisci i valori `Result<T, E>` nel tuo codice.
>
> Ad esempio, ecco un altro modo per scrivere la stessa logica mostrata nel Listato 9-5, questa volta usando le closure e il metodo `unwrap_or_else`:
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
> Sebbene questo codice abbia lo stesso comportamento del Listato 9-5, non contiene espressioni `match` ed è più facile da leggere. Torna a questo esempio dopo aver letto il Capitolo 13 e cercare il metodo `unwrap_or_else` nella documentazione della libreria standard. Molti altri di questi metodi possono semplificare grandi `match` nidificati quando si ha a che fare con errori.

#### Scorciatoie per il Panic in caso di errore: `unwrap` ed `expect`

Usare `match` funziona abbastanza bene, ma può essere un po' verboso e non sempre comunica bene l'intento. Il tipo `Result<T, E>` ha molti metodi helper definiti su di esso per svolgere vari compiti più specifici. Il metodo `unwrap` è un metodo scorciatoia implementato proprio come l'espressione `match` che abbiamo scritto nel Listato 9-4. Se il valore `Result` è la variante `Ok`, `unwrap` restituirà il valore all'interno di `Ok`. Se il `Result` è la variante `Err`, `unwrap` chiamerà la macro `panic!` per noi. Ecco un esempio di `unwrap` in azione:

<span class="filename">Nome del file: src/main.rs</span>

```rust,should_panic
{{#rustdoc_include ../listings/ch09-error-handling/no-listing-04-unwrap/src/main.rs}}
```

Se eseguiamo questo codice senza un file *hello.txt*, vedremo un messaggio di errore dalla chiamata `panic!` che il metodo `unwrap` effettua:

<!-- manual-regeneration
cd listings/ch09-error-handling/no-listing-04-unwrap
cargo run
copy and paste relevant text
-->

```text
thread 'main' panicked at src/main.rs:4:49:
called `Result::unwrap()` on an `Err` value: Os { code: 2, kind: NotFound, message: "No such file or directory" }
```

Allo stesso modo, il metodo `expect` ci consente anche di scegliere il messaggio di errore `panic!`. Usare `expect` invece di `unwrap` e fornire buoni messaggi di errore può trasmettere meglio il tuo intento e rendere più facile rintracciare la fonte di un panic. La sintassi di `expect` appare in questo modo:

<span class="filename">Nome del file: src/main.rs</span>

```rust,should_panic
{{#rustdoc_include ../listings/ch09-error-handling/no-listing-05-expect/src/main.rs}}
```

Usiamo `expect` nello stesso modo di `unwrap`: per restituire l'handle del file o chiamare la macro `panic!`. Il messaggio di errore utilizzato da `expect` nella sua chiamata a `panic!` sarà il parametro che passiamo a `expect`, invece del messaggio predefinito `panic!` che `unwrap` utilizza. Ecco come appare:

<!-- manual-regeneration
cd listings/ch09-error-handling/no-listing-05-expect
cargo run
copy and paste relevant text
-->

```text
thread 'main' panicked at src/main.rs:5:10:
hello.txt should be included in this project: Os { code: 2, kind: NotFound, message: "No such file or directory" }
```

Nel codice di qualità di produzione, la maggior parte dei Rustaceans sceglie `expect` piuttosto che `unwrap` e dà più contesto sul perché l'operazione si prevede che abbia sempre successo. In questo modo, se le tue ipotesi dovessero mai essere dimostrate errate, hai più informazioni da utilizzare nel debugging.

### Propagazione degli errori

Quando l'implementazione di una funzione chiama qualcosa che potrebbe fallire, invece di gestire l'errore all'interno della funzione stessa puoi restituire l'errore al codice chiamante in modo che possa decidere cosa fare. Questo è noto come *propagazione* dell'errore e dà più controllo al codice chiamante, dove potrebbero esserci più informazioni o logiche che definiscono come dovrebbe essere gestito l'errore rispetto a ciò che hai disponibile nel contesto del tuo codice.

Ad esempio, il Listato 9-6 mostra una funzione che legge un nome utente da un file. Se il file non esiste o non può essere letto, questa funzione restituirà quegli errori al codice che ha chiamato la funzione.

<span class="filename">Nome del file: src/main.rs</span>

<!-- Deliberately not using rustdoc_include here; the `main` function in the
file panics. We do want to include it for reader experimentation purposes, but
don't want to include it for rustdoc testing purposes. -->

```rust
{{#include ../listings/ch09-error-handling/listing-09-06/src/main.rs:here}}
```

<span class="caption">Listato 9-6: Una funzione che restituisce errori al codice chiamante utilizzando `match`</span>

Questa funzione può essere scritta in modo molto più breve, ma iniziamo facendo gran parte di essa manualmente per esplorare la gestione degli errori; alla fine, mostreremo il modo più breve. Diamo prima un'occhiata al tipo di ritorno della funzione: `Result<String, io::Error>`. Questo significa che la funzione restituisce un valore del tipo `Result<T, E>`, dove il parametro generico `T` è stato riempito con il tipo concreto `String` e il tipo generico `E` è stato riempito con il tipo concreto `io::Error`.

Se questa funzione riesce senza alcun problema, il codice che chiama questa funzione riceverà un valore `Ok` che contiene una `String`: il `username` che questa funzione ha letto dal file. Se questa funzione incontra problemi, il codice chiamante riceverà un valore `Err` che contiene un'istanza di `io::Error` che fornisce maggiori informazioni su quali problemi si sono verificati. Abbiamo scelto `io::Error` come tipo di ritorno di questa funzione perché questo è il tipo di valore di errore restituito da entrambe le operazioni che stiamo chiamando nel Blocco di questa funzione che potrebbero fallire: la funzione `File::open` e il metodo `read_to_string`.

Il Blocco della funzione inizia chiamando la funzione `File::open`. Poi gestiamo il valore `Result` con un `match` simile al `match` nel Listato 9-4. Se `File::open` riesce, l'handle del file nel modello variabile `file` diventa il valore nella variabile mutabile `username_file` e la funzione continua. Nel caso di `Err`, invece di chiamare `panic!`, usiamo la parola chiave `return` per restituire anticipatamente l'errore al codice chiamante e passiamo indietro il valore di errore da `File::open`, ora nel modello variabile `e`, come valore di errore di questa funzione.

Quindi, se abbiamo un handle del file in `username_file`, la funzione crea poi un nuovo `String` nella variabile `username` e chiama il metodo `read_to_string` sull'handle del file in `username_file` per leggere il contenuto del file in `username`. Il metodo `read_to_string` ritorna anche un `Result` perché potrebbe fallire, anche se `File::open` è riuscita. Quindi abbiamo bisogno di un altro `match` per gestire quel `Result`: se `read_to_string` riesce, allora la nostra funzione ha successo, e restituiamo il nome utente dal file che è ora in `username` avvolto in un `Ok`. Se `read_to_string` fallisce, restituiamo il valore di errore nello stesso modo in cui abbiamo restituito il valore di errore nel `match` che ha gestito il valore di ritorno di `File::open`. Tuttavia, non abbiamo bisogno di dire esplicitamente `return`, perché questa è l'ultima espressione nella funzione.

Il codice che chiama questa funzione gestirà quindi l'ottenimento di un valore `Ok` che contiene un nome utente o un valore `Err` che contiene un `io::Error`. Spetta al codice chiamante decidere cosa fare con quei valori. Se il codice chiamante riceve un valore `Err`, potrebbe chiamare `panic!` e arrestare il programma, usare un nome utente predefinito o cercare il nome utente da un'altra parte che non sia un file, ad esempio. Non abbiamo abbastanza informazioni su cosa sta effettivamente cercando di fare il codice chiamante, quindi trasmettiamo tutte le informazioni di successo o errore verso l'alto perché possa gestirli adeguatamente.

Questa modalità di propagazione degli errori è così comune in Rust che Rust fornisce l'operatore punto interrogativo `?` per renderlo più facile.

#### Una scorciatoia per propagare errori: l'operatore `?`

Il Listato 9-7 mostra un'implementazione di `read_username_from_file` che ha la stessa funzionalità del Listato 9-6, ma questa implementazione utilizza l'operatore `?`.

<span class="filename">Nome del file: src/main.rs</span>

<!-- Deliberately not using rustdoc_include here; the `main` function in the
file panics. We do want to include it for reader experimentation purposes, but
don't want to include it for rustdoc testing purposes. -->

```rust
{{#include ../listings/ch09-error-handling/listing-09-07/src/main.rs:here}}
```

<span class="caption">Listato 9-7: Una funzione che restituisce errori al codice chiamante utilizzando l'operatore `?`</span>
Il `?` posto dopo un valore `Result` è definito per funzionare quasi allo stesso modo
delle espressioni `match` che abbiamo definito per gestire i valori `Result` nella Lista 9-6. Se il valore del `Result` è un `Ok`, il valore all'interno dell'`Ok` verrà restituito da questa espressione, e il programma continuerà. Se il valore è un `Err`, l'`Err` verrà restituito dall'intera funzione come se avessimo usato la parola chiave `return`, in modo che il valore di errore venga propagato al codice chiamante.

C'è una differenza tra ciò che fa l'espressione `match` nella Lista 9-6 e ciò che fa l'operatore `?`: i valori di errore che hanno chiamato l'operatore `?` passano attraverso la funzione `from`, definita nel `From` trait nella libreria standard, che viene usata per convertire valori da un tipo a un altro. Quando l'operatore `?` chiama la funzione `from`, il tipo di errore ricevuto viene convertito nel tipo di errore definito nel tipo di ritorno della funzione corrente. Questo è utile quando una funzione restituisce un tipo di errore per rappresentare tutti i modi in cui una funzione potrebbe fallire, anche se parti potrebbero fallire per molte ragioni diverse.

Ad esempio, potremmo cambiare la funzione `read_username_from_file` nella Lista 9-7 per restituire un tipo di errore personalizzato chiamato `OurError` che definiamo. Se definiamo anche `impl From<io::Error> for OurError` per costruire un'istanza di `OurError` da un `io::Error`, allora le chiamate all'operatore `?` nel blocco di `read_username_from_file` chiameranno `from` e convertiranno i tipi di errore senza bisogno di aggiungere altro codice alla funzione.

Nel contesto della Lista 9-7, il `?` alla fine della chiamata `File::open` restituirà il valore all'interno di un `Ok` alla variabile `username_file`. Se si verifica un errore, l'operatore `?` restituirà in anticipo fuori dall'intera funzione e consegnerà qualsiasi valore `Err` al codice chiamante. La stessa cosa si applica al `?` alla fine della chiamata `read_to_string`.

L'operatore `?` elimina molta parte del codice ripetitivo e rende l'implementazione di questa funzione più semplice. Potremmo accorciare ulteriormente questo codice concatenando le chiamate ai metodi immediatamente dopo il `?`, come mostrato nella Lista 9-8.

<span class="filename">Nome del file: src/main.rs</span>

<!-- Deliberatamente non usando rustdoc_include qui; la funzione `main` nel
file genera panic. Vogliamo includerlo a scopo di sperimentazione da parte del lettore, ma
non vogliamo includerlo a scopo di test con rustdoc. -->

```rust
{{#include ../listings/ch09-error-handling/listing-09-08/src/main.rs:here}}
```

<span class="caption">Lista 9-8: Concatenazione delle chiamate ai metodi dopo l'operatore `?`</span>

Abbiamo spostato la creazione del nuovo `String` in `username` all'inizio della funzione; quella parte non è cambiata. Invece di creare una variabile `username_file`, abbiamo concatenato la chiamata a `read_to_string` direttamente sul risultato di `File::open("hello.txt")?`. Abbiamo ancora un `?` alla fine della chiamata `read_to_string`, e restituiamo ancora un valore `Ok` contenente `username` quando sia `File::open` che `read_to_string` hanno successo, piuttosto che restituire errori. La funzionalità è nuovamente la stessa delle Liste 9-6 e 9-7; questo è solo un modo diverso, più ergonomico, di scriverlo.

La Lista 9-9 mostra un modo per rendere questo ancora più breve usando `fs::read_to_string`.

<span class="filename">Nome del file: src/main.rs</span>

<!-- Deliberatamente non usando rustdoc_include qui; la funzione `main` nel
file genera panic. Vogliamo includerlo a scopo di sperimentazione da parte del lettore, ma
non vogliamo includerlo a scopo di test con rustdoc. -->

```rust
{{#include ../listings/ch09-error-handling/listing-09-09/src/main.rs:here}}
```

<span class="caption">Lista 9-9: Utilizzo di `fs::read_to_string` invece di aprire e poi leggere il file</span>

Leggere un file in una stringa è un'operazione abbastanza comune, quindi la libreria standard fornisce la comoda funzione `fs::read_to_string` che apre il file, crea un nuovo `String`, legge il contenuto del file, mette il contenuto in quella `String` e lo restituisce. Ovviamente, usare `fs::read_to_string` non ci dà l'opportunità di spiegare tutta la gestione degli errori, quindi l'abbiamo fatto nel modo più lungo prima.

#### Dove può essere usato l'operatore `?`

L'operatore `?` può essere usato solo in funzioni il cui tipo di ritorno è compatibile con il valore su cui si usa `?`. Questo perché l'operatore `?` è definito per eseguire un ritorno anticipato di un valore fuori dalla funzione, nello stesso modo dell'espressione `match` che abbiamo definito nella Lista 9-6. Nella Lista 9-6, il `match` stava usando un valore `Result`, e il ramo di ritorno anticipato restituiva un valore `Err(e)`. Il tipo di ritorno della funzione deve essere un `Result` affinché sia compatibile con questo `return`.

Nella Lista 9-10, guardiamo all'errore che otterremo se usiamo l'operatore `?` in una funzione `main` con un tipo di ritorno che è incompatibile con il tipo di valore su cui usiamo `?`.

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch09-error-handling/listing-09-10/src/main.rs}}
```

<span class="caption">Lista 9-10: Tentativo di usare il `?` nella funzione `main` che restituisce `()` non compila.</span>

Questo codice apre un file, che potrebbe fallire. L'operatore `?` segue il valore `Result` restituito da `File::open`, ma questa funzione `main` ha il tipo di ritorno `()`, non `Result`. Quando compiliamo questo codice, otteniamo il seguente messaggio di errore:

```console
{{#include ../listings/ch09-error-handling/listing-09-10/output.txt}}
```

Questo errore sottolinea che ci è permesso usare l'operatore `?` solo in una funzione che restituisce `Result`, `Option`, o un altro tipo che implementa `FromResidual`.

Per correggere l'errore, hai due scelte. Una scelta è cambiare il tipo di ritorno della tua funzione per essere compatibile con il valore su cui stai usando l'operatore `?` a condizione che tu non abbia restrizioni che lo impediscano. L'altra scelta è utilizzare un `match` o uno dei metodi `Result<T, E>` per gestire il `Result<T, E>` nel modo più appropriato.

Il messaggio di errore ha anche menzionato che `?` può essere usato anche con valori `Option<T>`. Come con l'uso di `?` su `Result`, puoi usare `?` su `Option` solo in una funzione che restituisce un `Option`. Il comportamento dell'operatore `?` quando chiamato su un `Option<T>` è simile al suo comportamento quando chiamato su un `Result<T, E>`: se il valore è `None`, il `None` verrà restituito in anticipo dalla funzione a quel punto. Se il valore è `Some`, il valore all'interno di `Some` è il valore risultante dell'espressione, e la funzione continua. La Lista 9-11 contiene un esempio di una funzione che trova l'ultimo carattere della prima riga nel testo fornito.

```rust
{{#rustdoc_include ../listings/ch09-error-handling/listing-09-11/src/main.rs:here}}
```

<span class="caption">Lista 9-11: Uso dell'operatore `?` su un valore `Option<T>`</span>

Questa funzione restituisce `Option<char>` perché è possibile che ci sia un carattere lì, ma è anche possibile che non ci sia. Questo codice prende l'argomento `text` string slice e chiama il metodo `lines` su di esso, che restituisce un iteratore sulle righe nella stringa. Poiché questa funzione vuole esaminare la prima riga, chiama `next` sull'iteratore per ottenere il primo valore dall'iteratore. Se `text` è la stringa vuota, questa chiamata a `next` restituirà `None`, nel qual caso usiamo `?` per fermarci e restituire `None` da `last_char_of_first_line`. Se `text` non è la stringa vuota, `next` restituirà un valore `Some` contenente un string slice della prima riga in `text`.

Il `?` estrae lo string slice, e possiamo chiamare `chars` su quello string slice per ottenere un iteratore dei suoi caratteri. Siamo interessati all'ultimo carattere di questa prima riga, quindi chiamiamo `last` per restituire l'ultimo elemento dell'iteratore. Questo è un `Option` perché è possibile che la prima riga sia la stringa vuota; ad esempio, se `text` inizia con una riga vuota ma ha caratteri su altre righe, come in `"\nhi"`. Tuttavia, se c'è un ultimo carattere nella prima riga, verrà restituito nella variante `Some`. L'operatore `?` nel mezzo ci dà un modo conciso di esprimere questa logica, permettendoci di implementare la funzione in una sola riga. Se non potessimo usare l'operatore `?` su `Option`, dovremmo implementare questa logica usando più chiamate ai metodi o un'espressione `match`.

Nota che puoi usare l'operatore `?` su un `Result` in una funzione che restituisce `Result`, e puoi usare l'operatore `?` su un `Option` in una funzione che restituisce `Option`, ma non puoi mescolare e abbinare. L'operatore `?` non convertirà automaticamente un `Result` in un `Option` o viceversa; in quei casi, puoi usare metodi come il metodo `ok` su `Result` o il metodo `ok_or` su `Option` per fare la conversione esplicitamente.

Fino ad ora, tutte le funzioni `main` che abbiamo usato restituiscono `()`. La funzione `main` è speciale perché è il punto di ingresso e di uscita di un programma eseguibile, e ci sono restrizioni su quale tipo di ritorno può avere affinché il programma si comporti come previsto.

Fortunatamente, `main` può anche restituire un `Result<(), E>`. La Lista 9-12 ha il codice dalla Lista 9-10, ma abbiamo cambiato il tipo di ritorno di `main` in `Result<(), Box<dyn Error>>` e aggiunto un valore di ritorno `Ok(())` alla fine. Questo codice ora verrà compilato.

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch09-error-handling/listing-09-12/src/main.rs}}
```

<span class="caption">Lista 9-12: Cambio della funzione `main` per restituire `Result<(), E>` consente l'uso dell'operatore `?` sui valori `Result`.</span>

Il tipo `Box<dyn Error>` è un *trait object*, di cui parleremo nella sezione [“Usare Trait Objects che Consentono Valori di Tipi Diversi”][trait-objects]<!-- ignore --> nel Capitolo 17. Per ora, puoi leggere `Box<dyn Error>` come “qualsiasi tipo di errore.” Usare `?` su un valore `Result` in una funzione `main` con il tipo di errore `Box<dyn Error>` è permesso perché consente a qualsiasi valore `Err` di essere restituito in anticipo. Anche se il corpo di questa funzione `main` restituirà solo errori di tipo `std::io::Error`, specificando `Box<dyn Error>`, questa firma continuerà a essere corretta anche se più codice che restituisce altri errori viene aggiunto al blocco di `main`.

Quando una funzione `main` restituisce un `Result<(), E>`, l'eseguibile uscirà con un valore di `0` se `main` restituisce `Ok(())` e uscirà con un valore diverso da zero se `main` restituisce un valore `Err`. Gli eseguibili scritti in C restituiscono interi quando escono: i programmi che escono con successo restituiscono l'intero `0`, e i programmi che generano errori restituiscono un intero diverso da `0`. Anche Rust restituisce interi dagli eseguibili per essere compatibile con questa convenzione.

La funzione `main` può restituire qualsiasi tipo che implementa [il trait `std::process::Termination`][termination]<!-- ignore -->, che contiene una funzione `report` che restituisce un `ExitCode`. Consulta la documentazione della libreria standard per ulteriori informazioni sull'implementazione del trait `Termination` per i tuoi tipi.

Ora che abbiamo discusso i dettagli del chiamare `panic!` o restituire `Result`, torniamo al tema di come decidere quale sia appropriato utilizzare in quali casi.

[handle_failure]: ch02-00-guessing-game-tutorial.html#handling-potential-failure-with-result
[trait-objects]: ch17-02-trait-objects.html#using-trait-objects-that-allow-for-values-of-different-types
[termination]: ../std/process/trait.Termination.html
