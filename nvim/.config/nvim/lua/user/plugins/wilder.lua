local status_ok, wilder = pcall(require, "wilder")
if not status_ok then
  return
end

wilder.config()
