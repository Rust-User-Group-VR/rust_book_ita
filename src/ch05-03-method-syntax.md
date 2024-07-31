## Sintassi del Metodo

*I metodi* sono simili alle funzioni: li dichiariamo con la parola chiave `fn` e un nome, possono avere parametri e un valore di ritorno, e contengono del codice che viene eseguito quando il metodo viene chiamato da qualche altra parte. A differenza delle funzioni, i metodi sono definiti nel contesto di una struct (o un enum o un trait object, che copriremo rispettivamente nel [Capitolo 6][enums]<!-- ignore --> e [Capitolo 17][trait-objects]<!-- ignore -->), e il loro primo parametro è sempre `self`, che rappresenta l'istanza della struct su cui il metodo viene chiamato.

### Definire Metodi

Cambiamo la funzione `area` che ha un'istanza di `Rectangle` come parametro e invece facciamo un metodo `area` definito sulla struct `Rectangle`, come mostrato nel Listing 5-13.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-13/src/main.rs}}
```

<span class="caption">Listing 5-13: Definire un metodo `area` sulla struct `Rectangle`</span>

Per definire la funzione nel contesto di `Rectangle`, iniziamo un blocco `impl` (implementazione) per `Rectangle`. Tutto ciò che si trova all'interno di questo blocco `impl` sarà associato al tipo `Rectangle`. Poi spostiamo la funzione `area` all'interno delle parentesi graffe dell'`impl` e cambiamo il primo (e in questo caso, unico) parametro in `self` nella firma e ovunque all'interno del corpo. In `main`, dove abbiamo chiamato la funzione `area` e passato `rect1` come argomento, possiamo invece usare la *sintassi del metodo* per chiamare il metodo `area` sulla nostra istanza di `Rectangle`. La sintassi del metodo va dopo un'istanza: aggiungiamo un punto seguito dal nome del metodo, parentesi tonde e qualsiasi argomento.

Nella firma per `area`, usiamo `&self` invece di `rectangle: &Rectangle`. Il `&self` è in realtà una forma abbreviata per `self: &Self`. All'interno di un blocco `impl`, il tipo `Self` è un alias per il tipo per cui è il blocco `impl`. I metodi devono avere un parametro chiamato `self` di tipo `Self` come loro primo parametro, quindi Rust permette di abbreviare questo con solo il nome `self` nella prima posizione del parametro. Notare che dobbiamo ancora usare il `&` davanti al `self` abbreviato per indicare che questo metodo prende in prestito l'istanza di `Self`, proprio come abbiamo fatto in `rectangle: &Rectangle`. I metodi possono prendere possesso di `self`, prendere in prestito `self` immutabilmente, come abbiamo fatto qui, o prendere in prestito `self` mutabilmente, proprio come possono fare con qualsiasi altro parametro.

Abbiamo scelto `&self` qui per lo stesso motivo per cui abbiamo usato `&Rectangle` nella versione della funzione: non vogliamo prendere possesso, e vogliamo solo leggere i dati nella struct, non scriverci. Se volessimo cambiare l'istanza su cui abbiamo chiamato il metodo come parte di ciò che il metodo fa, useremmo `&mut self` come primo parametro. Avere un metodo che prende possesso dell'istanza usando solo `self` come primo parametro è raro; questa tecnica è di solito usata quando il metodo trasforma `self` in qualcos'altro e si vuole prevenire l'utente dal usare l'istanza originale dopo la trasformazione.

Il motivo principale per usare i metodi anziché le funzioni, oltre a fornire una sintassi del metodo e non dover ripetere il tipo di `self` in ogni firma del metodo, è per l'organizzazione. Abbiamo messo tutte le cose che possiamo fare con un'istanza di un tipo in un unico blocco `impl` anziché far cercare agli utenti futuri del nostro codice le capacità di `Rectangle` in vari posti nella libreria che forniamo.

Notare che possiamo scegliere di dare a un metodo lo stesso nome di uno dei campi della struct. Ad esempio, possiamo definire un metodo su `Rectangle` che è anche chiamato `width`:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/no-listing-06-method-field-interaction/src/main.rs:here}}
```

Qui, scegliamo di fare in modo che il metodo `width` ritorni `true` se il valore nel campo `width` dell'istanza è maggiore di `0` e `false` se il valore è `0`: possiamo usare un campo all'interno di un metodo con lo stesso nome per qualsiasi scopo. In `main`, quando seguiamo `rect1.width` con delle parentesi tonde, Rust sa che intendiamo il metodo `width`. Quando non usiamo le parentesi tonde, Rust sa che intendiamo il campo `width`.

Spesso, ma non sempre, quando diamo a un metodo lo stesso nome di un campo vogliamo che solo ritorni il valore nel campo e non faccia nient'altro. Metodi come questi sono chiamati *getter*, e Rust non li implementa automaticamente per i campi della struct come fanno alcuni altri linguaggi. I getter sono utili perché puoi rendere il campo privato ma il metodo pubblico, e quindi abilitare l'accesso in sola lettura a quel campo come parte dell'API pubblica del tipo. Discuteremo cosa significano pubblico e privato e come designare un campo o un metodo come pubblico o privato nel [Capitolo 7][public]<!-- ignore -->.

> ### Dov'è l'Operatore `->`?
>
> In C e C++, si usano due operatori diversi per chiamare metodi: si usa `.` se si chiama un metodo direttamente sull'oggetto e `->` se si chiama il metodo su un puntatore all'oggetto e si ha bisogno di dereferenziare il puntatore prima. In altre parole, se `object` è un puntatore, `object->something()` è simile a `(*object).something()`.
>
> Rust non ha un equivalente dell'operatore `->`; invece, Rust ha una funzionalità chiamata *riferiemento e dereferimento automatico*. Chiamare metodi è uno dei pochi posti in Rust che ha questo comportamento.
>
> Ecco come funziona: quando chiami un metodo con `object.something()`, Rust aggiunge automaticamente `&`, `&mut`, o `*` affinché `object` corrisponda alla firma del metodo. In altre parole, i seguenti sono equivalenti:
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
> Il primo sembra molto più pulito. Questo comportamento di riferimento automatico funziona perché i metodi hanno un chiaro ricevitore, il tipo di `self`. Dato il ricevitore e il nome di un metodo, Rust può capire in modo definitivo se il metodo sta leggendo (`&self`), mutando (`&mut self`), o consumando (`self`). Il fatto che Rust renda implicito il trasferimento di proprietà per i ricevitori di metodo è una grande parte di ciò che rende la proprietà ergonomica in pratica.

### Metodi con Più Parametri

Pratichiamo l'uso dei metodi implementando un secondo metodo sulla struct `Rectangle`. Questa volta vogliamo che un'istanza di `Rectangle` prenda un'altra istanza di `Rectangle` e ritorni `true` se la seconda `Rectangle` può essere contenuta completamente all'interno di `self` (la prima `Rectangle`); altrimenti, dovrebbe ritornare `false`. Cioè, una volta che abbiamo definito il metodo `can_hold`, vogliamo essere in grado di scrivere il programma mostrato nel Listing 5-14.

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-14/src/main.rs}}
```

<span class="caption">Listing 5-14: Utilizzare il metodo `can_hold` non ancora scritto</span>

L'output previsto sarebbe simile al seguente perché entrambe le dimensioni di `rect2` sono più piccole delle dimensioni di `rect1`, ma `rect3` è più largo di `rect1`:

```text
Can rect1 hold rect2? true
Can rect1 hold rect3? false
```

Sappiamo di voler definire un metodo, quindi sarà all'interno del blocco `impl Rectangle`. Il nome del metodo sarà `can_hold` e prenderà in prestito immutabilmente un'altra `Rectangle` come parametro. Possiamo dire quale sarà il tipo del parametro guardando il codice che chiama il metodo: `rect1.can_hold(&rect2)` passa `&rect2`, che è un prestito immutabile di `rect2`, un'istanza di `Rectangle`. Questo ha senso perché dobbiamo solo leggere `rect2` (anziché scriverci, cosa che significherebbe che avremmo bisogno di un prestito mutabile), e vogliamo che `main` mantenga la proprietà di `rect2` così possiamo usarlo di nuovo dopo aver chiamato il metodo `can_hold`. Il valore di ritorno di `can_hold` sarà un valore booleano, e l'implementazione controllerà se la larghezza e l'altezza di `self` sono maggiori della larghezza e dell'altezza dell'altra `Rectangle`, rispettivamente. Aggiungiamo il nuovo metodo `can_hold` al blocco `impl` dal Listing 5-13, mostrato nel Listing 5-15.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-15/src/main.rs:here}}
```

<span class="caption">Listing 5-15: Implementare il metodo `can_hold` su `Rectangle` che prende un'altra istanza di `Rectangle` come parametro</span>

Quando eseguiamo questo codice con la funzione `main` nel Listing 5-14, otterremo il nostro output desiderato. I metodi possono avere diversi parametri che aggiungiamo alla firma dopo il parametro `self`, e quei parametri funziano proprio come i parametri nelle funzioni.

### Funzioni Associate

Tutte le funzioni definite all'interno di un blocco `impl` sono chiamate *funzioni associate* perché sono associate al tipo denominato dopo l'`impl`. Possiamo definire funzioni associate che non hanno `self` come loro primo parametro (e quindi non sono metodi) perché non necessitano di un'istanza del tipo con cui lavorare. Abbiamo già usato una funzione di questo tipo: la funzione `String::from` che è definita sul tipo `String`.

Le funzioni associate che non sono metodi sono spesso utilizzate per costruttori che ritorneranno una nuova istanza della struct. Questi sono spesso chiamati `new`, ma `new` non è un nome speciale e non è integrato nel linguaggio. Per esempio, potremmo scegliere di fornire una funzione associata chiamata `square` che avrebbe un parametro di dimensione e userebbe quello sia come larghezza che come altezza, rendendo così più facile creare un `Rectangle` quadrato piuttosto che dover specificare lo stesso valore due volte:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/no-listing-03-associated-functions/src/main.rs:here}}
```

Le parole chiave `Self` nel tipo di ritorno e nel corpo della funzione sono alias per il tipo che appare dopo la parola chiave `impl`, che in questo caso è `Rectangle`.

Per chiamare questa funzione associata, usiamo la sintassi `::` con il nome della struct; `let sq = Rectangle::square(3);` è un esempio. Questa funzione è nello spazio dei nomi della struct: la sintassi `::` è utilizzata sia per le funzioni associate che per gli spazi dei nomi creati dai moduli. Discuteremo i moduli nel [Capitolo 7][modules]<!-- ignore -->.

### Molteplici Blocchi `impl`

Ogni struct è autorizzata ad avere molteplici blocchi `impl`. Ad esempio, il Listing 5-15 è equivalente al codice mostrato nel Listing 5-16, che ha ogni metodo nel proprio blocco `impl`.

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-16/src/main.rs:here}}
```

<span class="caption">Listing 5-16: Riscrivere il Listing 5-15 usando molteplici blocchi `impl`</span>

Non c'è nessun motivo per separare questi metodi in molteplici blocchi `impl` qui, ma questa è una sintassi valida. Vedremo un caso in cui molteplici blocchi `impl` sono utili nel Capitolo 10, dove discuteremo i tipi generici e i trait.

## Sommario

Le struct ti permettono di creare tipi personalizzati significativi per il tuo dominio. Usando le struct, puoi mantenere pezzi di dati associati tra di loro e nominare ogni pezzo per rendere il tuo codice chiaro. Nei blocchi `impl`, puoi definire funzioni che sono associate al tuo tipo, e i metodi sono un tipo di funzione associata che ti permette di specificare il comportamento che le istanze delle tue struct hanno.

Ma le struct non sono l'unico modo in cui puoi creare tipi personalizzati: passiamo alla caratteristica degli enum di Rust per aggiungere un altro strumento al tuo toolbox.

[enums]: ch06-00-enums.html
[trait-objects]: ch17-02-trait-objects.md
[public]: ch07-03-paths-for-referring-to-an-item-in-the-module-tree.html#exposing-paths-with-the-pub-keyword
[modules]: ch07-02-defining-modules-to-control-scope-and-privacy.html

