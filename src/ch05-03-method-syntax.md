## Sintassi del metodo

I *metodi* sono simili alle funzioni: li dichiariamo con la parola chiave `fn` e un
nome, possono avere parametri e un valore di ritorno, e contengono un po' di codice
che viene eseguito quando il metodo viene chiamato da qualche altra parte. A differenza delle funzioni,
i metodi sono definiti nel contesto di una struct (o di un enum o di un object trait, che copriamo nel [Capitolo 6][enums]<!-- ignore --> e nel [Capitolo 17][trait-objects]<!-- ignore -->, rispettivamente), e il loro primo parametro è
sempre `self`, che rappresenta l'istanza della struct su cui sta venendo chiamato il metodo.

### Definizione dei metodi

Modifichiamo la funzione `area` che ha un'istanza di `Rectangle` come parametro
e invece creiamo un metodo `area` definito sulla struct `Rectangle`, come mostrato
nella Listing 5-13.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-13/src/main.rs}}
```

<span class="caption">Listing 5-13: Definizione di un metodo `area` sulla
struct `Rectangle`</span>

Per definire la funzione nel contesto di `Rectangle`, iniziamo un blocco `impl`
(d'implementazione) per `Rectangle`. Tutto ciò che si trova all'interno di questo blocco `impl`
sarà associato con il tipo `Rectangle`. Poi spostiamo la funzione `area` all'interno delle parentesi graffe di `impl` e cambiamo il primo (e in questo caso, unico)
parametro in `self` nella firma e ovunque all'interno del corpo. In
`main`, dove abbiamo chiamato la funzione `area` e passato `rect1` come un argomento,
possiamo invece usare la *sintassi del metodo* per chiamare il metodo `area` sulla nostra istanza di `Rectangle`.
La sintassi del metodo segue un'istanza: aggiungiamo un punto seguito dal
nome del metodo, parentesi, e qualsiasi argomento.

Nella firma per `area`, usiamo `&self` invece di `rectangle: &Rectangle`.
Il `&self` è in realtà un abbreviazione per `self: &Self`. All'interno di un blocco `impl`, il
tipo `Self` è un alias per il tipo per il quale il blocco `impl` è. I metodi devono
avere un parametro chiamato `self` di tipo `Self` come loro primo parametro, quindi Rust
ti permette di abbreviare questo con solo il nome `self` nel primo posto per i parametri.
Nota che dobbiamo ancora usare `&` davanti alla abbreviazione di `self`
per indicare che questo metodo prende in prestito l'istanza di `Self`, proprio come abbiamo fatto in
`rectangle: &Rectangle`. I metodi possono prendere il possesso di `self`, prendere in prestito `self`
immutabilmente, come abbiamo fatto qui, oppure prendere in prestito `self` mutabilmente, proprio come possono fare con qualsiasi
altro parametro.

Abbiamo scelto `&self` qui per la stessa ragione per cui abbiamo usato `&Rectangle` nella versione della funzione:
non vogliamo prendere il possesso, e vogliamo solo leggere i dati nella
struct, non scriverci. Se volessimo cambiare l'istanza su cui abbiamo
chiamato il metodo come parte di ciò che il metodo fa, useremmo `&mut self` come
il primo parametro. Avere un metodo che prende il possesso dell'istanza usando solo `self` come il primo parametro è raro; questa tecnica è solitamente
usata quando il metodo trasforma `self` in qualcos'altro e vuoi
impedire al chiamante di usare l'istanza originale dopo la trasformazione.

La ragione principale per usare i metodi invece delle funzioni, oltre a
fornire la sintassi del metodo e non dover ripetere il tipo di `self` in ogni
firma del metodo, è per l'organizzazione. Abbiamo messo tutte le cose che possiamo fare
con un'istanza di un tipo in un unico blocco `impl` piuttosto che fare cercare ai futuri utenti
delle nostre capacità di `Rectangle` in vari luoghi nella
libreria che forniamo.

Nota che possiamo scegliere di dare a un metodo lo stesso nome di uno dei campi della struct.
Ad esempio, possiamo definire un metodo su `Rectangle` che si chiama anche
`width`:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/no-listing-06-method-field-interaction/src/main.rs:here}}
```

Qui, stiamo scegliendo di fare in modo che il metodo `width` restituisca `true` se il valore nel
campo `width` dell'istanza è maggiore di `0` e `false` se il valore è
`0`: possiamo usare un campo all'interno di un metodo con lo stesso nome per qualsiasi scopo. In `main`, quando seguiamo `rect1.width` con parentesi, Rust sa che intendiamo il metodo `width`. Quando non usiamo le parentesi, Rust sa che intendiamo il campo `width`.

Spesso, ma non sempre, quando diamo a un metodo lo stesso nome di un campo vogliamo
che restituisca solo il valore nel campo e non faccia nulla d'altro. Metodi come questo
sono chiamati *gettatori*, e Rust non li implementa automaticamente per i campi della struct come fanno alcuni altri linguaggi. I gettatori sono utili perché puoi rendere il
campo privato ma il metodo pubblico, e quindi abilitare l'accesso in sola lettura a quel campo come parte dell'API pubblica del tipo. Discuteremo cosa sono i termini pubblico e privato e come designare un campo o un metodo come pubblico o privato nel [Capitolo 7][public]<!-- ignore -->.

> ### Dov'è l'operatore `->`?
>
> In C e C++, si usano due operatori differenti per chiamare i metodi: si usa
> `.` se si sta chiamando un metodo sull'oggetto direttamente e `->` se si sta
> chiamando il metodo su un puntatore all'oggetto e si ha bisogno di effettuare il dereferenziamento del
> puntatore prima. In altre parole, se `object` è un puntatore,
> `object->something()` è simile a `(*object).something()`.
>
> Rust non ha un equivalente per l'operatore `->`; invece, Rust ha una
> caratteristica chiamata *riferenziamento e dereferenziamento automatico*. Chiamare metodi è
> uno dei pochi posti in Rust che ha questo comportamento.
>
> Ecco come funziona: quando chiami un metodo con `object.something()`, Rust
> aggiunge automaticamente `&`, `&mut`, o `*` in modo che `object` corrisponda alla firma del
> metodo. In altre parole, i seguenti sono la stessa cosa:
>
> <!-- CAN'T EXTRACT SEE BUG https://github.com/rust-lang/mdBook/issues/1127 -->
> ```rust
> # #[derive(Debug,Copy,Clone)]
> # struct Point {
> #     x: f64,
> #     y: f64,
> # }
> #
> # impl Point {
> #    fn distance(&self, other: &Point) -> f64 {
> #        let x_squared = f64::powi(other.x - self.x, 2);
> #        let y_squared = f64::powi(other.y - self.y, 2);
> #
> #        f64::sqrt(x_squared + y_squared)
> #    }
> # }
> # let p1 = Point { x: 0.0, y: 0.0 };
> # let p2 = Point { x: 5.0, y: 6.5 };
> p1.distance(&p2);
> (&p1).distance(&p2);
> ```
>
> Il primo sembra molto più pulito. Questo comportamento di riferenziamento automatico funziona
> perché i metodi hanno un ricevitore chiaro: il tipo di `self`. Data la ricevente
> e il nome di un metodo, Rust può capire definitivamente se il metodo sta
> leggendo (`&self`), cambiando (`&mut self`), o consumando (`self`). Il fatto
> che Rust renda implicito il prestito per i ricevitori del metodo è una grande parte di
> come rendere il possesso ergonomico nella pratica.

### Metodi con più parametri


Facciamo pratica utilizzando i metodi implementando un secondo metodo sullo struct `Rectangle`. Questa volta vogliamo che un'istanza di `Rectangle` prenda un'altra istanza di `Rectangle` e restituisca `true` se il secondo `Rectangle` può adattarsi completamente all'interno di `self` (il primo `Rectangle`); altrimenti, dovrebbe restituire `false`. Cioè, una volta definito il metodo `can_hold`, vogliamo essere in grado di scrivere il programma mostrato nella Listing 5-14.

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-14/src/main.rs}}
```

<span class="caption">Listing 5-14: Utilizzo del metodo ancora non scritto `can_hold`</span>

L'output previsto dovrebbe apparire come il seguente perché entrambe le dimensioni di `rect2` sono più piccole delle dimensioni di `rect1`, ma `rect3` è più largo di `rect1`:

```text
Can rect1 hold rect2? true
Can rect1 hold rect3? false
```

Sappiamo che vogliamo definire un metodo, quindi sarà all'interno del blocco `impl Rectangle`. Il nome del metodo sarà `can_hold`, e prenderà in prestito immutabile un altro `Rectangle` come parametro. Possiamo capire qual sarà il tipo del parametro guardando il codice che chiama il metodo: `rect1.can_hold(&rect2)` passa `&rect2`, che è un prestito immutabile a `rect2`, un'istanza di `Rectangle`. Questo ha senso perché abbiamo solo bisogno di leggere `rect2` (piuttosto che scrivere, che avrebbe significato che avremmo avuto bisogno di un prestito mutabile), e vogliamo che `main` mantenga l'ownership di `rect2` così possiamo usarlo di nuovo dopo aver chiamato il metodo `can_hold`. Il valore di ritorno di `can_hold` sarà un Booleano, e l'implementazione controllerà se la larghezza e l'altezza di `self` sono maggiori rispettivamente della larghezza e dell'altezza dell'altro `Rectangle`. Aggiungiamo il nuovo metodo `can_hold` al blocco `impl` dalla Listing 5-13, mostrato nella Listing 5-15.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-15/src/main.rs:here}}
```

<span class="caption">Listing 5-15: Implementazione del metodo `can_hold` su `Rectangle` che prende un'altra istanza di `Rectangle` come parametro</span>

Quando eseguiamo questo codice con la funzione `main` nella Listing 5-14, otteniamo l'output desiderato. I metodi possono avere più parametri che aggiungiamo alla firma dopo il parametro `self`, e tali parametri funzionano proprio come i parametri nelle funzioni.

### Funzioni Associate

Tutte le funzioni definite all'interno di un blocco `impl` sono chiamate *funzioni associate* perché sono associate al tipo nominato dopo l'`impl`. Possiamo definire funzioni associate che non hanno `self` come primo parametro (e quindi non sono metodi) perché non hanno bisogno di un'istanza del tipo con cui lavorare. Abbiamo già usato una funzione di questo tipo: la funzione `String::from` che è definita sul tipo `String`.

Le funzioni associate che non sono metodi vengono spesso utilizzate per i costruttori che restituiranno una nuova istanza dello struct. Questi sono spesso chiamati `new`, ma `new` non è un nome speciale e non è incorporato nel linguaggio. Ad esempio, potremmo scegliere di fornire una funzione associata chiamata `square` che avrebbe un parametro di dimensione e lo userebbe sia come larghezza che altezza, rendendo così più facile creare un `Rectangle` quadrato piuttosto che dover specificare lo stesso valore due volte:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/no-listing-03-associated-functions/src/main.rs:here}}
```

Le parole chiave `Self` nel tipo di ritorno e nel corpo della funzione sono alias per il tipo che appare dopo la parola chiave `impl`, che in questo caso è `Rectangle`.

Per chiamare questa funzione associata, utilizziamo la sintassi `::` con il nome dello struct; `let sq = Rectangle::square(3);` è un esempio. Questa funzione è nel namespace dello struct: la sintassi `::` viene utilizzata sia per le funzioni associate che per i namespace creati dai moduli. Discuteremo i moduli nel [Capitolo 7][modules]<!-- ignore -->.

### Multipli Blocchi `impl`

Ogni struct è autorizzato ad avere più blocchi `impl`. Ad esempio, la Listing 5-15 è equivalente al codice mostrato nella Listing 5-16, che ha ciascun metodo nel suo blocco `impl`.

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-16/src/main.rs:here}}
```

<span class="caption">Listing 5-16: Riscrittura della Listing 5-15 utilizzando multipli blocchi `impl`</span>

Non c'è motivo di separare questi metodi in più blocchi `impl` qui, ma questa è sintassi valida. Vedremo un caso in cui più blocchi `impl` sono utili nel Capitolo 10, dove discutiamo i tipi generici e i trait.

## Sommario

Gli Struct ti permettono di creare tipi personalizzati che sono significativi per il tuo dominio. Utilizzando gli struct, puoi mantenere pezzi di dati associati collegati tra di loro e nominare ogni pezzo per rendere il tuo codice chiaro. Nei blocchi `impl`, puoi definire funzioni che sono associate al tuo tipo, e i metodi sono un tipo di funzione associata che ti permette di specificare il comportamento che hanno le istanze dei tuoi struct.

Ma gli struct non sono l'unico modo in cui puoi creare tipi personalizzati: passiamo alla funzionalità enum di Rust per aggiungere un altro strumento alla tua cassetta degli attrezzi.

[enums]: ch06-00-enums.html
[trait-objects]: ch17-02-trait-objects.md
[public]: ch07-03-paths-for-referring-to-an-item-in-the-module-tree.html#exposing-paths-with-the-pub-keyword
[modules]: ch07-02-defining-modules-to-control-scope-and-privacy.html

