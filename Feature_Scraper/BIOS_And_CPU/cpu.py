import psutil

# Return system CPU times as a named tuple
"""
scputimes(user=5434.58, nice=843.75, system=1901.28, idle=166600.49, iowait=52.51, irq=0.0, softirq=463.14, steal=0.0, guest=0.0, guest_nice=0.0)
"""
print(psutil.cpu_times())

# Return a float representing the current system-wide CPU utilization as a percentage. 
"""
1.2
"""
print(psutil.cpu_percent())

# Same as cpu_percent() but provides utilization percentages for each specific CPU time as is returned by psutil.cpu_times(percpu=True).
"""
scputimes(user=0.0, nice=0.0, system=0.0, idle=0.0, iowait=0.0, irq=0.0, softirq=0.0, steal=0.0, guest=0.0, guest_nice=0.0)
"""
print(psutil.cpu_times_percent())

# Return the number of logical CPUs in the system (same as os.cpu_count in Python 3.4) or None if undetermined. 
"""
16
"""
print(psutil.cpu_count())

# Return various CPU statistics as a named tuple
"""
scpustats(ctx_switches=183933409, interrupts=66986829, soft_interrupts=23829832, syscalls=0)
"""
print(psutil.cpu_stats())

# Return CPU frequency as a named tuple including current, min and max frequencies expressed in Mhz. 
"""
scpufreq(current=2024.5329375, min=1400.0, max=2900.0)
"""
print(psutil.cpu_freq())

# Return the average system load over the last 1, 5 and 15 minutes as a tuple. 
"""
(3.85, 3.81, 3.85)
"""
print(psutil.getloadavg())