autoload -Uz insert-last-word 
zle -N insert-last-word 
bindkey -M viins '^[lastarg' insert-last-word

#Horizontal word traversal with arrow keys (escape sequence set in iterm opts)
bindkey -M viins '^[b' vi-backward-word
bindkey -M viins '^[f' vi-forward-word

#Word deletion
bindkey -M viins '^[dwb' backward-delete-word
bindkey -M viins '^[dwf' delete-word

#Arrow key history search
#autoload -Uz up-line-or-beginning-search
#autoload -Uz down-line-or-beginning-search
#zle -N up-line-or-beginning-search
#zle -N down-line-or-beginning-search
#bindkey -M viins '^[[A' up-line-or-beginning-search 
#bindkey -M viins '^[[B' down-line-or-beginning-search 

# start typing + [Up-Arrow] - fuzzy find history forward
if [[ "${terminfo[kcuu1]}" != "" ]]; then
  autoload -U up-line-or-beginning-search
  zle -N up-line-or-beginning-search
  bindkey -M viins "${terminfo[kcuu1]}" up-line-or-beginning-search
fi
# start typing + [Down-Arrow] - fuzzy find history backward
if [[ "${terminfo[kcud1]}" != "" ]]; then
  autoload -U down-line-or-beginning-search
  zle -N down-line-or-beginning-search
  bindkey -M viins "${terminfo[kcud1]}" down-line-or-beginning-search
fi
