## Ciao, Cargo!

Cargo è il sistema di build e il gestore di pacchetti di Rust. La maggior parte dei Rustaceans utilizza questo strumento per gestire i propri progetti Rust perché Cargo gestisce molte attività per te, come la compilazione del tuo codice, il download delle librerie da cui dipende il tuo codice e la compilazione di queste librerie. (Chiamiamo le librerie di cui il tuo codice ha bisogno *dipendenze*.)

I programmi Rust più semplici, come quello che abbiamo scritto finora, non hanno dipendenze. Se avessimo costruito il progetto "Hello, world!" con Cargo, avrebbe usato solo la parte di Cargo che gestisce la compilazione del tuo codice. Man mano che scrivi programmi Rust più complessi, aggiungerai dipendenze, e se inizi un progetto usando Cargo, aggiungere dipendenze sarà molto più facile.

Poiché la stragrande maggioranza dei progetti Rust utilizza Cargo, il resto di questo libro presuppone che tu stia usando Cargo. Cargo viene installato con Rust se hai utilizzato gli installer ufficiali discussi nella sezione [“Installazione”][installation]<!-- ignore -->. Se hai installato Rust tramite altri metodi, verifica se Cargo è installato inserendo il seguente comando nel tuo terminale:

```console
$ cargo --version
```

Se visualizzi un numero di versione, significa che è installato! Se visualizzi un errore, come `command not found`, consulta la documentazione per il metodo di installazione utilizzato per determinare come installare Cargo separatamente.

### Creare un Progetto con Cargo

Creiamo un nuovo progetto usando Cargo e vediamo come differisce dal nostro progetto originale "Hello, world!". Torna alla tua directory *projects* (o ovunque tu abbia deciso di archiviare il tuo codice). Quindi, su qualsiasi sistema operativo, esegui il seguente comando:

```console
$ cargo new hello_cargo
$ cd hello_cargo
```

Il primo comando crea una nuova directory e progetto chiamato *hello_cargo*. Abbiamo chiamato il nostro progetto *hello_cargo*, e Cargo crea i suoi file in una directory con lo stesso nome.

Entra nella directory *hello_cargo* e elenca i file. Vedrai che Cargo ha generato due file e una directory per noi: un file *Cargo.toml* e una directory *src* con un file *main.rs* all'interno.

Ha anche inizializzato un nuovo repository Git assieme a un file *.gitignore*. I file Git non verranno generati se esegui `cargo new` all'interno di un repository Git esistente; puoi ignorare questo comportamento usando `cargo new --vcs=git`.

> Nota: Git è un sistema di controllo di versione comune. Puoi modificare `cargo new` per utilizzare un sistema di controllo di versione diverso o nessun sistema di controllo di versione utilizzando il flag `--vcs`. Esegui `cargo new --help` per vedere le opzioni disponibili.

Apri *Cargo.toml* nel tuo editor di testo preferito. Dovrebbe apparire simile al codice nel Listing 1-2.

<Listing number="1-2" file-name="Cargo.toml" caption="Contenuto di *Cargo.toml* generato da `cargo new`">

```toml
[package]
name = "hello_cargo"
version = "0.1.0"
edition = "2021"

# Guarda più chiavi e le loro definizioni su https://doc.rust-lang.org/cargo/reference/manifest.html

[dependencies]
```

</Listing>

Questo file è nel formato [*TOML*][toml]<!-- ignore --> (*Tom’s Obvious, Minimal Language*), che è il formato di configurazione di Cargo.

La prima riga, `[package]`, è un'intestazione di sezione che indica che le dichiarazioni seguenti configurano un pacchetto. Man mano che aggiungiamo più informazioni a questo file, aggiungeremo altre sezioni.

Le successive tre righe impostano le informazioni di configurazione di cui Cargo ha bisogno per compilare il tuo programma: il nome, la versione e l'edizione di Rust da utilizzare. Parleremo della chiave `edition` nell'[Appendice E][appendix-e]<!-- ignore -->.

L'ultima riga, `[dependencies]`, è l'inizio di una sezione in cui elencare eventuali dipendenze del tuo progetto. In Rust, i pacchetti di codice sono denominati *crates*. Non avremo bisogno di altri crates per questo progetto, ma ne avremo bisogno nel primo progetto del Capitolo 2, quindi utilizzeremo questa sezione delle dipendenze allora.

Ora apri *src/main.rs* e dai un'occhiata:

<span class="filename">Nome del file: src/main.rs</span>

```rust
fn main() {
    println!("Hello, world!");
}
```

Cargo ha generato un programma “Hello, world!” per te, proprio come quello che abbiamo scritto nel Listing 1-1! Fino ad ora, le differenze tra il nostro progetto e il progetto generato da Cargo sono che Cargo ha inserito il codice nella directory *src* e abbiamo un file di configurazione *Cargo.toml* nella directory principale.

Cargo si aspetta che i tuoi file sorgente risiedano all'interno della directory *src*. La directory del progetto di livello superiore è solo per i file README, le informazioni sulla licenza, i file di configurazione e tutto ciò che non è correlato al tuo codice. Usare Cargo ti aiuta a organizzare i tuoi progetti. C'è un posto per tutto, e tutto è al suo posto.

Se hai iniziato un progetto che non utilizza Cargo, come abbiamo fatto con il progetto "Hello, world!", puoi convertirlo in un progetto che utilizza Cargo. Sposta il codice del progetto nella directory *src* e crea un file *Cargo.toml* appropriato.

### Compilare ed Eseguire un Progetto Cargo

Ora vediamo cosa cambia quando compiliamo ed eseguiamo il programma “Hello, world!” con Cargo! Dalla tua directory *hello_cargo*, compila il tuo progetto inserendo il seguente comando:

```console
$ cargo build
   Compiling hello_cargo v0.1.0 (file:///projects/hello_cargo)
    Finished dev [unoptimized + debuginfo] target(s) in 2.85 secs
```

Questo comando crea un file eseguibile in *target/debug/hello_cargo* (o *target\debug\hello_cargo.exe* su Windows) anziché nella tua directory corrente. Poiché la build predefinita è una build di debug, Cargo mette il binario in una directory chiamata *debug*. Puoi eseguire l'eseguibile con questo comando:

```console
$ ./target/debug/hello_cargo # o .\target\debug\hello_cargo.exe su Windows
Hello, world!
```

Se tutto va bene, `Hello, world!` dovrebbe apparire nel terminale. L'esecuzione di `cargo build` per la prima volta fa sì che Cargo crei anche un nuovo file a livello principale: *Cargo.lock*. Questo file tiene traccia delle versioni esatte delle dipendenze nel tuo progetto. Questo progetto non ha dipendenze, quindi il file è un po' scarso. Non dovrai mai modificare manualmente questo file; Cargo gestisce il suo contenuto per te.

Abbiamo appena compilato un progetto con `cargo build` e l'abbiamo eseguito con `./target/debug/hello_cargo`, ma possiamo anche utilizzare `cargo run` per compilare il codice e poi eseguire l'eseguibile risultante tutto in un solo comando:

```console
$ cargo run
    Finished dev [unoptimized + debuginfo] target(s) in 0.0 secs
     Running `target/debug/hello_cargo`
Hello, world!
```

Utilizzare `cargo run` è più conveniente che dover ricordare di eseguire `cargo build` e poi utilizzare l'intero percorso del binario, quindi la maggior parte degli sviluppatori utilizza `cargo run`.

Nota che questa volta non abbiamo visto un output che indicasse che Cargo stava compilando `hello_cargo`. Cargo ha capito che i file non erano cambiati, quindi non ha ricompilato ma semplicemente ha eseguito il binario. Se avessi modificato il tuo codice sorgente, Cargo avrebbe ricompilato il progetto prima di eseguirlo e avresti visto questo output:

```console
$ cargo run
   Compiling hello_cargo v0.1.0 (file:///projects/hello_cargo)
    Finished dev [unoptimized + debuginfo] target(s) in 0.33 secs
     Running `target/debug/hello_cargo`
Hello, world!
```

Cargo fornisce anche un comando chiamato `cargo check`. Questo comando controlla rapidamente il tuo codice per assicurarsi che si compili ma non produce un eseguibile:

```console
$ cargo check
   Checking hello_cargo v0.1.0 (file:///projects/hello_cargo)
    Finished dev [unoptimized + debuginfo] target(s) in 0.32 secs
```

Perché potresti non volere un eseguibile? Spesso, `cargo check` è molto più veloce di `cargo build` perché salta il passaggio di produzione di un eseguibile. Se stai controllando continuamente il tuo lavoro durante la scrittura del codice, utilizzare `cargo check` accelererà il processo di informarti se il tuo progetto si compila ancora! Così, molti Rustaceans eseguono `cargo check` periodicamente mentre scrivono i loro programmi per assicurarsi che si compilino. Quindi eseguono `cargo build` quando sono pronti per utilizzare l'eseguibile.

Ricapiamo cosa abbiamo imparato finora su Cargo:

* Possiamo creare un progetto usando `cargo new`.
* Possiamo costruire un progetto usando `cargo build`.
* Possiamo costruire ed eseguire un progetto in un solo passaggio usando `cargo run`.
* Possiamo costruire un progetto senza produrre un binario per controllare gli errori usando `cargo check`.
* Invece di salvare il risultato della build nella stessa directory del nostro codice, Cargo lo memorizza nella directory *target/debug*.

Un ulteriore vantaggio di utilizzare Cargo è che i comandi sono gli stessi indipendentemente dal sistema operativo su cui stai lavorando. Quindi, a questo punto, non forniremo più istruzioni specifiche per Linux e macOS rispetto a Windows.

### Compilare per il Rilascio

Quando il tuo progetto è finalmente pronto per il rilascio, puoi utilizzare `cargo build --release` per compilarlo con ottimizzazioni. Questo comando creerà un eseguibile in *target/release* invece di *target/debug*. Le ottimizzazioni fanno eseguire il codice Rust più velocemente, ma attivarle allunga il tempo necessario per compilare il tuo programma. Questo è il motivo per cui ci sono due profili differenti: uno per lo sviluppo, quando vuoi ricostruire rapidamente e spesso, e un altro per costruire il programma finale che darai a un utente che non verrà ricostruito ripetutamente e che verrà eseguito il più velocemente possibile. Se stai facendo benchmarking del tempo di esecuzione del tuo codice, assicurati di eseguire `cargo build --release` e fare il benchmarking con l'eseguibile in *target/release*.

### Cargo come Convenzione

Con progetti semplici, Cargo non fornisce molto valore rispetto a solo utilizzare `rustc`, ma dimostrerà il suo valore man mano che i tuoi programmi diventeranno più intricati. Una volta che i programmi crescono a più file o hanno bisogno di una dipendenza, è molto più facile lasciare che Cargo coordini la build.

Anche se il progetto `hello_cargo` è semplice, ora utilizza gran parte degli strumenti reali che utilizzerai nel resto della tua carriera con Rust. Infatti, per lavorare su eventuali progetti esistenti, puoi utilizzare i seguenti comandi per controllare il codice usando Git, passare alla directory di quel progetto e costruirlo:

```console
$ git clone example.org/someproject
$ cd someproject
$ cargo build
```

Per ulteriori informazioni su Cargo, consulta [la sua documentazione][cargo].

## Riepilogo

Hai già iniziato alla grande il tuo viaggio con Rust! In questo capitolo, hai imparato a:

* Installare l'ultima versione stabile di Rust usando `rustup`
* Aggiornare a una nuova versione di Rust
* Aprire la documentazione installata localmente
* Scrivere ed eseguire un programma “Hello, world!” utilizzando `rustc` direttamente
* Creare ed eseguire un nuovo progetto usando le convenzioni di Cargo

Questo è un ottimo momento per costruire un programma più sostanziale per abituarti a leggere e scrivere codice Rust. Quindi, nel Capitolo 2, costruiremo un programma di gioco di indovinelli. Se preferisci iniziare imparando come funzionano i concetti di programmazione comuni in Rust, consulta il Capitolo 3 e poi torna al Capitolo 2.

[installation]: ch01-01-installation.html#installation
[toml]: https://toml.io
[appendix-e]: appendix-05-editions.html
[cargo]: https://doc.rust-lang.org/cargo/
