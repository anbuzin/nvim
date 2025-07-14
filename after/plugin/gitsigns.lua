vim.keymap.set("n", "<leader>hq", function() require("gitsigns").setqflist("all") end,
    { desc = "Load all [H]unks to [Q]uickfix" })

