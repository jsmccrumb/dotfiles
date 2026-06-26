-- Use Tree-sitter expressions to determine where code can fold
vim.o.foldmethod = "expr"
-- vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- Lower thresholds so small/nested blocks are allowed to collapse
vim.o.foldminlines = 0
vim.o.foldnestmax = 10
-- Keep folds open by default when opening a new file
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99

-- Customize how a closed fold looks
vim.o.foldtext = "v:lua.vim.treesitter.foldtext()"

-- Keep the renderer function in the global table so Neovim's engine can find it
_G.custom_go_foldtext = function()
  local fs = vim.v.foldstart
  local fe = vim.v.foldend
  local line = vim.api.nvim_buf_get_lines(0, fs - 1, fs, false)[1]

  -- Clean up trailing open structures for a sleeker look
  line = line:gsub("%s*{%s*$", " { ... }")
  line = line:gsub("%s*%(%s*$", " ( ... )") -- Fixed a tiny syntax escape typo here from the last snippet!

  local fold_lines = fe - fs + 1
  local count_text = string.format(" [%d lines]", fold_lines)

  local prefix = "+-- "
  local padding = " --- "

  return prefix .. line .. " " .. padding .. count_text
end

-- Your centralized FileType hook for Go
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function(args)
    -- 1. Boot up the native Tree-sitter engine for this buffer
    vim.treesitter.start(args.buf, "go")

    -- 2. Bind the folding expressions locally to this window
    vim.wo.foldmethod = "expr"
    vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"

    -- 3. Set the custom visual layout ONLY for this Go window
    vim.wo.foldtext = "v:lua.custom_go_foldtext()"
  end,
})
