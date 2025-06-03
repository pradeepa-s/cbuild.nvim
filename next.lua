local M = {}

vim.api.nvim_create_autocmd('TermOpen', {
	group = vim.api.nvim_create_augroup('custom-term-open', {
		clear = true
	}),
	callback = function(_)
		vim.opt.number = false
		vim.opt.relativenumber = false
	end,
})

local job_id = 0
local last_command = nil

vim.keymap.set("n", "<leader>st", function()
	vim.cmd.vnew()
	vim.cmd.term()
	vim.cmd.wincmd('J')
	vim.api.nvim_win_set_height(0, 15)
	job_id = vim.bo.channel
end, {desc =  "Open a small terminal"})

local get_command_and_execute = function()
	last_command = vim.fn.input("Enter command > ")
	vim.fn.chansend(job_id, {last_command, ""})
end

vim.keymap.set("n", "<leader>sc", function()
	if last_command then
		vim.fn.chansend(job_id, {last_command, ""})
	else
		get_command_and_execute()
	end
end, {desc = "Send command"})

vim.keymap.set("n", "<leader>sC", function()
	get_command_and_execute()
end, {desc = "Send new command"})
