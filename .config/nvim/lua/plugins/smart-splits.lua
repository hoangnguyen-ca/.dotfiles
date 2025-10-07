return {
  "mrjones2014/smart-splits.nvim",
  lazy = false,
  keys = {
    -- Move cursor
    {
      "<A-h>",
      function() require("smart-splits").move_cursor_left() end,
      desc = "Move to left window",
    },
    {
      "<A-l>",
      function() require("smart-splits").move_cursor_right() end,
      desc = "Move to right window",
    },
    {
      "<A-j>",
      function() require("smart-splits").move_cursor_down() end,
      desc = "Move to below window",
    },
    {
      "<A-k>",
      function() require("smart-splits").move_cursor_up() end,
      desc = "Move to above window",
    },

    -- Resize windows
    {
      "<A-Left>",
      function() require("smart-splits").resize_left() end,
      desc = "Resize window left",
    },
    {
      "<A-Right>",
      function() require("smart-splits").resize_right() end,
      desc = "Resize window right",
    },
    {
      "<A-Down>",
      function() require("smart-splits").resize_down() end,
      desc = "Resize window down",
    },
    {
      "<A-Up>",
      function() require("smart-splits").resize_up() end,
      desc = "Resize window up",
    },
  },
}