## Package e Crates

Le prime parti del sistema dei moduli che tratteremo sono i package e i crates.

Un *crate* è la quantità minima di codice che il compilatore Rust considera in un dato momento. Anche se esegui `rustc` invece di `cargo` e passi un singolo file di codice sorgente (come abbiamo fatto nella sezione “Scrivere ed Eseguire un Programma Rust” del Capitolo 1), il compilatore considera quel file come un crate. I Crates possono contenere moduli, e i moduli possono essere definiti in altri file che vengono compilati con il crate, come vedremo nelle sezioni a venire.

Un crate può essere di due forme: un crate binario o un crate libreria. I *crate binari* sono programmi che puoi compilare in un eseguibile che puoi eseguire, come un programma da linea di comando o un server. Ciascuno deve avere una funzione chiamata `main` che definisce cosa succede quando l'eseguibile viene eseguito. Tutti i crate che abbiamo creato finora sono stati crate binari.

I *library crates* non hanno una funzione `main` e non vengono compilati in un eseguibile. Invece, definiscono funzionalità destinate a essere condivise tra più progetti. Ad esempio, il crate `rand` che abbiamo utilizzato nel [Capitolo 2][rand]<!-- ignore --> fornisce funzionalità che generano numeri casuali. La maggior parte delle volte quando i Rustaceans dicono “crate”, intendono il crate libreria, e usano “crate” in modo intercambiabile con il concetto generale di programmazione di una “libreria”.

Il *crate root* è un file sorgente da cui il compilatore Rust parte e costituisce il modulo radice del tuo crate (spiegheremo i moduli in dettaglio nella sezione [“Definire Moduli per Controllare Scope e Privacy”][modules]<!-- ignore -->).

Un *package* è un insieme di uno o più crate che fornisce un insieme di funzionalità. Un package contiene un file *Cargo.toml* che descrive come costruire quei crate. Cargo è in realtà un package che contiene il crate binario per lo strumento a linea di comando che hai utilizzato per costruire il tuo codice. Il package Cargo contiene anche un crate libreria da cui il crate binario dipende. Altri progetti possono dipendere dal crate libreria Cargo per usare la stessa logica che usa lo strumento a linea di comando Cargo. Un package può contenere quanti crate binari vuoi, ma al massimo solo un crate libreria. Un package deve contenere almeno un crate, sia che si tratti di un crate libreria o binario.

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

Dopo aver eseguito `cargo new my-project`, usiamo `ls` per vedere cosa crea Cargo. Nella directory del progetto, c'è un file *Cargo.toml*, dandoci un package. C'è anche una directory *src* che contiene *main.rs*. Apri *Cargo.toml* nel tuo editor di testo e nota che non c'è menzione di *src/main.rs*. Cargo segue una convenzione secondo cui *src/main.rs* è il crate root di un crate binario con lo stesso nome del package. Allo stesso modo, Cargo sa che se la directory del package contiene *src/lib.rs*, il package contiene un crate libreria con lo stesso nome del package, e *src/lib.rs* è il suo crate root. Cargo passa i file del crate root a `rustc` per costruire la libreria o il binario.

Qui, abbiamo un package che contiene solo *src/main.rs*, il che significa che contiene solo un crate binario chiamato `my-project`. Se un package contiene *src/main.rs* e *src/lib.rs*, ha due crate: un binario e una libreria, entrambi con lo stesso nome del package. Un package può avere più crate binari posizionando i file nella directory *src/bin*: ciascun file sarà un crate binario separato.

[modules]: ch07-02-defining-modules-to-control-scope-and-privacy.html
[rand]: ch02-00-guessing-game-tutorial.html#generating-a-random-number
