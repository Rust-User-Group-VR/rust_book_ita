# Gestire Progetti in Crescita con Pacchetti, Crate, e Moduli

Man mano che scrivi programmi di grandi dimensioni, l'organizzazione del tuo codice diventerà sempre più
importante. Raggruppando le funzionalità correlate e separando il codice con caratteristiche distinte, chiarirai dove trovare il codice che implementa una data
caratteristica e dove andare per modificare il funzionamento di una caratteristica.

I programmi che abbiamo scritto finora sono stati in un modulo in un unico file. Man mano che un
progetto cresce, dovresti organizzare il codice dividendo in più moduli
e poi in più file. Un pacchetto può contenere più crate binari e
opzionalmente una crate di libreria. Man mano che un pacchetto cresce, puoi estrarre parti in
crates separate che diventano dipendenze esterne. Questo capitolo copre tutte
queste tecniche. Per progetti molto grandi composti da un insieme di pacchetti interrelati
che evolvono insieme, Cargo fornisce gli *spazi di lavoro*, che tratteremo
nella sezione [“Spazi di Lavoro Cargo”][workspaces]<!-- ignore --> nel Capitolo 14.

Discuteremo anche dell'incapsulazione dei dettagli di implementazione, che ti permette di riutilizzare
il codice ad un livello più alto: una volta che hai implementato un'operazione, altri codici possono
chiamare il tuo codice tramite la sua interfaccia pubblica senza dover sapere come funziona la 
implementazione. Il modo in cui scrivi il codice definisce quali parti sono pubbliche per 
l'uso da parte di altri codici e quali parti sono dettagli di implementazione privati che ti
riservi il diritto di modificare. Questo è un altro modo per limitare la quantità di dettagli
che devi tenere a mente.

Un concetto correlato è lo scope: il contesto annidato in cui è scritto il codice ha un
insieme di nomi che sono definiti come “nello scope”. Quando si legge, scrive e
compila il codice, i programmatori e i compilatori devono sapere se un determinato
nome in un determinato punto si riferisce a una variabile, funzione, struct, enum, modulo,
costante, o altro elemento e cosa significa quell'elemento. Puoi creare scopes e
cambiare quali nomi sono dentro o fuori dallo scope. Non puoi avere due elementi con lo
stesso nome nello stesso scope; ci sono strumenti disponibili per risolvere i conflitti di nomi.

Rust ha un numero di funzionalità che ti permettono di gestire l'organizzazione del tuo codice,
inclusi quali dettagli vengono esposti, quali dettagli sono privati,
e quali nomi sono in ogni scope nei tuoi programmi. Queste funzionalità, a volte
collettivamente indicate come il *sistema dei moduli*, includono:

* **Pacchetti:** Una funzionalità di Cargo che ti permette di costruire, testare, e condividere crates
* **Crates:** Un albero di moduli che produce una libreria o un eseguibile
* **Moduli** e **use:** Ti permettono di controllare l'organizzazione, lo scope, e
  la privacy dei percorsi
* **Percorsi:** Un modo di denominare un elemento, come una struct, funzione, o modulo

In questo capitolo, copriremo tutte queste funzionalità, discuteremo di come interagiscono, e
spiegheremo come usarle per gestire lo scope. Alla fine, dovresti avere una solida
comprensione del sistema dei moduli e essere in grado di lavorare con gli scopes come un pro!

[workspaces]: ch14-03-cargo-workspaces.html
