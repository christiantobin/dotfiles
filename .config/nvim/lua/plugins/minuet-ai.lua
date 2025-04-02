if true then
    return {}
end
return {
    {
        "milanglacier/minuet-ai.nvim",
        config = function()
            require("minuet").setup({
                provider = "openai_fim_compatible",
                n_completions = 1, -- recommend for local model for resource saving
                -- I recommend beginning with a small context window size and incrementally
                -- expanding it, depending on your local computing power. A context window
                -- of 512, serves as an good starting point to estimate your computing
                -- power. Once you have a reliable estimate of your local computing power,
                -- you should adjust the context window to a larger value.
                context_window = 512,
                provider_options = {
                    openai_fim_compatible = {
                        api_key = "TERM",
                        name = "Ollama",
                        end_point = "http://localhost:11434/v1/completions",
                        model = "qwen2.5-coder:0.5b",
                        optional = {
                            max_tokens = 512,
                            top_p = 0.9,
                        },
                    },
                },
                virtualtext = {
                    auto_trigger_ft = { "*" },
                },
            })
        end,
    },
    {
        "nvim-cmp",
        optional = true,
        opts = function(_, opts)
            -- if you wish to use autocomplete
            table.insert(opts.sources, 1, {
                name = "minuet",
                group_index = 1,
                priority = 100,
            })

            opts.performance = {
                -- It is recommended to increase the timeout duration due to
                -- the typically slower response speed of LLMs compared to
                -- other completion sources. This is not needed when you only
                -- need manual completion.
                fetching_timeout = 2000,
            }

            opts.mapping = vim.tbl_deep_extend("force", opts.mapping or {}, {
                -- if you wish to use manual complete
                ["<leader>a"] = require("minuet").make_cmp_map(),
            })
        end,
    },
    { "nvim-lua/plenary.nvim" },
    { "Saghen/blink.cmp" },
}
