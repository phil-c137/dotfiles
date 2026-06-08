-- Sync the yank buffer across Yazi instances (for dual-pane use in
-- tmux splits: yank in one pane, paste in the other)
require("session"):setup {
	sync_yanked = true,
}

-- Dual-pane navigation (philocalyst/dual-pane.yazi fork)
require("dual-pane"):setup()
