import os
from web_scraper import run_web_scraper

config = os.path.join("..", "config.json")
result = run_web_scraper(config)

assert 'sc9' in result['BMC']
print("Check sc9 keyword in output -- OK")
assert 'sc10' in result['BMC']
print("Check sc10 keyword in output -- OK")

assert 'status' in result['BMC']['sc10']
print("Check status of sc10 BMC -- OK")
if result['BMC']['sc10']['status'] == 'OK':
    target_attributes = ['CPU_FAN', "CPU_ECC", "Memory_Train_ERR", 'Watchdog2', '+12V', '+3.3V', '+3.3V_ALW', "+5V", "+5V_ALW", '+CPU_1.8V', '+CPU_1.8V_S5', '+CPU_3.3V', "+PCH_CLDO", '+VCORE', '+VDDIO_ABCD', '+VDDIO_EFGH', '+VSOC', 'CHIPSET_FAN', "CPU Temp.", "LAN Temp.", 'PCIE02 Temp.', 'PCIE06 Temp.', 'SOC_FAN', 'VBAT', 'power_control', 'status']
    for i in target_attributes:
        assert i in result['BMC']['sc10']
    print("Check all attributes in sc10 BMC -- OK")

    assert result['BMC']['sc10']['CPU_FAN'].isdigit()
    print("Check sc10 BMC CPU_FAN -- OK")
    
    assert len(result['BMC']['sc10']['+12V']) == 6
    assert result['BMC']['sc10']['+12V'][:3] == '12.'
    assert result['BMC']['sc10']['+12V'][3:].isdigit()
    print("Check sc10 BMC +12V -- OK")

    assert len(result['BMC']['sc10']['+3.3V']) == 5
    assert result['BMC']['sc10']['+3.3V'][:2] == '3.'
    assert result['BMC']['sc10']['+3.3V'][2:].isdigit()
    print("Check sc10 BMC +3.3V -- OK")

    assert len(result['BMC']['sc10']['+3.3V_ALW']) == 5
    assert result['BMC']['sc10']['+3.3V_ALW'][:2] == '3.'
    assert result['BMC']['sc10']['+3.3V_ALW'][2:].isdigit()
    print("Check sc10 BMC +3.3V_ALW -- OK")

    assert len(result['BMC']['sc10']['+5V']) == 5
    assert result['BMC']['sc10']['+5V'][:2] == '5.'
    assert result['BMC']['sc10']['+5V'][2:].isdigit()
    print("Check sc10 BMC +5V -- OK")

    assert len(result['BMC']['sc10']['+5V_ALW']) == 5
    assert result['BMC']['sc10']['+5V_ALW'][:2] == '5.'
    assert result['BMC']['sc10']['+5V_ALW'][2:].isdigit()
    print("Check sc10 BMC +5V_ALW -- OK")

    assert len(result['BMC']['sc10']['+CPU_1.8V']) == 5
    assert result['BMC']['sc10']['+CPU_1.8V'][:2] == '1.'
    assert result['BMC']['sc10']['+CPU_1.8V'][2:].isdigit()
    print("Check sc10 BMC +CPU_1.8V -- OK")

    assert len(result['BMC']['sc10']['+CPU_1.8V_S5']) == 5
    assert result['BMC']['sc10']['+CPU_1.8V_S5'][:2] == '1.'
    assert result['BMC']['sc10']['+CPU_1.8V_S5'][2:].isdigit()
    print("Check sc10 BMC +CPU_1.8V_S5 -- OK")

    assert len(result['BMC']['sc10']['+CPU_3.3V']) == 5
    assert result['BMC']['sc10']['+CPU_3.3V'][:2] == '3.'
    assert result['BMC']['sc10']['+CPU_3.3V'][2:].isdigit()
    print("Check sc10 BMC +CPU_3.3V -- OK")

    assert len(result['BMC']['sc10']['+PCH_CLDO']) == 5
    assert result['BMC']['sc10']['+PCH_CLDO'][1] == '.'
    assert result['BMC']['sc10']['+PCH_CLDO'][2:].isdigit()
    print("Check sc10 BMC +PCH_CLDO -- OK")

    assert len(result['BMC']['sc10']['+VCORE']) == 5
    assert result['BMC']['sc10']['+VCORE'][1] == '.'
    assert result['BMC']['sc10']['+VCORE'][2:].isdigit()
    print("Check sc10 BMC +VCORE -- OK")

    assert len(result['BMC']['sc10']['+VDDIO_ABCD']) == 5
    assert result['BMC']['sc10']['+VDDIO_ABCD'][1] == '.'
    assert result['BMC']['sc10']['+VDDIO_ABCD'][2:].isdigit()
    print("Check sc10 BMC +VDDIO_ABCD -- OK")

    assert len(result['BMC']['sc10']['+VDDIO_EFGH']) == 5
    assert result['BMC']['sc10']['+VDDIO_EFGH'][1] == '.'
    assert result['BMC']['sc10']['+VDDIO_EFGH'][2:].isdigit()
    print("Check sc10 BMC +VDDIO_EFGH -- OK")

    assert len(result['BMC']['sc10']['+VSOC']) == 5
    assert result['BMC']['sc10']['+VSOC'][1] == '.'
    assert result['BMC']['sc10']['+VSOC'][2:].isdigit()
    print("Check sc10 BMC +VSOC -- OK")

    assert result['BMC']['sc10']['CHIPSET_FAN'].isdigit()
    print("Check sc10 BMC CHIPSET_FAN -- OK")
    assert result['BMC']['sc10']['CPU Temp.'].isdigit()
    print("Check sc10 BMC CPU Temp. -- OK")
    assert result['BMC']['sc10']['LAN Temp.'].isdigit()
    print("Check sc10 BMC LAN Temp. -- OK")
    assert result['BMC']['sc10']['PCIE02 Temp.'].isdigit()
    print("Check sc10 BMC PCIE02 Temp. -- OK")
    assert result['BMC']['sc10']['PCIE06 Temp.'].isdigit()
    print("Check sc10 BMC PCIE06 Temp. -- OK")
    assert result['BMC']['sc10']['SOC_FAN'].isdigit()
    print("Check sc10 BMC SOC_FAN -- OK")

    assert len(result['BMC']['sc10']['+VBAT']) == 5
    assert result['BMC']['sc10']['+VBAT'][1] == '.'
    assert result['BMC']['sc10']['+VBAT'][2:].isdigit()
    print("Check sc10 BMC +VBAT -- OK")

    power_control_options = ['Hard Reset', "Power Off", "Power On", "Power Cycle", "ACPI Shutdown"]
    assert result['BMC']['sc10']['power_control'] in power_control_options
    print("Check sc10 BMC power_control' -- OK")