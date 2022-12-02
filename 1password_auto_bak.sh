#!/bin/zsh


# 1password会周期行的自动备份，将备份好的文件，移动到百度网盘中进行云盘备份
# 利用mac crontab 每周五同步一次 
# 同步空间用的是3518账号
cp -R -a /Users/hoey/Library/Group\ Containers/2BUA8C4S2C.com.agilebits/Library/Application\ Support/1Password/Backups /Users/hoey/同步空间/app/1Password

content=`ls -l /Users/hoey/同步空间/app/1Password/Backups`

echo "自动备份1password成功 ${content}" |mail -s "自动备份1password数据" 351865576@qq.com
