#!/bin/bash

opts=$@
getParam(){
  arg=$1
  echo $opts | xargs -n1 | cut -b 2- | awk -F'=' '{if($1=="'"$arg"'") print $2}'
}


USER=zhaoyihao             
echo "[INFO] USER: "${USER}

# stg:t-itop.juneyaoair.com prd:jmp.juneyaoair.com
HOST=`getParam HOST`
echo "[INFO] HOST: "${HOST}

PASSWORD=Cnnqjban235
echo "[INFO] PASSWORD: *****"

# stg:20 prd:2222
PORT=`getParam PORT`
echo "[INFO] PORT: "${PORT}

#STG_TOKEN="537949"

PRD_TOKEN="`oathtool --totp -b 4YIKKGPXJD3G32YP`"

sw_login(){
        expect -c "
        # 每个判断等待两秒
        set timeout 2
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
        				\"*OTP Code*\" { send $PRD_TOKEN\n }
        }
        # 停留在当前登录界面
        interact
        "
}
sw_login