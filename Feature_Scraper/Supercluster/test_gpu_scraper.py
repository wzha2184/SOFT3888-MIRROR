from gpu_scraper import GPUScraper

gpu = GPUScraper()
result = gpu.get_gpu_result()

assert 'GPU_count' in result
assert result['GPU_count'] == 2
board1 = 'GPU-d1beb192-bcec-67d2-4a5f-51108e4f03d1'
board2 = 'GPU-70987dcb-d543-54bc-8ac5-fc3cfc530043'
assert board1 in result
assert board2 in result
print("Check the output contains 2 correct boards -- OK")

target_attributes = ['UUID', "BIOS", "Name", "Temperature", 'totalMemory', 'usedMemory', 'freeMemory', 'power', 'limitPower', 'minLimitPower', 'maxLimitPower', 'graphicsFrequency', 'StreamingMultiprocessorFrequency', 'memoryFrequency', 'MaxgraphicsFrequency', 'MaxStreamingMultiprocessorFrequency', 'MaxmemoryFrequency', 'fanSpeed', 'status']
for t in target_attributes:
    assert t in result[board1]
    assert t in result[board2]
print("Check all attributes in 2 boards' outputs -- OK")

assert result[board1]['Name'] == 'NVIDIA GeForce RTX 3090'
assert result[board2]['Name'] == 'NVIDIA GeForce RTX 3090'
print("Check Name of the 2 GPU boards -- OK")

one_decimal_place_attributes = ['Temperature', 'totalMemory', 'limitPower', 'minLimitPower', 'maxLimitPower', 'graphicsFrequency', 'StreamingMultiprocessorFrequency', 'memoryFrequency', 'MaxgraphicsFrequency', 'MaxStreamingMultiprocessorFrequency', 'MaxmemoryFrequency']
for o in one_decimal_place_attributes:
    assert result[board1][o][-2] == '.'
    assert result[board1][o][:-2].isdigit()
    assert result[board1][o][-1].isdigit()
    assert result[board2][o][-2] == '.'
    assert result[board2][o][:-2].isdigit()
    assert result[board2][o][-1].isdigit()
print("Check ['Temperature', 'totalMemory', 'limitPower', 'minLimitPower', 'maxLimitPower', 'graphicsFrequency', 'StreamingMultiprocessorFrequency', 'memoryFrequency', 'MaxgraphicsFrequency', 'MaxStreamingMultiprocessorFrequency', 'MaxmemoryFrequency'] of the 2 GPU boards -- OK")

four_decimal_places_attributes = ['usedMemory', 'freeMemory']
for f in four_decimal_places_attributes:
    assert result[board1][o][-5] == '.'
    assert result[board1][o][:-5].isdigit()
    assert result[board1][o][-4:].isdigit()
    assert result[board2][o][-5] == '.'
    assert result[board2][o][:-5].isdigit()
    assert result[board2][o][-4:].isdigit()
print("Check usedMemory and freeMemory of the 2 GPU boards -- OK")

assert result[board1]['power'][-4] == '.'
assert result[board1]['power'][:-4].isdigit()
assert result[board1]['power'][-3:].isdigit()
assert result[board2]['power'][-4] == '.'
assert result[board2]['power'][:-4].isdigit()
assert result[board2]['power'][-3:].isdigit()
print("Check power of the 2 GPU boards -- OK")

assert result[board1]['fanSpeed'].isdigit()
assert result[board2]['fanSpeed'].isdigit()
print("Check fanSpeed of the 2 GPU boards -- OK")