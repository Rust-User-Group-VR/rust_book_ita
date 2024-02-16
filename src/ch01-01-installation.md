## Installazione

Il primo passo è installare Rust. Scaricheremo Rust attraverso `rustup`, uno
strumento da linea di comando per la gestione delle versioni Rust e degli strumenti associati. Avrai bisogno
di una connessione internet per il download.

> Nota: Se per qualche motivo preferisci non usare `rustup`, consulta la
> pagina [Altri metodi di installazione di Rust][otherinstall] per altre opzioni.

I seguenti passaggi installano l'ultima versione stabile del compilatore Rust.
Le garanzie di stabilità di Rust assicurano che tutti gli esempi nel libro che
compilano continueranno a compilare con versioni Rust più recenti. L'output potrebbe
differire leggermente tra le versioni perché Rust migliora spesso i messaggi di errore e
avvisi. In altre parole, qualsiasi versione più recente e stabile di Rust che installi utilizzando
questi passaggi dovrebbero funzionare come previsto con il contenuto di questo libro.

> ### Notazione della linea di comando
>
> In questo capitolo e in tutto il libro, mostreremo alcuni comandi utilizzati nel
> terminale. Le linee che dovresti inserire in un terminale iniziano tutte con `$`. Non
> hai bisogno di digitare il carattere `$`; è il prompt della linea di comando mostrato per
> indicare l'inizio di ogni comando. Le linee che non iniziano con `$` tipicamente
> mostrano l'output del comando precedente. Inoltre, esempi specifici per PowerShell
> utilizzeranno `>` invece di `$`.

### Installazione di `rustup` su Linux o macOS

Se stai utilizzando Linux o macOS, apri un terminale e inserisci il seguente comando:

```console
$ curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh
```

Il comando scarica uno script e inizia l'installazione dello strumento `rustup`,
che installa l'ultima versione stabile di Rust. Potrebbe esserti richiesta
la tua password. Se l'installazione ha successo, apparirà la seguente linea:

```text
Rust is installed now. Great!
```

Avrai anche bisogno di un *linker*, che è un programma che Rust usa per unire i suoi
output compilati in un unico file. È probabile che ne abbia già uno. Se ricevi errori del linker, dovresti installare un compilatore C, che di solito include un linker. Un compilatore C è anche utile perché alcuni pacchetti Rust comuni dipendono da
codice C e avranno bisogno di un compilatore C.

Su macOS, puoi ottenere un compilatore C eseguendo:

```console
$ xcode-select --install
```

Gli utenti Linux dovrebbero generalmente installare GCC o Clang, secondo la
documentazione della loro distribuzione. Ad esempio, se stai utilizzando Ubuntu, puoi installare
il pacchetto `build-essential`.

### Installazione di `rustup` su Windows

Su Windows, vai a [https://www.rust-lang.org/tools/install][install] e segui
le istruzioni per installare Rust. Ad un certo punto dell'installazione, riceverai
un messaggio che spiega che avrai anche bisogno degli strumenti di compilazione MSVC per
Visual Studio 2013 o versioni successive.

Per acquisire gli strumenti di compilazione, dovrai installare [Visual Studio
2022][visualstudio]. Quando ti verrà chiesto quali carichi di lavoro installare, include:

* "Sviluppo desktop con C++"
* Il SDK di Windows 10 o 11
* Il componente del pacchetto lingua inglese, insieme a qualsiasi altro pacchetto lingua di
  tua scelta

Il resto di questo libro usa comandi che funzionano sia in *cmd.exe* che in PowerShell.
Se ci sono differenze specifiche, spiegheremo quale utilizzare.

### Risoluzione dei problemi

Per verificare se hai installato correttamente Rust, apri una shell e inserisci questa
riga:

```console
$ rustc --version
```

Dovresti vedere il numero di versione, il hash del commit e la data del commit per l'ultima
versione stabile che è stata rilasciata, nel seguente formato:

```text
rustc x.y.z (abcabcabc yyyy-mm-dd)
```

Se vedi queste informazioni, hai installato Rust con successo! Se non vedi queste informazioni, verifica che Rust sia nella tua variabile di sistema `%PATH%` come segue.

In Windows CMD, usa:

```console
> echo %PATH%
```

In PowerShell, usa:

```powershell
> echo $env:Path
```

In Linux e macOS, usa:

```console
$ echo $PATH
```

Se tutto è corretto e Rust ancora non funziona, ci sono un numero di
posti dove puoi ottenere aiuto. Scopri come metterti in contatto con altri Rustaceans (un
nomignolo sciocco che ci chiamiamo) sulla [pagina della community][community].

### Aggiornamento e disinstallazione

Una volta che Rust è installato tramite `rustup`, aggiornare a una versione appena rilasciata è
facile. Dalla tua shell, esegui lo script di aggiornamento seguente:

```console
$ rustup update
```

Per disinstallare Rust e `rustup`, esegui lo script di disinstallazione seguente dalla tua shell:

```console
$ rustup self uninstall
```

### Documentazione locale

L'installazione di Rust include anche una copia locale della documentazione in modo
che tu possa leggerla offline. Esegui `rustup doc` per aprire la documentazione locale
nel tuo browser.

Ogni volta che un tipo o una funzione sono forniti dalla libreria standard e non sei
sicuro di cosa faccia o di come usarla, usa la documentazione dell'interfaccia di programmazione delle applicazioni (API) per scoprirlo!

[otherinstall]: https://forge.rust-lang.org/infra/other-installation-methods.html
[install]: https://www.rust-lang.org/tools/install
[visualstudio]: https://visualstudio.microsoft.com/downloads/
[community]: https://www.rust-lang.org/community
