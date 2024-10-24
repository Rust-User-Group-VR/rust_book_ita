## Hello, World!

Ora che hai installato Rust, è il momento di scrivere il tuo primo programma Rust. È tradizione, quando si impara un nuovo linguaggio, scrivere un piccolo programma che stampa il testo `Hello, world!` sullo schermo, quindi faremo lo stesso qui!

> Nota: Questo libro presuppone una familiarità di base con la riga di comando. Rust non impone richieste specifiche su quali strumenti o editor utilizzare o dove il tuo codice debba risiedere, quindi se preferisci utilizzare un ambiente di sviluppo integrato (IDE) anziché la riga di comando, sentiti libero di usare il tuo IDE preferito. Molti IDE ora hanno un certo grado di supporto per Rust; consulta la documentazione dell’IDE per i dettagli. Il team di Rust si è concentrato sul fornire un ottimo supporto IDE tramite `rust-analyzer`. Consulta [Appendix D][devtools]<!-- ignore --> per ulteriori dettagli.

### Creazione di una Directory di Progetto

Inizierai creando una directory per memorizzare il tuo codice Rust. Non importa a Rust dove risiede il tuo codice, ma per gli esercizi e i progetti in questo libro, suggeriamo di creare una directory *projects* nella tua directory home e di mantenere lì tutti i tuoi progetti.

Apri un terminale ed inserisci i seguenti comandi per creare una directory *projects* e una directory per il progetto "Hello, world!" all'interno della directory *projects*.

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

Successivamente, crea un nuovo file sorgente e chiamalo *main.rs*. I file Rust terminano sempre con l'estensione *.rs*. Se stai utilizzando più di una parola nel nome del tuo file, la convenzione è di usare un underscore per separarle. Ad esempio, usa *hello_world.rs* anziché *helloworld.rs*.

Ora apri il file *main.rs* che hai appena creato e inserisci il codice nel Listato 1-1.

<Listing number="1-1" file-name="main.rs" caption="Un programma che stampa `Hello, world!`">

```rust
fn main() {
    println!("Hello, world!");
}
```

</Listing>

Salva il file e torna alla finestra del tuo terminale nella directory *~/projects/hello_world*. Su Linux o macOS, inserisci i seguenti comandi per compilare ed eseguire il file:

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

Indipendentemente dal tuo sistema operativo, la stringa `Hello, world!` dovrebbe essere stampata nel terminale. Se non vedi questo output, consulta la parte [“Troubleshooting”][troubleshooting]<!-- ignore --> della sezione Installazione per modi su come ottenere aiuto.

Se `Hello, world!` è stato stampato, congratulazioni! Hai ufficialmente scritto un programma Rust. Questo ti rende un programmista Rust—benvenuto!

### Anatomia di un Programma Rust

Esaminiamo in dettaglio questo programma “Hello, world!”. Ecco il primo elemento del puzzle:

```rust
fn main() {

}
```

Queste righe definiscono una funzione chiamata `main`. La funzione `main` è speciale: è sempre il primo codice che viene eseguito in ogni programma Rust eseguibile. Qui, la prima riga dichiara una funzione di nome `main` che non ha parametri e non restituisce nulla. Se ci fossero parametri, essi andrebbero messi tra le parentesi `()`.

Il Blocco della funzione è racchiuso tra `{}`. Rust richiede parentesi graffe attorno a tutti i blocchi delle funzioni. È buona norma posizionare la parentesi graffa di apertura sulla stessa linea della dichiarazione della funzione, aggiungendo uno spazio in mezzo.

> Nota: Se vuoi aderire a uno stile standard nei progetti Rust, puoi utilizzare uno strumento di formattazione automatica chiamato `rustfmt` per formattare il tuo codice in uno stile particolare (maggiori dettagli su `rustfmt` in [Appendix D][devtools]<!-- ignore -->). Il team di Rust ha incluso questo strumento con la distribuzione standard di Rust, come `rustc`, quindi dovrebbe essere già installato sul tuo computer!

Il blocco della funzione `main` contiene il seguente codice:

```rust
    println!("Hello, world!");
```

Questa linea svolge tutto il lavoro in questo piccolo programma: stampa il testo sullo schermo. Ci sono quattro dettagli importanti da notare qui.

Primo, lo stile Rust prevede di indentare con quattro spazi, non con un tab.

Secondo, `println!` chiama una macro Rust. Se avesse chiamato una funzione normale, sarebbe stato scritto come `println` (senza il `!`). Discuteremo in dettaglio delle macro Rust nel Capitolo 19. Per ora, devi solo sapere che usando un `!` significa che stai chiamando una macro invece di una funzione normale e che le macro non seguono sempre le stesse regole delle funzioni.

Terzo, vedi la stringa `"Hello, world!"`. Passiamo questa stringa come argomento a `println!`, e la stringa viene stampata sullo schermo.

Quarto, terminiamo la linea con un punto e virgola (`;`), che indica che questa espressione è finita e la prossima è pronta per iniziare. La maggior parte delle linee di codice Rust termina con un punto e virgola.

### Compilare ed Eseguire Sono Passi Separati

Hai appena eseguito un programma appena creato, quindi esaminiamo ogni passo del processo.

Prima di eseguire un programma Rust, devi compilarlo usando il compilatore Rust inserendo il comando `rustc` e passandogli il nome del tuo file sorgente, in questo modo:

```console
$ rustc main.rs
```

Se hai una formazione in C o C++, noterai che è simile a `gcc` o `clang`. Dopo una compilazione riuscita, Rust produce un file binario eseguibile.

Su Linux, macOS, e PowerShell su Windows, puoi vedere l'eseguibile inserendo il comando `ls` nel tuo shell:

```console
$ ls
main  main.rs
```

Su Linux e macOS, vedrai due file. Con PowerShell su Windows, vedrai gli stessi tre file che vedresti utilizzando CMD. Con CMD su Windows, dovresti inserire quanto segue:

```cmd
> dir /B %= the /B option says to only show the file names =%
main.exe
main.pdb
main.rs
```

Questo mostra il file del codice sorgente con estensione *.rs*, il file eseguibile (*main.exe* su Windows, ma *main* su tutte le altre piattaforme), e, quando usi Windows, un file contenente informazioni di debug con estensione *.pdb*. Da qui, esegui il file *main* o *main.exe*, in questo modo:

```console
$ ./main # o .\main.exe su Windows
```

Se il tuo *main.rs* è il tuo programma “Hello, world!”, questa linea stampa `Hello, world!` sul tuo terminale.

Se sei più familiare con un linguaggio dinamico, come Ruby, Python o JavaScript, potresti non essere abituato a compilare ed eseguire un programma come passi separati. Rust è un linguaggio *compilato in anticipo*, il che significa che puoi compilare un programma e dare l'eseguibile a qualcun altro, e loro possono eseguirlo anche senza avere Rust installato. Se dai a qualcuno un file *.rb*, *.py*, o *.js*, deve avere un'implementazione di Ruby, Python o JavaScript installata (rispettivamente). Ma in quei linguaggi, hai bisogno di un solo comando per compilare ed eseguire il tuo programma. Tutto è un compromesso nel design dei linguaggi.

Compilare con `rustc` va bene per programmi semplici, ma man mano che il progetto cresce, vorrai gestire tutte le opzioni e rendere facile condividere il tuo codice. Successivamente, ti introdurremo allo strumento Cargo, che ti aiuterà a scrivere programmi Rust nel mondo reale.

[troubleshooting]: ch01-01-installation.html#troubleshooting
[devtools]: appendix-04-useful-development-tools.html
