# Introduzione

> Nota: Questa edizione del libro è la stessa de [Il Libro del Linguaggio di
> Programmazione Rust][nsprust] disponibile in formato cartaceo ed ebook da [No Starch
> Press][nsp].

[nsprust]: https://nostarch.com/rust-programming-language-2nd-edition
[nsp]: https://nostarch.com/

Benvenuti in *Il Linguaggio di Programmazione Rust*, un libro introduttivo su Rust. 
Il linguaggio di programmazione Rust ti aiuta a scrivere software più veloce e affidabile. 
L'ergonomia ad alto livello e il controllo a basso livello sono spesso in conflitto nel design dei linguaggi di programmazione; 
Rust sfida questo conflitto. Attraverso il bilanciamento della capacità tecnica potente e 
un'ottima esperienza per lo sviluppatore, Rust ti offre l'opzione di controllare i dettagli a basso livello (come l'uso della memoria) 
senza tutto il disturbo tradizionalmente associato a tale controllo.

## Per chi è Rust

Rust è ideale per molte persone per una varietà di motivi. Diamo un'occhiata ad alcuni dei gruppi più importanti.

### Team di Sviluppatori

Rust si sta dimostrando uno strumento produttivo per la collaborazione tra grandi team di sviluppatori con livelli di conoscenza dei sistemi di programmazione variabili. 
Il codice a basso livello è incline a vari bug sottili, che nella maggior parte degli altri linguaggi possono essere catturati solo attraverso test estensivi e un'accurata revisione del codice da parte di sviluppatori esperti. 
In Rust, il compilatore svolge il ruolo di guardiano rifiutandosi di compilare codice con questi bug elusivi, inclusi i bug di concorrenza. 
Lavorando insieme al compilatore, il team può concentrare il loro tempo sulla logica del programma piuttosto che a rincorrere bug.

Rust porta anche strumenti di sviluppo contemporanei nel mondo della programmazione di sistemi:

* Cargo, il gestore delle dipendenze integrato e strumento di build, rende l'aggiunta, la compilazione e la gestione delle dipendenze indolore e coerente nell'ecosistema Rust.
* Lo strumento di formattazione Rustfmt assicura uno stile di codifica coerente tra gli sviluppatori.
* Il rust-analyzer alimenta l'integrazione dell'Integrated Development Environment (IDE) per il completamento del codice e i messaggi di errore in linea.

Usando questi e altri strumenti dell'ecosistema Rust, gli sviluppatori possono essere produttivi mentre scrivono codice a livello di sistema.

### Studenti

Rust è per studenti e per coloro che sono interessati ad apprendere i concetti dei sistemi. Usando Rust, molte persone hanno imparato argomenti come lo sviluppo di sistemi operativi. La comunità è molto accogliente e felice di rispondere alle domande degli studenti. Attraverso sforzi come questo libro, i team di Rust vogliono rendere i concetti dei sistemi più accessibili a più persone, specialmente a coloro che sono nuovi alla programmazione.

### Aziende

Centinaia di aziende, grandi e piccole, usano Rust in produzione per una varietà di compiti, tra cui strumenti a riga di comando, servizi web, strumenti DevOps, dispositivi embedded, analisi e transcodifica audio e video, criptovalute, bioinformatica, motori di ricerca, applicazioni Internet of Things, apprendimento automatico, e anche parti importanti del browser web Firefox.

### Sviluppatori Open Source

Rust è per le persone che vogliono costruire il linguaggio di programmazione Rust, la comunità, gli strumenti per sviluppatori e le librerie. Ci piacerebbe che tu contribuissi al linguaggio Rust.

### Persone che Valutano Velocità e Stabilità

Rust è per le persone che desiderano velocità e stabilità in un linguaggio. Per velocità, intendiamo sia quanto rapidamente il codice Rust può essere eseguito sia la velocità con cui Rust ti permette di scrivere programmi. I controlli del compilatore di Rust garantiscono stabilità attraverso aggiunte di funzionalità e refactoring. Questo è in contrasto con il codice legacy fragile nei linguaggi senza questi controlli, che gli sviluppatori spesso hanno paura di modificare. Puntando su astrazioni a costo zero, funzionalità di alto livello che si compilano in codice di basso livello veloce come il codice scritto manualmente, Rust si sforza di far sì che il codice sicuro sia anche codice veloce.

Il linguaggio Rust spera di supportare anche molti altri utenti; quelli menzionati qui sono solo alcuni dei principali stakeholder. In generale, la più grande ambizione di Rust è eliminare i compromessi che i programmatori hanno accettato per decenni, fornendo sicurezza *e* produttività, velocità *e* ergonomia. Prova Rust e vedi se le sue scelte funzionano per te.

## Per chi è questo libro

Questo libro presume che tu abbia scritto codice in un altro linguaggio di programmazione ma non fa alcuna supposizione su quale. Abbiamo cercato di rendere il materiale ampiamente accessibile a coloro che provengono da una vasta gamma di background di programmazione. Non dedichiamo molto tempo a parlare di cosa sia la programmazione o di come pensarla. Se sei completamente nuovo alla programmazione, sarebbe meglio che leggessi un libro che fornisce specificamente un'introduzione alla programmazione.

## Come utilizzare questo libro

In generale, questo libro presume che tu lo stia leggendo in sequenza dalla prima all'ultima pagina. I capitoli successivi si basano sui concetti dei capitoli precedenti, e i capitoli precedenti potrebbero non approfondire i dettagli su un argomento particolare ma lo riprenderanno in un capitolo successivo.

Troverai due tipi di capitoli in questo libro: capitoli concettuali e capitoli di progetto. Nei capitoli concettuali, imparerai un aspetto di Rust. Nei capitoli di progetto, costruiremo piccoli programmi insieme, applicando ciò che hai imparato finora. I capitoli 2, 12 e 20 sono capitoli di progetto; il resto sono capitoli concettuali.

Il Capitolo 1 spiega come installare Rust, come scrivere un programma “Hello, world!” e come usare Cargo, il gestore di pacchetti e strumento di build di Rust. Il Capitolo 2 è un'introduzione pratica alla scrittura di un programma in Rust, facendoti costruire un gioco di indovinelli. Qui copriamo i concetti a un alto livello e i capitoli successivi forniranno dettagli aggiuntivi. Se vuoi sporcarti le mani subito, il Capitolo 2 è il posto giusto per farlo. Il Capitolo 3 copre le funzionalità di Rust simili a quelle di altri linguaggi di programmazione, e nel Capitolo 4 imparerai il sistema di ownership di Rust. Se sei un apprendista particolarmente meticoloso che preferisce imparare ogni dettaglio prima di passare al successivo, potresti voler saltare il Capitolo 2 e andare direttamente al Capitolo 3, tornando al Capitolo 2 quando vuoi lavorare a un progetto applicando i dettagli che hai imparato.

Il Capitolo 5 discute delle structs e dei metodi, e il Capitolo 6 copre le enums, le espressioni `match` e il costrutto di controllo del flusso `if let`. Userai structs e enums per creare tipi personalizzati in Rust.

Nel Capitolo 7, imparerai il sistema di module di Rust e le regole di privacy per organizzare il tuo codice e la sua interfaccia pubblica di programmazione delle applicazioni (API). Il Capitolo 8 discute alcune strutture dati di raccolta comuni che la libreria standard fornisce, come vettori, strings e hash maps. Il Capitolo 9 esplora la filosofia e le tecniche di gestione degli errori di Rust.

Il Capitolo 10 approfondisce i generics, i traits e i lifetimes, che ti danno il potere di definire codice che si applica a più tipi. Il Capitolo 11 parla di testing, che anche con le garanzie di sicurezza di Rust, è necessario per garantire che la logica del tuo programma sia corretta. Nel Capitolo 12, costruiremo la nostra implementazione di un sottoinsieme delle funzionalità dello strumento a riga di comando `grep` che cerca testo all'interno dei file. Per questo, useremo molti dei concetti discussi nei capitoli precedenti.

Il Capitolo 13 esplora le closures e gli iterators: funzionalità di Rust che provengono dai linguaggi di programmazione funzionali. Nel Capitolo 14, esamineremo Cargo in maggior dettaglio e parleremo delle migliori pratiche per condividere le tue librerie con altri. Il Capitolo 15 discute i smart pointers che la libreria standard fornisce e i traits che abilitano la loro funzionalità.

Nel Capitolo 16, esamineremo diversi modelli di programmazione concorrente e parleremo di come Rust ti aiuti a programmare senza paura con più threads. Il Capitolo 17 guarda a come gli idiomi di Rust si confrontano ai principi di programmazione orientata agli oggetti con cui potresti avere familiarità.

Il Capitolo 18 è un riferimento su pattern e pattern matching, che sono modi potenti di esprimere idee attraverso i programmi Rust. Il Capitolo 19 contiene una varietà di argomenti avanzati di interesse, inclusi unsafe Rust, macro, e altro sui lifetimes, traits, tipi, funzioni e closures.

Nel Capitolo 20, completeremo un progetto in cui implementeremo un server web multithread a basso livello!

Infine, alcuni appendici contengono informazioni utili sul linguaggio in un formato più simile a un riferimento. L'Appendice A copre le parole chiave di Rust, l'Appendice B copre gli operatori e i simboli di Rust, l'Appendice C copre i traits derivabili forniti dalla libreria standard, l'Appendice D copre alcuni strumenti di sviluppo utili, e l'Appendice E spiega le edizioni di Rust. Nell'Appendice F, puoi trovare traduzioni del libro, e nell'Appendice G copriremo come viene realizzato Rust e cos'è il Rust nightly.

Non c'è un modo sbagliato di leggere questo libro: se vuoi saltare avanti, fallo! Potresti dover tornare indietro a capitoli precedenti se incontri delle confusioni. Ma fai ciò che funziona per te.

<span id="ferris"></span>

Una parte importante del processo di apprendimento di Rust è imparare a leggere i messaggi di errore che il compilatore mostra: questi ti guideranno verso il codice funzionante. Come tale, forniremo molti esempi che non si compilano insieme al messaggio di errore che il compilatore ti mostrerà in ogni situazione. Sappi che se inserisci ed esegui un esempio casuale, potrebbe non compilarsi! Assicurati di leggere il testo circostante per vedere se l'esempio che stai cercando di eseguire è destinato a dar luogo a un errore. Ferris ti aiuterà anche a distinguere il codice che non è destinato a funzionare:

| Ferris                                                                                                           | Significato                                      |
|------------------------------------------------------------------------------------------------------------------|--------------------------------------------------|
| <img src="img/ferris/does_not_compile.svg" class="ferris-explain" alt="Ferris con un punto di domanda"/>            | Questo codice non si compila!                      |
| <img src="img/ferris/panics.svg" class="ferris-explain" alt="Ferris che alza le mani"/>                     | Questo codice genera un panic!                                |
| <img src="img/ferris/not_desired_behavior.svg" class="ferris-explain" alt="Ferris con un artiglio sollevato, che fa spallucce"/> | Questo codice non produce il comportamento desiderato. |

Nella maggior parte delle situazioni, ti guideremo verso la versione corretta di qualsiasi codice che non si compila.

## Codice Sorgente

I file sorgente da cui è generato questo libro possono essere trovati su
[GitHub][book].

[book]: https://github.com/rust-lang/book/tree/main/src
