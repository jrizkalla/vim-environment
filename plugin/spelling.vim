command! -nargs=2 Spell silent call spelling#CreateAbbrev(<f-args>)
command! LoadSpelling silent call spelling#LoadSpellingAbbrevs()
