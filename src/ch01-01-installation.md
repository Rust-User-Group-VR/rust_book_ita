## Installazione

Il primo passo è installare Rust. Scaricheremo Rust attraverso `rustup`, uno
strumento da linea di comando per la gestione delle versioni Rust e degli strumenti associati. Avrai bisogno
di una connessione internet per il download.

> Nota: Se preferisci non usare `rustup` per qualche motivo, per favore consulta il
> [pagina dei metodi di installazione di Rust][otherinstall] per più opzioni.

I seguenti passaggi installano l'ultima versione stabile del compilatore Rust.
Le garanzie di stabilità di Rust assicurano che tutti gli esempi nel libro che
compilano continueranno a compilare con le nuove versioni di Rust. L'output potrebbe
differire leggermente tra le versioni perché Rust migliora spesso i messaggi di errore e
avvertenze. In altre parole, qualsiasi versione, stabile e più recente, di Rust che installi utilizzando
questi passaggi dovrebbe funzionare come previsto con il contenuto di questo libro.

> ### Notazione da linea di comando
>
> In questo capitolo e in tutto il libro, mostreremo alcuni comandi utilizzati nel
> terminale. Le linee che dovresti inserire in un terminale iniziano tutte con `$`. Non
> c'è bisogno di digitare il carattere `$`; è il prompt del comando da linea mostrato per
> indicare l'inizio di ogni comando. Le linee che non iniziano con `$` mostrano tipicamente
> l'output del comando precedente. Inoltre, gli esempi specifici di PowerShell
> useranno `>` piuttosto che `$`.

### Installazione di `rustup` su Linux o macOS

Se stai usando Linux o macOS, apri un terminale e inserisci il seguente comando:

```console
$ curl --proto '=https' --tlsv1.2 https://sh.rustup.rs -sSf | sh
```

Il comando scarica uno script e avvia l'installazione del
strumento `rustup`, che installa l'ultima versione stabile di Rust. Potrebbe essere richiesto
di inserire la tua password. Se l'installazione va a buon fine, apparirà la seguente linea:

```text
Rust è ora installato. Fantastico!
```

Avrai anche bisogno di un *linker*, che è un programma che Rust usa per unire i suoi
output compilati in un unico file. È probabile che tu ne abbia già uno. Se ottieni errori del linker, dovresti installare un compilatore C, che include tipicamente un
linker. Un compilatore C è anche utile perché alcuni pacchetti comuni di Rust dipendono da
codice C e avranno bisogno di un compilatore C.

Su macOS, puoi ottenere un compilatore C eseguendo:

```console
$ xcode-select --install
```

Gli utenti Linux dovrebbero generalmente installare GCC o Clang, secondo la
documentazione della loro distribuzione. Ad esempio, se usi Ubuntu, puoi installare
il pacchetto `build-essential`.

### Installazione di `rustup` su Windows

Su Windows, vai a [https://www.rust-lang.org/tools/install][install] e segui
le istruzioni per l'installazione di Rust. Ad un certo punto dell'installazione, riceverai un messaggio che spiega che avrai anche bisogno degli strumenti di costruzione MSVC per
Visual Studio 2013 o successivo.

Per acquisire gli strumenti di costruzione, dovrai installare [Visual Studio
2022][visualstudio]. Quando ti verrà chiesto quali workload installare, includi:

* "Sviluppo Desktop con C++"
* Il SDK di Windows 10 o 11
* Il pacchetto di lingua inglese, insieme a qualsiasi altro pacchetto di lingue della tua scelta

Il resto di questo libro utilizza comandi che funzionano sia in *cmd.exe* che in PowerShell.
Se ci sono delle differenze specifiche, spiegheremo quale utilizzare.

### Risoluzione dei problemi

Per verificare se hai installato correttamente Rust, apri una shell e inserisci quest
riga:

```console
$ rustc --version
```

Dovresti vedere il numero di versione, l'hash del commit, e la data del commit per l'ultima
versione stabile che è stata rilasciata, nel seguente formato:

```text
rustc x.y.z (abcabcabc yyyy-mm-dd)
```

Se vedi queste informazioni, hai installato con successo Rust! Se non vedi queste informazioni, verifica che Rust si trovi nella tua variabile di sistema `%PATH%` come segue.

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

Se tutto è corretto e Rust ancora non funziona, ci sono diversi
posti dove puoi ottenere aiuto. Scopri come metterti in contatto con altri utenti di Rust (un
soprannome un po' sciocco che ci diamo) sulla [pagina della community][community].

### Aggiornamento e Disinstallazione

Una volta installato Rust tramite `rustup`, l'aggiornamento a una versione appena rilasciata è
semplice. Dalla tua shell, esegui lo script di aggiornamento seguente:

```console
$ rustup update
```

Per disinstallare Rust e `rustup`, esegui lo script di disinstallazione seguente dalla tua shell:

```console
$ rustup self uninstall
```

### Documentazione Locale

L'installazione di Rust include anche una copia locale della documentazione in modo
che tu possa leggerla offline. Esegui `rustup doc` per aprire la documentazione locale
sul tuo browser.

Ogni volta che viene fornito un tipo o una funzione dalla libreria standard e non sei
sicuro di cosa fa o come usarlo, usa la documentazione dell'interfaccia di programmazione dell'applicazione (API) per scoprirlo!

[otherinstall]: https://forge.rust-lang.org/infra/other-installation-methods.html
[install]: https://www.rust-lang.org/tools/install
[visualstudio]: https://visualstudio.microsoft.com/downloads/
[community]: https://www.rust-lang.org/community
