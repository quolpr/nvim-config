return function()
  vim.g['fern#renderer'] = 'nerdfont'

  -- TODO: port it to lua
  vim.cmd([[
    nmap <silent> - :Fern . -reveal=% -wait <CR>
    nmap <silent> _ :Fern %:p:h -wait -reveal=% <CR>


    function! s:init_fern() abort
      nmap <buffer> <C-J> <C-W><C-J>
      nmap <buffer> <C-K> <C-W><C-K>
      nmap <buffer> <C-L> <C-W><C-L>
      nmap <buffer> <C-H> <C-W><C-H>
      nmap <buffer> <CR> <Plug>(fern-action-open-or-expand)
    endfunction

    augroup fern-custom
      autocmd! *
      autocmd FileType fern call s:init_fern()
    augroup END
  ]])
end
