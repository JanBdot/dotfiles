local M = {}

-- TODO think about implementing UI
-- M.ui = { theme = 'catppuccin' }
M.lazy = require "custom.lazy"
-- telescope is a fuzzy finder
M.telescope = require "custom.telescope"
-- treesitter is for highlighting
M.treesitter = require "custom.treesitter"
-- lsp config
M.lsp = require "custom.lsp"
-- completion engine
M.cmp = require "custom.cmp"
M.settings = require "custom.settings"
M.mappings = require "custom.mappings"
M.cmake = require "custom.configs.cmake"

return M
