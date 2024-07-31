## Definire Moduli per Controllare l'Ambito e la Privacy

In questa sezione parleremo dei moduli e di altre parti del sistema dei moduli,
ovvero dei *percorsi*, che ti permettono di dare un nome agli elementi; della parola chiave `use` che porta un percorso nell'ambito; e della parola chiave `pub` per rendere pubblici gli elementi. Discuteremo anche della parola chiave `as`, dei pacchetti esterni e dell'operatore glob.

### Riepilogo sui Moduli

Prima di entrare nei dettagli dei moduli e dei percorsi, forniamo un rapido
riferimento su come funzionano i moduli, i percorsi, la parola chiave `use` e la parola chiave `pub` nel compilatore e su come la maggior parte degli sviluppatori organizza il proprio codice. Vedremo esempi di ciascuna di queste regole in tutto questo capitolo, ma questo è un ottimo posto a cui fare riferimento come promemoria su come funzionano i moduli.

- **Inizia dalla radice del crate**: Quando compili un crate, il compilatore cerca
  prima nel file radice del crate (di solito *src/lib.rs* per un crate di libreria o
  *src/main.rs* per un crate binario) il codice da compilare.
- **Dichiarare moduli**: Nel file radice del crate, puoi dichiarare nuovi moduli;
ad esempio puoi dichiarare un modulo “garden” con `mod garden;`. Il compilatore cercherà
il codice del modulo in questi luoghi:
  - Inline, tra parentesi graffe che sostituiscono il punto e virgola dopo `mod
    garden`
  - Nel file *src/garden.rs*
  - Nel file *src/garden/mod.rs*
- **Dichiarare sottomoduli**: In qualsiasi file diverso dalla radice del crate, puoi
  dichiarare sottomoduli. Ad esempio, puoi dichiarare `mod vegetables;` in
  *src/garden.rs*. Il compilatore cercherà il codice del sottomodulo all'interno della
  directory denominata come il modulo padre in questi luoghi:
  - Inline, direttamente dopo `mod vegetables`, tra parentesi graffe anziché
    il punto e virgola
  - Nel file *src/garden/vegetables.rs*
  - Nel file *src/garden/vegetables/mod.rs*
- **Percorsi verso il codice nei moduli**: Una volta che un modulo fa parte del tuo crate,
  puoi fare riferimento al codice in quel modulo da qualsiasi altra parte nello stesso crate,
  purché le regole di privacy lo permettano, utilizzando il percorso verso il codice. Ad esempio, un
  tipo `Asparagus` nel modulo vegetables del giardino si troverà in
  `crate::garden::vegetables::Asparagus`.
- **Privato vs. pubblico**: Il codice all'interno di un modulo è privato rispetto ai suoi moduli genitori
  per impostazione predefinita. Per rendere un modulo pubblico, dichiaralo con `pub mod`
  anziché `mod`. Per rendere pubblici anche gli elementi all'interno di un modulo pubblico, usa
  `pub` davanti alle loro dichiarazioni.
- **La parola chiave `use`**: All'interno di un ambito, la parola chiave `use` crea scorciatoie per
  gli elementi per ridurre la ripetizione di percorsi lunghi. In qualsiasi ambito che può fare riferimento a
  `crate::garden::vegetables::Asparagus`, puoi creare una scorciatoia con `use
  crate::garden::vegetables::Asparagus;` e da quel momento in poi devi solo
  scrivere `Asparagus` per utilizzare quel tipo nell'ambito.

Qui, creiamo un crate binario chiamato `backyard` che illustra queste regole.
La directory del crate, anch'essa chiamata `backyard`, contiene questi file e
directory:

```text
backyard
├── Cargo.lock
├── Cargo.toml
└── src
    ├── garden
    │   └── vegetables.rs
    ├── garden.rs
    └── main.rs
```

Il file radice del crate in questo caso è *src/main.rs*, e contiene:

<span class="filename">Nome del file: src/main.rs</span>

```rust,noplayground,ignore
{{#rustdoc_include ../listings/ch07-managing-growing-projects/quick-reference-example/src/main.rs}}
```

La linea `pub mod garden;` dice al compilatore di includere il codice che trova in
*src/garden.rs*, che è:

<span class="filename">Nome del file: src/garden.rs</span>

```rust,noplayground,ignore
{{#rustdoc_include ../listings/ch07-managing-growing-projects/quick-reference-example/src/garden.rs}}
```

Qui, `pub mod vegetables;` significa che anche il codice in *src/garden/vegetables.rs* è
incluso. Quel codice è:

```rust,noplayground,ignore
{{#rustdoc_include ../listings/ch07-managing-growing-projects/quick-reference-example/src/garden/vegetables.rs}}
```

Ora entriamo nei dettagli di queste regole e dimostriamole in azione!

### Raggruppare Codice Correlato in Moduli

I *moduli* ci permettono di organizzare il codice all'interno di un crate per una migliore leggibilità e facile riutilizzo.
I moduli ci permettono anche di controllare la *privacy* degli elementi poiché il codice all'interno di un
modulo è privato per impostazione predefinita. Gli elementi privati sono dettagli di implementazione interna
non disponibili per l'uso esterno. Possiamo scegliere di rendere pubblici i moduli e gli elementi
contenuti, esponendoli per consentire al codice esterno di utilizzarli e dipendere su di essi.

Ad esempio, scriviamo un crate di libreria che fornisce la funzionalità di un
ristorante. Definiremo le firme delle funzioni ma lasceremo i loro corpi
vuoti per concentrarci sull'organizzazione del codice piuttosto che sull'implementazione
di un ristorante.

Nell'industria della ristorazione, alcune parti di un ristorante sono denominate
*front of house* e altre *back of house*. Il front of house è dove
si trovano i clienti; questo include dove i camerieri accolgono i clienti, i camerieri prendono
ordini e pagamenti e i baristi preparano i drink. Il back of house è dove gli
chef e i cuochi lavorano in cucina, i lavapiatti puliscono e i gestori fanno
lavori amministrativi.

Per strutturare il nostro crate in questo modo, possiamo organizzare le sue funzioni in moduli
nidificati. Crea una nuova libreria chiamata `restaurant` eseguendo `cargo new
restaurant --lib`. Poi inserisci il codice in Listing 7-1 in *src/lib.rs* per
definire alcuni moduli e le firme delle funzioni; questo codice è la sezione front of house.

<span class="filename">Nome del file: src/lib.rs</span>

```rust,noplayground
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-01/src/lib.rs}}
```

<span class="caption">Elenco 7-1: Un modulo `front_of_house` che contiene altri moduli che a loro volta contengono funzioni</span>

Definiamo un modulo con la parola chiave `mod` seguita dal nome del modulo
(in questo caso, `front_of_house`). Il corpo del modulo va poi dentro parentesi
graffe. All'interno dei moduli, possiamo posizionare altri moduli, come in questo caso con i
moduli `hosting` e `serving`. I moduli possono anche contenere definizioni per altri
elementi, come struct, enum, costanti, trait, e — come in Listing
7-1 — funzioni.

Utilizzando i moduli, possiamo raggruppare definizioni correlate insieme e dire perché
sono correlate. I programmatori che usano questo codice possono navigare
nel codice in base ai gruppi anziché dover leggere tutte le definizioni, rendendo più facile
trovare le definizioni rilevanti per loro. I programmatori che aggiungono nuova funzionalità
a questo codice sapranno dove posizionare il codice per mantenere l'organizzazione del programma.

In precedenza, abbiamo menzionato che *src/main.rs* e *src/lib.rs* sono chiamati radici
del crate. Il motivo del loro nome è che il contenuto di uno di questi due
file forma un modulo chiamato `crate` alla radice della struttura del modulo
del crate, noto come *albero del modulo*.

L'elenco 7-2 mostra l'albero del modulo per la struttura nell'elenco 7-1.

```text
crate
 └── front_of_house
     ├── hosting
     │   ├── add_to_waitlist
     │   └── seat_at_table
     └── serving
         ├── take_order
         ├── serve_order
         └── take_payment
```

<span class="caption">Elenco 7-2: L'albero del modulo per il codice nell'elenco
7-1</span>

Questo albero mostra come alcuni moduli si nidificano all'interno di altri moduli; ad esempio,
`hosting` si nidifica dentro `front_of_house`. L'albero mostra anche che alcuni moduli
sono *fratelli*, cioè sono definiti nello stesso modulo; `hosting` e
`serving` sono fratelli definiti dentro `front_of_house`. Se il modulo A è
contenuto dentro il modulo B, diciamo che il modulo A è il *figlio* del modulo B e
che il modulo B è il *genitore* del modulo A. Nota che l'intero albero dei moduli
è radicato sotto il modulo implicito chiamato `crate`.

L'albero del modulo potrebbe ricordarti l'albero delle directory nel filesystem sul tuo
computer; questo è un paragone molto appropriato! Proprio come le directory in un filesystem,
usiamo i moduli per organizzare il nostro codice. E proprio come i file in una directory, abbiamo
bisogno di un modo per trovare i nostri moduli.
