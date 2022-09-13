import igpu
import json
from pynvml import *


class GPUScraper:
    def __init__(self) -> None:
        nvmlInit()

        self.result = {}
        self.result["GPU"] = {}

    def get_count(self) -> int:
        return igpu.count_devices()

    def get_gpu_result(self) -> dict:
        self.get_all_gpu_result()
        return self.result

    def get_gpu_info(self, num) -> None:
        gpu = igpu.get_device(num)
        self.result["GPU"][gpu.uuid] = {}
        self.result["GPU"][gpu.uuid]["UUID"] = str(gpu.uuid)
        self.result["GPU"][gpu.uuid]["BIOS"] = str(gpu.bios)
        self.result["GPU"][gpu.uuid]["Name"] = str(gpu.name)
        self.result["GPU"][gpu.uuid]["Temperature"] = str(gpu.utilization.temperature)
    
    def get_gpu_memory(self, num) -> None:
        gpu_info = igpu.get_device(num)
        self.result["GPU"][gpu_info.uuid]["totalMemory"] = str(gpu_info.memory.total)
        self.result["GPU"][gpu_info.uuid]["usedMemory"] = str(gpu_info.memory.used)
        self.result["GPU"][gpu_info.uuid]["freeMemory"] = str(gpu_info.memory.free)
        
    def get_gpu_power(self, num) -> None:
        uuid = igpu.get_device(num).uuid
        gpu_info_power = igpu.get_device(num).power
        self.result["GPU"][uuid]["power"] = str(gpu_info_power.draw)
        self.result["GPU"][uuid]["limitPower"] = str(gpu_info_power.limit)
        self.result["GPU"][uuid]["minLimitPower"] = str(gpu_info_power.min_limit)
        self.result["GPU"][uuid]["maxLimitPower"] = str(gpu_info_power.max_limit)

    def get_gpu_frequency(self, num) -> None:
        gpu_info = igpu.get_device(num)
        self.result["GPU"][gpu_info.uuid]["graphicsFrequency"] = str(gpu_info.clocks.graphics)
        self.result["GPU"][gpu_info.uuid]["StreamingMultiprocessorFrequency"] = str(gpu_info.clocks.sm)
        self.result["GPU"][gpu_info.uuid]["memoryFrequency"] = str(gpu_info.clocks.memory)
        self.result["GPU"][gpu_info.uuid]["MaxgraphicsFrequency"] = str(gpu_info.clocks.max_graphics)
        self.result["GPU"][gpu_info.uuid]["MaxStreamingMultiprocessorFrequency"] = str(gpu_info.clocks.max_sm)
        self.result["GPU"][gpu_info.uuid]["MaxmemoryFrequency"] = str(gpu_info.clocks.max_memory)

    def get_gpu_fan(self, num) -> None:
        gpu_info = igpu.get_device(num)
        try:
            handle = nvmlDeviceGetHandleByIndex(num)
            fan_speed = nvmlDeviceGetFanSpeed(handle)
            self.result["GPU"][gpu_info.uuid]["fanSpeed"] = fan_speed
        except:
            self.result["GPU"][gpu_info.uuid]["fanSpeed"] = "0"

    def get_all_gpu_result(self) -> None:
        self.result["GPU"]["GPU_count"] = self.get_count()
        for i in range(self.get_count()):
            self.result["GPU"][igpu.get_device(i).uuid] = {}
            self.get_gpu_info(i)
            self.get_gpu_memory(i)
            self.get_gpu_power(i)
            self.get_gpu_frequency(i)
            self.get_gpu_fan(i)


if __name__ == "__main__":
    gpu = GPUScraper()
    print(json.dumps(gpu.get_gpu_result(), indent=2))
