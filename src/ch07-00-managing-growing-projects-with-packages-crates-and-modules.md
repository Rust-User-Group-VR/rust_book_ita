# Gestire Progetti Crescenti con Packages, Crates e Moduli

Man mano che scrivi programmi più grandi, organizzare il codice diventerà sempre
più importante. Raggruppando la funzionalità correlata e separando il codice con caratteristiche distinte, chiarirai dove trovare il codice che implementa una particolare funzionalità e dove andare per cambiare il funzionamento di una funzionalità.

I programmi che abbiamo scritto finora sono stati in un modulo in un file. Man mano che un progetto cresce, dovresti organizzare il codice suddividendolo in più moduli e poi in più file. Un package può contenere più binary crates e opzionalmente un library crate. Man mano che un package cresce, puoi estrarre parti in crate separati che diventano dipendenze esterne. Questo capitolo copre tutte queste tecniche. Per i progetti molto grandi comprendenti un insieme di packages interrelati che evolvono insieme, Cargo fornisce *workspaces*, che tratteremo nella sezione [“Cargo Workspaces”][workspaces]<!-- ignore --> del Capitolo 14.

Parleremo anche di come incapsulare i dettagli dell'implementazione, il che ti consente di riutilizzare il codice a un livello superiore: una volta che hai implementato un'operazione, altro codice può chiamare il tuo codice tramite la sua interfaccia pubblica senza dover sapere come funziona l'implementazione. Il modo in cui scrivi il codice definisce quali parti sono pubbliche per l'uso da parte di altro codice e quali parti sono dettagli privati di implementazione che ti riservi il diritto di cambiare. Questo è un altro modo per limitare la quantità di dettagli che devi mantenere nella tua mente.

Un concetto correlato è lo scope: il contesto annidato in cui è scritto il codice ha un insieme di nomi definiti come "in scope". Quando leggon, scrivono e compilano il codice, programmatori e compilatori devono sapere se un particolare nome in un determinato punto si riferisce a una variabile, funzione, struct, enum, modulo, costante o altro elemento e cosa significa quell'elemento. Puoi creare scopes e cambiare quali nomi sono in o fuori dallo scope. Non puoi avere due elementi con lo stesso nome nello stesso scope; sono disponibili strumenti per risolvere conflitti di nomi.

Rust ha una serie di funzionalità che ti permettono di gestire l'organizzazione del tuo codice, inclusa l'esposizione di determinati dettagli, quali dettagli sono privati e quali nomi sono in ciascuno scope nei tuoi programmi. Queste funzionalità, talvolta collettivamente denominate *module system*, includono:

* **Packages:** Una funzionalità di Cargo che ti consente di costruire, testare e condividere crates
* **Crates:** Un albero di moduli che produce una libreria o un eseguibile
* **Modules** e **use:** Ti consentono di controllare l'organizzazione, lo scope e
  la privacy dei paths
* **Paths:** Un modo di nominare un elemento, come una struct, funzione, o modulo

In questo capitolo, copriremo tutte queste funzionalità, discuteremo di come interagiscono e spiegheremo come usarle per gestire lo scope. Alla fine, dovresti avere una solida comprensione del module system e essere in grado di lavorare con gli scopes come un professionista!

[workspaces]: ch14-03-cargo-workspaces.html
