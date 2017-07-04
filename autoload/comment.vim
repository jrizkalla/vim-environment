if exists("g:loaded_vimenv_comment")
    finish
endif

let g:loaded_vimenv_comment = 1


if !exists("g:comment_string")
    " Create the default one
    " Note: comments without a delim are marked with ? to 
    " identify them from normal comments
    " Comments like /* */ are not because they can't be nesed
    let g:comment_string = {
                \"vim"        : ['"?'],
                \"c"          : ["//?"],
                \"c++"        : ["//?" ],
                \"cpp"        : ["//?" ],
                \"ld"         : ["/*?", "*/"],
                \"css"        : ["/*?", "*/"],
                \"scss"       : ["//?"],
                \"java"       : ["//?" ],
                \"python"     : ["#?"],
                \"javascript" : ["//?"],
                \"tex"        : ["%?"],
                \"plaintex"   : ["%?"],
                \"objc"       : ["//?"],
                \"swift"      : ["//?"],
            \}
    
    if !exists("g:comment_string_extra")
        let g:comment_string_extra = {}
    endif
endif

" FUNCTION: comment#ToggleComment
" Toggle commenting on a range of lines
function! comment#ToggleComment() range
    let orig_pos = getcurpos()
    
    if !has_key(g:comment_string, &filetype) && !has_key(g:comment_string_extra, &filetype)
        echoe "Error: I don't know how to comment '" . &filetype . "'. Try adding an entry to g:comment_string_extra."
    endif
    
    if has_key(g:comment_string, &filetype)
        let comment_sym = g:comment_string[&filetype]
    else
        let comment_sym = g:comment_string_extra[&filetype]
    endif
    
    let is_long_comment = len(comment_sym) == 2
    let left_sym = comment_sym[0]
    if is_long_comment
        let right_sym = comment_sym[1]
    endif
    
    for linenum in range(a:firstline, a:lastline)
        " does it start with the left symbol
        let line = getline(linenum)
        
        let is_commented = 0
        if len(line) >= len(left_sym) && line[0:len(left_sym)-1] == left_sym
            if is_long_comment && len(line) >= (len(left_sym)+len(right_sym))
                        \ && line[len(line)-len(right_sym):] == right_sym
                let is_commented = 1
            elseif !is_long_comment
                let is_commented = 1
            endif
        endif
        
        call cursor(linenum, 1) " col doesn't matter
        
        if is_commented
            execute "normal! 0" . len(left_sym) . "x"
            if is_long_comment
                execute "normal! $" . (len(right_sym)-1) . "hd$"
            endif
        else
            execute "normal! 0i" . left_sym . "\<esc>"
            if is_long_comment
                execute "normal! A" . right_sym . "\<esc>"
            endif
        endif
        
    endfor
    
    " restore position
    call setpos('.', orig_pos)
endfunction

" FUNCTION: comment#ToggleCommentLine
" Toggle comment for a single line
function! comment#ToggleCommentLine()
    let file = &ft
    
    if !has_key(g:comment_string, file)
        echoe "Error: I don't know how to comment '" . file . "' files. Try adding an entry to g:comment_string_extra"
    endif
    
    let comment_sym = g:comment_string[file]
    
    " Is the start sym the first thing on this line?
    let line_split = split(getline("."), ' ')
    
    if len(line_split) == 0 || 
                \len(line_split[0]) < len(comment_sym[0]) ||
                \line_split[0][0:len(comment_sym[0])-1] !=# comment_sym[0]
        " The line is not commented.
        let put_comment = "normal! I" . comment_sym[0]
        if len(comment_sym) > 1
            let put_comment .= "\<esc>A" . comment_sym[1]
        endif
        execute put_comment
    else
        " Remove the comment
        let rem_comment = "normal! ^" . len(comment_sym[0]) . "x"
        if len(comment_sym) > 1
            let rem_comment .= "g_" . (len(comment_sym[1])-1) . "h" . len(comment_sym[1]) . "x"
        endif
        execute rem_comment
    endif
endfunction
