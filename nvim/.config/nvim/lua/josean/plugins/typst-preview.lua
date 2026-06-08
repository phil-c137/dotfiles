return {
  "chomosuke/typst-preview.nvim",
  ft = "typst",
  version = "1.*",
  build = function()
    require("typst-preview").update()
  end,
  opts = {
    -- use the system default browser for the live preview
    open_cmd = nil,
    -- scroll the preview to follow the cursor while editing
    follow_cursor = true,
  },
  keys = {
    { "<leader>op", "<cmd>TypstPreview<cr>", desc = "Typst preview open", ft = "typst" },
    { "<leader>oc", "<cmd>TypstPreviewStop<cr>", desc = "Typst preview close", ft = "typst" },
  },
}
