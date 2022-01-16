local module = { name = "PutInMotion" }

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

	vim.api.nvim_buf_set_text(0,
		left[1] - 1, left[2],
		right[1] - 1, math.min(right[2], vim.fn.getline(right[1]):len() - 1) + 1,
		vim.split(contents:gsub("\n$", ""), "\n")
	)
end

--
-- MAPPINGS
--

vim.keymap.set("n", "<plug><put-in-motion>", function() return module.operator("normal") end, { silent = true, expr = true })
vim.keymap.set("x", "<plug><put-in-motion>", function() return module.operator("visual") end, { silent = true, expr = true })
vim.keymap.set("o", "<plug><put-in-motion>", "g@", { silent = true })

return module
