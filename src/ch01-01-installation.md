## Installazione

Il primo passo è installare Rust. Scaricheremo Rust tramite `rustup`, uno
strumento da linea di comando per gestire le versioni di Rust e gli strumenti associati. Avrai bisogno di una connessione internet per il download.

> Nota: Se preferisci non utilizzare `rustup` per qualche motivo, consulta la
> [pagina Altri Metodi di Installazione di Rust][otherinstall] per altre opzioni.

I seguenti passi installano l'ultima versione stabile del compilatore Rust.
Le garanzie di stabilità di Rust assicurano che tutti gli esempi nel libro che
compilano continueranno a compilare con le versioni più recenti di Rust. L'output potrebbe
variare leggermente tra le versioni poiché Rust spesso migliora i messaggi di errore e
di avvertimento. In altre parole, qualsiasi nuova versione stabile di Rust installata
seguendo questi passi dovrebbe funzionare come previsto con il contenuto di questo libro.

> ### Notazione della Linea di Comando
>
> In questo capitolo e in tutto il libro, mostreremo alcuni comandi usati nel
> terminale. Le righe che dovresti inserire in un terminale iniziano tutte con `$`. Non hai bisogno di digitare il carattere `$`; è il prompt della linea di comando mostrato per
> indicare l'inizio di ciascun comando. Le righe che non iniziano con `$` tipicamente
> mostrano l'output del comando precedente. Inoltre, gli esempi specifici di PowerShell
> useranno `>` anziché `$`.

### Installare `rustup` su Linux o macOS

Se stai usando Linux o macOS, apri un terminale e inserisci il seguente comando:

```console
$ curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh
```

Il comando scarica uno script e avvia l'installazione dello strumento `rustup`,
che installa l'ultima versione stabile di Rust. Potresti essere invitato a
fornire la tua password. Se l'installazione è riuscita, verrà visualizzata la seguente riga:

```text
Rust is installed now. Great!
```

Avrai anche bisogno di un *linker*, che è un programma che Rust utilizza per unire i suoi
output compilati in un unico file. È probabile che tu ne abbia già uno. Se ottieni
errori di linker, dovresti installare un compilatore C, che includerà tipicamente un
linker. Un compilatore C è anche utile perché alcuni pacchetti Rust comuni dipendono dal
codice C e avranno bisogno di un compilatore C.

Su macOS, puoi ottenere un compilatore C eseguendo:

```console
$ xcode-select --install
```

Gli utenti Linux dovrebbero generalmente installare GCC o Clang, in base alla
documentazione della loro distribuzione. Ad esempio, se usi Ubuntu, puoi installare il pacchetto `build-essential`.

### Installare `rustup` su Windows

Su Windows, vai a [https://www.rust-lang.org/tools/install][install] e segui
le istruzioni per installare Rust. Ad un certo punto dell'installazione, ti verrà chiesto di installare Visual Studio. Questo fornisce un linker e le librerie native necessarie per compilare i programmi. Se hai bisogno di ulteriore assistenza con questo passaggio, consulta [https://rust-lang.github.io/rustup/installation/windows-msvc.html][msvc]

Il resto di questo libro utilizza comandi che funzionano sia in *cmd.exe* che in PowerShell.
Se ci sono differenze specifiche, spiegheremo quale usare.

### Risoluzione dei Problemi

Per verificare se hai installato correttamente Rust, apri una shell e inserisci questa
riga:

```console
$ rustc --version
```

Dovresti vedere il numero di versione, l'hash del commit e la data del commit per l'ultima versione stabile rilasciata, nel seguente formato:

```text
rustc x.y.z (abcabcabc yyyy-mm-dd)
```

Se vedi queste informazioni, hai installato correttamente Rust! Se non vedi queste informazioni, verifica che Rust sia nella variabile di sistema `%PATH%` come segue.

In CMD di Windows, usa:

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

Se tutto ciò è corretto e Rust non funziona ancora, ci sono vari posti dove puoi ottenere aiuto. Scopri come entrare in contatto con altri Rustaceans (un soprannome scherzoso che ci diamo) sulla [pagina della comunità][community].

### Aggiornamento e Disinstallazione

Una volta che Rust è installato tramite `rustup`, aggiornare a una versione rilasciata di recente è semplice. Dalla tua shell, esegui il seguente script di aggiornamento:

```console
$ rustup update
```

Per disinstallare Rust e `rustup`, esegui il seguente script di disinstallazione dalla tua shell:

```console
$ rustup self uninstall
```

### Documentazione Locale

L'installazione di Rust include anche una copia locale della documentazione in modo che tu possa leggerla offline. Esegui `rustup doc` per aprire la documentazione locale nel tuo browser.

Ogni volta che un tipo o una funzione è fornita dalla libreria standard e non sei
sicuro di cosa faccia o di come usarla, usa la documentazione dell'interfaccia di programmazione delle applicazioni (API) per approfondire!

[otherinstall]: https://forge.rust-lang.org/infra/other-installation-methods.html
[install]: https://www.rust-lang.org/tools/install
[msvc]: https://rust-lang.github.io/rustup/installation/windows-msvc.html
[community]: https://www.rust-lang.org/community

