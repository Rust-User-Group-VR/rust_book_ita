## Ciao, Cargo!

Cargo è il sistema di compilazione e il gestore dei pacchetti di Rust. La maggior parte dei Rustacei usa questo strumento
per gestire i loro progetti Rust perché Cargo gestisce molti compiti per te,
come la compilazione del tuo codice, il download delle librerie di cui il tuo codice dipende, e
la compilazione di tali librerie. (Chiamiamo le librerie di cui il tuo codice ha bisogno 
*dipendenze*.)

I programmi Rust più semplici, come quello che abbiamo scritto finora, non hanno alcuna
dipendenza. Se avessimo costruito il progetto "Ciao, mondo!" con Cargo, avrebbe
utilizzato solo la parte di Cargo che gestisce la compilazione del tuo codice. Man mano che scrivi programmi Rust più complessi, aggiungerai delle dipendenze e se inizi un progetto 
utilizzando Cargo, aggiungere dipendenze sarà molto più facile da fare.

Poiché la stragrande maggioranza dei progetti Rust utilizza Cargo, il resto di questo libro
presume che tu stia usando anche Cargo. Cargo viene installato con Rust se si utilizza l'installatore ufficiale discussa nella 
sezione ["Installazione"][installation]<!-- ignore -->. Se hai installato Rust
attraverso qualche altro mezzo, controlla se Cargo è installato inserendo il
seguente nel tuo terminale:

```console
$ cargo --version
```

Se vedi un numero di versione, ce l'hai! Se vedi un errore, come `command
not found`, guarda la documentazione del tuo metodo di installazione per
determinare come installare Cargo separatamente.

### Creare un Progetto con Cargo

Creiamo un nuovo progetto usando Cargo e vediamo come differisce dal nostro
progetto "Ciao, mondo!" originale. Torna alla tua directory dei *progetti*
(o ovunque tu abbia deciso di conservare il tuo codice). Poi, su qualsiasi sistema operativo,
esegui il seguente comando:

```console
$ cargo new hello_cargo
$ cd hello_cargo
```

Il primo comando crea una nuova directory e un progetto chiamato *hello_cargo*.
Abbiamo chiamato il nostro progetto *hello_cargo*, and Cargo crea i suoi file in una
directory con lo stesso nome.

Entra nella directory *hello_cargo* e elenca i file. Vedrai che Cargo
ha generato due file e una directory per noi: un file *Cargo.toml* e una
directory *src* con un file *main.rs* all'interno.

Ha anche inizializzato un nuovo repository Git insieme a un file *.gitignore*.
I file Git non saranno generati se si esegue `cargo new` all'interno di un repository Git
esistente; puoi sovrascrivere questo comportamento usando `cargo new --vcs=git`.

> Nota: Git è un comune sistema di controllo delle versioni. Puoi cambiare `cargo new` a
> utilizzare un diverso sistema di controllo delle versioni o nessun sistema di controllo delle versioni utilizzando
> il flag `--vcs`. Esegui `cargo new --help` per vedere le opzioni disponibili.

Apri *Cargo.toml* nel tuo editor di testo preferito. Dovrebbe apparire simile al
codice in Lista 1-2.

<span class="filename">Nome del file: Cargo.toml</span>

```toml
[package]
name = "hello_cargo"
version = "0.1.0"
edition = "2021"

# See more keys and their definitions at https://doc.rust-lang.org/cargo/reference/manifest.html

[dependencies]
```

<span class="caption">Lista 1-2: Contenuto di *Cargo.toml* generato da `cargo
new`</span>

Questo file è nel formato [*TOML*][toml]<!-- ignore --> (*Tom’s Obvious, Minimal
Language*), che è il formato di configurazione di Cargo.

La prima riga, `[package]`, è un'intestazione di sezione che indica che le
seguenti affermazioni stanno configurando un pacchetto. Man mano che aggiungiamo più informazioni a
questo file, aggiungeremo altre sezioni.

Le seguenti tre righe impostano le informazioni di configurazione di cui Cargo ha bisogno per compilare
il tuo programma: il nome, la versione, e l'edizione di Rust da utilizzare. Parleremo
di chiave `edition` in [Appendice E][appendix-e]<!-- ignore -->.

L'ultima riga, `[dependencies]`, è l'inizio di una sezione per elencare qualsiasi
delle dipendenze del tuo progetto. In Rust, i pacchetti di codice sono riferiti come
*crates*. Non avremo bisogno di altre crates per questo progetto, ma lo faremo nel
primo progetto nel Capitolo 2, quindi utilizzeremo questa sezione delle dipendenze allora.

Ora apri *src/main.rs* e dai un'occhiata:

<span class="filename">Nome del file: src/main.rs</span>

```rust
fn main() {
    println!("Hello, world!");
}
```

Cargo ha generato un programma "Ciao, mondo!" per te, proprio come quello che noi
abbiamo scritto nella Lista 1-1! Finora, le differenze tra il nostro progetto e il
progetto generato da Cargo sono che Cargo ha posizionato il codice nella directory *src*
e abbiamo un file di configurazione *Cargo.toml* nella directory principale.

Cargo si aspetta che i tuoi file sorgente si trovino dentro la directory *src*. La
directory del progetto di livello superiore è solo per i file README, le informazioni sulla licenza,
i file di configurazione, e qualsiasi altra cosa non relativa al tuo codice. Usare Cargo
ti aiuta a organizzare i tuoi progetti. C'è un posto per tutto, e
tutto è al suo posto.

Se hai iniziato un progetto che non utilizza Cargo, come abbiamo fatto con il progetto "Ciao,
mondo!", puoi convertirlo in un progetto che utilizza Cargo. Sposta il
codice del progetto nella directory *src* e crea un appropriato file *Cargo.toml*.

### Costruire e Eseguire un Progetto Cargo

Ora vediamo cosa cambia quando costruiamo ed eseguiamo il programma "Ciao, mondo!"
con Cargo! Dalla tua directory *hello_cargo*, costruisci il tuo progetto inserendo il 
seguente comando:

```console
$ cargo build
   Compiling hello_cargo v0.1.0 (file:///projects/hello_cargo)
    Finished dev [unoptimized + debuginfo] target(s) in 2.85 secs
```

Questo comando crea un file eseguibile in *target/debug/hello_cargo* (o
*target\debug\hello_cargo.exe* su Windows) piuttosto che nella tua attuale
directory. Poiché la build predefinita è una build di debug, Cargo mette il eseguibile in 
una directory chiamata *debug*. Puoi eseguire il programma con il seguente comando:

```console
$ ./target/debug/hello_cargo # or .\target\debug\hello_cargo.exe on Windows
Hello, world!
```

Se tutto va bene, `Ciao, mondo!` dovrebbe stamparsi sul terminale. Eseguendo `cargo
build` per la prima volta causa anche a Cargo di creare un nuovo file al livello principale: *Cargo.lock*. Questo file tiene traccia delle versioni esatte delle
dipendenze nel tuo progetto. Questo progetto non ha dipendenze, quindi il
file è un po' scarso. Non avrai mai bisogno di modificare manualmente questo file; Cargo
gestisce il contenuto per te.

Abbiamo appena costruito un progetto con `cargo build` e lo abbiamo eseguito con
`./target/debug/hello_cargo`, ma possiamo anche utilizzare `cargo run` per compilare il
codice e successivamente eseguire il programma risultante tutto con un solo comando:

```console
$ cargo run
    Finished dev [unoptimized + debuginfo] target(s) in 0.0 secs
     Running `target/debug/hello_cargo`
Hello, world!
```

Usare `cargo run` è più comodo che dover ricordare di eseguire `cargo
build` e poi usare l''intero percorso al binario, quindi la maggior parte degli sviluppatori utilizzano `cargo
run`.

Noterai che questa volta non abbiamo visto output indicante che Cargo stava compilando 
`hello_cargo`. Cargo ha dedotto che i file non erano cambiati, quindi non ha
ricostruito, ma ha eseguito solo il programma. Se avessi modificato il tuo codice sorgente, Cargo avrebbe 
ricostruito il progetto prima di eseguirlo, e avresti visto questo
output:

```console
$ cargo run
   Compiling hello_cargo v0.1.0 (file:///projects/hello_cargo)
    Finished dev [unoptimized + debuginfo] target(s) in 0.33 secs
     Running `target/debug/hello_cargo`
Hello, world!
```

Cargo fornisce anche un comando chiamato `cargo check`. Questo comando controlla rapidamente
il tuo codice per assicurarsi che si compili ma non produce un eseguibile:

```console
$ cargo check
   Checking hello_cargo v0.1.0 (file:///projects/hello_cargo)
    Finished dev [unoptimized + debuginfo] target(s) in 0.32 secs
```

Perché non vorresti un eseguibile? Spesso, `cargo check` è molto più veloce di
`cargo build` perché salta il passaggio di produrre un eseguibile. Se stai
continuamente controllando il tuo lavoro mentre scrivi il codice, usando `cargo check` velocizzerà
il processo che ti permette di sapere se il tuo progetto si sta ancora compilando! Pertanto, molti Rustacei eseguono `cargo check` periodicamente mentre scrivono il loro
programma per assicurarsi che si compili. Poi eseguono `cargo build` quando sono
pronti ad utilizzare l'eseguibile.

Ricapitoliamo quello che abbiamo imparato finora su Cargo:

* Possiamo creare un progetto usando `cargo new`.
* Possiamo costruire un progetto usando `cargo build`.
* Possiamo costruire e eseguire un progetto in un solo passaggio usando `cargo run`.
* Possiamo costruire un progetto senza produrre un binario per controllare gli errori usando
  `cargo check`.
* Invece di salvare il risultato della build nella stessa directory del nostro codice,
  Cargo lo memorizza nella directory *target/debug*.

Un vantaggio aggiuntivo dell'uso di Cargo è che i comandi sono gli stessi
indipendentemente dal sistema operativo su cui si sta lavorando. Quindi, a questo punto, non forniremo più istruzioni specifiche per Linux e macOS rispetto a Windows.

### Compilazione per il Rilascio

Quando il tuo progetto è finalmente pronto per il rilascio, puoi usare `cargo build
--release` per compilarlo con ottimizzazioni. Questo comando creerà un
eseguibile in *target/release* invece di *target/debug*. Le ottimizzazioni
rendono il tuo codice Rust più veloce, ma accenderli allunga il tempo che impiega
il tuo programma per compilare. Questo è il motivo per cui ci sono due profili diversi: uno
per lo sviluppo, quando si vuole ricostruire rapidamente e spesso, e un altro per
costruire il programma finale che darai a un utente che non sarà ricostruito
ripetutamente e che funzionerà il più velocemente possibile. Se stai misurando il tempo di esecuzione del tuo
codice, assicurati di eseguire `cargo build --release` e fare il benchmark con
l'eseguibile in *target/release*.

### Cargo come Convenzione

Con progetti semplici, Cargo non offre molte vantaggi rispetto all'uso direttamente di
`rustc`, ma dimostrerà il suo valore man mano che i tuoi programmi diventano più complessi.
Una volta che i programmi crescono fino a più file o necessitano una dipendenza, è molto più facile
lasciare che Cargo coordini la build.

Anche se il progetto `hello_cargo` è semplice, ora utilizza gran parte del vero
strumentazione che utilizzerai nel resto della tua carriera Rust. Infatti, per lavorare su qualsiasi
progetti esistenti, puoi usare i seguenti comandi per visualizzare il codice
utilizzando Git, cambiare alla directory di quel progetto, e costruire:

```console
$ git clone example.org/someproject
$ cd someproject
$ cargo build
```

Per maggiori informazioni su Cargo, consulta [la sua documentazione][cargo].

## Riassunto

Sei già partito con il piede giusto nel tuo viaggio con Rust! In questo capitolo,
hai imparato a:

* Installare l'ultima versione stabile di Rust usando `rustup`
* Aggiornare a una versione Rust più recente
* Aprire la documentazione installata localmente
* Scrivere ed eseguire un programma "Hello, world!" usando direttamente `rustc`
* Creare ed eseguire un nuovo progetto usando le convenzioni di Cargo

Questo è un ottimo momento per costruire un programma più sostanziale per abituarsi a leggere
e scrivere codice Rust. Quindi, nel Capitolo 2, costruiremo un programma di gioco di indovinelli.
Se preferisci iniziare imparando come funzionano i concetti di programmazione comuni in 
Rust, vedi il Capitolo 3 e poi torna al Capitolo 2.

[installation]: ch01-01-installation.html#installation
[toml]: https://toml.io
[appendix-e]: appendix-05-editions.html
[cargo]: https://doc.rust-lang.org/cargo/

