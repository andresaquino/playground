if !exists('loaded_snippet') || &cp
    finish
endif

"let st = g:snip_start_tag
let st = "${"
let et = "}"
"let et = g:snip_end_tag
"let cd = g:snip_elem_delim

"Snippet !env #!/usr/bin/env ${1:${TM_SCOPE/(?:source|.*)\\.(\\w+).*/$1/}}
exec "Snippet if if [ ".st."_VAR_".et." -eq _VAL_ ]<CR>then<CR>_INSTRUCTIONS_<CR>fi<CR>"
exec "Snippet elif elif [ ".st."_CONDITION_".et." ]; then<CR>".st.et
exec "Snippet for for ITEM in ".st."_VAR_".et."<CR>do<CR>_INSTRUCTIONS_<CR>done"
exec "Snippet while while (".st."_VAR_".et.")<CR>do<CR>_INSTRUCTIONS_<CR>done"
exec "Snippet case case ".st."_VAR_".et." in<CR>_VAL_ )<CR>_INSTRUCTIONS_<CR>;;<CR><CR>*)<CR>_DEFAULT_<CR>;;<CR><CR>esac"
exec "Snippet #function # name_of_function <CR>name_of_function () {<CR>_INSTRUCTIONS_<CR>}"
