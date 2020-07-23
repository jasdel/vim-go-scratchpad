" Only run once.
if exists("g:go_scratchpad_loaded_install")
  finish
endif
let g:go_scratchpad_loaded_install = 1

" don't spam the user when Vim is started in Vi compatibility mode
let s:cpo_save = &cpo
set cpo&vim

function! s:checkVersion() abort
" TODO version checks?
endfunction

call s:checkVersion()

command! -nargs=? -complete=dir GoScratchpad call s:GoScratchpad(<f-args>)

function! s:GoScratchpad(rootPath)
  if rootPath != ""
    let l:tmpdir = rootPath
  else
    let l:tmpdir = go#util#tempdir('vim-go-scratchpad')
  endif

  let l:cd = exists('*haslocaldir') && haslocaldir() ? 'lcd ' : 'cd '
  let l:dir = getcwd()

  try
    execute l:cd . fnameescape(l:tmpdir)

    let l:make_mod_cmd = ['go', 'mod', 'init', 'vim-go-scratchpad/sheet']
    vnew 'main.go'

    let [l:out, l:err] = go#util#Exec(l:make_mod_cmd)
    if l:err
      call go#util#EchoError(printf('Error installing %s: %s', l:importPath, l:out))
    endif

  finally
    execute l:cd . fnameescape(l:dir)
  endtry

endfunction

" restore Vi compatibility settings
let &cpo = s:cpo_save
unlet s:cpo_save

" vim: sw=2 ts=2 et
