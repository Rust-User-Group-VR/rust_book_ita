## Definizione e Istanziazione di Structs

Le Structs sono simili alle tuple, discusse nella sezione [“Il Tipo Tuple”][tuples]<!--
ignore -->, in quanto entrambe contengono più valori correlati. Come le tuple, le
parti di una struct possono essere di tipi diversi. A differenza delle tuple, in una struct
dovrai nominare ogni pezzo di dati in modo che sia chiaro cosa significano i valori. Aggiungere questi nomi
significa che le structs sono più flessibili delle tuple: non devi contare
sull'ordine dei dati per specificare o accedere ai valori di un'istanza.

Per definire una struct, inseriamo la parola chiave `struct` e diamo un nome all'intera struct. Un
il nome della struct dovrebbe descrivere l'importanza dei pezzi di dati che
vengono raggruppati insieme. Quindi, tra parentesi graffe, definiamo i nomi e i tipi dei
pezzi di dati, che chiamiamo *campi*. Ad esempio, la Listing 5-1 mostra una
struct che memorizza le informazioni su un account utente.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-01/src/main.rs:here}}
```

<span class="caption">Listing 5-1: Definizione di una struct `User`</span>

Per utilizzare una struct dopo che l'abbiamo definita, creiamo un *istanza* di quella struct
specificando valori concreti per ciascuno dei campi. Creiamo un'istanza
stabilisco il nome della struct e poi aggiungo parentesi graffe contenenti *chiave:
coppie di valori*, dove le chiavi sono i nomi dei campi e i valori sono il
dati che vogliamo memorizzare in quei campi. Non dobbiamo specificare i campi in
lo stesso ordine in cui li abbiamo dichiarati nella struct. In altre parole, il
la definizione della struct è come un modello generale per il tipo, e le istanze riempiono
in quel modello con dati particolari per creare valori del tipo. Per
esempio, possiamo dichiarare un utente particolare come mostrato nella Listing 5-2.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-02/src/main.rs:here}}
```

<span class="caption">Listing 5-2: Creazione di un'istanza della struct `User`
</span>

Per ottenere un valore specifico da una struct, utilizziamo la notazione del punto. Ad esempio, per
accedere all'indirizzo email di questo utente, utilizziamo `user1.email`. Se l'istanza è
mutabile, possiamo cambiare un valore utilizzando la notazione del punto e assegnando a un
campo particolare. La Listing 5-3 mostra come cambiare il valore nel campo `email`
di un'istanza mutabile `User`.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-03/src/main.rs:here}}
```

<span class="caption">Listing 5-3: Modifica del valore nel campo `email` di un
istanza `User`</span>

Nota che l'intera istanza deve essere mutabile; Rust non ci permette di contrassegnare
solo certi campi come mutabili. Come con qualsiasi espressione, possiamo costruire un nuovo
istanza della struct come ultima espressione nel corpo della funzione per
ritornare implicitamente quella nuova istanza.

La Listing 5-4 mostra una funzione `build_user` che restituisce un'istanza `User` con
l'email e il nome utente dati. Il campo `active` riceve il valore `true`, e
il `sign_in_count` riceve un valore di `1`.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-04/src/main.rs:here}}
```

<span class="caption">Listing 5-4: Una funzione `build_user` che prende un'email
e un nome utente e restituisce un'istanza `User`</span>

Ha senso dare ai parametri della funzione lo stesso nome dei campi della struct
ma dover ripetere i nomi dei campi `email` e `username` e
le variabili è un po' noioso. Se la struct avesse più campi, ripetere ogni nome
sarebbe ancora più fastidioso. Fortunatamente, c'è una comoda scorciatoia!

<!-- Vecchia intestazione. Non rimuovere o i link potrebbero rompersi. -->
<a id="using-the-field-init-shorthand-when-variables-and-fields-have-the-same-name"></a>

### Utilizzo della scorciatoia di inizializzazione del campo

Poiché i nomi dei parametri e i nomi dei campi della struct sono esattamente gli stessi in
Listing 5-4, possiamo usare la sintassi della *scorciatoia di inizializzazione del campo* per riscrivere
`build_user` in modo che si comporti esattamente allo stesso modo ma non ha la ripetizione di
`username` e `email`, come mostrato nella Listing 5-5.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-05/src/main.rs:here}}
```

<span class="caption">Listing 5-5: Una funzione `build_user` che utilizza la scorciatoia di inizializzazione del campo
perché i parametri `username` ed `email` hanno lo stesso nome dei campi della struct</span>

Qui, stiamo creando una nuova istanza della struct `User`, che ha un campo
chiamato `email`. Vogliamo impostare il valore del campo `email` al valore nel
parametro `email` della funzione `build_user`. Poiché il campo `email` e il
il parametro `email` hanno lo stesso nome, dobbiamo solo scrivere `email` piuttosto
che `email: email`.

### Creazione di Istanze da Altre Istanze con la Sintassi di Aggiornamento Struct

È spesso utile creare una nuova istanza di una struct che include la maggior parte di
i valori da un'altra istanza, ma cambia alcuni. Puoi farlo usando
sintassi di aggiornamento della struct*.

Prima, nella Listing 5-6 mostriamo come creare una nuova istanza di `User` in `user2`
regolarmente, senza la sintassi di aggiornamento. Impostiamo un nuovo valore per `email` ma
altrimenti utilizziamo gli stessi valori da `user1` che abbiamo creato nella Listing 5-2.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-06/src/main.rs:here}}
```

<span class="caption">Listing 5-6: Creazione di una nuova istanza `User` utilizzando uno dei
valori da `user1`</span>

Usando la sintassi di aggiornamento della struct, possiamo ottenere lo stesso effetto con meno codice, come
mostrato nella Listing 5-7. La sintassi `..` specifica che i campi rimanenti non
esplicitamente impostati dovrebbero avere lo stesso valore dei campi nell'istanza data.

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/listing-05-07/src/main.rs:here}}
```

<span class="caption">Listing 5-7: Utilizzo della sintassi di aggiornamento della struct per impostare un nuovo
valore `email` per un'istanza `User` ma per utilizzare il resto dei valori da
`user1`</span>

Il codice nella Listing 5-7 crea anche un'istanza in `user2` che ha un
valore diverso per `email` ma ha gli stessi valori per i campi `username`,
`active`, e `sign_in_count` da `user1`. Il `..user1` deve venire per ultimo
per specificare che tutti i campi rimanenti dovrebbero ricevere i loro valori dal
campi corrispondenti in `user1`, ma possiamo scegliere di specificare i valori per come
molti campi vogliamo in qualsiasi ordine, indipendentemente dall'ordine dei campi nel
definizione della struct.

Nota che la sintassi di aggiornamento struct utilizza `=` come un'assegnazione; questo perché
sposta i dati, proprio come abbiamo visto nella sezione [“Variabili e dati che interagiscono con
Move”][move]<!-- ignore -->. In questo esempio, non possiamo più utilizzare
`user1` come un tutto dopo aver creato `user2` perché la `String` nel
campo `username` di `user1` è stata spostata in `user2`. Se avessimo dato a `user2` nuove
valori `String` sia per `email` che per `username`, e quindi avessimo utilizzato solo i
valori `active` e `sign_in_count` da `user1`, allora `user1` sarebbe ancora
valido dopo aver creato `user2`. Sia `active` che `sign_in_count` sono tipi che
implementano il trait `Copy`, quindi il comportamento che abbiamo discusso nella sezione [“Solo dati Stack:
Copy”][copy]<!-- ignore --> si applicherebbe.

### Utilizzo di Struct Tuple Senza Campi Nominati per Creare Diversi Tipi

Rust supporta anche struct che assomigliano a tuple, chiamate *struct di tuple*.
Le struct di tuple hanno il significato aggiunto che il nome della struct fornisce, ma non hanno
nomi associati ai loro campi; piuttosto, hanno solo i tipi dei
campi. Le struct di tuple sono utili quando vuoi dare un nome all'intera tupla
e rendere la tupla un tipo diverso da altre tuple, e quando nominare ogni campo come in una normale struct sarebbe verbose o ridondante.

Per definire una struct di tupla, inizia con la parola chiave `struct` e il nome della struct
seguito dai tipi nella tupla. Ad esempio, qui definiamo e usiamo due
struct di tuple chiamate `Color` e `Point`:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/no-listing-01-tuple-structs/src/main.rs}}
```

Nota che i valori `black` e `origin` sono tipi diversi perché sono
istanze di diverse struct di tuple. Ogni struct che definisci è un tipo a sé stante,
anche se i campi all'interno della struct potrebbero avere gli stessi tipi. Per
esempio, una funzione che prende un parametro di tipo `Color` non può prendere un
`Point` come argomento, anche se entrambi i tipi sono composti da tre valori `i32`.
In caso contrario, le istanze di struct di tuple sono simili alle tuple in quanto puoi
destrutturarle nelle loro parti individuali, e puoi usare un `.` seguito
dall'indice per accedere a un valore individuale.

### Struct Unit-Like Senza Alcun Campo

Puoi anche definire struct che non hanno alcun campo! Queste sono chiamate
*struct unit-like* perché si comportano in modo simile a `()`, il tipo unit che
abbiamo menzionato nella sezione ["Il Tipo Tupla"][tuples]<!-- ignore -->. Le struct unit-like
possono essere utili quando devi implementare un trait su un certo tipo ma non
hai dati che vuoi memorizzare nel tipo stesso. Discutiamo dei trait
nel Capitolo 10. Ecco un esempio di dichiarazione e istanziazione di una struct unit
chiamata `AlwaysEqual`:

<span class="filename">Nome del file: src/main.rs</span>

```rust
{{#rustdoc_include ../listings/ch05-using-structs-to-structure-related-data/no-listing-04-unit-like-structs/src/main.rs}}
```

Per definire `AlwaysEqual`, utilizziamo la parola chiave `struct`, il nome che vogliamo, e
poi un punto e virgola. Non c'è bisogno di parentesi graffe o parentesi tonde! Poi possiamo ottenere un
istanza di `AlwaysEqual` nella variabile `subject` in modo simile: utilizzando il
nome che abbiamo definito, senza parentesi graffe o parentesi tonde. Immagina che in seguito
implementeremo un comportamento per questo tipo in modo che ogni istanza di
`AlwaysEqual` sia sempre uguale a ogni istanza di qualsiasi altro tipo, forse per
avere un risultato noto per i test. Non avremmo bisogno di alcun dato per
implementare quel comportamento! Vedrai nel Capitolo 10 come definire i trait e
implementarli su qualsiasi tipo, inclusi i struct unit-like.

> ### Ownership dei Dati della Struct
>
> Nella definizione della struct `User` nella Lista 5-1, abbiamo utilizzato il tipo `String`
> posseduto piuttosto che il tipo `&str` slice di stringa. Questa è una scelta
> volontaria perché vogliamo che ciascuna istanza di questa struct possieda tutti i suoi dati e che
> tali dati siano validi per tutto il tempo in cui l'intera struct è valida.
>
> È anche possibile per le struct memorizzare riferimenti ai dati posseduti da qualcos'altro,
> ma per farlo è necessario l'uso di *lifetimes*, una caratteristica di Rust che discuteremo nel Capitolo 10. Gli lifetimes garantiscono che i dati a cui una struct fa riferimento
> siano validi per tutto il tempo in cui la struct è. Supponiamo che tu tenti di memorizzare un riferimento
> in una struct senza specificare gli lifetimes, come nel seguente; questo non funzionerà:
>
> <span class="filename">Nome del file: src/main.rs</span>
>
> <!-- CAN'T EXTRACT SEE https://github.com/rust-lang/mdBook/issues/1127 -->
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
> Il compilatore si lamenterà del fatto che ha bisogno di specificatori lifetime:
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
> riferimenti nelle struct, ma per ora, risolveremo errori come questi utilizzando tipi posseduti
> come `String` invece di riferimenti come `&str`.

<!-- manual-regeneration
for the error above
after running update-rustc.sh:
pbcopy < listings/ch05-using-structs-to-structure-related-data/no-listing-02-reference-in-struct/output.txt
paste above
add `> ` before every line -->

[tuples]: ch03-02-data-types.html#the-tuple-type
[move]: ch04-01-what-is-ownership.html#variables-and-data-interacting-with-move
[copy]: ch04-01-what-is-ownership.html#stack-only-data-copy

