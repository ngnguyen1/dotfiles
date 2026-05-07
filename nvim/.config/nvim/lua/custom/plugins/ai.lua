---@module 'lazy'
---@type LazySpec
return {
  {
    'David-Kunz/gen.nvim',
    opts = {
      model = 'qwen2.5-coder:14b',
      host = 'localhost',
      port = '11434',
      display_mode = 'float',
      show_prompt = true,
      show_model = true,
      no_auto_close = true,
    },
    keys = {
      { '<leader>ar', ':Gen Review_Code<CR>', mode = 'v', desc = 'Ollama: Review selection' },
      { '<leader>ac', ':Gen<CR>', mode = { 'n', 'v' }, desc = 'Ollama: Custom prompt' },
    },
  },
}
-- vim: ts=2 sts=2 sw=2 et
