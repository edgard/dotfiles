if has("gui_macvim")
  macmenu File.Print key=<nop>
  macmenu File.New\ Tab key=<nop>
  macmenu File.New\ Window key=<nop>
  macmenu File.Close key=<nop>
  macmenu File.Open\.\.\. key=<nop>
  macmenu &File.Open\ Tab\.\.\. key=<nop>

  autocmd GUIEnter * set visualbell t_vb=

  set guifont=PragmataPro:h14

  set guioptions+=t
  set guioptions-=r  " remove right scroll bar
  set guioptions-=R  "remove right scrool bar when split
  set guioptions-=l  " remove left scroll bar
  set guioptions-=L  " remove left scrool bar when split
  set guioptions-=b  " remove bottom scroll bar
  set guioptions-=m  " hide menu bar
  set guioptions-=T  " hide tool bar
endif
