return {
    "kawre/leetcode.nvim",
    build = ":TSUpdate html",
    dependencies = {
        "nvim-telescope/telescope.nvim",
        "nvim-lua/plenary.nvim", -- required by telescope
        "MunifTanjim/nui.nvim",
        "nvim-tree/nvim-web-devicons",
    },
    opts = {
        -- configuration goes here
        lang = "javascript",
        image_support = false,
        max_width_window_percentage = 100,
        window_overlap_clear_enabled = true,
    },
}
