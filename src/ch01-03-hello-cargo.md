## Ciao, Cargo!

Cargo è il sistema di compilazione e il gestore dei pacchetti di Rust. La maggior parte dei Rustaceans utilizza questo strumento
per gestire i loro progetti Rust perché Cargo gestisce molti compiti per te,
come compilare il tuo codice, scaricare le librerie di cui il tuo codice dipende e
compilare tali librerie. (Chiamiamo le librerie di cui il tuo codice ha bisogno
*dipendenze*.)

I programmi Rust più semplici, come quello che abbiamo scritto finora, non hanno alcuna
dipendenza. Se avessimo costruito il progetto "Hello, world!" con Cargo, avrebbe
usato solo la parte di Cargo che gestisce la compilazione del tuo codice. Man mano che scrivi programmi Rust più complessi, aggiungerai dipendenze e, se inizi un progetto
utilizzando Cargo, aggiungere dipendenze sarà molto più facile da fare.

Poiché la stragrande maggioranza dei progetti Rust utilizza Cargo, il resto di questo libro
presupponi che tu stia usando anche Cargo. Cargo viene installato con Rust se hai
usato i programmi di installazione ufficiali discussi nella
sezione ["Installazione"][installazione]<!-- ignore -->. Se hai installato Rust
attraverso altri mezzi, controlla se Cargo è installato digitando il
seguente nel tuo terminale:

```console
$ cargo --version
```

Se vedi un numero di versione, ce l'hai! Se vedi un errore, come `command
not found`, guarda la documentazione per il tuo metodo di installazione per
determinare come installare Cargo separatamente.

### Creare un progetto con Cargo

Creiamo un nuovo progetto usando Cargo e vediamo come si differenzia dal nostro
originale progetto "Hello, world!". Torna alla tua directory *progetti*
(o ovunque tu abbia deciso di memorizzare il tuo codice). Poi, su qualsiasi sistema operativo,
esegui il seguente:

```console
$ cargo new hello_cargo
$ cd hello_cargo
```

Il primo comando crea una nuova directory e un progetto chiamato *hello_cargo*.
Abbiamo chiamato il nostro progetto *hello_cargo*, e Cargo crea i suoi file in a
directory con lo stesso nome.

Vai nella directory *hello_cargo* e elenca i file. Vedrai che Cargo
ha generato due file e una directory per noi: un file *Cargo.toml* e a
directory *src* con un file *main.rs* all'interno.

Ha anche inizializzato un nuovo repository Git insieme a un file *.gitignore*.
I file Git non verranno generati se esegui `cargo new` all'interno di un esistente Git
repository; puoi sovrascrivere questo comportamento usando `cargo new --vcs=git`.

> Nota: Git è un comune sistema di controllo delle versioni. Puoi cambiare `cargo new` per
> utilizzare un diverso sistema di controllo delle versioni o nessun sistema di controllo delle versioni utilizzando
> l'opzione `--vcs`. Esegui `cargo new --help` per vedere le opzioni disponibili.

Apri *Cargo.toml* nel tuo editor di testo preferito. Dovrebbe assomigliare al 
codice in Listing 1-2.

<span class="filename">Nome del file: Cargo.toml</span>

```toml
[package]
name = "hello_cargo"
version = "0.1.0"
edition = "2021"

# See more keys and their definitions at https://doc.rust-lang.org/cargo/reference/manifest.html

[dependencies]
```

<span class="caption">Listing 1-2: Contenuti del *Cargo.toml* generato da `cargo
new`</span>

Questo file è nel formato [*TOML*][toml]<!-- ignore --> (*Tom’s Obvious, Minimal
Language*), che è il formato di configurazione di Cargo.

La prima riga, `[package]`, è un'intestazione di sezione che indica che il
le seguenti dichiarazioni stanno configurando un package. Man mano che aggiungeremo più informazioni a
questo file, aggiungeremo altre sezioni.

Le prossime tre righe impostano le informazioni di configurazione di cui Cargo ha bisogno per compilare
il tuo programma: il nome, la versione, e l'edizione di Rust da utilizzare. Parleremo
della key `edition` in [Appendix E][appendix-e]<!-- ignore -->.

L'ultima riga, `[dependencies]`, è l'inizio di una sezione per te per elencare qualsiasi
delle dipendenze del tuo progetto. In Rust, i pacchetti di codice sono indicati come
*crates*. Non avremo bisogno di altre crates per questo progetto, ma lo faremo nel
primo progetto nel Capitolo 2, quindi useremo questa sezione delle dipendenze allora.

Ora apri *src/main.rs* e dai un'occhiata:

<span class="filename">Nome del file: src/main.rs</span>

```rust
fn main() {
    println!("Hello, world!");
}
```

Cargo ha generato un programma "Hello, world!" per te, proprio come quello che noi
abbiamo scritto in Listing 1-1! Finora, le differenze tra il nostro progetto e il
progetto generato da Cargo sono che Cargo ha posizionato il codice nella directory *src*
e abbiamo un file di configurazione *Cargo.toml* nella directory principale.

Cargo si aspetta che i tuoi file sorgente risiedano all'interno della directory *src*. The
la directory del progetto di livello superiore è solo per i file README, le informazioni sulla licenza,
i file di configurazione e qualsiasi altra cosa non correlata al tuo codice. Usando Cargo
ti aiuta a organizzare i tuoi progetti. C'è un posto per tutto, e
tutto è al suo posto.

Se hai avviato un progetto che non utilizza Cargo, come abbiamo fatto con il progetto "Hello,
world!", puoi convertirlo in un progetto che utilizza Cargo. Sposta il
codice del progetto nella directory *src* e crea un appropriato file *Cargo.toml*.

### Costruire ed Eseguire un Progetto Cargo

Ora vediamo cosa cambia quando costruiamo ed eseguiamo il programma "Hello, world!"
con Cargo! Dalla tua directory *hello_cargo*, costruisci il tuo progetto inserendo il seguente comando:

```console
$ cargo build
   Compiling hello_cargo v0.1.0 (file:///projects/hello_cargo)
    Finished dev [unoptimized + debuginfo] target(s) in 2.85 secs
```

Questo comando crea un file eseguibile in *target/debug/hello_cargo* (o
*target\debug\hello_cargo.exe* su Windows) piuttosto che nella tua attuale
directory. Poiché la compilazione predefinita è una compilazione di debug, Cargo mette il binario in
una directory chiamata *debug*. Puoi eseguire l'eseguibile con questo comando:

```console
$ ./target/debug/hello_cargo # o .\target\debug\hello_cargo.exe su Windows
Hello, world!
```

Se tutto va bene, `Hello, world!` dovrebbe stampare sul terminale. Eseguendo `cargo
build` per la prima volta fa anche sì che Cargo crei un nuovo file al livello superiore: *Cargo.lock*. Questo file tiene traccia delle versioni esatte delle
dipendenze nel tuo progetto. Questo progetto non ha dipendenze, quindi il
file è un po' scarso. Non avrai mai bisogno di cambiare questo file manualmente; Cargo
gestisce i suoi contenuti per te.

Abbiamo appena costruito un progetto con `cargo build` e lo abbiamo eseguito con
`./target/debug/hello_cargo`, ma possiamo anche usare `cargo run` per compilare il
codice e poi eseguire l'eseguibile risultante tutto in un solo comando:

```console
$ cargo run
    Finished dev [unoptimized + debuginfo] target(s) in 0.0 secs
     Running `target/debug/hello_cargo`
Hello, world!
```

Using `cargo run` is more convenient than having to remember to run `cargo
L'uso di `cargo run` è più conveniente che dover ricordare di eseguire `cargo
build` e poi utilizzare l'intero percorso per il binario, quindi la maggior parte degli sviluppatori usa `cargo
run`.

Notate che questa volta non abbiamo visto un output che indica che Cargo stava compilando
`hello_cargo`. Cargo ha capito che i file non erano cambiati, quindi non
ha ricostruito ma ha semplicemente eseguito il binario. Se avessi modificato il tuo codice sorgente, Cargo
avrebbe ricostruito il progetto prima di eseguirlo, e avresti visto questo
output:

```console
$ cargo run
   Compiling hello_cargo v0.1.0 (file:///projects/hello_cargo)
    Finished dev [unoptimized + debuginfo] target(s) in 0.33 secs
     Running `target/debug/hello_cargo`
Hello, world!
```

Cargo fornisce anche un comando chiamato `cargo check`. Questo comando controlla rapidamente
il tuo codice per assicurarsi che venga compilato ma non produce un eseguibile:

```console
$ cargo check
   Checking hello_cargo v0.1.0 (file:///projects/hello_cargo)
    Finished dev [unoptimized + debuginfo] target(s) in 0.32 secs
```

Perché non vorresti un eseguibile? Spesso, `cargo check` è molto più veloce di
`cargo build` poiché salta il passaggio di produzione di un eseguibile. Se stai
continuamente controllando il tuo lavoro mentre scrivi il codice, l'uso di `cargo check` velocizzerà
il processo di farti sapere se il tuo progetto è ancora in fase di compilazione! Come
tale, molti Rustaceans eseguono `cargo check` periodicamente mentre scrivono il loro
programma per assicurarsi che si compili. Quindi eseguono `cargo build` quando sono
pronti per utilizzare l'eseguibile.

Ricapitoliamo ciò che abbiamo imparato finora su Cargo:

* Possiamo creare un progetto usando `cargo new`.
* Possiamo costruire un progetto usando `cargo build`.
* Possiamo costruire ed eseguire un progetto in un unico passaggio usando `cargo run`.
* Possiamo costruire un progetto senza produrre un binario per controllare gli errori usando
  `cargo check`.
* Invece di salvare il risultato della build nella stessa directory del nostro codice,
  Cargo lo memorizza nella directory *target/debug*.

Un ulteriore vantaggio nell'utilizzo di Cargo è che i comandi sono gli stessi a
prescindere dal sistema operativo su cui stai lavorando. Quindi, a questo punto, non forniremo più istruzioni specifiche per Linux e macOS rispetto a Windows.

### Compilazione per il rilascio

Quando il tuo progetto è finalmente pronto per il rilascio, puoi usare `cargo build
--release` per compilarlo con ottimizzazioni. Questo comando creerà un
eseguibile in *target/release* invece di *target/debug*. Le ottimizzazioni
rendono il tuo codice Rust più veloce, ma attivarle allunga il tempo necessario per la compilazione del tuo programma. Ecco perché ci sono due profili diversi: uno
per lo sviluppo, quando vuoi ricostruire velocemente e spesso, e un altro per
costruire il programma finale che darai a un utente che non sarà ricostruito
ripetutamente e che funzionerà il più velocemente possibile. Se stai effettuando benchmark del tempo di esecuzione del tuo
codice, assicurati di eseguire `cargo build --release` e fare il benchmark con
l'eseguibile in *target/release*.

### Cargo come convenzione

Con progetti semplici, Cargo non fornisce un grande valore rispetto all'uso
di `rustc`, ma dimostrerà il suo valore man mano che i tuoi programmi diventano più intricati.
Una volta che i programmi crescono in più file o hanno bisogno di una dipendenza, è molto più facile lasciare che Cargo coordini la compilazione.

Anche se il progetto `hello_cargo` è semplice, ora utilizza gran parte del vero
strumentario che userai nel resto della tua carriera Rust. Infatti, per lavorare su qualsiasi
progetti esistenti, puoi utilizzare i seguenti comandi per scaricare il codice
usando Git, passare alla directory di quel progetto e compilare:

```console
$ git clone example.org/someproject
$ cd someproject
$ cargo build
```

Per maggiori informazioni su Cargo, consulta [la sua documentazione][cargo].

## Riepilogo

Sei già partito alla grande nel tuo viaggio Rust! In questo capitolo,
hai imparato come:

* Installare l'ultima versione stabile di Rust usando `rustup`
* Aggiornare a una versione Rust più recente
* Aprire la documentazione installata localmente
* Scrivere ed eseguire un programma "Hello, world!" usando `rustc` direttamente
* Creare ed eseguire un nuovo progetto utilizzando le convenzioni di Cargo

Questo è un ottimo momento per costruire un programma più consistente per abituarti a leggere
e scrivere codice Rust. Quindi, nel Capitolo 2, costruiremo un programma di gioco di indovinelli.
Se preferisci iniziare imparando come funzionano i concetti di programmazione comuni in
Rust, vedi il Capitolo 3 e poi torna al Capitolo 2.

[installation]: ch01-01-installation.html#installation
[toml]: https://toml.io
[appendix-e]: appendix-05-editions.html
[cargo]: https://doc.rust-lang.org/cargo/

