local jumpMap = {}
local allowedJumpKeys = { 'q', 'w', 'e', 'r', 't', 'a', 's', 'd', 'f', 'g', 'z', 'x', 'c', 'v', 'b' }
local keysToGroup = 5
local MENU_WIDTH = 40

local function isAllowedKey(key)
  for _, allowedKey in ipairs(allowedJumpKeys) do
    if allowedKey == key then
      return true
    end
  end
  return false
end

-- Utility function to get a file name for display.
-- If input is a buffer number then we retrieve its name.
-- If input is already a string (the full file path), we convert it 
-- to a relative path (relative to the current working directory).
local function getFileName(input)
  if type(input) == "number" then
    local name = vim.api.nvim_buf_get_name(input)
    return name ~= "" and vim.fn.fnamemodify(name, ":~:.") or ""
  elseif type(input) == "string" then
    return vim.fn.fnamemodify(input, ":~:.")
  else
    return ""
  end
end

---------------------------------------------------------------------
-- Helper: Trim a string from the left with an ellipsis if too long.
--
-- Given a file string and an available width, if the display width of
-- the file is more than available, then return a new string that starts
-- with an ellipsis and ends with the last (available - 1) characters.
---------------------------------------------------------------------
local function trimFilename(file, available)
  local disp = vim.fn.strdisplaywidth(file)
  if disp <= available then
    return file
  end
  -- Reserve one character for the ellipsis.
  local cut = available - 1
  if cut < 1 then
    return file:sub(-available)
  end
  -- Trim from the left: take the last 'cut' characters, prepend an ellipsis.
  return "…" .. file:sub(-cut)
end

---------------------------------------------------
-- Persistence: Loading and saving jumpMap to a dotfile.
---------------------------------------------------

-- Get the path for the .jumppack file in the current directory.
local function getJumpPackFilePath()
  return vim.fn.getcwd() .. "/.jumppack"
end

-- Load the saved jumpMap (if it exists) from .jumppack.
local function loadJumpPack()
  local filepath = getJumpPackFilePath()
  local f = io.open(filepath, "r")
  if f then
    local content = f:read("*a")
    io.close(f)
    if content and #content > 0 then
      jumpMap = vim.fn.json_decode(content)
    else
      jumpMap = {}
    end
  else
    jumpMap = {}
  end
end

-- Save the current jumpMap to the .jumppack file.
local function saveJumpPack()
  local filepath = getJumpPackFilePath()
  local f = io.open(filepath, "w")
  if f then
    local data = vim.fn.json_encode(jumpMap)
    f:write(data)
    io.close(f)
  end
end

---------------------------------------------------
-- Drawing the Floating Jump Menu
---------------------------------------------------

local function drawJumpMenu(mode)
  local header = "🚀 JumpPack "
  if mode == "set" then
    header = "🎯 Setting Jump Zone "
  end

  local lines = {}
  table.insert(lines, "")
  -- Build a line for each allowed jump key.
  local keyCount = #allowedJumpKeys
  for i, key in ipairs(allowedJumpKeys) do
    local prefix = key .. "] "
    local line = prefix
    if jumpMap[key] then
      -- Convert the stored filename (full path) to a relative display.
      local file = getFileName(jumpMap[key].filename or jumpMap[key])
      if file ~= "" then
        -- Calculate the available space for the file portion.
        local available = MENU_WIDTH - vim.fn.strdisplaywidth(prefix)
        if vim.fn.strdisplaywidth(file) > available then
          file = trimFilename(file, available)
        end
        line = prefix .. file
      end
    end
    table.insert(lines, line)
    -- After every 4 keys (except after the last group) insert an empty line.
    if i % keysToGroup == 0 and i < keyCount then
      table.insert(lines, "")
    end
  end

  -- Append an empty line and then the right-aligned header.
  table.insert(lines, "")
  local displayWidth = vim.fn.strdisplaywidth(header)
  if displayWidth < MENU_WIDTH then
    header = string.rep(" ", MENU_WIDTH - displayWidth) .. header
  end
  table.insert(lines, header)
  return lines
end

---------------------------------------------------
-- Floating Window Management
---------------------------------------------------

local win_handle = nil
local buf_handle = nil

local function openJumpMenu(mode)
  -- If a window is already open, close it first.
  if win_handle and vim.api.nvim_win_is_valid(win_handle) then
    vim.api.nvim_win_close(win_handle, true)
  end

  local lines = drawJumpMenu(mode)
  -- Create a scratch buffer for the floating window.
  buf_handle = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf_handle, 0, -1, false, lines)

  local width = MENU_WIDTH
  local height = #lines

  -- Calculate the centered position.
  local opts = {
    relative = 'editor',
    width = width,
    height = height,
    row = (vim.o.lines - height) / 2 - 1,
    col = (vim.o.columns - width) / 2,
    style = 'minimal',
    border = 'rounded'
  }

  win_handle = vim.api.nvim_open_win(buf_handle, false, opts)
end

local function closeJumpMenu()
  if win_handle and vim.api.nvim_win_is_valid(win_handle) then
    vim.api.nvim_win_close(win_handle, true)
    win_handle = nil
  end
  if buf_handle and vim.api.nvim_buf_is_valid(buf_handle) then
    vim.api.nvim_buf_delete(buf_handle, { force = true })
    buf_handle = nil
  end
end

---------------------------------------------------
-- Jump Point Functions
---------------------------------------------------

-- Store the current buffer and file path as the jump point for the specified key.
local function setJumpPoint(key)
  local buf = vim.api.nvim_get_current_buf()
  local filename = vim.api.nvim_buf_get_name(buf)
  jumpMap[key] = {
    bufnr = buf,
    filename = filename
  }
  print("Set jump point [" .. key .. "] to buffer: " .. buf)
  saveJumpPack()  -- Persist the jumpMap to disk.
  if win_handle then
    vim.api.nvim_buf_set_lines(buf_handle, 0, -1, false, drawJumpMenu("set"))
  end
end

-- Jump to the buffer stored in the jump map for the given key.
local function jumpToPoint(key)
  local data = jumpMap[key]
  if not data then
    print("No jump point exists for key: " .. key)
    return
  end

  if vim.api.nvim_buf_is_valid(data.bufnr) then
    vim.api.nvim_set_current_buf(data.bufnr)
  else
    local filename = data.filename
    if filename and #filename > 0 then
      vim.cmd("edit " .. vim.fn.fnameescape(filename))
    else
      print("Jump point for key " .. key .. " doesn't have a valid file name")
    end
  end
end

---------------------------------------------------
-- Main Command for Handling Input, Modes, and Escape.
---------------------------------------------------

local function jumpCommand()
  loadJumpPack()  -- Load persistent jump mappings when the command starts.
  local mode = "jump"  -- Start in jump (normal) mode.

  while true do
    openJumpMenu(mode)
    vim.cmd("redraw")  -- Force screen update.

    local key = vim.fn.nr2char(vim.fn.getchar())
    if key:byte() == 27 then
      if mode == "jump" then
        print("Jump command canceled.")
        break
      else
        mode = "jump"
        print("Exiting set mode, back to jump mode.")
        goto continue_loop
      end
    end

    if mode == "jump" then
      if key == "j" then
        mode = "set"
        goto continue_loop
      else
        if isAllowedKey(key) then
          jumpToPoint(key)
        else
          print("Invalid jump key: " .. key)
        end
        break
      end
    else
      if isAllowedKey(key) then
        setJumpPoint(key)
      else
        print("Invalid jump key: " .. key)
      end
      break
    end

    ::continue_loop::
  end

  vim.schedule(function()
    closeJumpMenu()
    vim.cmd("redraw")
  end)
end

---------------------------------------------------
-- Map the <leader>j key to trigger the jumpCommand.
---------------------------------------------------

vim.keymap.set('n', '<leader>j', jumpCommand)
