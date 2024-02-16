## Pacchetti e Crates

Le prime parti del sistema dei moduli che copriremo sono i pacchetti e le crates.

Una *crate* è la più piccola quantità di codice che il compilatore Rust considera alla volta. Anche se esegui `rustc` piuttosto che `cargo` e passi un singolo file di codice sorgente (come abbiamo fatto all'inizio nel capitolo "Scrivere ed Eseguire un Programma Rust" del Capitolo 1), il compilatore considera quel file come una crate. Le crates possono contenere moduli, e i moduli possono essere definiti in altri file che vengono compilati con la crate, come vedremo nelle prossime sezioni.

Una crate può presentarsi in due forme: una crate binaria o una crate di libreria.
Le *crates binarie* sono programmi che puoi compilare in un eseguibile che puoi eseguire, come un programma da riga di comando o un server. Ognuna deve avere una funzione chiamata `main` che definisce cosa succede quando l'eseguibile viene eseguito. Tutte le crates che abbiamo creato finora sono state crates binarie.

Le *crates di libreria* non hanno una funzione `main`, e non vengono compilate in un eseguibile. Invece, definiscono funzionalità destinate a essere condivise con più progetti. Ad esempio, la crate `rand` che abbiamo usato nel [Capitolo 2][rand]<!-- ignore --> fornisce funzionalità che genera numeri casuali. La maggior parte del tempo quando i Rustaceans dicono “crate”, intendono la crate di libreria, e usano “crate” in modo intercambiabile con il concetto di programmazione generale di una “libreria".

La *radice della crate* è un file sorgente da cui il compilatore Rust inizia e costituisce il modulo radice della tua crate (spiegheremo i moduli in profondità nella sezione [“Definire Moduli per Controllare lo Scope e la Privacy”][modules]<!-- ignore -->).

Un *pacchetto* è un insieme di una o più crates che fornisce un insieme di funzionalità. Un pacchetto contiene un file *Cargo.toml* che descrive come costruire quelle crates. Cargo è in realtà un pacchetto che contiene la crate binaria per lo strumento da riga di comando che hai usato per costruire il tuo codice. Il pacchetto Cargo contiene anche una crate di libreria su cui dipende la crate binaria. Altri progetti possono dipendere dalla crate di libreria di Cargo per utilizzare la stessa logica che utilizza lo strumento da riga di comando di Cargo.

Un pacchetto può contenere quante più crates binarie vuoi, ma al massimo solo una crate di libreria. Un pacchetto deve contenere almeno una crate, che sia una crate di libreria o binaria.

Facciamo un giro su cosa succede quando creiamo un pacchetto. Per prima cosa, inseriamo il comando `cargo new`:

```console
$ cargo new my-project
     Created binary (application) `my-project` package
$ ls my-project
Cargo.toml
src
$ ls my-project/src
main.rs
```

Dopo aver eseguito `cargo new`, usiamo `ls` per vedere cosa crea Cargo. Nella directory del progetto, c'è un file *Cargo.toml*, che ci dà un pacchetto. C'è anche una directory *src* che contiene *main.rs*. Apri *Cargo.toml* nel tuo editor di testo, e noterai che non c'è alcuna menzione di *src/main.rs*. Cargo segue una convenzione secondo la quale *src/main.rs* è la radice della crate di una crate binaria con lo stesso nome del pacchetto. Allo stesso modo, Cargo sa che se la directory del pacchetto contiene *src/lib.rs*, il pacchetto contiene una crate di libreria con lo stesso nome del pacchetto, e *src/lib.rs* è la sua radice della crate. Cargo passa i file della radice della crate a `rustc` per costruire la libreria o il binario.

Qui, abbiamo un pacchetto che contiene solo *src/main.rs*, il che significa che contiene solo una crate binaria chiamata `my-project`. Se un pacchetto contiene *src/main.rs* e *src/lib.rs*, ha due crates: una binaria e una di libreria, entrambe con lo stesso nome del pacchetto. Un pacchetto può avere più crates binarie posizionando i file nella directory *src/bin*: ogni file sarà una crate binaria separata.

[modules]: ch07-02-defining-modules-to-control-scope-and-privacy.html
[rand]: ch02-00-guessing-game-tutorial.html#generating-a-random-number
