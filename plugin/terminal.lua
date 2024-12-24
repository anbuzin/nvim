local state = {
    floating = {
        buf = -1,
        win = -1,
    },
}

local function create_floating_win(opts)
    opts = opts or {}

    local width = opts.width or math.floor(vim.o.columns * 0.8)
    local height = opts.height or math.floor(vim.o.lines * 0.8)

    local col = math.floor((vim.o.columns - width) / 2)
    local row = opts.row or math.floor((vim.o.lines - height) / 2)

    local buf = nil

    if vim.api.nvim_buf_is_valid(opts.buf) then
        buf = opts.buf
    else
        buf = vim.api.nvim_create_buf(false, true) -- no file scratch buffer
    end

    local config = {
        relative = "editor",
        width = width,
        height = height,
        col = col,
        row = row,
        style = "minimal",
        border = "rounded",
    }

    local win = vim.api.nvim_open_win(buf, true, config)
    return { buf = buf, win = win }
end


local toggle_terminal = function(size)
    local width = nil
    local height = nil
    local row = nil

    if size == "small" then
        width = math.floor(vim.o.columns * 0.9)
        height = math.floor(vim.o.lines * 0.2)
        row = vim.o.lines - height
    end
    if not vim.api.nvim_win_is_valid(state.floating.win) then
        state.floating = create_floating_win { buf = state.floating.buf, width = width, height = height, row = row }
        if vim.bo[state.floating.buf].buftype ~= "terminal" then
            vim.cmd.terminal()
        end
    else
        vim.api.nvim_win_hide(state.floating.win)
    end
end

vim.keymap.set({ "n", "t" }, "<leader>tt", function() toggle_terminal() end, { desc = "[T]oggle floating [T]erminal" })
vim.keymap.set({ "n", "t" }, "<leader>st", function() toggle_terminal("small") end,
    { desc = "Toggle [S]mall floating [T]erminal" })

vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit to normal mode in terminal" })
