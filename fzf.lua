local fzf_command = 'fzf.exe --height 40% --exact --no-sort --reverse --cycle'

local clink_command
local clink_alias = os.getalias("clink")
if not clink_alias or clink_alias == "" then
    clink_command =  ""
else
    clink_command = clink_alias:gsub(" $[*]", "")
end


function fzf_history(rl_buffer)
    local temp_contents = rl_buffer:getbuffer()
    if #clink_command == 0 then
        rl_buffer:ding()
        return
    end
    local r = io.popen('"'..clink_command..' history --bare | '..fzf_command..' -i --tac --query="'..temp_contents..'""')
    if not r then
        rl_buffer:ding()
        return
    end
    local str = r:read('*all')
    r:close()

    str = str:gsub("[\r\n]", "")
    rl_buffer:beginundogroup()
    rl_buffer:remove(0, -1)
    if string.len(str) == 0 then
        rl_buffer:insert(temp_contents)
    else
        rl_buffer:insert(str)
    end
    rl_buffer:endundogroup()
    rl_buffer:refreshline()
end

function fzf_file(rl_buffer)
    local r = io.popen(fzf_command)
    if not r then
        rl_buffer:ding()
        return
    end
    local str = r:read('*line')
    r:close()
    if str then
        rl_buffer:insert(str)
    end
    rl_buffer:refreshline()
end
