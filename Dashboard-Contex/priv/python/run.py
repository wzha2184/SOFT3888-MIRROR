from dataclasses import replace
import re
import paramiko
import json
import os
from BMC.web_scraper import WebScraper

def get_bmc_result(url_config: str) -> dict:
    with open(url_config, "r") as jc:
        config = json.load(jc)
        bmc_url = config["BMC"]

        result = {}
        for bmc in bmc_url.keys():
            web_scraper = WebScraper(bmc, bmc_url[bmc])
            result.update(web_scraper.get_bmc_result())

        return result


def get_supercluster_result(username: str, password: str, url_config: str) -> dict:
    with open(url_config, "r") as jc:
        config = json.load(jc)

        result = {}
        sc_url = config["supercluster"]
        for sc in sc_url.keys():
            ssh = paramiko.SSHClient()
            ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            ssh.connect(sc_url[sc], username=username, password=password)
            path = os.path.join("Feature_Scraper", "Supercluster")
            ssh_stdin, ssh_stdout, ssh_stderr = ssh.exec_command('cd {}; echo 6r7mYcxLHXLq8Rgu | sudo -S -k python3 supercluster_scraper.py'.format(path))
            
            str_result = ssh_stdout.read().decode('utf-8').replace("\'", "\"")
            json_result = json.loads(str_result)
            result.update(json_result)
            # print(str_result)

        return result

def get_result(username: str, password: str, url_config: str):
    # result = get_bmc_result(url_config)
    result = {'BMC': {'BMC1': {}}}
    result.update(get_supercluster_result(username, password, url_config))

    # old method
    # return str(result).replace("\'", "\"").replace("+12V", "bmc_12v")

    # return str(result).replace("\'", "\"")

    return str(result).replace("\'", "\"").replace("CPU_FAN", "bmc_cpu_fan").replace("CPU_OPT", "bmc_cpu_opt").replace("CPU_ECC", "bmc_cpu_ecc").replace("Memory_Train_ERR", "bmc_memory_train_err").replace("Watchdog2", "bmc_watchdog2") .replace("+12V", "bmc_12v").replace("+3.3V_ALW", "bmc_33v_alw").replace("+3.3V", "bmc_33v").replace("+5V_ALW", "bmc_5v_alw").replace("+5V", "bmc_5v").replace("+CPU_1.8V_S5", "bmc_cpu_18v_s5").replace("+CPU_1.8V", "bmc_cpu_18v").replace("+CPU_3.3V", "bmc_33v").replace("+PCH_CLDO", "bmc_pch_cldo").replace("+VCORE", "bmc_vcore").replace("+VDDIO_ABCD", "bmc_vddio_abcd").replace ("+VDDIO_EFGH", "bmc_vddio_efgh").replace("+VSOC", "bmc_vsoc").replace("CHIPSET_FAN", "bmc_chipset_fan").replace("CPU Temp.", "bmc_cpu_temp").replace("LAN Temp.", "bmc_lan_temp").replace("SOC_FAN", "bmc_soc_fan").replace("VBAT", "bmc_vbat")


# if __name__ == "__main__":
#     username = "usyd-10a"
#     password="6r7mYcxLHXLq8Rgu"

#     print(get_result(username, password, "url_config.json"))