vim.cmd("hi clear")
if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
end

require("standard-themes").setup()

vim.g.colors_name = "standard-themes"
