local module = { name = "SortInMotion" }

--
-- FUNCTIONS
--

function module.setup()
	_G[module.name] = module
end

function module.operator(mode)
	vim.opt.operatorfunc = string.format("v:lua.%s.handler", module.name)
	if mode == "visual" then return "g@`>" end
	return "g@"
end

function module.handler(motion)
	local register = vim.v.register
	local contents = vim.fn.getreg(register)

	local left = vim.api.nvim_buf_get_mark(0, "[")
	local right = vim.api.nvim_buf_get_mark(0, "]")
	local lines = vim.api.nvim_buf_get_lines(0, left[1] - 1, right[1], false)

	if motion == "line" or motion == "block" or (motion == "char" and #lines > 1) then
		vim.cmd(string.format("%d,%dsort u", left[1], right[1]))
	elseif motion == "char" then
		print("TODO: single line sorting not yet implemented")
	end
end

--
-- MAPPINGS
--

vim.keymap.set("n", "<plug><sort-in-motion>", function() return module.operator("normal") end, { silent = true, expr = true })
vim.keymap.set("x", "<plug><sort-in-motion>", function() return module.operator("visual") end, { silent = true, expr = true })
vim.keymap.set("o", "<plug><sort-in-motion>", "g@", { silent = true })

return module
