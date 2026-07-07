local M = {}

local palette = require("standard-themes.palette")

M.setup = function()
    vim.api.nvim_command("hi clear")
    if vim.fn.exists("syntax_on") then
        vim.api.nvim_command("syntax reset")
    end


    local highlights = {
        -- base neovim highlight groups
        Normal = { fg = palette.colors.fg, bg = palette.colors.bg },
        Comment = { fg = palette.colors.comment },
        Constant = { fg = palette.colors.constant },
        String = { fg = palette.colors.string },
        Character = { fg = palette.colors.string },
        Identifier = { fg = palette.colors.variable},
        Function = { fg = palette.colors.fnname },
        Type = { fg = palette.colors.type },
        Structure = { fg = palette.colors.keyword },
        Typedef = { fg = palette.colors.keyword },
        StorageClass = { fg = palette.colors.keyword },
        PreProc = { fg = palette.colors.preprocessor },
        Include = { fg = palette.colors.preprocessor },
        Define = { fg = palette.colors.preprocessor },
        Macro = { fg = palette.colors.preprocessor },
        PreCondit = { fg = palette.colors.preprocessor },
        Keyword = { fg = palette.colors.keyword, bold = true },
        Underlined = { fg = palette.colors.fg_link },
        Special = { fg = palette.colors.green },
        SpecialChar = { fg = palette.colors.green },
        Dimmed = { fg = palette.colors.fg_dim },
        Error = { fg = palette.colors.error },
        Delimiter = { fg = palette.colors.fg_main },

        -- treesitter
        ["@annotation"] = { fg = palette.colors.preprocessor },
        ["@attribute"] = { fg = palette.colors.preprocessor },
        ["@annotation"] = { fg = palette.colors.preprocessor },
        ["@constant.builtin"] = { fg = palette.colors.fg_main },
        ["@keyword"] = { fg = palette.colors.keyword },
        ["@keyword.import"] = { fg = palette.colors.preprocessor },
        ["@keyword.directive"] = { fg = palette.colors.preprocessor },
        ["@type"] = { fg = palette.colors.type },
        ["@type.definition"] = { fg = palette.colors.keyword },
        ["@type.builtin"] = { fg = palette.colors.type },
        ["@string.escape"] = { fg = palette.colors.green },
        ["@variable"] = { fg = palette.colors.variable },
        ["@variable.builtin"] = { fg = palette.colors.variable },
        ["@variable.member"] = { fg = palette.colors.variable },
        ["@variable.parameter"] = { fg = palette.colors.variable },
        ["@punctuation.special"] = { fg = palette.colors.green },
        ["@punctuation.special.markdown"] = { fg = palette.colors.green }
        }

    for group, opts in pairs(highlights) do
        vim.api.nvim_set_hl(0, group, opts)
    end
end

return M
