## Per `panic!` o Non per `panic!`

Quindi, come decidi quando dovresti chiamare `panic!` e quando dovresti restituire
`Result`? Quando il codice si blocca, non c'è modo di recuperare. Potresti chiamare `panic!`
per qualsiasi situazione di errore, sia che sia possibile un recupero o meno, ma
allora stai prendendo la decisione che una situazione è irrecuperabile per conto
del codice chiamante. Quando scegli di restituire un valore `Result`, dai al
codice chiamante delle opzioni. Il codice chiamante potrebbe scegliere di tentare di recuperare in un
modo che è appropriato per la sua situazione, o potrebbe decidere che un valore `Err`
in questo caso è irrecuperabile, quindi può chiamare `panic!` e trasformare il tuo
errore recuperabile in uno irrecuperabile. Pertanto, restituire `Result` è un
buona scelta predefinita quando stai definendo una funzione che potrebbe fallire.

In situazioni come esempi, codice prototipo e test, è più
appropriato scrivere codice che blocca invece di restituire un `Result`. Esploreremo perché, poi discuteremo situazioni in cui il compilatore non può capire che
il fallimento è impossibile, ma tu come umano puoi. Il capitolo concluderà con
alcune linee guida generali su come decidere se bloccare nel codice di libreria.

### Esempi, Codice Prototipo e Test

Quando stai scrivendo un esempio per illustrare un concetto, includere anche il robusto
il codice di gestione degli errori può rendere l'esempio meno chiaro. Negli
esempi, si capisce che una chiamata a un metodo come `unwrap` che potrebbe
bloccare è pensata come segnaposto per il modo in cui vorresti che la tua applicazione gestisca
gli errori, che possono variare in base a ciò che sta facendo il resto del tuo codice.

Allo stesso modo, i metodi `unwrap` e `expect` sono molto utili quando si sta prototipando,
prima di essere pronti a decidere come gestire gli errori. Lasciano chiari segnali nel
tuo codice per quando sei pronto a rendere il tuo programma più robusto.

Se una chiamata a un metodo fallisce in un test, vorresti che l'intero test fallisse, anche se
quel metodo non è la funzionalità sotto test. Poiché `panic!` è come un test
viene contrassegnata come fallimento, chiamare `unwrap` o `expect` è esattamente ciò che dovrebbe
accadere.

### Casi in cui hai più informazioni del compilatore

Sarebbe anche appropriato chiamare `unwrap` o `expect` quando hai un po'
altra logica che assicura che il `Result` avrà un valore `Ok`, ma la logica
non è qualcosa che il compilatore capisce. Avrai ancora un valore `Result`
che devi gestire: qualunque operazione stai chiamando ha ancora la
possibilità di fallire in generale, anche se è logicamente impossibile in
la tua situazione particolare. Se puoi assicurarti ispezionando manualmente il codice
che non avrai mai una variante `Err`, è perfettamente accettabile chiamare
`unwrap`, e ancora meglio documentare il motivo per cui pensi che non avrai mai una
variante `Err` nel testo di `expect`. Ecco un esempio:

```rust
{{#rustdoc_include ../listings/ch09-error-handling/no-listing-08-unwrap-that-cant-fail/src/main.rs:here}}
```

Stiamo creando un'istanza `IpAddr` analizzando una stringa hardcoded. Possiamo vedere
che `127.0.0.1` è un indirizzo IP valido, quindi è accettabile utilizzare `expect`
qui. Tuttavia, avere una stringa valida e hardcoded non modifica il tipo di ritorno
del metodo `parse`: otteniamo ancora un valore `Result`, e il compilatore 
deve ancora farci gestire il `Result` come se la variante `Err` fosse una possibilità
perché il compilatore non è abbastanza intelligente da capire che questa stringa è sempre un
indirizzo IP valido. Se la stringa dell'indirizzo IP provenisse da un utente anziché essere
hardcoded nel programma e quindi *avesse* una possibilità di fallimento,
vorremmo sicuramente gestire il `Result` in un modo più robusto invece.
Menzionare l'assunzione che questo indirizzo IP sia hardcoded ci spingerà a
cambiare `expect` con un codice di gestione degli errori migliore se in futuro, abbiamo bisogno di ottenere
l'indirizzo IP da qualche altra fonte.

### Linee Guida per la Gestione degli Errori

È consigliabile far bloccare il tuo codice quando è possibile che il tuo codice
potrebbe finire in uno stato non valido. In questo contesto, uno *stato cattivo* è quando un
ipotesi, garanzia, contratto o invariante è stato violato, come quando
valori non validi, valori contraddittori o valori mancanti vengono passati al tuo
codice—più uno o più dei seguenti:

* Lo stato non valido è qualcosa che non ci si aspetta, contrariamente a qualcosa che
  potrebbe accadere occasionalmente, come un utente che inserisce dati nel formato sbagliato.
* Il tuo codice dopo questo punto ha bisogno di non essere in questo stato cattivo,
  piuttosto che controllare il problema ad ogni passo.
* Non c'è un buon modo per codificare queste informazioni nei tipi che usi. Attraverseremo
  un esempio di cosa vogliamo dire nella [sezione "Codificare stati e comportamenti
  come tipi"][encoding]<!-- ignore --> del capitolo 17.

Se qualcuno chiama il tuo codice e passa dei valori che non hanno senso, è
meglio restituire un errore se puoi in modo che l'utente della libreria possa decidere che cosa
vuole fare in quel caso. Tuttavia, nei casi in cui continuare potrebbe essere
insicuro o dannoso, la scelta migliore potrebbe essere chiamare `panic!` e avvisare la
persona che utilizza la tua libreria del bug nel suo codice in modo che possa correggerlo durante
lo sviluppo. Allo stesso modo, `panic!` è spesso appropriato se stai chiamando
codice esterno che è fuori dal tuo controllo e restituisce uno stato non valido che
non hai modo di correggere.

Tuttavia, quando il fallimento è atteso, è più appropriato restituire un `Result`
piuttosto che fare una chiamata a `panic!`. Esempi includono un parser cui viene fornito dati malformati
o una richiesta HTTP che restituisce uno stato che indica che hai raggiunto un limite di velocità.
In questi casi, restituire un `Result` indica che il fallimento è un'
possibilità attesa che il codice chiamante deve decidere come gestire.

Quando il tuo codice esegue un'operazione che potrebbe mettere un utente a rischio se è
chiamato utilizzando valori non validi, il tuo codice dovrebbe verificare prima che i valori siano validi 
e bloccarsi se i valori non sono validi. Questo è principalmente per motivi di sicurezza:
tentare di operare su dati non validi può esporre il tuo codice a vulnerabilità.
Questo è il motivo principale per cui la libreria standard chiamerà `panic!` se si tenta
un accesso alla memoria fuori dai limiti: cercare di accedere alla memoria che non appartiene a
la struttura dati corrente è un problema di sicurezza comune. Le funzioni spesso hanno
*contratti*: il loro comportamento è garantito solo se gli input soddisfano particolari
requisiti. Il blocco quando il contratto viene violato ha senso perché una
violazione del contratto indica sempre un bug nel chiamante e non è un tipo di
errore che vuoi che il codice chiamante debba gestire esplicitamente. Di fatto, non c'è
nessun modo ragionevole per il codice chiamante di recuperare; i *programmatori* chiamanti devono
correggere il codice. I contratti per una funzione, specialmente quando una violazione causerà
un blocco, dovrebbero essere spiegati nella documentazione API della funzione.

Tuttavia, avere molti controlli di errore in tutte le tue funzioni sarebbe verboso
e fastidioso. Fortunatamente, puoi utilizzare il sistema di tipi di Rust (e quindi il tipo
controllo fatto dal compilatore) per fare molti dei controlli per te. Se il tuo
funzione ha un tipo particolare come parametro, puoi procedere con la logica del tuo codice
sapendo che il compilatore si è già assicurato che tu abbia un valore valido. Ad esempio, se hai un tipo invece di un `Option`, il tuo programma si aspetta di
avere *qualcosa* invece di *niente*. Il tuo codice quindi non deve gestire
due casi per le varianti `Some` e `None`: avrà solo un caso per
aver sicuramente un valore. Il codice che tenta di passare nulla alla tua funzione non sarà
nemmeno compilato, quindi la tua funzione non deve controllare quel caso a runtime.
Un altro esempio è l'uso di un tipo di intero senza segno come `u32`, che garantisce
che il parametro non è mai negativo.

### Creazione di Tipi Personalizzati per la Validazione


Andiamo un passo avanti con l'idea di utilizzare il sistema di tipi di Rust per garantire di avere un valore valido e guardiamo la creazione di un tipo personalizzato per la convalida. Ricordiamo il gioco di indovinare nel Capitolo 2 in cui il nostro codice chiedeva all'utente di indovinare un numero
tra 1 e 100. Non abbiamo mai convalidato che l'indovinello dell'utente fosse tra quei
numeri prima di confrontarlo con il nostro numero segreto; abbiamo solo convalidato che
l'indovinello fosse positivo. In questo caso, le conseguenze non erano molto gravi: il nostro
output di "Troppo alto" o "Troppo basso" sarebbe comunque corretto. Ma sarebbe un
miglioramento utile guidare l'utente verso indovinelli validi e avere un comportamento diverso quando un utente indovina un numero che è fuori range rispetto a quando un utente
scrive, ad esempio, lettere.

Un modo per farlo sarebbe analizzare l'indovinello come un `i32` invece di solo un
`u32` per consentire potenzialmente numeri negativi, e poi aggiungere un controllo per il
numero in range, come il seguente:

```rust,ignore
{{#rustdoc_include ../listings/ch09-error-handling/no-listing-09-guess-out-of-range/src/main.rs:here}}
```

L'espressione `if` controlla se il nostro valore è fuori range, informa l'utente
del problema e chiama `continue` per iniziare la prossima iterazione del loop
e chiedere un altro indovinello. Dopo l'espressione `if`, possiamo procedere con i
confronti tra `guess` e il numero segreto sapendo che `guess` è
tra 1 e 100.

Tuttavia, questa non è una soluzione ideale: se fosse assolutamente critico che il
programma operasse solo su valori tra 1 e 100, e avesse molte funzioni
con questo requisito, avere un controllo come questo in ogni funzione sarebbe
noioso (e potrebbe avere un impatto sulle prestazioni).

Invece, possiamo creare un nuovo tipo e mettere le convalide in una funzione per creare
un'istanza del tipo piuttosto che ripetere le convalide ovunque. In questo modo,
è sicuro per le funzioni usare il nuovo tipo nelle loro firme e
utilizzare con fiducia i valori che ricevono. La Tabella 9-13 mostra un modo per definire un
tipo `Guess` che creerà solo un'istanza di `Guess` se la funzione `new` riceve un valore tra 1 e 100.

<!-- Non sto usando qui deliberatamente rustdoc_include; la funzione `main` nel
file richiede la crate `rand`. Vogliamo includerlo per scopi di
sperimentazione del lettore, ma non vogliamo includerlo per scopi di test di rustdoc
. -->

```rust
{{#include ../listings/ch09-error-handling/listing-09-13/src/main.rs:here}}
```

<span class="caption">Tabella 9-13: Un tipo `Guess` che continuerà solo con
valori tra 1 e 100</span>

Prima, definiamo una Struct chiamata `Guess` che ha un campo chiamato `value` che
contiene un `i32`. Questo è dove il numero sarà memorizzato.

Poi implementiamo una funzione associata chiamata `new` su `Guess` che crea
istanze di valori `Guess`. La funzione `new` è definita per avere un
parametro chiamato `value` di tipo `i32` e per restituire un `Guess`. Il codice nel
corpo della funzione `new` testa `value` per assicurarsi che sia tra 1 e 100.
Se `value` non supera questo test, facciamo una chiamata a `panic!`, che allerterà
il programmatore che sta scrivendo il codice chiamante che ha un bug che ha bisogno
di fixare, perché creare un `Guess` con un `value` fuori di questo range avrebbe
violato il contratto che `Guess::new` sta contando su. Le condizioni in cui
`Guess::new` potrebbe entrare in panic dovrebbero essere discusse nella sua API
documentazione di fronte al pubblico; copriremo le convenzioni di documentazione che indicano la possibilità di un `panic!` nella documentazione dell'API che crei nel Capitolo 14. Se
`value` supera il test, creiamo un nuovo `Guess` con il suo campo `value` impostato al
parametro `value` e restituire il `Guess`.

Successivamente, implementiamo un metodo chiamato `value` che prende in prestito `self`, non ha alcun
altri parametri, e restituisce un `i32`. Questo tipo di metodo è talvolta chiamato
un *getter*, perché il suo scopo è ottenere alcuni dati dai suoi campi e restituirli. Questo metodo pubblico è necessario perché il campo `value` della struct `Guess`
è privato. È importante che il campo `value` sia privato in modo che il codice
che utilizza la struct `Guess` non sia autorizzato a impostare `value` direttamente: il codice al di fuori del modulo *deve* utilizzare la funzione `Guess::new` per creare un'istanza di `Guess`, garantendo così che non ci sia modo per un `Guess` di avere un `value` che non sia stato controllato dalle condizioni nella funzione `Guess::new`.

Una funzione che ha un parametro o restituisce solo numeri tra 1 e 100 potrebbe
poi dichiare nella sua firma che prende o restituisce un `Guess` invece di un
`i32` e non avrebbe bisogno di fare nessun ulteriore controllo nel suo corpo.

## Sommario

Le funzionalità di gestione degli errori di Rust sono progettate per aiutarti a scrivere codice più robusto.
La macro `panic!` segnala che il tuo programma è in uno stato che non può gestire e
ti permette di dire al processo di fermarsi invece di cercare di procedere con valori non validi o
errati. L'enum `Result` utilizza il sistema di tipi di Rust per indicare che le operazioni potrebbero fallire in un modo da cui il tuo codice potrebbe riprendersi. Puoi usare
`Result` per dire al codice che chiama il tuo codice che ha bisogno di gestire potenziali
successi o fallimenti. Utilizzare `panic!` e `Result` nelle situazioni
appropriate renderà il tuo codice più affidabile di fronte a problemi inevitabili.

Ora che hai visto modi utili in cui la libreria standard utilizza i generici con
gli enum `Option` e `Result`, parleremo di come funzionano i generici e di come puoi
utilizzarli nel tuo codice.

[encoding]: ch17-03-oo-design-patterns.html#encoding-states-and-behavior-as-types

