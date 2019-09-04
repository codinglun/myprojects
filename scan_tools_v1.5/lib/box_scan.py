#!/usr/bin/python
#coding=utf-8
import json
import time
import sys
import os
import commands
import re
reload(sys)
sys.setdefaultencoding('utf-8')
sys_info = []


#读取配置文件，并将其转化为json结构list
def load_config(config):
    with open(config, 'r') as f:
        configs = f.read()
    	config_items = json.loads(configs)
    return config_items

def my_strip(_dir, re_txt, stype = 'dir'):
    re_result = ''
    if stype == 'dir': 
   	reg = re.compile(re_txt)
   	re_result = reg.sub('', _dir)
    elif stype == 'str':
	reg = re.compile(re_txt)
        re_result = reg.sub('  ', _dir)
    return re_result

	
#将结果以json结构字符串形式写入/tmp目录下
def save_result():
    cur_dir = os.getcwd()
    save_dir = my_strip(cur_dir, r"(/dir.*)$") + '/result'
    save_name = my_strip(sys.argv[1], r"^(.*/config)")
    save_name = my_strip(save_name, r"(\.conf)$")
    scan_result = save_dir + save_name + '_' + time.strftime("%Y-%m-%d", time.localtime(time.time()))+'.json' 
    with open(scan_result, 'w') as f:
        scan_info = json.dumps(sys_info, ensure_ascii=False, indent=4)
        f.write(scan_info)
def cur_time():
    local_time = time.localtime(time.time())
    format_time = time.strftime("%Y-%m-%d %H:%M:%S",local_time)
    return format_time

#获取配置文件中的检查项并获取执行结果
def parse_config(config):
    for item in config:
        try:
            scan_item = item["检查项".decode("utf-8")]
            print scan_item
            scan_tool = item["tool"]
            cur_path = os.getcwd()
            shell_path = cur_path + "/lib/" + scan_tool
	    scan_date = cur_time()
	    (status, output) = commands.getstatusoutput('sh ' + shell_path)
	    output = my_strip(output, r"\n|\r|\t", 'str')
	    result = {
                "title" : scan_item,
                "tool" : scan_tool,
                "date" : scan_date,
                "result": output,			                
            	     }
	    if status != 0:
		result ={
		 "title" : scan_item,
                 "tool" : scan_tool,
                 "date" : scan_date,
		 "value" : "failed", }
        except:
            result = {
                "title" : scan_item,
                "tool" : scan_tool,
                "date" : scan_date, 
		"value": "failed" 
		}
        finally:
            global sys_info
            sys_info.append(result)
        #time.sleep(1)
if __name__ == "__main__":
    config_file = sys.argv[1]
    config_items = load_config(config_file)
    parse_config(config_items)
    save_result()
