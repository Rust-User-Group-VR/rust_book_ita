## Memorizzare Testo Codificato in UTF-8 con le Stringhe

Abbiamo parlato delle stringhe nel Capitolo 4, ma ora le esamineremo più in profondità. I nuovi Rustaceans si bloccano comunemente sulle stringhe per una combinazione di tre motivi: la propensione di Rust a esporre possibili errori, le stringhe come una struttura di dati più complicata rispetto a quanto molti programmatori credano, e l'UTF-8. Questi fattori si combinano in un modo che può sembrare difficile quando si proviene da altri linguaggi di programmazione.

Discutiamo delle stringhe nel contesto delle collezioni perché le stringhe sono implementate come una collezione di byte, più alcuni metodi per fornire funzionalità utili quando quei byte sono interpretati come testo. In questa sezione, parleremo delle operazioni su `String` che ogni tipo di collezione ha, come la creazione, l'aggiornamento e la lettura. Discuteremo anche di come `String` sia diversa dalle altre collezioni, in particolare di come l'indicizzazione in una `String` sia complicata dalle differenze tra il modo in cui le persone e i computer interpretano i dati di `String`.

### Che Cosa è una Stringa?

Definiremo prima cosa intendiamo con il termine *stringa*. Rust ha un solo tipo di stringa nel linguaggio base, che è la string slice `str` solitamente vista nella sua forma presa in prestito `&str`. Nel Capitolo 4, abbiamo parlato delle *string slice*, che sono riferimenti a dati di stringa codificati in UTF-8 memorizzati altrove. I letterali di stringa, ad esempio, sono memorizzati nel binario del programma e sono quindi string slice.

Il tipo `String`, fornito dalla libreria standard di Rust piuttosto che codificato nel linguaggio base, è un tipo di stringa cresciuto, mutabile, di proprietà, codificato in UTF-8. Quando i Rustaceans si riferiscono alle "stringhe" in Rust, potrebbero riferirsi sia al tipo `String` che al tipo di string slice `&str`, non solo a uno di quei due tipi. Sebbene questa sezione riguardi principalmente `String`, entrambi i tipi sono utilizzati ampiamente nella libreria standard di Rust, e sia `String` che le string slice sono codificati in UTF-8.

### Creare una Nuova Stringa

Molte delle stesse operazioni disponibili con `Vec<T>` sono disponibili anche con `String` poiché `String` è effettivamente implementata come un wrapper attorno a un vettore di byte con alcune garanzie, restrizioni e capacità extra. Un esempio di una funzione che funziona allo stesso modo con `Vec<T>` e `String` è la funzione `new` per creare un'istanza, mostrata nel Listato 8-11.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-11/src/main.rs:here}}
```

<span class="caption">Listing 8-11: Creare una nuova, vuota `String`</span>

Questa riga crea una nuova stringa vuota chiamata `s`, in cui possiamo poi caricare dati. Spesso avremo alcuni dati iniziali con cui vogliamo iniziare la stringa. Per questo, utilizziamo il metodo `to_string`, disponibile su qualsiasi tipo che implementa il `Display` trait, come fanno i letterali di stringa. Il Listato 8-12 mostra due esempi.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-12/src/main.rs:here}}
```

<span class="caption">Listing 8-12: Utilizzare il metodo `to_string` per creare una `String` da un letterale di stringa</span>

Questo codice crea una stringa che contiene `contenuto iniziale`.

Possiamo anche utilizzare la funzione `String::from` per creare una `String` da un letterale di stringa. Il codice nel Listato 8-13 è equivalente al codice nel Listato 8-12 che utilizza `to_string`.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-13/src/main.rs:here}}
```

<span class="caption">Listing 8-13: Utilizzare la funzione `String::from` per creare una `String` da un letterale di stringa</span>

Poiché le stringhe sono utilizzate per molte cose, possiamo usare molte diverse API generiche per le stringhe, fornendoci molte opzioni. Alcune di esse possono sembrare ridondanti, ma tutte hanno il loro posto! In questo caso, `String::from` e `to_string` fanno la stessa cosa, quindi quale scegliete è una questione di stile e leggibilità.

Ricordate che le stringhe sono codificate in UTF-8, quindi possiamo includere qualsiasi dato correttamente codificato in esse, come mostrato nel Listato 8-14.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-14/src/main.rs:here}}
```

<span class="caption">Listing 8-14: Memorizzare saluti in diverse lingue nelle stringhe</span>

Tutti questi sono valori `String` validi.

### Aggiornare una Stringa

Una `String` può crescere in dimensione e il suo contenuto può cambiare, proprio come il contenuto di un `Vec<T>`, se si spinge più dati in essa. Inoltre, è possibile utilizzare comodamente l'operatore `+` o la macro `format!` per concatenare valori `String`.

#### Aggiungere a una Stringa con `push_str` e `push`

Possiamo far crescere una `String` usando il metodo `push_str` per aggiungere una string slice, come mostrato nel Listato 8-15.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-15/src/main.rs:here}}
```

<span class="caption">Listing 8-15: Aggiungere una string slice a una `String` usando il metodo `push_str`</span>

Dopo queste due righe, `s` conterrà `foobar`. Il metodo `push_str` prende una string slice perché non vogliamo necessariamente prendere Ownership del parametro. Ad esempio, nel codice nel Listato 8-16, vogliamo essere in grado di utilizzare `s2` dopo aver aggiunto il suo contenuto a `s1`.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-16/src/main.rs:here}}
```

<span class="caption">Listing 8-16: Usare una string slice dopo aver aggiunto il suo contenuto a una `String`</span>

Se il metodo `push_str` prendesse Ownership di `s2`, non saremmo in grado di stampare il suo valore nell'ultima riga. Tuttavia, questo codice funziona come ci aspetteremmo!

Il metodo `push` prende un singolo carattere come parametro e lo aggiunge alla `String`. Il Listato 8-17 aggiunge la lettera *l* a una `String` usando il metodo `push`.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-17/src/main.rs:here}}
```

<span class="caption">Listing 8-17: Aggiungere un carattere a un valore `String` usando `push`</span>

Di conseguenza, `s` conterrà `lol`.

#### Concatenazione con l'Operatore `+` o la Macro `format!`

Spesso, vorrete combinare due stringhe esistenti. Un modo per farlo è usare l'operatore `+`, come mostrato nel Listato 8-18.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-18/src/main.rs:here}}
```

<span class="caption">Listing 8-18: Usare l'operatore `+` per combinare due valori `String` in un nuovo valore `String`</span>

La stringa `s3` conterrà `Hello, world!`. La ragione per cui `s1` non è più valida dopo l'aggiunta, e il motivo per cui abbiamo usato un riferimento a `s2`, ha a che fare con la firma del metodo che viene chiamato quando si usa l'operatore `+`. L'operatore `+` usa il metodo `add`, la cui firma appare in questo modo:

```rust,ignore
fn add(self, s: &str) -> String {
```

Nella libreria standard, vedrete `add` definito usando generici e tipi associati. Qui, abbiamo sostituito i tipi concreti, che è ciò che accade quando chiamiamo questo metodo con valori `String`. Discuteremo dei generici nel Capitolo 10. Questa firma ci dà gli indizi di cui abbiamo bisogno per comprendere gli aspetti complessi dell'operatore `+`.

Per prima cosa, `s2` ha un `&`, il che significa che stiamo aggiungendo un *riferimento* della seconda stringa alla prima stringa. Questo è dovuto al parametro `s` nella funzione `add`: possiamo aggiungere solo un `&str` a una `String`; non possiamo aggiungere due valori `String` insieme. Ma un momento — il tipo di `&s2` è `&String`, non `&str`, come specificato nel secondo parametro per `add`. Allora perché il Listato 8-18 compila?

La ragione per cui siamo in grado di usare `&s2` nella chiamata a `add` è che il compilatore può *forzare* il parametro `&String` in un `&str`. Quando chiamiamo il metodo `add`, Rust usa una *deref coercion*, che qui trasforma `&s2` in `&s2[..]`. Discuteremo la deref coercion in maggiore profondità nel Capitolo 15. Poiché `add` non prende Ownership del parametro `s`, `s2` sarà ancora un `String` valido dopo questa operazione.

In secondo luogo, possiamo vedere nella firma che `add` prende Ownership di `self` perché `self` non ha un `&`. Ciò significa che `s1` nel Listato 8-18 verrà spostato nella chiamata a `add` e non sarà più valido dopo. Quindi, sebbene `let s3 = s1 + &s2;` sembri che copierà entrambe le stringhe e ne creerà una nuova, questa istruzione in realtà prende Ownership di `s1`, aggiunge una copia del contenuto di `s2` e poi restituisce Ownership del risultato. In altre parole, sembra che faccia molte copie, ma non è così; l'implementazione è più efficiente del copiaggio.

Se abbiamo bisogno di concatenare più stringhe, il comportamento dell'operatore `+` diventa scomodo:

```rust
{{#rustdoc_include ../listings/ch08-common-collections/no-listing-01-concat-multiple-strings/src/main.rs:here}}
```

A questo punto, `s` sarà `tic-tac-toe`. Con tutti quei caratteri `+` e `"`, è difficile capire cosa stia succedendo. Per combinare le stringhe in modi più complicati, possiamo invece usare la macro `format!`:

```rust
{{#rustdoc_include ../listings/ch08-common-collections/no-listing-02-format/src/main.rs:here}}
```

Questo codice imposta anche `s` su `tic-tac-toe`. La macro `format!` funziona come `println!`, ma invece di stampare l'output sullo schermo, restituisce una `String` con il contenuto. La versione del codice che utilizza `format!` è molto più facile da leggere, e il codice generato dalla macro `format!` utilizza i riferimenti in modo tale che questa chiamata non prende Ownership di nessuno dei suoi parametri.

### Indicizzazione nelle Stringhe

In molti altri linguaggi di programmazione, accedere ai singoli caratteri in una stringa facendo riferimento a essi tramite indice è un'operazione valida e comune. Tuttavia, se provate ad accedere a parti di una `String` usando la sintassi di indicizzazione in Rust, otterrete un errore. Considerate il codice non valido nel Listato 8-19.

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-19/src/main.rs:here}}
```

<span class="caption">Listing 8-19: Tentativo di utilizzare la sintassi di indicizzazione con una String</span>

Questa codice risulterà nel seguente errore:

```console
{{#include ../listings/ch08-common-collections/listing-08-19/output.txt}}
```

L'errore e la nota raccontano la storia: le stringhe di Rust non supportano l'indicizzazione. Ma perché no? Per rispondere a questa domanda, dobbiamo discutere di come Rust memorizza le stringhe in memoria.

#### Rappresentazione Interna

Una `String` è un wrapper sopra un `Vec<u8>`. Guardiamo a qualcuna delle nostre stringhe di esempio correttamente codificate in UTF-8 offerte nel Listato 8-14. Prima, questa:

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-14/src/main.rs:spanish}}
```

In questo caso, `len` sarà `4`, il che significa che il vettore che memorizza la stringa `"Hola"` è lungo 4 byte. Ciascuna di queste lettere occupa un byte quando è codificata in UTF-8. La seguente riga, tuttavia, potrebbe sorprendervi (notate che questa stringa inizia con la lettera cirillica maiuscola *Ze*, non il numero 3):

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-14/src/main.rs:russian}}
```

Se vi si chiedesse quanto è lunga la stringa, potreste dire 12. In realtà, Rust risponde 24: questo è il numero di byte che ci vuole per codificare "Здравствуйте" in UTF-8, perché ogni valore scalare Unicode in quella stringa occupa 2 byte di archiviazione. Pertanto, un indice nei byte della stringa non sempre corrisponderà a un valido valore scalare Unicode. Per dimostrare, considerate questo codice non valido in Rust:

```rust,ignore,does_not_compile
let hello = "Здравствуйте";
let answer = &hello[0];
```

Sapete già che `answer` non sarà `З`, la prima lettera. Quando codificato in UTF-8, il primo byte di `З` è `208` e il secondo è `151`, quindi sembrerebbe che `answer` dovrebbe effettivamente essere `208`, ma `208` non è un carattere valido da solo. Restituire `208` probabilmente non è quello che un utente vorrebbe se chiedesse la prima lettera di questa stringa; comunque, questo è l'unico dato che Rust ha all'indirizzo byte 0. Gli utenti generalmente non vogliono che venga restituito il valore del byte, anche se la stringa contiene solo lettere latine: se `&"hello"[0]` fosse codice valido che restituiva il valore del byte, restituirebbe `104`, non `h`.

La risposta, quindi, è che per evitare di restituire un valore inaspettato e causare bug che potrebbero non essere scoperti immediatamente, Rust non compila questo codice affatto e previene incomprensioni presto nel processo di sviluppo.

#### Byte e Valori Scalari e Grapheme Clusters! Oh Mio!

Un altro punto dell'UTF-8 è che ci sono effettivamente tre modi rilevanti di guardare le stringhe dalla prospettiva di Rust: come byte, valori scalari e cluster di grafemi (la cosa più vicina a ciò che chiameremmo *lettere*).

Se guardiamo alla parola hindi “नमस्ते” scritta nell'alfabeto devanagari, è memorizzata come un vettore di valori `u8` che appare in questo modo:

```text
[224, 164, 168, 224, 164, 174, 224, 164, 184, 224, 165, 141, 224, 164, 164,
224, 165, 135]
```

Sono 18 byte ed è il modo in cui i computer memorizzano infine questi dati. Se li guardiamo come valori scalari Unicode, che è ciò che è il tipo `char` di Rust, quei byte assomigliano a questo:

```text
['न', 'म', 'स', '्', 'त', 'े']
```

Ci sono sei valori `char` qui, ma il quarto e il sesto non sono lettere: sono diacritici che non hanno senso da soli. Infine, se li guardiamo come cluster di grafemi, otterremmo ciò che una persona chiamerebbe le quattro lettere che compongono la parola hindi:

```text
["न", "म", "स्", "ते"]
```

Rust fornisce diversi modi di interpretare i dati grezzi della stringa che i computer memorizzano in modo che ogni programma possa scegliere l'interpretazione di cui ha bisogno, indipendentemente dalla lingua umana in cui sono i dati.

Un'ultima ragione per cui Rust non ci permette di indicizzare in una `String` per ottenere un carattere è che le operazioni di indicizzazione sono attese per avere sempre un tempo costante (O(1)). Ma non è possibile garantire quella prestazione con una `String`, perché Rust dovrebbe scorrere il contenuto dall'inizio all'indice per determinare quanti caratteri validi ci fossero.

### Frazionare le Stringhe

Indicizzare in una stringa è spesso una cattiva idea perché non è chiaro quale dovrebbe essere il tipo di ritorno dell'operazione di indicizzazione della stringa: un valore del byte, un carattere, un cluster di grafemi o una string slice. Se avete davvero bisogno di usare indici per creare frazioni di stringhe, quindi, Rust richiede di essere più specifici.

Anziché indicizzare usando `[]` con un numero singolo, potete usare `[]` con un intervallo per creare una string slice contenente dei byte particolari:

```rust
let hello = "Здравствуйте";

let s = &hello[0..4];
```

Qui, `s` sarà un `&str` che contiene i primi quattro byte della stringa. In precedenza, abbiamo menzionato che ciascuno di questi caratteri era di due byte, il che significa che `s` sarà `Зд`.
Se cercassimo di effettuare uno Slice solo su una parte dei byte di un carattere con qualcosa come `&hello[0..1]`, Rust andrebbe in Panic a runtime nello stesso modo in cui accadrebbe se fosse acceduto un indice non valido in un vettore:

```console
{{#include ../listings/ch08-common-collections/output-only-01-not-char-boundary/output.txt}}
```

Dovresti prestare attenzione quando crei String Slices con Range, perché farlo potrebbe causare il crash del tuo programma.

### Metodi per iterare sulle String

Il modo migliore per operare su parti di stringhe è essere espliciti se desideri caratteri o byte. Per i singoli valori scalari Unicode, utilizza il metodo `chars`. Chiamare `chars` su “Зд” separa e restituisce due valori di tipo `char`, e puoi iterare sul risultato per accedere a ciascun elemento:

```rust
for c in "Зд".chars() {
    println!("{c}");
}
```

Questo codice stamperà il seguente output:

```text
З
д
```

In alternativa, il metodo `bytes` restituisce ciascun byte grezzo, il che potrebbe essere adatto per il tuo dominio:

```rust
for b in "Зд".bytes() {
    println!("{b}");
}
```

Questo codice stamperà i quattro byte che compongono questa stringa:

```text
208
151
208
180
```

Ma assicurati di ricordare che i valori scalari Unicode validi possono essere composti da più di un byte.

Ottenere cluster di grafemi dalle stringhe, come con lo script Devanagari, è complesso, quindi questa funzionalità non è fornita dalla libreria standard. Crates sono disponibili su [crates.io](https://crates.io/)<!-- ignore --> se questa è la funzionalità di cui hai bisogno.

### Le String non sono così semplici

Per riassumere, le stringhe sono complicate. I diversi linguaggi di programmazione fanno scelte diverse su come presentare questa complessità al programmatore. Rust ha scelto di rendere la gestione corretta dei dati `String` il comportamento predefinito per tutti i programmi Rust, il che significa che i programmatori devono pensare di più alla gestione dei dati UTF-8 all'inizio. Questo compromesso espone più complessità delle stringhe rispetto a quanto appaia in altri linguaggi di programmazione, ma ti impedisce di dover gestire errori legati ai caratteri non ASCII più avanti nel ciclo di sviluppo.

La buona notizia è che la libreria standard offre molta funzionalità basata sui tipi `String` e `&str` per aiutare a gestire correttamente queste situazioni complesse. Assicurati di controllare la documentazione per metodi utili come `contains` per cercare in una stringa e `replace` per sostituire parti di una stringa con un'altra stringa.

Passiamo a qualcosa di un po' meno complesso: le hash map!
