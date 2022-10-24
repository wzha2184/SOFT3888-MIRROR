from gpu_scraper import GPUScraper

gpu = GPUScraper()
result = gpu.get_gpu_result()

assert 'GPU_count' in result
assert result['GPU_count'] == 2
print("Check the output contains 2 boards -- OK")

board1 = '1'
board2 = '2'

target_attributes = ['UUID', "BIOS", "Name", "Temperature", 'totalMemory', 'usedMemory', 'freeMemory', 'power', 'limitPower', 'minLimitPower', 'maxLimitPower', 'graphicsFrequency', 'StreamingMultiprocessorFrequency', 'memoryFrequency', 'MaxgraphicsFrequency', 'MaxStreamingMultiprocessorFrequency', 'MaxmemoryFrequency', 'fanSpeed', 'status']
for t in target_attributes:
    assert t in result[board1]
    assert t in result[board2]
print("Check all attributes in 2 boards' outputs -- OK")

assert len(result[board1]['Name']) > 0
assert len(result[board2]['Name']) > 0
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
    assert result[board1][f][-5] == '.'
    assert result[board1][f][:-5].isdigit()
    assert result[board1][f][-4:].isdigit()
    assert result[board2][f][-5] == '.'
    assert result[board2][f][:-5].isdigit()
    assert result[board2][f][-4:].isdigit()
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