# Programmazione di un gioco di indovinelli

Salta dentro Rust lavorando su un progetto hands-on insieme! Questo capitolo ti introduce a alcuni comuni concetti di Rust, mostrandoti come usarli in un vero programma. Imparerai cos'è `let`, `match`, metodi, funzioni associate, crate esterni e altro ancora! Nei capitoli successivi, esploreremo queste idee in modo più dettagliato. In questo capitolo, eserciterai solo i fondamentali.

Realizzeremo un classico problema di programmazione per principianti: un gioco di indovinelli. Ecco come funziona: il programma genererà un intero casuale tra 1 e 100. Chiederà quindi al giocatore di inserire un supposizione. Dopo che una supposizione è stata inserita, il programma indicherà se la supposizione è troppo bassa o troppo alta. Se la supposizione è corretta, il gioco stamperà un messaggio di congratulazioni e uscirà.

## Configurazione di un nuovo progetto

Per configurare un nuovo progetto, vai nella directory *projets* che hai creato nel capitolo 1 e crea un nuovo progetto usando Cargo, in questo modo:

```console
$ cargo new guessing_game
$ cd guessing_game
```

Il primo comando, `cargo new`, prende il nome del progetto (`guessing_game`) come primo argomento. Il secondo comando cambia alla directory del nuovo progetto.

Guarda il file *Cargo.toml* generato:

<span class="filename">Nome file: Cargo.toml</span>

```toml
{{#include ../listings/ch02-guessing-game-tutorial/no-listing-01-cargo-new/Cargo.toml}}
```

Come hai visto nel capitolo 1, `cargo new` genera un programma "Hello, world!" per te. Dai un'occhiata al file *src/main.rs*:

<span class="filename">Nome file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/no-listing-01-cargo-new/src/main.rs}}
```

Ora compiliamo questo programma "Hello, world!" e eseguiamolo nello stesso passaggio usando il comando `cargo run`:

```console
{{#include ../listings/ch02-guessing-game-tutorial/no-listing-01-cargo-new/output.txt}}
```

Il comando `run` è utile quando devi iterare rapidamente su un progetto, come faremo in questo gioco, testando rapidamente ogni iterazione prima di passare alla successiva.

Riapri il file *src/main.rs*. Scriverai tutto il codice in questo file.

## Elaborazione di una supposizione

La prima parte del programma del gioco di indovinelli richiederà l'input dell'utente, elaborerà quell'input e controllerà che l'input sia nella forma prevista. Per iniziare, permetteremo al giocatore di inserire una supposizione. Inserisci il codice in Listato 2-1 in *src/main.rs*.

<span class="filename">Nome file: src/main.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-01/src/main.rs:all}}
```

<span class="caption"> Listato 2-1: Codice che ottiene una supposizione dall'utente e la stampa </span>

Questo codice contiene molte informazioni, quindi passiamolo riga per riga. Per ottenere input dall'utente e quindi stampare il risultato come output, dobbiamo portare la libreria di input/output `io` nel campo di azione. La libreria `io` proviene dalla libreria standard, nota come `std`:

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-01/src/main.rs:io}}
```

Di default, Rust ha un insieme di elementi definiti nella libreria standard che porta nel campo di azione di ogni programma. Questo set è chiamato *preludio*, e puoi vedere tutto in esso [nella documentazione della libreria standard][prelude].

Se un tipo che vuoi usare non è nel preludio, devi portare esplicitamente quel tipo nel campo di azione con una dichiarazione `use`. Utilizzare la libreria `std::io` ti fornisce una serie di funzioni utili, tra cui la possibilità di accettare input dall'utente.

Come hai visto nel capitolo 1, la funzione `main` è il punto di ingresso nel programma:

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-01/src/main.rs:main}}
```

La sintassi `fn` dichiara una nuova funzione; le parentesi, `()`, indicano che non ci sono parametri; e l'accolade, `{`, avvia il corpo della funzione.

Come hai anche imparato nel capitolo 1, println! è una macro che stampa una stringa sullo schermo:

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-01/src/main.rs:print}}
```

Questo codice sta stampando un prompt che indica di cosa tratta il gioco e richiede input dall'utente.

### Memorizzazione di valori con variabili

Successivamente, creeremo una *variabile* per memorizzare l'input dell'utente, in questo modo:

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-01/src/main.rs:string}}
```

Ora il programma sta diventando interessante! C'è molto da fare in questa piccola linea. Usiamo l'istruzione `let` per creare la variabile. Ecco un altro esempio:

```rust,ignore
let apples = 5;
```

Questa linea crea una nuova variabile chiamata `apples` e la lega al valore 5. In Rust, le variabili sono immutabili di default, il che significa che una volta che diamo un valore alla variabile, il valore non cambierà. Discuteremo questo concetto in dettaglio nella sezione ["Variabili e mutabilità"][variables-and-mutability]<!-- ignore --> nel capitolo 3. Per rendere una variabile mutabile, aggiungi `mut` prima del nome della variabile:

```rust,ignore
let apples = 5; // immutabile
let mut bananas = 5; // mutabile
```

> Nota: La sintassi `//` inizia un commento che prosegue fino alla fine della riga. Rust ignora tutto nei commenti. Discuteremo i commenti più in dettaglio nel [capitolo 3][comments]<!-- ignore -->.

Tornando al programma del gioco di indovinelli, ora sai che `let mut guess` introdurrà una variabile mutabile chiamata `guess`. Il segno di uguale (`=`) dice a Rust che vogliamo legare qualcosa alla variabile ora. A destra del segno di uguale c'è il valore a cui `guess` è legato, che è il risultato della chiamata a `String::new`, una funzione che restituisce una nuova istanza di una `String`. [`String`][string]<!-- ignore --> è un tipo di stringa fornito dalla libreria standard che è un testo in codifica UTF-8 espandibile.

La sintassi `::` nella riga `::new` indica che `new` è una funzione associata del tipo `String`. Una *funzione associata* è una funzione implementata su un tipo, in questo caso `String`. Questa funzione `new` crea una nuova stringa vuota. Troverai una funzione `new` su molti tipi perché è un nome comune per una funzione che crea un nuovo valore di un certo tipo.

In totale, la riga `let mut guess = String::new();` ha creato una variabile mutabile che al momento è legata a una nuova, vuota istanza di una `String`. Uff!

### Ricezione dell'input dell'utente

Ricorda che abbiamo incluso la funzionalità di input/output dalla libreria standard con `use std::io;` alla prima riga del programma. Ora chiameremo la funzione `stdin` dal modulo `io`, che ci permetterà di gestire l'input dell'utente:

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-01/src/main.rs:read}}
```

Se non avessimo importato la libreria `io` con `use std::io;` all'inizio del programma, avremmo potuto ancora usare la funzione scrivendo questa chiamata di funzione come `std::io::stdin`. La funzione `stdin` restituisce un'istanza di [`std::io::Stdin`][iostdin]<!-- ignore -->, che è un tipo che rappresenta un gestore per l'input standard del tuo terminale.
Successivamente, la riga `.read_line(&mut guess)` chiama il metodo [`read_line`][read_line]<!--
ignore --> sull'handle dell'input standard per ottenere input dall'utente.
Stiamo anche passando `&mut guess` come argomento a `read_line` per dire a cosa
stringa memorizzare l'input dell'utente. Il compito completo di `read_line` è prendere
qualsiasi cosa l'utente digita nell'input standard e appendere quella in una stringa
(senza sovrascrivere i suoi contenuti), quindi passiamo quella stringa come argomento. La stringa argomento deve essere mutabile affinché il metodo possa modificare il
contenuto della stringa.

L'`&` indica che questo argomento è un *riferimento*, che ti dà un modo per
lasciare che più parti del tuo codice accedano a un pezzo di dati senza necessità di
copia quel dato nella memoria più volte. I riferimenti sono una caratteristica complessa
e uno dei principali vantaggi di Rust è quanto sia sicuro e facile usare
riferimenti. Non è necessario conoscere molti di questi dettagli per completare questo
programma. Per ora, tutto quello che devi sapere è che, come le variabili, i riferimenti sono
immutabili di default. Pertanto, devi scrivere `&mut guess` piuttosto che
`&guess` per renderlo mutabile. (Il Capitolo 4 spiegherà più precisamente i riferimenti.)

<!-- Vecchia intestazione. Non rimuovere o i collegamenti potrebbero rompersi. -->
<a id="handling-potential-failure-with-the-result-type"></a>

### Gestire Fallimenti Potenziali con `Result`

Stiamo ancora lavorando su questa riga di codice. Ora stiamo discutendo una terza riga di
testo, ma notiamo che è ancora parte di una singola riga logica di codice. La prossima
parte è questo metodo:

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-01/src/main.rs:expect}}
```

Avremmo potuto scrivere questo codice come:

```rust,ignore
io::stdin().read_line(&mut guess).expect("Impossibile leggere la riga");
```

Tuttavia, una lunga linea è difficile da leggere, quindi è meglio dividerla. È
spesso saggio introdurre una nuova riga e altri spazi bianchi per aiutare a spezzare lunghe
righe quando chiami un metodo con la sintassi `.nome_del_metodo()`. Ora discutiamo ciò che fa questa riga.

Come detto in precedenza, `read_line` mette qualsiasi cosa l'utente inserisce nella stringa
che gli passiamo, ma ritorna anche un valore `Result`. [`Result`][result]<!--
ignore --> è un'[*enumerazione*][enums]<!-- ignore -->, spesso chiamata *enum*,
che è un tipo che può essere in uno dei molti possibili stati. Chiamiamo ogni stato possibile *variante*.

[Capitolo 6][enums]<!-- ignore --> coprirà gli enum più in dettaglio. Lo scopo
di questi tipi `Result` è codificare informazioni sulla gestione degli errori.

Le varianti di `Result` sono `Ok` e `Err`. La variante `Ok` indica che l'operazione è andata a buon fine e dentro `Ok` c'è il valore generato con successo.
La variante `Err` significa che l'operazione è fallita e `Err` contiene informazioni 
su come o perché l'operazione è fallita.

I valori del tipo `Result`, come i valori di qualsiasi tipo, hanno metodi definiti su di loro. Un'istanza di `Result` ha un metodo [`expect`][expect]<!-- ignore -->
che è possibile chiamare. Se questa istanza di `Result` è un valore `Err`, `expect` farà crashare il programma e visualizzerà il messaggio che avete passato come argomento a `expect`. Se il metodo `read_line` restituisce un `Err`, sarebbe probabilmente il risultato di un errore proveniente dal sistema operativo sottostante.
Se questa istanza di `Result` è un valore `Ok`, `expect` prenderà il valore di ritorno che `Ok` sta tenendo e restituirà solo quel valore in modo che tu possa utilizzarlo.
In questo caso, quel valore è il numero di byte nell'input dell'utente.

Se non chiamate `expect`, il programma si compilerà, ma otterrete un avvertimento:

```console
{{#include ../listings/ch02-guessing-game-tutorial/no-listing-02-without-expect/output.txt}}
```

Rust avverte che non hai usato il valore `Result` restituito da `read_line`,
indicando che il programma non ha gestito un possibile errore.

Il modo corretto per sopprimere l'avvertimento è effettivamente scrivere del codice di gestione degli errori,
ma nel nostro caso vogliamo semplicemente che il programma si arresti in caso di problema, quindi possiamo
utilizzare `expect`. Imparerai a recuperare da errori nel [Capitolo 9][recupero]<!-- ignore -->.

### Stampa dei valori con segnaposti `println!`

A parte la parentesi graffa di chiusura, c'è solo un'altra riga da discutere nel codice finora:

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-01/src/main.rs:print_guess}}
```

Questa riga stampa la stringa che ora contiene l'input dell'utente. Il set `{}` di
parentesi graffe è un segnaposto: pensa a `{}` come piccole chele di granchio che tengono
un valore al suo posto. Durante la stampa del valore di una variabile, il nome della variabile può
andare all'interno delle parentesi graffe. Quando si stampa il risultato della valutazione di un'espressione, mettete le parentesi graffe vuote nella stringa di formato, quindi seguite la
stringa di formato con un elenco separato da virgole di espressioni da stampare in ogni segnaposto di parentesi graffa vuota nello stesso ordine. Stampare una variabile e il risultato
di un'espressione in una sola chiamata a `println!` avrebbe un aspetto simile a questo:

```rust
let x = 5;
let y = 10;

println!("x = {x} e y + 2 = {}", y + 2);
```

Questo codice stamperebbe `x = 5 e y + 2 = 12`.

### Testare la prima parte

Proviamo la prima parte del gioco indovina. Eseguiamolo usando `cargo run`:

<!-- rigenerazione-manuale
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
Per favore inserisci il tuo tentativo.
6
Hai indovinato: 6
```

A questo punto, la prima parte del gioco è terminata: stiamo ottenendo input da 
tastiera e poi lo stampiamo.

## Generare un numero segreto

Successivamente, abbiamo bisogno di generare un numero segreto che l'utente tenterà di indovinare. Il numero segreto dovrebbe essere diverso ogni volta in modo che il gioco sia divertente da giocare più di una volta. Useremo un numero casuale tra 1 e 100 in modo che il gioco non sia troppo difficile. Rust non include ancora la funzionalità di numeri casuali nella sua libreria standard. Tuttavia, il team di Rust fornisce una crate [`rand`][randcrate] con la detta funzionalità.

### Utilizzare una crate per ottenere più funzionalità

Ricorda che una crate è una raccolta di file di codice sorgente Rust. Il progetto che abbiamo sviluppato è una *crate binaria*, che è un eseguibile. La crate `rand` è una *crate di libreria*, che contiene codice che è destinato ad essere utilizzato in altri programmi e non può essere eseguito da solo.

Il coordinamento di Cargo delle crate esterne è dove Cargo risplende veramente. Prima che possiamo scrivere codice che usa `rand`, dobbiamo modificare il file *Cargo.toml* per includere la crate `rand` come una dipendenza. Apri quel file adesso e aggiungi la seguente riga alla fine, sotto l'intestazione della sezione `[dependencies]` che Cargo ha creato per te. Assicurati di specificare `rand` esattamente come abbiamo qui, con questo numero di versione, altrimenti gli esempi di codice in questo tutorial potrebbero non funzionare:

<!-- Quando aggiorni la versione di `rand` utilizzata, aggiorna anche la versione di
`rand` utilizzata in questi file in modo che tutti corrispondano:
* ch07-04-bringing-paths-into-scope-with-the-use-keyword.md
* ch14-03-cargo-workspaces.md
-->

<span class="filename">Nome del file: Cargo.toml</span>

```toml
{{#include ../listings/ch02-guessing-game-tutorial/listing-02-02/Cargo.toml:8:}}
```

Nel file *Cargo.toml*, tutto ciò che segue un'intestazione fa parte di quella
sezione che continua fino a quando non inizia un'altra sezione. In `[dependencies]` dici a Cargo quali crate esterne il tuo progetto dipende e quali versioni di queste crate richiedi. In questo caso, specifichiamo la crate `rand` con lo specificatore di versione semantica `0.8.5`. Cargo comprende [Semantic Versioning][semver]<!-- ignore --> (a volte chiamato *SemVer*), che è uno standard per la scrittura dei numeri di versione. Lo specificatore `0.8.5` è in realtà una scorciatoia per `^0.8.5`, che significa qualsiasi versione che sia almeno 0.8.5 ma inferiore a 0.9.0.
Cargo considera che queste versioni abbiano API pubbliche compatibili con la versione
0.8.5, e questa specifica garantisce che otterrai l'ultimo rilascio di patch che
si compilerà ancora con il codice in questo capitolo. Qualsiasi versione 0.9.0 o superiore
non è garantito che abbia la stessa API di quella utilizzata negli esempi seguenti.

Ora, senza modificare alcun codice, costruiamo il progetto, come mostrato in
Listing 2-2.

<!-- manual-regeneration
cd listings/ch02-guessing-game-tutorial/listing-02-02/
rm Cargo.lock
cargo clean
cargo build -->

```console
$ cargo build
    Aggiornamento indice crates.io
  Scaricato rand v0.8.5
  Scaricato libc v0.2.127
  Scaricato getrandom v0.2.7
  Scaricato cfg-if v1.0.0
  Scaricato ppv-lite86 v0.2.16
  Scaricato rand_chacha v0.3.1
  Scaricato rand_core v0.6.3
   Compiling libc v0.2.127
   Compiling getrandom v0.2.7
   Compiling cfg-if v1.0.0
   Compiling ppv-lite86 v0.2.16
   Compiling rand_core v0.6.3
   Compiling rand_chacha v0.3.1
   Compiling rand v0.8.5
   Compiling guessing_game v0.1.0 (file:///projects/guessing_game)
    Finito dev [un ottimizzato + debuginfo] target(s) in 2.53s
```

<span class="caption">Listing 2-2: L'output da `cargo build` dopo
avendo aggiunto la crate rand come dipendenza</span>

Potresti vedere numeri di versione differenti (ma saranno tutti compatibili con il
codice, grazie a SemVer!) e linee diverse (a seconda del sistema operativo), e le linee potrebbero essere in un ordine diverso.

Quando includiamo una dipendenza esterna, Cargo recupera le ultime versioni di
tutto ciò di cui quella dipendenza ha bisogno dal *registry*, che è una copia dei dati
da [Crates.io][cratesio]. Crates.io è dove le persone nell'ecosistema Rust
pubblicano i loro progetti Rust open source per altri da usare.

Dopo l'aggiornamento del registry, Cargo controlla la sezione `[dependencies]` e
scarica qualsiasi crate elencata che non è già scaricata. In questo caso,
sebbene abbiamo elencato solo `rand` come dipendenza, Cargo ha anche preso altre crates
che `rand` dipende per funzionare. Dopo aver scaricato le crates, Rust le compila
e quindi compila il progetto con le dipendenze disponibili.

Se esegui immediatamente di nuovo `cargo build` senza fare alcuna modifica, non
otterrai alcun output oltre alla riga `Finished`. Cargo sa che ha già
scaricato e compilato le dipendenze, e non hai modificato nulla
riguardo a loro nel tuo file *Cargo.toml*. Cargo sa anche che non hai cambiato
nulla riguardo al tuo codice, quindi non lo ricompila neanche. Non avendo nulla da
fare, si limita ad uscire.

Se apri il file *src/main.rs*, fai una piccola modifica, e poi lo salvi e
compili di nuovo, vedrai solo due righe di output:

<!-- manual-regeneration
cd listings/ch02-guessing-game-tutorial/listing-02-02/
touch src/main.rs
cargo build -->

```console
$ cargo build
   Compiling guessing_game v0.1.0 (file:///projects/guessing_game)
    Finito dev [unoptimized + debuginfo] target(s) in 2.53 sec
```

Queste righe mostrano che Cargo aggiorna solo la build con la tua piccola modifica al
file *src/main.rs*. Le tue dipendenze non sono cambiate, quindi Cargo sa che può
riutilizzare ciò che ha già scaricato e compilato per quelle.

#### Garantire Builds Riproducibili con il file *Cargo.lock*

Cargo ha un meccanismo che garantisce che tu possa ricostruire lo stesso artifact ogni volta
tu o chiunque altro costruisce il tuo codice: Cargo utilizzerà solo le versioni delle
dipendenze che hai specificato fino a quando non indichi altro. Ad esempio, diciamo che
la prossima settimana esce la versione 0.8.6 della crate `rand`, e quella versione
contiene una correzione di bug importante, ma contiene anche una regressione che romperà
il tuo codice. Per gestire questo, Rust crea il file *Cargo.lock* la prima volta che esegui `cargo build`, quindi ora abbiamo questo nella directory *guessing_game*.

Quando costruisci un progetto per la prima volta, Cargo capisce tutte le versioni
delle dipendenze che soddisfano i criteri e poi le scrive nel
file *Cargo.lock*. Quando costruirai il tuo progetto in futuro, Cargo vedrà
che il file *Cargo.lock* esiste e userà le versioni specificate lì
piuttosto che rifare tutto il lavoro di determinare le versioni di nuovo. Questo ti permette
di avere una build riproducibile automaticamente. In altre parole, il tuo progetto rimarrà
alla 0.8.5 finché non aggiorni esplicitamente, grazie al file *Cargo.lock*. 
Poiché il file *Cargo.lock* è importante per le builds riproducibili, spesso è
controllato nel controllo delle versioni con il resto del codice nel tuo progetto.

#### Aggiornamento di una Crate per Ottenere una Nuova Versione

Quando *vuoi* aggiornare una crate, Cargo fornisce il comando `update`,
che ignorerà il file *Cargo.lock* e determinerà tutte le ultime versioni
che si adattano alle tue specifiche in *Cargo.toml*. Quindi Cargo scriverà quelle
versioni nel file *Cargo.lock*. Altrimenti, di default, Cargo cercherà solo
versioni superiori a 0.8.5 e inferiori a 0.9.0. Se la crate `rand` ha
rilasciato le due nuove versioni 0.8.6 e 0.9.0, vedresti il seguente se
hai eseguito `cargo update`:

<!-- manual-regeneration
cd listings/ch02-guessing-game-tutorial/listing-02-02/
cargo update
assumendo che ci sia una nuova versione 0.8.x di rand; altrimenti usa un altro aggiornamento
come guida per creare l'output ipotetico mostrato qui -->

```console
$ cargo update
    Aggiornamento indice crates.io
    Aggiornamento rand v0.8.5 -> v0.8.6
```

Cargo ignora il rilascio 0.9.0. A questo punto, noteresti anche un cambiamento
nel tuo file *Cargo.lock* che nota che la versione della crate `rand` che stai
usando ora è 0.8.6. Per usare `rand` versione 0.9.0 o qualsiasi versione nella serie 0.9.*x*,
dovresti aggiornare il file *Cargo.toml* per farlo sembrare così:

```toml
[dependencies]
rand = "0.9.0"
```

La prossima volta che esegui `cargo build`, Cargo aggiornerà il registro delle crates
disponibili e rivaluterà le tue richieste `rand` in base alla nuova versione
che hai specificato.

C'è molto altro da dire su [Cargo][doccargo]<!-- ignore --> e [il suo
ecosistema][doccratesio]<!-- ignore -->, che discuteremo nel Capitolo 14, ma
per ora, è tutto quello che devi sapere. Cargo rende molto facile riutilizzare
librerie, quindi i Rustaceans sono in grado di scrivere progetti più piccoli che sono assemblati
da un numero di pacchetti.

### Generare un Numero Casuale

Cominciamo a usare `rand` per generare un numero da indovinare. Il passo successivo è di
aggiornare *src/main.rs*, mostrato in Listing 2-3.

<span class="filename">Nome file: src/main.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-03/src/main.rs:all}}
```

<span class="caption">Listing 2-3: Aggiungere codice per generare un numero
casuale</span>

Per prima cosa aggiungiamo la linea `use rand::Rng;`. Il trait `Rng` definisce metodi che
i generatori di numeri casuali implementano, e questo trait deve essere in scope per noi
usare quei metodi. Il Capitolo 10 coprirà i trait in dettaglio.

Successivamente, aggiungiamo due righe nel mezzo. Nella prima riga, chiamiamo
la funzione `rand::thread_rng` che ci dà il particolare generatore di numeri casuali
che andremo a usare: uno che è locale al thread corrente di
esecuzione e che è seminato dal sistema operativo. Poi chiamiamo il metodo `gen_range`
sul generatore di numeri casuali. Questo metodo è definito dal trait `Rng`
che abbiamo portato in scope con la dichiarazione `use rand::Rng;`. Il
metodo `gen_range` prende come argomento un'espressione di range e genera un
numero casuale in quel range. Il tipo di espressione di range che stiamo usando qui prende
la forma `start..=end` ed è inclusivo sui confini inferiori e superiori, quindi dobbiamo
specificare `1..=100` per richiedere un numero tra 1 e 100.

> Nota: Non saprai subito quali traits utilizzare e quali metodi e funzioni
> chiamare da una crate, quindi ogni crate ha una documentazione con istruzioni su come
> utilizzarlo. Un'altra caratteristica interessante di Cargo è che eseguendo il comando `cargo doc
> --open` verrà generata la documentazione fornita da tutte le tue dipendenze
> localmente e la aprirà nel tuo browser. Se sei interessato ad altre
> funzionalità nella crate `rand`, per esempio, esegui `cargo doc --open` e
> clicca su `rand` nella sidebar a sinistra.

La seconda nuova riga stampa il numero segreto. Questo è utile mentre stiamo
sviluppando il programma per poterlo testare, ma lo elimineremo dalla
versione finale. Non è un gran gioco se il programma stampa la risposta non appena
parte!

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
Indovina il numero!
Il numero segreto è: 7
Inserisci il tuo palpite.
4
Hai indovinato: 4

$ cargo run
    Finished dev [unoptimized + debuginfo] target(s) in 0.02s
     Running `target/debug/guessing_game`
Indovina il numero!
Il numero segreto è: 83
Inserisci il tuo palpite.
5
Hai indovinato: 5
```

Dovresti ottenere differenti numeri casuali, e tutti dovrebbero essere numeri tra
1 e 100. Ben fatto!

## Confrontare il Palpite con il Numero Segreto

Ora che abbiamo l'input dell'utente e un numero casuale, possiamo confrontarli. Questo passaggio
è mostrato in Elencazione 2-4. Nota che questo codice non compilerà ancora, come spiegheremo.

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-04/src/main.rs:here}}
```

<span class="caption">Elencazione 2-4: Gestione dei possibili valori restituiti dal
confronto tra due numeri</span>

Aggiungiamo prima una nuova istruzione `use`, che introduce il tipo chiamato
`std::cmp::Ordering` dal library standard. Il tipo `Ordering` è un altro enum e ha le varianti `Less`, `Greater`, e `Equal`. Sono i tre risultati possibili quando confronti due valori.

Poi aggiungiamo cinque nuove linee alla fine che usano il tipo `Ordering`. Il
metodo `cmp` confronta due valori e può essere chiamato su qualsiasi cosa che può essere
confrontata. Esso prende un riferimento a qualunque cosa tu voglia confrontare: qui sta confrontando `guess` con `secret_number`. Poi restituisce una variante dell'
enum `Ordering` che abbiamo introdotto con l'istruzione `use`. Utilizziamo un'espressione
[`match`][match]<!-- ignore --> per decidere cosa fare dopo in base a
quale variante di `Ordering` è stata restituita dalla chiamata a `cmp` con i valori
in `guess` e `secret_number`.

Un'espressione `match` è composta da *bracci*. Un braccio consiste in un *modello* contro cui
confrontare, e il codice che dovrebbe essere eseguito se il valore dato a `match`
soddisfa il modello di tale braccio. Rust prende il valore dato a `match` e guarda
attraverso il modello di ogni braccio a sua volta. I modelli e la costruzione `match` sono
potenti caratteristiche di Rust: permettono di esprimere una varietà di situazioni che il tuo codice
potrebbe incontrare e si assicurano che tu le gestisca tutte. Queste caratteristiche saranno
coperte in dettaglio nel Capitolo 6 e nel Capitolo 18, rispettivamente.

Facciamo un esempio con l'espressione `match` che utilizziamo qui. Diciamo che
l'utente ha indovinato 50 e il numero segreto generato casualmente questa volta è
38.

Quando il codice confronta 50 a 38, il metodo `cmp` restituirà
`Ordering::Greater` perché 50 è maggiore di 38. L'espressione `match` ottiene
il valore `Ordering::Greater` e inizia a controllare il modello di ogni braccio. Guarda
il modello del primo braccio, `Ordering::Less`, e vede che il valore
`Ordering::Greater` non corrisponde a `Ordering::Less`, quindi ignora il codice in
quel braccio e passa al braccio successivo. Il modello del braccio successivo è
`Ordering::Greater`, che *corrisponde* a `Ordering::Greater`! Il codice associato in quel braccio verrà eseguito e stampa `Troppo grande!` sullo schermo. L'espressione `match`
termina dopo il primo match di successo, quindi non guarderà l'ultimo
braccio in questo scenario.

Tuttavia, il codice in Elencazione 2-4 non compilerà ancora. Proviamo:

<!--
The error numbers in this output should be that of the code **WITHOUT** the
anchor or snip comments
-->

```console
{{#include ../listings/ch02-guessing-game-tutorial/listing-02-04/output.txt}}
```

Il nocciolo dell'errore afferma che ci sono *tipi non corrispondenti*. Rust ha un
forte, sistema di tipi statico. Tuttavia, ha anche inferenza di tipo. Quando abbiamo scritto
`let mut guess = String::new()`, Rust è stato in grado di inferire che `guess` dovesse essere
una `String` e non ci ha fatto scrivere il tipo. `secret_number`, d'altra parte, è un tipo numerico. Alcuni dei tipi numerici di Rust possono avere un valore tra 1
e 100: `i32`, un numero a 32 bit; `u32`, un numero a 32 bit non firmato; `i64`, un
numero a 64 bit; così come gli altri. A meno che non sia specificato diversamente, Rust predefinisce un `i32`, che è il tipo di `secret_number` a meno che non aggiungi informazioni di tipo
altrove che farebbe con Rust per inferire un diverso tipo numerico. Il motivo
dell'errore è che Rust non può confrontare una stringa e un tipo numerico.

In definitiva, vogliamo convertire la `String` che il programma legge come input in un
vero tipo numerico in modo da poterlo confrontare numericamente con il numero segreto. Lo facciamo aggiungendo questa riga al corpo della funzione `main`:

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/no-listing-03-convert-string-to-number/src/main.rs:here}}
```

La riga è:

```rust,ignore
let guess: u32 = guess.trim().parse().expect("Per favore inserisci un numero!");
```

Creiamo una variabile chiamata `guess`. Ma aspetta, il programma ha già
una variabile chiamata `guess`? Sì, ma fortunatamente Rust ci permette di ombreggiare il
valore precedente di `guess` con uno nuovo. L'*ombreggiamento* ci permette di riutilizzare il nome della variabile `guess`
piuttosto che costringerci a creare due variabili uniche, come
`guess_str` e `guess`, per esempio. Questo sarà coperto in più dettaglio in
[Capitolo 3][shadowing]<!-- ignore -->, ma per ora, sappi che questa caratteristica è
spesso usata quando vuoi convertire un valore da un tipo a un altro tipo.

Colleghiamo questa nuova variabile all'espressione `guess.trim().parse()`. Il `guess`
nella espressione si riferisce alla variabile `guess` originale che conteneva
l'input come una stringa. Il metodo `trim` su un'istanza di `String` eliminerà qualsiasi
spazi bianchi all'inizio e alla fine, cosa che dobbiamo fare per poter confrontare la
stringa con `u32`, che può contenere solo dati numerici. L'utente deve premere
<span class="keystroke">enter</span> per soddisfare `read_line` e inserire il loro
palpite, che aggiunge un carattere di newline alla stringa. Per esempio, se l'utente
digita <span class="keystroke">5</span> e preme <span
class="keystroke">enter</span>, `guess` sembra questo: `5\n`. Il `\n`
rappresenta "newline." (Su Windows, premendo <span
class="keystroke">enter</span> risulta in un ritorno a capo e una newline,
`\r\n`.) Il metodo `trim` elimina `\n` o `\r\n`, risultando in solo `5`.


Il [metodo `parse` su stringhe][parse]<!-- ignore --> converte una stringa in
un altro tipo. Qui, lo usiamo per convertire da una stringa a un numero. Dobbiamo
dire a Rust quale numero di tipo vogliamo usando `let guess: u32`. I due punti
(`:`) dopo `guess` dicono a Rust che andremo a annotare il tipo della variabile. Rust ha alcuni
tipi di numeri incorporati; il `u32` visto qui è un intero non firmato a 32 bit.
È una buona scelta predefinita per un piccolo numero positivo. Imparerai di
altri tipi di numeri nel [Capitolo 3][integers]<!-- ignore -->.

Inoltre, l'annotazione `u32` in questo programma di esempio e il confronto
con `secret_number` significa che Rust inferirà che anche `secret_number` dovrebbe essere un
`u32`. Quindi ora il confronto sarà tra due valori dello stesso
tipo!

Il metodo `parse` funzionerà solo sui caratteri che possono logicamente essere convertiti
in numeri e quindi possono facilmente causare errori. Se, ad esempio, la stringa
contenuta `A👍%`, non ci sarebbe modo di convertirla in un numero. Poiché potrebbe
fallire, il metodo `parse` restituisce un tipo `Result`, molto come il metodo `read_line`
fa (discusso in precedenza in [“Gestire il potenziale fallimento con
`Result`”](#handling-potential-failure-with-result)<!-- ignore-->). Tratteremo
questo `Result` nello stesso modo usando di nuovo il metodo `expect`. Se `parse`
restituisce una variante `Err` `Result` perché non riesce a creare un numero dalla
stringa, la chiamata `expect` farà crashare il gioco e stampa il messaggio che gli diamo.
Se `parse` può convertire con successo la stringa in un numero, restituirà il
varianti `Ok` di `Result`, e `expect` restituirà il numero che vogliamo dal
valore `Ok`.

Facciamo funzionare ora il programma:

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
Per favore, inserisci il tuo numero.
  76
Hai indovinato: 76
Troppo grande!
```

Bene! Anche se sono stati aggiunti spazi prima dell'ipotesi, il programma ha ancora capito
che l'utente ha ipotizzato 76. Esegui il programma alcune volte per verificare il
comportamento diverso con diversi tipi di input: indovinare il numero correttamente,
indovina un numero troppo alto e indovina un numero troppo basso.

Abbiamo la maggior parte del gioco che funziona ora, ma l'utente può fare solo un indovinello.
Cambiamo questo aggiungendo un ciclo!

## Consentire più ipotesi con Ciclismo

La parola chiave `loop` crea un ciclo infinito. Aggiungeremo un loop per dare agli utenti
più possibilità di indovinare il numero:

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/no-listing-04-looping/src/main.rs:here}}
```

Come puoi vedere, abbiamo spostato tutto dal prompt di input del supposto in avanti in
un ciclo. Assicurati di indentare le linee all'interno del ciclo per altri quattro spazi ciascuno
e esegui di nuovo il programma. Il programma chiederà ora un'altra supposizione per sempre,
che introduce effettivamente un nuovo problema. Non sembra che l'utente possa uscire!

L'utente potrebbe sempre interrompere il programma usando la scorciatoia da tastiera
<span class="keystroke">ctrl-c</span>. Ma c'è un altro modo per sfuggire a questo
mostro insaziabile, come menzionato nella discussione `parse` in ["Confrontando l'
Indovina con il numero segreto"](comparing-the-guess-to-the-secret-number)<!--
ignore -->: se l'utente inserisce una risposta non numerica, il programma si bloccherà. Noi
possono sfruttare questo per permettere all'utente di uscire, come mostrato qui:

<!-- manual-regeneration
cd listings/ch02-guessing-game-tutorial/no-listing-04-looping/
cargo run
(palpito troppo piccolo)
(palpito troppo grande)
(indovinello corretto)
esci
-->

```console
$ cargo run
   Compiling guessing_game v0.1.0 (file:///projects/guessing_game)
    Finished dev [unoptimized + debuginfo] target(s) in 1.50s
     Running `target/debug/guessing_game`
Indovina il numero!
Il numero segreto è: 59
Per favore, inserisci il tuo numero.
45
Hai indovinato: 45
Troppo piccolo!
Per favore, inserisci il tuo numero.
60
Hai indovinato: 60
Troppo grande!
Per favore, inserisci il tuo numero.
59
Hai indovinato: 59
Hai vinto!
Per favore, inserisci il tuo numero.
esci
thread 'main' panicked at 'Per favore, digita un numero!: ParseIntError { kind: InvalidDigit }', src/main.rs:28:47
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace
```

Digitando `esci` si uscirà dal gioco, ma come noterai, così sarà anche inserire qualsiasi
altra input non numerico. Questo è subottimale, per dirlo in modo gentile; vogliamo che il gioco
si fermi anche quando viene indovinato il numero corretto.

### Uscire dopo un indovino corretto

Programmiamo il gioco per uscire quando l'utente vince aggiungendo un'istruzione `break`:

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/no-listing-05-quitting/src/main.rs:here}}
```

Aggiungendo la riga `break` dopo `Hai vinto!` fa sì che il programma esca dal ciclo quando
l'utente indovina il segreto
numero correttamente. Uscire dal ciclo significa anche
uscire dal programma, perché il ciclo è l'ultima parte di `main`.

### Gestione dell'input non valido

Per affinare ulteriormente il comportamento del gioco, piuttosto che bloccare il programma quando
l'utente inserisce un non-numero, facciamo in modo che il gioco ignori un non-numero in modo che
l'utente può continuare a indovinare. Possiamo farlo modifcando la riga dove `guess`
viene convertito da una `String` a un `u32`, come mostrato nella Listato 2-5.

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-05/src/main.rs:here}}
```

<span class="caption">Listato 2-5: Ignorando un'ipotesi non numerica e chiedendo di
un'altra ipotesi invece di bloccare il programma</span>

Passiamo da una chiamata `expect` a un'espressione `match` per passare dal crash
su un errore alla gestione dell'errore. Ricorda che `parse` restituisce un `Result`
tipo e `Result` è un enum che ha le varianti `Ok` ed `Err`. Stiamo usando
un'espressione `match` qui, come abbiamo fatto con il risultato `Ordering` del metodo `cmp`.

Se `parse` è in grado di trasformare correttamente la stringa in un numero, sarà
restituirà un valore `Ok` che contiene il numero risultante. Quel valore `Ok` sarà
corrisponde al modello del primo braccio e l'espressione `match` restituirà solo il
valore `num` che `parse` ha prodotto e inserito nel valore `Ok`. Quel numero
arriverà proprio dove lo vogliamo nella nuova variabile `guess` che stiamo creando.

Se `parse` *non* è in grado di trasformare la stringa in un numero, restituirà un
valore `Err` che contiene più informazioni sull'errore. Il valore `Err` non
corrisponde al modello `Ok(num)` nel primo braccio `match`, ma corrisponde
corrisponde al modello `Err(_)` nel secondo braccio. L'underscore, `_`, è un
valore catchall; in questo esempio, stiamo dicendo che vogliamo corrispondere a tutti i `Err`
valori, indipendentemente dalle informazioni che hanno dentro di loro. Quindi il programma sarà
eseguire il codice del secondo braccio, `continue`, che dice al programma di andare al
successivo ciclo di iterazione del `loop` e chiedere un'altra supposizione. Quindi, in effetti, il
il programma ignora tutti gli errori che `parse` potrebbe incontrare!

Ora tutto nel programma dovrebbe funzionare come previsto. Proviamolo:

<!-- manual-regeneration
cd listings/ch02-guessing-game-tutorial/listing-02-05/
cargo run
(palpito troppo piccolo)
(palpito troppo grande)
foo
(indovinello corretto)
-->
```console
$ cargo run
   Compiling guessing_game v0.1.0 (file:///projects/guessing_game)
    Finished dev [unoptimized + debuginfo] target(s) in 4.45s
     Running `target/debug/guessing_game`
Indovina il numero!
Il numero segreto è: 61
Per favore inserisci il tuo tentativo.
10
Hai detto: 10
Troppo piccolo!
Per favore inserisci il tuo tentativo.
99
Hai detto: 99
Troppo grande!
Per favore inserisci il tuo tentativo.
foo
Per favore inserisci il tuo tentativo.
61
Hai detto: 61
Hai vinto!
```

Fantastico! Con un ultimo piccolo ritocco, completeremo il gioco dell'indovinello. Ricorda
che il programma sta ancora stampando il numero segreto. Questo andava bene per
i test, ma rovina il gioco. Eliminiamo il `println!` che mostra il
numero segreto. L'elenco 2-6 mostra il codice finale.

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-06/src/main.rs}}
```

<span class="caption">Elenco 2-6: Codice completo del gioco dell'indovinello</span>

A questo punto, hai costruito con successo il gioco dell'indovinello. Congratulazioni!

## Riepilogo

Questo progetto è stato un modo pratico per introdurti a molti nuovi concetti di Rust:
`let`, `match`, funzioni, l'uso di crates esterne, e molto altro. Nei prossimi
capitoli, imparerai questi concetti in più dettagli. Il capitolo 3
tratta concetti che la maggior parte dei linguaggi di programmazione hanno, come variabili, tipi di dati, e funzioni, e mostra come usarli in Rust. Il capitolo 4 esplora
la proprietà, una caratteristica che rende Rust diverso da altri linguaggi. Il capitolo 5
discute di structs e della sintassi dei metodi, e il capitolo 6 spiega come funzionano gli enums.

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

