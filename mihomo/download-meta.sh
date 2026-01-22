#!/bin/bash

platform=$1

# 获取版本号
version=$(curl -L -s https://gh-proxy.com/github.com/MetaCubeX/mihomo/releases/download/Prerelease-Alpha/version.txt)

# 根据参数下载文件
if [[ $platform == "macos" ]]; then
	filename="clash.meta-darwin-amd64-cgo-${version}.gz"
elif [[ $platform == "macos-arm" ]]; then
	filename="mihomo-darwin-arm64-${version}.gz"
elif [[ $platform == "linux" ]]; then
	filename="mihomo-linux-amd64-compatible-${version}.gz"
else
	echo "参数错误，请输入 macos、macos-arm、linux"
	exit 1
fi

echo "https://github.com/MetaCubeX/mihomo/releases/download/Prerelease-Alpha/${filename}"

curl -L -o ${filename} https://gh-proxy.com/github.com/MetaCubeX/mihomo/releases/download/Prerelease-Alpha/${filename}

# 解压缩文件
gzip -d ${filename}

# 重命名
if [[ $platform == "macos" ]]; then
	  filebin="clash.meta-darwin-amd64-cgo-${version}"
elif [[ $platform == "macos-arm" ]]; then
	  filebin="mihomo-darwin-arm64-${version}"
elif [[ $platform == "linux" ]]; then
	  filebin="mihomo-linux-amd64-compatible-${version}"
else
	  echo "error"
	  exit 1
fi

echo "${filebin}"

mv ${filebin} clash.meta

chmod +x clash.meta

./clash.meta -v
