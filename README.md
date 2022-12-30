1. 1password_auto_bak.sh

   1password会周期行的自动备份，将备份好的文件，移动到百度网盘中进行云盘备份,利用mac crontab 每周五同步一次,同步空间用的是3518账号

2. juneyao_auto_ssh_prd.sh

   自动跳转生产ssh，并且集成双因素认证

3. juneyao_mfa_tk_prd.sh

   jmp.juneyaoair.com 登录的双因素认证

   ```brew install oath-toolkit```