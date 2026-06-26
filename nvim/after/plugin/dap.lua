local dap = require("dap")
local dapui = require("dapui")
local dapgo = require("dap-go")

-- 1. Setup the Go Adapter
-- This automatically configures "Debug Test" and "Attach to Process" capabilities
dapgo.setup({
  delve = {
    -- Initialize delve with absolute paths
    path = "dlv",
    initialize_timeout_sec = 30,
    port = "${port}",
  },
})

-- Setup UI with both layouts
dapui.setup({
  layouts = {
    -- Layout 1: The Lean Inspector (Your default)
    {
      elements = {
        { id = "scopes", size = 0.70 },
        { id = "stacks", size = 0.30 },
      },
      size = 40,
      position = "left",
    },
    -- Layout 2: The Full IDE Experience
    {
      elements = {
        { id = "scopes", size = 0.25 },
        { id = "breakpoints", size = 0.25 },
        { id = "stacks", size = 0.25 },
        { id = "watches", size = 0.25 },
      },
      size = 40,
      position = "left",
    },
    -- Shared Bottom Tray for both layouts
    {
      elements = {
        { id = "repl", size = 0.5 },
        { id = "console", size = 0.5 },
      },
      size = 10,
      position = "bottom",
    },
  },
})

-- Auto-open UI when debugging starts
dap.listeners.after.event_initialized["dapui_config"] = function()
  -- Always reset to layout 1 (Lean) on new sessions
  dapui.open({ layout = 1 })
end


local map = vim.keymap.set

-- A localized state to track which layout is active
local current_layout = 1

-- Core Execution
map("n", "<leader>dc", dap.continue, { desc = "Debug: Start / Continue" })
map("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })

-- Your Specific Use Cases
map("n", "<leader>dt", dapgo.debug_test, { desc = "Debug: Closest Go Test" })

-- Stepping through code
map("n", "<leader>do", dap.step_over, { desc = "Debug: Step Over" })
map("n", "<leader>di", dap.step_into, { desc = "Debug: Step Into" })
map("n", "<leader>dI", dap.step_out, { desc = "Debug: Step Out" })

-- UI Namespace: Toggles and Layouts
map("n", "<leader>duu", dapui.toggle, { desc = "Debug UI: Toggle Panels On/Off" })

map("n", "<leader>dul", function()
  -- Toggle between layout 1 (Lean) and 2 (IDE)
  current_layout = current_layout == 1 and 2 or 1
  dapui.open({ layout = current_layout })
  vim.notify("DAP Layout: " .. (current_layout == 1 and "Lean" or "IDE"))
end, { desc = "Debug UI: Switch Layout (Lean/IDE)" })

-- UI Namespace: Floating Windows
map("n", "<leader>duf", function()
  -- Opens a native select menu asking which panel you want to float (scopes, console, etc.)
  dapui.float_element() 
end, { desc = "Debug UI: Float Element" })

map("n", "<leader>due", function()
  -- Evaluates the variable currently under your cursor and shows it in a floating window
  dapui.eval(nil, { enter = true }) 
end, { desc = "Debug UI: Evaluate Variable Under Cursor" })

-- UI Namespace: Quick Console Access
map("n", "<leader>duc", function()
  -- Explicitly float just the console, useful if the UI is closed but you want to check logs
  dapui.float_element("console", { enter = true })
end, { desc = "Debug UI: Float Console (Logs)" })
