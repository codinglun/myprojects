#!/usr/bin/python
# -*- coding: utf-8 -*-

# version 1.01
import json
import sys,os,stat
reload(sys)  
sys.setdefaultencoding('utf8')  

# system cfg: /opt/dragonball/config/DragonBall.json
# /system/application/webdomain
# /system/application/smtp/username

# device cfg: /opt/dragonball/config/device_ip.json
# /device/192.168.0.3/application/role

# container cfg:

#########################################################################
def strip_value(Val):
    if Val.find(' ') > 0:
        return Val
    
    if Val.startswith('"'):
        Len = len(Val)
        return Val[1:Len-1]

    return Val

def guess_root_path():
    patho = "/opt/dragonball/config/box.cfg"
    pathi = "/opt/dirmap/config/box.cfg"

    if os.path.exists(patho):
        return "/opt/dragonball"
    else:
        return "/opt/dirmap"

def get_local_ip():
    rpath = guess_root_path()
    cfile = rpath + "/config/box.cfg" 

    Fpr = open(cfile, "r")
    Key = "local_ip="
    Val = "127.0.0.1"
    for line in Fpr.readlines():
        line = line.rstrip()
        if line.startswith(Key):
            Val = line[len(Key):]
            break
    Fpr.close()
    return Val
 
def get_sys_file():
    rpath = guess_root_path()
    return  rpath + "/config/DragonBall.json" 
    
def get_dev_module_path(DevIP):
    rpath   = guess_root_path()
    if DevIP == "":
        DevIP = get_local_ip()
    return rpath + "/config/device_%s/module" %(DevIP)
 
def get_dev_file(LocalIP):
    rpath   = guess_root_path()
    if LocalIP == "":
        LocalIP = get_local_ip()
    return rpath + "/config/device_%s/device_%s.json" %(LocalIP, LocalIP)

def get_runtime_file():
    rpath = guess_root_path()
    return  rpath + "/config/runtime.cfg"
 
def get_module_obj(filepath):
    if os.path.exists(filepath) != False:
        FileObjs = load_json(filepath)
        return FileObjs["dragonBallConfig"]["containerWide"]["framework"]
    return None

#########################################################################
def get_obj(Obj, Key):
    if Obj is None:
        return None

    Keys = Obj.keys()
    for key in Keys:
        if key == Key:
            return Obj[Key]
    return None 

def get_ball(JsonObjs, Ball):
    Items = len(JsonObjs)
    for Obj in JsonObjs:
        DragonBall = Obj["dragonBallConfig"]
        SysWide    = DragonBall["systemWide"]
        FrameWork  = SysWide["framework"]

        if FrameWork["name"] == Ball:
            return SysWide

    return None


def get_all_ball(JsonObjs):
    Items = len(JsonObjs)
    for Obj in JsonObjs:
        DragonBall = Obj["dragonBallConfig"]
        SysWide    = DragonBall["systemWide"]
        FrameWork  = SysWide["framework"]
        Custom     = get_obj(SysWide, "custom")
        print FrameWork["name"]

def dump_objs(Fpw, Objs, Prefix):
    if Objs is None:
        Fpw.write("%s=\n" %(Prefix))
        return
    
    if type(Objs) is bool:
        Fpw.write('%s="%s"\n' %(Prefix,Objs))
        return
    
    if type(Objs) is unicode:
        Fpw.write('%s="%s"\n' %(Prefix,Objs))
        return

    if type(Objs) is int:
        Fpw.write('%s="%d"\n' %(Prefix,Objs))
        return

    if type(Objs) is list:
        Val = ""
        for Obj in Objs:
            #dump_objs(Fpw, Obj, Prefix)
            if Val == "":
                Val = Obj
            else:
                Val = Val + " " + Obj
        Fpw.write('%s="%s"\n' %(Prefix, Val))
    else:
        Keys = Objs.keys()
        for Key in Keys:
            Obj = Objs[Key]
            if Obj == None:
                continue
            CurName = Prefix + "/" + Key
            dump_objs(Fpw, Obj, CurName)
        
 
def dump_ball(Fpw, JsonObjs):
    Items = len(JsonObjs)
    for Obj in JsonObjs:
        DragonBall = Obj["dragonBallConfig"]
        SysWide    = DragonBall["systemWide"]
        FrameWork  = SysWide["framework"]
        Custom     = get_obj(SysWide, "custom")
        Name       = "system/" + FrameWork["name"]
        Fpw.write("\n#[%s]\n" %(Name))
        dump_objs(Fpw, Custom, Name)
    Fpw.close()

	   
##############################################################################
def load_json(FileName):
    JsonFile = open(FileName)
    JsonBufs = JsonFile.read()
    JsonObjs = json.loads(JsonBufs)

    JsonFile.close()
    return JsonObjs

def converted_file(FileName):
    BName  = os.path.basename(FileName)
    Status = os.stat(FileName)
    Mtime  = Status[stat.ST_MTIME]
    Size   = Status[stat.ST_SIZE]
    Fname  = "/tmp/%s.%s.%d" %(BName, Mtime, Size)
    return Fname

def get_sys_cert(JsonObjs):
    for Obj in JsonObjs:
        DragonBall = Obj["dragonBallConfig"]
        SysWide    = DragonBall["systemWide"]
        FrameWork  = SysWide["framework"]
        Name       = FrameWork["name"]
        if Name != "haproxy":
            continue
        Custom     = get_obj(SysWide, "custom")
        Safe       = get_obj(Custom, "safe")
        Cert       = get_obj(Safe, "cert")
        print Cert
 
def get_sys_hosts(JsonObjs):
    for Obj in JsonObjs:
        DragonBall = Obj["dragonBallConfig"]
        SysWide    = DragonBall["systemWide"]
        FrameWork  = SysWide["framework"]
        Name       = FrameWork["name"]
        if Name != "application":
            continue
        Custom     = get_obj(SysWide, "custom")
        hosts      = get_obj(Custom, "tohosts")
        item       = get_obj(hosts,  "tohost")
        print item.replace('\n', ',')
        break
 
def get_sys_cfg(Key, Dft):
    SysFile = get_sys_file()
    CnfFile = converted_file(SysFile)

    #something special
    if Key == "system/cert":
        JsonObjs = load_json(SysFile)
        get_sys_cert(JsonObjs)
        return
    if Key == "system/application/tohosts/tohost" or Key == "system/application/tohosts":
        JsonObjs = load_json(SysFile)
        get_sys_hosts(JsonObjs)
        return
    #end
       
    if os.path.exists(CnfFile) == False:
        JsonObjs = load_json(SysFile)
        FpCnf    = open(CnfFile, "w")
        dump_ball(FpCnf, JsonObjs)
        FpCnf.close()

    Key = Key + "="
    Val = Dft
    Fpr = open(CnfFile, "r")
    for line in Fpr.readlines():
        line = line.rstrip()
        if line.startswith(Key):
            Val = line[len(Key):]
            break
    Fpr.close()
    Val0  = strip_value(Val)
    Val1 = Val0.replace('\n', ',')
    print Val1
    
def get_dev_modules(DevIP):
    ModulePath = get_dev_module_path(DevIP)
    if os.path.exists(ModulePath) == False:
        return ''

    list = os.listdir(ModulePath)
    Roles='' #'"'
    for line in list:
        Ext = os.path.splitext(line)[1] 
        if Ext == '.json':
            filepath = os.path.join(ModulePath, line)
            JsonObjs = get_module_obj(filepath)
            Name     = JsonObjs["name"]  
            Role     = JsonObjs["role"]  
            if Role == "database": #we put database as the first
                Roles = Name + "::" + Role + " " + Roles
            else:
                Roles = Roles + Name + "::" + Role + " "
    #Roles = Roles + '"'
    print Roles

def get_dev_rolename(Key, Type):
    ModulePath = get_dev_module_path("")
    if os.path.exists(ModulePath) == False:
        return ''

    Ret = ''
    list = os.listdir(ModulePath)
    for line in list:

        Ext = os.path.splitext(line)[1] 
        if Ext == '.json':
            filepath = os.path.join(ModulePath, line)
            JsonObjs = get_module_obj(filepath)
            Name     = JsonObjs["name"]  
            Role     = JsonObjs["role"]  

            if Type == "role" and Key == Name:
                Ret = Role
                break;

            if Type == "name" and Key == Role:
                Ret = Name
                break;
    return Ret

##############################################
# something special
##############################################
def get_role_ip(Role):
    cfg_path = guess_root_path() + "/config"
    role_len = len(Role)
    role_list= []

    list = os.listdir(cfg_path)
    for line in list:
        if line.startswith('device_') == False:
            continue 

        modulepath = cfg_path + "/" + line + "/module"
        if os.path.exists(modulepath) == False:
            continue

        # all modules
        modules = os.listdir(modulepath)
        for module in modules:
            filepath = modulepath + "/" +  module
            JsonObjs = get_module_obj(filepath)
            role     = JsonObjs["role"]  

            if role == Role:
                role_name=JsonObjs["name"]  
                ip = line[len('device_'):]
                print role_name, ip

def get_dev_list():
    cfg_path = guess_root_path() + "/config"
    list = os.listdir(cfg_path)
    for line in list:
        if line.startswith('device_') == False:
            continue 

        devicefile = cfg_path + "/" + line + "/" + line + ".json"
        if os.path.exists(devicefile) == False:
           continue

        JsonObjs = load_json(devicefile)
        ip     = JsonObjs["ip"]
        passwd = JsonObjs["password"]
 
        modulepath = cfg_path + "/" + line + "/module"
        if os.path.exists(modulepath) == False:
            continue

        # all modules
        modules = os.listdir(modulepath)
        rolelist = "" 
        for module in modules:
            filepath = modulepath + "/" +  module
            JsonObjs = get_module_obj(filepath)
            role_name=JsonObjs["name"]  
            if rolelist == "":
                rolelist = role_name
            else:
                rolelist = rolelist + "," + role_name

        print ip, passwd, rolelist
    return 


def get_role_list(Role, Type):
    cfg_path = guess_root_path() + "/config"
    role_len = len(Role)
    role_list= []
    resu_list= []

    list = os.listdir(cfg_path)
    for line in list:
        if line.startswith('device_') == False:
            continue 

        modulepath = cfg_path + "/" + line + "/module"
        if os.path.exists(modulepath) == False:
            continue

        # all modules
        modules = os.listdir(modulepath)
        for module in modules:
            filepath = modulepath + "/" +  module
            JsonObjs = get_module_obj(filepath)
            role     = JsonObjs["role"]  

            if role == Role or Role == "all":
                if Type == "name": 
                    role_name=JsonObjs["name"]  
                    #sort by number
                    if Role == "all":
                        role_list.append(role_name)
                    else:
                        role_numb=role_name[role_len:]
                        role_list.append(int(role_numb))
                else:
                    ip = line[len('device_'):]
                    role_list.append(ip)

    #notice, name list should be in pattern like: database2, database13...
    role_list.sort()
    for item in role_list:
        if Type == "name": 
            if Role == "all": 
                resu_list.append(item)
            else:
                resu_list.append(Role+str(item))
        else:
            resu_list.append(item)

    return resu_list

##############################################
def get_dev_cfg(DevIP, Key, Dft):
    if Key == "device/roles" or Key == "device/modules":
        get_dev_modules(DevIP)
        return

    if Key.startswith("device/list"):
        get_dev_list()
        return

    if Key.startswith("device/dockerip/"):
        role = Key[len("device/dockerip/"):] 
        Ret = get_role_ip(role)
        return

    if Key.startswith("device/rolename/"):
        role = Key[len("device/rolename/"):] 
        Ret = get_dev_rolename(role, "name")
        print Ret
        return

    if Key.startswith("device/roletype/"):
        role = Key[len("device/roletype/"):] 
        Ret = get_dev_rolename(role, "role")
        print Ret
        return

    if Key.startswith("device/iplist/"):
        role = Key[len("device/iplist/"):] 
        re_list = get_role_list(role, "ip")
        for item in re_list:
            print item
        return

    if Key.startswith("device/namelist/"):
        role = Key[len("device/namelist/"):] 
        re_list = get_role_list(role, "name")
        for item in re_list:
            print item
        return

    DevFile = get_dev_file(DevIP)
    CnfFile = converted_file(DevFile)
    if os.path.exists(CnfFile) == False:
        JsonObjs = load_json(DevFile)
        FpCnf    = open(CnfFile, "w")
        dump_objs(FpCnf, JsonObjs, "device")
        FpCnf.close()

    Key = Key + "="
    Val = Dft
    Fpr = open(CnfFile, "r")
    for line in Fpr.readlines():
        line = line.rstrip()
        if line.startswith(Key):
            Val = line[len(Key):]
            break
    Fpr.close()
    print strip_value(Val)
 

####################################################
#module
####################################################
def get_module_ip(Name):
    subnet = get_run_cfg("system/network/subnet")
    ippart = subnet.split(".")
    result = ''

    namelist = get_role_list("all", "name")
    i = 1
    for item in namelist:
        if item == Name:
            result = "%s.%s.%s.%d" %(ippart[0], ippart[1], ippart[2], i)
            break;
        i = i + 1 
   
    return result

def get_module_cfg(Key, Dft):
    ModulePath = get_dev_module_path("")
    if os.path.exists(ModulePath) == False:
        return

    Ret = ''

    if Key.startswith("module/ip/"):
        name = Key[len("module/ip/"):] 
        Ret = get_module_ip(name)

    if Key.startswith("module/port/"):
        localip = get_local_ip()
        name = Key[len("module/port/"):] 
        role = get_dev_rolename(name, "role")
        filepath = ModulePath + "/%s_%s.json" %(role, name)
        JsonObjs = get_module_obj(filepath)
        portmaps = get_obj(JsonObjs, "portMap")
        if portmaps is not None:
            for portm in portmaps:
                portin   = portm["inside"]
                portout  = portm["outside"]
                Ret = Ret + "-p %s:%s:%s " %(localip, portout, portin)

    if Key.startswith("module/dirmap/"):
        name = Key[len("module/dirmap/"):]
        role = get_dev_rolename(name, "role")
        filepath = ModulePath + "/%s_%s.json" %(role, name)
        JsonObjs = get_module_obj(filepath)
        portmaps = get_obj(JsonObjs, "dirMap")
        if portmaps is not None:
            for portm in portmaps:
                portin   = portm["inside"]
                portout  = portm["outside"]
                Ret = Ret + "-v %s:%s " %(portout, portin)

    if Key.startswith("module/s3/role"):
        Name = get_dev_rolename('objectstorage', "name")
        filepath = ModulePath + "/objectstorage_%s.json" %(Name)
        JsonObjs = get_module_obj(filepath)
        roles    = JsonObjs["roles"]  
        for role in roles:
            Ret = Ret + " " + role["type"]["name"]

    if Key.startswith("module/s3/"):
        cfg_path = guess_root_path() + "/config"
        s3role = Key[len("module/s3/"):] 

        list = os.listdir(cfg_path)
        for line in list:
            if line.startswith('device_') == False:
                continue 

            fullpath = cfg_path + "/" + line
            if os.path.isdir(fullpath) == False:
                continue

            modulepath = fullpath + "/module"
            if os.path.exists(modulepath) == False:
                continue

            # all modules
            modules = os.listdir(modulepath)
            for module in modules:

                if module.startswith("objectstorage") == False:
                    continue;

                filepath = modulepath + "/" +  module
                JsonObjs = get_module_obj(filepath)
                roles    = JsonObjs["roles"]  

                for role in roles:
                    if role["type"]["name"] == s3role:
                        Nam = JsonObjs["name"]
                        if Ret == '':
                            Ret = Nam 
                        else:
                            Ret = Ret + "\n" + Nam
    print Ret

def get_run_cfg(Key):
    CnfFile = get_runtime_file()
    Key = Key + "="
    Val = None
    Fpr = open(CnfFile, "r")
    for line in Fpr.readlines():
        line = line.rstrip()
        if line.startswith(Key):
            Val = line[len(Key):]
            break
    Fpr.close()
    return Val
 
##############################################
def unit_test():
    print get_sys_file()
    print get_dev_module_path("")
    print get_dev_file("")
    get_sys_cfg("system/application/domain", None)
    get_dev_cfg("", "device/roles", None)
    print get_run_cfg("system/redis/host")
    get_role_list("database", "ip")
    get_role_list("application", "name")
    get_dev_cfg("", "device/iplist/database", "")
    get_dev_cfg("", "device/namelist/application", "")


if __name__ == "__main__":
    if len(sys.argv) == 1:
        print "what is the key?"
        exit(1)

    key = sys.argv[1]

    #runtime cfg in the highest priority
    val = get_run_cfg(key)
    if val is not None:
        print val
        exit (0)
 
    #there is a default value
    default_val = ""
    if len(sys.argv) > 2:
        default_val = sys.argv[2]

    #start parsing file
    key_list = key.split("/") 
    cfg_type = key_list[0]

    #system config
    if cfg_type == "system":
        get_sys_cfg(key, default_val)

    #device config
    elif cfg_type == "device":
        dev_ip = ""
        if len(sys.argv) > 3:
            dev_ip = sys.argv[3]
        get_dev_cfg(dev_ip, key, default_val)

    #container config
    elif cfg_type == "module":
        get_module_cfg(key, default_val)

    #unit test
    elif cfg_type == "test":
         unit_test()

    else:
        print default_val
