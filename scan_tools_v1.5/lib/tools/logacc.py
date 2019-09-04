#!/usr/bin/python
# -*- coding: utf-8 -*-

#from dateutil.parser import parse
#from dateutil import tz
import re
import json
import sys,os,stat,getopt
reload(sys)
#--------------------------------------
import collections


#-------------------------------------

sys.setdefaultencoding('utf8')

#72.16.102.136 - - [07/Sep/2017:00:00:01 +0800] "POST /v2/user/oppoLogin HTTP/1.1" 403 627 "-" "TeamTalk/91 CFNetwork/811.5.4 Darwin/16.7.0" "120.197.195.111"
pattern_nginx = re.compile(r'(?P<ip>.*) - - \[(?P<date>.*)\] "(?P<req>.*)" (?P<rcode>\d+) (?P<rsize>\d+) "(?P<ref>.*)" "(?P<ua>.*)" "(?P<cip>.*)"')

#127.0.0.1 - "null-user" [09/Mar/2018:16:45:36 +0800] "POST /delta/databox/?S=FF9F0CD8 HTTP/1.0" 200 139 "-" "LDVirtualBox_2.0.1.30_Microsoft Windows 8 Ver6.2_64"
#pattern_resin = re.compile(r'(?P<ip>.*) - (-|".*") \[(?P<date>.*)\] "(?P<req>.*)" (?P<rcode>\d+) (?P<rsize>\d+) "(?P<ref>.*)" "(?P<ua>.*)"')
pattern_resin = re.compile(r'(?P<ip>.*) - (-|".*") \[(?P<date>.*)\] "(?P<req>.*)" (?P<rcode>\d+) (?P<rsize>\d+) (.*)')
#TZ_LOCAL = tz.tzlocal()

log_file = ''
log_type = 'nginx'
time_format = 'sec'
def parse_parameters():
    global log_file
    global log_type
    global time_format

    argsize = len(sys.argv)
    if argsize < 2:
        print sys.argv[0]
        print '  <log file> -f logfile -r [-t d:h:m:s]'
        exit (0)

    try:
        opts,args = getopt.getopt(sys.argv[1:], "f:t:r")
        for opt,arg in opts:
            if opt == "-f":
                log_file = arg
            if opt == "-t":
                time_format = arg
            if opt == "-r":
                log_type = "resin"

    except getopt.GetoptError as Err:
        print Err
        return

def get_time_pose():
    #09/Mar/2018 15:13:38 +0800
    global time_format
    if time_format == 'd':
        return 11
    if time_format == 'h':
        return 14
    if time_format == 'm':
        return 17
    if time_format == 's':
        return 20
    return 20
 
def parse_resin_log(filename):
    list_time = []
    cur_time = ''
    cnt_time = 0
    max_time = 0

    map_uri = {}
    cur_uri = ''
    cnt_uri = 0

    time_pose = get_time_pose()
    filer = open(filename, "r")
    for line in filer.readlines():
        match = pattern_resin.match(line)
        if match:
            local_date = match.group('date').replace(':', ' ', 1)
            m_dat = local_date[0:time_pose] 
            #m_req = match.group('req')
            #print m_ip, m_dat, m_req

            if cur_time == m_dat:
                cnt_time = cnt_time + 1
            else:
                list_time.append((cur_time, cnt_time))
                if max_time < cnt_time:
                    max_time = cnt_time
                cnt_time = 0
                cur_time = m_dat

        else:
            print "not match"
            print line

    filer.close()

    factor = 0.0
    if max_time > 0:
        factor = 200.0 / max_time

    for (sec, cnt) in list_time:
        fcnt = int(factor * cnt)
        print sec, ':' * fcnt, cnt


def parse_nginx_log(filename):
    map_ip = {} #记录中所有访问过ip集合KEY: IP VALUE:times
    cur_ip = ''#当前记录IP
    cnt_ip = 0
    #=======================================================
    # list_time = []#某时刻访问ip访问次数集合，项 (时间，次数)
    list_time = {}
    list_time = collections.OrderedDict()
    cur_time = ''
    cnt_time = 0
    max_time = 0
    #---------------------------------------------------------
    map_ac = {} #访问IP集合；项key:访问的ip value:访问次数
    map_ac = collections.OrderedDict()
    cur_ac = ''
    cnt_ac = 0
    #---------------------------------------------------------
    map_uri = {}
    cur_uri = ''
    cnt_uri = 0

    time_pose = get_time_pose()
    filer = open(filename, "r")
    for line in filer.readlines():
        match = pattern_nginx.match(line)
        if match:
            local_date = match.group('date').replace(':', ' ', 1)
            m_date = local_date[0:time_pose] 
            #foreign_date = parse(fmt_date)
            #local_date = foreign_date.astimezone(TZ_LOCAL)
            m_ip  = match.group('cip')
            #m_req = match.group('req')
            #print m_ip, m_date, m_req
	#--------------------------------------------------------
	    if m_ip != "-":
		res = re.search(r'(2(5[0-5]{1}|[0-4]\d{1})|[0-1]?\d{1,2})(\.(2(5[0-5]{1}|[0-4]\d{1})|[0-1]?\d{1,2})){3}', m_ip)
	        ac_ip = res.group(0)
                if map_ac.has_key(ac_ip):
                    cnt = map_ac[ac_ip]
                    map_ac[ac_ip] = cnt + 1
                else:
                    map_ac[ac_ip] = 1	    
	     
	#--------------------------------------------------------
            if map_ip.has_key(m_ip):
                cnt = map_ip[m_ip]
                map_ip[m_ip] = cnt + 1
            else:
                map_ip[m_ip] = 1
	#=======================================================
	#原代码显示不了当前日期访问，对代码进行修改
            if cur_time == m_date:
                cnt_time = cnt_time + 1
	        list_time[m_date] = cnt_time
            else:
               # list_time.append((cur_time, cnt_time))
		list_time[m_date] = 1
                if max_time < cnt_time:
                    max_time = cnt_time
               # cnt_time = 0
		cnt_time = 1
                cur_time = m_date
	#======================================================
        else:
            print "not match"
            print line

    filer.close()	
    print len(map_ip) 
    for item in map_ip: #输出记录的IP及其访问次数
        print item, map_ip[item]
    #--------------------------------------------
    print "ACTIVED_IP：", len(map_ac)
    for ip in map_ac: #输出记录的访问IP及其访问次数
        print "活跃IP及访问次数：", ip, map_ac[ip]
    #-------------------------------------------
    factor = 0.0
    if max_time > 0:
        factor = 200.0 / max_time
    #==========================================================
   # for (sec, cnt) in list_time:#输出记录时间点及访问次数
   #     fcnt = int(factor * cnt)
   #     print sec, ':' * fcnt, cnt
    for (sec, cnt) in list_time.items():#输出记录时间点及访问次数
        fcnt = int(factor * cnt)
        print "{}\t{}\t{}".format(sec, ':' * fcnt, cnt)
    #=========================================================
if __name__ == '__main__':
    parse_parameters()
    print 'log_file:', log_file #输出时间点
    print time_format#输出以哪种时间类型获取当前访问次数(天/时/分/秒）
    print log_type#输出分析日志类型

    if log_type == 'nginx':
        parse_nginx_log(log_file)

    if log_type == 'resin':
        parse_resin_log(log_file)

