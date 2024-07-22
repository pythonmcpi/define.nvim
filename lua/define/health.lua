local main = require("define")

local M = {}

function M.check()
    vim.health.start("define.nvim")

    local ok, curl = pcall(require, "plenary.curl")

    if ok then
        vim.health.ok("pelnary.curl is available")

        vim.health.info("attempting to contact api")

        local api_ok, resp = pcall(main.getDefinition, "hello")

        if api_ok then
            vim.health.ok("api is reachable")
        else
            vim.health.error("api was not reachable")
        end
    else
        vim.health.error("plenary.curl is missing", {"Install https://github.com/nvim-lua/plenary.nvim"})
    end
end

return M

