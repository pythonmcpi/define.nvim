local bufhelper = require "define.bufhelper"
local curl = require "plenary.curl"

local API_BASE = "https://api.dictionaryapi.dev/api/v2/"
-- The API can be selfhosted: https://github.com/meetDeveloper/freeDictionaryAPI

local function setup(conf)
    if conf.api then
        API_BASE = conf.api
    end
end

local function cat(list)
    local s = list[1]

    for n, part in ipairs(list) do
        if n ~= 1 then
            s = s .. ", " .. part
        end
    end

    return s
end

local function getDefinition(word)
    local url = API_BASE .. "entries/en/" .. word:gsub(" ", "%%20")

    local resp = curl.get(url, {
        accept = "application/json"
    })

    if resp.status == 200 then
        local data = vim.json.decode(resp.body)[1]
        local lines = {}

        table.insert(lines, "## " .. data.word)
        table.insert(lines, "")

        for num, meaning in ipairs(data.meanings) do
            table.insert(lines, "# " .. meaning.partOfSpeech)

            for i, defn in ipairs(meaning.definitions) do
                if defn.definition ~= nil then
                    table.insert(lines, "  " .. i .. ". " .. defn.definition)

                    if defn.example ~= nil then
                        table.insert(lines, "    > Ex: " .. defn.example)
                    end

                    if #defn.synonyms > 0 then
                        table.insert(lines, "##### Synonyms: " .. cat(defn.synonyms))
                    end

                    if #defn.antonyms > 0 then
                        table.insert(lines, "##### Antonyms: " .. cat(defn.antonyms))
                    end

                    table.insert(lines, "")
                end
            end

            if meaning.synonyms ~= nil and #meaning.synonyms > 0 then
                table.insert(lines, "## Synonyms: " .. cat(meaning.synonyms))
                table.insert(lines, "")
            end

            if meaning.antonyms ~= nil and #meaning.antonyms > 0 then
                table.insert(lines, "## Antonyms: " .. cat(meaning.antonyms))
                table.insert(lines, "")
            end

            if num ~= #data.meanings then table.insert(lines, "") end
        end

        return 200, lines
    elseif resp.status == 404 then
        local data = vim.json.decode(resp.body)

        return 404, {data.title, "", data.message, data.resolution}
    else
        return resp.status, {
            "Error: API returned status code " .. resp.status,
            "",
            "Below is the raw response body:",
            resp.body,
        }
    end
end

local function displayDefinition(word)
        bufhelper.open_buffer("DEFINITION.md")
        bufhelper.clear_buffer()

        local status, def = getDefinition(word)

        bufhelper.set_buffer(def)
end

vim.api.nvim_create_user_command(
    "Define",
    function (ctx)
        displayDefinition(ctx.args)
    end,
    {
        desc = "Fetch the dictionary definition of a word or phrase",
        nargs = "+",
    }
)

vim.api.nvim_create_user_command(
    "DefineReload",
    function (ctx)
        local plugin = require("lazy.core.config").plugins["define.nvim"]
        require("lazy.core.loader").reload(plugin)
    end,
    {
        desc = "[For Development] Reload this plugin",
    }
)

return {
    setup = setup,
    getDefinition = getDefinition,
}

