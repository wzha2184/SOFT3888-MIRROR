import igpu
import json
from pynvml import *


class GPUScraper:
    def __init__(self) -> None:
        nvmlInit()
        self.result = {}

    def get_count(self) -> int:
        return igpu.count_devices()

    def get_gpu_result(self) -> dict:
        self.get_all_gpu_result()
        return self.result

    def get_gpu_info(self, num) -> None:
        gpu = igpu.get_device(num)
        self.result[str(num + 1)]["UUID"] = str(gpu.uuid)
        self.result[str(num + 1)]["BIOS"] = str(gpu.bios)
        self.result[str(num + 1)]["Name"] = str(gpu.name)
        self.result[str(num + 1)]["Temperature"] = str(gpu.utilization.temperature)
    
    def get_gpu_memory(self, num) -> None:
        gpu_info = igpu.get_device(num)
        self.result[str(num + 1)]["totalMemory"] = str(gpu_info.memory.total)
        self.result[str(num + 1)]["usedMemory"] = str(gpu_info.memory.used)
        self.result[str(num + 1)]["freeMemory"] = str(gpu_info.memory.free)
        
    def get_gpu_power(self, num) -> None:
        gpu_info_power = igpu.get_device(num).power
        self.result[str(num + 1)]["power"] = str(gpu_info_power.draw)
        self.result[str(num + 1)]["limitPower"] = str(gpu_info_power.limit)
        self.result[str(num + 1)]["minLimitPower"] = str(gpu_info_power.min_limit)
        self.result[str(num + 1)]["maxLimitPower"] = str(gpu_info_power.max_limit)

    def get_gpu_frequency(self, num) -> None:
        gpu_info = igpu.get_device(num)
        self.result[str(num + 1)]["graphicsFrequency"] = str(gpu_info.clocks.graphics)
        self.result[str(num + 1)]["StreamingMultiprocessorFrequency"] = str(gpu_info.clocks.sm)
        self.result[str(num + 1)]["memoryFrequency"] = str(gpu_info.clocks.memory)
        self.result[str(num + 1)]["MaxgraphicsFrequency"] = str(gpu_info.clocks.max_graphics)
        self.result[str(num + 1)]["MaxStreamingMultiprocessorFrequency"] = str(gpu_info.clocks.max_sm)
        self.result[str(num + 1)]["MaxmemoryFrequency"] = str(gpu_info.clocks.max_memory)

    def get_gpu_fan(self, num) -> None:
        gpu_info = igpu.get_device(num)
        try:
            handle = nvmlDeviceGetHandleByIndex(num)
            fan_speed = nvmlDeviceGetFanSpeed(handle)
            self.result[str(num + 1)]["fanSpeed"] = fan_speed
        except:
            self.result[str(num + 1)]["fanSpeed"] = "0"

    def get_all_gpu_result(self) -> None:
        self.result["GPU_count"] = self.get_count()
        for i in range(self.get_count()):
            self.result[str(i + 1)] = {}
            try:
                self.get_gpu_info(i)
                self.get_gpu_memory(i)
                self.get_gpu_power(i)
                self.get_gpu_frequency(i)
                self.get_gpu_fan(i)
                self.result[str(i + 1)]["status"] = "OK"
            except:
                self.result[str(i + 1)]["status"] = "error - Problem occurred when scraping data from GPU"


if __name__ == "__main__":
    gpu = GPUScraper()
    print(json.dumps(gpu.get_gpu_result(), indent=2))
