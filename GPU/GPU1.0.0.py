from pynvml import *
nvmlInit()
print("Driver: ", nvmlSystemGetDriverVersion()) 
deviceCount = nvmlDeviceGetCount()
for i in range(deviceCount):
    handle = nvmlDeviceGetHandleByIndex(i)
    print("GPU", i, ":", nvmlDeviceGetName(handle))

handle = nvmlDeviceGetHandleByIndex(0)
info = nvmlDeviceGetMemoryInfo(handle)
print("Memory Total: ",info.total)
print("Memory Free: ",info.free)
print("Memory Used: ",info.used)

print("Temperature is %d C"%nvmlDeviceGetTemperature(handle,0))
print("Fan speed is ",nvmlDeviceGetFanSpeed(handle))
print("Power status",nvmlDeviceGetPowerState(handle))



nvmlShutdown()



