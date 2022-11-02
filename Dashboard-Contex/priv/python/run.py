import sys
import json
from BMC.web_scraper import run_web_scraper
from Supercluster.supercluster_scraper import run_supercluster_scraper


def get_result(username: str, password: str, url_config: str):
    result = run_web_scraper(url_config)
    result.update(run_supercluster_scraper(username, password, url_config))

    return str(result).replace("\'", "\"").replace("CPU_FAN", "bmc_cpu_fan").replace("CPU_OPT", "bmc_cpu_opt").replace("CPU_ECC", "bmc_cpu_ecc").replace("Memory_Train_ERR", "bmc_memory_train_err").replace("Watchdog2", "bmc_watchdog2") .replace("+12V", "bmc_12v").replace("+3.3V_ALW", "bmc_33v_alw").replace("+3.3V", "bmc_33v").replace("+5V_ALW", "bmc_5v_alw").replace("+5V", "bmc_5v").replace("+CPU_1.8V_S5", "bmc_cpu_18v_s5").replace("+CPU_1.8V", "bmc_cpu_18v").replace("+CPU_3.3V", "bmc_cpu_33v").replace("+PCH_CLDO", "bmc_pch_cldo").replace("+VCORE", "bmc_vcore").replace("+VDDIO_ABCD", "bmc_vddio_abcd").replace ("+VDDIO_EFGH", "bmc_vddio_efgh").replace("+VSOC", "bmc_vsoc").replace("CHIPSET_FAN", "bmc_chipset_fan").replace("CPU Temp.", "bmc_cpu_temp").replace("LAN Temp.", "bmc_lan_temp").replace("SOC_FAN", "bmc_soc_fan").replace("VBAT", "bmc_vbat")

def get_sc_result(username: str, password: str, url_config: str):
    result = run_supercluster_scraper(username, password, url_config)
    return str(result).replace("\'", "\"")

def get_bmc_result(url_config: str):
    result = run_web_scraper(url_config)
    return str(result).replace("\'", "\"").replace("CPU_FAN", "bmc_cpu_fan").replace("CPU_OPT", "bmc_cpu_opt").replace("CPU_ECC", "bmc_cpu_ecc").replace("Memory_Train_ERR", "bmc_memory_train_err").replace("Watchdog2", "bmc_watchdog2") .replace("+12V", "bmc_12v").replace("+3.3V_ALW", "bmc_33v_alw").replace("+3.3V", "bmc_33v").replace("+5V_ALW", "bmc_5v_alw").replace("+5V", "bmc_5v").replace("+CPU_1.8V_S5", "bmc_cpu_18v_s5").replace("+CPU_1.8V", "bmc_cpu_18v").replace("+CPU_3.3V", "bmc_cpu_33v").replace("+PCH_CLDO", "bmc_pch_cldo").replace("+VCORE", "bmc_vcore").replace("+VDDIO_ABCD", "bmc_vddio_abcd").replace ("+VDDIO_EFGH", "bmc_vddio_efgh").replace("+VSOC", "bmc_vsoc").replace("CHIPSET_FAN", "bmc_chipset_fan").replace("CPU Temp.", "bmc_cpu_temp").replace("LAN Temp.", "bmc_lan_temp").replace("SOC_FAN", "bmc_soc_fan").replace("VBAT", "bmc_vbat")




if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Invalid arguments!")
    else:
        username = sys.argv[1]
        password = sys.argv[2]
        config_path = sys.argv[3]
        
        print(get_sc_result(username, password, config_path))
        print(get_bmc_result(config_path))