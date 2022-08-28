import platform
import sys
import json
import socket
import subprocess
import pprint
import re
import psutil


# bios = dict()
# if sys.platform == 'win32':
#     print('TODO')
# else:
#     bios['vendor'] = subprocess.check_output("dmidecode --string bios-vendor", universal_newlines=True, shell=True)
#     bios['release_date'] = subprocess.check_output("dmidecode --string bios-release-date", universal_newlines=True, shell=True)
#     bios['version'] = subprocess.check_output("dmidecode --string bios-version", universal_newlines=True, shell=True)
# print(bios)
result = subprocess.check_output(['dmidecode'])
print(result)