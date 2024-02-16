## Definire moduli per controllare l'ambito di visibilità e la privacy

In questa sezione, parleremo di moduli e altre parti del sistema dei moduli,
ovvero i *percorsi* che ti permettono di nominare gli elementi; l'istruzione `use` che porta un
percorso nell'ambito di visibilità; e l'istruzione `pub` per rendere gli elementi pubblici. Discuteremo anche
l'istruzione `as`, i pacchetti esterni e l'operatore globale.

Iniziamo con un elenco di regole per un facile riferimento quando organizzi
il tuo codice in futuro. Poi spiegheremo ogni regola in
dettaglio.

### Foglio di Sintesi sui Moduli

Qui forniamo un rapido riferimento su come i moduli, i percorsi, l'istruzione `use`, e
l'istruzione `pub` lavorano nel compilatore, e come la maggior parte degli sviluppatori organizza il loro
codice. Andremo attraverso esempi di ognuna di queste regole in tutto questo
capitolo, ma questo è un ottimo punto di riferimento per ricordare come funzionano i moduli.

- **Inizia dalla radice della Crate**: Quando compila una crate, il compilatore guarda prima
  nel file radice della crate (generalmente *src/lib.rs* per una libreria crate o
  *src/main.rs* per una crate binaria) in cerca del codice da compilare.
- **Dichiarazione di moduli**: Nel file radice della crate, puoi dichiarare nuovi moduli;
per esempio, dichiari un modulo "giardino" con `mod giardino;`. Il compilatore cercherà il codice del modulo in questi posti:
  - Inline, all'interno di parentesi graffe che sostituiscono il punto e virgola dopo `mod
    giardino`
  - Nel file *src/giardino.rs*
  - Nel file *src/giardino/mod.rs*
- **Dichiarazione di sottomoduli**: In qualsiasi file diverso dalla radice della crate, puoi
  dichiarare sottomoduli. Ad esempio, potresti dichiarare `mod verdure;` in
  *src/giardino.rs*. Il compilatore cercherà il codice del sottomodulo all'interno della
  directory denominata per il modulo padre in questi luoghi:
  - Inline, direttamente dopo `mod verdure`, all'interno delle parentesi graffe al posto del punto e virgola
  - Nel file *src/giardino/verdure.rs*
  - Nel file *src/giardino/verdure/mod.rs*
- **Percorsi al codice nei moduli**: Una volta che un modulo è parte della tua crate, puoi
  fare riferimento al codice in quel modulo da qualsiasi altra parte in quella stessa crate, finché le regole di privacy lo consentono, usando il percorso al codice. Ad esempio, un tipo `Asparago` nel modulo verdure del giardino sarebbe trovato a
  `crate::giardino::verdure::Asparago`.
- **Privato vs pubblico**: Il codice all'interno di un modulo è privato dai suoi moduli genitore
  per impostazione predefinita. Per rendere un modulo pubblico, dichiaralo con `pub mod`
  invece di `mod`. Per rendere pubblici anche gli elementi all'interno di un modulo pubblico, usa
  `pub` prima delle loro dichiarazioni.
- **L'istruzione `use`**: All'interno di un ambito di visibilità, l'istruzione `use` crea scorciatoie a
  elementi per ridurre la ripetizione di percorsi lunghi. In qualsiasi ambito di visibilità che può fare riferimento a
  `crate::giardino::verdure::Asparago`, puoi creare una scorciatoia con `use
  crate::giardino::verdure::Asparago;` e da quel momento devi solo scrivere `Asparago` per utilizzare quel tipo nell'ambito di visibilità.

Qui creiamo una crate binaria chiamata `cortile` che illustra queste regole. La
directory della crate, anche chiamata `cortile`, contiene questi file e directory:

```text
cortile
├── Cargo.lock
├── Cargo.toml
└── src
    ├── giardino
    │   └── verdure.rs
    ├── giardino.rs
    └── main.rs
```

Il file radice della crate in questo caso è *src/main.rs*, e contiene:

<span class="filename">Nome file: src/main.rs</span>

```rust,noplayground,ignore
{{#rustdoc_include ../listings/ch07-managing-growing-projects/quick-reference-example/src/main.rs}}
```

La linea `pub mod giardino;` dice al compilatore di includere il codice che trova in
*src/giardino.rs*, che è:

<span class="filename">Nome file: src/giardino.rs</span>

```rust,noplayground,ignore
{{#rustdoc_include ../listings/ch07-managing-growing-projects/quick-reference-example/src/giardino.rs}}
```

Qui, `pub mod verdure;` significa che il codice in *src/giardino/verdure.rs* è
incluso anche. Quel codice è:

```rust,noplayground,ignore
{{#rustdoc_include ../listings/ch07-managing-growing-projects/quick-reference-example/src/giardino/verdure.rs}}
```

Ora entreremo nei dettagli di queste regole e li mostreremo in azione!

### Raggruppare Codice Correlato nei Moduli

I *moduli* ci permettono di organizzare il codice all'interno di una crate per leggibilità e facilità di riutilizzo.
I moduli ci consentono anche di controllare la *privacy* degli elementi, perché il codice all'interno di un
modulo è privato per default. Gli elementi privati sono dettagli di implementazione interna
non disponibili per l'uso esterno. Possiamo scegliere di rendere i moduli e gli elementi
in essi pubblici, che li espone per consentire al codice esterno di utilizzarli e dipenderne.

Come esempio, scriviamo una libreria crate che fornisce la funzionalità di un
ristorante. Definiremo le firme delle funzioni, ma lasceremo i loro corpi
vuoti per concentrarci sull'organizzazione del codice, piuttosto che sull'implementazione di un ristorante.

Nell'industria della ristorazione, alcune parti di un ristorante vengono definite come
*front of house* e altre come *back of house*. Il front of house è dove
ci sono i clienti; ciò include il luogo in cui gli host fanno sedere i clienti, i camerieri prendono
ordini e pagamenti, e i barman preparano le bevande. Il back of house è dove i
cuochi e i cuochi lavorano in cucina, i lavapiatti puliscono, e i manager si occupano di
lavoro amministrativo.

Per strutturare la nostra crate in questo modo, possiamo organizzare le sue funzioni in moduli annidati.
Crea una nuova libreria chiamata `ristorante` eseguendo `cargo new ristorante --lib`; poi inserisci il codice nell'Esempio 7-1 in *src/lib.rs* per
definire alcuni moduli e firme delle funzioni. Ecco la sezione front of house:

<span class="filename">Nome file: src/lib.rs</span>

```rust,noplayground
{{#rustdoc_include ../listings/ch07-managing-growing-projects/listing-07-01/src/lib.rs}}
```

<span class="caption">Esempio 7-1: Un modulo `front_of_house` che contiene altri
moduli che a loro volta contengono funzioni</span>

Definiamo un modulo con l'istruzione `mod` seguita dal nome del modulo
(in questo caso, `front_of_house`). Il corpo del modulo poi va all'interno delle parentesi graffe.
All'interno dei moduli, possiamo inserire altri moduli, come in questo caso con i
moduli `hosting` e `serving`. I moduli possono anche contenere definizioni per altri
elementi, come struct, enum, costanti, traits, e - come nell'Esempio
7-1 - funzioni.

Utilizzando i moduli, possiamo raggruppare le definizioni correlate insieme e nominarle perché
sono correlate. Gli sviluppatori che utilizzano questo codice possono navigare il codice in base ai
gruppi piuttosto che dover leggere tutte le definizioni, rendendo più facile trovare le definizioni rilevanti per loro. Gli sviluppatori che aggiungono nuove funzionalità
a questo codice saprebbero dove posizionare il codice per mantenere il programma organizzato.

Prima, abbiamo menzionato che *src/main.rs* e *src/lib.rs* si chiamano radici delle crate.
Il motivo del loro nome è che i contenuti di uno di questi due
i file formano un modulo chiamato `crate` alla radice della struttura del modulo della crate,
conosciuta come *albero dei moduli*.

L'Esempio 7-2 mostra l'albero dei moduli per la struttura nell'Esempio 7-1.

```text
crate
 └── front_of_house
     ├── hosting
     │   ├── aggiungi_alla_lista_d_attesa
     │   └── una_tavolo
     └── serving
         ├── prendi_ordine
         ├── servizio_ordine
         └── ricezione_pagamento
```

<span class="caption">Esempio 7-2: L'albero dei moduli per il codice nell'Esempio
7-1</span>

Questo albero mostra come alcuni moduli si annidano l'uno dentro l'altro; ad esempio,
`hosting` si annida all'interno di `front_of_house`. L'albero mostra anche che alcuni moduli
sono *fratelli* tra di loro, il che significa che sono definiti nello stesso modulo;
`hosting` e `serving` sono fratelli definiti all'interno di `front_of_house`. Se il modulo
A è contenuto all'interno del modulo B, diciamo che il modulo A è il *figlio* del modulo B
e che il modulo B è il *genitore* del modulo A. Nota che l'intero albero dei moduli
ha radice sotto il modulo implicito denominato `crate`.

L'albero dei moduli potrebbe ricordarti l'albero delle directory del sistema dei file del tuo
computer; questo è un paragone molto appropriato! Proprio come le directory in un sistema di file,
usi i moduli per organizzare il tuo codice. E proprio come i file in una directory, abbiamo
bisogno di un modo per trovare i nostri moduli.

