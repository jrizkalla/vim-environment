# vim-environment
My Vim environment (as a plugin).

## Comment

Comment is a simple plugin to allow commenting of code.
To comment lines `n` to `m` run Comment with range `n,m`: `n,mComment`.

To add support for files, define `g:comment_string_extra` as a dictionary of filename with an arrays of comment strings.
If comments are single lines (such as Python # comments), simply place one entry in the array.
If comments must be delimited (such as Css comments `/* */`), place two entries in the array.
For example, the following adds support for language foo which comments its code using a caret and bar which comments its code using brackets.
```vim
let g:comment_string_extra = {
  \"foo": ["^"],
  \"bar": ["{", "}"],
}
```

## Spelling

Spelling is a simple plugin that fixes spelling mistakes.
It uses any file that has the glob pattern `spelling*.txt` in `g:spelling_search_directory` (default, `~/.vim/`) to store words you misspell and their corrections.

Run `LoadSpelling` to load all spellings.
Use `Spell <wrong word> <right word>` to add a misspelling to `spelling.txt`.
