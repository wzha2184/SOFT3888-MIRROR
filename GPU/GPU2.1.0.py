import igpu

def get_count():
    print(f'This host has {igpu.count_devices()} devices.')
    return igpu.count_devices()


def get_all_gpu_info():
    for i in range(get_count()):
        get_gpu_info(i)
        get_gpu_memory(i)
        get_gpu_power(i)
        get_gpu_frequency(i)


def get_gpu_info(num):
    gpu = igpu.get_device(num)
    for gpu_info in igpu.devices():
        print("UUID: " + str(gpu_info.uuid))
        print("BIOS: " + str(gpu_info.bios))
        print(f'GPU board {gpu_info.index}: {gpu_info.name}')
        print(f'Utilization: GPU {gpu_info.utilization.gpu}% | Memory {gpu_info.utilization.memory}%')
        print(f'Temperature: {gpu_info.utilization.temperature}C (Fan - {gpu_info.utilization.fan}%)')
        print()

 

def get_gpu_memory(num):
    gpu_info = igpu.get_device(num)
    print("Memory: " + str(gpu_info.memory))
    
def get_gpu_power(num):
    gpu_info = igpu.get_device(num)
    print("Memory: " + str(gpu_info.power))

def get_gpu_frequency(num):
    gpu_info = igpu.get_device(num)
    print("The current frequency of graphics (shader) clock: "+ str(gpu_info.clocks.graphics))
    print("The current frequency of SM (Streaming Multiprocessor) clock: "+ str(gpu_info.clocks.sm))
    print("The current frequency of memory clock: " + str(gpu_info.clocks.memory))
    print("The maximum frequency of graphics (shader) clock: " + str(gpu_info.clocks.max_graphics))
    print("The maximum frequency of SM (Streaming Multiprocessor) clock: " + str(gpu_info.clocks.max_sm))
    print("The maximum frequency of memory clock" + str(gpu_info.clocks.max_memory))
    print("The clock unit of measurement" + str(gpu_info.clocks.unit))





