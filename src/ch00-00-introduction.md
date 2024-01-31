# Introduzione

> Nota: Questa edizione del libro è la stessa di [The Rust Programming
> Language][nsprust] disponibile in formato stampato e ebook da [No Starch
> Press][nsp].

[nsprust]: https://nostarch.com/rust-programming-language-2nd-edition
[nsp]: https://nostarch.com/

Benvenuto a *The Rust Programming Language*, un libro introduttivo su Rust.
Il linguaggio di programmazione Rust ti aiuta a scrivere software più veloce e affidabile.
Nella progettazione dei linguaggi di programmazione, l'ergonomia ad alto livello e il controllo a basso livello sono spesso in contrasto; Rust sfida questo conflitto. Bilanciando potenti capacità tecniche e un'ottima esperienza di sviluppo, Rust ti dà la possibilità di controllare dettagli a basso livello (come l'uso della memoria) senza tutto il fastidio tradizionalmente associato a tale controllo.

## Per chi è Rust

Rust è ideale per molte persone per vari motivi. Diamo un'occhiata ad alcuni dei gruppi più importanti.

### Team di sviluppatori

Rust si sta dimostrando uno strumento produttivo per la collaborazione tra grandi team di sviluppatori con diversi livelli di conoscenza della programmazione di sistema. Il codice a basso livello è incline a vari bug sottili, che nella maggior parte degli altri linguaggi possono essere individuati solo attraverso test estensivi e un'attenta revisione del codice da parte di sviluppatori esperti. In Rust, il compilatore svolge un ruolo di gatekeeper rifiutandosi di compilare codice con questi bug elusivi, inclusi i bug di concorrenza. Lavorando al fianco del compilatore, il team può dedicare il proprio tempo a concentrarsi sulla logica del programma piuttosto che a dare la caccia ai bug.

Rust porta anche strumenti di sviluppo contemporanei nel mondo della programmazione di sistema:

* Cargo, il gestore di dipendenze incluso e strumento di compilazione, rende l'aggiunta,
  la compilazione e la gestione delle dipendenze senza problemi e coerenti in tutto l'ecosistema Rust.
* Lo strumento di formattazione Rustfmt garantisce uno stile di codificazione coerente tra
  gli sviluppatori.
* Il Rust Language Server alimenta l'integrazione dell'ambiente di sviluppo integrato (IDE)
  per il completamento del codice e i messaggi di errore in linea.

Utilizzando questi e altri strumenti nell'ecosistema Rust, gli sviluppatori possono essere
produttivi mentre scrivono codice a livello di sistema.

### Studenti

Rust è per gli studenti e coloro che sono interessati a conoscere i concetti di sistema.
Utilizzando Rust, molte persone hanno appreso argomenti come lo sviluppo di sistemi operativi. La comunità è molto accogliente e felice di rispondere alle domande degli studenti. Attraverso iniziative come questo libro, i team di Rust vogliono rendere i concetti di sistema più accessibili a più persone, in particolare a quelle nuove alla programmazione.

### Aziende

Centinaia di aziende, grandi e piccole, usano Rust in produzione per una varietà di compiti, tra cui strumenti da riga di comando, servizi web, strumentazione DevOps, dispositivi incorporati, analisi e transcodifica audio e video, criptovalute, bioinformatica, motori di ricerca, applicazioni Internet of Things, machine learning, e persino parti importanti del browser web Firefox.

### Sviluppatori Open Source

Rust è per persone che vogliono costruire il linguaggio di programmazione Rust, la comunità, gli strumenti per sviluppatori e le librerie. Ci piacerebbe che tu contribuissi al linguaggio Rust.

### Persone che valorizzano velocità e stabilità

Rust è per persone che desiderano velocità e stabilità in un linguaggio. Con velocità, intendiamo sia la rapidità con cui può eseguire il codice Rust sia la velocità con cui Rust ti permette di scrivere programmi. I controlli del compilatore Rust garantiscono la stabilità attraverso l'aggiunta di funzionalità e il refactoring. Questo è in contrasto con il codice legacy fragile nei linguaggi senza questi controlli, che gli sviluppatori spesso hanno paura di modificare. Cercando di ottenere astrazioni a costo zero, funzionalità di livello superiore che si compilano in codice di livello inferiore veloce come il codice scritto manualmente, Rust si sforza di rendere il codice sicuro anche codice veloce.

Il linguaggio Rust spera di supportare molti altri utenti; quelli menzionati qui sono semplicemente alcuni dei principali stakeholder. In generale, la più grande ambizione di Rust è eliminare i compromessi che i programmatori hanno accettato per decenni fornendo sicurezza *e* produttività, velocità *e* ergonomia. Prova Rust e vedi se le sue scelte funzionano per te.

## A chi è destinato questo libro

Questo libro presume che tu abbia già scritto codice in un altro linguaggio di programmazione, ma non fa alcuna supposizione su quale. Abbiamo cercato di rendere il materiale ampiamente accessibile a persone con una vasta gamma di background di programmazione. Non passiamo molto tempo a parlare di cosa sia la programmazione o di come pensarla. Se sei completamente nuovo alla programmazione, sarebbe meglio che leggessi un libro che fornisce specificamente un'introduzione alla programmazione.

## Come utilizzare questo libro

In generale, questo libro presume che tu lo stia leggendo in sequenza dall'inizio alla fine. I capitoli successivi si basano sui concetti dei capitoli precedenti, e i capitoli precedenti potrebbero non approfondire i dettagli su un particolare argomento, ma rivedranno l'argomento in un capitolo successivo.

Troverai due tipi di capitoli in questo libro: capitoli concettuali e capitoli di progetto. Nei capitoli concettuali, imparerai un aspetto di Rust. Nei capitoli di progetto, costruiremo insieme piccoli programmi, applicando ciò che hai appreso finora. I capitoli 2, 12 e 20 sono capitoli di progetto; il resto sono capitoli concettuali.

Il capitolo 1 spiega come installare Rust, come scrivere un programma "Hello, world!" e come utilizzare Cargo, il gestore dei pacchetti di Rust e strumento di compilazione. Il capitolo 2 è un'introduzione pratica alla scrittura di un programma in Rust, che ti farà costruire un gioco di indovinanza dei numeri. Qui copriamo concetti ad alto livello, e i capitoli successivi forniranno dettagli aggiuntivi. Se vuoi mettere le mani in pasta subito, il capitolo 2 è il posto giusto. Il capitolo 3 tratta le funzionalità di Rust simili a quelle di altri linguaggi di programmazione, e nel capitolo 4 imparerai il sistema di "ownership" di Rust. Se sei un apprendista particolarmente meticoloso che preferisce imparare ogni dettaglio prima di passare al successivo, potresti voler saltare il capitolo 2 e andare direttamente al capitolo 3, tornando al capitolo 2 quando vorresti lavorare su un progetto applicando i dettagli che hai appreso.

Il capitolo 5 discute di strutture e metodi, e il capitolo 6 riguarda enum, espressioni `match` e il costrutto di controllo del flusso `if let`. Userai strutture ed enum per creare tipi personalizzati in Rust.

Nel capitolo 7, imparerai sul sistema di moduli di Rust e sulle regole sulla privacy per organizzare il tuo codice e la sua interfaccia di programmazione delle applicazioni (API) pubblica. Il capitolo 8 discute alcune strutture di dati di raccolta comuni che la libreria standard fornisce, come vettori, stringhe e mappe hash. Il capitolo 9 esplora la filosofia e le tecniche di gestione degli errori di Rust.

Il capitolo 10 approfondisce i generici, i tratti e le durate, che ti danno il potere di definire il codice che si applica a più tipi. Il capitolo 11 tratta tutto sui test, che anche con le garanzie di sicurezza di Rust sono necessari per garantire che la logica del tuo programma sia corretta. Nel capitolo 12, costruiremo la nostra implementazione di un sottoinsieme di funzionalità dal tool di linea di comando `grep` che cerca testo all'interno dei file. Per questo, utilizzeremo molti dei concetti che abbiamo discusso nei capitoli precedenti.

Il capitolo 13 esplora funzioni di chiusura e iteratori: funzionalità di Rust che provengono dai linguaggi di programmazione funzionale. Nel capitolo 14, esamineremo Cargo più in profondità e parleremo delle migliori pratiche per condividere le tue librerie con gli altri. Il capitolo 15 discute i puntatori intelligenti che la libreria standard fornisce e i tratti che ne abilitano la funzionalità.

Nel capitolo 16, ripercorreremo diversi modelli di programmazione concorrente e parleremo di come Rust ti aiuta a programmare in più thread senza paura. Il capitolo 17 esamina come gli idiomi di Rust si confrontano con i principi della programmazione orientata agli oggetti che potresti conoscere.

Il capitolo 18 è un riferimento su pattern e pattern matching, che sono modi potenti di esprimere idee in tutto i programmi Rust. Il capitolo 19 contiene un miscuglio di argomenti avanzati di interesse, tra cui Rust insicuro, macro e altro ancora su durate, tratti, tipi, funzioni e chiusure.

Nel capitolo 20, completeremo un progetto in cui implementeremo un server web multithread di basso livello!

Infine, alcuni allegati contengono informazioni utili sul linguaggio in formato più simile a un riferimento. L'allegato A copre le parole chiave di Rust, l'allegato B copre gli operatori e i simboli di Rust, l'allegato C copre tratti derivabili forniti dalla libreria standard, l'allegato D copre alcuni strumenti di sviluppo utili, e l'allegato E spiega le edizioni di Rust. Nell'allegato F, puoi trovare traduzioni del libro, e nell'allegato G parleremo di come viene fatto Rust e di cosa sia Rust notturno.

Non c'è un modo sbagliato di leggere questo libro: se vuoi saltare avanti, fallo! Potresti dover tornare indietro ai capitoli precedenti se riscontri qualche confusione. Ma fai quello che funziona per te.

<span id="ferris"></span>

Una parte importante del processo di apprendimento di Rust è imparare a leggere i messaggi di errore visualizzati dal compilatore: questi ti guideranno verso il codice funzionante. Pertanto, forniremo molti esempi che non si compilano insieme al messaggio di errore che il compilatore ti mostrerà in ogni situazione. Sappi che se inserisci ed esegui un esempio casuale, potrebbe non compilarsi! Assicurati di leggere il testo circostante per vedere se l'esempio che stai cercando di eseguire dovrebbe generare un errore. Ferris ti aiuterà anche a distinguere il codice che non è inteso per funzionare:

| Ferris                                                                                                           | Significato                                          |
|------------------------------------------------------------------------------------------------------------------|--------------------------------------------------|
| <img src="img/ferris/does_not_compile.svg" class="ferris-explain" alt="Ferris con un punto interrogativo"/>            | Questo codice non compila!                      |
| <img src="img/ferris/panics.svg" class="ferris-explain" alt="Ferris che alza le mani"/>                   | Questo codice entra in panico!                                |
| <img src="img/ferris/not_desired_behavior.svg" class="ferris-explain" alt="Ferris con una zampa in alto, ad uno sghignazzo"/> | Questo codice non produce il comportamento desiderato. |

Nella maggior parte delle situazioni, ti guideremo verso la versione corretta di qualsiasi codice che
non compila.

## Codice Sorgente

I file sorgenti da cui questo libro è generato possono essere trovati su
[GitHub][book].

[book]: https://github.com/rust-lang/book/tree/main/src

