nvim-config
===========

Usage
-----

On servers or other places where you're not gonna really edit the config:
(requires `git` to be available)

```lua
-- ~/.config/nvim/init.lua
vim.pack.add { "https://github.com/darkwater/nvim-config" }
require("dark-config").setup()
```
