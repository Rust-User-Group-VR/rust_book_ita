## Hello, World!

Ora che hai installato Rust, è il momento di scrivere il tuo primo programma in Rust.
È tradizione quando si impara un nuovo linguaggio scrivere un piccolo programma che
stampa il testo `Hello, world!` sullo schermo, quindi faremo lo stesso qui!

> Nota: Questo libro presume una conoscenza di base della riga di comando. Rust non fa
> richieste specifiche sul tuo modo di editare, sugli strumenti che usi o sul luogo in cui risiede il tuo codice, quindi
> se preferisci utilizzare un ambiente di sviluppo integrato (IDE) piuttosto che
> la riga di comando, sei libero di utilizzare il tuo IDE preferito. Molti IDE ora hanno un certo
> grado di supporto per Rust; controlla la documentazione dell'IDE per i dettagli. Il team di Rust
> si è concentrato su abilitare un ottimo supporto per IDE tramite `rust-analyzer`. Vedi 
> [Appendice D][devtools]<!-- ignore --> per ulteriori dettagli.


### Creazione di una directory di progetto

Inizierai creando una directory per conservare il tuo codice Rust. Non importa
a Rust dove vive il tuo codice, ma per gli esercizi e i progetti in questo libro,
ti suggeriamo di creare una directory *projects* nella tua home directory e di conservare tutti
i tuoi progetti lì.

Apri un terminale e inserisci i seguenti comandi per creare una directory *projects*
e una directory per il progetto "Hello, world!" all'interno della directory *projects*.

Per Linux, macOS, e PowerShell su Windows, inserisci questo:

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

### Scrivere ed eseguire un programma Rust

Dopo, crea un nuovo file sorgente e chiamalo *main.rs*. I file Rust terminano sempre con
l'estensione *.rs*. Se stai utilizzando più di una parola nel tuo nome file, la
convenzione è utilizzare un underscore per separarle. Ad esempio, usa
*hello_world.rs* invece di *helloworld.rs*.

Ora apri il file *main.rs* che hai appena creato e inserisci il codice in Elenco 1-1.

<span class="filename">Nome del file: main.rs</span>


```rust
fn main() {
    println!("Hello, world!");
}
```

<span class="caption">Elenco 1-1: Un programma che stampa `Hello, world!`</span>

Salva il file e torna alla tua finestra del terminale nella
directory *~/projects/hello_world*. Su Linux o macOS, inserisci i seguenti
comandi per compilare ed eseguire il file:

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

Indipendentemente dal tuo sistema operativo, la stringa `Hello, world!` dovrebbe essere stampata su
il terminale. Se non vedi questo output, fai riferimento alla
parte "Risoluzione dei problemi" della sezione di installazione
per modi di ottenere aiuto.

Se `Hello, world!` è stato stampato, congratulazioni! Hai ufficialmente scritto un programma Rust
Ciò ti rende un programmatore Rust - benvenuto!

### Anatomia di un programma Rust

Rivediamo questo programma "Hello, world!" nel dettaglio. Ecco il primo pezzo dell'
puzzle:

```rust
fn main() {

}
```

Queste linee definiscono una funzione chiamata `main`. La funzione `main` è speciale: è
sempre il primo codice che si esegue in ogni programma Rust eseguibile. Qui, la
prima linea dichiara una funzione chiamata `main` che non ha parametri e non restituisce
nulla. Se ci fossero dei parametri, andrebbero tra parentesi `()`.

Il corpo della funzione è racchiuso in `{}`. Rust richiede parentesi graffe intorno a tutti
i corpi di funzione. È buona pratica posizionare la parentesi graffa di apertura sulla stessa
linea della dichiarazione della funzione, aggiungendo uno spazio in mezzo.

> Nota: Se vuoi aderire a uno stile standard nei progetti Rust, puoi
> usare uno strumento di formattazione automatica chiamato `rustfmt` per formattare il tuo codice in uno
> stile particolare (maggiori informazioni su `rustfmt` in
> [Appendice D][devtools]<!-- ignore -->). Il team di Rust ha incluso questo strumento
> con la distribuzione standard di Rust, come `rustc`, quindi già dovrebbe essere
> installato sul tuo computer!

Il corpo della funzione `main` contiene il seguente codice:

```rust
    println!("Hello, world!");
```

Questa linea fa tutto il lavoro in questo piccolo programma: stampa il testo sullo 
schermo. Ci sono quattro dettagli importanti da notare qui.

Primo, lo stile di Rust è di indentare con quattro spazi, non un tab.

Secondo, `println!` chiama una macro Rust. Se avesse chiamato una funzione invece, sarebbe stato inserito come `println` (senza il `!`). Discuteremo delle macro Rust in dettaglio nel Capitolo 19. Per ora, devi solo sapere che l'uso di un `!` significa che stai chiamando una macro invece di una funzione normale e che le macro non seguono sempre le stesse regole delle funzioni.

Terzo, vedi la stringa `"Hello, world!"`. Passiamo questa stringa come argomento a `println!`, e la stringa viene stampata sullo schermo.

Quarto, terminiamo la linea con un punto e virgola (`;`), che indica che questa espressione è finita e la successiva è pronta per iniziare. La maggior parte delle righe di codice Rust termina con un punto e virgola.

### Compilazione ed Esecuzione Sono Passaggi Separati

Hai appena eseguito un programma appena creato, quindi esaminiamo ciascun passaggio nel processo.

Prima di eseguire un programma Rust, devi compilarlo usando il compilatore Rust inserendo il comando `rustc` e passandogli il nome del tuo file sorgente, così:

```console
$ rustc main.rs
```

Se hai esperienza con C o C++, noterai che questo è simile a `gcc` o `clang`. Dopo aver compilato con successo, Rust produce un eseguibile binario.

Su Linux, macOS, e PowerShell su Windows, puoi vedere l'eseguibile inserendo il comando `ls` nel tuo shell:

```console
$ ls
main  main.rs
```

Su Linux e macOS, vedrai due file. Con PowerShell su Windows, vedrai gli stessi tre file che vedresti utilizzando CMD. Con CMD su Windows, inseriresti il seguente:

```cmd
> dir /B %= the /B option says to only show the file names =%
main.exe
main.pdb
main.rs
```

Questo mostra il file del codice sorgente con l'estensione *.rs*, il file eseguibile (*main.exe* su Windows, ma *main* su tutte le altre piattaforme), e, quando si utilizza Windows, un file contenente informazioni di debug con l'estensione *.pdb*. Da qui, esegui il file *main* o *main.exe*, così:

```console
$ ./main # o .\main.exe su Windows
```

Se il tuo *main.rs* è il tuo programma "Hello, world!", questa linea stampa `Hello,
world!` sul tuo terminale.

Se sei più familiare con un linguaggio dinamico, come Ruby, Python, o
JavaScript, potresti non essere abituato a compilare ed eseguire un programma come
passaggi separati. Rust è un linguaggio *compilato prima del tempo*, il che significa che puoi
compilare un programma e dare l'eseguibile a qualcun altro, e possono eseguirlo
anche senza avere installato Rust. Se dai a qualcuno un file *.rb*, *.py*, o *.js*, hanno bisogno di avere una implementazione Ruby, Python, o JavaScript
installata (rispettivamente). Ma in quei linguaggi, hai bisogno di un solo comando per
compilare ed eseguire il tuo programma. Ogni cosa è un compromesso nel design del linguaggio.

Compilare solo con `rustc` va bene per programmi semplici, ma man mano che il tuo progetto
cresce, vorrai gestire tutte le opzioni e rendere facile condividere il tuo
codice. Successivamente, ti presenteremo lo strumento Cargo, che ti aiuterà a scrivere
programmi Rust per il mondo reale.

[troubleshooting]: ch01-01-installation.html#troubleshooting
[devtools]: appendix-04-useful-development-tools.html
