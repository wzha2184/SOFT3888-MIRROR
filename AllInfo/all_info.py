"""
{
  "CPUandBIOS": {
    "critical_sensors": {
      "CPU_FAN": "1000RPM",
      "CPU_OPT": "1200RPM"
    },
    "descrete_sensors": {
      "CPU_ECC": "Presence Detected",
      "Memory_Train_ERR": "N/A",     
      "Watchdog2": "N/A"
    },
    "normal_sensors": {
      "+12V": "12.120 Volts",        
      "+3.3V": "3.328 Volts",        
      "+3.3V_ALW": "3.312 Volts",    
      "+5V": "5.064 Volts",
      "+5V_ALW": "5.016 Volts",      
      "+CPU_1.8V": "1.770 Volts",    
      "+CPU_1.8V_S5": "1.810 Volts", 
      "+CPU_3.3V": "3.424 Volts",    
      "+PCH_CLDO": "1.182 Volts",    
      "+VCORE": "1.392 Volts",       
      "+VDDIO_ABCD": "1.230 Volts",
      "+VDDIO_EFGH": "1.230 Volts",
      "+VSOC": "1.044 Volts",
      "CHIPSET_FAN": "1900 RPM",
      "CPU Temp.": "54 \u00b0C",
      "LAN Temp.": "58 \u00b0C",
      "SOC_FAN": "2300 RPM",
      "VBAT": "3.280 Volts"
    },
    "cpu_freq": {
      "cpu_current_freq": 2199.8740937499997,
      "cpu_min_freq": 2200.0,
      "cpu_max_freq": 3900.0
    },
    "baseboard-serial-number": "210686206000109",
    "On Board Devices": {
      "Device 1": {
        "Type": "Video",
        "Status": "Enabled",
        "Description": "   To Be Filled By O.E.M."
      }
    },
    "PCIe information": {
      "System Slot  1": {
        "Designation": "PCIEX16_1",
        "Type": "x16 PCI Express",
        "Current Usage": "In Use",
        "Length": "Long",
        "ID": "0",
        "Characteristics": "3.3 V is provided, Opening is shared, PME signal is supported",
        "Bus Address": "0000:00:00.0"
      },
      "System Slot  2": {
        "Designation": "PCIEX16_2",
        "Type": "x8 PCI Express",
        "Current Usage": "In Use",
        "Length": "Long",
        "ID": "1",
        "Characteristics": "3.3 V is provided, Opening is shared, PME signal is supported",
        "Bus Address": "0000:00:00.0"
      },
      "System Slot  3": {
        "Designation": "PCIEX16_3",
        "Type": "x16 PCI Express",
        "Current Usage": "In Use",
        "Length": "Long",
        "ID": "2",
        "Characteristics": "3.3 V is provided, Opening is shared, PME signal is supported",
        "Bus Address": "0000:00:00.0"
      },
      "System Slot 4": {
        "Designation": "PCIEX16_4",
        "Type": "x8 PCI Express",
        "Current Usage": "In Use",
        "Length": "Long",
        "ID": "3",
        "Characteristics": "3.3 V is provided, Opening is shared, PME signal is supported\n\t",
        "Bus Address": "0000:00:00.0"
      }
    }
  },
  "GPU": {
    "GPU_count": 2,
    "GPU0": {
      "GPU_info": {
        "UUID": "GPU-f11c8a14-3c9b-48e8-8c02-7da2495d17ee",
        "BIOS": "94.02.42.C0.05",
        "Name": "NVIDIA GeForce RTX 3090",
        "Utilization_GPU": "0.0",
        "Utilization_Memory": "0.0",
        "Temperature": "51.0"
      },
      "GPU_memory": {
        "totalMemory": "24576.0",
        "usedMemory": "307.8125",
        "freeMemory": "24268.1875"
      },
      "GPU_power": {
        "power": "41.541",
        "limitPower": "420.0",
        "minLimitPower": "100.0",
        "maxLimitPower": "450.0"
      },
      "get_gpu_frequency": {
        "graphicsFrequency": "210.0",
        "StreamingMultiprocessorFrequency": "210.0",
        "memoryFrequency": "405.0",
        "MaxgraphicsFrequency": "2100.0",
        "MaxStreamingMultiprocessorFrequency": "2100.0",
        "MaxmemoryFrequency": "9751.0"
      }
    },
    "GPU1": {
      "GPU_info": {
        "UUID": "GPU-5caf1987-9e67-8051-0080-9384b24a66db",
        "BIOS": "94.02.42.C0.05",
        "Name": "NVIDIA GeForce RTX 3090",
        "Utilization_GPU": "0.0",
        "Utilization_Memory": "0.0",
        "Temperature": "45.0"
      },
      "GPU_memory": {
        "totalMemory": "24576.0",
        "usedMemory": "307.8125",
        "freeMemory": "24268.1875"
      },
      "GPU_power": {
        "power": "32.609",
        "limitPower": "420.0",
        "minLimitPower": "100.0",
        "maxLimitPower": "450.0"
      },
      "get_gpu_frequency": {
        "graphicsFrequency": "210.0",
        "StreamingMultiprocessorFrequency": "210.0",
        "memoryFrequency": "405.0",
        "MaxgraphicsFrequency": "2100.0",
        "MaxStreamingMultiprocessorFrequency": "2100.0",
        "MaxmemoryFrequency": "9751.0"
      }
    }
  }
}
"""

import igpu
from selenium import webdriver
from time import sleep
from selenium.webdriver.common.by import By
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC
from selenium import webdriver
from webdriver_manager.chrome import ChromeDriverManager
import json
from logging import critical
from unicodedata import decimal
from bs4 import BeautifulSoup
import psutil
import subprocess
import re

options = webdriver.ChromeOptions()
options.add_argument('--no-sandbox')
options.add_argument('ignore-certificate-errors')
options.add_argument('--headless')
options.add_argument('--disable-dev-shm-usage')
driver = webdriver.Chrome(ChromeDriverManager().install(), options=options)
driver.get('https://192.168.10.108/#login')
name = WebDriverWait(driver, 20).until(EC.presence_of_element_located((By.ID, "userid")))
name.send_keys("admin")
password = WebDriverWait(driver, 20).until(EC.presence_of_element_located((By.ID, "password")))
password.send_keys("admin")
submit = WebDriverWait(driver, 20).until(EC.presence_of_element_located((By.ID, "btn-login")))
submit.click()
sleep(15)

driver.get('https://192.168.10.108/#sensors')
sleep(10)
pageSource = driver.page_source
# print(pageSource)
html_doc = str(pageSource)
result = {}
result["critical_sensors"] = {}
result["descrete_sensors"] = {}
result["normal_sensors"] = {}

soup = BeautifulSoup(html_doc, 'html.parser')
critical_sensors = None
descrete_sensors = None
normal_sensors = None

info = soup.find_all("div")
for div in info:
    if div.get("class") is not None and " ".join(div.get("class")) == "row animated fadeInUp":
        critical_sensors = div
    elif div.get("class") is not None and " ".join(div.get("class")) == "row animated fadeInUp delay-0":
        descrete_sensors = div
    elif div.get("class") is not None and " ".join(div.get("class")) == "row animated fadeInUp delay-1":
        normal_sensors = div

# Critical sensors(CPU)
CPU_info = critical_sensors.find_all("div")
name = None
value = None
for div in CPU_info:
    if " ".join(div.get("class")) == "percentage":
        value = div.text
    if " ".join(div.get("class")) == "sensor-title":
        name = div.text

    if name is not None and value is not None:
        result["critical_sensors"][name] = value
        name = None
        value = None

# Descrete sensors
descrete_info = descrete_sensors.find_all("tr")
for row in descrete_info:
    state = []
    for col in row.find_all("td"):
        if col.get("class") is None or "".join(col.get("class")) != "hide":
            state.append(col.text.strip())
        if len(state) == 2:
            result["descrete_sensors"][state[0]] = state[1]
            state = []

normal_info = normal_sensors.find_all("tr")
for row in normal_info:
    state = []
    for col in row.find_all("td"):
        state.append(col.text.strip())
        if len(state) == 2:
            result["normal_sensors"][state[0]] = state[1]
            state = []

# Return CPU frequency as a named tuple including current, min and max frequencies expressed in Mhz.
"""
scpufreq(current=2024.5329375, min=1400.0, max=2900.0)
"""
cpu_freq = str(psutil.cpu_freq()).split(', ')
cpu_current_freq = float(cpu_freq[0][17:])
cpu_min_freq = float(cpu_freq[1][4:])
cpu_max_freq = float(cpu_freq[2][4:-2])
result["cpu_freq"] = {}
result["cpu_freq"]["cpu_current_freq"] = cpu_current_freq
result["cpu_freq"]["cpu_min_freq"] = cpu_min_freq
result["cpu_freq"]["cpu_max_freq"] = cpu_max_freq

# Baseboard (Motherboard) serial number
result["baseboard-serial-number"] =subprocess.check_output('sudo dmidecode -s baseboard-serial-number'.split(' ')).decode().strip()

# On Board Devices
result['On Board Devices'] = {}
devices = subprocess.check_output('sudo dmidecode -t 10'.split(' ')).decode()
if not ("Type" in devices):
    pass
else:
    types = [m.start() for m in re.finditer('Type', devices)]
    next_start = [m.start() for m in re.finditer('On Board Device', devices)]
    for i in range(0, len(types) - 1):
        device = "Device " + str(i + 1)
        result['On Board Devices'][device] = {}
        attributes = devices[types[i]:next_start[i + 1]].strip().split("\n\t")
        for attribute in attributes:
            key = attribute.split(": ")[0]
            value = attribute.split(": ")[1]
            result['On Board Devices'][device][key] = value
    last_device = "Device " + str(len(types))
    result['On Board Devices'][last_device] = {}
    attributes = devices[types[-1]:].strip().split("\n\t")
    for attribute in attributes:
        key = attribute.split(": ")[0]
        value = attribute.split(": ")[1]
        result['On Board Devices'][last_device][key] = value

# System Slots (PCIe versions)
s = subprocess.check_output('sudo dmidecode -t 9'.split(' ')).decode()
result['PCIe information'] = {}
slots = subprocess.check_output('sudo dmidecode -t 9'.split(' ')).decode()
if not ('Designation' in slots):
    pass
else:
    designations = [m.start() for m in re.finditer('Designation', s)]
    characteristics = [m.start() for m in re.finditer('Characteristics', s)]
    bus_addresses = [m.start() for m in re.finditer('Bus Address', s)]
    next_start = [m.start() for m in re.finditer('Handle ', s)]
    for i in range(0, len(designations) - 1):
        slot = "System Slot  " + str(i + 1)
        result['PCIe information'][slot] = {}
        first_five = s[designations[i]:characteristics[i]].strip().split("\n\t")
        for attribute in first_five:
            key = attribute.split(": ")[0]
            value = attribute.split(": ")[1]
            result['PCIe information'][slot][key] = value
        chars = s[characteristics[i]:bus_addresses[i]].strip().split('\n\t\t')
        chars1 = ''
        for j in range (1, len(chars)):
            chars1 += chars[j] + ", "
        if len(chars1) > 0:
            chars1 = chars1[:-2]
        result['PCIe information'][slot]['Characteristics'] = chars1
        bus_address = s[bus_addresses[i]:next_start[i + 1]].strip().split(": ")
        result['PCIe information'][slot][bus_address[0]] = bus_address[1]
    slot = "System Slot " + str(len(designations))
    result['PCIe information'][slot] = {}
    first_five = s[designations[-1]:characteristics[-1]].strip().split("\n\t")
    for attribute in first_five:
        key = attribute.split(": ")[0]
        value = attribute.split(": ")[1]
        result['PCIe information'][slot][key] = value
    chars = s[characteristics[-1]:bus_addresses[-1]].split('\n\t\t')
    chars1 = ''
    for j in range (1, len(chars)):
        chars1 += chars[j] + ", "
    if len(chars1) > 0:
        chars1 = chars1[:-2]
    result['PCIe information'][slot]['Characteristics'] = chars1
    bus_address = s[bus_addresses[-1]:].strip().split(": ")
    result['PCIe information'][slot][bus_address[0]] = bus_address[1]

def get_count():
    return igpu.count_devices()

def get_gpu_info(num):
    result = {}
    gpu = igpu.get_device(num)
    result["UUID"] = str(gpu.uuid)
    result["BIOS"] = str(gpu.bios)
    result["Name"] = str(gpu.name)
    result["Utilization_GPU"] = str(gpu.utilization.gpu)
    result["Utilization_Memory"] = str(gpu.utilization.memory)
    result["Temperature"] = str(gpu.utilization.temperature)
    return result

 

def get_gpu_memory(num):
    gpu_info = igpu.get_device(num)
    result = {}
    result["totalMemory"] = str(gpu_info.memory.total)
    result["usedMemory"] = str(gpu_info.memory.used)
    result["freeMemory"] = str(gpu_info.memory.free)
    return result
    
def get_gpu_power(num):
    result = {}
    gpu_info_power = igpu.get_device(num).power
    result["power"] = str(gpu_info_power.draw)
    result["limitPower"] = str(gpu_info_power.limit)
    result["minLimitPower"] = str(gpu_info_power.min_limit)
    result["maxLimitPower"] = str(gpu_info_power.max_limit)
    return result

def get_gpu_frequency(num):
    result = {}
    gpu_info = igpu.get_device(num)
    result["graphicsFrequency"] = str(gpu_info.clocks.graphics)
    result["StreamingMultiprocessorFrequency"] = str(gpu_info.clocks.sm)
    result["memoryFrequency"] = str(gpu_info.clocks.memory)
    result["MaxgraphicsFrequency"] = str(gpu_info.clocks.max_graphics)
    result["MaxStreamingMultiprocessorFrequency"] = str(gpu_info.clocks.max_sm)
    result["MaxmemoryFrequency"] = str(gpu_info.clocks.max_memory)
    return result

def getGPUJsonString():
    GPUResult = {}
    GPUResult["GPU_count"] = get_count()
    for i in range(get_count()):
        GPUResult["GPU" + str(i)] = {}
        GPUResult["GPU" + str(i)]["GPU_info"] = get_gpu_info(i)
        GPUResult["GPU" + str(i)]["GPU_memory"] = get_gpu_memory(i)
        GPUResult["GPU" + str(i)]["GPU_power"] = get_gpu_power(i)
        GPUResult["GPU" + str(i)]["get_gpu_frequency"] = get_gpu_frequency(i)
    return GPUResult

all_info = {}
all_info["CPUandBIOS"] = result
all_info["GPU"] = getGPUJsonString()
print(json.dumps(all_info, indent=2))


# Haven't finished hardware control part

# For the current logging, we may use lm-sensors in the future
