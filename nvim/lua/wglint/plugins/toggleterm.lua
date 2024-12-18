return {
	-- ... vos autres plugins
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		config = function()
			require("toggleterm").setup({
				-- personnalisez ici si nécessaire
				size = 20,
				open_mapping = [[<c-t>]], -- Raccourci pour ouvrir/fermer le terminal
				shade_filetypes = {},
				shade_terminals = true,
				shading_factor = 2,
				direction = "horizontal", -- options: 'vertical' | 'horizontal' | 'tab' | 'float'
				float_opts = {
					border = "curved",
				},
			})
		end,
	},
}
