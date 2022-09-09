import igpu
import json

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
    gpu_info== igpu.get_device(num)
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
        GPUResult["GPU" + str(i)] = []
        GPUResult["GPU" + str(i)][GPU_info] = get_gpu_info(i)
        GPUResult["GPU" + str(i)][GPU_memory] = get_gpu_memory(i)
        GPUResult["GPU" + str(i)][GPU_power] = get_gpu_power(i)
        GPUResult["GPU" + str(i)][get_gpu_frequency] = get_gpu_frequency(i)
    return GPUResult = {}

print(getGPUJsonString)