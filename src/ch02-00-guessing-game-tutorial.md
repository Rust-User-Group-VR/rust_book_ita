# Programmare un Gioco di Indovinelli

Immergiamoci in Rust lavorando insieme a un progetto pratico! Questo capitolo ti introdurrà a pochi concetti comuni di Rust mostrandoti come usarli in un programma reale. Imparerai a conoscere `let`, `match`, metodi, funzioni associate, *crate* esterne e altro ancora! Nei capitoli successivi, esploreremo queste idee in maggior dettaglio. In questo capitolo, eserciterai solo le basi.

Implementeremo un classico problema di programmazione per principianti: un gioco di indovinelli. Ecco come funziona: il programma genererà un intero casuale tra 1 e 100. Chiederà quindi al giocatore di inserire un indovinello. Dopo che un indovinello è stato inserito, il programma indicherà se l'indovinello è troppo basso o troppo alto. Se l'indovinello è corretto, il gioco stamperà un messaggio di congratulazioni ed uscirà.

## Configurazione di un Nuovo Progetto

Per configurare un nuovo progetto, vai alla directory *projects* che hai creato nel Capitolo 1 e crea un nuovo progetto usando Cargo, come segue:

```console
$ cargo new guessing_game
$ cd guessing_game
```

Il primo comando, `cargo new`, prende il nome del progetto (`guessing_game`) come primo argomento. Il secondo comando cambia nella directory del nuovo progetto.

Guarda il file *Cargo.toml* generato:

<!-- manual-regeneration
cd listings/ch02-guessing-game-tutorial
rm -rf no-listing-01-cargo-new
cargo new no-listing-01-cargo-new --name guessing_game
cd no-listing-01-cargo-new
cargo run > output.txt 2>&1
cd ../../..
-->

<span class="filename">Nome del file: Cargo.toml</span>

```toml
{{#include ../listings/ch02-guessing-game-tutorial/no-listing-01-cargo-new/Cargo.toml}}
```

Come hai visto nel Capitolo 1, `cargo new` genera un programma “Hello, world!” per te. Controlla il file *src/main.rs*:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/no-listing-01-cargo-new/src/main.rs}}
```

Ora compiliamo questo programma “Hello, world!” ed eseguiamolo nello stesso passaggio usando il comando `cargo run`:

```console
{{#include ../listings/ch02-guessing-game-tutorial/no-listing-01-cargo-new/output.txt}}
```

Il comando `run` è utile quando hai bisogno di iterare rapidamente su un progetto, come faremo in questo gioco, testando rapidamente ogni iterazione prima di passare alla successiva.

Riapri il file *src/main.rs*. Scriverai tutto il codice in questo file.

## Elaborare un Indovinello

La prima parte del programma del gioco di indovinelli chiederà l'input dell'utente, elaborerà quell'input e verificherà che l'input sia nella forma prevista. Per iniziare, permetteremo al giocatore di inserire un indovinello. Inserisci il codice nell'Elenco 2-1 in *src/main.rs*.

<Elenco numero="2-1" nome-file="src/main.rs" didascalia="Codice che ottiene un indovinello dall'utente e lo stampa">

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-01/src/main.rs:all}}
```

</Elenco> 

Questo codice contiene molte informazioni, quindi esaminiamolo riga per riga. Per ottenere l'input dell'utente e poi stampare il risultato come output, dobbiamo portare la libreria `io` di input/output nello Scope. La libreria `io` proviene dalla libreria standard, conosciuta come `std`:

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-01/src/main.rs:io}}
```

Per default, Rust ha un insieme di elementi definiti nella libreria standard che porta nello Scope di ogni programma. Questo insieme è chiamato *prelude*, e puoi vedere tutto ciò che contiene [nella documentazione della libreria standard][prelude].

Se un tipo che vuoi usare non è nel prelude, devi portare esplicitamente quel tipo nello Scope con un'istruzione `use`. Usare la libreria `std::io` ti fornisce una serie di funzionalità utili, inclusa la possibilità di accettare input dall'utente.

Come hai visto nel Capitolo 1, la funzione `main` è il punto di ingresso nel programma:

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-01/src/main.rs:main}}
```

La sintassi `fn` dichiara una nuova funzione; le parentesi tonde, `()`, indicano che non ci sono parametri; e la parentesi graffa, `{`, inizia il Blocco della funzione.

Come hai anche imparato nel Capitolo 1, `println!` è una macro che stampa una stringa a schermo:

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-01/src/main.rs:print}}
```

Questo codice sta stampando un prompt che dichiara cosa sia il gioco e richiede un input dall'utente.

### Memorizzare Valori con le Variabili

Successivamente, creeremo una *variabile* per memorizzare l'input dell'utente, come segue:

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-01/src/main.rs:string}}
```

Ora il programma diventa interessante! C'è molto in corso in questa piccola riga. Usiamo l'istruzione `let` per creare la variabile. Ecco un altro esempio:

```rust,ignore
let apples = 5;
```

Questa linea crea una nuova variabile chiamata `apples` e la associa al valore 5. In Rust, le variabili sono immutabili per default, il che significa che una volta assegnato un valore alla variabile, questo valore non cambierà. Discuteremo questo concetto in dettaglio nella sezione [“Variabili e Mutabilità”][variables-and-mutability]<!-- ignore --> nel Capitolo 3. Per rendere una variabile mutabile, aggiungiamo `mut` prima del nome della variabile:

```rust,ignore
let apples = 5; // immutabile
let mut bananas = 5; // mutabile
```

> Nota: La sintassi `//` inizia un commento che continua fino alla fine della linea. Rust ignora tutto nei commenti. Discuteremo i commenti in modo più dettagliato nel [Capitolo 3][comments]<!-- ignore -->.

Tornando al programma del gioco di indovinelli, ora sai che `let mut guess` introdurrà una variabile mutabile chiamata `guess`. Il segno di uguale (`=`) dice a Rust che vogliamo associare qualcosa alla variabile ora. A destra del segno di uguale c'è il valore a cui `guess` è associato, ovvero il risultato della chiamata a `String::new`, una funzione che restituisce una nuova istanza di una `String`.
[`String`][string]<!-- ignore --> è un tipo di stringa fornito dalla libreria standard che è un testo UTF-8 codificato espandibile.

La sintassi `::` nella linea `::new` indica che `new` è una funzione associata del tipo `String`. Una *funzione associata* è una funzione che è implementata su un tipo, in questo caso `String`. Questa funzione `new` crea una nuova stringa vuota. Troverai una funzione `new` su molti tipi perché è un nome comune per una funzione che crea un nuovo valore di qualche tipo.

In sintesi, la linea `let mut guess = String::new();` ha creato una variabile mutabile che è attualmente associata a una nuova istanza vuota di una `String`. Uff!

### Ricevere Input dall'Utente

Ricordati che abbiamo incluso la funzionalità di input/output dalla libreria standard con `use std::io;` nella prima linea del programma. Ora chiameremo la funzione `stdin` dal modulo `io`, il quale ci permetterà di gestire l'input dell'utente:

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-01/src/main.rs:read}}
```

Se non avessimo importato la libreria `io` con `use std::io;` all'inizio del programma, potremmo ancora usare la funzione scrivendo questa chiamata di funzione come `std::io::stdin`. La funzione `stdin` restituisce un'istanza di [`std::io::Stdin`][iostdin]<!-- ignore -->, che è un tipo che rappresenta un handle per l'input standard del tuo terminale.

Successivamente, la riga `.read_line(&mut guess)` chiama il metodo [`read_line`][read_line]<!-- ignore --> sull'handle di input standard per ottenere l'input dall'utente. Passiamo anche `&mut guess` come argomento a `read_line` per dirgli in quale stringa memorizzare l'input dell'utente. Il lavoro completo di `read_line` è prendere qualsiasi cosa l'utente digiti nell'input standard e appenderla a una stringa (senza sovrascrivere il suo contenuto), quindi passiamo quella stringa come argomento. La stringa ha bisogno di essere mutabile affinché il metodo possa cambiare il contenuto della stringa.

Il `&` indica che questo argomento è una *referenza*, che ti dà un modo di far accedere parti multiple del tuo codice a un pezzo di dati senza doverne copiare i dati in memoria più volte. Le referenze sono una caratteristica complessa e uno dei maggiori vantaggi di Rust è quanto sia sicuro e facile usare le referenze. Non hai bisogno di sapere molti di quei dettagli per completare questo programma. Per ora, tutto ciò che devi sapere è che, come le variabili, le referenze sono immutabili per default. Pertanto, devi scrivere `&mut guess` piuttosto che `&guess` per renderla mutabile. (Il Capitolo 4 spiegherà le referenze in modo più approfondito.)

<!-- Old heading. Do not remove or links may break. -->
<a id="handling-potential-failure-with-the-result-type"></a>

### Gestire il Potenziale Fallimento con `Result`

Stiamo ancora lavorando su questa riga di codice. Ora stiamo discutendo una terza riga di testo, ma nota che fa ancora parte di una singola riga logica di codice. La parte successiva di questo metodo è:

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-01/src/main.rs:expect}}
```

Avremmo potuto scrivere questo codice come:

```rust,ignore
io::stdin().read_line(&mut guess).expect("Failed to read line");
```

Tuttavia, una riga lunga è difficile da leggere, quindi è meglio dividerla. È spesso saggio introdurre un nuovo riga e altri spazi bianchi per aiutare a spezzare righe lunghe quando chiami un metodo con la sintassi `.method_name()`. Ora discutiamo cosa fa questa linea.

Come menzionato prima, `read_line` mette qualsiasi cosa l'utente inserisca nella stringa che passiamo ad essa, ma restituisce anche un valore `Result`. [`Result`][result]<!-- ignore --> è un [*enumeration*][enums]<!-- ignore -->, spesso chiamato *enum*, che è un tipo che può essere in uno di molti stati possibili. Chiamiamo ciascun stato possibile una *variante*.

Il [Capitolo 6][enums]<!-- ignore --> coprirà gli enum in modo più dettagliato. Lo scopo di questi tipi `Result` è codificare le informazioni sulla gestione degli errori.

Le varianti di `Result` sono `Ok` ed `Err`. La variante `Ok` indica che l'operazione è stata eseguita con successo, e dentro `Ok` c'è il valore generato con successo. La variante `Err` significa che l'operazione è fallita, e `Err` contiene informazioni su come o perché l'operazione è fallita.

Valori del tipo `Result`, come valori di qualsiasi tipo, hanno metodi definiti su di loro. Un'istanza di `Result` ha un metodo [`expect`][expect]<!-- ignore --> che puoi chiamare. Se questa istanza di `Result` è un valore `Err`, `expect` farà sì che il programma si arresti e visualizzi il messaggio che hai passato come argomento a `expect`. Se il metodo `read_line` restituisce un `Err`, è probabile che sia il risultato di un errore proveniente dal sistema operativo sottostante. Se questa istanza di `Result` è un valore `Ok`, `expect` prenderà il valore di ritorno che `Ok` sta trattenendo e restituirà solo quel valore a te in modo che tu possa usarlo. In questo caso, quel valore è il numero di byte nell'input dell'utente.

Se non chiami `expect`, il programma si compila, ma otterrai un avvertimento:

```console
{{#include ../listings/ch02-guessing-game-tutorial/no-listing-02-without-expect/output.txt}}
```

Rust avverte che non hai utilizzato il valore `Result` restituito da `read_line`, indicando che il programma non ha gestito un possibile errore.

Il modo giusto per eliminare l'avviso è scrivere effettivamente codice di gestione degli errori, ma nel nostro caso vogliamo solo che questo programma si arresti quando si verifica un problema, quindi possiamo usare `expect`. Imparerai a recuperare da errori nel [Capitolo 9][recover]<!-- ignore -->.

### Stampare Valori con i Segnaposto di `println!`

A parte la parentesi graffa di chiusura, c'è solo un'altra riga di cui discutere nel codice finora:

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-01/src/main.rs:print_guess}}
```

Questa riga stampa la stringa che ora contiene l'input dell'utente. Il set di parentesi graffe `{}` è un segnaposto: pensa a `{}` come piccole chele che tengono un valore in posizione. Quando si stampa il valore di una variabile, il nome della variabile può andare dentro le parentesi graffe. Quando si stampa il risultato di una espressione, posiziona parentesi graffe vuote nella stringa di formato, quindi segui la stringa di formato con un elenco separato da virgole di espressioni da stampare in ogni segnaposto di parentesi graffe vuoto nello stesso ordine. Stampare una variabile e il risultato di un'espressione in una chiamata a `println!` apparirebbe così:

```rust
let x = 5;
let y = 10;

println!("x = {x} and y + 2 = {}", y + 2);
```

Questo codice stamperebbe `x = 5 and y + 2 = 12`.

### Testare la Prima Parte

Testiamo la prima parte del gioco di indovinelli. Eseguilo usando `cargo run`:

<!-- manual-regeneration
cd listings/ch02-guessing-game-tutorial/listing-02-01/
cargo clean
cargo run
input 6 -->

```console
$ cargo run
   Compiling guessing_game v0.1.0 (file:///projects/guessing_game)
    Finished dev [unoptimized + debuginfo] target(s) in 6.44s
     Running `target/debug/guessing_game`
Guess the number!
Please input your guess.
6
You guessed: 6
```

A questo punto, la prima parte del gioco è finita: stiamo ottenendo input dalla tastiera e poi lo stampiamo.

## Generare un Numero Segreto

Successivamente, dobbiamo generare un numero segreto che l'utente tenterà di indovinare. Il numero segreto dovrebbe essere diverso ogni volta affinché il gioco sia divertente da giocare più di una volta. Useremo un numero casuale tra 1 e 100 in modo che il gioco non sia troppo difficile. Rust non include ancora funzionalità di numeri casuali nella sua libreria standard. Tuttavia, il team di Rust fornisce un [`crate rand`][randcrate] con tale funzionalità.

### Usare un Crate per Ottenere Maggiori Funzionalità

Ricorda che un crate è una raccolta di file di codice sorgente Rust. Il progetto su cui abbiamo lavorato è un *crate binario*, che è un eseguibile. Il crate `rand` è un *crate libreria*, che contiene codice destinato a essere utilizzato in altri programmi e non può essere eseguito da solo.

Il coordinamento dei crate esterni da parte di Cargo è dove Cargo brilla davvero. Prima di poter scrivere codice che utilizza `rand`, dobbiamo modificare il file *Cargo.toml* per includere il crate `rand` come dipendenza. Apri quel file ora e aggiungi la seguente riga in fondo, sotto l'intestazione della sezione `[dependencies]` che Cargo ha creato per te. Assicurati di specificare `rand` esattamente come abbiamo fatto qui, con questo numero di versione, altrimenti i codici di esempio in questo tutorial potrebbero non funzionare:

<!-- Quando aggiorni la versione di `rand` usata, aggiorna anche la versione di
`rand` usata in questi file, in modo che corrispondano tutti:
* ch07-04-bringing-paths-into-scope-with-the-use-keyword.md
* ch14-03-cargo-workspaces.md
-->

<span class="filename">Nome del file: Cargo.toml</span>

```toml
{{#include ../listings/ch02-guessing-game-tutorial/listing-02-02/Cargo.toml:8:}}
```


Nel file *Cargo.toml*, tutto ciò che segue un'intestazione fa parte di quella sezione che continua fino a quando non inizia un'altra sezione. In `[dependencies]` indichi a Cargo da quali crate esterni il tuo progetto dipende e quali versioni di quei crate richiedi. In questo caso, specifichiamo il crate `rand` con lo specificatore di versione semantica `0.8.5`. Cargo comprende il [Versionamento Semantico][semver]<!-- ignore --> (a volte chiamato *SemVer*), che è uno standard per scrivere numeri di versione. Lo specificatore `0.8.5` è in realtà un'abbreviazione per `^0.8.5`, il che significa qualsiasi versione che sia almeno 0.8.5 ma inferiore a 0.9.0.

Cargo considera queste versioni come aventi API pubbliche compatibili con la versione 0.8.5, e questa specifica garantisce che otterrai l'ultima release di patch che continuerà a compilare con il codice in questo capitolo. Qualsiasi versione 0.9.0 o successiva non è garantita per avere la stessa API di quanto utilizzato nei seguenti esempi.

Ora, senza cambiare nessuno del codice, costruiamo il progetto, come mostrato nel Listing 2-2.

<Listing number="2-2" caption="L'output dell'esecuzione di `cargo build` dopo aver aggiunto il crate rand come dipendenza">

```console
$ cargo build
    Updating crates.io index
  Downloaded rand v0.8.5
  Downloaded libc v0.2.127
  Downloaded getrandom v0.2.7
  Downloaded cfg-if v1.0.0
  Downloaded ppv-lite86 v0.2.16
  Downloaded rand_chacha v0.3.1
  Downloaded rand_core v0.6.3
   Compiling libc v0.2.127
   Compiling getrandom v0.2.7
   Compiling cfg-if v1.0.0
   Compiling ppv-lite86 v0.2.16
   Compiling rand_core v0.6.3
   Compiling rand_chacha v0.3.1
   Compiling rand v0.8.5
   Compiling guessing_game v0.1.0 (file:///projects/guessing_game)
    Finished dev [unoptimized + debuginfo] target(s) in 2.53s
```

</Listing>

Potresti vedere numeri di versione diversi (ma saranno tutti compatibili con il codice, grazie a SemVer!) e linee diverse (a seconda del sistema operativo), e le linee potrebbero essere in un ordine diverso.

Quando includiamo una dipendenza esterna, Cargo recupera le ultime versioni di tutto ciò che quella dipendenza necessita dal *registro*, che è una copia dei dati da [Crates.io][cratesio]. Crates.io è dove le persone nell'ecosistema Rust pubblicano i loro progetti Rust open source affinché altri possano utilizzarli.

Dopo aver aggiornato il registro, Cargo controlla la sezione `[dependencies]` e scarica qualsiasi crate elencato che non è già stato scaricato. In questo caso, sebbene abbiamo elencato solo `rand` come dipendenza, Cargo ha preso anche altri crate da cui `rand` dipende per funzionare. Dopo aver scaricato i crate, Rust li compila e poi compila il progetto con le dipendenze disponibili.

Se esegui immediatamente `cargo build` di nuovo senza apportare modifiche, non otterrai alcun output a parte la linea `Finished`. Cargo sa già di aver scaricato e compilato le dipendenze e tu non hai cambiato nulla su di esse nel tuo file *Cargo.toml*. Cargo sa anche che non hai cambiato nulla sul tuo codice, quindi non lo ricompila nemmeno. Con nulla da fare, semplicemente si chiude.

Se apri il file *src/main.rs*, fai una modifica banale, poi lo salvi e lo compili di nuovo, vedrai solo due righe di output:

```console
$ cargo build
   Compiling guessing_game v0.1.0 (file:///projects/guessing_game)
    Finished dev [unoptimized + debuginfo] target(s) in 2.53 secs
```

Queste righe mostrano che Cargo aggiorna solo la build con la tua piccola modifica al file *src/main.rs*. Le tue dipendenze non sono cambiate, quindi Cargo sa che può riutilizzare ciò che ha già scaricato e compilato per quelle.

#### Garantire Build Riproducibili con il File *Cargo.lock*

Cargo ha un meccanismo che garantisce che tu possa ricostruire lo stesso artefatto ogni volta che tu o chiunque altro costruisce il tuo codice: Cargo utilizzerà solo le versioni delle dipendenze che hai specificato finché non indichi altrimenti. Ad esempio, supponiamo che la prossima settimana venga rilasciata la versione 0.8.6 del crate `rand` e che quella versione contenga una correzione di bug importante, ma contenga anche una regressione che romperà il tuo codice. Per gestire ciò, Rust crea il file *Cargo.lock* la prima volta che esegui `cargo build`, quindi ora abbiamo questo nella directory *guessing_game*.

Quando costruisci un progetto per la prima volta, Cargo determina tutte le versioni delle dipendenze che soddisfano i criteri e poi le scrive nel file *Cargo.lock*. Quando costruisci il tuo progetto in futuro, Cargo vedrà che il file *Cargo.lock* esiste e utilizzerà le versioni specificate lì piuttosto che fare tutto il lavoro di determinare di nuovo le versioni. Questo ti consente di avere una build riproducibile automaticamente. In altre parole, il tuo progetto rimarrà a 0.8.5 finché non effettui un aggiornamento esplicito, grazie al file *Cargo.lock*. Poiché il file *Cargo.lock* è importante per le build riproducibili, spesso viene inserito nel controllo del codice sorgente insieme al resto del codice nel tuo progetto.

#### Aggiornare un Crate per Ottenere una Nuova Versione

Quando vuoi *veramente* aggiornare un crate, Cargo fornisce il comando `update`, che ignorerà il file *Cargo.lock* e determinerà tutte le ultime versioni che soddisfano le tue specifiche in *Cargo.toml*. Cargo scriverà poi quelle versioni nel file *Cargo.lock*. In questo caso, Cargo cercherà solo versioni maggiori di 0.8.5 e minori di 0.9.0. Se il crate `rand` ha rilasciato le due nuove versioni 0.8.6 e 0.9.0, vedresti quanto segue se eseguissi `cargo update`:

```console
$ cargo update
    Updating crates.io index
    Updating rand v0.8.5 -> v0.8.6
```

Cargo ignora il rilascio della 0.9.0. A questo punto, noteresti anche un cambiamento nel tuo file *Cargo.lock* che indica che la versione del crate `rand` che stai usando ora è 0.8.6. Per usare la versione 0.9.0 di `rand` o qualsiasi versione nella serie 0.9.*x*, dovresti aggiornare il file *Cargo.toml* in modo che assomigli a questo:

```toml
[dependencies]
rand = "0.9.0"
```

La prossima volta che eseguirai `cargo build`, Cargo aggiornerà il registro dei crate disponibili e rivaluterà le tue richieste `rand` secondo la nuova versione che hai specificato.

Ci sarebbe molto altro da dire su [Cargo][doccargo]<!-- ignore --> e [il suo ecosistema][doccratesio]<!-- ignore -->, di cui discuteremo nel Capitolo 14, ma per ora, questo è tutto ciò che devi sapere. Cargo rende molto facile riutilizzare le librerie, quindi i Rustaceans sono in grado di scrivere progetti più piccoli che sono assemblati da diversi pacchetti.

### Generazione di un Numero Casuale

Iniziamo a utilizzare `rand` per generare un numero da indovinare. Il passo successivo è aggiornare *src/main.rs*, come mostrato nel Listing 2-3.

<Listing number="2-3" file-name="src/main.rs" caption="Aggiungere codice per generare un numero casuale">

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-03/src/main.rs:all}}
```

</Listing>

Per prima cosa aggiungiamo la linea `use rand::Rng;`. Il `Rng` trait definisce metodi che i generatori di numeri casuali implementano, e questo trait deve essere nello Scope affinché possiamo utilizzare quei metodi. Il Capitolo 10 tratterà i trait in dettaglio.

Successivamente, stiamo aggiungendo due righe nel mezzo. Nella prima riga, chiamiamo la funzione `rand::thread_rng` che ci fornisce il particolare generatore di numeri casuali che stiamo per utilizzare: uno che è locale al thread di esecuzione corrente ed è seminato dal sistema operativo. Poi chiamiamo il metodo `gen_range` sul generatore di numeri casuali. Questo metodo è definito dal trait `Rng` che abbiamo portato nello Scope con l'istruzione `use rand::Rng;`. Il metodo `gen_range` prende un'espressione di intervallo come argomento e genera un numero casuale nell'intervallo. Il tipo di espressione di intervallo che stiamo utilizzando qui ha la forma `start..=end` ed è inclusivo sui limiti inferiore e superiore, quindi dobbiamo specificare `1..=100` per richiedere un numero tra 1 e 100.

> Nota: Non saprai semplicemente quali trait usare e quali metodi e funzioni chiamare da un crate, quindi ogni crate ha documentazione con istruzioni per utilizzarlo. Un'altra caratteristica interessante di Cargo è che eseguire il comando `cargo doc --open` costruirà la documentazione fornita da tutte le tue dipendenze localmente e la aprirà nel tuo browser. Se sei interessato ad altre funzionalità nel crate `rand`, ad esempio, esegui `cargo doc --open` e clicca su `rand` nella barra laterale a sinistra.

La seconda nuova linea stampa il numero segreto. Questo è utile mentre stiamo sviluppando il programma per poterlo testare, ma lo elimineremo dalla versione finale. Non è molto un gioco se il programma stampa la risposta appena inizia!

Prova a eseguire il programma alcune volte:

```console
$ cargo run
   Compiling guessing_game v0.1.0 (file:///projects/guessing_game)
    Finished dev [unoptimized + debuginfo] target(s) in 2.53s
     Running `target/debug/guessing_game`
Guess the number!
The secret number is: 7
Please input your guess.
4
You guessed: 4

$ cargo run
    Finished dev [unoptimized + debuginfo] target(s) in 0.02s
     Running `target/debug/guessing_game`
Guess the number!
The secret number is: 83
Please input your guess.
5
You guessed: 5
```

Dovresti ottenere numeri casuali diversi, e dovrebbero essere tutti numeri tra 1 e 100. Ottimo lavoro!

## Confrontare l'Indovinello con il Numero Segreto

Ora che abbiamo l'input dell'utente e un numero casuale, possiamo confrontarli. Quel passaggio è mostrato nel Listing 2-4. Nota che questo codice non sarà ancora compilabile, come spiegheremo.

<Listing number="2-4" file-name="src/main.rs" caption="Gestire i possibili valori di ritorno del confronto tra due numeri">

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-04/src/main.rs:here}}
```

</Listing>

Per prima cosa aggiungiamo un'altra istruzione `use`, portando un tipo chiamato `std::cmp::Ordering` nello Scope dalla libreria standard. Il tipo `Ordering` è un altro enum e ha le varianti `Less`, `Greater`, e `Equal`. Questi sono i tre risultati possibili quando confronti due valori.

Poi aggiungiamo cinque nuove righe in basso che utilizzano il tipo `Ordering`. Il metodo `cmp` confronta due valori e può essere chiamato su qualsiasi cosa che possa essere confrontata. Prende un riferimento a qualsiasi cosa vuoi confrontare: qui sta confrontando `guess` con `secret_number`. Poi restituisce una variante dell'enum `Ordering` che abbiamo portato nello Scope con l'istruzione `use`. Utilizziamo un'espressione [`match`][match]<!-- ignore --> per decidere cosa fare successivamente in base a quale variante di `Ordering` è stata restituita dalla chiamata a `cmp` con i valori in `guess` e `secret_number`.

Un'espressione `match` è costituita da *Rami*. Un Ramo consiste in un *Pattern* da abbinare e il codice che dovrebbe essere eseguito se il valore dato a `match` si adatta a quel Pattern del Ramo. Rust prende il valore dato a `match` e controlla ciascun Pattern del Ramo a turno. I Pattern e il costrutto `match` sono potenti caratteristiche di Rust: ti permettono di esprimere una varietà di situazioni che il tuo codice potrebbe incontrare e ti assicurano di gestirle tutte. Queste caratteristiche saranno trattate in dettaglio nel Capitolo 6 e nel Capitolo 18, rispettivamente.

Vediamo un esempio con l'espressione `match` che utilizziamo qui. Supponiamo che l'utente abbia indovinato 50 e che il numero segreto generato casualmente questa volta sia 38.

Quando il codice confronta 50 con 38, il metodo `cmp` restituirà `Ordering::Greater` perché 50 è maggiore di 38. L'espressione `match` ottiene il valore `Ordering::Greater` e inizia a verificare ogni Pattern del Ramo. Guarda il Pattern del primo Ramo, `Ordering::Less`, e vede che il valore `Ordering::Greater` non corrisponde a `Ordering::Less`, quindi ignora il codice in quel Ramo e passa al prossimo Ramo. Il Pattern del prossimo Ramo è `Ordering::Greater`, che *corrisponde* a `Ordering::Greater`! Il codice associato in quel Ramo sarà eseguito e stamperà `Too big!` sullo schermo. L'espressione `match` termina dopo la prima corrispondenza riuscita, quindi non esaminerà l'ultimo Ramo in questo scenario.

Tuttavia, il codice nel Listing 2-4 non sarà ancora compilabile. Proviamo:

```console
{{#include ../listings/ch02-guessing-game-tutorial/listing-02-04/output.txt}}
```

Il nucleo dell'errore afferma che ci sono *tipi non corrispondenti*. Rust ha un sistema tipologico forte e statico. Tuttavia, ha anche la determinazione del tipo. Quando abbiamo scritto `let mut guess = String::new()`, Rust è stato in grado di inferire che `guess` dovrebbe essere un `String` e non ci ha costretti a scrivere il tipo. D'altra parte, `secret_number` è un tipo numerico. Alcuni tipi numerici di Rust possono avere un valore tra 1 e 100: `i32`, un numero a 32 bit; `u32`, un numero Unsigned a 32 bit; `i64`, un numero a 64 bit; oltre ad altri. A meno che non sia specificato diversamente, Rust predefinisce un `i32`, che è il tipo di `secret_number` a meno che tu non aggiunga informazioni di tipo altrove che farebbero inferire a Rust un tipo numerico diverso. La ragione dell'errore è che Rust non può confrontare una stringa e un tipo numerico.

Alla fine, vogliamo convertire il `String` che il programma legge come input in un tipo numerico in modo da poterlo confrontare numericamente con il numero segreto. Lo facciamo aggiungendo questa riga al Blocco della funzione `main`:

<span class="filename">Nome file: src/main.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/no-listing-03-convert-string-to-number/src/main.rs:here}}
```

La linea è:

```rust,ignore
let guess: u32 = guess.trim().parse().expect("Please type a number!");
```

Creiamo una variabile chiamata `guess`. Ma aspetta, il programma ha già una variabile chiamata `guess`? Sì, ma Rust ci permette utilmente di sovrascrivere il valore precedente di `guess` con uno nuovo. *Shadowing* ci permette di riutilizzare il nome della variabile `guess` piuttosto che costringerci a creare due variabili uniche, come `guess_str` e `guess`, per esempio. Tratteremo questo in maggior dettaglio nel [Capitolo 3][shadowing]<!-- ignore -->, ma per ora, sappi che questa caratteristica è spesso utilizzata quando si desidera convertire un valore da un tipo a un altro tipo.
Noi leghiamo questa nuova variabile all'espressione `guess.trim().parse()`. Il `guess`
nell'espressione si riferisce alla variabile `guess` originale che conteneva
l'input come stringa. Il metodo `trim` su un'istanza di `String` eliminerà qualsiasi
spazio bianco all'inizio e alla fine, cosa che dobbiamo fare per poter confrontare la
stringa con il `u32`, che può contenere solo dati numerici. L'utente deve premere
<kbd>invio</kbd> per soddisfare `read_line` e inserire il loro guess, che aggiunge un
carattere di nuova linea alla stringa. Ad esempio, se l'utente digita <kbd>5</kbd> e
preme <kbd>invio</kbd>, `guess` appare così: `5\n`. Il `\n` rappresenta
“newline.” (Su Windows, premendo <kbd>invio</kbd> risulta in un ritorno a capo
e un newline, `\r\n`.) Il metodo `trim` elimina `\n` o `\r\n`, risultando
in solo `5`.

Il [metodo `parse` sulle stringhe][parse]<!-- ignore --> converte una stringa in
un altro tipo. Qui, lo usiamo per convertire da una stringa a un numero. Dobbiamo
dire a Rust esattamente il tipo di numero che vogliamo usando `let guess: u32`. Il duepunti
(`:`) dopo `guess` dice a Rust che annoteremo il tipo della variabile. Rust ha alcuni
tipi di numeri integrati; il `u32` visto qui è un intero senza segno a 32-bit.
È una buona scelta predefinita per un piccolo numero positivo. Imparerai a conoscere
altri tipi di numeri nel [Capitolo 3][integers]<!-- ignore -->.

Inoltre, l'annotazione `u32` in questo programma di esempio e la comparazione
con `secret_number` significano che Rust dedurrà che `secret_number` dovrebbe essere
anche un `u32`. Quindi ora la comparazione sarà tra due valori dello stesso tipo!

Il metodo `parse` funzionerà solo su caratteri che possono logicamente essere convertiti
in numeri e quindi può facilmente causare errori. Se, ad esempio, la stringa
conteneva `A👍%`, non ci sarebbe modo di convertirlo in un numero. Poiché potrebbe
fallire, il metodo `parse` restituisce un tipo `Result`, proprio come il metodo
`read_line` (discusso in precedenza in [“Gestire i fallimenti potenziali con
`Result`”](#handling-potential-failure-with-result)<!-- ignore-->). Tratteremo
questo `Result` nello stesso modo usando di nuovo il metodo `expect`. Se `parse`
restituisce una variante `Err` `Result` perché non è stato in grado di creare un numero dalla
stringa, la chiamata `expect` farà crashare il gioco e stampare il messaggio che gli diamo.
Se `parse` può convertire con successo la stringa in un numero, restituirà la
variante `Ok` di `Result`, e `expect` restituirà il numero che vogliamo dal
valore `Ok`.

Eseguiamo il programma ora:

<!-- manual-regeneration
cd listings/ch02-guessing-game-tutorial/no-listing-03-convert-string-to-number/
cargo run
  76
-->

```console
$ cargo run
   Compiling guessing_game v0.1.0 (file:///projects/guessing_game)
    Finished dev [unoptimized + debuginfo] target(s) in 0.43s
     Running `target/debug/guessing_game`
Indovina il numero!
Il numero segreto è: 58
Per favore inserisci il tuo guess.
  76
Hai indovinato: 76
Troppo grande!
```

Bello! Anche se erano stati aggiunti spazi prima del guess, il programma ha comunque capito
che l'utente ha indovinato 76. Esegui il programma alcune volte per verificare il
comportamento diverso con diversi tipi di input: indovina il numero correttamente,
indovina un numero che è troppo alto, e indovina un numero che è troppo basso.

Abbiamo quasi tutto il gioco funzionante ora, ma l'utente può fare solo un guess.
Modifichiamolo aggiungendo un loop!

## Permettere Molteplici Guess con Looping

La keyword `loop` crea un loop infinito. Aggiungeremo un loop per dare agli utenti
più possibilità di indovinare il numero:

<span class="filename">Filename: src/main.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/no-listing-04-looping/src/main.rs:here}}
```

Come puoi vedere, abbiamo spostato tutto dal prompt di inserimento del guess in poi dentro
un loop. Assicurati di indentare le righe all'interno del loop di ulteriori quattro spazi ciascuna
e esegui nuovamente il programma. Ora il programma chiederà un altro guess all'infinito,
il che introduce un nuovo problema. Non sembra che l'utente possa uscire!

L'utente potrebbe sempre interrompere il programma utilizzando la scorciatoia da tastiera
<kbd>ctrl</kbd>-<kbd>c</kbd>. Ma c'è un altro modo per sfuggire a questo insaziabile
mostro, come menzionato nella discussione del `parse` in [“Comparare il Guess al
Numero Segreto”](#comparing-the-guess-to-the-secret-number)<!-- ignore -->: se
l'utente inserisce una risposta non numerica, il programma si bloccherà. Possiamo trarre
vantaggio di ciò per consentire all'utente di uscire, come mostrato qui:

<!-- manual-regeneration
cd listings/ch02-guessing-game-tutorial/no-listing-04-looping/
cargo run
(guess troppo piccolo)
(guess troppo grande)
(guess corretto)
quit
-->

```console
$ cargo run
   Compiling guessing_game v0.1.0 (file:///projects/guessing_game)
    Finished dev [unoptimized + debuginfo] target(s) in 1.50s
     Running `target/debug/guessing_game`
Indovina il numero!
Il numero segreto è: 59
Per favore inserisci il tuo guess.
45
Hai indovinato: 45
Troppo piccolo!
Per favore inserisci il tuo guess.
60
Hai indovinato: 60
Troppo grande!
Per favore inserisci il tuo guess.
59
Hai indovinato: 59
Hai vinto!
Per favore inserisci il tuo guess.
quit
thread 'main' panicked at 'Per favore digita un numero!: ParseIntError { kind: InvalidDigit }', src/main.rs:28:47
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace
```

Digitare `quit` uscirà dal gioco, ma come noterai, anche inserire qualsiasi
altro input non numerico farà lo stesso. Questo è subottimale, per non dire altro; vogliamo che il gioco
si fermi anche quando il numero corretto è stato indovinato.

### Uscire Dopo un Indovinamento Corretto

Programmiamo il gioco per uscire quando l'utente vince aggiungendo una dichiarazione `break`:

<span class="filename">Filename: src/main.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/no-listing-05-quitting/src/main.rs:here}}
```

Aggiungere la riga `break` dopo `Hai vinto!` fa uscire il programma dal loop
quando l'utente indovina correttamente il numero segreto. Uscire dal loop significa
anche uscire dal programma, perché il loop è l'ultima parte di `main`.

### Gestire Input Non Validi

Per affinare ulteriormente il comportamento del gioco, invece di far crashare il programma quando
l'utente inserisce un non-numero, facciamo in modo che il gioco ignori un non-numero così l'utente
può continuare a indovinare. Possiamo farlo modificando la riga in cui `guess`
è convertito da una `String` a un `u32`, come mostrato nel Listing 2-5.

<Listing number="2-5" file-name="src/main.rs" caption="Ignorare un guess non numerico e chiedere un altro guess invece di far crashare il programma">

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-05/src/main.rs:here}}
```

</Listing>

Passiamo da una chiamata `expect` a un'espressione `match` per passare dal crash
su un errore alla gestione dell'errore. Ricorda che `parse` restituisce un tipo
`Result` e `Result` è un enum che ha le varianti `Ok` e `Err`. Stiamo usando
un'espressione `match` qui, come abbiamo fatto con il risultato di `Ordering` del metodo `cmp`.

Se `parse` è in grado di convertire con successo la stringa in un numero, restituirà
un valore `Ok` che contiene il numero risultante. Quel valore `Ok` corrisponderà
al pattern del primo Ramo, e l'espressione `match` restituirà semplicemente il valore
`num` che `parse` ha prodotto e inserito nel valore `Ok`. Quel numero
finirà esattamente dove lo vogliamo nella nuova variabile `guess` che stiamo creando.

Se `parse` *non* è in grado di trasformare la stringa in un numero, restituirà un
valore `Err` che contiene ulteriori informazioni sull'errore. Il valore `Err`
non corrisponde al pattern `Ok(num)` nel primo Ramo `match`, ma corrisponde
al pattern `Err(_)` nel secondo Ramo. Il trattino basso, `_`, è un
valore di ripiego; in questo esempio, stiamo dicendo che vogliamo far corrispondere tutti i valori
`Err`, non importa quali informazioni abbiano al loro interno. Quindi il programma
eseguirà il codice del secondo Ramo, `continue`, che dice al programma di passare
all'iterazione successiva del `loop` e chiedere un altro guess. Quindi, effettivamente, 
il programma ignorerà tutti gli errori che `parse` potrebbe incontrare!

Ora tutto nel programma dovrebbe funzionare come previsto. Proviamolo:

<!-- manual-regeneration
cd listings/ch02-guessing-game-tutorial/listing-02-05/
cargo run
(guess troppo piccolo)
(guess troppo grande)
foo
(guess corretto)
-->

```console
$ cargo run
   Compiling guessing_game v0.1.0 (file:///projects/guessing_game)
    Finished dev [unoptimized + debuginfo] target(s) in 4.45s
     Running `target/debug/guessing_game`
Indovina il numero!
Il numero segreto è: 61
Per favore inserisci il tuo guess.
10
Hai indovinato: 10
Troppo piccolo!
Per favore inserisci il tuo guess.
99
Hai indovinato: 99
Troppo grande!
Per favore inserisci il tuo guess.
foo
Per favore inserisci il tuo guess.
61
Hai indovinato: 61
Hai vinto!
```

Fantastico! Con un piccolo ultimo aggiustamento, finiremo il gioco dell'indovinello. Ricorda
che il programma sta ancora stampando il numero segreto. È stato utile per
testare, ma rovina il gioco. Eliminiamo il `println!` che stampa il
numero segreto. Il Listing 2-6 mostra il codice finale.

<Listing number="2-6" file-name="src/main.rs" caption="Codice completo del gioco dell'indovinello">

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-06/src/main.rs}}
```

</Listing>

A questo punto, hai costruito con successo il gioco dell'indovinello. Congratulazioni!

## Sommario

Questo progetto è stato un modo pratico per introdurti a molti nuovi concetti di Rust:
`let`, `match`, funzioni, l'uso di crate esterni, e altro. Nei prossimi
capitoli, imparerai questi concetti in maggiore dettaglio. Il Capitolo 3
copre concetti che la maggior parte dei linguaggi di programmazione hanno, come variabili, tipi
di dati e funzioni, e mostra come usarli in Rust. Il Capitolo 4 esplora
ownership, una caratteristica che rende Rust diverso dagli altri linguaggi. Il Capitolo 5
discute structs e sintassi dei metodi, e il Capitolo 6 spiega come funzionano gli enum.

[prelude]: ../std/prelude/index.html
[variables-and-mutability]: ch03-01-variables-and-mutability.html#variables-and-mutability
[comments]: ch03-04-comments.html
[string]: ../std/string/struct.String.html
[iostdin]: ../std/io/struct.Stdin.html
[read_line]: ../std/io/struct.Stdin.html#method.read_line
[result]: ../std/result/enum.Result.html
[enums]: ch06-00-enums.html
[expect]: ../std/result/enum.Result.html#method.expect
[recover]: ch09-02-recoverable-errors-with-result.html
[randcrate]: https://crates.io/crates/rand
[semver]: http://semver.org
[cratesio]: https://crates.io/
[doccargo]: https://doc.rust-lang.org/cargo/
[doccratesio]: https://doc.rust-lang.org/cargo/reference/publishing.html
[match]: ch06-02-match.html
[shadowing]: ch03-01-variables-and-mutability.html#shadowing
[parse]: ../std/primitive.str.html#method.parse
[integers]: ch03-02-data-types.html#integer-types
