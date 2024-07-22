# define.nvim

Get dictionary definitions from within neovim.

## Installing

You can install define the same way as any other neovim plugin. define.nvim also requires [plenary](https://github.com/nvim-lua/plenary.nvim).

### lazy

```lua
{
    "pythonmcpi/define.nvim",
    lazy = false,
},
{
    "nvim-lua/plenary.nvim",
},
```

## Usage

`:Define <word>` Look up a word in the dictionary.

