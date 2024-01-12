#!/bin/sh

function update_site(){
    filename=$1
    url=$2

    echo `date "+%Y/%m/%d %H.%M.%S"`' [info] update site file: '`${filename}`
    curl ${url} > /tmp/nestingdns/${filename}

    if [ -f /tmp/nestingdns/${filename} ]; then
        if [ -f /nestingdns/etc/site/${filename} ]; then
            rm -rf /nestingdns/etc/site/${filename}
        fi
        mv /tmp/nestingdns/${filename} /nestingdns/etc/site/
    fi
}


# 清空日志文件
rm -rf /nestingdns/log/update.log
rm -rf /nestingdns/log/*.gz
# 准备下载路径
if [ -d /tmp/nestingdns ]; then
    rm -rf /tmp/nestingdns
fi
mkdir -p /tmp/nestingdns


# site 文件下载
echo `date "+%Y/%m/%d %H.%M.%S"`' [info] update site file'
update_site direct-list.txt https://mirror.ghproxy.com/https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/direct-list.txt
update_site apple-cn.txt https://mirror.ghproxy.com/https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/apple-cn.txt
update_site google-cn.txt https://mirror.ghproxy.com/https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/google-cn.txt

update_site proxy-list.txt https://mirror.ghproxy.com/https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/proxy-list.txt
update_site gfw.txt https://mirror.ghproxy.com/https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/gfw.txt
update_site greatfire.txt https://mirror.ghproxy.com/https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/greatfire.txt

update_site private.txt https://mirror.ghproxy.com/https://raw.githubusercontent.com/Loyalsoldier/domain-list-custom/release/private.txt

update_site CN-ip-cidr.txt https://mirror.ghproxy.com/https://raw.githubusercontent.com/Loyalsoldier/v2ray-rules-dat/release/CN-ip-cidr.txt

update_site cloudflare.txt https://www.cloudflare-cn.com/ips-v4/#


# 重启 mosdns
echo `date "+%Y/%m/%d %H.%M.%S"`' [info] restart mosdns'
pkill -f /nestingdns/bin/mosdns
rm -rf /nestingdns/log/mosdns.log
nohup /nestingdns/bin/mosdns start -c /nestingdns/etc/conf/mosdns.yaml -d /nestingdns/work/mosdns > /dev/null 2>&1 &