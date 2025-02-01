
## vis-tab-autoconf

tab-autoconf will autoconfigure, that is, set expandtab and tabwidth from the file being edited.

### Installation

Put this somewhere in your vis settings and require as normal in your visrc.

It returns a table[setting] 

### Module

```
NAME: tabautoconf
DESC: <string>
search_limit: 500 -- Limits the amount of lines to search for
spacelimit: 8 -- limit for indentation guessed
```

spacelimit is necessary because sometimes files first indent found can be huge
this ignores that indentation and looks for the next one
