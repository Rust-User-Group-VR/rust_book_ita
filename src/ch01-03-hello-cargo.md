## Hello, Cargo!

Cargo è il sistema di build e il gestore di pacchetti di Rust. La maggior parte dei Rustaceans utilizza questo strumento per gestire i loro progetti in Rust perché Cargo gestisce molte attività per te, come compilare il tuo codice, scaricare le librerie da cui dipende il tuo codice e costruire quelle librerie. (Chiamiamo le librerie di cui il tuo codice ha bisogno *dipendenze*.)

I programmi Rust più semplici, come quello che abbiamo scritto finora, non hanno dipendenze. Se avessimo costruito il progetto “Hello, world!” con Cargo, avrebbe utilizzato solo la parte di Cargo che gestisce la compilazione del codice. Man mano che scrivi programmi Rust più complessi, aggiungerai dipendenze, e se inizi un progetto utilizzando Cargo, aggiungere dipendenze sarà molto più facile.

Poiché la stragrande maggioranza dei progetti Rust utilizza Cargo, il resto di questo libro assume che tu stia usando anche Cargo. Cargo viene installato con Rust se hai utilizzato gli installer ufficiali discussi nella sezione [“Installazione”][installation]<!-- ignore -->. Se hai installato Rust attraverso altri mezzi, verifica se Cargo è installato inserendo quanto segue nel tuo terminale:

```console
$ cargo --version
```

Se vedi un numero di versione, lo hai! Se vedi un errore, come `command not found`, consulta la documentazione per il tuo metodo di installazione per determinare come installare Cargo separatamente.

### Creare un progetto con Cargo

Creiamo un nuovo progetto utilizzando Cargo e vediamo come differisce dal nostro progetto originale “Hello, world!”. Torna alla tua directory *projects* (o ovunque tu abbia deciso di memorizzare il tuo codice). Poi, su qualsiasi sistema operativo, esegui quanto segue:

```console
$ cargo new hello_cargo
$ cd hello_cargo
```

Il primo comando crea una nuova directory e un progetto chiamato *hello_cargo*. Abbiamo chiamato il nostro progetto *hello_cargo*, e Cargo crea i suoi file in una directory con lo stesso nome.

Entra nella directory *hello_cargo* ed elenca i file. Vedrai che Cargo ha generato due file e una directory per noi: un file *Cargo.toml* e una directory *src* con un file *main.rs* all'interno.

Ha anche inizializzato un nuovo repository Git insieme a un file *.gitignore*. I file Git non verranno generati se esegui `cargo new` all'interno di un repository Git esistente; puoi sovrascrivere questo comportamento utilizzando `cargo new --vcs=git`.

> Nota: Git è un sistema di controllo delle versioni comune. Puoi cambiare `cargo new` per utilizzare un diverso sistema di controllo delle versioni o nessun sistema di controllo delle versioni utilizzando il flag `--vcs`. Esegui `cargo new --help` per vedere le opzioni disponibili.

Apri *Cargo.toml* nel tuo editor di testo preferito. Dovrebbe sembrare simile al codice nel Listing 1-2.

<Listing number="1-2" file-name="Cargo.toml" caption="Contenuto di *Cargo.toml* generato da `cargo new`">

```toml
[package]
name = "hello_cargo"
version = "0.1.0"
edition = "2021"

# Vedi altri chiavi e le loro definizioni su https://doc.rust-lang.org/cargo/reference/manifest.html

[dependencies]
```

</Listing>

Questo file è nel formato [*TOML*][toml]<!-- ignore --> (*Tom’s Obvious, Minimal Language*), che è il formato di configurazione di Cargo.

La prima riga, `[package]`, è un'intestazione di sezione che indica che le dichiarazioni successive stanno configurando un pacchetto. Man mano che aggiungiamo più informazioni a questo file, aggiungeremo altre sezioni.

Le tre righe successive impostano le informazioni di configurazione di cui Cargo ha bisogno per compilare il tuo programma: il nome, la versione e l'edizione di Rust da utilizzare. Parleremo della chiave `edition` nell'[Appendice E][appendix-e]<!-- ignore -->.

L'ultima riga, `[dependencies]`, è l'inizio di una sezione per elencare tutte le dipendenze del tuo progetto. In Rust, i pacchetti di codice sono indicati come *crates*. Non avremo bisogno di altri crates per questo progetto, ma li useremo nel primo progetto nel Capitolo 2, quindi useremo questa sezione delle dipendenze allora.

Ora apri *src/main.rs* e dai un'occhiata:

<span class="filename">Nome del file: src/main.rs</span>

```rust
fn main() {
    println!("Hello, world!");
}
```

Cargo ha generato un programma “Hello, world!” per te, proprio come quello che abbiamo scritto nel Listing 1-1! Finora, le differenze tra il nostro progetto e il progetto generato da Cargo sono che Cargo ha inserito il codice nella directory *src* e abbiamo un file di configurazione *Cargo.toml* nella directory principale.

Cargo si aspetta che i tuoi file sorgente si trovino all'interno della directory *src*. La directory del progetto di livello superiore è solo per i file README, le informazioni sulla licenza, i file di configurazione e qualsiasi altra cosa non correlata al tuo codice. Utilizzare Cargo ti aiuta a organizzare i tuoi progetti. C'è un posto per tutto e tutto è al suo posto.

Se hai iniziato un progetto che non utilizza Cargo, come abbiamo fatto con il progetto “Hello, world!”, puoi convertirlo in un progetto che utilizza Cargo. Sposta il codice del progetto nella directory *src* e crea un file *Cargo.toml* appropriato. Un modo semplice per ottenere quel file *Cargo.toml* è eseguire `cargo init`, che lo creerà automaticamente per te.

### Compilare ed eseguire un progetto Cargo

Ora vediamo cosa è diverso quando costruiamo ed eseguiamo il programma “Hello, world!” con Cargo! Dalla tua directory *hello_cargo*, costruisci il tuo progetto inserendo il seguente comando:

```console
$ cargo build
   Compiling hello_cargo v0.1.0 (file:///projects/hello_cargo)
    Finished dev [unoptimized + debuginfo] target(s) in 2.85 secs
```

Questo comando crea un file eseguibile in *target/debug/hello_cargo* (o *target\debug\hello_cargo.exe* su Windows) invece che nella tua directory corrente. Poiché la build predefinita è una build di debug, Cargo mette il binario in una directory chiamata *debug*. Puoi eseguire l'eseguibile con questo comando:

```console
$ ./target/debug/hello_cargo # o .\target\debug\hello_cargo.exe su Windows
Hello, world!
```

Se tutto va bene, `Hello, world!` dovrebbe stampare nel terminale. Eseguire `cargo build` per la prima volta causa anche la creazione da parte di Cargo di un nuovo file a livello superiore: *Cargo.lock*. Questo file tiene traccia delle versioni esatte delle dipendenze nel tuo progetto. Questo progetto non ha dipendenze, quindi il file è un po' scarno. Non sarà mai necessario modificare manualmente questo file; Cargo gestisce i suoi contenuti per te.

Abbiamo appena costruito un progetto con `cargo build` e lo abbiamo eseguito con `./target/debug/hello_cargo`, ma possiamo anche usare `cargo run` per compilare il codice e poi eseguire l'eseguibile risultante tutto in un comando:

```console
$ cargo run
    Finished dev [unoptimized + debuginfo] target(s) in 0.0 secs
     Running `target/debug/hello_cargo`
Hello, world!
```

Usare `cargo run` è più conveniente che dover ricordare di eseguire `cargo build` e poi usare l'intero percorso al binario, quindi la maggior parte degli sviluppatori utilizza `cargo run`.

Nota che questa volta non abbiamo visto un output che indica che Cargo stava compilando `hello_cargo`. Cargo ha capito che i file non erano cambiati, quindi non ha ricompilato ma ha solo eseguito il binario. Se avevi modificato il tuo codice sorgente, Cargo avrebbe ricostruito il progetto prima di eseguirlo e avresti visto questo output:

```console
$ cargo run
   Compiling hello_cargo v0.1.0 (file:///projects/hello_cargo)
    Finished dev [unoptimized + debuginfo] target(s) in 0.33 secs
     Running `target/debug/hello_cargo`
Hello, world!
```

Cargo fornisce anche un comando chiamato `cargo check`. Questo comando controlla rapidamente il tuo codice per assicurarsi che compili ma non produce un eseguibile:

```console
$ cargo check
   Checking hello_cargo v0.1.0 (file:///projects/hello_cargo)
    Finished dev [unoptimized + debuginfo] target(s) in 0.32 secs
```

Perché non vorresti un eseguibile? Spesso, `cargo check` è molto più veloce di `cargo build` perché salta il passaggio di produzione di un eseguibile. Se stai controllando continuamente il tuo lavoro mentre scrivi il codice, usare `cargo check` accelererà il processo di farti sapere se il tuo progetto è ancora compilabile! Per questo motivo, molti Rustacean eseguono `cargo check` periodicamente mentre scrivono il loro programma per assicurarsi che compili. Poi eseguono `cargo build` quando sono pronti per utilizzare l'eseguibile.

Riassumiamo ciò che abbiamo imparato finora su Cargo:

* Possiamo creare un progetto usando `cargo new`.
* Possiamo costruire un progetto usando `cargo build`.
* Possiamo costruire ed eseguire un progetto in un solo passaggio usando `cargo run`.
* Possiamo costruire un progetto senza produrre un binario per controllare gli errori usando `cargo check`.
* Invece di salvare il risultato della build nella stessa directory del nostro codice, Cargo lo memorizza nella directory *target/debug*.

Un ulteriore vantaggio dell'utilizzare Cargo è che i comandi sono gli stessi indipendentemente dal sistema operativo su cui stai lavorando. Quindi, a questo punto, non forniremo più istruzioni specifiche per Linux e macOS rispetto a Windows.

### Compilare per il rilascio

Quando il tuo progetto è finalmente pronto per il rilascio, puoi usare `cargo build --release` per compilarlo con ottimizzazioni. Questo comando creerà un eseguibile in *target/release* invece di *target/debug*. Le ottimizzazioni fanno sì che il tuo codice Rust venga eseguito più velocemente, ma accenderle allunga il tempo necessario per compilare il tuo programma. Questo è il motivo per cui ci sono due profili diversi: uno per lo sviluppo, quando vuoi ricostruire rapidamente e spesso, e un altro per costruire il programma finale che darai a un utente che non verrà ricostruito ripetutamente e che verrà eseguito il più rapidamente possibile. Se stai facendo benchmark sui tempi di esecuzione del tuo codice, assicurati di eseguire `cargo build --release` e fare benchmark con l'eseguibile in *target/release*.

### Cargo come convenzione

Con progetti semplici, Cargo non offre molto valore rispetto all'utilizzo di `rustc`, ma dimostrerà il suo valore man mano che i tuoi programmi diventeranno più intricati. Una volta che i programmi crescono in file multipli o necessitano di una dipendenza, è molto più facile lasciare che Cargo coordini la build.

Sebbene il progetto `hello_cargo` sia semplice, ora utilizza gran parte degli strumenti reali che utilizzerai nel resto della tua carriera in Rust. Infatti, per lavorare su qualsiasi progetto esistente, puoi usare i seguenti comandi per controllare il codice usando Git, cambiare nella directory di quel progetto e costruire:

```console
$ git clone example.org/someproject
$ cd someproject
$ cargo build
```

Per ulteriori informazioni su Cargo, consulta [la sua documentazione][cargo].

## Sommario

Sei già sulla buona strada nel tuo viaggio con Rust! In questo capitolo, hai imparato come:

* Installare l'ultima versione stabile di Rust utilizzando `rustup`
* Aggiornare a una versione più recente di Rust
* Aprire la documentazione installata localmente
* Scrivere ed eseguire un programma “Hello, world!” utilizzando `rustc` direttamente
* Creare ed eseguire un nuovo progetto utilizzando le convenzioni di Cargo

Questo è un ottimo momento per costruire un programma più sostanziale per abituarti a leggere e scrivere codice Rust. Quindi, nel Capitolo 2, costruiremo un programma di gioco di indovinelli. Se preferisci iniziare imparando come funzionano i concetti di programmazione comuni in Rust, vedi il Capitolo 3 e poi torna al Capitolo 2.

[installation]: ch01-01-installation.html#installation
[toml]: https://toml.io
[appendix-e]: appendix-05-editions.html
[cargo]: https://doc.rust-lang.org/cargo/
