return {
  {
	"stevearc/dressing.nvim",
	init = function()
		---@diagnostic disable-next-line: duplicate-set-field
		vim.ui.select = function(...)
			require("lazy").load({ plugins = { "dressing.nvim" } })
			return vim.ui.select(...)
		end
		---@diagnostic disable-next-line: duplicate-set-field
		vim.ui.input = function(...)
			require("lazy").load({ plugins = { "dressing.nvim" } })
			return vim.ui.input(...)
		end
  end},

  { "nvzone/volt", lazy = true },

  {
    "nvzone/minty",
    cmd = { "Shades", "Huefy" },
  },

  {
    {
        "nvim-tree/nvim-tree.lua",
        opts = function(_, opts)
            opts.filters = {
                dotfiles = true, -- Enable hiding dotfiles
            }
            return opts
        end,
    },
  },
  {
    "codota/tabnine-nvim",
    build = "./dl_binaries.sh", -- This ensures binaries are downloaded during setup
    lazy = false,              -- Load it immediately on startup (set to true if lazy loading is desired)
    config = function()
      require('tabnine').setup({
        disable_auto_comment = true,
        accept_keymap = "<S-Tab>",
        dismiss_keymap = "<C-]>",
        debounce_ms = 800,
        suggestion_color = { gui = "#808080", cterm = 244 },
        exclude_filetypes = { "TelescopePrompt" },
      })
    end,
  },
}
