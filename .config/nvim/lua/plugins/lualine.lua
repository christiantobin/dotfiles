return {
    "nvim-lualine/lualine.nvim",
    opts = function()
        return {
            options = {
                icons_enabled = true,
                theme = "auto", -- You can change this to any lualine-supported theme
                component_separators = { left = "", right = "" },
                section_separators = { left = "", right = "" },
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch", "diff", "diagnostics" },
                lualine_c = { "filename" },
                lualine_x = { "encoding", "fileformat", "filetype" },
                lualine_y = { "location" },
                -- Custom 12-hour time format with AM/PM in lualine_z
                lualine_z = {
                    {
                        function()
                            return os.date("%I:%M %p") -- 12-hour format with AM/PM
                        end,
                        icon = "", -- Optional clock icon
                    },
                },
            },
            inactive_sections = {
                lualine_a = {},
                lualine_b = {},
                lualine_c = { "filename" },
                lualine_x = { "location" },
                lualine_y = {},
                lualine_z = {},
            },
            tabline = {},
            extensions = {},
        }
    end,
}
