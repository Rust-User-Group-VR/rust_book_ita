# Introduzione

> Nota: Questa edizione del libro è la stessa di [The Rust Programming
> Language][nsprust] disponibile in formato cartaceo e ebook da [No Starch
> Press][nsp].

[nsprust]: https://nostarch.com/rust-programming-language-2nd-edition
[nsp]: https://nostarch.com/

Benvenuto a *The Rust Programming Language*, un libro introduttivo su Rust.
Il linguaggio di programmazione Rust ti aiuta a scrivere software più veloce e affidabile.
Gli strumenti di alto livello e il controllo di basso livello sono spesso in contrasto nella
progettazione del linguaggio di programmazione; Rust sfida quel conflitto. Equilibrando una potente
capacità tecnica e un'eccellente esperienza di sviluppo, Rust ti dà l'opzione
di controllare dettagli di basso livello (come l'uso della memoria) senza tutto il fastidio
tradizionalmente associato a tale controllo.

## Per chi è Rust

Rust è ideale per molte persone per vari motivi. Diamo un'occhiata ad alcuni dei
gruppi più importanti.

### Team di sviluppatori

Sta risultando che Rust è uno strumento produttivo per la collaborazione tra grandi team di.
sviluppatori con vari livelli di conoscenza della programmazione di sistemi. Il codice di basso livello è
propenso a vari bug sottili, che nella maggior parte degli altri linguaggi possono essere catturati
solo attraverso test estensivi e un'attenta revisione del codice da parte di sviluppatori esperti.
In Rust, il compilatore svolge un ruolo di guardiano rifiutando di 
compilare codice con questi bug elusivi, inclusi i bug di Concurrency.
Lavorando a fianco del compilatore, il team può dedicare il suo tempo a concentrarsi sulla logica del programma
piuttosto che a caccia di bug.

Rust porta anche strumenti di sviluppo contemporanei nel mondo della programmazione dei sistemi:

* Cargo, il gestore di dipendenze e strumento di compilazione incluso, rende l'aggiunta, 
  la compilazione e la gestione delle dipendenze indolori e coerenti in tutto l'ecosistema Rust.
* Lo strumento di formattazione Rustfmt garantisce uno stile di codifica coerente attraverso
  gli sviluppatori.
* Il Rust Language Server alimenta l'integrazione dell'Ambiente di Sviluppo Integrato (IDE)
  per il completamento del codice e i messaggi di errore inline.

Utilizzando questi e altri strumenti nell'ecosistema Rust, gli sviluppatori possono essere
produttivi mentre scrivono codice di livello sistema.

### Studenti

Rust è per gli studenti e per coloro che sono interessati a imparare i concetti sui sistemi
. Usando Rust, molte persone hanno imparato argomenti come lo sviluppo di sistemi operativi.
La community è molto accogliente e felice di rispondere alle domande degli studenti. Attraverso sforzi come questo libro, i team di Rust vogliono 
rendere i concetti dei sistemi più accessibili a più persone, specialmente a quelle nuove nella programmazione.

### Aziende

Centinaia di aziende, grandi e piccole, usano Rust in produzione per vari 
compiti, tra cui strumenti da riga di comando, servizi web, strumentazione DevOps, dispositivi incorporati, 
analisi audio e video e transcodifica, criptovalute,
bioinformatica, motori di ricerca, applicazioni Internet of Things, apprendimento automatico, e persino 
parti importanti del browser web Firefox.

### Sviluppatori Open Source

Rust è per le persone che vogliono costruire il linguaggio di programmazione Rust, la comunità,
gli strumenti per sviluppatori e le librerie. Ci piacerebbe che tu contribuissi al linguaggio Rust.

### Persone che apprezzano la velocità e la stabilità

Rust è per le persone che desiderano velocità e stabilità in un linguaggio. Con velocità, intendiamo sia 
quanto velocemente il codice Rust può essere eseguito e la velocità con cui Rust ti consente
di scrivere programmi. I controlli del compilatore Rust garantiscono stabilità attraverso 
aggiunta di funzionalità e rifattorizzazione. Questo è in contrasto con il codice legacy fragile in
i linguaggi senza questi controlli, che gli sviluppatori spesso hanno paura di modificare. Sforzandosi per abstrazioni a costo zero, 
caratteristiche di livello superiore che si compilano in codice di livello inferiore veloce come il codice scritto manualmente, 
Rust si sforza di rendere il codice sicuro anche il codice veloce.

Si spera che il linguaggio Rust supporti anche molti altri utenti; quelli menzionati
qui sono semplicemente alcuni dei maggiori stakeholder. Nel complesso, l'ambizione più grande di Rust è quella di eliminare i compromessi che i programmatori hanno accettato 
per decenni fornendo sicurezza *e* produttività, velocità *e* ergonomia. Dai una prova a Rust e vedi 
se le sue scelte funzionano per te.

## Per chi è questo libro

Questo libro presume che tu abbia scritto codice in un altro linguaggio di programmazione ma 
non fa supposizioni su quale. Abbiamo cercato di rendere il materiale 
ampiamente accessibile a coloro provenienti da una vasta gamma di background di programmazione. Non 
passiamo molto tempo a parlare di cosa sia la programmazione *è* o su come pensarci. Se sei del tutto nuovo alla programmazione, 
sarebbe meglio servito leggendo un libro che fornisce specificamente un'introduzione alla programmazione.

## Come utilizzare questo libro

In generale, questo libro presuppone che tu lo stia leggendo in sequenza dall'inizio alla fine.
I capitoli successivi si basano su concetti nei capitoli precedenti, e i capitoli precedenti potrebbero non approfondire i dettagli su un particolare argomento ma 
rivisiteranno l'argomento in un capitolo successivo.

Troverai due tipi di capitoli in questo libro: capitoli di concetti e capitoli di progetti. Nei capitoli di concetto, apprenderai un aspetto di Rust. Nei capitoli di progetto, costruiremo piccoli programmi insieme, applicando ciò che hai finora appreso. I capitoli 2, 12 e 20 sono capitoli di progetto; il resto sono capitoli di concetto.

Il Capitolo 1 spiega come installare Rust, come scrivere un programma "Hello, world!", e come usare Cargo, il gestore di pacchetti di Rust e strumento di compilazione. Il Capitolo 2 è un'introduzione pratica alla scrittura di un programma in Rust, facendoti costruire un gioco di indovinare numeri. Qui copriamo concetti ad alto livello, e i capitoli successivi forniranno dettagli aggiuntivi. Se vuoi sporcarti le mani subito, il Capitolo 2 è il luogo adatto per farlo. Il Capitolo 3 copre le funzionalità di Rust che sono simili a quelle di altri linguaggi di programmazione, e nel Capitolo 4 imparerai il sistema di Ownership di Rust. Se sei un apprendista particolarmente scrupoloso che preferisce imparare ogni dettaglio prima di passare al successivo, potresti voler saltare il Capitolo 2 e andare direttamente al Capitolo 3, tornando al Capitolo 2 quando vorrai lavorare su un progetto applicando i dettagli che hai appreso.

Il Capitolo 5 discute Structs e metodi, e il Capitolo 6 copre Enum, espressioni `match`
e l'istruzione di controllo del flusso `if let`. Userai Structs e Enum per creare tipi personalizzati in Rust.

Nel Capitolo 7, imparerai il sistema dei moduli di Rust e le regole della privacy
per organizzare il tuo codice e la sua pubblica Interfaccia di Programmazione dell'Applicazione
(API). Il Capitolo 8 discute alcune comuni strutture di dati di collezioni che la
la libreria standard fornisce, come i vettori, le stringhe e le mappe hash. Il Capitolo 9
esplora la filosofia e le tecniche di gestione degli errori di Rust.

Il Capitolo 10 approfondisce i generici, i traits, e i lifetimes, che ti danno il potere
di definire il codice che si applica a più tipi. Il Capitolo 11 riguarda tutti i test,
che anche con le garanzie di sicurezza di Rust sono necessari per assicurare la correttezza della logica del tuo programma.
Nel Capitolo 12, costruiremo la nostra implementazione di un sottoinsieme di funzionalità dal `grep` comando da riga di comando che cerca testo
all'interno dei file. Per questo, utilizzeremo molti dei concetti che abbiamo discusso nei
capitoli precedenti.

Il Capitolo 13 esplora closures e iteratori: caratteristiche di Rust che provengono
da linguaggi di programmazione funzionali. Nel Capitolo 14, esamineremo Cargo in più
profondità e parleremo delle migliori pratiche per condividere le tue librerie con gli altri.
Il Capitolo 15 discute i puntatori intelligenti che la libreria standard fornisce e i
traits che abilitano le loro funzionalità.

Nel Capitolo 16, passeremo attraverso diversi modelli di programmazione concorrente
e parleremo di come Rust ti aiuta a programmare in più thread senza paura.
Il Capitolo 17 guarda come gli idiomi di Rust si confrontano con 
principi di programmazione orientata agli oggetti con cui potresti essere familiare.

Il Capitolo 18 è un riferimento sui pattern e il matching di pattern, che sono potenti
modi di esprimere idee nei programmi Rust. Il Capitolo 19 contiene un assortimento di argomenti avanzati di interesse, tra cui Rust insicuro, macro, e 
altre informazioni su lifetimes, traits, tipi, funzioni e closures.

Nel Capitolo 20, completeremo un progetto in cui implementeremo un server web a basso livello
multithread!
Infine, alcuni appendici contengono informazioni utili sul linguaggio in un
formato più simile a un riferimento. L'appendice A copre le parole chiave di Rust, l'appendice B
copre gli operatori e i simboli di Rust, l'appendice C copre i trait derivabili
forniti dalla libreria standard, l'appendice D copre alcuni strumenti di sviluppo utili, 
e l'appendice E spiega le edizioni di Rust. Nell'appendice F, puoi trovare
traduzioni del libro, e nell'appendice G tratteremo come viene fatto Rust e
cosa sia il Rust nightly.

Non c'è un modo sbagliato di leggere questo libro: se vuoi saltare avanti, fallo!
Potresti dover tornare indietro ai capitoli precedenti se riscontri qualche
confusione. Ma fai quello che funziona per te.

<span id="ferris"></span>

Una parte importante del processo di apprendimento del Rust è imparare a leggere i
messaggi di errore che il compilatore visualizza: questi ti guideranno verso il codice funzionante.
Come tale, forniremo molti esempi che non compilano insieme al messaggio di errore
che il compilatore ti mostrerà in ogni situazione. Sappi che se inserisci
ed esegui un esempio casuale, potrebbe non compilare! Assicurati di leggere il
testo circostante per vedere se l'esempio che stai cercando di eseguire è destinato a generare un errore. Ferris ti aiuterà anche a distinguere il codice che non dovrebbe funzionare:

| Ferris                                                                                                           | Significato                                     |
|------------------------------------------------------------------------------------------------------------------|-------------------------------------------------|
| <img src="img/ferris/does_not_compile.svg" class="ferris-explain" alt="Ferris con un punto interrogativo"/>      | Questo codice non compila!                      |
| <img src="img/ferris/panics.svg" class="ferris-explain" alt="Ferris con le mani alzate"/>                        | Questo codice va in panic!                      |
| <img src="img/ferris/not_desired_behavior.svg" class="ferris-explain" alt="Ferris con una zampa alzata"/>       | Questo codice non produce il comportamento desiderato. |

Nella maggior parte delle situazioni, ti guideremo verso la versione corretta di qualsiasi codice che
non compila.

## Codice Sorgente

I file sorgente da cui è generato questo libro possono essere trovati su
[GitHub][book].

[book]: https://github.com/Rust-User-Group-VR/rust_book_ita

