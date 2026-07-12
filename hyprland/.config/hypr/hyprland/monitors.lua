for _, m in ipairs(Monitors) do
  hl.monitor({
    output = m.name and m.name or "desc:" .. m.desc,
    mode = m.mode,
    position = m.position,
    scale = m.scale,
  })
end
