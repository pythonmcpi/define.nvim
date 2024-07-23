-- Originallu based on https://stackoverflow.com/a/75240496

local buffer_number = -1

local function display(data)
    if data then
        vim.api.nvim_buf_set_option(buffer_number, "readonly", false)

        -- Append instead of overwrite
        vim.api.nvim_buf_set_lines(buffer_number, -1, -1, true, data)

        vim.api.nvim_buf_set_option(buffer_number, "readonly", true)

        -- Modification flag is never set when buftype = "nofile"
    end
end

local function open_buffer(name)
    -- Check if the buffer number is still visible
    local buffer_visible = vim.api.nvim_call_function("bufwinnr", { buffer_number })

    if buffer_number == -1 or buffer_visible == -1 then
        -- Check aspect ratio of current window
        local ratio = vim.o.columns / vim.o.lines

        if ratio < 3 then
            -- New buffer on bottom
            vim.api.nvim_command("botright split " .. name)
        else
            -- New buffer on the right
            vim.api.nvim_command("botright vsplit " .. name)
        end

        buffer_number = vim.api.nvim_get_current_buf()

        -- Set buffer flags
        vim.opt_local.readonly = true
        vim.opt_local.buftype = "nofile"
        vim.opt_local.bufhidden = "hide"
        vim.opt_local.buflisted = false
        vim.opt_local.swapfile = false
    end
end

local function set_buffer(lines)
    if buffer_number == -1 then return end

    vim.api.nvim_buf_set_option(buffer_number, "readonly", false)
    vim.api.nvim_buf_set_lines(buffer_number, 0, -1, true, lines)
    vim.api.nvim_buf_set_option(buffer_number, "readonly", true)
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

