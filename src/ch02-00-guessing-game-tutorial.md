# Programmare un gioco dell'indovinello

Saltiamo subito nel mondo Rust lavorando su un progetto pratico insieme! Questo
capitolo ti introduce ad alcuni concetti comuni di Rust mostrando come usarli in un programma reale. Imparerai all'uso di `let`, `match`, metodi, funzioni associate, crate esterni e molto altro! Nei capitoli seguenti, esploreremo queste idee in maggior dettaglio. In questo capitolo, ti allenerai solo con i fondamentali.

Implementeremo un classico problema di programmazione per principianti: un gioco dell'indovinello. Ecco come funziona: il programma genererà un numero intero casuale tra 1 e 100, quindi richiederà al giocatore di inserire un indovinello. Dopo che un indovinello è stato inserito, il programma indicherà se l'indovinello è troppo basso o troppo alto. Se l'indovinello è corretto, il gioco stamperà un messaggio di congratulazioni e si interromperà.

## Configurare un Nuovo Progetto

Per configurare un nuovo progetto, vai nella directory *projects* che hai creato nel
Capitolo 1 e crea un nuovo progetto utilizzando Cargo, in questo modo:

```console
$ cargo new guessing_game
$ cd guessing_game
```

Il primo comando, `cargo new`, prende il nome del progetto (`guessing_game`) 
come primo argomento. Il secondo comando cambia nella directory del nuovo progetto.

Dai un'occhiata al file *Cargo.toml* generato:

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

Come hai visto nel Capitolo 1, `cargo new` genera un programma "Hello, world!" per te. Dai un'occhiata al file *src/main.rs*:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/no-listing-01-cargo-new/src/main.rs}}
```

Ora compiliamo questo programma "Hello, world!" e eseguiamolo nello stesso passaggio usando il comando `cargo run`:

```console
{{#include ../listings/ch02-guessing-game-tutorial/no-listing-01-cargo-new/output.txt}}
```

Il comando `run` è utile quando devi iterare rapidamente su un progetto,
come faremo in questo gioco, testando rapidamente ciascuna iterazione prima di passare a quella successiva.

Riapri il file *src/main.rs*. Scriverai tutto il codice in questo file.

## Elaborazione di un Indovinello

La prima parte del programma del gioco dell'indovinello richiederà l'input dell'utente, elaborerà
quell'input, e controllerà che l'input sia nella forma prevista. Per iniziare, permetteremo
al giocatore di inserire un indovinello. Inserisci il codice nel Listato 2-1 nel
*src/main.rs*.

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-01/src/main.rs:all}}
```

<span class="caption">Listato 2-1: Codice che ottiene un indovinello dall'utente e
lo stampa</span>

Questo codice contiene molte informazioni, quindi analizziamolo riga per riga. Per
ottenere l'input dell'utente e poi stampare il risultato come output, dobbiamo portare la
libreria di input/output `io` nel nostro ambito. La libreria `io` viene dalla libreria standard
conosciuta come `std`:

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-01/src/main.rs:io}}
```

Per impostazione predefinita, Rust ha un insieme di elementi definiti nella libreria standard che include in ogni programma. Questo insieme è chiamato *prelude*, e
puoi vedere tutto ciò che contiene [nella documentazione della libreria standard][prelude].

Se un tipo che vuoi usare non è nel prelude, devi portare quel tipo
esplicitamente nel tuo ambito con un'istruzione `use`. L'uso della libreria `std::io`
ti fornisce una serie di funzioni utili, tra cui la capacità di accettare
input dell'utente.

Come hai visto nel Capitolo 1, la funzione `main` è il punto di ingresso nel
programma:

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-01/src/main.rs:main}}
```

La sintassi `fn` dichiara una nuova funzione; le parentesi, `()`, indicano che
non ci sono parametri; e la parentesi graffa, `{`, inizia il corpo della funzione.

Come hai anche imparato nel Capitolo 1, `println!` è una macro che stampa una stringa sullo
schermo:

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-01/src/main.rs:print}}
```

Questo codice sta stampando un invito a partecipare al gioco e sta richiedendo un input
dall'utente.

### Memorizzazione dei Valori con Variabili

Dopo, creeremo una *variabile* per memorizzare l'input dell'utente, in questo modo:

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-01/src/main.rs:string}}
```

Ora il programma sta diventando interessante! C'è molta informazione in questa piccola
riga. Usiamo l'istruzione `let` per creare la variabile. Eccoti un altro esempio:

```rust,ignore
let mele = 5;
```

Questa riga crea una nuova variabile chiamata `mele` e la lega al valore 5. In
Rust, le variabili sono immutabili per impostazione predefinita, il che significa che una volta che diamo un valore alla variabile, il valore non cambia. Discuteremo di questo concetto in dettaglio nella sezione ["Variabili e Mutabilità"][variables-and-mutability]<!-- ignore -->
nel Capitolo 3. Per rendere una variabile mutabile, aggiungiamo `mut` prima del
nome della variabile:

```rust,ignore
let mele = 5; // immutabile
let mut banane = 5; // mutabile
```

> Nota: La sintassi `//` inizia un commento che continua fino alla fine del
> riga. Rust ignora tutto ciò che è nei commenti. Discuteremo di più
> sui commenti nel dettaglio nel [Capitolo 3][comments]<!-- ignore -->.

Tornando al programma del gioco dell'indovinello, ora sai che `let mut guess` introdurrà
una variabile mutabile chiamata `guess`. Il simbolo uguale (`=`) dice a Rust che
vogliamo legare qualcosa alla variabile ora. A destra del simbolo uguale c'è il valore a cui `guess` è legata, che è il risultato della chiamata
`String::new`, una funzione che restituisce una nuova istanza di un `String`.
[`String`][string]<!-- ignore --> è un tipo di stringa fornito dalla libreria standard
che è un pezzo di testo codificato UTF-8 e ingrandibile.

La sintassi `::` nella riga `::new` indica che `new` è una funzione associata
del tipo `String`. Una *funzione associata* è una funzione implementata su un tipo, in questo caso `String`. Questa funzione `new` crea una
nuova stringa vuota. Troverai una funzione `new` su molti tipi perché è un
nome comune per una funzione che crea un nuovo valore di un certo genere.

In totale, la linea `let mut guess = String::new();` ha creato una variabile
mutabile che attualmente è legata a una nuova istanza vuota di un `String`. Che fatica!

### Ricevere Input dall'Utente

Ricordiamo che abbiamo incluso la funzionalità di input/output dalla libreria standard con `use std::io;` sulla prima riga del programma. Ora chiameremo
la funzione `stdin` dal modulo `io`, che ci consentirà di gestire l'input dell'utente:

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-01/src/main.rs:read}}
```

Se non avessimo importato la libreria `io` con `use std::io;` all'inizio del
programma, avremmo potuto comunque utilizzare la funzione scrivendo questa chiamata di funzione come
`std::io::stdin`. La funzione `stdin` restituisce un'istanza di
[`std::io::Stdin`][iostdin]<!-- ignore -->, che è un tipo che rappresenta un
gestore per lo standard input del tuo terminale.

La riga successiva, `.read_line(&mut guess)` chiama il metodo [`read_line`][read_line]<!--
ignore --> sul gestore dell'input standard per ottenere l'input dall'utente.
Stiamo anche passando `&mut guess` come argomento a `read_line` per dirgli in quale
stringa archiviare l'input dell'utente. Il compito completo di `read_line` è di prendere
quello che l'utente scrive nell'input standard e aggiungerlo a una stringa
(senza sovrascrivere i suoi contenuti), quindi passiamo quella stringa come argomento. La stringa argomento deve essere mutabile perchè il metodo può cambiare il
contenuto della stringa.

L'`&` indica che questo argomento è un *riferimento*, che ti permette di
lasciare che più parti del tuo codice accedano a un pezzo di dati senza bisogno di
copiare quei dati in memoria più volte. I riferimenti sono una caratteristica complessa,
e uno dei principali vantaggi di Rust è quanto sia sicuro e facile usare
i riferimenti. Non hai bisogno di conoscere molti di questi dettagli per finire questo
programma. Per ora, tutto quello che devi sapere è che, come le variabili, i riferimenti sono
immutabili per impostazione predefinita. Quindi, devi scrivere `&mut guess` piuttosto che
`&guess` per renderlo mutabile. (Il Capitolo 4 spiegherà i riferimenti più
completamente.)

<!-- Old heading. Do not remove or links may break. -->
<a id="handling-potential-failure-with-the-result-type"></a>

### Gestione dei Potenziali Fallimenti con `Result`

Stiamo ancora lavorando su questa riga di codice. Stiamo ora discutendo di una terza riga di
testo, ma nota che è ancora parte di una singola riga logica di codice. La parte successiva è questo metodo:

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-01/src/main.rs:expect}}
```

Avremmo potuto scrivere questo codice come:

```rust,ignore
io::stdin().read_line(&mut guess).expect("Failed to read line");
```

Tuttavia, una riga lunga è difficile da leggere, quindi è meglio dividerla. È
spesso saggio introdurre una nuova riga e altri spazi bianchi per aiutare a spezzare le linee lunghe quando si chiama un metodo con la sintassi `.method_name()`. Ora discutiamo di cosa fa questa riga.

Come accennato prima, `read_line` mette qualsiasi cosa l'utente inserisce nella stringa
che gli passiamo, ma restituisce anche un valore `Result`. [`Result`][result]<!--
ignore --> è un [*enumerazione*][enums]<!-- ignore -->, spesso chiamata *enum*,
che è un tipo che può essere in uno dei possibili stati multipli. Chiamiamo ogni possobile stato un *variante*.

Il [Capitolo 6][enums]<!-- ignore --> tratterà gli enum in modo più dettagliato. Lo scopo
di questi tipi `Result` è di codificare le informazioni sulla gestione degli errori.

I varianti di `Result` sono `Ok` e `Err`. La variante `Ok` indica che l'operazione è stata eseguita con successo, e dentro `Ok` c'è il valore generato con successo. 
La variante `Err` significa che l'operazione è fallita, e `Err` contiene informazioni su come o perché l'operazione è fallita.

I valori del tipo `Result`, come i valori di qualsiasi tipo, hanno metodi definiti su di loro. Un'istanza di `Result` ha un metodo [`expect`][expect]<!-- ignore -->
che puoi chiamare. Se questa istanza di `Result` è un valore `Err`, `expect`
farà crashare il programma e visualizzerà il messaggio che hai passato come argomento a `expect`. Se il metodo `read_line` restituisce un `Err`, sarebbe probabilmente il risultato di un errore proveniente dal sistema operativo sottostante.
Se questa istanza di `Result` è un valore `Ok`, `expect` prenderà il valore di ritorno che `Ok` sta contenendo e restituirà solo quel valore a te in modo da poterlo utilizzare. In questo caso, quel valore è il numero di byte nell'input dell'utente.

Se non chiami `expect`, il programma compila, ma otterrai un avviso:

```console
{{#include ../listings/ch02-guessing-game-tutorial/no-listing-02-without-expect/output.txt}}
```

Rust avverte che non hai utilizzato il valore `Result` restituito da `read_line`,
indicando che il programma non ha gestito un possibile errore.

Il modo corretto per sopprimere l'avviso è di scrivere effettivamente il codice di gestione degli errori,
ma nel nostro caso vogliamo solo far crashare questo programma quando si verifica un problema, quindi possiamo
usare `expect`. Imparerai a riprenderti dagli errori nel [Capitolo
9][recover]<!-- ignore -->.

### Stampa dei Valori con i Segnaposti di `println!`

A parte la parentesi graffa di chiusura, c'è solo una riga da discutere nel codice finora:

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-01/src/main.rs:print_guess}}
```

Questa riga stampa la stringa che ora contiene l'input dell'utente. Il `{}` insieme di parentesi graffe è un segnaposto: pensa al `{}` come piccole chele di granchio che mantengono un valore al suo posto. Quando si stampa il valore di una variabile, il nome della variabile può andare nelle parentesi graffe. Quando si stampa il risultato della valutazione di un'espressione, si posiziona l'insieme di parentesi graffe vuoto nella stringa di formato, quindi si segue la stringa di formato con una lista separata da virgole di espressioni da stampare in ogni segnaposto di parentesi graffa vuota nello stesso ordine. Stampare una variabile e il risultato di un'espressione in una sola chiamata a `println!` apparirebbe così:

```rust
let x = 5;
let y = 10;

println!("x = {x} and y + 2 = {}", y + 2);
```

Questo codice stamperebbe `x = 5 and y + 2 = 12`.

### Test della Prima Parte

Proviamo la prima parte del gioco della supposizione. Eseguiamolo utilizzando `cargo run`:

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

A questo punto, la prima parte del gioco è completata: stiamo ottenendo l'input dalla
tastiera e poi lo stampiamo.

## Generazione di un Numero Segreto

Successivamente, dobbiamo generare un numero segreto che l'utente proverà a indovinare. Il
numero segreto dovrebbe essere diverso ogni volta così il gioco è divertente da giocare più di una volta. Useremo un numero casuale tra 1 e 100 così il gioco non è troppo
difficile. Rust non include ancora la funzionalità di numeri casuali nella sua libreria standard. Tuttavia, il team di Rust fornisce un [`rand` crate][randcrate] con
detta funzionalità.

### Utilizzo di un Crate per Ottenere Più Funzionalità

Ricorda che un crate è una collezione di file di codice sorgente Rust. Il progetto
che stiamo costruendo è un *crate binario*, che è un eseguibile. Il `rand`
crate è un *crate di libreria*, che contiene codice che è destinato a essere utilizzato in altri programmi e non può essere eseguito da solo.
Il coordinamento di Cargo delle crates esterne è il punto di forza di Cargo. Prima che possiamo scrivere codice che utilizza `rand`, dobbiamo modificare il file *Cargo.toml* per includere la crate `rand` come dipendenza. Apri quel file adesso e aggiungi la seguente riga in fondo, sotto l'intestazione della sezione `[dependencies]` che Cargo ha creato per te. Assicurati di specificare `rand` esattamente come abbiamo qui, con questo numero di versione, altrimenti gli esempi di codice in questo tutorial potrebbero non funzionare:

<!-- Quando aggiorni la versione di `rand` utilizzata, aggiorna anche la versione di
`rand` utilizzata in questi file in modo che tutti corrispondano:
* ch07-04-bringing-paths-into-scope-with-the-use-keyword.md
* ch14-03-cargo-workspaces.md
-->

<span class="filename">Nome del file: Cargo.toml</span>

```toml
{{#include ../listings/ch02-guessing-game-tutorial/listing-02-02/Cargo.toml:8:}}
```

Nel file *Cargo.toml*, tutto ciò che segue un'intestazione fa parte di quella sezione che continua fino a quando non inizia un'altra sezione. In `[dependencies]` dici a Cargo quali crates esterne il tuo progetto dipende e quali versioni di quelle crates richiedi. In questo caso, specifichiamo la crate `rand` con il selettore di versione semantica `0.8.5`. Cargo capisce [Versionamento Semantico][semver]<!-- ignore --> (a volte chiamato *SemVer*), che è uno standard per scrivere numeri di versione. Il selettore `0.8.5` è in realtà una scorciatoia per `^0.8.5`, che significa qualsiasi versione che è almeno 0.8.5 ma inferiore a 0.9.0.

Cargo considera queste versioni avere API pubbliche compatibili con la versione 0.8.5, e questa specifica garantisce che otterrai l'ultimo rilascio di patch che compilerà ancora con il codice in questo capitolo. Non è garantito che qualsiasi versione 0.9.0 o superiore abbia la stessa API di quella che gli esempi seguenti utilizzano.

Ora, senza cambiare nessuno del codice, costruiamo il progetto, come mostrato in elenco 2-2.

<!-- rigenerazione-manuale
cd listings/ch02-guessing-game-tutorial/listing-02-02/
rm Cargo.lock
cargo clean
cargo build -->

```console
$ cargo build
    Aggiornamento crates.io index
  Scaricato rand v0.8.5
  Scaricato libc v0.2.127
  Scaricato getrandom v0.2.7
  Scaricato cfg-if v1.0.0
  Scaricato ppv-lite86 v0.2.16
  Scaricato rand_chacha v0.3.1
  Scaricato rand_core v0.6.3
   Compilazione libc v0.2.127
   Compilazione getrandom v0.2.7
   Compilazione cfg-if v1.0.0
   Compilazione ppv-lite86 v0.2.16
   Compilazione rand_core v0.6.3
   Compilazione rand_chacha v0.3.1
   Compilazione rand v0.8.5
   Compilazione guessing_game v0.1.0 (file:///projects/guessing_game)
    Finito dev [unoptimized + debuginfo] target(s) in 2.53s
```

<span class="caption">Listato 2-2: L'output dall'esecuzione di `cargo build` dopo
avendo aggiunto la crate rand come dipendenza</span>

Potresti vedere numeri di versione diversi (ma saranno tutti compatibili con il
codice, grazie a SemVer!) e righe diverse (a seconda del sistema
operativo), e le righe possono essere in un ordine diverso.

Quando includiamo una dipendenza esterna, Cargo recupera le ultime versioni di
tutto ciò di cui quella dipendenza ha bisogno dal *registro*, che è una copia dei dati
da [Crates.io][cratesio]. Crates.io è dove le persone nell'ecosistema Rust
pubblicano i loro progetti Rust open source per l'utilizzo da parte di altri.

Dopo aver aggiornato il registro, Cargo controlla la sezione `[dependencies]` e
scarica le crates elencate che non sono già scaricate. In questo caso,
sebbene abbiamo elencato solo `rand` come dipendenza, Cargo ha anche preso altre crates
di cui `rand` dipende per funzionare. Dopo aver scaricato le crates, Rust le compila
e poi compila il progetto con le dipendenze disponibili.

Se immediatamente esegui `cargo build` di nuovo senza apportare modifiche, tu
non otterrai output se non la riga `Finished`. Cargo sa che ha già
scaricato e compilato le dipendenze, e tu non hai cambiato nulla
riguardo a loro nel tuo file *Cargo.toml*. Cargo sa anche che non hai cambiato
nulla riguardo al tuo codice, quindi non lo ricompila nemmeno. Con nulla da
fare, esce semplicemente.

Se apri il file *src/main.rs*, fai una modifica banale, e poi salvi e
costruisci di nuovo, vedrai solo due righe di output:

<!-- rigenerazione-manuale
cd listings/ch02-guessing-game-tutorial/listing-02-02/
touch src/main.rs
cargo build -->

```console
$ cargo build
   Compilazione guessing_game v0.1.0 (file:///projects/guessing_game)
    Finish dev [unoptimized + debuginfo] target(s) in 2.53 secs
```

Queste righe mostrano che Cargo aggiorna solo la build con la tua piccola modifica al
file *src/main.rs*. Le tue dipendenze non sono cambiate, quindi Cargo sa che può
riutilizzare ciò che ha già scaricato e compilato per quelle.

#### Garantire Costruzioni Riproducibili con il file *Cargo.lock*

Cargo ha un meccanismo che ti assicura di poter ricostruire lo stesso artefatto ogni volta
tu o chiunque altro costruisce il tuo codice: Cargo utilizzerà solo le versioni delle
dipendenze che hai specificato fino a quando non indichi diversamente. Ad esempio, diciamo che
la prossima settimana esce la versione 0.8.6 della crate `rand`, e quella versione
contiene una correzione di bug importante, ma contiene anche una regressione che
causerà la rottura del tuo codice. Per gestire questo, Rust crea il file *Cargo.lock* la prima volta che esegui `cargo build`, quindi ora abbiamo questo nella directory *guessing_game*.

Quando costruisci un progetto per la prima volta, Cargo capisce tutte le versioni
delle dipendenze che soddisfano i criteri e poi li scrive al
file *Cargo.lock*. Quando costruirai il tuo progetto in futuro, Cargo vedrà
che il file *Cargo.lock* esiste e userà le versioni specificate là
piuttosto che fare tutto il lavoro di capire le versioni di nuovo. Questo ti permette di
avere una costruzione riproducibile automaticamente. In altre parole, il tuo progetto rimarrà al 0.8.5 fino a quando non fai un aggiornamento esplicito, grazie al file *Cargo.lock*. Poiché il file *Cargo.lock* è importante per le costruzioni riproducibili, è spesso
controllato nel controllo del codice sorgente con il resto del codice nel tuo progetto.

#### Aggiornamento di una Crate per Ottenere una Nuova Versione

Quando *vuoi* aggiornare una crate, Cargo fornisce il comando `update`,
che ignorerà il file *Cargo.lock* e capirà tutte le ultime versioni
che si adattano alle tue specifiche in *Cargo.toml*. Cargo poi scrive quelle
versioni nel file *Cargo.lock*. Altrimenti, per default, Cargo cercherà solo
versioni maggiori di 0.8.5 e inferiori a 0.9.0. Se la crate `rand` ha
rilasciato le due nuove versioni 0.8.6 e 0.9.0, vedresti quanto segue se
esegui `cargo update`:

<!-- rigenerazione-manuale
cd listings/ch02-guessing-game-tutorial/listing-02-02/
cargo update
assumendo che ci sia una nuova versione 0.8.x di rand; altrimenti usa un altro aggiornamento
come guida per creare l'output ipotetico mostrato qui -->

```console
$ cargo update
    Aggiornamento crates.io index
    Aggiornamento rand v0.8.5 -> v0.8.6
```
Cargo ignora il rilascio 0.9.0. A questo punto, noteresti anche un cambiamento
nel tuo file *Cargo.lock* che indica che la versione della crate `rand` che stai
ora utilizzando è 0.8.6. Per usare `rand` version 0.9.0 o qualsiasi versione nella serie 0.9.*x*,
dovresti aggiornare il file *Cargo.toml* in modo che sembri questo:

```toml
[dependencies]
rand = "0.9.0"
```

La prossima volta che eseguirai `cargo build`, Cargo aggiornerà il registro delle crate
disponibili e rivaluterà le tue esigenze di `rand` secondo la nuova versione
che hai specificato.

C'è molto altro da dire su [Cargo][doccargo]<!-- ignore --> e [il suo
ecosistema][doccratesio]<!-- ignore -->, di cui parleremo nel Capitolo 14, ma
per ora, questo è tutto ciò che devi sapere. Cargo semplifica molto il riutilizzo
delle librerie, quindi i Rustaceans sono in grado di scrivere progetti più piccoli che sono assemblati
da un numero di pacchetti.

### Generare un Numero Casuale

Iniziamo a utilizzare `rand` per generare un numero da indovinare. Il passo successivo è quello di
aggiorna *src/main.rs*, come mostrato nella Listing 2-3.

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-03/src/main.rs:all}}
```

<span class="caption">Listing 2-3: Aggiunta di codice per generare un numero
casuale</span>

Prima aggiungiamo la riga `use rand::Rng;`. Il trait `Rng` definisce metodi che
i generatori di numeri casuali implementano, e questo trait deve essere in scope per noi
usare quei metodi. Il Capitolo 10 tratterà i trait in dettaglio.

In seguito, stiamo aggiungendo due righe nel mezzo. Nella prima riga, chiamiamo
la funzione `rand::thread_rng` che ci dà il particolare generatore di numeri
casuale che andremo a utilizzare: uno che è locale al thread corrente di
esecuzione e viene inizializzato dal sistema operativo. Poi chiamiamo `gen_range`
metodo sul generatore di numeri casuali. Questo metodo è definito dal trait `Rng`
che abbiamo importato con l'istruzione `use rand::Rng;`. Il
metodo `gen_range` prende un'espressione di range come argomento e genera un
numero casuale nell'intervallo. Il tipo di espressione di range che stiamo utilizzando qui prende
la forma `start..=end` ed è inclusivo sui limiti inferiori e superiori, quindi
dobbiamo specificare `1..=100` per richiedere un numero tra 1 e 100.

> Nota: Non saprai semplicemente quali trait utilizzare e quali metodi e funzioni
> chiamare da una crate, quindi ogni crate ha una documentazione con le istruzioni per
> utilizzarlo. Un'altra interessante funzionalità di Cargo è che eseguendo il comando `cargo doc
> --open` verrà generata localmente la documentazione fornita da tutte le tue dipendenze
> e la aprirà nel tuo browser. Se sei interessato ad altre
> funzionalità nel crate `rand`, ad esempio, esegui `cargo doc --open` e
> fai clic su `rand` nella barra laterale a sinistra.

La seconda nuova linea stampa il numero segreto. Questo è utile mentre stiamo
sviluppando il programma per poterlo testare, ma lo cancelleremo dalla
versione finale. Non è un gran gioco se il programma stampa la risposta appena
inizia!

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
Inserisci il tuo indovinello.
4
Hai indovinato: 4

$ cargo run
    Finished dev [unoptimized + debuginfo] target(s) in 0.02s
     Running `target/debug/guessing_game`
Indovina il numero!
Il numero segreto è: 83
Inserisci il tuo indovinello.
5
Hai indovinato: 5
```

Dovresti ottenere numeri casuali diversi, e dovrebbero essere tutti numeri tra
1 e 100. Ottimo lavoro!

## Confrontare l'Indovinello con il Numero Segreto

Ora che abbiamo l'input dell'utente e un numero casuale, possiamo confrontarli. Quel passo
è mostrato nella Listing 2-4. Nota che questo codice non compilerà ancora, come spiegheremo.

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-04/src/main.rs:here}}
```

<span class="caption">Listing 2-4: Gestione dei possibili valori di ritorno del
confronto tra due numeri</span>

Prima aggiungiamo un'altra istruzione `use`, portando in scope un tipo chiamato
`std::cmp::Ordering` dalla libreria standard. Il tipo `Ordering` è un altro enum e ha i varianti `Less`, `Greater`, e `Equal`. Questi sono
i tre risultati che sono possibili quando confronti due valori.

Poi aggiungiamo cinque nuove righe in fondo che utilizzano il tipo `Ordering`. Il
metodo `cmp` confronta due valori e può essere chiamato su qualsiasi cosa che può essere
confrontato. Prende un riferimento a qualunque cosa tu voglia paragonare: qui sta
confrontando `guess` a `secret_number`. Poi ritorna una variante dell'enum
`Ordering` che abbiamo portato in scope con l'istruzione `use`. Usiamo un
[`match`][match]<!-- ignore --> espressione per decidere cosa fare successivamente basato
su quale variante di `Ordering` è stata ritornata dalla chiamata a `cmp` con i valori
in `guess` e `secret_number`.

Una espressione `match` è composta da *bracci*. Un braccio consiste in un *pattern* al
quale confrontare, e il codice che dovrebbe essere eseguito se il valore dato a `match`
si adatta al pattern di quel braccio. Rust prende il valore dato a `match` e guarda
attraverso il pattern di ogni braccio a turno. I pattern e la voce `match` sono
caratteristiche potenti di Rust: ti permettono di esprimere una varietà di situazioni che il tuo codice
potrebbe incontrare e si assicurano che tu le gestisca tutte. Queste funzionalità verranno
coperte in dettaglio nei Capitoli 6 e 18.

Facciamo un esempio con l'espressione `match` che usiamo qui. Supponiamo che
l'utente abbia indovinato 50 e il numero segreto generato casualmente questa volta è
38.

Quando il codice confronta 50 a 38, il metodo `cmp` restituirà
`Ordering::Greater` perché 50 è maggiore di 38. L'espressione `match` prende
il valore `Ordering::Greater` e inizia a controllare il pattern di ogni braccio. Esso guarda
il pattern del primo braccio, `Ordering::Less`, e vede che il valore
`Ordering::Greater` non corrisponde a `Ordering::Less`, quindi ignora il codice in
quel braccio e passa al braccio successivo. Il pattern del braccio successivo è
`Ordering::Greater`, che *corrisponde* a `Ordering::Greater`! Il codice associato
in quel braccio verrà eseguito e stamperà `Troppo grande!` sullo schermo. L'espressione `match`
termina dopo il primo match di successo, quindi non guarderà l'ultimo braccio in questo scenario.

Tuttavia, il codice della Listing 2-4 non compilerà ancora. Proviamoci:

<!--
The error numbers in this output should be that of the code **WITHOUT** the
anchor or snip comments
-->

```console
{{#include ../listings/ch02-guessing-game-tutorial/listing-02-04/output.txt}}
```
Il fulcro dell'errore indica che ci sono *tipi non corrispondenti*. Rust ha un
sistema di tipi forte e statico. Tuttavia, ha anche l'inferenza dei tipi. Quando abbiamo scritto
`let mut guess = String::new()`, Rust ha potuto dedurre che `guess` doveva essere
una `String` e non ci ha fatto scrivere il tipo. Il `secret_number`, dall'altra
parte, è un tipo numerico. Alcuni dei tipi numerici di Rust possono avere un valore tra 1
e 100: `i32`, un numero a 32 bit; `u32`, un numero a 32 bit senza segno; `i64`, un
numero a 64 bit; così come altri. A meno che non sia specificato diversamente, Rust di default usa
un `i32`, che è il tipo di `secret_number` a meno che non si aggiungano informazioni sul tipo
altrove che farebbero dedurre a Rust un diverso tipo numerico. Il motivo
dell'errore è che Rust non può confrontare una stringa e un tipo numerico.

In definitiva, vogliamo convertire la `String` che il programma legge come input in un
vero tipo numerico in modo da poterlo confrontare numericamente con il numero segreto. Lo facciamo
aggiungendo questa riga al corpo della funzione `main`:

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/no-listing-03-convert-string-to-number/src/main.rs:here}}
```

La riga è:

```rust,ignore
let guess: u32 = guess.trim().parse().expect("Per favore, digita un numero!");
```

Creiamo una variabile chiamata `guess`. Ma aspetta, il programma non ha già
una variabile chiamata `guess`? Lo ha, ma utilmente Rust ci permette di mascherare il
preesistente valore di `guess` con uno nuovo. *Mascherare* ci permette di riutilizzare il nome della variabile `guess`
piuttosto che costringerci a creare due variabili uniche, come
`guess_str` e `guess`, per esempio. Tratteremo questo in più dettaglio in
[Capitolo 3][shadowing]<!-- ignore -->, ma per ora, sappiate che questa caratteristica è
spesso utilizzata quando si vuole convertire un valore da un tipo a un altro tipo.

Associamo questa nuova variabile all'espressione `guess.trim().parse()`. Il `guess`
nell'espressione si riferisce alla originale variabile `guess` che conteneva l'input come stringa. Il metodo `trim` su un istanza di `String` eliminerà qualsiasi
spazio bianco all'inizio e alla fine, che dobbiamo fare per essere in grado di confrontare la
stringa con il `u32`, che può contenere solo dati numerici. L'utente deve premere
<span class="keystroke">invio</span> per soddisfare `read_line` e inserire il loro
indovinamento, che aggiunge un carattere di nuova linea alla stringa. Ad esempio, se l'utente
digita <span class="keystroke">5</span> e preme <span
class="keystroke">invio</span>, `guess` appare così: `5\n`. Il `\n`
rappresenta “nuova linea.” (Su Windows, premendo <span
class="keystroke">invio</span> risulta in un ritorno a capo e una nuova linea,
`\r\n`.) Il metodo `trim` elimina `\n` o `\r\n`, risultando in solo `5`.

Il [metodo `parse` su stringhe][parse]<!-- ignore --> converte una stringa in
un altro tipo. Qui, lo usiamo per convertire da una stringa a un numero. Dobbiamo
dire a Rust il numero esatto del tipo che vogliamo usando `let guess: u32`. I due punti
(`:`) dopo `guess` dicono a Rust che annoteremo il tipo della variabile. Rust ha
alcuni tipi numerici incorporati; il `u32` visto qui è un intero non firmato, a 32 bit.
È una buona scelta di default per un piccolo numero positivo. Imparerete su
altri tipi di numeri nel [Capitolo 3][integers]<!-- ignore -->.

Inoltre, l'annotazione `u32` in questo esempio di programma e il confronto
con `secret_number` significa che Rust dedurrà che `secret_number` dovrebbe essere un `u32` anche. Quindi ora il confronto sarà tra due valori dello stesso
tipo!

Il metodo `parse` funzionerà solo su caratteri che possono logicamente essere convertiti
in numeri e quindi può facilmente causare errori. Se, ad esempio, la stringa
contenuta `A👍%`, non ci sarebbe modo di convertirlo in un numero. Poiché potrebbe
fallire, il metodo `parse` restituisce un tipo `Result`, esattamente come fa il metodo `read_line`
(parlato prima in [“Gestire il Potenziale Fallimento con
`Result`”](#handling-potential-failure-with-result)<!-- ignore-->). Tratteremo
questo `Result` allo stesso modo utilizzando il metodo `expect` ancora. Se `parse`
restituisce una variante `Err` `Result` perché non è riuscita a creare un numero dal
stringa, la chiamata `expect` farà andare in crash il gioco e stamperà il messaggio che gli diamo.
Se `parse` può convertire con successo la stringa in un numero, restituirà la
variante `Ok` di `Result`, e `expect` restituirà il numero che vogliamo dal
valore `Ok`.

Facciamo girare il programma ora:

<!-- manual-regeneration
cd listings/ch02-guessing-game-tutorial/no-listing-03-convert-string-to-number/
cargo run
  76
-->

```console
$ cargo run
   Compilazione guessing_game v0.1.0 (file:///projects/guessing_game)
    Terminata non ottimizzata + debuginfo cosi com'è in 0.43s
     Esecuzione di `target/debug/guessing_game`
Indovina il numero!
Il numero segreto è: 58
Inserisci il tuo indovinello.
  76
Hai indovinato: 76
Troppo grande!
```

Bene! Anche se sono stati aggiunti spazi prima dell'indovinello, il programma ha ancora capito che l'utente ha indovinato 76. Esegui il programma più volte per verificare il
comportamento diverso con diversi tipi di input: indovina il numero correttamente,
indovina un numero che è troppo alto, e indovina un numero che è troppo basso.

Abbiamo la maggior parte del gioco che funziona ora, ma l'utente può fare solo un indovinello.
Cerchiamo di cambiarlo aggiungendo un ciclo!

## Consentire Multiple Indovinati con un Ciclo

La parola chiave `loop` crea un ciclo infinito. Aggiungeremo un ciclo per dare agli utenti
più opportunità di indovinare il numero:

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/no-listing-04-looping/src/main.rs:here}}
```

Come potete vedere, abbiamo spostato tutto a partire dall'input dell'indovinello in avanti dentro
un ciclo. Assicuratevi di rientrare le righe all'interno del ciclo con altri quattro spazi ciascuno
e eseguire il programma di nuovo. Il programma ora chiederà un altro indovinello per sempre,
che in realtà introduce un nuovo problema. Non sembra che l'utente possa uscire!

L'utente potrebbe sempre interrompere il programma utilizzando la scorciatoia da tastiera
<span class="keystroke">ctrl-c</span>. Ma c'è un altro modo per sfuggire a questo
mostro insaziabile, come menzionato nella discussione `parse` in [“Confrontando l'Indovinello con il Numero Segreto”](#comparing-the-guess-to-the-secret-number)<!--
ignore -->: se l'utente inserisce una risposta non numerica, il programma andrà in crash. Possiamo
sfruttare ciò per consentire all'utente di uscire, come mostrato qui:

<!-- manual-regeneration
cd listings/ch02-guessing-game-tutorial/no-listing-04-looping/
cargo run
(indovinello troppo piccolo)
(indovinello troppo grande)
(indovinello corretto)
quit
-->
```console
$ cargo run
   Compiling guessing_game v0.1.0 (file:///projects/guessing_game)
    Finished dev [unoptimized + debuginfo] target(s) in 1.50s
     Running `target/debug/guessing_game`
Indovina il numero!
Il numero segreto è: 59
Inserisci il tuo tentativo.
45
Hai indovinato: 45
Troppo piccolo!
Inserisci il tuo tentativo.
60
Hai indovinato: 60
Troppo grande!
Inserisci il tuo tentativo.
59
Hai indovinato: 59
Hai vinto!
Inserisci il tuo tentativo.
quit
thread 'main' panicked at 'Si prega di digitare un numero!: ParseIntError { kind: InvalidDigit }', src/main.rs:28:47
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace
```

Digitare `quit` terminerà il gioco, ma come noterai, lo farà anche l'inserimento di qualsiasi
altro input non numerico. Questo è subottimale, per dirlo con gentilezza; vogliamo che il gioco
si fermi anche quando il numero corretto viene indovinato.

### Uscita Dopo un Tentativo Corretto

Programmiamo il gioco per uscire quando l'utente vince aggiungendo una dichiarazione `break`:

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/no-listing-05-quitting/src/main.rs:here}}
```

Aggiungendo la riga `break` dopo `Hai vinto!` si fa sì che il programma esca dal loop quando
l'utente indovina il numero segreto correttamente. Uscire dal loop significa anche
usare dal programma, perché il loop è l'ultima parte di `main`.

### Gestione di Input Non Validi

Per affinare ulteriormente il comportamento del gioco, invece di far cadere il programma quando
l'utente inserisce un non numero, facciamo sì che il gioco ignori un non numero così l'utente può continuare a tentare. Possiamo farlo modificando la riga in cui `guess`
viene convertito da una `String` a un `u32`, come mostrato nell'elenco 2-5.

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-05/src/main.rs:here}}
```

<span class="caption">Elenco 2-5: Ignorare un tentativo non numerico e chiedere un
altro tentativo invece di far cadere il programma</span>

Passiamo da una chiamata `expect` a un'espressione `match` per passare da un crash
su un errore a gestire l'errore. Ricorda che `parse` restituisce un tipo `Result`
e `Result` è un enum che ha le varianti `Ok` e `Err`. Stiamo usando
un'espressione `match` qui, come abbiamo fatto con il risultato `Ordering` del metodo `cmp`.

Se `parse` riesce a convertire correttamente la stringa in un numero, restituirà
un valore `Ok` che contiene il numero risultante. Quel valore `Ok` corrisponderà
al modello del primo braccio, e l'espressione `match` restituirà semplicemente il
valore `num` che `parse` ha prodotto e messo all'interno del valore `Ok`. Quel numero
finirà proprio dove lo vogliamo nel nuovo variabile `guess` che stiamo creando.

Se `parse` *non* riesce a convertire la stringa in un numero, restituirà un
valore `Err` che contiene ulteriori informazioni sull'errore. Il valore `Err`
non corrisponde al modello `Ok(num)` nel primo braccio di `match`, ma corrisponde
al modello `Err(_)` nel secondo braccio. L'underscore, `_`, è un
valore catchall; in questo esempio, stiamo dicendo che vogliamo abbinare tutti i valori `Err`,
indipendentemente dalle informazioni che contengono al loro interno. Quindi il programma eseguirà
il codice del secondo braccio, `continue`, che dice al programma di andare alla
prossima iterazione del `loop` e chiedere un altro tentativo. Quindi, in effetti, il
programma ignora tutti gli errori che `parse` potrebbe incontrare!

Ora tutto nel programma dovrebbe funzionare come previsto. Proviamoci:

<!-- manual-regeneration
cd listings/ch02-guessing-game-tutorial/listing-02-05/
cargo run
(tentativo troppo piccolo)
(tentativo troppo grande)
foo
(tentativo corretto)
-->

```console
$ cargo run
   Compiling guessing_game v0.1.0 (file:///projects/guessing_game)
    Finished dev [unoptimized + debuginfo] target(s) in 4.45s
     Running `target/debug/guessing_game`
Indovina il numero!
Il numero segreto è: 61
Inserisci il tuo tentativo.
10
Hai indovinato: 10
Troppo piccolo!
Inserisci il tuo tentativo.
99
Hai indovinato: 99
Troppo grande!
Inserisci il tuo tentativo.
foo
Inserisci il tuo tentativo.
61
Hai indovinato: 61
Hai vinto!
```

Fantastico! Con un piccolo ritocco finale, termineremo il gioco di indovinare. Ricorda
che il programma sta ancora stampando il numero segreto. Questo ha funzionato bene per
i test, ma rovina il gioco. Cancelliamo il `println!` che stampa il
numero segreto. L'elenco 2-6 mostra il codice finale.

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-06/src/main.rs}}
```

<span class="caption">Elenco 2-6: Codice completo del gioco di indovinare</span>

A questo punto, hai realizzato con successo il gioco di indovinare. Congratulazioni!

## Riepilogo

Questo progetto è stato un modo pratico di introdurti a molti nuovi concetti di Rust:
`let`, `match`, funzioni, l'uso di crate esterne, e altro ancora. Nei prossimi
pochi capitoli, imparerai questi concetti con più dettaglio. Il Capitolo 3
copre concetti che la maggior parte dei linguaggi di programmazione ha, come le variabili, i tipi di dati, e le funzioni, e mostra come usarli in Rust. Il Capitolo 4 esplora
la proprietà, una caratteristica che rende Rust diverso da altri linguaggi. Il Capitolo 5
discute le strutture e la sintassi dei metodi, e il Capitolo 6 spiega come funzionano gli enum.

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

