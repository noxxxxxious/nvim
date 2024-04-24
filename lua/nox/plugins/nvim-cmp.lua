return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-buffer", -- source for text in buffer
		"hrsh7th/cmp-path", -- source for file system paths
		"hrsh7th/cmp-nvim-lsp", -- adds lsp completion capabilities
		"onsails/lspkind.nvim", -- add vscode-like pictograms to nvim built-in lsp
		"L3MON4D3/LuaSnip", -- snippet engine
		"saadparwaiz1/cmp_luasnip", -- for autocompletion
		"rafamadriz/friendly-snippets", -- useful snippets
		"Saecki/crates.nvim", -- crates.io dependencies
		"David-Kunz/cmp-npm", -- npm dependencies
	},
	config = function()
    -- See `:help cmp`
    local cmp = require 'cmp'
    local luasnip = require 'luasnip'
		local lspkind = require("lspkind")
    luasnip.config.setup {}
		-- load vs-code like snippets from plugins (e.g. friendly-snippets)
		require("luasnip.loaders.from_vscode").lazy_load()

    cmp.setup {
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },
      completion = { completeopt = 'menu,menuone,noinsert' },

      -- For an understanding of why these mappings were
      -- chosen, you will need to read `:help ins-completion`
      --
      -- No, but seriously. Please read `:help ins-completion`, it is really good!
      mapping = cmp.mapping.preset.insert {
        -- Select the [n]ext item
        ['<C-n>'] = cmp.mapping.select_next_item(),
        -- Select the [p]revious item
        ['<C-p>'] = cmp.mapping.select_prev_item(),

        -- Scroll the documentation window [b]ack / [f]orward
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),

        -- Accept ([y]es) the completion.
        --  This will auto-import if your LSP supports it.
        --  This will expand snippets if the LSP sent a snippet.
        ['<C-y>'] = cmp.mapping.confirm { select = true },
				["<CR>"] = cmp.mapping.confirm({ select = false }),

        -- Manually trigger a completion from nvim-cmp.
        --  Generally you don't need this, because nvim-cmp will display
        --  completions whenever it has completion options available.
        ['<C-Space>'] = cmp.mapping.complete {},

        -- Think of <c-l> as moving to the right of your snippet expansion.
        --  So if you have a snippet that's like:
        --  function $name($args)
        --    $body
        --  end
        --
        -- <c-l> will move you to the right of each of the expansion locations.
        -- <c-h> is similar, except moving you backwards.
        ['<C-l>'] = cmp.mapping(function()
          if luasnip.expand_or_locally_jumpable() then
            luasnip.expand_or_jump()
          end
        end, { 'i', 's' }),
        ['<C-h>'] = cmp.mapping(function()
          if luasnip.locally_jumpable(-1) then
            luasnip.jump(-1)
          end
        end, { 'i', 's' }),

        -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
        --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
      },
      sources = {
				{ name = "nvim_lsp" }, -- lsp
				{ name = "luasnip" }, -- snippets
				{ name = "buffer" }, -- text within current buffer
				{ name = "path" }, -- file system paths
      },
    }
		local fmt = require'luasnip.extras.fmt'.fmt
		-- custom snippets 
		luasnip.add_snippets(nil, {
			vue = {
				luasnip.s("noxvue", fmt("<template>\n\t<div>\n\t\t{}\n\t</div>\n</template>\n\n<script setup lang='ts'>\n\t{}\n</script>\n\n<style scoped>\n\t{}\n</style>\n", {
					luasnip.insert_node(1),
					luasnip.insert_node(2),
					luasnip.insert_node(3)
				}))
			},
		})
  end,
}
