if exists('b:did_indent')
    finish
endif

let b:did_indent = 1

setlocal indentexpr=GetVarlinkIndent()
setlocal indentkeys=o,O,0)

function! GetVarlinkIndent()
    let prev = prevnonblank(v:lnum - 1)
    if prev == 0
        return 0
    endif

    let ind = indent(prev)
    let pline = substitute(getline(prev), '#.*$', '', '')
    let line  = substitute(getline(v:lnum), '#.*$', '', '')

    " Previous line opened a nesting level.
    if count(pline, '(') > count(pline, ')')
        let ind += shiftwidth()
    endif

    " Current line closes a nesting level.
    if line =~ '^\s*)'
        let ind -= shiftwidth()
    endif

    return max([0, ind])
endfunction
