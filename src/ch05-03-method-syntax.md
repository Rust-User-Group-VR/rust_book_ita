## Sintassi dei Metodi

*Metodi* sono simili alle funzioni: li dichiariamo con la parola chiave `fn` e un nome, possono avere parametri e un valore di ritorno, e contengono del codice che viene eseguito quando il metodo viene chiamato da qualche altra parte. A differenza delle funzioni, i metodi sono definiti nel contesto di una struct (o di un enum o un trait object, che copriremo rispettivamente nel [Capitolo 6][enums]<!-- ignore --> e nel [Capitolo 17][trait-objects]<!-- ignore -->), e il loro primo parametro è sempre `self`, che rappresenta l'istanza della struct su cui il metodo viene chiamato.

### Definire Metodi

Modifichiamo la funzione `area` che ha un'istanza `Rectangle` come parametro e trasformiamola invece in un metodo `area` definito sulla struct `Rectangle`, come mostrato in Listing 5-13.

<span class="filename">Filename: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-13/src/main.rs}}
```

<span class="caption">Listing 5-13: Definire un metodo `area` sulla struct `Rectangle`</span>

Per definire la funzione nel contesto di `Rectangle`, iniziamo un blocco `impl` (implementazione) per `Rectangle`. Tutto ciò che è all'interno di questo blocco `impl` sarà associato al tipo `Rectangle`. Quindi spostiamo la funzione `area` all'interno delle parentesi graffe `impl` e cambiamo il primo (e in questo caso, l'unico) parametro in `self` nella firma e ovunque all'interno del blocco. In `main`, dove abbiamo chiamato la funzione `area` e passato `rect1` come argomento, possiamo invece utilizzare la *sintassi del metodo* per chiamare il metodo `area` sulla nostra istanza `Rectangle`. La sintassi del metodo segue un'istanza: aggiungiamo un punto seguito dal nome del metodo, parentesi, e qualsiasi argomento.

Nella firma di `area`, usiamo `&self` invece di `rectangle: &Rectangle`. Il `&self` è in realtà un'abbreviazione per `self: &Self`. All'interno di un blocco `impl`, il tipo `Self` è un alias per il tipo per cui il blocco `impl` è definito. I metodi devono avere un parametro chiamato `self` di tipo `Self` come primo parametro, quindi Rust ti consente di abbreviare questo solo con il nome `self` nel primo posto del parametro. Nota che dobbiamo ancora usare il `&` davanti all'abbreviazione `self` per indicare che questo metodo prende in prestito l'istanza di `Self`, proprio come abbiamo fatto in `rectangle: &Rectangle`. I metodi possono acquisire ownership di `self`, prendere in prestito `self` in modo immutabile, come abbiamo fatto qui, o mutabilmente, proprio come possono fare con qualsiasi altro parametro.

Abbiamo scelto `&self` qui per lo stesso motivo per cui abbiamo usato `&Rectangle` nella versione funzionale: non vogliamo acquisire ownership e vogliamo solo leggere i dati nella struct, non scriverli. Se volessimo cambiare l'istanza su cui abbiamo chiamato il metodo come parte di ciò che il metodo fa, useremmo `&mut self` come primo parametro. Avere un metodo che prende l'ownership dell'istanza usando solo `self` come primo parametro è raro; questa tecnica viene solitamente utilizzata quando il metodo trasforma `self` in qualcos'altro e vuoi impedire al chiamante di utilizzare l'istanza originale dopo la trasformazione.

Il motivo principale per utilizzare i metodi invece delle funzioni, oltre a fornire la sintassi del metodo e non dover ripetere il tipo di `self` in ogni firma dei metodi, è per l'organizzazione. Abbiamo inserito tutte le operazioni che possiamo fare con un'istanza di un tipo in un unico blocco `impl` anziché far cercare agli utenti futuri del nostro codice le capacità di `Rectangle` in vari punti della libreria che forniamo.

Nota che possiamo scegliere di dare a un metodo lo stesso nome di uno dei campi della struct. Ad esempio, possiamo definire un metodo su `Rectangle` che si chiama anch'esso `width`:

<span class="filename">Filename: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/no-listing-06-method-field-interaction/src/main.rs:here}}
```

Qui, scegliamo di far sì che il metodo `width` ritorni `true` se il valore nel campo `width` dell'istanza è maggiore di `0` e `false` se il valore è `0`: possiamo usare un campo all'interno di un metodo con lo stesso nome per qualsiasi scopo. In `main`, quando seguiamo `rect1.width` con le parentesi, Rust sa che intendiamo il metodo `width`. Quando non usiamo le parentesi, Rust sa che intendiamo il campo `width`.

Spesso, ma non sempre, quando diamo a un metodo lo stesso nome di un campo vogliamo solo che restituisca il valore del campo e non faccia altro. Metodi come questi sono chiamati *getters*, e Rust non li implementa automaticamente per i campi delle struct come fanno alcuni altri linguaggi. I getters sono utili perché puoi rendere il campo privato ma il metodo pubblico, e in tal modo abilitare l'accesso di sola lettura a quel campo come parte dell'API pubblica del tipo. Discuteremo cosa sono pubblico e privato e come designare un campo o un metodo come pubblico o privato nel [Capitolo 7][public]<!-- ignore -->.

> ### Dov’è l'Operatore `->`?
>
> In C e C++, vengono usati due operatori diversi per chiamare metodi: si usa `.` se si sta chiamando un metodo sull’oggetto direttamente e `->` se si sta chiamando il metodo su un puntatore all’oggetto e si ha bisogno di dereferenziare il puntatore prima. In altre parole, se `object` è un puntatore, `object->something()` è simile a `(*object).something()`.
>
> Rust non ha un equivalente dell'operatore `->`; invece, Rust ha una caratteristica chiamata *riferimento e dereferenziazione automatica*. Chiamare metodi è uno dei pochi posti in cui Rust ha questo comportamento.
>
> Ecco come funziona: quando chiami un metodo con `object.something()`, Rust aggiunge automaticamente `&`, `&mut` o `*` così che `object` combaci con la firma del metodo. In altre parole, i seguenti sono gli stessi:
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
> Il primo sembra molto più chiaro. Questo comportamento di riferimento automatico funziona perché i metodi hanno un ricevitore chiaro—il tipo di `self`. Dati il ricevitore e il nome di un metodo, Rust può capire in modo definitivo se il metodo sta leggendo (`&self`), mutando (`&mut self`), o consumando (`self`). Il fatto che Rust renda implicito il borrowing per i ricevitori di metodo è una grande parte nel rendere ownership ergonomica in pratica.

### Metodi con Più Parametri

Facciamo pratica con l'uso dei metodi implementando un secondo metodo sulla struct `Rectangle`. Questa volta vogliamo che un'istanza di `Rectangle` prenda un'altra istanza di `Rectangle` e restituisca `true` se il secondo `Rectangle` può adattarsi completamente all'interno di `self` (il primo `Rectangle`); altrimenti, dovrebbe restituire `false`. Cioè, una volta che abbiamo definito il metodo `can_hold`, vogliamo essere in grado di scrivere il programma mostrato in Listing 5-14.

<span class="filename">Filename: src/main.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-14/src/main.rs}}
```

<span class="caption">Listing 5-14: Utilizzare il metodo `can_hold` non ancora scritto</span>

L'output previsto sarà il seguente perché entrambe le dimensioni di `rect2` sono più piccole delle dimensioni di `rect1`, ma `rect3` è più largo di `rect1`:

```text
Can rect1 hold rect2? true
Can rect1 hold rect3? false
```

Sappiamo che vogliamo definire un metodo, quindi sarà all'interno del blocco `impl Rectangle`. Il nome del metodo sarà `can_hold`, e prenderà un riferimento immutabile di un altro `Rectangle` come parametro. Possiamo capire quale sarà il tipo del parametro guardando il codice che chiama il metodo: `rect1.can_hold(&rect2)` passa `&rect2`, che è un riferimento immutabile a `rect2`, un'istanza di `Rectangle`. Questo ha senso perché abbiamo bisogno solo di leggere `rect2` (piuttosto che scrivere, il che significherebbe che avremmo bisogno di un riferimento mutabile), e vogliamo che `main` mantenga ownership di `rect2` così possiamo usarlo di nuovo dopo aver chiamato il metodo `can_hold`. Il valore di ritorno di `can_hold` sarà un Boolean, e l'implementazione controllerà se la larghezza e l'altezza di `self` sono maggiori della larghezza e dell'altezza dell'altro `Rectangle`, rispettivamente. Aggiungiamo il nuovo metodo `can_hold` al blocco `impl` da Listing 5-13, mostrato in Listing 5-15.

<span class="filename">Filename: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-15/src/main.rs:here}}
```

<span class="caption">Listing 5-15: Implementare il metodo `can_hold` su `Rectangle` che prende un'altra istanza di `Rectangle` come parametro</span>

Quando eseguiamo questo codice con la funzione `main` in Listing 5-14, otterremo il risultato desiderato. I metodi possono prendere più parametri che aggiungiamo alla firma dopo il parametro `self`, e quei parametri funzionano proprio come i parametri nelle funzioni.

### Funzioni Associate

Tutte le funzioni definite all'interno di un blocco `impl` sono chiamate *funzioni associate* perché sono associate al tipo chiamato dopo `impl`. Possiamo definire funzioni associate che non hanno `self` come primo parametro (e quindi non sono metodi) perché non richiedono un'istanza del tipo con cui lavorare. Abbiamo già usato una funzione come questa: la funzione `String::from` definita sul tipo `String`.

Le funzioni associate che non sono metodi sono spesso utilizzate per i costruttori che restituiranno una nuova istanza della struct. Queste sono spesso chiamate `new`, ma `new` non è un nome speciale e non è incorporato nel linguaggio. Ad esempio, potremmo scegliere di fornire una funzione associata chiamata `square` che avrebbe un parametro dimensionale e lo userebbe sia per la larghezza che per l'altezza, rendendo così più facile creare un `Rectangle` quadrato piuttosto che dover specificare lo stesso valore due volte:

<span class="filename">Filename: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/no-listing-03-associated-functions/src/main.rs:here}}
```

Le parole chiave `Self` nel tipo di ritorno e nel corpo della funzione sono alias per il tipo che appare dopo la parola chiave `impl`, che in questo caso è `Rectangle`.

Per chiamare questa funzione associata, utilizziamo la sintassi `::` con il nome della struct; `let sq = Rectangle::square(3);` è un esempio. Questa funzione è organizzata tramite la struct: la sintassi `::` viene utilizzata sia per le funzioni associate che per gli spazi dei nomi creati dai moduli. Discuteremo i moduli nel [Capitolo 7][modules]<!-- ignore -->.

### Blocchi `impl` Multipli

Ogni struct è consentita avere blocchi `impl` multipli. Ad esempio, Listing 5-15 è equivalente al codice mostrato in Listing 5-16, che ha ciascun metodo nel proprio blocco `impl`.

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-16/src/main.rs:here}}
```

<span class="caption">Listing 5-16: Riscrivere il Listing 5-15 usando blocchi `impl` multipli</span>

Non c'è motivo di separare questi metodi in blocchi `impl` multipli qui, ma questa è una sintassi valida. Vedremo un caso in cui i blocchi `impl` multipli sono utili nel Capitolo 10, dove discuteremo i tipi generici e i traits.

## Sommario

Le structs ti permettono di creare tipi personalizzati che sono significativi per il tuo dominio. Usando le structs, puoi tenere pezzi di dati associati collegati tra loro e nominare ciascun pezzo per rendere il tuo codice chiaro. Nei blocchi `impl`, puoi definire funzioni che sono associate al tuo tipo, e i metodi sono un tipo di funzione associata che ti permette di specificare il comportamento che le istanze delle tue structs hanno.

Ma le structs non sono l'unico modo per creare tipi personalizzati: passiamo alla caratteristica degli enum di Rust per aggiungere un altro strumento alla tua cassetta degli attrezzi.

[enums]: ch06-00-enums.html
[trait-objects]: ch17-02-trait-objects.md
[public]: ch07-03-paths-for-referring-to-an-item-in-the-module-tree.html#exposing-paths-with-the-pub-keyword
[modules]: ch07-02-defining-modules-to-control-scope-and-privacy.html
