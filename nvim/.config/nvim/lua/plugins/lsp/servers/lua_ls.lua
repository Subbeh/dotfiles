return {
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
      hint = {
        enable = true,
        arrayIndex = "Disable", -- "Enable" | "Auto" | "Disable"
        await = true,
        paramName = "Disable",  -- "All" | "Literal" | "Disable"
        paramType = true,
        semicolon = "All",      -- "All" | "SameLine" | "Disable"
        setType = false,
      },
      format = {
        enable = true,
        defaultConfig = {
          max_line_length = "unset",
          indent_style = "space",
          indent_size = "2",
          quote_style = "double",
          call_arg_parentheses = "keep",
          column_width = "unset",
          line_endings = "unix",
          trailing_table_separator = "smart",
        },
      },
    },
  },
}
