## Definire e Istantiare le Struct

Le Struct sono simili alle tuple, discusse nella sezione ["Il Tipo Tuple"][tuples]<!--
ignore -->, in quanto entrambe contengono più valori correlati. Come le tuple, le parti di una struct possono essere di diversi tipi. A differenza delle tuple, in una struct darete un nome a ciascun pezzo di dati in modo che sia chiaro cosa significano i valori. Aggiungere questi nomi significa che le struct sono più flessibili delle tuple: non devi fare affidamento sull'ordine dei dati per specificare o accedere ai valori di un'istanza.

Per definire una struct, inseriamo la keyword `struct` e diamo un nome all'intera struct. Il nome di una struct dovrebbe descrivere il significato dei pezzi di dati che vengono raggruppati insieme. Poi, all'interno delle parentesi graffe, definiamo i nomi e i tipi dei pezzi di dati, che chiamiamo *fields*. Ad esempio, la Lista 5-1 mostra una struct che memorizza informazioni su un account utente.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-01/src/main.rs:here}}
```

<span class="caption">Lista 5-1: Una definizione di struct `User`</span>

Per utilizzare una struct dopo che l'abbiamo definita, creiamo un' *istanza* di quella struct specificando valori concreti per ciascuno dei fields. Creiamo un'istanza dichiarando il nome della struct e poi aggiungendo parentesi graffe contenenti coppie *chiave: valore*, dove le chiavi sono i nomi dei fields e i valori sono i dati che vogliamo memorizzare in quei fields. Non dobbiamo specificare i fields nello stesso ordine in cui li abbiamo dichiarati nella struct. In altre parole, la definizione della struct è come un modello generale per il tipo, e le istanze riempiono quel modello con dati particolari per creare valori di quel tipo. Ad esempio, possiamo dichiarare un utente particolare come mostrato nella Lista 5-2.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-02/src/main.rs:here}}
```

<span class="caption">Lista 5-2: Creazione di un'istanza della struct `User`
</span>

Per ottenere un valore specifico da una struct, utilizziamo la notazione con il punto. Ad esempio, per accedere all'indirizzo email di questo utente, utilizziamo `user1.email`. Se l'istanza è mutable, possiamo cambiare un valore utilizzando la notazione del punto e assegnando un particolare field. La Lista 5-3 mostra come cambiare il valore nel field `email` di un'istanza mutable `User`.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-03/src/main.rs:here}}
```

<span class="caption">Lista 5-3: Modificare il valore nel field `email` di un'istanza `User`</span>

Si noti che l'intera istanza deve essere mutable; Rust non ci permette di contrassegnare solo alcuni fields come mutable. Come per qualsiasi espressione, possiamo costruire una nuova istanza della struct come ultima espressione nel corpo della funzione per restituire implicitamente quella nuova istanza.

La Lista 5-4 mostra una funzione `build_user` che restituisce un'istanza di `User` con l'email e il nome utente dati. Il field `active` ottiene il valore `true`, e il `sign_in_count` ottiene un valore `1`.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-04/src/main.rs:here}}
```

<span class="caption">Lista 5-4: Una funzione `build_user` che prende un'email
e il nome utente e restituisce un'istanza `User`</span>

È logico dare ai parametri della funzione lo stesso nome dei fields della struct, ma dover ripetere i nomi dei fields `email` e `username` e delle variabili è un po' noioso. Se la struct avesse più fields, ripetere ciascun nome diventerebbe ancora più fastidioso. Fortunatamente, c'è una scorciatoia conveniente!

<!-- Vecchio titolo. Non rimuovere o i link possono rompersi. -->
<a id="using-the-field-init-shorthand-when-variables-and-fields-have-the-same-name"></a>

### Uso dell'Inizializzazione Rapida dei Fields

Poiché i nomi dei parametri e i nomi dei fields della struct sono esattamente gli stessi nella Lista 5-4, possiamo utilizzare la sintassi di *inizializzazione rapida dei fields* per riscrivere `build_user` in modo che si comporti esattamente allo stesso modo ma senza la ripetizione di `username` e `email`, come mostrato nella Lista 5-5.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-05/src/main.rs:here}}
```

<span class="caption">Lista 5-5: Una funzione `build_user` che utilizza l'inizializzazione rapida dei fields perché i parametri `username` e `email` hanno lo stesso nome dei fields della struct</span>

Qui, stiamo creando una nuova istanza della struct `User`, che ha un field chiamato `email`. Vogliamo impostare il valore del field `email` al valore del parametro `email` della funzione `build_user`. Poiché il field `email` e il parametro `email` hanno lo stesso nome, abbiamo solo bisogno di scrivere `email` piuttosto che `email: email`.

### Creazione di Istanze da Altre Istanze con la Sintassi di Aggiornamento della Struct

Spesso è utile creare una nuova istanza di una struct che include la maggior parte dei valori di un'altra istanza, ma ne cambia alcuni. Puoi farlo utilizzando la *sintassi di aggiornamento della struct*.

Prima, nella Lista 5-6 mostriamo come creare una nuova istanza `User` in `user2` regolarmente, senza la sintassi di aggiornamento. Impostiamo un nuovo valore per `email` ma altrimenti utilizziamo gli stessi valori di `user1` che abbiamo creato nella Lista 5-2.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-06/src/main.rs:here}}
```

<span class="caption">Lista 5-6: Creazione di una nuova istanza `User` utilizzando uno dei valori da `user1`</span>

Utilizzando la sintassi di aggiornamento della struct, possiamo ottenere lo stesso effetto con meno codice, come mostrato nella Lista 5-7. La sintassi `..` specifica che i restanti fields non impostati esplicitamente dovrebbero avere lo stesso valore dei fields nell'istanza data.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-07/src/main.rs:here}}
```

<span class="caption">Lista 5-7: Uso della sintassi di aggiornamento della struct per impostare un nuovo valore `email` per un'istanza `User` ma per utilizzare il resto dei valori da `user1`</span>

Il codice nella Lista 5-7 crea anche un'istanza in `user2` che ha un valore diverso per `email` ma ha gli stessi valori per i fields `username`, `active`, e `sign_in_count` da `user1`. Il `..user1` deve venire per ultimo per specificare che qualsiasi campo rimanente dovrebbe ottenere i suoi valori dai campi corrispondenti in `user1`, ma possiamo scegliere di specificare valori per quanti campi vogliamo in qualsiasi ordine, indipendentemente dall'ordine dei campi nella definizione della struct.

Si noti che la sintassi di aggiornamento della struct utilizza `=` come un'assegnazione; questo perché sposta i dati, proprio come abbiamo visto nella sezione ["Variabili e Dati che Interagiscono con lo Spostamento"][move]<!-- ignore -->. In questo esempio, non possiamo più utilizzare `user1` come un tutto dopo aver creato `user2` perché la `String` nel field `username` di `user1` è stata spostata in `user2`. Se avessimo dato a `user2` nuovi valori `String` sia per `email` che per `username`, e quindi avessimo utilizzato solo i valori `active` e `sign_in_count` da `user1`, allora `user1` sarebbe ancora valido dopo aver creato `user2`. Sia `active` che `sign_in_count` sono tipi che implementano il Trait `Copy`, quindi si applicherebbe il comportamento che abbiamo discusso nella sezione ["Dati Solo Stack: Copy"][copy]<!-- ignore -->.

### Uso delle Tuple Struct Senza Fields Denominati per Creare Diversi Tipi


Rust supporta anche strutture che assomigliano a tuple, chiamate *strutture tuple*.
Le strutture tuple hanno il significato aggiunto che il nome della struct fornisce ma non hanno
nomi associati ai loro campi; piuttosto, hanno solo i tipi dei
campi. Le strutture tuple sono utili quando vuoi dare un nome a tutta la tupla
e rendere la tupla un tipo diverso da altre tuple, e quando denominare ogni
campo come in una struct regolare sarebbe verbose o ridondante.

Per definire una struct tuple, inizia con la parola chiave `struct` e il nome della struct
seguito dai tipi nella tupla. Ad esempio, qui definiamo e usiamo due
struct tuple chiamate `Color` e `Point`:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/no-listing-01-tuple-structs/src/main.rs}}
```

Nota che i valori `black` e `origin` sono tipi diversi perché sono
istanze di diverse strutture tuple. Ogni struct che definisci è un tipo a sé,
anche se i campi all'interno della struct potrebbero avere gli stessi tipi. Ad esempio,
una funzione che prende un parametro di tipo `Color` non può prendere un
`Point` come argomento, anche se entrambi i tipi sono formati da tre valori `i32`.
In caso contrario, le istanze delle struct tuple sono simili alle tuple in quanto si possono
destrutturare nei loro singoli pezzi, e si può usare un `.` seguito
dall'indice per accedere a un valore individuale.

### Struct Simili a Unit Senza Campi

Puoi anche definire strutture che non hanno campi! Queste sono chiamate
*struct simili a unit* perché si comportano in modo simile a `()`, il tipo unit che
abbiamo menzionato nella sezione [“Il Tipo Tuple”][tuples]<!-- ignore -->. Le struct simili a unit
possono essere utili quando hai bisogno di implementare un trait su qualche tipo ma non hai
dati che vuoi memorizzare nel tipo stesso. Discuteremo i trait
nel Capitolo 10. Ecco un esempio di dichiarazione e istanziazione di una struct unit
chiamata `AlwaysEqual`:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/no-listing-04-unit-like-structs/src/main.rs}}
```

Per definire `AlwaysEqual`, usiamo la parola chiave `struct`, il nome che vogliamo, e
poi un punto e virgola. Non c'è bisogno di parentesi graffe o parentesi! Poi possiamo ottenere un
istanza di `AlwaysEqual` nella variabile `subject` in modo simile: utilizzando il
nome che abbiamo definito, senza parentesi graffe o parentesi. Immagina che più tardi
implementeremo un comportamento per questo tipo tale che ogni istanza di
`AlwaysEqual` sia sempre uguale a ogni istanza di qualsiasi altro tipo, forse per
avere un risultato noto per i test. Non avremmo bisogno di alcun dato per
implementare quel comportamento! Vedrai nel Capitolo 10 come definire i trait e
implementarli su qualsiasi tipo, comprese le struct simili a unit.

> ### L'Ownership dei Dati della Struct
>
> Nella definizione della struct `User` nell'Esercizio 5-1, abbiamo usato il `String`
> tipo possessedo piuttosto che il tipo slice di stringa `&str`. Questa è una scelta
> deliberata perché vogliamo che ogni istanza di questa struct possegga tutti i suoi dati e che
> tali dati siano validi per tutto il tempo in cui l'intera struct è valida.
>
> È anche possibile per le struct memorizzare riferimenti a dati posseduti da qualche cosa
> altro, ma per farlo si richiede l'uso delle *lifetime*, una funzionalità di Rust che discuteremo
> nel Capitolo 10. Le lifetime assicurano che i dati referenziati da una struct
> siano validi per tutto il tempo in cui la struct esiste. Supponiamo che tu provi a memorizzare un riferimento
> in una struct senza specificare le lifetime, come nel seguente esempio; questo non funzionerà:
>
> <span class="filename">Nome del file: src/main.rs</span>
>
> <!-- NON POSSO ESTRARRE VEDI https://github.com/rust-lang/mdBook/issues/1127 -->
>
> ```rust,ignore,does_not_compile
> struct User {
>     active: bool,
>     username: &str,
>     email: &str,
>     sign_in_count: u64,
> }
>
> fn main() {
>     let user1 = User {
>         active: true,
>         username: "someusername123",
>         email: "someone@example.com",
>         sign_in_count: 1,
>     };
> }
> ```
>
> Il compilatore si lamenterà che ha bisogno di specificatori di lifetime:
>
> ```console
> $ cargo run
>    Compiling structs v0.1.0 (file:///projects/structs)
> error[E0106]: missing lifetime specifier
>  --> src/main.rs:3:15
>   |
> 3 |     username: &str,
>   |               ^ expected named lifetime parameter
>   |
> help: consider introducing a named lifetime parameter
>   |
> 1 ~ struct User<'a> {
> 2 |     active: bool,
> 3 ~     username: &'a str,
>   |
>
> error[E0106]: missing lifetime specifier
>  --> src/main.rs:4:12
>   |
> 4 |     email: &str,
>   |            ^ expected named lifetime parameter
>   |
> help: consider introducing a named lifetime parameter
>   |
> 1 ~ struct User<'a> {
> 2 |     active: bool,
> 3 |     username: &str,
> 4 ~     email: &'a str,
>   |
>
> For more information about this error, try `rustc --explain E0106`.
> error: could not compile `structs` due to 2 previous errors
> ```
>
> Nel Capitolo 10, discuteremo come risolvere questi errori in modo da poter memorizzare
> riferimenti nelle struct, ma per ora, risolveremo errori come questi usando tipi posseduti
> come `String` invece di riferimenti come `&str`.

<!-- manual-regeneration
per l'errore qui sopra
dopo aver eseguito update-rustc.sh:
pbcopy < listings/ch05-using-structs-to-structure-related-data/no-listing-02-reference-in-struct/output.txt
incolla sopra
aggiungi `> ` prima di ogni linea -->

[tuples]: ch03-02-data-types.html#il-tipo-tuple
[move]: ch04-01-what-is-ownership.html#variables-and-data-interacting-with-move
[copy]: ch04-01-what-is-ownership.html#soli-dati-nello-stack-copy

