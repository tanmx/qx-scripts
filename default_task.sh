#!/bin/bash
set -e
CONFIG=/qx-scripts/config
git -C /qx-scripts pull
PACKAGE=/qx-scripts/repositories/ZhiYi-N-Private-Script/package.json
SENDNOTIFY=/qx-scripts/repositories/ZhiYi-N-Private-Script/Scripts/sendNotify.js

echo "下载代码"
while read LINE || [[ -n ${LINE} ]]
do
  NAME=`echo $LINE | awk '{print $1}'`
  REPO=`echo $LINE | awk '{print $2}'`
  BRANCH=`echo $LINE | awk '{print $3}'`
  if [ ! -d "/qx-scripts/repositories/${NAME}-${REPO}" ];then
	if [ -z ${BRANCH} ];then
		git clone https://github.com/${NAME}/${REPO} /qx-scripts/repositories/${NAME}-${REPO}
	else
		git clone https://github.com/${NAME}/${REPO} /qx-scripts/repositories/${NAME}-${REPO} -b ${BRANCH}
	fi
  fi
done < ${CONFIG}

echo "复制依赖文件"
\cp /qx-scripts/package.json /qx-scripts/repositories/ZhiYi-N-Private-Script/package.json
\cp /qx-scripts/sendNotify.js /qx-scripts/repositories/ZhiYi-N-Private-Script/Scripts/sendNotify.js

echo "定时任务更新代码，git 拉取最新代码，并安装更新依赖..."
for i in `ls /qx-scripts/repositories/`
do
  if [ ${i} != 'Zero-S1-xmly_speed' ];then
	git -C /qx-scripts/repositories/${i} pull
	npm install --prefix /qx-scripts/repositories/${i}
  fi
done
echo "加载最新task"
crontab /qx-scripts/crontab_list.sh
