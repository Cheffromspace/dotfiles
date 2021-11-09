
--[[
-- vim.lsp.set_log_level("debug")
lvim is the global options object

Linters should be
filled in as strings with either
a global executable or a path to
an executable
]]
-- THESE ARE EXAMPLE CONFIGS FEEL FREE TO CHANGE TO WHATEVER YOU WANT

-- general
vim.opt.dictionary:append("/usr/share/dict/words")
lvim.log.level = "warn"
lvim.format_on_save = true
lvim.colorscheme = "tokyonight"

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = "space"
-- add your own keymapping
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
-- lvim.keys.normal_mode["<leader>,"] = ':lua require"nvim-sfdx"<cr>'
-- unmap a default keymapping
-- lvim.keys.normal_mode["<C-Up>"] = ""
-- edit a default keymapping
-- lvim.keys.normal_mode["<C-q>"] = ":q<cr>"

-- Change Telescope navigation to use j and k for navigation and n and p for history in both input and normal mode.
-- lvim.builtin.telescope.on_config_done = function()
--   local actions = require "telescope.actions"
--   -- for input mode
--   lvim.builtin.telescope.defaults.mappings.i["<C-j>"] = actions.move_selection_next
--   lvim.builtin.telescope.defaults.mappings.i["<C-k>"] = actions.move_selection_previous
--   lvim.builtin.telescope.defaults.mappings.i["<C-n>"] = actions.cycle_history_next
--   lvim.builtin.telescope.defaults.mappings.i["<C-p>"] = actions.cycle_history_prev
--   -- for normal mode
--   lvim.builtin.telescope.defaults.mappings.n["<C-j>"] = actions.move_selection_next
--   lvim.builtin.telescope.defaults.mappings.n["<C-k>"] = actions.move_selection_previous
-- end

-- Use which-key to add extra bindings with the leader-key prefix
-- lvim.builtin.which_key.mappings["P"] = { "<cmd>Telescope projects<CR>", "Projects" }
lvim.builtin.which_key.mappings["t"] = {
  name = "+Trouble",
  r = { "<cmd>Trouble lsp_references<cr>", "References" },
  f = { "<cmd>Trouble lsp_definitions<cr>", "Definitions" },
  d = { "<cmd>Trouble lsp_document_diagnostics<cr>", "Diagnostics" },
  q = { "<cmd>Trouble quickfix<cr>", "QuickFix" },
  l = { "<cmd>Trouble loclist<cr>", "LocationList" },
  w = { "<cmd>Trouble lsp_workspace_diagnostics<cr>", "Diagnostics" },
}

lvim.builtin.which_key.mappings["j"] = {
  name = "Harpoon",
  a = {'<cmd>lua require("harpoon.mark").add_file()<cr>', 'add file'},
  m = {':lua require("harpoon.ui").toggle_quick_menu()<cr>', 'toggle menu'},
  h = {':lua require("harpoon.ui").nav_file(1)<cr>', 'Index 1'},
  j = {':lua require("harpoon.ui").nav_file(2)<cr>', 'Index 2'},
  k = {':lua require("harpoon.ui").nav_file(3)<cr>', 'Index 3'},
  l = {':lua require("harpoon.ui").nav_file(4)<cr>', 'Index 4'}
}



-- TODO: User Config for predefined plugins
-- After changing plugin config exit and reopen LunarVim, Run :PackerInstall :PackerCompile
lvim.builtin.dashboard.active = true
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.show_icons.git = 0



-- if you don't want all the parsers change this to a table of the ones you want
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "javascript",
  "json",
  "lua",
  "python",
  "typescript",
  "css",
  "rust",
  "java",
  "yaml"
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enabled = true

lvim.builtin.cmp.sources = {
  {name = "nvim_lsp"},
  {name = "nvim_lua"},
  {name = "path"},
  {name = "luasnip"},
  {name = "buffer", keyword_length = 4 },
{name = "dictionary", keyword_length = 4 }
}



lvim.builtin.cmp.experimental = {
  native_menu = false,
  ghost_menu = true
}
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup({{exe = "prettier", filetypes = {"apex"} }})
lvim.format_on_save = true

local lspconfig = require'lspconfig'
local configs = require'lspconfig/configs'
local apexCmd = { '/usr/bin/java','-cp', '/home/jonflatt/languageServers/Apex/apex-jorje-lsp.jar', '-Ddebug.internal.errors=true', 'apex.jorje.lsp.ApexLanguageServerLauncher' }
-- Check if it's already defined for when reloading this file.
if not lspconfig.apexls then
  configs.apexls = {
    default_config = {
      cmd = apexCmd,
      filetypes = {'apex'},
      root_dir = require("lspconfig/util").root_pattern(".git", "package.json"),
      on_attach = require("lvim.lsp").common_on_attach,
      on_init = require("lvim.lsp").common_on_init,
      capabilities = require("lvim.lsp").common_capabilities(),
      formatters = { exe = 'prettier'},
      settings = {}
    }
  }
end
lspconfig.apexls.setup{}

--Powershel LSP
lspconfig.powershell_es.setup{
  bundle_path = '/home/jonflatt/languageServers/Powershell',
}
--Powershell treesitter
local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.java.used_by = "apex"
-- parser_config.powershell = {
--   install_info = {
--     url = "https://github.com/jrsconfitto/tree-sitter-powershell",
--     files = {"src/parser.c"}
--   },
--   filetype = "ps1",
--   used_by = { "psm1", "psd1", "pssc", "psxml", "cdxml" }
-- }

-- local query = vim.treesitter.parse_query('java', [[
--   -- (method_declaratio
--   --   (modifiers
--   --     (marker_annotation
--   --       name: (identifier) @annotation
--   --         (#match? @annotation "^[iI][sS][tT][eE][sS][tT]$")))
--   --   name: (identifier) @method (#offset! @method))
--   -- ]])
-- parser_config.apex = {
--   install_info = {
--     url = "~/source/tree-sitter-apex/",
--     files = {"src/parser.c"}
--   },
--   filetype = "apex",
--   used_by = { "apex" }
-- }
-- parser_config.java.used_by = {'apex'}

-- parser_config.java.used_by = "apex"

-- Additional Plugins
lvim.plugins = {
  {'chrisbra/csv.vim'},
  {'airblade/vim-gitgutter'},
  {'nvim-treesitter/playground'},
  {'folke/tokyonight.nvim'},
  {'folke/trouble.nvim'},
  {'ThePrimeagen/harpoon'},
  {'uga-rosa/cmp-dictionary'}
  -- {'github/copilot.vim'}
}

-- lvim.keys.insert_mode['<right>'] = '<cmd>lua nvim_exec(copilot#Accept())<cr>'

-- vim.api.nvim_exec([[
--   imap <script><silent><nowait><expr> <right> <cmd> copilot#Accept()
-- ]])
-- <script><silent><nowait><expr> <Tab> copilot#Accept()
--Autocommands (https://neovim.io/doc/user/autocmd.html)
lvim.autocommands.custom_groups = {
  { "BufWinEnter", "*.cls", "setlocal tabstop=4 softtabstop=4 shiftwidth=4 cindent"}
}
