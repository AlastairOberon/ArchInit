return {
    {
        "benlubas/molten-nvim",
        version = "^1.0.0", -- use version <2.0.0 to avoid breaking changes
        dependencies = { "3rd/image.nvim" },
        build = ":UpdateRemotePlugins",

        init = function()
            -- Molten config
            vim.g.molten_image_provider = "image.nvim"
            vim.g.molten_output_win_max_height = 20

            -- REQUIRED for molten to load its commands:
            vim.g.python3_host_prog =
                "/home/alastair_oberon/Shenanigans/Coding_shenanigans/Juplab_env/.venv/bin/python3"
        end,
    },
}

