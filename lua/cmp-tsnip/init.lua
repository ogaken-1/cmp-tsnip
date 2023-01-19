local source = {}

function source.new()
  return setmetatable({}, { __index = source })
end

function source.is_available()
  return vim.fn['denops#plugin#is_loaded'] 'tsnip' == 1
end

function source.get_debug_name()
  return 'tsnip'
end

function source.get_keyword_pattern()
  return [[\k\+]]
end

---@class tsnip.Item
---@field public word string
---@field public info string

function source:complete(_, callback)
  ---@type tsnip.Item[]
  local items = vim.fn['tsnip#items']()

  local completion_items = {}

  for _, item in ipairs(items) do
    table.insert(completion_items, {
      label = item.word,
      filterText = item.word,
      documentation = item.info,
    })
  end

  callback(completion_items)
end

---@param completion_item lsp.CompletionItem
---@param callback fun(completion_item: lsp.CompletionItem|nil)
function source:execute(completion_item, callback)
  vim.fn['tsnip#remove_suffix_word'](completion_item.label)
  vim.cmd.TSnip { completion_item.label }
  callback(completion_item)
end

return source
