@@ -0,0 +1,53 @@
-- 获取用户文件路径，并将路径中的\替换成/，以兼容Linux
local rime_user_path = string.gsub(rime_api.get_user_data_dir(), '\\', '/')

-- 复制文件函数
local function copy_file_by_lua(sourceFilePath, destinationFilePath)
	-- 定义要检查的文件夹路径
	local buildFolderPath = rime_user_path .. '/build'

	-- 使用os.execute来执行命令检查文件夹是否存在
	-- 这里使用ls命令在Unix-like系统上，Windows系统可能需要使用dir命令
	local exists = os.execute("ls -d " .. buildFolderPath .. " > /dev/null 2>&1")

	-- 检查文件夹是否存在
	if exists == 0 then
		-- 文件夹存在，不执行任何操作
	else
		-- 文件夹不存在，创建文件夹
		os.execute("mkdir -p " .. buildFolderPath)
	end

	-- 打开源文件
	local sourceFile = assert(io.open(sourceFilePath, "rb"))
	if not sourceFile then
		--log.writeLog("无法打开源文件: " .. sourceFile)
		return
	end

	-- 创建或覆盖目标文件
	local destinationFile = assert(io.open(destinationFilePath, "wb"))
	if not destinationFile then
		--log.writeLog("无法创建目标文件: " .. destinationFilePath)
		sourceFile:close()
		return
	end

	-- 读取源文件内容并写入目标文件
	local chunkSize = 4096 -- 可以调整缓冲区大小以适应不同需求
	local chunk = sourceFile:read(chunkSize)
	while chunk do
		destinationFile:write(chunk)
		chunk = sourceFile:read(chunkSize)
	end

	-- 清理：关闭文件
	sourceFile:close()
	destinationFile:close()
end

-- 拷贝拼音音调文件
copy_file_by_lua(rime_user_path .. '/pinyin_tone/zdict.reverse.bin', rime_user_path .. '/build/zdict.reverse.bin')
copy_file_by_lua(rime_user_path .. '/pinyin_tone/kMandarin.reverse.bin', rime_user_path .. '/build/kMandarin.reverse.bin')
copy_file_by_lua(rime_user_path .. '/pinyin_tone/pinyin.reverse.bin', rime_user_path .. '/build/pinyin.reverse.bin')
copy_file_by_lua(rime_user_path .. '/pinyin_tone/tone.reverse.bin', rime_user_path .. '/build/tone.reverse.bin')
