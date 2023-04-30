
vim.keymap.set("n", "<space>m1r", "^dt.x$F.r?<Ignore>dF.^:s/\\./<Space>p<BS>g<BS>/g<CR>f?r.<Ignore>" , {})
vim.keymap.set("n", "<space>mr", "^$F.r?<Ignore>dF.^:s/\\./<Space>p<BS>g<BS>/g<CR>f?r.<Ignore>" , {})
