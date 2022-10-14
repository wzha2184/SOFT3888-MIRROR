import re
import psutil
import subprocess


class ShellScraper:
    def __init__(self) -> None:
        self.result = {"CPU": {}, "BIOS": {}}

    def get_shell_result(self) -> dict:
        self.get_all_shell_result()
        return self.result

    def get_all_shell_result(self) -> None:
        self.get_CPU_frequency()
        try:
            self.get_CPU_serial_number()
            self.get_connected_devices()
            self.get_PCIe()
            self.result["BIOS"]["status"] = "OK"
        except:
            self.result["BIOS"]["status"] = "error - Problem occourred when scraping data from BIOS"

    def get_CPU_frequency(self) -> None:
        try:
            # Return CPU frequency as a named tuple including current, min and max frequencies expressed in Mhz.
            """
            scpufreq(current=2024.5329375, min=1400.0, max=2900.0)
            """
            cpu_freq = str(psutil.cpu_freq()).split(', ')
            cpu_current_freq = float(cpu_freq[0][17:])
            cpu_min_freq = float(cpu_freq[1][4:])
            cpu_max_freq = float(cpu_freq[2][4:-2])

            self.result["CPU"]["cpu_freq"] = {}
            self.result["CPU"]["cpu_freq"]["cpu_current_freq"] = cpu_current_freq
            self.result["CPU"]["cpu_freq"]["cpu_min_freq"] = cpu_min_freq
            self.result["CPU"]["cpu_freq"]["cpu_max_freq"] = cpu_max_freq
            self.result["CPU"]["status"] = "OK"
        except:
            self.result["CPU"]["status"] = "error - Problem occourred when scraping data from CPU"

    def get_CPU_serial_number(self) -> None:
        # Baseboard (Motherboard) serial number
        self.result["BIOS"]["baseboard-serial-number"] =subprocess.check_output('sudo dmidecode -s baseboard-serial-number'.split(' ')).decode().strip()

    def get_connected_devices(self) -> None:
        # On Board Devices
        self.result["BIOS"]['On Board Devices'] = {}
        devices = subprocess.check_output('sudo dmidecode -t 10'.split(' ')).decode()
        if not ("Type" in devices):
            pass
        else:
            types = [m.start() for m in re.finditer('Type', devices)]
            next_start = [m.start() for m in re.finditer('On Board Device', devices)]
            for i in range(0, len(types) - 1):
                device = "Device " + str(i + 1)
                self.result["BIOS"]['On Board Devices'][device] = {}
                attributes = devices[types[i]:next_start[i + 1]].strip().split("\n\t")
                for attribute in attributes:
                    key = attribute.split(": ")[0]
                    value = attribute.split(": ")[1]
                    self.result["BIOS"]['On Board Devices'][device][key] = value
            last_device = "Device " + str(len(types))
            self.result["BIOS"]['On Board Devices'][last_device] = {}
            attributes = devices[types[-1]:].strip().split("\n\t")
            for attribute in attributes:
                key = attribute.split(": ")[0]
                value = attribute.split(": ")[1]
                self.result["BIOS"]['On Board Devices'][last_device][key] = value

    def get_PCIe(self) -> None:
        # System Slots (PCIe versions)
        s = subprocess.check_output('sudo dmidecode -t 9'.split(' ')).decode()
        self.result["BIOS"]['PCIe information'] = {}
        slots = subprocess.check_output('sudo dmidecode -t 9'.split(' ')).decode()

        if 'Designation' in slots:
            designations = [m.start() for m in re.finditer('Designation', s)]
            characteristics = [m.start() for m in re.finditer('Characteristics', s)]
            bus_addresses = [m.start() for m in re.finditer('Bus Address', s)]
            next_start = [m.start() for m in re.finditer('Handle ', s)]

            for i in range(0, len(designations) - 1):
                slot = "System Slot  " + str(i + 1)
                self.result["BIOS"]['PCIe information'][slot] = {}
                first_five = s[designations[i]:characteristics[i]].strip().split("\n\t")
                for attribute in first_five:
                    key = attribute.split(": ")[0]
                    value = attribute.split(": ")[1]
                    self.result["BIOS"]['PCIe information'][slot][key] = value

                chars = s[characteristics[i]:bus_addresses[i]].strip().split('\n\t\t')
                chars1 = ''
                for j in range (1, len(chars)):
                    chars1 += chars[j] + ", "
                if len(chars1) > 0:
                    chars1 = chars1[:-2]

                self.result["BIOS"]['PCIe information'][slot]['Characteristics'] = chars1
                bus_address = s[bus_addresses[i]:next_start[i + 1]].strip().split(": ")
                self.result["BIOS"]['PCIe information'][slot][bus_address[0]] = bus_address[1]

            slot = "System Slot " + str(len(designations))
            self.result["BIOS"]['PCIe information'][slot] = {}
            first_five = s[designations[-1]:characteristics[-1]].strip().split("\n\t")
            for attribute in first_five:
                key = attribute.split(": ")[0]
                value = attribute.split(": ")[1]
                self.result["BIOS"]['PCIe information'][slot][key] = value
            chars = s[characteristics[-1]:bus_addresses[-1]].split('\n\t\t')
            chars1 = ''

            for j in range (1, len(chars)):
                chars1 += chars[j] + ", "
            if len(chars1) > 0:
                chars1 = chars1[:-2]

            self.result["BIOS"]['PCIe information'][slot]['Characteristics'] = chars1.strip()
            bus_address = s[bus_addresses[-1]:].strip().split(": ")
            self.result["BIOS"]['PCIe information'][slot][bus_address[0]] = bus_address[1]
    
if __name__ == "__main__":
    shell_scraper = ShellScraper()
    print(shell_scraper.get_shell_result())