## Definire i Moduli per Controllare Scope e Privacy

In questa sezione, parleremo di moduli e altre parti del sistema dei moduli,
ovvero i *paths*, che ti permettono di nominare gli elementi; la parola
chiave `use` che porta un path nello scope; e la parola chiave `pub` per rendere
pubblici gli elementi. Discuteremo anche della parola chiave `as`, dei pacchetti
esterni e dell'operatore glob.

### Scheda di Riferimento dei Moduli

Prima di passare ai dettagli dei moduli e dei paths, forniamo un rapido
riferimento su come funzionano moduli, paths, la parola chiave `use` e la
parola chiave `pub` nel compilatore, e come la maggior parte degli sviluppatori
organizza il proprio codice. Esamineremo esempi di ciascuna di queste regole
lungo questo capitolo, ma questo è un ottimo posto a cui fare riferimento come
promemoria di come funzionano i moduli.

- **Inizia dalla radice del crate**: Quando si compila un crate, il compilatore
  guarda prima nel file radice del crate (di solito *src/lib.rs* per un crate
  di libreria o *src/main.rs* per un crate binario) per del codice da compilare.
- **Dichiarare moduli**: Nel file radice del crate, puoi dichiarare nuovi moduli;
  supponi di dichiarare un modulo "garden" con `mod garden;`. Il compilatore
  cercherà il codice del modulo in questi posti:
  - In linea, all'interno di parentesi graffe che sostituiscono il punto e
    virgola che segue `mod garden`
  - Nel file *src/garden.rs*
  - Nel file *src/garden/mod.rs*
- **Dichiarare sottomoduli**: In qualsiasi file diverso dalla radice del crate,
  puoi dichiarare sottomoduli. Ad esempio, potresti dichiarare `mod vegetables;`
  in *src/garden.rs*. Il compilatore cercherà il codice del sottomodulo
  all'interno della directory nominata per il modulo genitore in questi posti:
  - In linea, immediatamente dopo `mod vegetables`, all'interno di parentesi
    graffe invece del punto e virgola
  - Nel file *src/garden/vegetables.rs*
  - Nel file *src/garden/vegetables/mod.rs*
- **Paths al codice nei moduli**: Una volta che un modulo fa parte del tuo crate,
  puoi fare riferimento al codice in quel modulo da qualsiasi altra parte nello stesso crate,
  fintanto che le regole di privacy lo consentono, usando il path al codice.
  Ad esempio, un tipo `Asparagus` nel modulo delle verdure del giardino
  sarebbe trovato a `crate::garden::vegetables::Asparagus`.
- **Privato vs. pubblico**: Il codice all'interno di un modulo è privato rispetto
  ai suoi moduli genitori per impostazione predefinita. Per rendere un modulo
  pubblico, dichiaralo con `pub mod` invece di `mod`. Per rendere pubblici gli
  elementi all'interno di un modulo pubblico, usa `pub` prima delle loro
  dichiarazioni.
- **La parola chiave `use`**: All'interno di uno scope, la parola chiave `use`
  crea scorciatoie per gli elementi per ridurre la ripetizione di paths lunghi.
  In qualsiasi scope che può fare riferimento a
  `crate::garden::vegetables::Asparagus`, puoi creare una scorciatoia con `use
  crate::garden::vegetables::Asparagus;` e da quel momento in poi devi solo
  scrivere `Asparagus` per utilizzare quel tipo nello scope.

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

La linea `pub mod garden;` dice al compilatore di includere il codice che trova
in *src/garden.rs*, che è:

<span class="filename">Nome del file: src/garden.rs</span>

```rust,noplayground,ignore
{{#rustdoc_include ../listings/ch07-managing-growing-projects/quick-reference-example/src/garden.rs}}
```

Qui, `pub mod vegetables;` significa che anche il codice in
*src/garden/vegetables.rs* è incluso. Quel codice è:

```rust,noplayground,ignore
{{#rustdoc_include ../listings/ch07-managing-growing-projects/quick-reference-example/src/garden/vegetables.rs}}
```

Ora entriamo nei dettagli di queste regole e dimostriamole in azione!

### Raggruppare Codice Correlato in Moduli

I *moduli* ci permettono di organizzare il codice all'interno di un crate per
leggibilità e facile riutilizzo. I moduli ci permettono anche di controllare la
*privacy* degli elementi poiché il codice all'interno di un modulo è privato per
impostazione predefinita. Gli elementi privati sono dettagli di
implementazione interni non disponibili per uso esterno. Possiamo scegliere di
rendere pubblici i moduli e gli elementi al loro interno, esponendoli per
permettere al codice esterno di utilizzarli e dipenderne.

Come esempio, scriviamo un crate di libreria che fornisce la funzionalità di un
ristorante. Definiremo le firme delle funzioni ma lasceremo vuoti i loro blocchi
per concentrarci sull'organizzazione del codice piuttosto che sull'implementazione
di un ristorante.

Nell'industria della ristorazione, alcune parti di un ristorante sono
denominate *front of house* e altre *back of house*. Front of house è dove
si trovano i clienti; questo comprende dove i promotori siedono i clienti, i
camerieri prendono ordini e pagamenti, e i baristi fanno i drink. Back of house
è dove gli chef e i cuochi lavorano in cucina, i lavapiatti puliscono, e i
manager svolgono lavori amministrativi.

Per strutturare il nostro crate in questo modo, possiamo organizzare le sue
funzioni in moduli annidati. Crea una nuova libreria chiamata `restaurant`
eseguendo `cargo new restaurant --lib`. Quindi inserisci il codice nel
Listing 7-1 in *src/lib.rs* per definire alcuni moduli e le firme delle
funzioni; questo codice rappresenta la sezione front of house.

<span class="filename">Nome del file: src/lib.rs</span>

```rust,noplayground
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-01/src/lib.rs}}
```

<span class="caption">Listing 7-1: Un modulo `front_of_house` contenente altri
moduli che a loro volta contengono funzioni</span>

Definiamo un modulo con la parola chiave `mod` seguita dal nome del modulo
(in questo caso, `front_of_house`). Il corpo del modulo va quindi all'interno
di parentesi graffe. All'interno dei moduli, possiamo inserire altri moduli,
come in questo caso con i moduli `hosting` e `serving`. I moduli possono anche
contenere definizioni per altri elementi, come struct, enum, costanti, traits, e—
come nel Listing 7-1—funzioni.

Usando i moduli, possiamo raggruppare insieme definizioni correlate e nominare
perché sono correlate. I programmatori che usano questo codice possono
navigare il codice basandosi sui gruppi piuttosto che dover leggere tutte le
definizioni, rendendo più facile trovare le definizioni rilevanti per loro. I
programmatori che aggiungono nuova funzionalità a questo codice saprebbero
dove posizionare il codice per mantenere il programma organizzato.

In precedenza, abbiamo menzionato che *src/main.rs* e *src/lib.rs* sono
chiamati radici del crate. Il motivo del loro nome è che i contenuti di uno
qualsiasi di questi due file formano un modulo denominato `crate` alla radice
della struttura del modulo del crate, conosciuta come *albero dei moduli*.

Il Listing 7-2 mostra l'albero dei moduli per la struttura nel Listing 7-1.

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

<span class="caption">Listing 7-2: L'albero dei moduli per il codice nel Listing
7-1</span>

Questo albero mostra come alcuni moduli si annidano all'interno di altri moduli; ad esempio,
`hosting` si annida all'interno di `front_of_house`. L'albero mostra anche che
alcuni moduli sono *fratelli*, nel senso che sono definiti nello stesso modulo;
`hosting` e `serving` sono fratelli definiti all'interno di `front_of_house`.
Se il modulo A è contenuto all'interno del modulo B, diciamo che il modulo A è
il *figlio* del modulo B e che il modulo B è il *genitore* del modulo A. Nota
che l'intero albero dei moduli è radicato sotto il modulo implicito denominato `crate`.

L'albero dei moduli potrebbe ricordarti l'albero delle directory del filesystem
sul tuo computer; questo è un confronto molto adeguato! Proprio come le
directory in un filesystem, usi i moduli per organizzare il tuo codice. E
proprio come i file in una directory, abbiamo bisogno di un modo per trovare i
nostri moduli.
