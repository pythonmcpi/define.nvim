-- Based on https://stackoverflow.com/a/75240496

local buffer_number = -1

local function display(data)
    if data then
        -- Make buffer writable
        vim.api.nvim_buf_set_option(buffer_number, "readonly", false)

        -- Append data
        vim.api.nvim_buf_set_lines(buffer_number, -1, -1, true, data)

        -- Make buffer readonly
        vim.api.nvim_buf_set_option(buffer_number, "readonly", true)

        -- Mark buffer as not modified so there's no need to save when exiting
        vim.api.nvim_buf_set_option(buffer_number, "modified", false)
    end
end

local function open_buffer(name)
    -- Check if the buffer number is still visible
    local buffer_visible = vim.api.nvim_call_function("bufwinnr", { buffer_number })

    if buffer_number == -1 or not buffer_visible then
        -- Create new buffer
        vim.api.nvim_command("botright vsplit " .. name)

        buffer_number = vim.api.nvim_get_current_buf()

        -- Mark buffer readonly
        vim.opt_local.readonly = true
    end
end

local function set_buffer(lines)
    if buffer_number == -1 then return end

    vim.api.nvim_buf_set_option(buffer_number, "readonly", false)
    vim.api.nvim_buf_set_lines(buffer_number, 0, -1, true, lines)
    vim.api.nvim_buf_set_option(buffer_number, "readonly", true)
    vim.api.nvim_buf_set_option(buffer_number, "modified", false)
end

local function clear_buffer()
    set_buffer({})
end

return {
    display = display,
    open_buffer = open_buffer,
    clear_buffer = clear_buffer,
    set_buffer = set_buffer,
}

