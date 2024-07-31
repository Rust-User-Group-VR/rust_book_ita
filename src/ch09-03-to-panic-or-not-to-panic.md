## `panic!` o non `panic!`

Allora, come decidere se chiamare `panic!` o restituire `Result`? Quando il codice va in panico, non c'è modo di recuperare. Potresti chiamare `panic!` per qualsiasi situazione di errore, che ci sia o meno un modo possibile per recuperare, ma così stai decidendo che una situazione è irreversibile per conto del codice chiamante. Quando scegli di restituire un valore `Result`, dai al codice chiamante delle opzioni. Il codice chiamante potrebbe scegliere di tentare di recuperare in un modo appropriato per la sua situazione, oppure potrebbe decidere che un valore `Err` in questo caso è irrecuperabile, quindi può chiamare `panic!` e trasformare il tuo errore recuperabile in uno irrecuperabile. Pertanto, restituire `Result` è una buona scelta predefinita quando stai definendo una funzione che potrebbe fallire.

In situazioni come esempi, codice prototipo e test, è più appropriato scrivere codice che va in panico invece di restituire un `Result`. Esploriamo il perché, poi discutiamo situazioni in cui il compilatore non può dire che il fallimento è impossibile, ma tu come essere umano puoi. Il capitolo si concluderà con alcune linee guida generali su come decidere se andare in panico nel codice delle librerie.

### Esempi, Codice Prototipo e Test

Quando stai scrivendo un esempio per illustrare qualche concetto, includere anche un robusto codice di gestione degli errori può rendere l'esempio meno chiaro. Negli esempi, è inteso che una chiamata a un metodo come `unwrap` che potrebbe andare in panico sia un segnaposto per il modo in cui vorresti che la tua applicazione gestisse gli errori, il che può differire a seconda di cosa sta facendo il resto del tuo codice.

Similarmente, i metodi `unwrap` e `expect` sono molto utili quando stai facendo prototipi, prima di essere pronto a decidere come gestire gli errori. Lasciano chiari marcatori nel tuo codice per quando sei pronto a rendere il tuo programma più robusto.

Se una chiamata al metodo fallisce in un test, vorresti che l'intero test fallisse, anche se quel metodo non è la funzionalità sotto test. Poiché `panic!` è il modo in cui un test è segnato come un fallimento, chiamare `unwrap` o `expect` è esattamente ciò che dovrebbe accadere.

### Casi in cui Hai Più Informazioni del Compilatore

Sarebbe anche appropriato chiamare `unwrap` o `expect` quando hai una qualche altra logica che garantisce che il `Result` avrà un valore `Ok`, ma la logica non è qualcosa che il compilatore capisce. Avrai comunque un valore `Result` che devi gestire: qualsiasi operazione che stai chiamando ha comunque la possibilità di fallire in generale, anche se è logicamente impossibile nella tua situazione particolare. Se puoi assicurarti ispezionando manualmente il codice che non avrai mai una variante `Err`, è perfettamente accettabile chiamare `unwrap` ed è ancora meglio documentare il motivo per cui pensi che non avrai mai una variante `Err` nel testo di `expect`. Ecco un esempio:

```rust
{{#rustdoc_include ../listings/ch09-error-handling/no-listing-08-unwrap-that-cant-fail/src/main.rs:here}}
```

Stiamo creando un'istanza di `IpAddr` analizzando una stringa hardcoded. Possiamo vedere che `127.0.0.1` è un indirizzo IP valido, quindi è accettabile usare `expect` qui. Tuttavia, avere una stringa valida hardcoded non cambia il tipo di ritorno del metodo `parse`: otteniamo comunque un valore `Result`, e il compilatore ci farà comunque gestire il `Result` come se la variante `Err` fosse una possibilità perché il compilatore non è abbastanza intelligente da vedere che questa stringa è sempre un indirizzo IP valido. Se la stringa dell'indirizzo IP provenisse da un utente piuttosto che essere hardcoded nel programma e quindi *avesse* una possibilità di fallimento, vorremmo sicuramente gestire il `Result` in modo più robusto. Menzionare l'assunzione che questo indirizzo IP sia hardcoded ci spingerà a cambiare `expect` in un codice di gestione degli errori migliore se, in futuro, dovessimo ottenere l'indirizzo IP da qualche altra fonte.

### Linee Guida per la Gestione degli Errori

È consigliabile far andare il codice in panico quando è possibile che il codice possa trovarsi in uno stato cattivo. In questo contesto, un *cattivo stato* è quando qualche assunzione, garanzia, contratto o invariante è stato infranto, come quando valori non validi, valori contraddittori o valori mancanti vengono passati al codice — più uno o più dei seguenti:

* Il cattivo stato è qualcosa che è inaspettato, contrariamente a qualcosa che probabilmente accade occasionalmente, come un utente che inserisce dati nel formato sbagliato.
* Il tuo codice dopo questo punto ha bisogno di non essere in questo stato cattivo, piuttosto che controllare il problema a ogni passo.
* Non c'è un buon modo per codificare queste informazioni nei tipi che usi. Lavoreremo attraverso un esempio di cosa intendiamo nella sezione [“Encoding States and Behavior as Types”][encoding]<!-- ignore --> del Capitolo 17.

Se qualcuno chiama il tuo codice e passa valori che non hanno senso, è meglio restituire un errore se puoi così l'utente della libreria può decidere cosa vuole fare in quel caso. Tuttavia, nei casi in cui continuare potrebbe essere insicuro o dannoso, la scelta migliore potrebbe essere chiamare `panic!` e avvisare la persona che usa la tua libreria del bug nel loro codice in modo che possa risolverlo durante lo sviluppo. Similmente, `panic!` è spesso appropriato se stai chiamando codice esterno che è fuori dal tuo controllo e restituisce uno stato non valido che non hai modo di risolvere.

Tuttavia, quando il fallimento è previsto, è più appropriato restituire un `Result` piuttosto che fare una chiamata `panic!`. Esempi includono un parser che viene dato dati malformati o una richiesta HTTP che restituisce uno stato che indica che hai raggiunto un limite di velocità. In questi casi, restituire un `Result` indica che il fallimento è una possibilità prevista che il codice chiamante deve decidere come gestire.

Quando il tuo codice esegue un'operazione che potrebbe mettere a rischio l'utente se viene chiamata utilizzando valori non validi, il tuo codice dovrebbe verificare che i valori siano validi prima e andare in panico se i valori non sono validi. Questo è principalmente per motivi di sicurezza: tentare di operare su dati non validi può esporre il tuo codice a vulnerabilità. Questo è il motivo principale per cui la libreria standard chiama `panic!` se tenti un accesso alla memoria fuori dai limiti: cercare di accedere alla memoria che non appartiene alla struttura dati corrente è un problema di sicurezza comune. Le funzioni spesso hanno *contratti*: il loro comportamento è garantito solo se gli input soddisfano particolari requisiti. Andare in panico quando il contratto è violato ha senso perché una violazione del contratto indica sempre un bug lato chiamante, e non è un tipo di errore che vuoi che il codice chiamante debba gestire esplicitamente. In effetti, non c'è modo ragionevole per il codice chiamante di recuperare; i *programmatori* chiamanti devono correggere il codice. I contratti per una funzione, specialmente quando una violazione causerà un panico, dovrebbero essere spiegati nella documentazione dell'API per la funzione.

Tuttavia, avere molti controlli degli errori in tutte le tue funzioni sarebbe prolisso e fastidioso. Fortunatamente, puoi usare il sistema di tipi di Rust (e quindi il controllo dei tipi fatto dal compilatore) per fare molti dei controlli per te. Se la tua funzione ha un particolare tipo come parametro, puoi procedere con la logica del tuo codice sapendo che il compilatore ha già assicurato che hai un valore valido. Ad esempio, se hai un tipo piuttosto che un `Option`, il tuo programma si aspetta di avere *qualcosa* piuttosto che *niente*. Il tuo codice quindi non deve gestire due casi per le varianti `Some` e `None`: avrà solo un caso per avere sicuramente un valore. Il codice che cerca di passare niente alla tua funzione non verrà nemmeno compilato, quindi la tua funzione non deve verificare quel caso a runtime. Un altro esempio è utilizzare un tipo integer senza segno come `u32`, che assicura che il parametro non sia mai negativo.

### Creazione di Tipi Personalizzati per la Validazione

Prendiamo l'idea di usare il sistema di tipi di Rust per assicurarci di avere un valore valido un passo avanti e guardiamo alla creazione di un tipo personalizzato per la validazione. Ricorda il gioco d'ipotesi nel Capitolo 2 in cui il nostro codice chiedeva all'utente di indovinare un numero tra 1 e 100. Non abbiamo mai validato che l'ipotesi dell'utente fosse tra quei numeri prima di controllarla contro il nostro numero segreto; abbiamo solo validato che l'ipotesi fosse positiva. In questo caso, le conseguenze non erano molto gravi: la nostra risposta di "Troppo alto" o "Troppo basso" sarebbe comunque stata corretta. Ma sarebbe un miglioramento utile guidare l'utente verso ipotesi valide e avere un comportamento diverso quando l'utente ipotizza un numero fuori dal range rispetto a quando l'utente digita, per esempio, lettere.

Un modo per fare questo sarebbe analizzare l'ipotesi come un `i32` invece di solo un `u32` per consentire potenzialmente numeri negativi, e poi aggiungere un controllo per il numero che sia nel range, così:

<span class="filename">Nome del file: src/main.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch09-error-handling/no-listing-09-guess-out-of-range/src/main.rs:here}}
```

L'espressione `if` controlla se il nostro valore è fuori dal range, informa l'utente del problema e chiama `continue` per iniziare la prossima iterazione del ciclo e chiedere un'altra ipotesi. Dopo l'espressione `if`, possiamo procedere con i confronti tra `guess` e il numero segreto sapendo che `guess` è tra 1 e 100.

Tuttavia, questa non è una soluzione ideale: se fosse assolutamente critico che il programma operasse solo su valori tra 1 e 100, e avesse molte funzioni con questo requisito, avere un controllo come questo in ogni funzione sarebbe tedioso (e potrebbe influire sulle prestazioni).

Invece, possiamo creare un nuovo tipo e mettere le convalide in una funzione per creare un'istanza del tipo piuttosto che ripetere le convalide ovunque. In questo modo, è sicuro per le funzioni utilizzare il nuovo tipo nelle loro firme e utilizzare con sicurezza i valori che ricevono. Elenco 9-13 mostra un modo per definire un tipo `Guess` che creerà solo un'istanza di `Guess` se la funzione `new` riceve un valore tra 1 e 100.

<span class="filename">Nome del file: src/lib.rs</span>

```rust
{{#rustdoc_include ../listings/ch09-error-handling/listing-09-13/src/lib.rs}}
```

<span class="caption">Elenco 9-13: Un tipo `Guess` che continuerà solo con valori tra 1 e 100</span>

Per prima cosa definiamo una struct chiamata `Guess` che ha un campo chiamato `value` che contiene un `i32`. Questo è dove sarà memorizzato il numero.

Poi implementiamo una funzione associata chiamata `new` su `Guess` che crea istanze di valori `Guess`. La funzione `new` è definita per avere un parametro chiamato `value` di tipo `i32` e per restituire un `Guess`. Il codice nel corpo della funzione `new` testa `value` per assicurarsi che sia tra 1 e 100. Se `value` non passa questo test, facciamo una chiamata `panic!`, che avviserà il programmatore che sta scrivendo il codice chiamante che ha un bug che deve risolvere, perché creare un `Guess` con un `value` fuori da questo range violerebbe il contratto su cui fa affidamento `Guess::new`. Le condizioni in cui `Guess::new` potrebbe andare in panico dovrebbero essere discusse nella documentazione dell'API pubblica; tratteremo le convenzioni di documentazione che indicano la possibilità di un `panic!` nella documentazione dell'API che crei nel Capitolo 14. Se `value` passa il test, creiamo un nuovo `Guess` con il campo `value` impostato sul parametro `value` e restituiamo il `Guess`.

Successivamente, implementiamo un metodo chiamato `value` che prende in prestito `self`, non ha altri parametri e restituisce un `i32`. Questo tipo di metodo è talvolta chiamato *getter* perché il suo scopo è ottenere qualche dato dai suoi campi e restituirlo. Questo metodo pubblico è necessario perché il campo `value` della struct `Guess` è privato. È importante che il campo `value` sia privato in modo che il codice che utilizza la struct `Guess` non possa impostare direttamente `value`: il codice al di fuori del modulo *deve* utilizzare la funzione `Guess::new` per creare un'istanza di `Guess`, garantendo così che non vi sia modo per un `Guess` di avere un `value` che non è stato controllato dalle condizioni nella funzione `Guess::new`.

Una funzione che ha un parametro o restituisce solo numeri tra 1 e 100 potrebbe quindi dichiarare nella sua firma che accetta o restituisce un `Guess` piuttosto che un `i32` e non avrebbe bisogno di fare alcun controllo aggiuntivo nel suo corpo.

## Sommario

Le funzionalità di gestione degli errori di Rust sono progettate per aiutarti a scrivere codice più robusto. La macro `panic!` segnala che il tuo programma è in uno stato che non può gestire e ti permette di dire al processo di fermarsi invece di tentare di procedere con valori non validi o errati. L'enum `Result` utilizza il sistema di tipi di Rust per indicare che le operazioni potrebbero fallire in un modo da cui il tuo codice potrebbe recuperare. Puoi usare `Result` per dire al codice che chiama il tuo codice che deve gestire il successo potenziale o il fallimento. Usare `panic!` e `Result` nelle situazioni appropriate renderà il tuo codice più affidabile di fronte a problemi inevitabili.

Ora che hai visto modi utili in cui la libreria standard usa i generici con gli enum `Option` e `Result`, parleremo di come funzionano i generici e di come puoi usarli nel tuo codice.

[encoding]: ch17-03-oo-design-patterns.html#encoding-states-and-behavior-as-types
