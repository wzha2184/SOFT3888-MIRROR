"""
{
    'GPU_count': 2, 
    'GPU0': {
        'GPU_info': {
            'UUID': 'GPU-f11c8a14-3c9b-48e8-8c02-7da2495d17ee', 
            'BIOS': '94.02.42.C0.05', 
            'Name': 'NVIDIA GeForce RTX 3090', 
            'Utilization_GPU': '0.0', 
            'Utilization_Memory': '0.0', 
            'Temperature': '51.0'
        }, 
        'GPU_memory': {
            'totalMemory': '24576.0', 
            'usedMemory': '307.8125', 
            'freeMemory': '24268.1875'
        }, 
        'GPU_power': {
            'power': '41.608', 
            'limitPower': '420.0', 
            'minLimitPower': '100.0', 
            'maxLimitPower': '450.0'
        }, 
        'get_gpu_frequency': {
            'graphicsFrequency': '210.0', 
            'StreamingMultiprocessorFrequency': '210.0', 
            'memoryFrequency': '405.0', 
            'MaxgraphicsFrequency': '2100.0', 
            'MaxStreamingMultiprocessorFrequency': 
            '2100.0', 
            'MaxmemoryFrequency': '9751.0'
        }
    }, 
    'GPU1': {
        'GPU_info': {
            'UUID': 'GPU-5caf1987-9e67-8051-0080-9384b24a66db', 
            'BIOS': '94.02.42.C0.05', 
            'Name': 'NVIDIA GeForce RTX 3090', 
            'Utilization_GPU': '0.0', 
            'Utilization_Memory': '0.0', 
            'Temperature': '46.0'
        }, 
        'GPU_memory': {
            'totalMemory': '24576.0', 
            'usedMemory': '307.8125', 
            'freeMemory': '24268.1875'
        }, 
        'GPU_power': {
            'power': '32.818', 
            'limitPower': '420.0', 
            'minLimitPower': '100.0', 
            'maxLimitPower': '450.0'
        }, 
        'get_gpu_frequency': {
            'graphicsFrequency': '210.0', 
            'StreamingMultiprocessorFrequency': '210.0', 
            'memoryFrequency': '405.0', 
            'MaxgraphicsFrequency': '2100.0', 
            'MaxStreamingMultiprocessorFrequency': '2100.0', 
            'MaxmemoryFrequency': '9751.0'
        }
    }
}
"""
import igpu
import json
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

print(getGPUJsonString())