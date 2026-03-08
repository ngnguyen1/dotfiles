**This repo is supposed to be used as config by NvChad users!**

- The main nvchad repo (NvChad/NvChad) is used as a plugin by this repo.
- So you just import its modules , like `require "nvchad.options" , require "nvchad.mappings"`
- So you can delete the .git from this repo ( when you clone it locally ) or fork it :)

## Debugging Guide

### JavaScript / TypeScript

This setup uses `nvim-dap` + `nvim-dap-ui` with the Mason `js-debug-adapter`.

#### Keymaps

- `<leader>db` - Toggle breakpoint
- `<leader>dd` - Set conditional breakpoint
- `<leader>dc` - Start / continue debug session
- `<leader>dj` - Step over
- `<leader>dl` - Step into
- `<leader>dk` - Step out
- `<leader>dr` - Run last configuration
- `<leader>de` - Terminate debug session

#### Configurations

When you press `<leader>dc`, choose one:

- `Debug current file`
- `Attach 9229`
- `Attach custom inspector port`

#### Professional flow

1. Start service with inspector enabled:

   ```bash
   NODE_OPTIONS='--inspect=9229' npm run dev
   ```

2. Set breakpoints with `<leader>db`.
3. Press `<leader>dc` and choose `Attach 9229` (or custom port).
4. Use `<leader>dj` / `<leader>dl` / `<leader>dk` to step.
5. Press `<leader>de` to stop; `<leader>dr` to rerun quickly.

Notes:

- API/app port (for example `4800`) is not the debug port.
- DAP attach uses Node inspector ports (`9229`, `9230`, ...).

### Rust

This setup uses `rustaceanvim` + Mason `codelldb`, integrated with the same DAP flow.

#### Keymaps

- `<leader>db` - Toggle breakpoint
- `<leader>dd` - Set conditional breakpoint
- `<leader>dc` - Start / continue debug session
- `<leader>dj` - Step over
- `<leader>dl` - Step into
- `<leader>dk` - Step out
- `<leader>dr` - Run last configuration
- `<leader>de` - Terminate debug session
- `<leader>dt` - Show Rust testables (`:RustLsp testables`)

#### Professional flow

1. Open project root (`Cargo.toml`).
2. Set breakpoints with `<leader>db`.
3. Use `<leader>dt` to pick testables or continue with `<leader>dc`.
4. Step with `<leader>dj` / `<leader>dl` / `<leader>dk`.
5. Stop with `<leader>de`.

Notes:

- Ensure `codelldb` is installed: `:MasonInstall codelldb`.
- Build with debug symbols for best stepping (`cargo build`, `cargo test`).

# Credits

1) Lazyvim starter https://github.com/LazyVim/starter as nvchad's starter was inspired by Lazyvim's . It made a lot of things easier!
