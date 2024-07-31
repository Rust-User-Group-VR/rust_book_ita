## Package e Crate

Le prime parti del sistema dei moduli che affronteremo sono i package e i crate.

Un *crate* è la quantità minima di codice che il compilatore Rust considera alla volta. Anche se esegui `rustc` invece di `cargo` e passi un singolo file di codice sorgente (come abbiamo fatto nella sezione "Scrivere ed eseguire un programma Rust" del Capitolo 1), il compilatore considera quel file come un crate. I crate possono contenere moduli, e i moduli possono essere definiti in altri file che vengono compilati con il crate, come vedremo nelle sezioni successive.

Un crate può presentarsi in due forme: un crate binario o un crate di librerie.
I *crate binari* sono programmi che puoi compilare in un eseguibile che puoi eseguire, come un programma da riga di comando o un server. Ognuno deve avere una funzione chiamata `main` che definisce cosa succede quando l'eseguibile viene eseguito. Tutti i crate che abbiamo creato finora erano crate binari.

I *crate di librerie* non hanno una funzione `main` e non vengono compilati in un eseguibile. Invece, definiscono funzionalità destinate a essere condivise con più progetti. Ad esempio, il crate `rand` che abbiamo usato nel [Capitolo 2][rand]<!-- ignore --> fornisce funzionalità che generano numeri casuali. La maggior parte delle volte, quando i Rustaceans dicono "crate", intendono un crate di libreria, e usano "crate" in modo intercambiabile con il concetto generale di programmazione di una "libreria".

La *radice del crate* è un file sorgente da cui il compilatore Rust parte e costituisce il modulo radice del tuo crate (spiegheremo i moduli in dettaglio nella sezione [“Definire Moduli per Controllare Scope e Privacy”][modules]<!-- ignore -->).

Un *package* è un insieme di uno o più crate che fornisce un set di funzionalità. Un package contiene un file *Cargo.toml* che descrive come costruire quei crate. Cargo è in realtà un package che contiene il crate binario per lo strumento da riga di comando che hai utilizzato per costruire il tuo codice. Il package Cargo contiene anche un crate di libreria da cui dipende il crate binario. Altri progetti possono dipendere dal crate di libreria di Cargo per usare la stessa logica che usa lo strumento da riga di comando Cargo.

Un crate può presentarsi in due forme: un crate binario o un crate di libreria. Un package può contenere quanti crate binari vuoi, ma al massimo solo un crate di libreria. Un package deve contenere almeno un crate, sia che si tratti di una libreria o di un crate binario.

Vediamo cosa succede quando creiamo un package. Prima inseriamo il comando `cargo new my-project`:

```console
$ cargo new my-project
     Created binary (application) `my-project` package
$ ls my-project
Cargo.toml
src
$ ls my-project/src
main.rs
```

Dopo aver eseguito `cargo new my-project`, usiamo `ls` per vedere cosa crea Cargo. Nella directory del progetto, c'è un file *Cargo.toml*, che ci fornisce un package. C'è anche una directory *src* che contiene *main.rs*. Apri *Cargo.toml* nel tuo editor di testo e nota che non c'è menzione di *src/main.rs*. Cargo segue una convenzione secondo cui *src/main.rs* è la radice del crate di un crate binario con lo stesso nome del package. Allo stesso modo, Cargo sa che se la directory del package contiene *src/lib.rs*, il package contiene un crate di libreria con lo stesso nome del package, e *src/lib.rs* è la sua radice del crate. Cargo passa i file di radice del crate a `rustc` per costruire la libreria o il binario.

Qui, abbiamo un package che contiene solo *src/main.rs*, il che significa che contiene solo un crate binario chiamato `my-project`. Se un package contiene *src/main.rs* e *src/lib.rs*, ha due crate: uno binario e uno di libreria, entrambi con lo stesso nome del package. Un package può avere più crate binari posizionando file nella directory *src/bin*: ogni file sarà un crate binario separato.

[modules]: ch07-02-defining-modules-to-control-scope-and-privacy.html
[rand]: ch02-00-guessing-game-tutorial.html#generating-a-random-number
