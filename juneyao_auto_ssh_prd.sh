#!/bin/bash

opts=$@
getParam(){
  arg=$1
  echo $opts | xargs -n1 | cut -b 2- | awk -F'=' '{if($1=="'"$arg"'") print $2}'
}


ENV=`getParam ENV`
echo "[INFO] ENV: "${ENV}

USER=zhaoyihao
echo "[INFO] USER: "${USER}

PASSWORD=Cnnqjban235
echo "[INFO] PASSWORD: *****"

if [ "${ENV}" == "STG" ];then
  # stg:t-jmp.juneyaoair.com prd:jmp.juneyaoair.com
  HOST="t-jmp.juneyaoair.com"
  # stg:2222 prd:2222
  PORT="2222"
  TOKEN=`cat $HOME/workspace/auto-work/juneyao-jmp-key/stg.txt`
elif [ "${ENV}" == "PRD" ];then
  # stg:t-jmp.juneyaoair.com prd:jmp.juneyaoair.com
  HOST="jmp.juneyaoair.com"
  # stg:2222 prd:2222
  PORT="2222"
  TOKEN=`cat $HOME/workspace/auto-work/juneyao-jmp-key/prd.txt`
else
  # stg:t-jmp.juneyaoair.com prd:jmp.juneyaoair.com
  HOST="t-jmp.juneyaoair.com"
  # stg:2222 prd:2222
  PORT="2222"
  TOKEN=`cat $HOME/workspace/auto-work/juneyao-jmp-key/stg.txt`
fi

DYNA_TOKEN="`oathtool --totp -b ${TOKEN}`"

sw_login(){
        expect -c "
        # 每个判断等待1秒
        set timeout 1
        spawn ssh $USER@$HOST -p $PORT
        # 判断是否需要保存秘钥
        expect {
                \"yes/no\"   { send yes\n }
        }
        # 判断发送密码
        expect {        
        				\"*assword\" { send $PASSWORD\n }
        }
        # 判断发送验证码
        expect {        
        				\"*OTP Code*\" { send $DYNA_TOKEN\n }
        }
        # 停留在当前登录界面
        interact
        "
}
sw_login