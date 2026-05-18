nvim-config
===========

Still a work in progress but it's coming along nicely.

In May 2026 I decided to completely redo my Neovim config from scratch, with 12
years of experience using (Neo)vim, and using the latest cool things (eg.
vim.pack, blink, built-in lsp support/bindings, tree-sitter)

Principles
----------

- **Installable as plugin**

  I want to be able to use this config everywhere, including on servers. I
  manually clone this repo on my desktop and laptop where I'll want to edit it,
  and for every other machine I use Neovim on, I install this config as a
  plugin, making use of vim.pack's update system.

- **Usable by root**

  I want to be able to use this config _**everywhere**_, including as root.
  Most plugins aren't installed if Neovim is running as root, and the ones that
  are loaded are pinned to a specific commit for some added security. Please
  note that I'm not a security expert so it might not necessarily be "safe" to
  your standards.

- **No Windows support currently**

  I don't use Windows anywhere currently so that's not part of my "everywhere".
  It might still work and I usually try to program cross-platformly but iunno
  how the root check will behave since uv.getuid() is not supported there.

- **Doing things properly**

  I'm not just making this for me, but also someone else: future me. A year
  from now I might not remember some quirks or how certain parts of my setup
  work, so for things that need manual setup, there's an actual flow, eg.
  notifications or dialogs.

  This should also translate to being easy to use by someone other that my
  present or future self. While you can't configure my config in ways you might
  want, hopefully this means it's easy to fork and adapt for your own needs.

- **A healthy dose of plugins**

  Not too many, not too few. I like using plugins, but I also like keeping my
  setup relatively simple. My previous setup grew slowly over time to 82, and
  well, stuff broke after a while. There were plugins I don't even remember
  what they do. This time around, I'm gonna be a bit more thoughtful about
  plugins I add. I'll also document what a plugin is for, including if it's
  just a dependency for something.

- **A bunch of custom functionality**

  By now I should have a pretty decent idea of what I want, as well as a decent
  understanding of how modern Neovim works, so I think it's time to do some
  stuff myself instead of finding plugins that only kinda do what I want.

If you want to know actual features like plugins and keybinds, I'm afraid
you'll have to just read the code. I could write some stuff here now but I
doubt I'll bother to keep it up-to-date. If you're reading this some time in
the future you can bother me about putting some screenshots here though.

Usage
-----

On servers or other places where you're not gonna really edit the config:
(requires `git` to be available)

```lua
-- ~/.config/nvim/init.lua and/or /root/.config/nvim/init.lua
vim.pack.add { "https://github.com/darkwater/nvim-config" }
require("dark-config").setup()

-- when installed for root and using sudo, you can apply the config for just
-- your user:
require("dark-config").setup { only_for_sudo_user = "dark" }

-- and if other users want to configure things you do not want, you can do
-- something like:
if require("dark-config").setup { only_for_sudo_user = "dark" } then
    return
end

vim.g.other_stuff = "blah"
```

If you're going to fork and edit the config, simply clone your fork to
`~/.config/nvim`.
