## Memorizzare Testo Codificato UTF-8 con Strings

Abbiamo parlato delle stringhe nel Capitolo 4, ma adesso le esamineremo più nel dettaglio. I nuovi Rustaceans trovano spesso difficoltà con le stringhe per una combinazione di tre ragioni: la propensione di Rust a esporre possibili errori, le stringhe essendo una struttura dati più complicata di quanto molti programmatori pensino, e UTF-8. Questi fattori si combinano in un modo che può sembrare difficile quando si proviene da altri linguaggi di programmazione.

Discutiamo delle stringhe nel contesto delle collezioni perché le stringhe sono implementate come una collezione di byte, oltre a metodi che forniscono funzionalità utili quando quei byte sono interpretati come testo. In questa sezione, parleremo delle operazioni su `String` che ogni tipo di collezione ha, come creare, aggiornare e leggere. Discuteremo anche i modi in cui `String` è diversa dalle altre collezioni, cioè come l'indicizzazione di una `String` è complicata dalle differenze tra come le persone e i computer interpretano i dati `String`.

### Cos'è una String?

Per prima cosa definiremo cosa intendiamo per il termine *stringa*. Rust ha solo un tipo di stringa nel linguaggio base, che è lo string slice `str` che solitamente si vede nella sua forma presa in prestito `&str`. Nel Capitolo 4, abbiamo parlato delle *string slices*, che sono riferimenti ad alcuni dati di stringa codificati UTF-8 memorizzati altrove. I letterali di stringa, per esempio, sono memorizzati nel binario del programma e sono quindi string slices.

Il tipo `String`, che è fornito dalla libreria standard di Rust piuttosto che codificato nel linguaggio base, è un tipo di stringa codificata UTF-8, cresciuta, mutabile, di proprietà. Quando i Rustaceans si riferiscono a “stringhe” in Rust, potrebbero riferirsi sia ai tipi `String` sia allo string slice `&str`, non solo a uno di questi tipi. Sebbene questa sezione sia in gran parte su `String`, entrambi i tipi sono utilizzati ampiamente nella libreria standard di Rust, ed entrambe `String` e string slices sono codificate UTF-8.

### Creare una Nuova String

Molte delle stesse operazioni disponibili con `Vec<T>` sono disponibili anche con `String` poiché `String` è effettivamente implementata come un wrapper intorno a un vettore di byte con alcune garanzie, restrizioni e capacità extra. Un esempio di una funzione che funziona allo stesso modo con `Vec<T>` e `String` è la funzione `new` per creare un'istanza, mostrata nel Listing 8-11.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-11/src/main.rs:here}}
```

<span class="caption">Listing 8-11: Creare una nuova, vuota `String`</span>

Questa linea crea una nuova stringa vuota chiamata `s`, nella quale possiamo poi caricare i dati. Spesso, avremo alcuni dati iniziali con cui vogliamo iniziare la stringa. Per questo, usiamo il metodo `to_string`, che è disponibile su qualsiasi tipo che implementa il trait `Display`, come fanno i letterali di stringa. Listing 8-12 mostra due esempi.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-12/src/main.rs:here}}
```

<span class="caption">Listing 8-12: Usare il metodo `to_string` per creare una
`String` da un letterale di stringa</span>

Questo codice crea una stringa contenente `initial contents`.

Possiamo anche utilizzare la funzione `String::from` per creare una `String` da un letterale di stringa. Il codice nel Listing 8-13 è equivalente al codice nel Listing 8-12 che utilizza `to_string`.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-13/src/main.rs:here}}
```

<span class="caption">Listing 8-13: Usare la funzione `String::from` per creare una `String` da un letterale di stringa</span>

Poiché le stringhe sono utilizzate per molte cose, possiamo utilizzare molte API generiche diverse per le stringhe, fornendoci molte opzioni. Alcune di esse possono sembrare ridondanti, ma tutte hanno il loro posto! In questo caso, `String::from` e `to_string` fanno la stessa cosa, quindi quale scegliete è una questione di stile e leggibilità.

Ricorda che le stringhe sono codificate UTF-8, quindi possiamo includere in esse qualsiasi dato codificato correttamente, come mostrato nel Listing 8-14.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-14/src/main.rs:here}}
```

<span class="caption">Listing 8-14: Memorizzare saluti in diverse lingue nelle stringhe</span>

Tutti questi sono valori di `String` validi.

### Aggiornare una String

Una `String` può crescere di dimensione e i suoi contenuti possono cambiare, proprio come i contenuti di un `Vec<T>`, se vi si aggiungono più dati. Inoltre, è possibile usare comodamente l'operatore `+` o la macro `format!` per concatenare valori `String`.

#### Appendere a una String con `push_str` e `push`

Possiamo far crescere una `String` utilizzando il metodo `push_str` per aggiungere una string slice, come mostrato nel Listing 8-15.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-15/src/main.rs:here}}
```

<span class="caption">Listing 8-15: Aggiungere una string slice a una `String` utilizzando il metodo `push_str`</span>

Dopo queste due linee, `s` conterrà `foobar`. Il metodo `push_str` prende una string slice perché non necessariamente vogliamo prendere possesso del parametro. Per esempio, nel codice nel Listing 8-16, vogliamo poter utilizzare `s2` dopo aver aggiunto i suoi contenuti a `s1`.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-16/src/main.rs:here}}
```

<span class="caption">Listing 8-16: Utilizzare una string slice dopo aver aggiunto i suoi contenuti a una `String`</span>

Se il metodo `push_str` prendesse possesso di `s2`, non potremmo stampare il suo valore nell'ultima riga. Tuttavia, questo codice funziona come ci aspettiamo!

Il metodo `push` prende un singolo carattere come parametro e lo aggiunge alla `String`. Il Listing 8-17 aggiunge la lettera *l* a una `String` utilizzando il metodo `push`.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-17/src/main.rs:here}}
```

<span class="caption">Listing 8-17: Aggiungere un carattere a un valore `String` utilizzando `push`</span>

Di conseguenza, `s` conterrà `lol`.

#### Concatenazione con l'Operatore `+` o la Macro `format!`

Spesso, vorrai combinare due stringhe esistenti. Un modo per farlo è utilizzare l'operatore `+`, come mostrato nel Listing 8-18.

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-18/src/main.rs:here}}
```

<span class="caption">Listing 8-18: Utilizzare l'operatore `+` per combinare due valori `String` in un nuovo valore `String`</span>

La stringa `s3` conterrà `Hello, world!`. Il motivo per cui `s1` non è più valido dopo l'aggiunta e il motivo per cui abbiamo usato un riferimento a `s2` ha a che fare con la firma del metodo che viene chiamato quando usiamo l'operatore `+`. L'operatore `+` utilizza il metodo `add`, la cui firma è simile a questa:

```rust,ignore
fn add(self, s: &str) -> String {
```

Nella libreria standard, vedrai `add` definito utilizzando tipi generici e tipologie associate. Qui, abbiamo sostituito i tipi concreti, che è ciò che accade quando chiamiamo questo metodo con valori `String`. Discutteremo i generici nel Capitolo 10. Questa firma ci fornisce gli indizi necessari per comprendere i punti difficili dell'operatore `+`.

Per prima cosa, `s2` ha un `&`, il che significa che stiamo aggiungendo un *reference* della seconda stringa alla prima stringa. Questo è dovuto al parametro `s` nella funzione `add`: possiamo aggiungere solo un `&str` a una `String`; non possiamo aggiungere due valori `String` insieme. Ma aspetta—il tipo di `&s2` è `&String`, non `&str`, come specificato nel secondo parametro per `add`. Quindi perché il Listing 8-18 compila?

Il motivo per cui possiamo utilizzare `&s2` nella chiamata a `add` è che il compilatore può *coercere* l'argomento `&String` in un `&str`. Quando chiamiamo il metodo `add`, Rust utilizza una *dereference coercion*, che qui trasforma `&s2` in `&s2[..]`. Discutteremo la dereference coercion più in dettaglio nel Capitolo 15. Poiché `add` non prende possesso del parametro `s`, `s2` sarà ancora una `String` valida dopo questa operazione.

In secondo luogo, possiamo vedere nella firma che `add` prende possesso di `self` perché `self` non ha un `&`. Questo significa che `s1` nel Listing 8-18 sarà spostato nella chiamata a `add` e non sarà più valido dopo. Quindi, sebbene `let s3 = s1 + &s2;` sembri che copierà entrambe le stringhe e ne creerà una nuova, questa istruzione in realtà prende possesso di `s1`, appende una copia dei contenuti di `s2`, e poi restituisce proprietà del risultato. In altre parole, sembra che stia facendo molte copie, ma non lo fa; l'implementazione è più efficiente della copia.

Se abbiamo bisogno di concatenare più stringhe, il comportamento dell'operatore `+` diventa insostenibile:

```rust
{{#rustdoc_include ../listings/ch08-common-collections/no-listing-01-concat-multiple-strings/src/main.rs:here}}
```

A questo punto, `s` sarà `tic-tac-toe`. Con tutti i caratteri `+` e `"`, è difficile vedere cosa stia succedendo. Per combinare le stringhe in modi più complicati, possiamo invece utilizzare la macro `format!`:

```rust
{{#rustdoc_include ../listings/ch08-common-collections/no-listing-02-format/src/main.rs:here}}
```

Questo codice imposta anche `s` a `tic-tac-toe`. La macro `format!` funziona come `println!`, ma invece di stampare l'output sullo schermo, restituisce una `String` con il contenuto. La versione del codice che utilizza `format!` è molto più facile da leggere, e il codice generato dalla macro `format!` utilizza riferimenti in modo che questa chiamata non prenda possesso di nessuno dei suoi parametri.

### Indicizzare nelle Stringhe

In molti altri linguaggi di programmazione, accedere ai singoli caratteri in una stringa facendo riferimento ad essi per indice è un'operazione valida e comune. Tuttavia, se provi ad accedere a parti di una `String` utilizzando la sintassi di indicizzazione in Rust, otterrai un errore. Considera il codice non valido nel Listing 8-19.

```rust,ignore,does_not_compile
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-19/src/main.rs:here}}
```

<span class="caption">Listing 8-19: Tentare di utilizzare la sintassi di indicizzazione con una String</span>

Questo codice risulterà nel seguente errore:

```console
{{#include ../listings/ch08-common-collections/listing-08-19/output.txt}}
```

L'errore e la nota raccontano la storia: le stringhe Rust non supportano l'indicizzazione. Ma perché no? Per rispondere a questa domanda, dobbiamo discutere su come Rust memorizza le stringhe in memoria.

#### Rappresentazione Interna

Una `String` è un wrapper su un `Vec<u8>`. Diamo un'occhiata ad alcune delle nostre stringhe esemplari codificate UTF-8 dal Listing 8-14. In primo luogo, questo:

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-14/src/main.rs:spanish}}
```

In questo caso, `len` sarà `4`, il che significa che il vettore che memorizza la stringa `Hola` è lungo 4 byte. Ognuna di queste lettere prende un byte quando viene codificata in UTF-8. La seguente riga, tuttavia, può sorprenderti (nota che questa stringa inizia con la lettera maiuscola cirillica *Ze*, non il numero 3):

```rust
{{#rustdoc_include ../listings/ch08-common-collections/listing-08-14/src/main.rs:russian}}
```

Se ti venisse chiesto quanto è lunga la stringa, potresti dire 12. In realtà, la risposta di Rust è 24: questo è il numero di byte che ci vogliono per codificare “Здравствуйте” in UTF-8, poiché ciascun valore scalare Unicode in quella stringa prende 2 byte di memoria. Pertanto, un indice nei byte della stringa non sempre corrisponderà a un valore scalare Unicode valido. Per dimostrare, considera questo codice Rust non valido:

```rust,ignore,does_not_compile
let hello = "Здравствуйте";
let answer = &hello[0];
```

Sai già che `answer` non sarà `З`, la prima lettera. Quando codificata in UTF-8, il primo byte di `З` è `208` e il secondo è `151`, quindi sembrerebbe che `answer` dovrebbe effettivamente essere `208`, ma `208` non è un carattere valido da solo. Restituire `208` probabilmente non è ciò che un utente vorrebbe se chiedesse la prima lettera di questa stringa; tuttavia, quello è l'unico dato che Rust ha a byte index 0. Gli utenti generalmente non vogliono che il valore del byte venga restituito, anche se la stringa contiene solo lettere latine: se `&"hello"[0]` fosse codice valido che restituiva il valore del byte, restituirebbe `104`, non `h`.

La risposta è, quindi, che per evitare di restituire un valore inatteso e causare bug che potrebbero non essere scoperti immediatamente, Rust non compila affatto questo codice e impedisce incomprensioni fin dall'inizio del processo di sviluppo.

#### Bytes, Valori Scalari e Cluster di Grafemi! Ahimè!

Un altro punto su UTF-8 è che ci sono effettivamente tre modi rilevanti per guardare le stringhe dal punto di vista di Rust: come byte, valori scalari e cluster di grafemi (la cosa più simile a ciò che chiameremmo *lettere*).

Se guardiamo la parola hindi “नमस्ते” scritta nell'alfabeto devanagari, è memorizzata come un vettore di valori `u8` che sembra così:

```text
[224, 164, 168, 224, 164, 174, 224, 164, 184, 224, 165, 141, 224, 164, 164,
224, 165, 135]
```

Sono 18 byte ed è come i computer memorizzano alla fine questi dati. Se li guardiamo come valori scalari Unicode, che è ciò che il tipo `char` di Rust è, quei byte sembrano così:

```text
['न', 'म', 'स', '्', 'त', 'े']
```

Ci sono sei valori `char` qui, ma il quarto e il sesto non sono lettere: sono diacritici che non hanno senso da soli. Infine, se li guardiamo come cluster di grafemi, otterremmo ciò che una persona chiamerebbe le quattro lettere che compongono la parola hindi:

```text
["न", "म", "स्", "ते"]
```

Rust fornisce diversi modi di interpretare i dati grezzi della stringa che i computer memorizzano in modo che ogni programma possa scegliere l'interpretazione di cui ha bisogno, indipendentemente dalla lingua umana in cui i dati sono.

Un ultimo motivo per cui Rust non ci permette di indicizzare una `String` per ottenere un carattere è che le operazioni di indicizzazione sono generalmente considerate operazioni a tempo costante (O(1)). Ma non è possibile garantire quella prestazione con una `String`, perché Rust dovrebbe camminare attraverso i contenuti dall'inizio all'indice per determinare quanti caratteri validi ci sono.

### Slicing delle Stringhe

Indicizzare una stringa è spesso un'idea cattiva perché non è chiaro quale dovrebbe essere il tipo di ritorno dell'operazione di indicizzazione della stringa: un valore di byte, un carattere, un cluster di grafemi o una string slice. Se davvero hai bisogno di usare indici per creare string slice, quindi, Rust ti chiede di essere più specifico.

Piuttosto che indicizzare usando `[]` con un singolo numero, puoi utilizzare `[]` con un range per creare una string slice contenente particolari byte:

```rust
let hello = "Здравствуйте";

let s = &hello[0..4];
```

Qui, `s` sarà una `&str` che contiene i primi quattro byte della stringa. In precedenza, abbiamo menzionato che ciascuno di questi caratteri era due byte, il che significa che `s` sarà `Зд`.

Se provassimo a fare uno slice di solo una parte dei byte di un carattere con qualcosa come `&hello[0..1]`, Rust andrebbe in panic a runtime nello stesso modo in cui accadrebbe se si accedesse a un indice non valido in un vettore:
```console
{{#include ../listings/ch08-common-collections/output-only-01-not-char-boundary/output.txt}}
```

Dovresti fare attenzione quando crei slice di stringhe con intervalli, perché farlo può far crashare il tuo programma.

### Metodi per Iterare sulle Stringhe

Il miglior modo per operare su pezzi di stringhe è essere espliciti riguardo a se vuoi caratteri o byte. Per i singoli valori scalari Unicode, usa il metodo `chars`. Chiamare `chars` su “Зд” separa e restituisce due valori di tipo `char`, e puoi iterare sul risultato per accedere a ciascun elemento:

```rust
for c in "Зд".chars() {
    println!("{c}");
}
```

Questo codice stamperà quanto segue:

```text
З
д
```

In alternativa, il metodo `bytes` restituisce ogni byte grezzo, il che potrebbe essere appropriato per il tuo dominio:

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

Recuperare le cluster dei grafemi dalle stringhe, come accade con la scrittura Devanagari, è complesso, quindi questa funzionalità non è fornita dalla libreria standard. I Crates sono disponibili su [crates.io](https://crates.io/)<!-- ignore --> se questa è la funzionalità di cui hai bisogno.

### Le Stringhe non sono così Semplici

Per riassumere, le stringhe sono complicate. I diversi linguaggi di programmazione fanno scelte diverse riguardo a come presentare questa complessità al programmatore. Rust ha scelto di rendere la gestione corretta dei dati `String` il comportamento predefinito per tutti i programmi Rust, il che significa che i programmatori devono pensare di più alla gestione dei dati UTF-8 sin dall'inizio. Questo compromesso espone più della complessità delle stringhe rispetto a quanto apparente in altri linguaggi di programmazione, ma ti previene dall'avere a che fare con errori relativi a caratteri non ASCII più avanti nel ciclo di sviluppo.

La buona notizia è che la libreria standard offre molte funzionalità costruite sui tipi `String` e `&str` per aiutare a gestire correttamente queste situazioni complesse. Assicurati di controllare la documentazione per metodi utili come `contains` per cercare in una stringa e `replace` per sostituire parti di una stringa con un'altra stringa.

Passiamo a qualcosa di un po' meno complesso: gli hash map!
```
