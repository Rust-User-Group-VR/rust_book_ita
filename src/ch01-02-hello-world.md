## Hello, World!

Ora che hai installato Rust, è il momento di scrivere il tuo primo programma in Rust.
È tradizione, quando si impara un nuovo linguaggio, scrivere un piccolo programma che stamperà il testo `Hello, world!` sullo schermo, quindi faremo lo stesso qui!

> Nota: Questo libro presume una familiarità di base con la riga di comando. Rust non richiede nulla di specifico riguardo l'editor o gli strumenti o dove il codice risiede, quindi se preferisci usare un ambiente di sviluppo integrato (IDE) invece della riga di comando, sentiti libero di utilizzare il tuo IDE preferito. Molti IDE ora hanno un certo grado di supporto per Rust; controlla la documentazione dell'IDE per i dettagli. Il team di Rust si è concentrato nel fornire un ottimo supporto per gli IDE tramite `rust-analyzer`. Vedi [Appendice D][devtools]<!-- ignore --> per maggiori dettagli.

### Creazione di una Directory di Progetto

Inizierai creando una directory per conservare il tuo codice Rust. Non importa a Rust dove risiede il tuo codice, ma per gli esercizi e i progetti in questo libro, suggeriamo di creare una directory *projects* nella tua home directory e di conservare lì tutti i tuoi progetti.

Apri un terminale ed entra i seguenti comandi per creare una directory *projects* e una directory per il progetto "Hello, world!" all'interno della directory *projects*.

Per Linux, macOS e PowerShell su Windows, inserisci questo:

```console
$ mkdir ~/projects
$ cd ~/projects
$ mkdir hello_world
$ cd hello_world
```

Per Windows CMD, inserisci questo:

```cmd
> mkdir "%USERPROFILE%\projects"
> cd /d "%USERPROFILE%\projects"
> mkdir hello_world
> cd hello_world
```

### Scrivere ed Eseguire un Programma Rust

Successivamente, crea un nuovo file sorgente chiamato *main.rs*. I file Rust terminano sempre con l'estensione *.rs*. Se stai usando più di una parola nel nome del file, la convenzione è usare un trattino basso per separarle. Ad esempio, usa *hello_world.rs* piuttosto che *helloworld.rs*.

Ora apri il file *main.rs* che hai appena creato e inserisci il codice elencato in Listing 1-1.

<Listing number="1-1" file-name="main.rs" caption="Un programma che stampa `Hello, world!`">

```rust
fn main() {
    println!("Hello, world!");
}
```

</Listing>

Salva il file e torna alla tua finestra del terminale nella directory *~/projects/hello_world*. Su Linux o macOS, inserisci i seguenti comandi per compilare ed eseguire il file:

```console
$ rustc main.rs
$ ./main
Hello, world!
```

Su Windows, inserisci il comando `.\main.exe` invece di `./main`:

```powershell
> rustc main.rs
> .\main.exe
Hello, world!
```

Indipendentemente dal tuo sistema operativo, la stringa `Hello, world!` dovrebbe essere stampata sul terminale. Se non vedi questo output, torna alla parte [“Risoluzione dei problemi”][troubleshooting]<!-- ignore --> della sezione di Installazione per trovare modalità per ottenere aiuto.

Se `Hello, world!` è stato stampato, congratulazioni! Hai ufficialmente scritto un programma in Rust. Questo ti rende un programmatore Rust—benvenuto!

### Anatomia di un Programma Rust

Esaminiamo in dettaglio questo programma "Hello, world!". Ecco la prima parte del puzzle:

```rust
fn main() {

}
```

Queste righe definiscono una funzione chiamata `main`. La funzione `main` è speciale: è sempre il primo codice che viene eseguito in ogni programma Rust eseguibile. Qui, la prima riga dichiara una funzione chiamata `main` che non ha parametri e non restituisce nulla. Se ci fossero parametri, andrebbero inseriti tra parentesi `()`.

Il corpo della funzione è racchiuso tra `{}`. Rust richiede parentesi graffe intorno a tutti i corpi delle funzioni. È buona norma posizionare la parentesi graffa di apertura sulla stessa linea della dichiarazione della funzione, aggiungendo uno spazio tra i due.

> Nota: Se desideri aderire a uno stile standard tra i progetti Rust, puoi utilizzare uno strumento di formattazione automatico chiamato `rustfmt` per formattare il tuo codice in uno stile particolare (maggiori informazioni su `rustfmt` si trovano in [Appendice D][devtools]<!-- ignore -->). Il team di Rust ha incluso questo strumento con la distribuzione standard di Rust, così come `rustc`, quindi dovrebbe essere già installato sul tuo computer!

Il corpo della funzione `main` contiene il seguente codice:

```rust
    println!("Hello, world!");
```

Questa linea fa tutto il lavoro in questo piccolo programma: stampa del testo sullo schermo. Ci sono quattro dettagli importanti da notare qui.

Primo, lo stile Rust è di indentare con quattro spazi, non con una tabulazione.

Secondo, `println!` chiama una macro di Rust. Se avesse chiamato una funzione invece, sarebbe stato `println` (senza il `!`). Discuteremo delle macro di Rust in maggiore dettaglio nel Capitolo 19. Per ora, devi solo sapere che usare un `!` significa che stai chiamando una macro invece di una funzione normale e che le macro non seguono sempre le stesse regole delle funzioni.

Terzo, vedi la stringa `"Hello, world!"`. Passiamo questa stringa come argomento a `println!`, e la stringa viene stampata sullo schermo.

Quarto, terminiamo la riga con un punto e virgola (`;`), che indica che questa espressione è terminata e la prossima è pronta per iniziare. La maggior parte delle righe di codice Rust termina con un punto e virgola.

### Compilare ed Eseguire Sono Passi Separati

Hai appena eseguito un programma appena creato, quindi esaminiamo ogni passo del processo.

Prima di eseguire un programma Rust, devi compilarlo usando il compilatore di Rust inserendo il comando `rustc` e passandogli il nome del tuo file sorgente, come questo:

```console
$ rustc main.rs
```

Se hai una base di conoscenze su C o C++, noterai che è simile a `gcc` o `clang`. Dopo aver compilato con successo, Rust emette un eseguibile binario.

Su Linux, macOS e PowerShell su Windows, puoi vedere l'eseguibile inserendo il comando `ls` nella tua shell:

```console
$ ls
main  main.rs
```

Su Linux e macOS, vedrai due file. Con PowerShell su Windows, vedrai gli stessi tre file che vedresti usando CMD. Con CMD su Windows, inseriresti il seguente comando:

```cmd
> dir /B %= l'opzione /B dice di mostrare solo i nomi dei file =%
main.exe
main.pdb
main.rs
```

Questo mostra il file sorgente con l'estensione *.rs*, il file eseguibile (*main.exe* su Windows, ma *main* su tutte le altre piattaforme), e, su Windows, un file contenente informazioni di debug con l'estensione *.pdb*. Da qui, esegui il file *main* o *main.exe*, in questo modo:

```console
$ ./main # o .\main.exe su Windows
```

Se il tuo *main.rs* è il tuo programma “Hello, world!”, questa linea stamperà `Hello, world!` sul tuo terminale.

Se sei più familiare con un linguaggio dinamico, come Ruby, Python o JavaScript, potresti non essere abituato a compilare ed eseguire un programma come passaggi separati. Rust è un linguaggio *compilato in anticipo*, il che significa che puoi compilare un programma e dare l'eseguibile a qualcun altro, e potranno eseguirlo anche senza avere Rust installato. Se dai a qualcuno un file *.rb*, *.py*, o *.js*, deve avere un'implementazione di Ruby, Python o JavaScript installata (rispettivamente). Ma in quei linguaggi, hai bisogno solo di un comando per compilare ed eseguire il tuo programma. Tutto è un compromesso nel design del linguaggio.

Compilare con `rustc` va bene per programmi semplici, ma man mano che il tuo progetto cresce, vorrai gestire tutte le opzioni e rendere facile la condivisione del tuo codice. Successivamente, ti presenteremo lo strumento Cargo, che ti aiuterà a scrivere programmi Rust per il mondo reale.

[troubleshooting]: ch01-01-installation.html#troubleshooting
[devtools]: appendix-04-useful-development-tools.html
