return {
    {
        "iamcco/markdown-preview.nvim",
        build = function()
            vim.fn["mkdp#util#install"]()
        end,
        ft = { "markdown" },
        config = function()
            -- Add any specific configuration if needed
        end,
    },
}
