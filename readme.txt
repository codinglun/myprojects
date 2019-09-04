#巡检/自检脚本使用方法：
  在scan_tools_v1.0目录下执行./scan.sh后,当已经安装网盘执行巡检模式，
  否则执行自检模式
  （如果复制后文件没有可执行权限使用chmod添加执行权限）
  >得到输出巡检/自检结果：
    >巡检：
    --result/
          --docker_info.result
          --mount.result
          --patrol_scan_${cur_date}.json
          --var_log_messages.result/
          --lsblk.result
          --mysql_show_status
          --sa_log/
    --${local_ip}_result_tgz
    >自检：
    --result/
          --self_scan_${cur_date}.json


#程序结构：
  --/scan_tools_v1.0                          //主目录
          --config/                           //配置文件目录
                --self_scan.config            //自检配置文件
                --patrol_scan.config          //巡检配置文件
          --scan.sh                           //脚本运行入口
          --result/                           //输出结果
          --readme                            //脚本相关信息
          --scan_item.txt                     //检测项目详情
          --lib                               //执行各项检测所需脚本目录
              --xx.sh                         //检测脚本
