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

        return result

def get_result(username: str, password: str, url_config: str):
    result = get_bmc_result(url_config)
    result.update(get_supercluster_result(username, password, url_config))
    return result


if __name__ == "__main__":
    username = "usyd-10a"
    password="6r7mYcxLHXLq8Rgu"

    print(get_result(username, password, "url_config.json"))