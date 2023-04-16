#!/bin/bash

# 该文件用于建立软链接，或者检查软链接是否有效，请使用 ./ 的方式运行

set -o errexit # 报错直接退出

check_up_ln()
{
    tmp_expect_d=$1  # 期望指向的目标
    tmp_expect_d_ln=$2  # 软链接所在地
    echo "" # 换行，也可以用 -e \n 的
    echo ">>> 检查软链接$tmp_expect_d_ln >>>"
    if [ -d $tmp_expect_d ]  # 存在
    then
        echo "目录存在":$tmp_expect_d
        if [ -L $tmp_expect_d_ln ] # 判断软链接是否存在
        then 
            echo "软链接存在":$tmp_expect_d_ln
            if [ -d $tmp_expect_d_ln ] # 判断软链接是否有效
            then
                tmp_read_ln='readlink -f $tmp_expect_d_ln'
                tmp_read_ln=$(readlink -f $tmp_expect_d_ln)
                echo "软链接有效, 当前指向":$tmp_read_ln
                if [ $tmp_read_ln != $tmp_expect_d ]
                then
                    echo "注意:软链接指向和期望目录不同"
                fi
            else
                echo "软链接无效, 删除并且重指定"
                unlink $tmp_expect_d_ln
                ln -s $tmp_expect_d $tmp_expect_d_ln
                tmp_read_ln='readlink -f $tmp_expect_d_ln'
                tmp_read_ln=$(readlink -f $tmp_expect_d_ln)
                echo "执行:unlink $tmp_expect_d_ln"
                echo "执行:ln -s $tmp_expect_d $tmp_expect_d_ln"
                echo "指定成功, 当前指向":$tmp_read_ln
            fi
        else
            echo "软链接不存在":$tmp_expect_d_ln
            echo "执行:ln -s $tmp_expect_d $tmp_expect_d_ln"
            ln -s $tmp_expect_d $tmp_expect_d_ln
            tmp_read_ln='readlink -f $tmp_expect_d_ln'
            tmp_read_ln=$(readlink -f $tmp_expect_d_ln)
            echo "指定成功, 当前指向":$tmp_read_ln
        fi
    else
        echo "目录不存在":$tmp_expect_d
        if [ -L $tmp_expect_d_ln ] # 判断软链接是否存在
        then 
            echo "软链接存在":$tmp_expect_d_ln
            if [ -d $tmp_expect_d_ln ] # 判断软链接是否有效
            then
                tmp_read_ln='readlink -f $tmp_expect_d_ln'
                tmp_read_ln=$(readlink -f $tmp_expect_d_ln)
                echo "软链接有效, 当前指向":$tmp_read_ln
                if [ $tmp_read_ln != $tmp_expect_d ]
                then
                    echo "注意: 软链接指向和期望目录不同"
                fi
            else
                echo "软链接无效"
                echo "执行:unlink $tmp_expect_d_ln"
                echo "软链接已删除"
                unlink $tmp_expect_d_ln
            fi
        else
            echo "软链接不存在":$tmp_expect_d_ln
        fi
    fi

    echo "<<< 检查软链接$tmp_expect_d_ln <<<"
    echo ""
}

check_up_ln "/mnt/c/Users/92762/Downloads" "$HOME/WinDownloads"
check_up_ln "/mnt/e/WslShares" "$HOME/WinWslShares"