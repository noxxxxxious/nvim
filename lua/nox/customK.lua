-- Keep track of which window is currently open/focused
local hover_win   = nil
local type_win    = nil
local state       = "none"      -- "none" | "hover" | "type"
local last_cursor = { 0, 0 }    -- {row, col} where last float was opened

-- Helper: get position params with correct offset-encoding
local function get_position_params()
  local bufnr    = vim.api.nvim_get_current_buf()
  local clients = vim.lsp.get_clients({ bufnr = bufnr })
  if #clients == 0 then return nil end

  for _, client in ipairs(clients) do
    if client.supports_method("textDocument/typeDefinition", bufnr) then
      local encoding = client.offset_encoding or "utf-16"
      return vim.lsp.util.make_position_params(0, encoding)
    end
  end

  return nil
end

-- Close a window safely if it still exists
local function safe_close(win)
  if win and vim.api.nvim_win_is_valid(win) then
    pcall(vim.api.nvim_win_close, win, true)
  end
end

-- Open the regular hover and capture its window ID
local function open_hover()
  state = "hover"

  -- Close any existing type window immediately
  safe_close(type_win)
  type_win = nil

  -- Trigger LSP hover
  vim.lsp.buf.hover()

  -- Remember where this was called
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  last_cursor = { row, col }

  -- After a short delay, capture whichever window is the new hover
  vim.defer_fn(function()
    if state ~= "hover" then
      return
    end
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local cfg = vim.api.nvim_win_get_config(win)
      if cfg.zindex and cfg.zindex > 50 then
        hover_win = win
        pcall(vim.api.nvim_set_current_win, win)
        return
      end
    end
  end, 100)
end

-- Collect full interface/type body and show it in a float
local function open_type_definition()
  state = "type"

  -- Close any existing hover window immediately
  safe_close(hover_win)
  hover_win = nil

  local params = get_position_params()
  if not params then
    vim.notify("No LSP client for textDocument/typeDefinition", vim.log.levels.WARN)
    return
  end

  -- Remember where this was called
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  last_cursor = { row, col }

  vim.lsp.buf_request(0, "textDocument/typeDefinition", params, function(err, result)
    if err or not result or vim.tbl_isempty(result) then
      return
    end

    local location = result[1] or result
    local uri      = location.uri or location.targetUri
    local range    = location.range or location.targetSelectionRange
    local def_buf  = vim.uri_to_bufnr(uri)

    vim.fn.bufload(def_buf)
    local all_lines   = vim.api.nvim_buf_get_lines(def_buf, 0, -1, false)
    local start_line  = range.start.line
    local lines       = {}
    local brace_count = 0
    local found_start = false

    for i = start_line, #all_lines do
      local line = all_lines[i + 1]
      table.insert(lines, line)
      for c in line:gmatch("[{}]") do
        if c == "{" then brace_count = brace_count + 1
        elseif c == "}" then brace_count = brace_count - 1 end
      end
      if not found_start and line:find("{") then
        found_start = true
      end
      if found_start and brace_count == 0 then
        break
      end
    end

    local filetype = vim.filetype.match({ buf = def_buf })

    local float_buf, winid = vim.lsp.util.open_floating_preview(lines, filetype, {
      border     = "rounded",
      max_width  = 80,
      max_height = 20,
      focusable  = true,
      title      = "Type Definition",
      relative   = "cursor",
      offset_y   = 0,
      offset_x   = 0,
    })

    type_win = winid
    pcall(vim.api.nvim_set_current_win, winid)
  end)
end

-- Main toggler: on each K press, check cursor movement first
local function toggle_hover_type()
  local row, col = unpack(vim.api.nvim_win_get_cursor(0))

  -- If cursor moved since last float was opened, reset everything
  if row ~= last_cursor[1] or col ~= last_cursor[2] then
    safe_close(hover_win)
    safe_close(type_win)
    hover_win   = nil
    type_win    = nil
    state       = "none"
  end

  if state == "none" or state == "type" then
    open_hover()
  elseif state == "hover" then
    open_type_definition()
  end
end

-- Map 'K' in normal mode
vim.keymap.set("n", "K", toggle_hover_type, {
  noremap = true,
  silent  = true,
  desc    = "Toggle LSP Hover ↔ Type Definition",
})
