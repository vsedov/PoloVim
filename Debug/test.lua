local ret = {}
for _, client in pairs(vim.lsp.get_active_clients()) do
  ret[client.name] = { root_dir = client.config.root_dir, settings = client.config.settings }
end
print(vim.inspect(ret))
