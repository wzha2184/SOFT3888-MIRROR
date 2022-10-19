from shell_scraper import ShellScraper

shell_scraper = ShellScraper()
result = shell_scraper.get_shell_result()

assert 'CPU' in result
assert 'cpu_freq' in result['CPU']
assert 'status' in result['CPU']
if result['CPU']['status'] == 'OK':
    valid_chars = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9', '.']
    assert 'cpu_current_freq' in result['CPU']['cpu_freq']
    for c in result['CPU']['cpu_freq']['cpu_current_freq']:
        assert c in valid_chars
    assert 'cpu_min_freq' in result['CPU']['cpu_freq']
    for c in result['CPU']['cpu_freq']['cpu_min_freq']:
        assert c in valid_chars
    assert 'cpu_max_freq' in result['CPU']['cpu_freq']
    for c in result['CPU']['cpu_freq']['cpu_max_freq']:
        assert c in valid_chars

assert 'BIOS' in result
assert 'status' in result['BIOS']
if result['status'] == 'OK':
    assert 'baseboard-serial-number' in result['BIOS']
    assert type(result['BIOS']['baseboard-serial-number']) == str and len(result['BIOS']['baseboard-serial-number']) > 0

    assert 'On Board Devices' in result['BIOS']
    assert 'Device 1' in result['BIOS']['On Board Devices']
    assert "Type" in result['BIOS']['On Board Devices']['Device 1'] and type(result['BIOS']['On Board Devices']['Device 1']['Type']) == str and len(result['BIOS']['On Board Devices']['Device 1']['Type']) > 0
    assert "Status" in result['BIOS']['On Board Devices']['Device 1'] and type(result['BIOS']['On Board Devices']['Device 1']['Status']) == str and len(result['BIOS']['On Board Devices']['Device 1']['Status']) > 0
    assert "Description" in result['BIOS']['On Board Devices']['Device 1'] and type(result['BIOS']['On Board Devices']['Device 1']['Description']) == str and len(result['BIOS']['On Board Devices']['Device 1']['Description']) > 0

    assert 'PCIe information' in result['BIOS']
    assert len(result['BIOS']['PCIe information']) == 4
    for p in result['BIOS']['PCIe information']:
        assert "Designation" in result['BIOS']['PCIe information'][p] and type(result['BIOS']['PCIe information'][p]["Designation"]) == str and len(result['BIOS']['PCIe information'][p]["Designation"]) > 0
        assert "Type" in result['BIOS']['PCIe information'][p] and type(result['BIOS']['PCIe information'][p]["Type"]) == str and len(result['BIOS']['PCIe information'][p]["Type"]) > 0
        assert "Current Usage" in result['BIOS']['PCIe information'][p] and type(result['BIOS']['PCIe information'][p]["Current Usage"]) == str and len(result['BIOS']['PCIe information'][p]["Current Usage"]) > 0
        assert "Length" in result['BIOS']['PCIe information'][p] and type(result['BIOS']['PCIe information'][p]["Length"]) == str and len(result['BIOS']['PCIe information'][p]["Length"]) > 0
        assert "ID" in result['BIOS']['PCIe information'][p] and type(result['BIOS']['PCIe information'][p]["ID"]) == str and len(result['BIOS']['PCIe information'][p]["ID"]) > 0
        assert "Characteristics" in result['BIOS']['PCIe information'][p] and type(result['BIOS']['PCIe information'][p]["Characteristics"]) == str and len(result['BIOS']['PCIe information'][p]["Characteristics"]) > 0
        assert "Bus Address" in result['BIOS']['PCIe information'][p] and type(result['BIOS']['PCIe information'][p]["Bus Address"]) == str and len(result['BIOS']['PCIe information'][p]["Bus Address"]) > 0
