{ pkgs, ... }: pkgs.writeScriptBin "translator_helper" ''
  #!${pkgs.nushell}/bin/nu

  def main [
    path: string
    --chapter (-c)
    --file (-f)
  ] {
    if $chapter {
      let chaptername = $path | split chars | range 0..3 | str join
      print $"Running markdown translator on chapter ($chaptername)"
      for fname in ((ls ./original/src/).name | where { |$fname| $fname | str starts-with ("original/src/" + $chaptername) }) {
        print $"Running martdown translator on ($fname) with dest src/(($fname | split row "/").2)"
        gpt_md_translator -c ./gptmdt_settings.toml -i $fname -o $"src/(($fname | split row "/").2)"
      }
    } else if $file {
      print $"Running markdown translator on ./original/src/($path) with dest ./src/($path)"
      gpt_md_translator -c ./gptmdt_settings.toml -i $"./original/src/($path)" -o $"./src/($path)"
    } else {
      print "You need to specify either --chapter or --file"
    }
  }
''