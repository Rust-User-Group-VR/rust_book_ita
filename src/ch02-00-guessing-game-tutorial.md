# Programmare un Gioco di Indovinelli

Immergiamoci in Rust lavorando a un progetto pratico insieme! Questo capitolo ti introduce ad alcuni concetti comuni di Rust mostrandoti come usarli in un programma reale. Imparerai a conoscere `let`, `match`, metodi, funzioni associate, crate esterni e altro ancora! Nei capitoli seguenti, esploreremo questi concetti in dettaglio. In questo capitolo, ti eserciterai solo sui fondamentali.

Implementeremo un classico problema di programmazione per principianti: un gioco di indovinelli. Ecco come funziona: il programma genererà un numero intero casuale tra 1 e 100. Quindi inviterà il giocatore a inserire un indovinello. Dopo che è stato inserito, il programma indicherà se l’indovinello è troppo basso o troppo alto. Se l’indovinello è corretto, il gioco stamperà un messaggio di congratulazioni e uscirà.

## Configurare un Nuovo Progetto

Per configurare un nuovo progetto, vai nella directory *projects* che hai creato nel Capitolo 1 e crea un nuovo progetto utilizzando Cargo, così:

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

Ora compiliamo questo programma “Hello, world!” e eseguiamolo nello stesso passo usando il comando `cargo run`:

```console
{{#include ../listings/ch02-guessing-game-tutorial/no-listing-01-cargo-new/output.txt}}
```

Il comando `run` è utile quando hai bisogno di iterare rapidamente su un progetto, come faremo in questo gioco, testando velocemente ogni iterazione prima di passare a quella successiva.

Riapri il file *src/main.rs*. Scriverai tutto il codice in questo file.

## Elaborare un Indovinello

La prima parte del programma del gioco di indovinelli chiederà l'input dell'utente, elaborerà tale input e controllerà che l'input sia nella forma prevista. Per iniziare, permetteremo al giocatore di inserire un indovinello. Inserisci il codice nel Listing 2-1 in *src/main.rs*.

<Listing number="2-1" file-name="src/main.rs" caption="Codice che ottiene un indovinello dall'utente e lo stampa">

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-01/src/main.rs:all}}
```

</Listing> 

Questo codice contiene molte informazioni, quindi esaminiamolo riga per riga. Per ottenere l'input dell'utente e quindi stampare il risultato come output, dobbiamo importare la libreria di input/output `io` nello Scope. La libreria `io` proviene dalla libreria standard, conosciuta come `std`:

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-01/src/main.rs:io}}
```

Per impostazione predefinita, Rust ha un insieme di elementi definiti nella libreria standard che include nello Scope di ogni programma. Questo insieme è chiamato *prelude*, e puoi vedere tutto ciò che contiene [nella documentazione della libreria standard][prelude].

Se il tipo che vuoi usare non è nel prelude, devi importerlo esplicitamente nello Scope con un'istruzione `use`. Usare la libreria `std::io` ti fornisce un numero di funzionalità utili, inclusa la possibilità di accettare l'input dell'utente.

Come hai visto nel Capitolo 1, la funzione `main` è il punto d'ingresso nel programma:

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-01/src/main.rs:main}}
```

La sintassi `fn` dichiara una nuova funzione; le parentesi, `()`, indicano che non ci sono parametri; e le parentesi graffe, `{`, iniziano il corpo della funzione.

Come hai anche imparato nel Capitolo 1, `println!` è una macro che stampa una stringa sullo schermo:

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-01/src/main.rs:print}}
```

Questo codice sta stampando un prompt che indica qual è il gioco e richiede input dall’utente.

### Memorizzare i Valori con le Variabili

Successivamente, creeremo una *variabile* per memorizzare l’input dell’utente, come questo:

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-01/src/main.rs:string}}
```

Ora il programma sta diventando interessante! C’è molto in questa piccola riga. Usiamo l'istruzione `let` per creare la variabile. Ecco un altro esempio:

```rust,ignore
let apples = 5;
```

Questa riga crea una nuova variabile chiamata `apples` e la lega al valore 5. In Rust, le variabili sono immutabili per impostazione predefinita, il che significa che una volta assegnato il valore alla variabile, il valore non cambierà. Discuteremo questo concetto in dettaglio nella sezione [“Variabili e Mutabilità”][variables-and-mutability]<!-- ignore --> nel Capitolo 3. Per rendere una variabile mutabile, aggiungiamo `mut` prima del nome della variabile:

```rust,ignore
let apples = 5; // immutabile
let mut bananas = 5; // mutabile
```

> Nota: La sintassi `//` inizia un commento che continua fino alla fine della
> riga. Rust ignora tutto nei commenti. Discuteremo i commenti in modo più
> dettagliato nel [Capitolo 3][comments]<!-- ignore -->.

Ritornando al programma di gioco di indovinelli, ora sai che `let mut guess` introdurrà una variabile mutabile chiamata `guess`. Il segno di uguale (`=`) dice a Rust che vogliamo legare qualcosa alla variabile ora. A destra del segno di uguale c'è il valore a cui `guess` è legato, che è il risultato della chiamata a `String::new`, una funzione che restituisce una nuova istanza di una `String`. [`String`][string]<!-- ignore --> è un tipo di stringa fornito dalla libreria standard che è un testo UTF-8 espandibile.

La sintassi `::` nella riga `::new` indica che `new` è una funzione associata al tipo `String`. Una *funzione associata* è una funzione che è implementata su un tipo, in questo caso `String`. Questa funzione `new` crea una nuova stringa vuota. Troverai una funzione `new` su molti tipi perché è un nome comune per una funzione che crea un nuovo valore di qualche tipo.

In sintesi, la riga `let mut guess = String::new();` ha creato una variabile mutabile che è attualmente legata a una nuova istanza vuota di una `String`. Uffa!

### Ricevere Input dall’Utente

Ricorda che abbiamo incluso la funzionalità di input/output dalla libreria standard con `use std::io;` nella prima riga del programma. Ora chiameremo la funzione `stdin` dal modulo `io`, che ci permetterà di gestire l'input dell'utente:

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-01/src/main.rs:read}}
```

Se non avessimo importato la libreria `io` con `use std::io;` all'inizio del programma, potremmo ancora usare la funzione scrivendo questa chiamata di funzione come `std::io::stdin`. La funzione `stdin` restituisce un'istanza di [`std::io::Stdin`][iostdin]<!-- ignore -->, che è un tipo che rappresenta un handle all'input standard per il tuo terminale.

Successivamente, la riga `.read_line(&mut guess)` chiama il metodo [`read_line`][read_line]<!-- ignore --> sull'handle dell'input standard per ottenere l'input dall'utente. Stiamo anche passando `&mut guess` come argomento a `read_line` per dirgli in quale stringa memorizzare l’input dell’utente. Il compito completo di `read_line` è prendere qualsiasi cosa l’utente digiti nell’input standard e aggiungerla a una stringa (senza sovrascriverne i contenuti), quindi passiamo quella stringa come argomento. L’argomento della stringa deve essere mutabile affinché il metodo possa cambiare il contenuto della stringa.

Il `&` indica che questo argomento è un *reference*, il che ti dà un modo per permettere a più parti del tuo codice di accedere a un pezzo di dati senza dover copiare quei dati in memoria più volte. I reference sono una caratteristica complessa, e uno dei grandi vantaggi di Rust è quanto sia sicuro e facile usare i reference. Non hai bisogno di sapere molti di questi dettagli per finire questo programma. Per ora, tutto ciò che devi sapere è che, come le variabili, i reference sono immutabili per impostazione predefinita. Pertanto, devi scrivere `&mut guess` anziché `&guess` per renderlo mutabile. (Il Capitolo 4 spiegherà i reference più approfonditamente.)

<!-- Old heading. Do not remove or links may break. -->
<a id="handling-potential-failure-with-the-result-type"></a>

### Gestione di Potenziali Errori con `Result`

Stiamo ancora lavorando su questa riga di codice. Stiamo ora discutendo una terza riga di testo, ma nota che fa ancora parte di una singola riga logica di codice. La parte successiva è questo metodo:

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-01/src/main.rs:expect}}
```

Avremmo potuto scrivere questo codice come:

```rust,ignore
io::stdin().read_line(&mut guess).expect("Failed to read line");
```

Tuttavia, una riga lunga è difficile da leggere, quindi è meglio dividerla. È spesso saggio introdurre un'interruzione di riga e altri spazi bianchi per aiutare a suddividere le righe lunghe quando si chiama un metodo con la sintassi `.method_name()`. Ora discutiamo cosa fa questa riga.

Come menzionato prima, `read_line` inserisce qualsiasi cosa l’utente inserisca nella stringa che gli passiamo, ma restituisce anche un valore `Result`. [`Result`][result]<!-- ignore --> è una [*enumerazione*][enums]<!-- ignore -->, spesso chiamata *enum*, che è un tipo che può essere in uno dove multiple possibili stati. Chiamiamo ciascun possibile stato una *variante*.

Il [Capitolo 6][enums]<!-- ignore --> coprirà le enum in modo più dettagliato. Lo scopo di questi tipi `Result` è codificare informazioni sulla gestione degli errori.

Le varianti di `Result` sono `Ok` e `Err`. La variante `Ok` indica che l'operazione è stata eseguita con successo e all'interno di `Ok` c'è il valore generato con successo. La variante `Err` significa che l'operazione è fallita, e `Err` contiene informazioni su come o perché l'operazione è fallita.

I valori del tipo `Result`, come i valori di qualsiasi tipo, hanno metodi definiti su di essi. Un'istanza di `Result` ha un [metodo `expect`][expect]<!-- ignore --> che puoi chiamare. Se questa istanza di `Result` è un valore `Err`, `expect` causerà il crash del programma e visualizzerà il messaggio che hai passato come argomento a `expect`. Se il metodo `read_line` restituisce un `Err`, probabilmente sarà il risultato di un errore proveniente dal sistema operativo sottostante. Se questa istanza di `Result` è un valore `Ok`, `expect` prenderà il valore restituito che `Ok` sta mantenendo e restituirà solo quel valore in modo che tu possa usarlo. In questo caso, quel valore è il numero di byte nell’input dell’utente.

Se non chiami `expect`, il programma verrà compilato, ma riceverai un avviso:

```console
{{#include ../listings/ch02-guessing-game-tutorial/no-listing-02-without-expect/output.txt}}
```

Rust avverte che non hai usato il valore `Result` restituito da `read_line`, indicando che il programma non ha gestito un possibile errore.

Il modo giusto per sopprimere l’avviso è scrivere effettivamente il codice per la gestione degli errori, ma nel nostro caso vogliamo solo che questo programma vada in crash quando si verifica un problema, quindi possiamo usare `expect`. Imparerai a gestire il recupero dagli errori nel [Capitolo 9][recover]<!-- ignore -->.

### Stampare Valori con i Segnaposto `println!`

A parte la parentesi graffa di chiusura, c'è solo un'altra riga di cui discutere nel codice finora:

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-01/src/main.rs:print_guess}}
```

Questa riga stampa la stringa che ora contiene l’input dell’utente. Il set di parentesi graffe `{}` è un segnaposto: pensa a `{}` come a piccole chele di granchio che tengono in posizione un valore. Quando stampi il valore di una variabile, il nome della variabile può andare all'interno delle parentesi graffe. Quando stampi il risultato della valutazione di un’espressione, inserisci parentesi graffe vuote nella stringa di formato, poi segui la stringa di formato con una lista di espressioni separate da virgole da stampare in ogni segnaposto di parentesi graffe vuote nello stesso ordine. Stampare una variabile e il risultato di un’espressione in una chiamata a `println!` sembrerebbe così:

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
Indovina il numero!
Per favore, inserisci il tuo indovinello.
6
Hai indovinato: 6
```

A questo punto, la prima parte del gioco è fatta: stiamo ottenendo l’input dalla tastiera e poi lo stiamo stampando.

## Generare un Numero Segreto

Successivamente, dobbiamo generare un numero segreto che l’utente tenterà di indovinare. Il numero segreto dovrebbe essere diverso ogni volta in modo che il gioco sia divertente da giocare più di una volta. Utilizzeremo un numero casuale tra 1 e 100 in modo che il gioco non sia troppo difficile. Rust non include ancora la funzionalità per i numeri casuali nella sua libreria standard. Tuttavia, il team di Rust fornisce un [`crate rand`][randcrate] con quella funzionalità.

### Utilizzare un Crate per Ottenere Più Funzionalità

Ricorda che un crate è una raccolta di file di codice sorgente Rust. Il progetto che abbiamo costruito è un *crate binario*, che è un eseguibile. Il crate `rand` è un *crate libreria*, che contiene codice destinato a essere usato in altri programmi e non può essere eseguito da solo.

Il coordinamento di Cargo con i crate esterni è dove Cargo brilla davvero. Prima di poter scrivere codice che utilizzi `rand`, dobbiamo modificare il file *Cargo.toml* per includere il crate `rand` come dipendenza. Apri quel file ora e aggiungi la seguente riga in fondo, sotto l’intestazione della sezione `[dependencies]` che Cargo ha creato per te. Assicurati di specificare `rand` esattamente come abbiamo fatto qui, con questa versione, altrimenti gli esempi di codice in questo tutorial potrebbero non funzionare:

<!-- When updating the version of `rand` used, also update the version of
`rand` used in these files so they all match:
* ch07-04-bringing-paths-into-scope-with-the-use-keyword.md
* ch14-03-cargo-workspaces.md
-->

<span class="filename">Nome del file: Cargo.toml</span>

```toml
{{#include ../listings/ch02-guessing-game-tutorial/listing-02-02/Cargo.toml:8:}}
```


Nel file *Cargo.toml*, tutto ciò che segue un'intestazione fa parte di quella sezione che continua fino a quando non inizia un'altra sezione. In `[dependencies]` indichi a Cargo di quali crate esterni il tuo progetto dipende e quali versioni di quei crate richiedi. In questo caso, specifichiamo il crate `rand` con lo specificatore di versione semantica `0.8.5`. Cargo comprende il [versionamento semantico][semver]<!-- ignore --> (a volte chiamato *SemVer*), che è uno standard per scrivere i numeri di versione. Lo specificatore `0.8.5` è in realtà una scorciatoia per `^0.8.5`, il che significa qualsiasi versione almeno 0.8.5 ma inferiore a 0.9.0.

Cargo considera queste versioni come aventi API pubbliche compatibili con la versione 0.8.5, e questa specifica assicura che otterrai l'ultima release della patch che continuerà a compilare con il codice in questo capitolo. Qualsiasi versione 0.9.0 o superiore non è garantita di avere la stessa API di quanto usato nei seguenti esempi.

Ora, senza modificare alcun codice, costruiamo il progetto, come mostrato nel Listing 2-2.

<!-- manual-regeneration
cd listings/ch02-guessing-game-tutorial/listing-02-02/
rm Cargo.lock
cargo clean
cargo build -->

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

Potresti vedere numeri di versione diversi (ma saranno comunque compatibili con il codice, grazie a SemVer!) e linee diverse (a seconda del sistema operativo), e le linee potrebbero essere in un ordine diverso.

Quando includiamo una dipendenza esterna, Cargo preleva le versioni più recenti di tutto ciò che quella dipendenza necessita dal *registro*, che è una copia di dati da [Crates.io][cratesio]. Crates.io è dove le persone nell'ecosistema Rust pubblicano i loro progetti Rust open source affinché altri possano utilizzarli.

Dopo aver aggiornato il registro, Cargo controlla la sezione `[dependencies]` e scarica qualsiasi crate elencato che non sia già stato scaricato. In questo caso, anche se abbiamo elencato solo `rand` come dipendenza, Cargo ha anche preso altri crate di cui `rand` dipende per funzionare. Dopo aver scaricato i crate, Rust li compila e poi compila il progetto con le dipendenze disponibili.

Se esegui immediatamente `cargo build` di nuovo senza fare alcuna modifica, non otterrai alcun output oltre alla riga `Finished`. Cargo sa che ha già scaricato e compilato le dipendenze e non hai cambiato nulla nel tuo file *Cargo.toml*. Cargo sa anche che non hai cambiato nulla del tuo codice, quindi non ricompila neanche quello. Non avendo nulla da fare, semplicemente esce.

Se apri il file *src/main.rs*, fai una modifica banale e poi lo salvi e lo ricostruisci, vedrai solo due righe di output:

<!-- manual-regeneration
cd listings/ch02-guessing-game-tutorial/listing-02-02/
touch src/main.rs
cargo build -->

```console
$ cargo build
   Compiling guessing_game v0.1.0 (file:///projects/guessing_game)
    Finished dev [unoptimized + debuginfo] target(s) in 2.53 secs
```

Queste righe mostrano che Cargo aggiorna solo la build con il tuo piccolo cambiamento al file *src/main.rs*. Le tue dipendenze non sono cambiate, quindi Cargo sa che può riutilizzare ciò che ha già scaricato e compilato per quelle.

#### Garantire Build Riproducibili con il File *Cargo.lock*

Cargo ha un meccanismo che assicura che tu possa ricostruire lo stesso artefatto ogni volta che tu o qualcun altro costruite il tuo codice: Cargo utilizzerà solo le versioni delle dipendenze che hai specificato finché non indicherai diversamente. Per esempio, supponiamo che la prossima settimana esca la versione 0.8.6 del crate `rand`, e che quella versione contenga una correzione importante di un bug, ma contenga anche una regressione che romperà il tuo codice. Per gestire questo, Rust crea il file *Cargo.lock* la prima volta che esegui `cargo build`, quindi ora abbiamo questo nella directory *guessing_game*.

Quando costruisci un progetto per la prima volta, Cargo determina tutte le versioni delle dipendenze che soddisfano i criteri e poi le scrive nel file *Cargo.lock*. Quando costruisci il tuo progetto in futuro, Cargo vedrà che il file *Cargo.lock* esiste e utilizzerà le versioni specificate lì piuttosto che fare tutto il lavoro di determinare di nuovo le versioni. Questo ti permette di avere una build riproducibile automaticamente. In altre parole, il tuo progetto rimarrà alla versione 0.8.5 finché non esegui un aggiornamento esplicito, grazie al file *Cargo.lock*. Poiché il file *Cargo.lock* è importante per build riproducibili, spesso è incluso nel controllo del codice sorgente insieme al resto del codice del tuo progetto.

#### Aggiornare un Crate per Ottenere una Nuova Versione

Quando *vuoi* aggiornare un crate, Cargo fornisce il comando `update`, che ignorerà il file *Cargo.lock* e determinerà tutte le versioni più recenti che soddisfano le tue specifiche in *Cargo.toml*. Cargo scriverà quindi quelle versioni nel file *Cargo.lock*. In questo caso, Cargo cercherà solo versioni maggiori di 0.8.5 e minori di 0.9.0. Se il crate `rand` ha rilasciato le due nuove versioni 0.8.6 e 0.9.0, vedresti quanto segue se eseguissi `cargo update`:

<!-- manual-regeneration
cd listings/ch02-guessing-game-tutorial/listing-02-02/
cargo update
assuming there is a new 0.8.x version of rand; otherwise use another update
as a guide to creating the hypothetical output shown here -->

```console
$ cargo update
    Updating crates.io index
    Updating rand v0.8.5 -> v0.8.6
```

Cargo ignora la release 0.9.0. A questo punto, noteresti anche una modifica nel file *Cargo.lock* che indica che la versione del crate `rand` che stai ora utilizzando è la 0.8.6. Per utilizzare la versione 0.9.0 di `rand` o qualsiasi versione nella serie 0.9.*x*, dovresti aggiornare il file *Cargo.toml* per assomigliare a questo:

```toml
[dependencies]
rand = "0.9.0"
```

La prossima volta che esegui `cargo build`, Cargo aggiornerà il registro dei crate disponibili e rivaluterà i tuoi requisiti di `rand` in base alla nuova versione che hai specificato.

C'è molto altro da dire su [Cargo][doccargo]<!-- ignore --> e [il suo ecosistema][doccratesio]<!-- ignore -->, di cui discuteremo nel Capitolo 14, ma per ora, questo è tutto quello che devi sapere. Cargo rende molto facile riutilizzare le librerie, quindi i Rustaceans possono scrivere progetti più piccoli che sono assemblati da un numero di pacchetti.

### Generare un Numero Casuale

Iniziamo a usare `rand` per generare un numero da indovinare. Il prossimo passo è aggiornare *src/main.rs*, come mostrato nel Listing 2-3.

<Listing number="2-3" file-name="src/main.rs" caption="Aggiungere codice per generare un numero casuale">

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-03/src/main.rs:all}}
```

</Listing>

Per prima cosa aggiungiamo la riga `use rand::Rng;`. Il trait `Rng` definisce i metodi che i generatori di numeri casuali implementano, e questo trait deve essere nello scope affinché possiamo usare quei metodi. Il Capitolo 10 coprirà i trait in dettaglio.

Successivamente, aggiungiamo due righe nel mezzo. Nella prima riga, chiamiamo la funzione `rand::thread_rng` che ci dà il particolare generatore di numeri casuali che useremo: uno che è locale al thread di esecuzione corrente ed è seminato dal sistema operativo. Poi chiamiamo il metodo `gen_range` sul generatore di numeri casuali. Questo metodo è definito dal trait `Rng` che abbiamo portato nello scope con l'istruzione `use rand::Rng;`. Il metodo `gen_range` prende un'espressione di intervallo come argomento e genera un numero casuale nell'intervallo. Il tipo di espressione di intervallo che stiamo usando qui prende la forma `start..=end` ed è inclusivo sui limiti inferiori e superiori, quindi dobbiamo specificare `1..=100` per richiedere un numero tra 1 e 100.

> Nota: Non saprai solo quali trait usare e quali metodi e funzioni chiamare da un crate, quindi ogni crate ha documentazione con istruzioni per usarlo. Un'altra caratteristica interessante di Cargo è che eseguendo il comando `cargo doc --open` verrà costruita la documentazione fornita da tutte le tue dipendenze localmente e aperta nel tuo browser. Se sei interessato ad altre funzionalità nel crate `rand`, per esempio, esegui `cargo doc --open` e fai clic su `rand` nella barra laterale a sinistra.

La seconda nuova riga stampa il numero segreto. Questo è utile mentre stiamo sviluppando il programma per poterlo testare, ma lo cancelleremo dalla versione finale. Non è molto un gioco se il programma stampa la risposta non appena inizia!

Prova a eseguire il programma alcune volte:

<!-- manual-regeneration
cd listings/ch02-guessing-game-tutorial/listing-02-03/
cargo run
4
cargo run
5
-->

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
Indovina il numero!
Il numero segreto è: 83
Per favore inserisci il tuo indovinello.
5
Hai indovinato: 5
```

Dovresti ottenere numeri casuali diversi, e dovrebbero essere tutti numeri tra 1 e 100. Ottimo lavoro!

## Confrontare l'Indovinello con il Numero Segreto

Ora che abbiamo l'input dell'utente e un numero casuale, possiamo confrontarli. Questo passaggio è mostrato nel Listing 2-4. Nota che questo codice non compila ancora, come spiegheremo.

<Listing number="2-4" file-name="src/main.rs" caption="Gestire i possibili valori di ritorno del confronto tra due numeri">

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-04/src/main.rs:here}}
```

</Listing>

Per prima cosa aggiungiamo un'altra istruzione `use`, portando un tipo chiamato
`std::cmp::Ordering` nello scope dalla libreria standard. Il tipo `Ordering` è un altro enum e ha le varianti `Less`, `Greater`, e `Equal`. Questi sono i tre risultati possibili quando confronti due valori.

Poi aggiungiamo cinque nuove righe in fondo che utilizzano il tipo `Ordering`. Il metodo `cmp` confronta due valori e può essere chiamato su qualsiasi cosa possa essere confrontata. Prende un riferimento a ciò con cui vuoi confrontare: qui sta confrontando `guess` con il `secret_number`. Poi restituisce una variante dell'enum `Ordering` che abbiamo portato nello scope con l'istruzione `use`. Utilizziamo un'espressione [`match`][match]<!-- ignore --> per decidere cosa fare successivamente in base a quale variante di `Ordering` è stata restituita dalla chiamata a `cmp` con i valori in `guess` e `secret_number`.

Un'espressione `match` è composta da *braccia*. Un braccio consiste in un *pattern* da abbinare e il codice che dovrebbe essere eseguito se il valore dato a `match` si adatta a quel pattern del braccio. Rust prende il valore dato a `match` e guarda attraverso il pattern di ciascun braccio a turno. I pattern e il costrutto `match` sono potenti funzionalità di Rust: ti permettono di esprimere una varietà di situazioni che il tuo codice potrebbe incontrare e ti assicurano di gestirle tutte. Queste funzionalità saranno trattate in dettaglio nel Capitolo 6 e nel Capitolo 18, rispettivamente.

Esaminiamo un esempio con l'espressione `match` che usiamo qui. Supponiamo che l'utente abbia indovinato 50 e il numero segreto generato casualmente questa volta sia 38.

Quando il codice confronta 50 con 38, il metodo `cmp` restituirà
`Ordering::Greater` perché 50 è maggiore di 38. L'espressione `match` ottiene il valore `Ordering::Greater` e inizia a controllare il pattern di ciascun braccio. Guarda il pattern del primo braccio, `Ordering::Less`, e vede che il valore `Ordering::Greater` non corrisponde a `Ordering::Less`, quindi ignora il codice in quel braccio e passa al prossimo braccio. Il pattern del prossimo braccio è `Ordering::Greater`, che *corrisponde* a `Ordering::Greater`! Il codice associato in quel braccio verrà eseguito e stampa `Too big!` sullo schermo. L'espressione `match` termina dopo il primo abbinamento riuscito, quindi non guarderà l'ultimo braccio in questo scenario.

Tuttavia, il codice nel Listing 2-4 non compila ancora. Proviamo:

<!--
I numeri degli errori in questo output dovrebbero essere quelli del codice **SENZA** l'ancora o i commenti snip
-->

```console
{{#include ../listings/ch02-guessing-game-tutorial/listing-02-04/output.txt}}
```

Il nucleo dell'errore afferma che ci sono *tipi non corrispondenti*. Rust ha un sistema di tipi forte e statico. Tuttavia, ha anche l'inferenza dei tipi. Quando abbiamo scritto `let mut guess = String::new()`, Rust è stato in grado di inferire che `guess` dovrebbe essere una `String` e non ci ha fatto scrivere il tipo. Il `secret_number`, d'altra parte, è un tipo numerico. Alcuni dei tipi numerici di Rust possono avere un valore tra 1 e 100: `i32`, un numero a 32 bit; `u32`, un numero senza segno a 32 bit; `i64`, un numero a 64 bit; così come altri. Se non diversamente specificato, Rust predefinito è uno `i32`, che è il tipo di `secret_number` a meno che tu non aggiunga informazioni di tipo altrove che farebbero inferire a Rust un tipo numerico diverso. La ragione dell'errore è che Rust non può confrontare una stringa e un tipo numerico.

In definitiva, vogliamo convertire la `String` che il programma legge come input in un tipo numerico in modo da poterla confrontare numericamente con il numero segreto. Lo facciamo aggiungendo questa riga al corpo della funzione `main`:

<span class="filename">Filename: src/main.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/no-listing-03-convert-string-to-number/src/main.rs:here}}
```

La riga è:

```rust,ignore
let guess: u32 = guess.trim().parse().expect("Please type a number!");
```

Creiamo una variabile chiamata `guess`. Ma aspetta, il programma non ha già una variabile chiamata `guess`? Sì, ma fortunatamente Rust ci permette di ombreggiare il valore precedente di `guess` con uno nuovo. L'*ombreggiatura* ci permette di riutilizzare il nome della variabile `guess` piuttosto che costringerci a creare due variabili uniche, come `guess_str` e `guess`, per esempio. Copriremo questo in maggior dettaglio nel [Capitolo 3][shadowing]<!-- ignore -->, ma per ora, sappi che questa funzionalità è spesso utilizzata quando vuoi convertire un valore da un tipo a un altro tipo.


Abbiamo associato questa nuova variabile all'espressione `guess.trim().parse()`. Il `guess`
nell'espressione si riferisce alla variabile `guess` originale che conteneva
l'input come una stringa. Il metodo `trim` su un'istanza di `String` eliminerà qualsiasi
spazio bianco all'inizio e alla fine, cosa che dobbiamo fare per poter confrontare la
stringa con il `u32`, che può contenere solo dati numerici. L'utente deve premere
<kbd>invio</kbd> per soddisfare `read_line` e inserire il proprio guess, il che aggiunge un
carattere di nuova linea alla stringa. Ad esempio, se l'utente digita <kbd>5</kbd> e
preme <kbd>invio</kbd>, `guess` apparirà così: `5\n`. Il `\n` rappresenta
"nuova linea". (Su Windows, premendo <kbd>invio</kbd> si genera un ritorno a capo
e una nuova linea, `\r\n`.) Il metodo `trim` elimina `\n` o `\r\n`, risultando
in solo `5`.

Il [metodo `parse` sulle stringhe][parse]<!-- ignore --> converte una stringa in
un altro tipo. Qui, lo usiamo per convertire da una stringa a un numero. Dobbiamo
dire a Rust il tipo di numero esatto che vogliamo usando `let guess: u32`. I due punti
(`:`) dopo `guess` indicano a Rust che annoteremo il tipo della variabile. Rust ha diversi
tipi di numeri integrati; il `u32` visto qui è un intero senza segno a 32 bit.
È una buona scelta predefinita per un numero positivo piccolo. Imparerai altri
tipi di numeri nel [Capitolo 3][integers]<!-- ignore -->.

Inoltre, l'annotazione `u32` in questo programma di esempio e il confronto
con `secret_number` implica che Rust dedurrà che `secret_number` dovrebbe essere
un `u32` anche. Quindi ora il confronto sarà tra due valori dello stesso
tipo!

Il metodo `parse` funzionerà solo su caratteri che possono essere logicamente convertiti
in numeri e quindi può facilmente causare errori. Se, per esempio, la stringa
conteneva `A👍%`, non ci sarebbe modo di convertire ciò in un numero. Poiché potrebbe
fallire, il metodo `parse` restituisce un tipo `Result`, proprio come il metodo `read_line`
(discusso in precedenza in [“Gestire i Potenziali Errori con `Result`”](#handling-potential-failure-with-result)<!-- ignore -->). Tratteremo
questo `Result` allo stesso modo usando nuovamente il metodo `expect`. Se `parse`
restituisce una variante `Err` del `Result` perché non è riuscita a creare un numero dalla
stringa, la chiamata `expect` farà crollare il gioco e stampare il messaggio che gli diamo.
Se `parse` riesce a convertire correttamente la stringa in un numero, restituirà la
variante `Ok` del `Result`, e `expect` restituirà il numero che vogliamo dal
valore `Ok`.

Eseguiamo ora il programma:

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
Guess the number!
The secret number is: 58
Please input your guess.
  76
You guessed: 76
Too big!
```

Fantastico! Anche se sono stati aggiunti spazi prima del guess, il programma ha comunque
capito che l'utente ha guessato 76. Esegui il programma alcune volte per verificare il
diverso comportamento con diversi tipi di input: indovinare il numero correttamente,
indovinare un numero troppo alto e indovinare un numero troppo basso.

Abbiamo la maggior parte del gioco che funziona ora, ma l'utente può fare solo un guess.
Cambiamo ciò aggiungendo un loop!

## Consentire Molteplici Guess con il Looping

La parola chiave `loop` crea un loop infinito. Aggiungeremo un loop per dare agli utenti
più possibilità di indovinare il numero:

<span class="filename">Filename: src/main.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/no-listing-04-looping/src/main.rs:here}}
```

Come puoi vedere, abbiamo spostato tutto dall'invito a inserire il guess in avanti all'interno
di un loop. Assicurati di indentare le righe all'interno del loop di altri quattro spazi ciascuna
e esegui di nuovo il programma. Il programma ora chiederà un altro guess per sempre,
il che in realtà introduce un nuovo problema. Sembra che l'utente non possa smettere!

L'utente potrebbe sempre interrompere il programma utilizzando la scorciatoia da tastiera
<kbd>ctrl</kbd>-<kbd>c</kbd>. Ma c'è un altro modo per sfuggire a questo mostro insaziabile,
come menzionato nella discussione sul `parse` in [“Confrontare il Guess con il
Numero Segreto”](#comparing-the-guess-to-the-secret-number)<!-- ignore -->: se
l'utente inserisce una risposta non numerica, il programma si bloccherà. Possiamo sfruttare
ciò per permettere all'utente di uscire, come mostrato qui:

<!-- manual-regeneration
cd listings/ch02-guessing-game-tutorial/no-listing-04-looping/
cargo run
(too small guess)
(too big guess)
(correct guess)
quit
-->

```console
$ cargo run
   Compiling guessing_game v0.1.0 (file:///projects/guessing_game)
    Finished dev [unoptimized + debuginfo] target(s) in 1.50s
     Running `target/debug/guessing_game`
Guess the number!
The secret number is: 59
Please input your guess.
45
You guessed: 45
Too small!
Please input your guess.
60
You guessed: 60
Too big!
Please input your guess.
59
You guessed: 59
You win!
Please input your guess.
quit
thread 'main' panicked at 'Please type a number!: ParseIntError { kind: InvalidDigit }', src/main.rs:28:47
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace
```

Digitare `quit` uscirà dal gioco, ma come noterai, così farà anche l'inserimento di qualsiasi
altro input non numerico. Questo è subottimale, per non dire altro; vogliamo che il gioco
si fermi anche quando il numero corretto è indovinato.

### Uscire Dopo un Indovinare Corretto

Programmiamo il gioco per uscire quando l'utente vince aggiungendo un'istruzione `break`:

<span class="filename">Filename: src/main.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/no-listing-05-quitting/src/main.rs:here}}
```

Aggiungere la riga `break` dopo `You win!` fa uscire il programma dal loop quando
l'utente indovina correttamente il numero segreto. Uscire dal loop significa anche
uscire dal programma, poiché il loop è l'ultima parte di `main`.

### Gestire l'Input Non Valido

Per perfezionare ulteriormente il comportamento del gioco, invece di far crollare il programma quando
l'utente inserisce un input non numerico, facciamo in modo che il gioco ignori l'input non numerico in modo
che l'utente possa continuare a indovinare. Possiamo farlo modificando la riga in cui `guess`
viene convertito da una `String` a un `u32`, come mostrato nel Listing 2-5.

<Listing number="2-5" file-name="src/main.rs" caption="Ignorare un guess non numerico e chiedere un altro guess invece di far crollare il programma">

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-05/src/main.rs:here}}
```

</Listing>

Passiamo da una chiamata `expect` a un'espressione `match` per passare dall'usare un crash
per un errore a gestire l'errore. Ricorda che `parse` restituisce un tipo `Result` e `Result`
è un enum che ha le varianti `Ok` e `Err`. Qui usiamo un'espressione `match`, come abbiamo fatto con il risultato `Ordering` del metodo `cmp`.

Se `parse` è in grado di trasformare con successo la stringa in un numero, restituirà
un valore `Ok` che contiene il numero risultante. Quel valore `Ok` corrisponderà al pattern
del primo braccio, e l'espressione `match` restituirà semplicemente il valore `num` che `parse`
ha prodotto e messo all'interno del valore `Ok`. Quel numero finirà esattamente dove lo
vogliamo nella nuova variabile `guess` che stiamo creando.

Se `parse` *non* è in grado di trasformare la stringa in un numero, restituirà un
valore `Err` che contiene ulteriori informazioni sull'errore. Il valore `Err`
non corrisponde al pattern `Ok(num)` nel primo braccio del `match`, ma corrisponde
al pattern `Err(_)` nel secondo braccio. Il trattino basso, `_`, è un
valore jolly; in questo esempio, stiamo dicendo che vogliamo abbinare tutti i valori `Err`,
indipendentemente dalle informazioni che hanno dentro. Quindi il programma eseguirà il codice
del secondo braccio, `continue`, che dice al programma di andare alla
prossima iterazione del `loop` e chiedere un altro guess. Quindi, effettivamente, il
programma ignora tutti gli errori che `parse` potrebbe incontrare!

Ora tutto nel programma dovrebbe funzionare come previsto. Proviamolo:

<!-- manual-regeneration
cd listings/ch02-guessing-game-tutorial/listing-02-05/
cargo run
(too small guess)
(too big guess)
foo
(correct guess)
-->

```console
$ cargo run
   Compiling guessing_game v0.1.0 (file:///projects/guessing_game)
    Finished dev [unoptimized + debuginfo] target(s) in 4.45s
     Running `target/debug/guessing_game`
Guess the number!
The secret number is: 61
Please input your guess.
10
You guessed: 10
Too small!
Please input your guess.
99
You guessed: 99
Too big!
Please input your guess.
foo
Please input your guess.
61
You guessed: 61
You win!
```

Fantastico! Con un piccolo ritocco finale, completeremo il gioco di indovina. Richiama
che il programma sta ancora stampando il numero segreto. Funzionava bene per
i test, ma rovina il gioco. Cancelliamo il `println!` che produce il
numero segreto. Il Listing 2-6 mostra il codice finale.

<Listing number="2-6" file-name="src/main.rs" caption="Codice completo del gioco di indovina">

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-06/src/main.rs}}
```

</Listing>

A questo punto, hai costruito con successo il gioco di indovina. Congratulazioni!

## Sommario

Questo progetto è stato un modo pratico per introdurti a molti nuovi concetti
di Rust: `let`, `match`, funzioni, l'uso di crate esterni, e altro. Nei próximos
due capitoli, imparerai questi concetti in modo più dettagliato. Il Capitolo 3
copre concetti che la maggior parte dei linguaggi di programmazione hanno, come variabili, tipi
di dati e funzioni, e mostra come usarli in Rust. Il Capitolo 4 esplora
la proprietà, una caratteristica che rende Rust diverso dagli altri linguaggi. Il Capitolo 5
discute gli struct e la sintassi dei metodi, e il Capitolo 6 spiega come funzionano
gli enum.

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
[docscratesio]: https://doc.rust-lang.org/cargo/reference/publishing.html
[match]: ch06-02-match.html
[shadowing]: ch03-01-variables-and-mutability.html#shadowing
[parse]: ../std/primitive.str.html#method.parse
[integers]: ch03-02-data-types.html#integer-types
