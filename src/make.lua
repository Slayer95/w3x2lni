local function main()
	
	--添加require搜寻路径
	package.path = package.path .. ';' .. arg[1] .. '\\src\\?.lua'
	package.cpath = package.cpath .. ';' .. arg[1] .. '\\build\\?.dll'
	require 'luabind'
	require 'filesystem'
	require 'utility'
	local w3x2txt = require 'w3x2txt'
	local stormlib = require 'stormlib'
	
	--保存路径
	root_dir	= fs.path(arg[1])
	input_dir	= root_dir / 'input'
	output_dir	= root_dir / 'output'
	meta_path	= root_dir / 'meta'
	user_meta_path	= meta_path / 'user'
	txt_dir		= root_dir / 'txt'

	fs.create_directories(txt_dir)
	fs.create_directories(input_dir)
	fs.create_directories(output_dir)

	if arg[2] then
		map_path	= fs.path(arg[2])
		local map = stormlib(map_path)
		for name in pairs(map) do
			map:extract(name, input_dir / name)
		end
		map:close()
	end

	--读取meta表
	w3x2txt.read_metadata(meta_path / 'abilitybuffmetadata.slk')
	w3x2txt.read_metadata(meta_path / 'abilitymetadata.slk')
	w3x2txt.read_metadata(meta_path / 'destructablemetadata.slk')
	w3x2txt.read_metadata(meta_path / 'doodadmetadata.slk')
	w3x2txt.read_metadata(meta_path / 'miscmetadata.slk')
	w3x2txt.read_metadata(meta_path / 'unitmetadata.slk')
	w3x2txt.read_metadata(meta_path / 'upgradeeffectmetadata.slk')
	w3x2txt.read_metadata(meta_path / 'upgrademetadata.slk')

	--读取函数
	w3x2txt.read_triggerdata(meta_path / 'TriggerData.txt')
	w3x2txt.read_triggerdata(user_meta_path / 'TriggerData.txt')

	if arg[2] then
		--转换二进制文件到txt
		w3x2txt.obj2txt(input_dir / 'war3map.w3u', txt_dir / 'war3map.w3u.txt', false)
		w3x2txt.obj2txt(input_dir / 'war3map.w3t', txt_dir / 'war3map.w3t.txt', false)
		w3x2txt.obj2txt(input_dir / 'war3map.w3b', txt_dir / 'war3map.w3b.txt', false)
		w3x2txt.obj2txt(input_dir / 'war3map.w3d', txt_dir / 'war3map.w3d.txt', true)
		w3x2txt.obj2txt(input_dir / 'war3map.w3a', txt_dir / 'war3map.w3a.txt', true)
		w3x2txt.obj2txt(input_dir / 'war3map.w3h', txt_dir / 'war3map.w3h.txt', false)
		w3x2txt.obj2txt(input_dir / 'war3map.w3q', txt_dir / 'war3map.w3q.txt', true)

		w3x2txt.w3i2txt(input_dir / 'war3map.w3i', txt_dir / 'war3map.w3i.txt')
		w3x2txt.wtg2txt(input_dir / 'war3map.wtg', txt_dir / 'war3map.wtg.txt')
		w3x2txt.wct2txt(input_dir / 'war3map.wct', txt_dir / 'war3map.wct.txt')
	else
		--转换txt到二进制文件
		w3x2txt.txt2obj(txt_dir / 'war3map.w3u.txt', output_dir / 'war3map.w3u', false)
		w3x2txt.txt2obj(txt_dir / 'war3map.w3t.txt', output_dir / 'war3map.w3t', false)
		w3x2txt.txt2obj(txt_dir / 'war3map.w3b.txt', output_dir / 'war3map.w3b', false)
		w3x2txt.txt2obj(txt_dir / 'war3map.w3d.txt', output_dir / 'war3map.w3d', true)
		w3x2txt.txt2obj(txt_dir / 'war3map.w3a.txt', output_dir / 'war3map.w3a', true)
		w3x2txt.txt2obj(txt_dir / 'war3map.w3h.txt', output_dir / 'war3map.w3h', false)
		w3x2txt.txt2obj(txt_dir / 'war3map.w3q.txt', output_dir / 'war3map.w3q', true)

		w3x2txt.txt2w3i(txt_dir / 'war3map.w3i.txt', output_dir / 'war3map.w3i')
		w3x2txt.txt2wtg(txt_dir / 'war3map.wtg.txt', output_dir / 'war3map.wtg')
		w3x2txt.txt2wct(txt_dir / 'war3map.wct.txt', output_dir / 'war3map.wct')
	end
	
	print('[完毕]: 用时 ' .. os.clock() .. ' 秒') 

end

main()
