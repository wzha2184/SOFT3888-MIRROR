import igpu

gpu_count = igpu.count_devices()
gpu = igpu.get_device(0)
print(f'This host has {gpu_count} devices.')
for gpu_info in igpu.devices():
    print(f'GPU board {gpu_info.index}: {gpu_info.name}')
    print(f'Utilization: GPU {gpu_info.utilization.gpu}% | Memory {gpu_info.utilization.memory}%')
    print(f'Temperature: {gpu_info.utilization.temperature}C (Fan - {gpu_info.utilization.fan}%)')
    print()

gpu_info = igpu.get_device(0)
gpu_info.update()
print("Memory: " + str(gpu_info.memory))
print("Power: " + str(gpu_info.power))
print("UUID: " + str(gpu_info.uuid))
print("BIOS: " + str(gpu_info.bios))

print("The current frequency of graphics (shader) clock: "+ str(gpu_info.clocks.graphics))
print("The current frequency of SM (Streaming Multiprocessor) clock: "+ str(gpu_info.clocks.sm))
print("The current frequency of memory clock: " + str(gpu_info.clocks.memory))
print("The maximum frequency of graphics (shader) clock: " + str(gpu_info.clocks.max_graphics))
print("The maximum frequency of SM (Streaming Multiprocessor) clock: " + str(gpu_info.clocks.max_sm))
print("The maximum frequency of memory clock" + str(gpu_info.clocks.max_memory))
print("The clock unit of measurement" + str(gpu_info.clocks.unit))
