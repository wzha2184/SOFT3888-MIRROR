import paramiko
import sys
import json
import os
from BIOS_And_CPU.supercluster_scraper import SuperclusterScraper
from BIOS_And_CPU.web_scraper import WebScraper
from GPU.gpu_scraper import GPUScraper

def get_bmc_and_gpu(url_config: str):
    with open(url_config, "r") as jc:
        config = json.load(jc)
        bmc_url = config["BMC"]

        result = {}
        gpu_scraper = GPUScraper()
        result.update(gpu_scraper.get_gpu_result())
        
        for bmc in bmc_url.keys():
            web_scraper = WebScraper(bmc, bmc_url[bmc])
            result.update(web_scraper.get_bmc_result())

        return result


def get_cpu_and_bios(username: str, password: str, url_config: str):
    with open(url_config, "r") as jc:
        config = json.load(jc)

        result = {}
        sc_url = config["supercluster"]
        for sc in sc_url.keys():
            ssh = paramiko.SSHClient()
            ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            ssh.connect(sc_url[sc], username=username, password=password)
            path = os.path.join("Feature_Scraper", "BIOS_And_CPU")
            ssh_stdin, ssh_stdout, ssh_stderr = ssh.exec_command('cd {}; echo 6r7mYcxLHXLq8Rgu | sudo -S -k python3 supercluster_scraper.py'.format(path))
            
            str_result = ssh_stdout.read().decode('utf-8')
            json_result = json.loads(str_result)
            result.update(json_result)


def get_result(username: str, password: str, url_config: str):
    return get_bmc_and_gpu(url_config).update(get_cpu_and_bios(username, password, url_config))


if __name__ == "__main__":
    username = "usyd-10a"
    password="6r7mYcxLHXLq8Rgu"

    get_result(username, password, "usl_config.json")