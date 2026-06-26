-- TODO treesitter?
-- treesitter text objects for better jumping
-- neorg?
-- lualine or anther status line?
-- lsp if needed
-- git / gitsigns / dap / cmp
-- comments
-- Create an autocmd group for hot-reloading
local reload_group = vim.api.nvim_create_augroup("ConfigReload", { clear = true })

vim.api.nvim_create_autocmd("BufWritePost", {
  group = reload_group,
  -- Trigger only when files inside your nvim config directory are saved
  pattern = vim.fn.stdpath("config") .. "/*.lua", 
  callback = function()
    -- Clear cache for all modules belonging to your config
    -- (Assumes your custom modules are structured in a 'user' or sub-folder)
    for name, _ in pairs(package.loaded) do
      if name:match("^user%.") or name:match("^config%.") then
        package.loaded[name] = nil
      end
    end

    -- Source the main configuration file again
    dofile(vim.env.MYVIMRC)
    vim.notify("Neovim configuration reloaded!", vim.log.levels.INFO)
  end,
})

-- OPTIONS
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.backup = false                          -- creates a backup file
vim.opt.clipboard = "unnamedplus"               -- allows neovim to access the system clipboard
vim.opt.cmdheight = 1                           -- more space in the neovim command line for displaying messages
vim.opt.fileencoding = "utf-8"                  -- the encoding written to a file
vim.opt.hlsearch = true                         -- highlight all matches on previous search pattern
vim.opt.ignorecase = true                       -- ignore case in search patterns
vim.opt.showmode = false                        -- we don't need to see things like -- INSERT -- anymore
vim.opt.showtabline = 0                         -- always show tabs
vim.opt.smartcase = true                        -- smart case
vim.opt.smartindent = true                      -- make indenting smarter again
vim.opt.splitbelow = true                       -- force all horizontal splits to go below current window
vim.opt.splitright = true                       -- force all vertical splits to go to the right of current window
vim.opt.swapfile = true                         -- creates a swapfile
vim.opt.termguicolors = true                    -- set term gui colors (most terminals support this)
vim.opt.timeoutlen = 1000                       -- time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.undofile = true                         -- enable persistent undo
vim.opt.undodir = vim.fn.stdpath("data") .. "/undo"
vim.opt.updatetime = 300                        -- faster completion (4000ms default)
vim.opt.writebackup = false                     -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
vim.opt.expandtab = true                        -- convert tabs to spaces
vim.opt.shiftwidth = 2                          -- the number of spaces inserted for each indentation
vim.opt.tabstop = 2                             -- insert 2 spaces for a tab
vim.opt.cursorline = true                       -- highlight the current line
vim.opt.relativenumber = true                   -- set relative numbering for lines lines
vim.opt.number = true                           -- set numbered line for current line
vim.opt.laststatus = 3
vim.opt.showcmd = false
vim.opt.ruler = false
vim.opt.numberwidth = 4                         -- set number column width to 2 {default 4}
vim.opt.signcolumn = "yes"                      -- always show the sign column, otherwise it would shift the text each time
vim.opt.foldcolumn = "auto"
vim.opt.wrap = false                            -- display lines as one long line
vim.opt.scrolloff = 8                           -- is one of my fav
vim.opt.sidescrolloff = 8
vim.opt.whichwrap:append("<,>,[,],h,l")
vim.opt.iskeyword:append("-")
vim.opt.spelllang = "en_us"
vim.opt.spell = true
vim.o.winborder = "rounded"

-- PLUGINS
vim.pack.add {
  { src = "https://github.com/catppuccin/nvim", name = "catppuccin"},
  "https://github.com/nvim-mini/mini.icons",
  "https://github.com/folke/snacks.nvim",
  "https://github.com/folke/which-key.nvim",
  "https://github.com/lewis6991/gitsigns.nvim",
  "https://github.com/mfussenegger/nvim-dap",
  "https://github.com/nvim-neotest/nvim-nio",
  "https://github.com/rcarriga/nvim-dap-ui",
  "https://github.com/leoluz/nvim-dap-go",
}

vim.cmd.colorscheme "catppuccin-mocha"
require('mini.icons').setup()
-- Plugin settings in separate files
local Snacks = require('snacks')
Snacks.setup({
  -- bigfile
  -- bufdelete
  -- dashboard
  -- gitbrowse
  -- input/select
  lazygit = {
    enabled = true,
    -- Automatically configure integrated colorscheme matching your editor
    configure = true,
  },
  blame = {
    enabled = true,
    width = 35, -- Keeps the text bounded nicely
  },
  -- notifier
  -- terminal
  -- rename
  picker = {
    enabled = true ,
    sources = {
      undo = {
        preview = "diff_delta",
      },
    },
  },
})

local gs = require("gitsigns")
gs.setup({
  current_line_blame = false, -- Set to true if you want it always on by default
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol', -- Blame appears at the end of the line
    delay = 50,           -- Half a second hover pause before showing
  },
})

-- KEYMAPS
-- Shorten function name
local keymap = vim.keymap.set
-- Silent keymap option
local opts = { silent = true }

local wk = require("which-key")

-- Optional: Call setup first if you want to pass global options
-- wk.setup({
  -- your which-key configurations (icons, layout, etc.)
-- })

wk.add({
  { "<leader>f", group = "Find..." },
  { "<leader>g", group = "Git..." },
  { "<leader>s", group = "Split..." },
  { "<leader>y", group = "Yank..." },
  { "<leader>c", group = "Code actions..." },
  { "<leader>d", group = "Debug..." },
  { "<leader>du", group = "Debug UI..." },
})

-- Snacks.picker
keymap("n", "<leader>e", function() Snacks.picker.explorer() end, { desc = "Open file Explorer"})
keymap("n", "<leader>fb", function() Snacks.picker.buffers() end, { desc = "Find Buffers"})
keymap("n", "<leader>fd", function() Snacks.picker.diagnostics() end, { desc = "Find Diagnostics"})
keymap("n", "<leader>ff", function() Snacks.picker.files() end, { desc = "Find Files"})
keymap("n", "<leader>fgb", function() Snacks.picker.git_log_line() end, { desc = "Find Git Blame"})
keymap("n", "<leader>fgd", function() Snacks.picker.git_diff() end, { desc = "Find Git Diff"}) -- 1. Snacks.picker.git_diff({ base = "origin" })
keymap("n", "<leader>fgl", function() Snacks.picker.git_log() end, { desc = "Find Git Log"})
keymap("n", "<leader>fgs", function() Snacks.picker.git_status() end, { desc = "Find Git Status"})
keymap("n", "<leader>fh", function() Snacks.picker.help() end, { desc = "Find Help"})
keymap("n", "<leader>fj", function() Snacks.picker.jumps() end, { desc = "Find Jumplist"})
keymap("n", "<leader>fl", function() Snacks.picker.lines() end, { desc = "Find Lines"})
keymap("n", "<leader>fm", function() Snacks.picker.marks() end, { desc = "Find marks"})
keymap("n", "<leader>fn", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, { desc = "Find neovim files"})
keymap("n", "<leader>fp", function() Snacks.picker.resume() end, { desc = "Open last picker (find picker)"})
keymap("n", "<leader>fq", function() Snacks.picker.qflist() end, { desc = "Find quickfix"})
keymap("n", "<leader>fr", function() Snacks.picker.recent() end, { desc = "Find Recent files"})
keymap("n", "<leader>ft", function() Snacks.picker.grep() end, { desc = "Find Text (rg)"})
keymap("n", "<leader>u", function() Snacks.picker.undo() end, { desc = "Undo tree"})
-- 1. Full Git TUI Panel (Commit, Push, History, Dynamic File Diffs)
keymap("n", "<leader>gg", function() Snacks.lazygit.open() end, { desc = "Lazygit TUI" })
keymap("n", "<leader>gh", function() Snacks.lazygit.log() end, { desc = "Git History (Current Repo)" })

keymap('n', '<leader>gb', gs.toggle_current_line_blame, { desc = "Toggle Git Blame Virtual Text" })
keymap('n', '<leader>gs', gs.toggle_signs, { desc = "Toggle Gutter Change Signs" })


-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", { desc = "Resize -2" })
keymap("n", "<C-Down>", ":resize +2<CR>", { desc = "Resize +2" })
keymap("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Vertical resize -2" })
keymap("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Vertical resize +2" })


-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Center on jump
keymap("n", "C-d>", "<C-d>zz")
keymap("n", "C-u>", "<C-u>zz")
keymap("n", "n", "nzzzv")
keymap("n", "N", "Nzzzv")

-- Clear highlights
keymap("n", "<leader>h", "<cmd>nohlsearch<CR>", { desc = "hide search highlight" })
keymap("n", "<leader><Enter>", "<cmd>nohlsearch<CR>", { desc = "hide search highlight" })
-- Better paste
keymap("v", "p", '"_dP', opts)

-- Insert --
-- Press jk fast to enter
keymap("i", "jk", "<ESC>", opts)
keymap("t", "jk", "<ESC>", opts)

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- splits
keymap("n", "<leader>sh", "<cmd>split<CR>", { desc = "Horizontal" })
keymap("n", "<leader>sv", "<cmd>vsplit<CR>", { desc = "Vertical" })
keymap("n", "<leader>so", "<cmd>only<CR>", { desc = "Only" })

-- copy filepath
function copyPath()
  local filepath = vim.fn.expand('%')
  vim.fn.setreg("+", filepath)
end
keymap("n", "<leader>yf", copyPath, { noremap = true, silent = true, desc = "copy full filepath" })


-- AUTOCMD
vim.cmd([[autocmd BufRead,BufNewFile *.cypher setfiletype cypher]])
-- Create an autocmd to spawn/attach LSP when opening relevant filetypes
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "go", "gomod", "lua" },
  callback = function(args)
    local bufnr = args.buf
    local ft = vim.bo[bufnr].filetype

    -- 1. Configuration for Go (gopls)
    if ft == "go" or ft == "gomod" then
      -- 1. Explicitly boot up the native Tree-sitter engine for this buffer
      vim.treesitter.start(bufnr, "go")

      -- 2. Bind the folding expressions locally to this window
      vim.wo.foldmethod = "expr"
      vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
      vim.lsp.start({
        name = "gopls",
        cmd = { "gopls" },
        root_dir = vim.fs.root(bufnr, { "go.work", "go.mod", ".git" }),
        settings = {
          gopls = {
            analyses = { unusedparams = true, shadow = true },
            staticcheck = true,
            completeUnimported = true,
            usePlaceholders = true,
          },
        },
      })

    -- 2. Configuration for Lua (lua-language-server)
    elseif ft == "lua" then
      vim.lsp.start({
        name = "lua-language-server",
        cmd = { "/home/jsm/src/language_servers/lua/bin/lua-language-server" },
        root_dir = vim.fs.root(bufnr, { ".luarc.json", ".luarc.jsonc", ".git" }),
        settings = {
          Lua = {
            runtime = { version = "LuaJIT" },
            diagnostics = { globals = { "vim" } }, -- Stop "Undefined global 'vim'" warnings
            workspace = {
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false,
            },
            telemetry = { enabled = false },
          },
        },
      })

    -- 3. Configuration for Neo4j Cypher
    elseif ft == "cypher" then
      vim.lsp.start({
        name = "cypher_ls",
        cmd = { "cypher-language-server", "--stdio" },
        -- Fall back to current file directory if no .git root is found
        root_dir = vim.fs.root(bufnr, { ".git" }) or vim.fn.expand("%:p:h"),
        settings = {},
      })

    end
  end,
})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf

    local map = function(keys, func, desc)
      vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
    end

    -- Swapping native goto commands for beautiful snacks.picker windows
    map("gd", function() Snacks.picker.lsp_definitions() end, "Definition")
    map("gD", function() Snacks.picker.lsp_declarations() end, "Declaration")
    map("gr", function() Snacks.picker.lsp_references() end, "References")
    map("gi", function() Snacks.picker.lsp_implementations() end, "Implementation")
    map("gt", function() Snacks.picker.lsp_type_definitions() end, "Type Definition")

    -- Symbol digging (Great for navigating massive Go packages or Lua setups)
    map("gs", function() Snacks.picker.lsp_symbols() end, "Document Symbols")
    map("gS", function() Snacks.picker.lsp_workspace_symbols() end, "Workspace Symbols")

    -- Keep your non-picker standard utilities intact
    map("K", vim.lsp.buf.hover, "Hover Documentation")
    map("<leader>r", vim.lsp.buf.rename, "Rename Symbol")
    map("<leader>ca", vim.lsp.buf.code_action, "Code Action")
  end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking text",
  group = vim.api.nvim_create_augroup("jsm-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.go",
  callback = function()
    vim.lsp.buf.format()
  end
})
