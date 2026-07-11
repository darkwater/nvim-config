- [x] GUI zoom with ctrl+shift+plus/minus
- [ ] Set up better vim.ui stuff
- [x] Fix help autocmd only working once
- [x] System colors
- [x] Bash highlighting in Github Actions yaml
- [x] Prevent Neovide scrolling animation when opening Telescope
- [ ] Prevent Neovide scrolling animation when opening Telescope in a less hacky way
- [ ] Deduplicate some things
    - [ ] Neovide animation settings that are temporarily overridden by autocmds
    - [ ] leadmultispace updated by autocmd on OptionSet
- [ ] <space>wQ that shows something like
    ```
    foo.lua
    bar.lua*
    are you sure you want to quit? y/n
    ```
- [ ] Toggle menu system
- [ ] Keep `<space>pp` sorted by recently used after entering a filter
- [ ] Automatically resize man pages on window resize
- [ ] Rust stuff like `<space>rr`
- [ ] Warnings for missing tree-sitter grammars
- [ ] Syntax highlighting within Markdown code blocks
- [ ] Markdown edit autocmd that keeps -/= length in sync with line above
- [ ] Fix <CR> not working in location list, our map overrides it
- [ ] Fix git diff preview deletions after the last line
- [ ] Figure out why we keep getting duplicate copilot instances
- [ ] Offer to install missing packages through pacman on Arch
    - Use fresh distrobox instance on SteamOS to figure out which
- [ ] Update .config/nvim if git repo
