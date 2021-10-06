-- Enable Starship prompt
os.setenv('STARSHIP_SHELL', 'cmd')
local custom_prompt = clink.promptfilter(5)

start_time = os.clock()
end_time = 0
curr_duration = 0
is_line_empty = true

clink.onbeginedit(function ()
  end_time = os.clock()
  if not is_line_empty then
    curr_duration = end_time - start_time
  end
end)

clink.onendedit(function (curr_line)
  start_time = os.clock()
  if string.len(string.gsub(curr_line, '^%s*(.-)%s*$', '%1')) == 0 then
    is_line_empty = true
  else
    is_line_empty = false
  end
end)

function custom_prompt:filter(prompt)
  return io.popen("starship.exe prompt"
    .." --status="..os.geterrorlevel()
    .." --cmd-duration="..math.floor(curr_duration*1000)
    .." --terminal-width="..console.getwidth()
  ):read("*a")
end
