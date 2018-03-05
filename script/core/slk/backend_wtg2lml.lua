local w2l
local wtg
local wct

local function get_path(path, used)
    path = path:gsub('[$\\$/$:$*$?$"$<$>$|]', '_')
    while used[path] do
        local name, id = path:match '(.+)_(%d+)$'
        if name and id then
            id = id + 1
        else
            name = path
            id = 1
        end
        path = name .. '_' .. id
    end
    return path
end

local function compute_path()
    if not wtg then
        return
    end
    local map = {}
    map[1] = {}
    local dirs = {}
    for _, dir in ipairs(wtg.categories) do
        dirs[dir.id] = {}
        map[1][dir.name] = get_path(dir.name, map[1])
    end
    for _, trg in ipairs(wtg.triggers) do
        table.insert(dirs[trg.category], trg)
    end
    for _, dir in ipairs(wtg.categories) do
        map[dir.name] = {}
        for _, trg in ipairs(dirs[dir.id]) do
            map[dir.name][trg.name] = get_path(trg.name, map[dir.name])
        end
    end
    return map
end

local function read_dirs(map)
    local dirs = {}
    for _, dir in ipairs(wtg.categories) do
        dirs[dir.id] = {}
    end
    for _, trg in ipairs(wtg.triggers) do
        table.insert(dirs[trg.category], trg)
    end
    local lml = { '', false }
    for i, dir in ipairs(wtg.categories) do
        local filename = map[1][dir.name]
        local dir_data = { filename, dir.id }
        if dir.name ~= filename then
            dir_data[#dir_data+1] = { '名称', dir.name }
        end
        if dir.comment == 1 then
            dir_data[#dir_data+1] = { '注释', 1 }
        end
        for i, trg in ipairs(dirs[dir.id]) do
            local filename = map[dir.name][trg.name]
            local trg_data = { filename, false }
            if trg.name ~= filename then
                trg_data[#trg_data+1] = { '名称', trg.name }
            end
            if trg.type == 1 then
                trg_data[#trg_data+1] = { '注释' }
            end
            if trg.enable == 0 then
                trg_data[#trg_data+1] = { '禁用' }
            end
            if trg.close == 1 then
                trg_data[#trg_data+1] = { '关闭' }
            end
            if trg.run == 1 then
                trg_data[#trg_data+1] = { '运行' }
            end
            dir_data[#dir_data+1] = trg_data
        end
        lml[i+2] = dir_data
    end
    return w2l:backend_lml(lml)
end

local function read_triggers(files, map)
    if not wtg then
        return
    end
    local triggers = {}
    local dirs = {}
    for _, dir in ipairs(wtg.categories) do
        dirs[dir.id] = dir.name
    end
    for i, trg in ipairs(wtg.triggers) do
        local dir = dirs[trg.category]
        local path = map[1][dir] .. '/' .. map[dir][trg.name]
        if trg.wct == 0 and trg.type == 0 then
            files[path..'.lml'] = w2l:backend_lml(trg.trg)
        end
        if #trg.des > 0 then
            files[path..'.txt'] = trg.des
        end
        if trg.wct == 1 then
            local buf = wct.triggers[i]
            if #buf > 0 then
                files[path..'.j'] = buf
            end
        end
    end
end

return function (w2l_, wtg_, wct_)
    w2l = w2l_
    wtg = wtg_
    wct = wct_

    local files = {}

    files['代码.txt'] = wct.custom.comment
    files['代码.j'] = wct.custom.code
    files['变量.lml'] = w2l:backend_lml(wtg.vars)

    local map = compute_path()
    
    files['目录.lml'] = read_dirs(map)
    read_triggers(files, map)

    return files
end
