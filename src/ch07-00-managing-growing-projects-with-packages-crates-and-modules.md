# Gestire Progetti in Crescita con Package, Crate e Moduli

Man mano che scrivi programmi di grandi dimensioni, organizzare il tuo codice diventerà sempre più importante. Raggruppando funzionalità correlate e separando il codice con caratteristiche distinte, chiarirai dove trovare il codice che implementa una particolare funzionalità e dove intervenire per modificare il funzionamento di una caratteristica.

I programmi che abbiamo scritto finora sono stati in un unico modulo in un unico file. Man mano che un progetto cresce, dovresti organizzare il codice suddividendolo in più moduli e quindi in più file. Un package può contenere più binary crate ed eventualmente un library crate. Man mano che un package cresce, puoi estrarre parti in crate separati che diventano dipendenze esterne. Questo capitolo copre tutte queste tecniche. Per progetti molto grandi che comprendono un insieme di package interconnessi che evolvono insieme, Cargo fornisce i *workspaces*, di cui parleremo nella sezione [“Cargo Workspaces”][workspaces]<!-- ignore --> nel Capitolo 14.

Discuteremo anche l'incapsulamento dei dettagli di implementazione, che ti consente di riutilizzare il codice a un livello più alto: una volta implementata un'operazione, altro codice può chiamare il tuo codice tramite la sua interfaccia pubblica senza dover sapere come funziona l'implementazione. Il modo in cui scrivi il codice definisce quali parti sono pubbliche per l'uso da parte di altro codice e quali parti sono dettagli di implementazione privati che ti riservi il diritto di modificare. Questo è un altro modo per limitare la quantità di dettagli che devi tenere a mente.

Un concetto correlato è lo scope: il contesto annidato in cui è scritto il codice ha un insieme di nomi definiti come “in scope.” Quando leggono, scrivono e compilano il codice, programmatori e compilatori devono sapere se un particolare nome in un punto specifico si riferisce a una variabile, funzione, struct, enum, modulo, costante o altro elemento e cosa significa quell'elemento. Puoi creare scope e modificare quali nomi sono dentro o fuori dallo scope. Non puoi avere due elementi con lo stesso nome nello stesso scope; sono disponibili strumenti per risolvere conflitti di nomi.

Rust ha una serie di funzionalità che ti permettono di gestire l'organizzazione del tuo codice, incluso quali dettagli sono esposti, quali sono privati e quali nomi sono in ciascun scope nei tuoi programmi. Queste funzionalità, a volte collettivamente chiamate *sistema di moduli*, includono:

* **Package:** Una funzionalità di Cargo che ti consente di costruire, testare e condividere crate
* **Crates:** Un albero di moduli che produce una libreria o un eseguibile
* **Moduli** e **use:** Ti permettono di controllare l'organizzazione, lo scope e
  la privacy dei path
* **Path:** Un modo di nominare un elemento, come una struct, funzione o modulo

In questo capitolo, copriremo tutte queste funzionalità, discuteremo come interagiscono e spiegheremo come usarle per gestire lo scope. Alla fine, dovresti avere una solida comprensione del sistema di moduli e essere in grado di lavorare con lo scope come un professionista!

[workspaces]: ch14-03-cargo-workspaces.html
