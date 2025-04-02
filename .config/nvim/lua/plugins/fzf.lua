if true then
    return {}
end
return {
    "ibhagwan/fzf-lua",
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- optional for file icons
    config = function()
        require("fzf-lua").setup({})
    end,
}
