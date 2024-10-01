return {
    "nvim-pack/nvim-spectre",
    config = function()
        require("spectre").setup({
            is_insert_mode = false, -- Don't start in insert mode
            cwd = vim.fn.getcwd(), -- Automatically use the current working directory
            default = { is_regex = false, ignore_case = false },
        })
    end,
}
