# Programmazione di un gioco d'indovinello

Tuffiamoci in Rust lavorando su un progetto pratico insieme! Questo
capitolo introduce alcuni concetti comuni di Rust mostrandoti come utilizzarli in un vero programma. Imparerai cose riguardo a `let`, `match`, metodi, funzioni associate, crate esterni e molto altro! Nei capitoli seguenti, esploreremo
queste idee in modo più dettagliato. In questo capitolo, eserciterai solamente le basi.

Implementeremo un classico problema di programmazione per principianti: un gioco d'indovinello. Ecco come funziona: il programma genererà un numero intero casuale tra 1 e 100. Chiederà quindi al giocatore di inserire un'ipotesi. Dopo aver inserito un'ipotesi, il programma indicherà se l'ipotesi è troppo bassa o troppo alta. Se l'ipotesi è corretta, il gioco stamperà un messaggio di congratulazioni ed uscirà.

## Creazione di un Nuovo Progetto

Per impostare un nuovo progetto, vai alla directory *progetti* che hai creato nel Capitolo 1 e crea un nuovo progetto utilizzando Cargo, come segue:

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

Come hai visto nel Capitolo 1, `cargo new` genera un programma "Ciao, mondo!" per
te. Controlla il file *src/main.rs*:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/no-listing-01-cargo-new/src/main.rs}}
```

Ora compiliamo questo programma "Ciao, mondo!" ed eseguiamolo nello stesso passaggio
usando il comando `cargo run`:

```console
{{#include ../listings/ch02-guessing-game-tutorial/no-listing-01-cargo-new/output.txt}}
```

Il comando `run` è utile quando devi iterare rapidamente su un progetto,
come faremo in questo gioco, testando rapidamente ogni iterazione prima di passare a
quella successiva.

Riapri il file *src/main.rs*. Scriverai tutto il codice in questo file.

## Elaborazione di un'Ipotesi

La prima parte del programma del gioco d'indovinello chiederà l'input dell'utente, elaborerà
quell'input, e verificherà che l'input sia nella forma prevista. Per iniziare, permetteremo
al giocatore di inserire un'ipotesi. Inserisci il codice in Elenco 2-1 in
*src/main.rs*.

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-01/src/main.rs:all}}
```

<span class="caption">Elenco 2-1: Codice che ottiene un'ipotesi dall'utente e
lo stampa</span>

Questo codice contiene molte informazioni, quindi andiamoci sopra riga per riga. Per
ottenere l'input dell'utente e poi stampare il risultato come output, abbiamo bisogno di portare la
libreria `io` di input/output nell'ambito di applicazione. La libreria `io` proviene dalla libreria standard
nota con il nome di `std`:

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-01/src/main.rs:io}}
```

Per impostazione predefinita, Rust ha un insieme di elementi definiti nella libreria standard che
porta nell'ambito di applicazione di ogni programma. Questo insieme è chiamato *prelude*, e
puoi vedere tutto in esso [nella documentazione della libreria standard][prelude].

Se un tipo che vuoi utilizzare non è nel prelude, devi portare quel tipo
nell'ambito di applicazione esplicitamente con una dichiarazione `use`. Utilizzando la libreria `std::io`
fornisce una serie di funzionalità utili, compresa la possibilità di accettare
input dell'utente.

Come hai visto nel Capitolo 1, la funzione `main` è il punto di ingresso nel
programma:

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-01/src/main.rs:main}}
```

La sintassi `fn` dichiara una nuova funzione; le parentesi, `()`, indicano che
non ci sono parametri; e le parentesi graffe, `{`, iniziano il corpo della funzione.

Come hai anche imparato nel Capitolo 1, `println!` è una macro che stampa una stringa a
lo schermo:

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-01/src/main.rs:print}}
```

Questo codice stampa un prompt che indica di cosa tratta il gioco e richiede l'input
dall'utente.

### Memorizzazione dei Valori con le Variabili

Successivamente, creeremo una *variabile* per memorizzare l'input dell'utente, così:

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-01/src/main.rs:string}}
```

Ora il programma sta diventando interessante! C'è molto da fare in questa piccola
riga. Usiamo l'istruzione `let` per creare la variabile. Ecco un altro esempio:

```rust,ignore
let mele = 5;
```

Questa riga crea una nuova variabile chiamata `mele` e la lega al valore 5. In
Rust, le variabili sono immutabili per impostazione predefinita, il che significa che una volta che diamo un valore alla variabile, il valore non cambierà. Discuteremo di questo concetto in dettaglio nel
sezione ["Variables and Mutability"][variabili-e-mutabilità]<!-- ignore -->
nel Capitolo 3. Per rendere una variabile mutabile, aggiungiamo `mut` prima del
nome della variabile:

```rust,ignore
let mele = 5; // immutabile
let mut banane = 5; // mutabile
```

> Nota: La sintassi `//` avvia un commento che continua fino alla fine del
> linea. Rust ignora tutto nei commenti. Discuteremo più dettagliatamente dei commenti nel [Capitolo 3][comments]<!-- ignora -->.

Tornando al programma del gioco d'indovinello, ora sai che `let mut guess` introdurrà
una variabile mutabile chiamata `guess`. Il segno uguale (`=`) dice a Rust che
vogliamo legare qualcosa alla variabile ora. A destra del segno uguale c'è
il valore a cui `guess` è legato, che è il risultato della chiamata a
`String::new`, una funzione che restituisce una nuova istanza di una `String`.
[`String`][string]<!-- ignore --> è un tipo di stringa fornito dalla libreria standard
che è un pezzo di testo UTF-8 modificabile.

La sintassi `::` nel `::new` indica che `new` è una funzione associata
del tipo `String`. Una *funzione associata* è una funzione che è
implementata su un tipo, in questo caso `String`. Questa funzione `new` crea una
nuova stringa vuota. Troverai una funzione `new` su molti tipi perché è un
nome comune per una funzione che crea un nuovo valore di qualche tipo.

Nel complesso, la riga `let mut guess = String::new ();` ha creato una variabile mutabile
che attualmente è legata a una nuova istanza vuota di una `String`. Uff!

### Ricezione dell'Input dell'Utente

Ricorda che abbiamo incluso la funzionalità di input/output dalla libreria standard
con `use std::io;` sulla prima riga del programma. Ora chiameremo
la funzione `stdin` dal modulo `io`, che ci permetterà di gestire l'input dell'utente:

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-01/src/main.rs:read}}
```

Se non avessimo importato la libreria `io` con `use std::io;` all'inizio di
del programma, avremmo potuto comunque utilizzare la funzione scrivendo questa chiamata di funzione come
`std::io::stdin`. La funzione `stdin` restituisce un'istanza di
[`std::io::Stdin`][iostdin]<!-- ignore-->, che è un tipo che rappresenta un
gestore per l'input standard del tuo terminale. 

Successivamente, la linea `.read_line(&mut guess)` chiama il metodo [`read_line`][read_line]<!--
ignore --> sull'handle dell'input standard per ricevere l'input dall'utente.
Stiamo anche passando `&mut guess` come argomento a `read_line` per indicare dove
salvare l'input dell'utente. Il compito completo di `read_line` è prendere
qualsiasi cosa l'utente digiti nell'input standard e aggiungerlo a una stringa
(senza sovrascrivere il suo contenuto), quindi passiamo quella stringa come argomento. La stringa deve essere mutabile affinché il metodo possa modificare il
contenuto della stringa.

L'`&` indica che questo argomento è un *riferimento*, che ti dà un modo per
lasciare che più parti del tuo codice accedano a un pezzo di dati senza dover
copiare quei dati in memoria più volte. I riferimenti sono una caratteristica complessa,
ed uno dei principali vantaggi di Rust è quanto sia sicuro e facile usare
i riferimenti. Non hai bisogno di conoscere molti dei dettagli per terminare questo
programma. Per ora, tutto ciò che devi sapere è che, come le variabili, i riferimenti sono
immutabili per default. Di conseguenza, devi scrivere `&mut guess` piuttosto che
`&guess` per renderlo mutabile.  (Il Capitolo 4 spiegherà i riferimenti più
approfonditamente.)

<!-- Old heading. Do not remove or links may break. -->
<a id="handling-potential-failure-with-the-result-type"></a>

### Gestione dei Possibili Fallimenti con `Result`

Stiamo ancora lavorando su questa linea di codice. Ora stiamo discutendo di una terza linea di
testo, ma nota che è ancora parte di una singola linea logica di codice. La prossima
parte è questo metodo:

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-01/src/main.rs:expect}}
```

Avremmo potuto scrivere questo codice come:

```rust,ignore
io::stdin().read_line(&mut guess).expect("Failed to read line");
```

Tuttavia, una lunga linea è difficile da leggere, quindi è meglio dividerla. È
spesso saggio introdurre una nuova linea e altri spazi bianchi per aiutare a spezzare le lunghe
linee quando si chiama un metodo con la sintassi `.method_name()`. Ora discutiamo cosa fa questa linea.

Come accennato in precedenza, `read_line` mette tutto quello che l'utente inserisce nella stringa
che gli passiamo, ma restituisce anche un valore `Result`. [`Result`][result]<!--
ignore --> è una [*enumerazione*][enums]<!-- ignore -->, spesso chiamata *enum*,
che è un tipo che può assumere uno di più possibili stati. Chiamiamo ogni stato possibile *variante*.

[Il Capitolo 6][enums]<!-- ignore --> tratterà gli enum più dettagliatamente. Lo scopo
di questi tipi `Result` è codificare le informazioni sulla gestione degli errori.

Le varianti di `Result` sono `Ok` e `Err`. La variante `Ok` indica che
l'operazione è stata eseguita con successo, e dentro `Ok` si trova il
valore generato con successo. La variante `Err` significa che l'operazione è fallita, e `Err` contiene informazioni
su come o perché l'operazione è fallita.

I valori del tipo `Result`, come i valori di qualsiasi tipo, hanno metodi definiti su di essi. Un'istanza di `Result` ha un metodo [`expect`][expect]<!-- ignore -->
che puoi chiamare. Se questa istanza di `Result` è un valore `Err`, `expect`
causerà il crash del programma e mostrerà il messaggio che hai passato come argomento a `expect`. Se il metodo `read_line` restituisce un `Err`, sarebbe
probabilmente il risultato di un errore proveniente dal sistema operativo sottostante.
Se questa istanza di `Result` è un valore `Ok`, `expect` prenderà il valore di ritorno che `Ok` sta tenendo e lo restituirà proprio a te in modo che tu possa usarlo.
In questo caso, quel valore è il numero di byte nell'input dell'utente.

Se non chiami `expect`, il programma si compilerà, ma otterrai un avviso:

```console
{{#include ../listings/ch02-guessing-game-tutorial/no-listing-02-without-expect/output.txt}}
```

Rust avverte che non hai usato il valore `Result` restituito da `read_line`,
indicando che il programma non ha gestito un possibile errore.

Il modo giusto per sopprimere l'avviso è scrivere effettivamente il codice di gestione degli errori,
ma nel nostro caso vogliamo solo far crashare questo programma quando si verifica un problema, quindi possiamo
usare `expect`. Imparerai a recuperare da errori nel [Capitolo
9][recover]<!-- ignore -->.

### Stampare Valori con i Segnaposto `println!`

A parte la parentesi graffa di chiusura, c'è solo un'altra linea da discutere nel
codice finora:

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-01/src/main.rs:print_guess}}
```

Questa riga stampa la stringa che ora contiene l'input dell'utente. Il set di
parentesi graffe `{}` è un segnaposto: pensa a `{}` come a dei piccoli morsetti di granchio che tengono
un valore al suo posto. Quando stampi il valore di una variabile, il nome della variabile può
andare dentro le parentesi graffe. Quando stampe il risultato di una valutazione di un'espressione, metti le parentesi graffe vuote nella stringa di formato, poi segui la
stringa di formato con una lista di espressioni separate da virgola da stampare in ogni segnaposto di parentesi graffe vuota nello stesso ordine. Stampare una variabile e il risultato
di un'espressione in una chiamata a `println!` potrebbe apparire così:

```rust
let x = 5;
let y = 10;

println!("x = {x} and y + 2 = {}", y + 2);
```

Questo codice stamperà `x = 5 e y + 2 = 12`.

### Testing la Prima Parte

Testiamo la prima parte del gioco di indovinelli. Eseguiamolo usando `cargo run`:

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

A questo punto, la prima parte del gioco è fatta: stiamo ricevendo input dalla
tastiera e poi lo stiamo stampando.

## Generare un Numero Segreto

Successivamente, dobbiamo generare un numero segreto che l'utente proverà a indovinare. Il
numero segreto dovrebbe essere diverso ogni volta in modo che il gioco sia divertente da giocare più di una volta. Useremo un numero casuale tra 1 e 100 in modo che il gioco non sia troppo
difficile. Rust non include ancora una funzionalità di numeri casuali nella sua libreria standard. Tuttavia, il team di Rust fornisce una [`rand` crate][randcrate] con
detta funzionalità.

### Usare una Crate per Ricevere Più Funzionalità

Ricorda che una crate è una collezione di file di codice sorgente Rust. Il progetto
che stiamo costruendo è un *crate binario*, che è un eseguibile. La crate `rand`
è una *crate di libreria*, che contiene il codice che è destinato ad essere utilizzato in altri programmi e non può essere eseguito da solo.

Il coordinamento di Cargo delle crate esterne è dove Cargo risplende davvero. Prima che noi
possiamo scrivere il codice che utilizza `rand`, abbiamo bisogno di modificare il file *Cargo.toml* per
includere la crate `rand` come dipendenza. Apri quel file adesso e aggiungi la
seguente riga in fondo, sotto l'intestazione della sezione `[dependencies]` che
Cargo ha creato per te. Assicurati di specificare `rand` esattamente come abbiamo qui, con
questo numero di versione, o gli esempi di codice in questo tutorial potrebbero non funzionare:

<!-- When updating the version of `rand` used, also update the version of
`rand` used in these files so they all match:
* ch07-04-bringing-paths-into-scope-with-the-use-keyword.md
* ch14-03-cargo-workspaces.md
-->

<span class="filename">Filename: Cargo.toml</span>

```toml
{{#include ../listings/ch02-guessing-game-tutorial/listing-02-02/Cargo.toml:8:}}
```

Nel file *Cargo.toml*, tutto ciò che segue un'intestazione fa parte di quella
sezione che continua fino all'inizio di un'altra sezione. In `[dependencies]` si
dice a Cargo quali crate esterni dipendono dal tuo progetto e quali versioni di
quei crate richiedi. In questo caso, specificiamo il crate `rand` con il
specificatore di versione semantica `0.8.5`. Cargo capisce [Semantic
Versioning][semver]<!-- ignore --> (a volte chiamato *SemVer*), che è uno
standard per scrivere numeri di versione. Il specificatore `0.8.5` è in realtà
una scorciatoia per `^0.8.5`, che significa qualsiasi versione che sia almeno 0.8.5 ma
inferiore a 0.9.0.

Cargo considera queste versioni avere API pubbliche compatibili con la versione
0.8.5, e questa specifica garantisce che otterai l'ultima release di patch che
andrà ancora a compilare con il codice in questo capitolo. Nessuna versione 0.9.0 o superiore
è garantita avere la stessa API di quella utilizzata negli esempi seguenti.

Ora, senza modificare nessuno dei codici, costruiamo il progetto, come mostrato in
Listing 2-2.

<!-- manual-regeneration
cd listings/ch02-guessing-game-tutorial/listing-02-02/
rm Cargo.lock
cargo clean
cargo build -->

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

<span class="caption">Listing 2-2: L'output da eseguire `cargo build` after
aggiungendo il crate di rand come dipendenza</span>

Potresti vedere numeri di versione diversi (ma saranno tutti compatibili con il
codice, grazie a SemVer!) e linee diverse (a seconda del sistema operativo), e le linee possono essere in un ordine diverso.

Quando includiamo una dipendenza esterna, Cargo estrae le ultime versioni di
tutto ciò di cui quella dipendenza ha bisogno dal *registro*, che è una copia dei dati
da [Crates.io][cratesio]. Crates.io è dove le persone nell'ecosistema Rust
postano i loro progetti Rust open source per gli altri da utilizzare.

Dopo aver aggiornato il registro, Cargo controlla la sezione `[dependencies]` e
scarica tutti i crate elencati che non sono già scaricati. In questo caso,
sebbene abbiamo elencato solo `rand` come dipendenza, Cargo ha anche preso altri crate
di cui `rand` dipende per funzionare. Dopo aver scaricato i crate, Rust li compila
e poi compila il progetto con le dipendenze disponibili.

Se esegui immediatamente di nuovo `cargo build` senza apportare modifiche, non
otterrai alcun output oltre alla linea `Finished`. Cargo sa che ha già
scaricato e compilato le dipendenze, e non hai cambiato nulla
di loro nel tuo file *Cargo.toml*. Cargo sa anche che non hai cambiato
nulla riguardo al tuo codice, quindi non lo ricompila neanche. Con niente da
fare, esce semplicemente.

Se apri il file *src/main.rs*, fai una modifica banale, e poi lo salvi e
costruisci di nuovo, vedrai solo due linee di output:

<!-- manual-regeneration
cd listings/ch02-guessing-game-tutorial/listing-02-02/
touch src/main.rs
cargo build -->

```console
$ cargo build
   Compiling guessing_game v0.1.0 (file:///projects/guessing_game)
    Finished dev [unoptimized + debuginfo] target(s) in 2.53 secs
```

Queste righe mostrano che Cargo aggiorna solo la build con la tua piccola modifica al
file *src/main.rs*. Le tue dipendenze non sono cambiate, quindi Cargo sa che può
riutilizzare ciò che ha già scaricato e compilato per quelli.

#### Garantire Build Riproducibili con il File *Cargo.lock*

Cargo ha un meccanismo che assicura che tu possa ricreare lo stesso artefatto ogni volta
tu o chiunque altro costruisci il tuo codice: Cargo userà solo le versioni delle
dipendenze che hai specificato fino a quando non indichi altrimenti. Ad esempio, diciamo che
la prossima settimana esce la versione 0.8.6 del crate `rand`, e quella versione
contiene una correzione di bug importante, ma contiene anche una regressione che
romperà il tuo codice. Per gestire questo, Rust crea il file *Cargo.lock* la prima volta che esegui `cargo build`, quindi ora abbiamo questo nella directory *guessing_game*.

Quando costruisci un progetto per la prima volta, Cargo capisce tutte le versioni
delle dipendenze che si adattino ai criteri e poi li scrive nel
file *Cargo.lock*. Quando costruisci il tuo progetto in futuro, Cargo vedrà
che il file *Cargo.lock* esiste e utilizzerà le versioni specificate lì
piuttosto che fare tutto il lavoro di capire le versioni di nuovo. Questo ti permette
di avere una build riproducibile automaticamente. In altre parole, il tuo progetto
rimarrà alla 0.8.5 fino a quando non aggiorni esplicitamente, grazie al file *Cargo.lock*. 
Poiché il file *Cargo.lock* è importante per le build riproducibili, è spesso
inserito nel controllo del codice sorgente con il resto del codice nel tuo progetto.

#### Aggiornamento di un Crate per Ottenere una Nuova Versione

Quando *vuoi* aggiornare un crate, Cargo fornisce il comando `update`,
che ignorerà il file *Cargo.lock* e capirà tutte le ultime versioni
che si adattano alle tue specifiche in *Cargo.toml*. Cargo poi scriverà quelle
versioni nel file *Cargo.lock*. Altrimenti, per impostazione predefinita, Cargo cercherà solo
per versioni superiori a 0.8.5 e inferiori a 0.9.0. Se il crate `rand` ha
rilasciato le due nuove versioni 0.8.6 e 0.9.0, vedresti il seguente se
hai eseguito `cargo update`:

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

Cargo ignora il rilascio 0.9.0. A questo punto, noteresti anche un cambiamento
nel tuo file *Cargo.lock* notando che la versione del crate `rand` che stai
ora utilizzando è 0.8.6. Per usare la versione `rand` 0.9.0 o qualsiasi versione nella serie 0.9.*x*,
dovresti aggiornare il file *Cargo.toml* per farlo sembrare così:

```toml
[dependencies]
rand = "0.9.0"
```

La prossima volta che esegui `cargo build`, Cargo aggiornerà il registro dei crate
disponibili e rivaluterà i tuoi requisiti `rand` secondo la nuova versione
che hai specificato.

C'è molto altro da dire su [Cargo][doccargo]<!-- ignore --> e [il suo
ecosistema][doccratesio]<!-- ignore -->, che discuteremo nel Capitolo 14, ma
per ora, è tutto ciò che devi sapere. Cargo rende molto facile riutilizzare
le librerie, quindi i Rustaceans sono in grado di scrivere progetti più piccoli che sono assemblati
da una serie di pacchetti.

### Generare un Numero Casuale

Cominciamo ad utilizzare `rand` per generare un numero da indovinare. Il passo successivo è
aggiornare *src/main.rs*, come mostrato nel Listing 2-3.

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-03/src/main.rs:all}}
```

<span class="caption">Listing 2-3: Aggiunta del codice per generare un numero
casuale</span>

Prima aggiungiamo la riga `use rand::Rng;`. Il trait `Rng` definisce metodi che
i generatori di numeri casuali implementano, e questo trait deve essere in ambito per noi per
usare quei metodi. Il Capitolo 10 coprirà i trait nel dettaglio.

In seguito, stiamo aggiungendo due righe nel mezzo. Nella prima riga, chiamiamo la funzione `rand::thread_rng` che ci dà il generatore di numeri casuali che stiamo per utilizzare: uno che è locale al thread corrente di esecuzione e che è inizializzato dal sistema operativo. Poi chiamiamo il metodo `gen_range` sul generatore di numeri casuali. Questo metodo è definito dal trait `Rng` che abbiamo portato in scope con l'istruzione `use rand::Rng;`. Il metodo `gen_range` prende un'espressione di range come argomento e genera un numero casuale in quel range. Il tipo di espressione di range che stiamo utilizzando qui prende la forma `start..=end` ed è inclusiva sui limiti inferiore e superiore, quindi dobbiamo specificare `1..=100` per richiedere un numero tra 1 e 100.

> Nota: Non saprai subito quali trait usare e quali metodi e funzioni chiamare da una crate, quindi ogni crate ha una documentazione con istruzioni per usarla. Un'altra caratteristica interessante di Cargo è che l'esecuzione del comando `cargo doc --open` creerà localmente la documentazione fornita da tutte le tue dipendenze e la aprirà nel tuo browser. Se sei interessato ad altre funzionalità della crate `rand`, ad esempio, esegui `cargo doc --open` e clicca su `rand` nella barra laterale a sinistra.

La seconda nuova riga stampa il numero segreto. Questo è utile mentre stiamo sviluppando il programma per poterlo testare, ma lo cancelleremo dalla versione finale. Non è molto un gioco se il programma stampa la risposta non appena si avvia!

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
Guess the number!
The secret number is: 83
Please input your guess.
5
You guessed: 5
```

Dovresti ottenere numeri casuali diversi, e dovrebbero tutti essere numeri tra 1 e 100. Ottimo lavoro!

## Confrontare il tentativo con il numero segreto

Ora che abbiamo i dati inseriti dall'utente e un numero casuale, possiamo confrontarli. Questo passaggio è mostrato nel Listing 2-4. Nota che questo codice non sarà ancora compilabile, come spiegheremo.

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-04/src/main.rs:here}}
```

<span class="caption">Listing 2-4: Gestione dei possibili valori di ritorno del confronto tra due numeri</span>

Per prima cosa aggiungiamo un'altra dichiarazione `use`, portando un tipo chiamato `std::cmp::Ordering` in scope dalla libreria standard. Il tipo `Ordering` è un altro enum e ha le varianti `Less`, `Greater` e `Equal`. Questi sono i tre risultati possibili quando si confrontano due valori.

Poi aggiungiamo cinque nuove righe in fondo che usano il tipo `Ordering`. Il metodo `cmp` confronta due valori e può essere chiamato su qualsiasi cosa che può essere confrontata. Prende un riferimento a qualsiasi cosa si vuole confrontare: qui sta confrontando `guess` con `secret_number`. Poi restituisce una variante dell'enum `Ordering` che abbiamo portato in scope con la dichiarazione `use`. Usiamo un'espressione [`match`][match]<!-- ignore --> per decidere cosa fare dopo in base a quale variante di `Ordering` è stata restituita dalla chiamata a `cmp` con i valori in `guess` e `secret_number`.

Un'espressione `match` è composta da *bracci*. Un braccio consiste in un *pattern* contro cui fare il match, e il codice che dovrebbe essere eseguito se il valore dato a `match` si adatta al pattern del braccio. Rust prende il valore dato a `match` e guarda attraverso ogni pattern del braccio a turno. I pattern e la struttura `match` sono potenti caratteristiche di Rust: ti permettono di esprimere una varietà di situazioni che il tuo codice potrebbe incontrare e si assicurano che tu le gestisca tutte. Queste caratteristiche verranno coperte in dettaglio nel Capitolo 6 e nel Capitolo 18, rispettivamente.

Facciamo un esempio con l'espressione `match` che usiamo qui. Supponiamo che l'utente abbia indovinato 50 e il numero segreto generato casualmente questa volta sia 38.

Quando il codice confronta 50 con 38, il metodo `cmp` restituisce `Ordering::Greater` perché 50 è maggiore di 38. L'espressione `match` ottiene il valore `Ordering::Greater` e inizia a controllare il pattern di ogni braccio. Guarda il pattern del primo braccio, `Ordering::Less`, e vede che il valore `Ordering::Greater` non corrisponde a `Ordering::Less`, quindi ignora il codice in quel braccio e passa al braccio successivo. Il pattern del braccio successivo è `Ordering::Greater`, che *corrisponde* a `Ordering::Greater`! Il codice associato in quel braccio sarà eseguito e stamperà `Too big!` sullo schermo. L'espressione `match` termina dopo il primo match di successo, quindi non guarderà l'ultimo braccio in questo scenario.

Tuttavia, il codice nel Listing 2-4 non compila ancora. Proviamolo:

```console
{{#include ../listings/ch02-guessing-game-tutorial/listing-02-04/output.txt}}
```

Il nucleo dell'errore afferma che ci sono dei *tipi incompatibili*. Rust ha un sistema di tipi forte e statico. Tuttavia, ha anche l'inferenza dei tipi. Quando abbiamo scritto `let mut guess = String::new()`, Rust è stato in grado di inferire che `guess` dovrebbe essere una `String` e non ci ha fatto scrivere il tipo. Il `secret_number`, d'altra parte, è un tipo numerico. Alcuni dei tipi numerici di Rust possono avere un valore tra 1 e 100: `i32`, un numero a 32 bit; `u32`, un numero unsigned a 32 bit; `i64`, un numero a 64 bit; così come altri. A meno che non sia specificato altrimenti, Rust utilizza un `i32` come default, che è il tipo di `secret_number` a meno che tu non aggiunga informazioni di tipo altrove che porterebbero Rust a inferire un diverso tipo numerico. Il motivo dell'errore è che Rust non può confrontare una stringa e un tipo numerico.

In definitiva, vogliamo convertire la `String` che il programma legge come input in un vero tipo numerico in modo da poterla confrontare numericamente con il numero segreto. Lo facciamo aggiungendo questa riga al corpo della funzione `main`:

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/no-listing-03-convert-string-to-number/src/main.rs:here}}
```

La riga è:

```rust,ignore
let guess: u32 = guess.trim().parse().expect("Please type a number!");
```

Creiamo una variabile chiamata `guess`. Ma aspetta, il programma non ha già una variabile chiamata `guess`? Lo fa, ma fortunatamente Rust ci permette di fare un "shadowing" del valore precedente di `guess` con uno nuovo. Il *shadowing* ci permette di riutilizzare il nome della variabile `guess` piuttosto che costringerci a creare due variabili uniche, come `guess_str` e `guess`, ad esempio. Copriremo questo in più dettaglio nel [Capitolo 3][shadowing]<!-- ignore -->, ma per ora, sappi che questa caratteristica è spesso usata quando vuoi convertire un valore da un tipo ad un altro tipo.
Leghiamo questa nuova variabile all'espressione `guess.trim().parse()`. Il `guess`
nell'espressione si riferisce alla variabile `guess` originale che conteneva l'input 
come stringa. Il metodo `trim` su un'istanza `String` eliminerà qualsiasi spazio
bianco all'inizio e alla fine, che dobbiamo fare per poter confrontare la stringa con
l'`u32`, che può contenere solo dati numerici. L'utente deve premere <span class="keystroke">invio</span>
per soddisfare `read_line` e inserire il loro suggerimento, che aggiunge un carattere di nuova 
linea alla stringa. Ad esempio, se l'utente digita <span class="keystroke">5</span> e preme <span
class="keystroke">invio</span>, `guess` si presenta così: `5\n`. Il `\n`
rappresenta “nuova linea”. (Su Windows, premendo <span
class="keystroke">invio</span> si ottiene un ritorno a capo e una nuova linea,
`\r\n`.) Il metodo `trim` elimina `\n` o `\r\n`, risulta solo `5`.

Il [`parse` metodo su stringhe][parse]<!-- ignore --> converte una stringa in
un altro tipo. Qui, lo usiamo per convertirlo da una stringa a un numero. Dobbiamo
dire a Rust il tipo di numero esatto che vogliamo usando `let guess: u32`. I due punti (`:`) 
dopo `guess` dicono a Rust che annoteremo il tipo di variabile. Rust ha alcuni
tipi di numeri predefiniti; l'`u32` qui visto è un intero senza segno a 32 bit.
È una buona scelta predefinita per un piccolo numero positivo. Imparerai a conoscere
altri tipi di numeri nel [Capitolo 3][interi]<!-- ignore -->.

Inoltre, l'annotazione `u32` in questo programma di esempio e il confronto
con `secret_number` significa che Rust dedurrà che `secret_number` dovrebbe essere un
`u32` pure. Quindi ora il confronto sarà tra due valori dello stesso
tipo!

Il metodo `parse` funzionerà solo su caratteri che possono logicamente essere convertiti
in numeri e quindi può facilmente causare errori. Se, per esempio, la stringa
contenesse `A👍%`, non ci sarebbe modo di convertire quello in un numero. Poiché potrebbe
fallire, il metodo `parse` restituisce un `Result` tipo, allo stesso modo in cui fa il
metodo `read_line` (discusso precedentemente in [“Gestire il potenziale fallimento con
`Result`”](#gestire-il-potenziale-fallimento-con-result)<!-- ignore-->). Tratteremo
questo `Result` nello stesso modo usando di nuovo il metodo `expect`. Se `parse`
restituisce una variante `Err` `Result` perché non è riuscito a creare un numero dalla
stringa, la chiamata `expect` farà crashare il gioco e stamperà il messaggio che gli diamo.
Se `parse` può convertire con successo la stringa in un numero, restituirà la
variante `Ok` di `Result`, e `expect` restituirà il numero che vogliamo dal valore di `Ok`.

Vediamo ora di eseguire il programma:

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
Per favore, inserisci il tuo suggerimento.
  76
Hai suggerito: 76
Troppo grande!
```

Bene! Anche se sono stati aggiunti spazi prima del suggerimento, il programma ha comunque capito
che l'utente ha suggerito 76. Esegui il programma più volte per verificare il diverso comportamento con diversi tipi di input: indovina il numero correttamente,
indovina un numero che è troppo alto, e indovina un numero che è troppo basso.

Abbiamo la maggior parte del gioco funzionante ora, ma l'utente può fare solo una supposizione.
Cambiare ciò aggiungendo un ciclo!

## Consente più suggerimenti con il ciclo

La parola chiave `loop` crea un ciclo infinito. Aggiungeremo un ciclo per dare agli utenti
più possibilità di indovinare il numero:

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/no-listing-04-looping/src/main.rs:here}}
```

Come puoi vedere, abbiamo spostato tutto dal prompt di inserimento del suggerimento in avanti in
un ciclo. Assicurati di indentare le righe all'interno del ciclo di altri quattro spazi ciascuna
ed eseguire nuovamente il programma. Il programma ora chiederà un altro suggerimento per sempre,
che in realtà introduce un nuovo problema. Non sembra che l'utente possa smettere!

L'utente potrebbe sempre interrompere il programma usando la scorciatoia da tastiera
<span class="keystroke">ctrl-c</span>. Ma c'è un altro modo per sfuggire a questo
mostro insaziabile, come menzionato nella discussione `parse` in [“Confronto del
supposizione con il numero segreto”](#confronto-del-supposizione-con-il-numero-segreto)<!-- ignore -->: 
se l'utente inserisce una risposta non numerica, il programma si bloccherà. Possiamo
approfittare di ciò per consentire all'utente di uscire, come mostrato qui:

<!-- manual-regeneration
cd listings/ch02-guessing-game-tutorial/no-listing-04-looping/
cargo run
(supposizione troppo piccola)
(supposizione troppo grande)
(supposizione corretta)
esci
-->

```console
$ cargo run
   Compiling guessing_game v0.1.0 (file:///projects/guessing_game)
    Finished dev [unoptimized + debuginfo] target(s) in 1.50s
     Running `target/debug/guessing_game`
Indovina il numero!
Il numero segreto è: 59
Per favore, inserisci il tuo suggerimento.
45
Hai suggerito: 45
Troppo piccolo!
Per favore, inserisci il tuo suggerimento.
60
Hai suggerito: 60
Troppo grande!
Per favore, inserisci il tuo suggerimento.
59
Hai suggerito: 59
Hai vinto!
Per favore, inserisci il tuo suggerimento.
esci
thread 'main' panicked at 'Per favore, inserisci un numero!: ParseIntError { kind: InvalidDigit }', src/main.rs:28:47
note: run with `RUST_BACKTRACE=1` environment variable to display a backtrace
```

Digita `esci` per fermare il gioco, ma come noterai, così farà entrare qualsiasi
altro input non numerico. Questo è subottimale, per non dire altro; vogliamo che il gioco
si fermi anche quando viene indovinato il numero corretto.

### Uscire dopo un suggerimento corretto

Programmiamo il gioco per uscire quando l'utente vince aggiungendo un'istruzione `break`:

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/no-listing-05-quitting/src/main.rs:here}}
```

Aggiungendo la riga `break` dopo `Hai vinto!` fa uscire il programma dal ciclo quando
l'utente indovina correttamente il numero segreto. Uscire dal ciclo significa anche
uscire dal programma, perché il ciclo è l'ultima parte del `main`.

### Gestione dell'input non valido

Per affinare ulteriormente il comportamento del gioco, invece di far crashare il programma quando
l'utente inserisce un non-numero, rendiamo il gioco ignorante a un non-numero in modo che
l'utente può continuare a indovinare. Possiamo farlo modificando la riga dove `guess`
viene convertito da una `String` a un `u32`, come mostrato nella lista 2-5.

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-05/src/main.rs:here}}
```

<span class="caption">Listato 2-5: Ignorare un suggerimento non numerico e chiedere un altro suggerimento invece di far crashare il programma</span>

Passiamo da una chiamata `expect` a un'espressione `match` per passare da crash su un errore a gestione dell'errore. Ricorda che `parse` ritorna un `Result`
tipo e `Result` è un Enum che ha le varianti `Ok` e `Err`. Stiamo usando un'espressione `match` qui, come abbiamo fatto con il `Ordering` risultato del metodo `cmp`.

Se `parse` è in grado di trasformare correttamente la stringa in un numero, ritornerà un valore `Ok` che contiene il numero risultante. Quel valore `Ok` corrisponderà al pattern del primo braccio, e l'espressione `match` ritornerà semplicemente il valore `num` che `parse` ha prodotto e messo all'interno del valore `Ok`. Quel numero finirà proprio dove lo vogliamo nella nuova variabile `guess` che stiamo creando. 
Se `parse` *non* è in grado di trasformare la stringa in un numero, restituirà un
valore `Err` che contiene ulteriori informazioni sull'errore. Il valore `Err`
non corrisponde al pattern `Ok(num)` nella prima armatura di `match`, ma corrisponde
al pattern `Err(_)` nella seconda armatura. L'underscore, `_`, è un
valore universale; in questo esempio, stiamo dicendo che vogliamo che corrisponda a tutti i valori `Err`,
indipendentemente dalle informazioni che contengono. Quindi il programma eseguirà
il codice della seconda armatura, `continue`, che dice al programma di passare alla
prossima iterazione del `loop` e chiedere un altro indovinello. Quindi, in pratica, il
programma ignora tutti gli errori che `parse` potrebbe incontrare!

Ora tutto nel programma dovrebbe funzionare come previsto. Proviamolo:

<!-- manual-regeneration
cd listings/ch02-guessing-game-tutorial/listing-02-05/
cargo run
(troppo piccolo)
(troppo grande)
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
Inserisci il tuo indovinello.
10
Hai indovinato: 10
Troppo piccolo!
Inserisci il tuo indovinello.
99
Hai indovinato: 99
Troppo grande!
Inserisci il tuo indovinello.
foo
Inserisci il tuo indovinello.
61
Hai indovinato: 61
Hai vinto!
```

Favoloso! Con un piccolissimo ritocco finale, completeremo il gioco dell'indovinello. Ricorda
che il programma sta ancora stampando il numero segreto. Funzionava bene per
i test, ma rovina il gioco. Eliminiamo il `println!` che stampa il
numero segreto. La Lista 2-6 mostra il codice finale.

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch02-guessing-game-tutorial/listing-02-06/src/main.rs}}
```

<span class="caption">Lista 2-6: Codice completo del gioco dell'indovinello</span>

A questo punto, hai costruito con successo il gioco dell'indovinello. Congratulazioni!

## Riepilogo

Questo progetto è stato un modo pratico per introdurti a molti nuovi concetti di Rust:
`let`, `match`, funzioni, l'uso di crate esterne e altro ancora. Nei prossimi
capitoli, apprenderai questi concetti in modo più dettagliato. Il Capitolo 3
tratta concetti presenti nella maggior parte dei linguaggi di programmazione, come variabili, tipi di dati e funzioni, e mostra come utilizzarli in Rust. Il Capitolo 4 esplora
l'ownership, una caratteristica che distingue Rust da altri linguaggi. Il Capitolo 5
discute le struct e la sintassi dei metodi, e il Capitolo 6 spiega come funzionano gli enum.

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
