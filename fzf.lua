-- Enable fzf standard keybindings for cmd and clink

local clink_command
local clink_alias = os.getalias("clink")
if not clink_alias or clink_alias == "" then
    clink_command =  ""
else
    clink_command = clink_alias:gsub(" $[*]", "")
end


function fzf_history(rl_buffer)
    local ctrl_r_opts = os.getenv('FZF_CTRL_R_OPTS')
    if not ctrl_r_opts then
        ctrl_r_opts = ""
    end
    local temp_contents = rl_buffer:getbuffer()
    if #clink_command == 0 then
        rl_buffer:ding()
        return
    end
    local r = io.popen('"'..clink_command..' history --bare | fzf.exe '..ctrl_r_opts..' -i --tac --query="'..temp_contents..'""')
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
    local ctrl_t_opts = os.getenv('FZF_CTRL_T_OPTS')
    if not ctrl_t_opts then
        ctrl_t_opts = ""
    end
    local ctrl_t_command = os.getenv('FZF_CTRL_T_COMMAND')
    if not ctrl_t_command then
        ctrl_t_command = "dir /b /s /a:-s"
    end
    local r = io.popen(ctrl_t_command..' | fzf.exe '..ctrl_t_opts)
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

function fzf_directory(rl_buffer)
    local alt_c_opts = os.getenv('FZF_ALT_C_OPTS')
    if not alt_c_opts then
        alt_c_opts = ""
    end
    local alt_c_command = os.getenv('FZF_ALT_C_COMMAND')
    if not alt_c_command then
        alt_c_command = "dir /b /s /a:d-s"
    end
    local temp_contents = rl_buffer:getbuffer()
    local r = io.popen('"'..alt_c_command..' | fzf.exe '..alt_c_opts..' -i --query="'..temp_contents..'""')
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
        rl_buffer:endundogroup()
        rl_buffer:refreshline()
    else
        rl_buffer:insert("cd /d "..str)
        rl_buffer:endundogroup()
        rl.invokecommand("accept-line")
    end
end
