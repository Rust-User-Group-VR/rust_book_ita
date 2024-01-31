## Ciao, Mondo!

Ora che hai installato Rust, è il momento di scrivere il tuo primo programma in Rust.
È tradizione quando si impara un nuovo linguaggio scrivere un piccolo programma che
stampa il testo `Ciao, mondo!` sullo schermo, quindi faremo lo stesso qui!

> Nota: Questo libro presume una conoscenza di base della linea di comando. Rust non impone
> nessuna richiesta specifica riguardo al tuo editor o strumenti o dove risiede il tuo codice, quindi
> se preferisci utilizzare un ambiente di sviluppo integrato (IDE) invece della
> linea di comando, sentiti libero di usare il tuo IDE preferito. Molti IDE adesso hanno un certo
> grado di supporto per Rust; controlla la documentazione dell'IDE per i dettagli. Il team di Rust
> si è concentrato su abilitare un grande supporto IDE tramite `rust-analyzer`. Guarda
> [Appendice D][devtools]<!-- ignora --> per maggiori dettagli.

### Creare una Directory di Progetto

Inizierai creando una directory per memorizzare il tuo codice Rust. Non importa
a Rust dove risiede il tuo codice, ma per gli esercizi e i progetti in questo libro,
suggeriamo di creare una directory *progetti* nella tua directory home e mantenere tutti
i tuoi progetti lì.

Apri un terminale e inserisci i seguenti comandi per creare una directory *progetti*
e una directory per il progetto "Ciao, mondo!" all'interno della directory *progetti*.

Per Linux, macOS, e PowerShell su Windows, inserisci questo:

```console
$ mkdir ~/progetti
$ cd ~/progetti
$ mkdir ciao_mondo
$ cd ciao_mondo
```

Per CMD di Windows, inserisci questo:

```cmd
> mkdir "%USERPROFILE%\progetti"
> cd /d "%USERPROFILE%\progetti"
> mkdir ciao_mondo
> cd ciao_mondo
```

### Scrivere ed Eseguire un Programma Rust

Poi, crea un nuovo file sorgente e chiamalo *main.rs*. I file Rust finiscono sempre con
l'estensione *.rs*. Se stai utilizzando più di una parola nel tuo nome file, la
convenzione è di usare un underscore per separarle. Per esempio, usa
*ciao_mondo.rs* invece di *ciaomondo.rs*.

Ora apri il file *main.rs* che hai appena creato e inserisci il codice in Elenco 1-1.

<span class="filename">Nome file: main.rs</span>

```rust
fn main() {
    println!("Ciao, mondo!");
}
```

<span class="caption">Elenco 1-1: Un programma che stampa `Ciao, mondo!`</span>

Salva il file e torna alla tua finestra del terminale nella
directory *~/progetti/ciao_mondo*. Su Linux o macOS, inserisci i seguenti
comandi per compilare ed eseguire il file:

```console
$ rustc main.rs
$ ./main
Ciao, mondo!
```

Su Windows, inserisci il comando `.\main.exe` invece di `./main`:

```powershell
> rustc main.rs
> .\main.exe
Ciao, mondo!
```

Indipendentemente dal tuo sistema operativo, la stringa `Ciao, mondo!` dovrebbe essere stampata su
il terminale. Se non vedi questo output, torna alla
[“Risoluzione dei problemi”][troubleshooting]<!-- ignora --> parte della sezione di Installazione
per trovate modi per ottenere aiuto.

Se `Ciao, mondo!` è stato stampato, congratulazioni! Hai ufficialmente scritto un programma Rust.
Questo ti rende un programmatore Rust—benvenuto!

### Anatomia di un Programma Rust

Rivediamo in dettaglio questo programma "Ciao, mondo!". Ecco il primo pezzo del
puzzle:

```rust
fn main() {

}
```

Queste righe definiscono una funzione chiamata `main`. La funzione `main` è speciale: è
sempre il primo codice che viene eseguito in ogni programma Rust eseguibile. Qui, la
prima riga dichiara una funzione chiamata `main` che non ha parametri e non ritorna niente.
Se ci fossero dei parametri, andrebbero dentro le parentesi `()`.

Il corpo della funzione è racchiuso in `{}`. Rust richiede parentesi graffe attorno a tutti i
corpi della funzione. È buona pratica mettere la parentesi graffa di apertura sulla stessa
riga come la dichiarazione della funzione, aggiungendo uno spazio in mezzo.

> Nota: Se vuoi attenerti a uno stile standard nei progetti Rust, puoi
> usare uno strumento di formattazione automatico chiamato `rustfmt` per formattare il tuo codice in uno
> stile particolare (più su `rustfmt` in
> [Appendice D][devtools]<!-- ignora -->). Il team Rust ha incluso questo strumento
> con la distribuzione standard Rust, come `rustc` lo è, quindi dovrebbe già essere
> installato sul tuo computer!

Il corpo della funzione `main` contiene il seguente codice:

```rust
    println!("Ciao, mondo!");
```

Questa riga fa tutto il lavoro in questo piccolo programma: stampa il testo sullo
schermo. Ci sono quattro dettagli importanti da notare qui.

Prima, lo stile Rust è di indentare con quattro spazi, non un tab.

Seconda, `println!` chiama un macro Rust. Se avesse chiamato una funzione invece, sarebbe stato inserito come `println` (senza il `!`). Discuteremo i macro Rust in più dettaglio nel Capitolo 19. Per ora, hai solo bisogno di sapere che usare un `!` significa che stai chiamando un macro invece di una funzione normale e che i macro non seguono sempre le stesse regole delle funzioni.

Terza, vedi la stringa `"Ciao, mondo!"`. Passiamo questa stringa come argomento a `println!`, e la stringa viene stampata sullo schermo.

Quarta, terminiamo la riga con un punto e virgola (`;`), il quale indica che questa
espressione è finita e la prossima è pronta per iniziare. La maggior parte delle righe di codice Rust
terminano con un punto e virgola.

### La Compilazione e l'Esecuzione Sono Fasi Separate

Hai appena eseguito un programma appena creato, quindi esaminiamo ogni fase nel
processo.

Prima di eseguire un programma Rust, devi compilarlo usando il compilatore Rust inserendo il comando `rustc` e passandogli il nome del tuo file sorgente, come questo:

```console
$ rustc main.rs
```

Se hai un background in C o C++, noterai che questo è simile a `gcc`
o `clang`. Dopo aver compilato con successo, Rust emette un eseguibile binario.

Su Linux, macOS, e PowerShell su Windows, puoi vedere l'eseguibile inserendo il comando `ls` nel tuo shell:

```console
$ ls
main  main.rs
```

Su Linux e macOS, vedrai due file. Con PowerShell su Windows, vedrai gli stessi tre file che vedresti usando CMD. Con CMD su Windows, inseriresti il seguente:

```cmd
> dir /B %= l'opzione /B dice di mostrare solo i nomi dei file =%
main.exe
main.pdb
main.rs
```

Questo mostra il file sorgente con l'estensione *.rs*, il file eseguibile (*main.exe* su Windows, ma *main* su tutte le altre piattaforme), e, quando si usa Windows, un file contenente informazioni di debug con l'estensione *.pdb*.
Da qui, esegui il file *main* o *main.exe*, così:

```console
$ ./main # o .\main.exe su Windows
```

Se il tuo *main.rs* è il tuo programma "Ciao, mondo!", questa riga stampa `Ciao,
mondo!` sul tuo terminale.

Se sei più familiare con un linguaggio dinamico, come Ruby, Python, o
JavaScript, potresti non essere abituato a compilare ed eseguire un programma come
fasi separate. Rust è un linguaggio *compilato in anticipo*, il che significa che puoi
compilare un programma e dare l'eseguibile a qualcun altro, e possono eseguirlo
anche senza avere Rust installato. Se dai a qualcuno un file *.rb*, *.py*, o *.js*, hanno bisogno di avere un'implementazione Ruby, Python, o JavaScript installata (rispettivamente). Ma in quei linguaggi, hai bisogno di un solo comando per
compilare ed eseguire il tuo programma. Tutto è un compromesso nella progettazione del linguaggio.

Compilare con `rustc` è ottimo per programmi semplici, ma quando il tuo progetto
cresce, vorrai gestire tutte le opzioni e rendere facile condividere il tuo
codice. Prossima, ti presenteremo lo strumento Cargo, che ti aiuterà a scrivere
programmi Rust nel mondo reale.

[troubleshooting]: ch01-01-installation.html#troubleshooting
[devtools]: appendix-04-useful-development-tools.html

