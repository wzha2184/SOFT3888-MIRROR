import igpu

class GPUScraper:
    def __init__(self) -> None:
        self.result = {}
        self.result["GPU"] = {}

    def get_count(self) -> int:
        return igpu.count_devices()

    def get_gpu_result(self) -> dict:
        return self.result

    def get_gpu_info(self, num) -> None:
        gpu = igpu.get_device(num)
        self.result["GPU"]["GPU" + str(num)]["UUID"] = str(gpu.uuid)
        self.result["GPU"]["GPU" + str(num)]["BIOS"] = str(gpu.bios)
        self.result["GPU"]["GPU" + str(num)]["Name"] = str(gpu.name)
        self.result["GPU"]["GPU" + str(num)]["Utilization_GPU"] = str(gpu.utilization.gpu)
        self.result["GPU"]["GPU" + str(num)]["Utilization_Memory"] = str(gpu.utilization.memory)
        self.result["GPU"]["GPU" + str(num)]["Temperature"] = str(gpu.utilization.temperature)
    
    def get_gpu_memory(self, num) -> None:
        gpu_info = igpu.get_device(num)
        self.result["GPU"]["GPU" + str(num)]["totalMemory"] = str(gpu_info.memory.total)
        self.result["GPU"]["GPU" + str(num)]["usedMemory"] = str(gpu_info.memory.used)
        self.result["GPU"]["GPU" + str(num)]["freeMemory"] = str(gpu_info.memory.free)
        
    def get_gpu_power(self, num) -> None:
        gpu_info_power = igpu.get_device(num).power
        self.result["GPU"]["GPU" + str(num)]["power"] = str(gpu_info_power.draw)
        self.result["GPU"]["GPU" + str(num)]["limitPower"] = str(gpu_info_power.limit)
        self.result["GPU"]["GPU" + str(num)]["minLimitPower"] = str(gpu_info_power.min_limit)
        self.result["GPU"]["GPU" + str(num)]["maxLimitPower"] = str(gpu_info_power.max_limit)

    def get_gpu_frequency(self, num) -> None:
        gpu_info = igpu.get_device(num)
        self.result["GPU"]["GPU" + str(num)]["graphicsFrequency"] = str(gpu_info.clocks.graphics)
        self.result["GPU"]["GPU" + str(num)]["StreamingMultiprocessorFrequency"] = str(gpu_info.clocks.sm)
        self.result["GPU"]["GPU" + str(num)]["memoryFrequency"] = str(gpu_info.clocks.memory)
        self.result["GPU"]["GPU" + str(num)]["MaxgraphicsFrequency"] = str(gpu_info.clocks.max_graphics)
        self.result["GPU"]["GPU" + str(num)]["MaxStreamingMultiprocessorFrequency"] = str(gpu_info.clocks.max_sm)
        self.result["GPU"]["GPU" + str(num)]["MaxmemoryFrequency"] = str(gpu_info.clocks.max_memory)

    def get_all_gpu_result(self) -> dict:
        self.result["GPU"]["GPU_count"] = self.get_count()
        for i in range(self.get_count()):
            self.get_gpu_info(i)
            self.get_gpu_memory(i)
            self.get_gpu_power(i)
            self.get_gpu_frequency(i)