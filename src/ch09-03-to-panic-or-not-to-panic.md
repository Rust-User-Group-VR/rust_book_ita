## `panic!` o Non `panic!`

Quindi come decidere quando dovresti chiamare `panic!` e quando dovresti restituire `Result`? Quando il codice va in panico, non c'è modo di recuperare. Potresti chiamare `panic!` per qualsiasi situazione di errore, che ci sia un modo possibile di recuperare o meno, ma in quel caso stai decidendo che una situazione è irrecuperabile per conto del codice chiamante. Quando scegli di restituire un valore `Result`, dai al codice chiamante delle opzioni. Il codice chiamante potrebbe scegliere di tentare di recuperare in un modo appropriato per la sua situazione, o potrebbe decidere che un valore `Err` in questo caso è irrecuperabile, quindi può chiamare `panic!` e trasformare il tuo errore recuperabile in uno irrecuperabile. Pertanto, restituire `Result` è una buona scelta predefinita quando si sta definendo una funzione che potrebbe fallire.

In situazioni come esempi, codice prototipo e test, è più appropriato scrivere codice che vada in panico invece di restituire un `Result`. Esploriamo il perché, quindi discutiamo situazioni in cui il compilatore non riesce a riconoscere che il fallimento è impossibile, ma tu come umano puoi. Il capitolo si concluderà con alcune linee guida generali su come decidere se andare in panico nel codice delle librerie.

### Esempi, Codice Prototipo e Test

Quando stai scrivendo un esempio per illustrare qualche concetto, includere anche un codice di gestione degli errori robusto può rendere l'esempio meno chiaro. Negli esempi, si capisce che una chiamata a un metodo come `unwrap` che potrebbe andare in panico è intesa come un segnaposto per il modo in cui vorresti che la tua applicazione gestisse gli errori, che può differire in base a cosa sta facendo il resto del tuo codice.

Allo stesso modo, i metodi `unwrap` e `expect` sono molto utili durante la prototipazione, prima che tu sia pronto a decidere come gestire gli errori. Lasciano segnaposti chiari nel tuo codice per quando sei pronto a rendere il tuo programma più robusto.

Se una chiamata a un metodo fallisce in un test, vorresti che l'intero test fallisca, anche se quel metodo non è la funzionalità sotto test. Poiché `panic!` è il modo in cui un test è segnato come fallito, chiamare `unwrap` o `expect` è esattamente quello che dovrebbe accadere.

### Casi in Cui Hai Più Informazioni Rispetto al Compilatore

Sarebbe anche appropriato chiamare `unwrap` o `expect` quando hai qualche altra logica che assicura che il `Result` avrà un valore `Ok`, ma la logica non è qualcosa che il compilatore comprende. Avrai comunque un valore `Result` che devi gestire: qualunque operazione tu stia chiamando ha ancora la possibilità di fallire in generale, anche se è logicamente impossibile nella tua particolare situazione. Se puoi assicurarti ispezionando manualmente il codice che non avrai mai una variante `Err`, è perfettamente accettabile chiamare `unwrap`, e ancora meglio documentare il motivo per cui pensi di non avere mai una variante `Err` nel testo di `expect`. Ecco un esempio:

```rust
{{#rustdoc_include ../listings/ch09-error-handling/no-listing-08-unwrap-that-cant-fail/src/main.rs:here}}
```

Stiamo creando un'istanza di `IpAddr` analizzando una stringa hardcoded. Possiamo vedere che `127.0.0.1` è un indirizzo IP valido, quindi è accettabile usare `expect` qui. Tuttavia, avere una stringa valida hardcoded non cambia il tipo di ritorno del metodo `parse`: otteniamo comunque un valore `Result`, e il compilatore ci farà ancora gestire il `Result` come se la variante `Err` fosse una possibilità perché il compilatore non è abbastanza intelligente da vedere che questa stringa è sempre un indirizzo IP valido. Se la stringa dell'indirizzo IP provenisse da un utente invece di essere hardcoded nel programma e quindi *avesse* una possibilità di fallimento, vorremmo sicuramente gestire il `Result` in un modo più robusto invece. Menzionare l'assunzione che questo indirizzo IP sia hardcoded ci spingerà a cambiare `expect` con un codice di gestione degli errori migliore se, in futuro, dovessimo ottenere l'indirizzo IP da qualche altra fonte invece.

### Linee Guida per la Gestione degli Errori

È consigliabile far entrare in panico il tuo codice quando è possibile che il tuo codice possa finire in uno stato problematico. In questo contesto, uno *stato problematico* si verifica quando qualche assunzione, garanzia, contratto o invariante è stato violato, come quando vengono passati al tuo codice valori invalidi, valori contraddittori o valori mancanti—più uno o più dei seguenti:

* Lo stato problematico è qualcosa di inaspettato, al contrario di qualcosa che probabilmente accadrà occasionalmente, come un utente che inserisce dati nel formato sbagliato.
* Il tuo codice da questo punto in poi deve fare affidamento sul non trovarsi in questo stato problematico, piuttosto che controllare il problema a ogni passo.
* Non c'è un buon modo per codificare queste informazioni nei tipi che usi. Esamineremo un esempio di ciò che intendiamo nella sezione [“Codifica degli Stati e dei Comportamenti come Tipi”][encoding]<!-- ignore --> del Capitolo 17.

Se qualcuno chiama il tuo codice e passa dei valori che non hanno senso, è meglio restituire un errore se puoi in modo che l'utente della libreria possa decidere cosa vuole fare in quel caso. Tuttavia, nei casi in cui continuare potrebbe essere insicuro o dannoso, la scelta migliore potrebbe essere chiamare `panic!` e allertare la persona che usa la tua libreria del bug nel loro codice in modo che possano correggerlo durante lo sviluppo. Allo stesso modo, `panic!` è spesso appropriato se stai chiamando codice esterno che è fuori dal tuo controllo e restituisce uno stato non valido che non hai modo di correggere.

Tuttavia, quando il fallimento è previsto, è più appropriato restituire un `Result` piuttosto che fare una chiamata a `panic!`. Esempi includono un parser a cui vengono dati dati malformati o una richiesta HTTP che restituisce uno stato che indica che hai raggiunto un limite di velocità. In questi casi, restituire un `Result` indica che il fallimento è una possibilità prevista che il codice chiamante deve decidere come gestire.

Quando il tuo codice esegue un'operazione che potrebbe mettere a rischio un utente se viene chiamata utilizzando valori non validi, il tuo codice dovrebbe verificare che i valori siano validi prima e andare in panico se i valori non sono validi. Questo è principalmente per motivi di sicurezza: tentare di operare su dati non validi può esporre il tuo codice a vulnerabilità. Questo è il motivo principale per cui la libreria standard chiamerà `panic!` se tenti un accesso alla memoria fuori dai limiti: tentare di accedere a memoria che non appartiene alla struttura dati corrente è un problema di sicurezza comune. Le funzioni spesso hanno dei *contratti*: il loro comportamento è garantito solo se gli input soddisfano requisiti particolari. Fare andare in panico quando il contratto è violato ha senso perché una violazione del contratto indica sempre un bug lato chiamante, e non è un tipo di errore che vuoi che il codice chiamante debba esplicitamente gestire. Infatti, non c'è modo ragionevole per il codice chiamante di recuperare; i *programmatori* chiamanti devono risolvere il codice. I contratti per una funzione, specialmente quando una violazione causerà un panico, dovrebbero essere spiegati nella documentazione API della funzione.

Tuttavia, avere molti controlli di errore in tutte le tue funzioni sarebbe prolisso e fastidioso. Fortunatamente, puoi utilizzare il sistema dei tipi di Rust (e quindi il controllo dei tipi fatto dal compilatore) per fare molti dei controlli per te. Se la tua funzione ha un tipo particolare come parametro, puoi procedere con la logica del tuo codice sapendo che il compilatore ha già garantito che hai un valore valido. Ad esempio, se hai un tipo piuttosto che un `Option`, il tuo programma si aspetta di avere *qualcosa* piuttosto che *niente*. Il tuo codice quindi non deve gestire due casi per le varianti `Some` e `None`: avrà solo un caso per avere sicuramente un valore. Il codice che tenta di passare nulla alla tua funzione non verrà nemmeno compilato, quindi la tua funzione non deve verificare quel caso a runtime. Un altro esempio è l'uso di un tipo di intero non firmato come `u32`, che garantisce che il parametro non sia mai negativo.

### Creare Tipi Personalizzati per la Validazione

Portiamo l'idea di utilizzare il sistema dei tipi di Rust per garantire che abbiamo un valore valido un passo avanti e guardiamo a creare un tipo personalizzato per la validazione. Ricordiamo il gioco di indovinare nel Capitolo 2 in cui il nostro codice chiedeva all'utente di indovinare un numero tra 1 e 100. Non abbiamo mai validato che l'indovinello dell'utente fosse tra quei numeri prima di confrontarlo con il nostro numero segreto; abbiamo solo validato che l'indovinello fosse positivo. In questo caso, le conseguenze non erano molto gravi: la nostra uscita di "Troppo alto" o "Troppo basso" sarebbe stata comunque corretta. Ma sarebbe un miglioramento utile guidare l'utente verso indovinelli validi e avere un comportamento diverso quando l'utente indovina un numero fuori dall'intervallo rispetto a quando l'utente digita, ad esempio, lettere invece.

Un modo per fare questo sarebbe analizzare l'indovinello come un `i32` invece di solo un `u32` per consentire numeri potenzialmente negativi, e poi aggiungere un controllo per il numero all'interno dell'intervallo, come segue:

<span class="filename">Nome file: src/main.rs</span>

```rust,ignore
{{#rustdoc_include ../listings/ch09-error-handling/no-listing-09-guess-out-of-range/src/main.rs:here}}
```

L'espressione `if` controlla se il nostro valore è fuori intervallo, informa l'utente del problema e chiama `continue` per iniziare la prossima iterazione del ciclo e chiedere un altro indovinello. Dopo l'espressione `if`, possiamo procedere con i confronti tra `guess` e il numero segreto sapendo che `guess` è tra 1 e 100.

Tuttavia, questa non è una soluzione ideale: se fosse assolutamente critico che il programma funzionasse solo su valori tra 1 e 100, e avesse molte funzioni con questo requisito, avere un controllo come questo in ogni funzione sarebbe tedioso (e potrebbe influire sulle prestazioni).

Invece, possiamo creare un nuovo tipo e mettere le validazioni in una funzione per creare un'istanza del tipo piuttosto che ripetere le validazioni ovunque. In questo modo, è sicuro per le funzioni utilizzare il nuovo tipo nelle loro firme e usare con fiducia i valori che ricevono. Il Listing 9-13 mostra un modo per definire un tipo `Guess` che creerà un'istanza di `Guess` solo se la funzione `new` riceve un valore tra 1 e 100.

<span class="filename">Nome file: src/lib.rs</span>

```rust
{{#rustdoc_include ../listings/ch09-error-handling/listing-09-13/src/lib.rs}}
```

<span class="caption">Listing 9-13: Un tipo `Guess` che continuerà solo con valori tra 1 e 100</span>

Prima definiamo una struct chiamata `Guess` che ha un campo chiamato `value` che contiene un `i32`. Questo è dove il numero sarà memorizzato.

Poi implementiamo una funzione associata chiamata `new` su `Guess` che crea istanze di valori `Guess`. La funzione `new` è definita per avere un parametro chiamato `value` di tipo `i32` e per restituire un `Guess`. Il codice nel Blocco della funzione `new` testa `value` per assicurarsi che sia tra 1 e 100. Se `value` non supera questo test, facciamo una chiamata a `panic!`, che avviserà il programmatore che sta scrivendo il codice chiamante che ha un bug che deve correggere, perché creare un `Guess` con un `value` al di fuori di questo intervallo violerebbe il contratto su cui si basa `Guess::new`. Le condizioni in cui `Guess::new` potrebbe far panic dovrebbero essere discusse nella sua documentazione API rivolta al pubblico; copriremo le convenzioni di documentazione che indicano la possibilità di un `panic!` nella documentazione API che crei nel Capitolo 14. Se `value` supera il test, creiamo un nuovo `Guess` con il suo campo `value` impostato sul parametro `value` e restituiamo il `Guess`.

Successivamente, implementiamo un metodo chiamato `value` che prende in prestito `self`, non ha altri parametri e restituisce un `i32`. Questo tipo di metodo viene talvolta chiamato un *getter* perché il suo scopo è ottenere alcuni dati dai suoi campi e restituirli. Questo metodo pubblico è necessario perché il campo `value` della struct `Guess` è privato. È importante che il campo `value` sia privato in modo che il codice che utilizza la struct `Guess` non sia autorizzato a impostare direttamente il `value`: il codice fuori dal modulo *deve* usare la funzione `Guess::new` per creare un'istanza di `Guess`, assicurando così che non ci sia modo per un `Guess` di avere un `value` che non sia stato controllato dalle condizioni nella funzione `Guess::new`.

Una funzione che ha un parametro o restituisce solo numeri tra 1 e 100 potrebbe quindi dichiarare nella sua firma che prende o restituisce un `Guess` piuttosto che un `i32` e non avrebbe bisogno di fare alcun controllo aggiuntivo nel suo Blocco.

## Sommario

Le funzionalità di gestione degli errori di Rust sono progettate per aiutarti a scrivere codice più robusto. La macro `panic!` segnala che il tuo programma è in uno stato che non può gestire e ti permette di dire al processo di fermarsi invece di cercare di procedere con valori invalidi o errati. L'enum `Result` utilizza il sistema dei tipi di Rust per indicare che le operazioni potrebbero fallire in un modo da cui il tuo codice potrebbe recuperare. Puoi usare `Result` per dire al codice che chiama il tuo codice che deve gestire il potenziale successo o fallimento anche. Usare `panic!` e `Result` nelle situazioni appropriate renderà il tuo codice più affidabile di fronte ai problemi inevitabili.

Ora che hai visto modi utili in cui la libreria standard utilizza i generici con gli enum `Option` e `Result`, parleremo di come funzionano i generici e come puoi usarli nel tuo codice.

[encoding]: ch17-03-oo-design-patterns.html#encoding-states-and-behavior-as-types
