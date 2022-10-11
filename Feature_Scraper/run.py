import paramiko
import sys
import json
from BMC.web_scraper import WebScraper, WebAccesser

def get_bmc_result(url_config: str) -> dict:
    with open(url_config, "r") as jc:
        config = json.load(jc)
        superclusters = config["superclusters"]

        web_accesser = WebAccesser()
        result = {}
        result["BMC"] = {}
        for sc in superclusters.keys():
            bmc_url = superclusters[sc]["BMC"]
            web_accesser.set_url(bmc_url)
            web_scraper = WebScraper(sc, web_accesser)
    
            result["BMC"][sc] = web_scraper.get_bmc_result()

        return result


def get_supercluster_result(username: str, password: str, url_config: str) -> dict:
    with open(url_config, "r") as jc:
        config = json.load(jc)

        result = {}
        superclusters = config["superclusters"]
        for sc in superclusters.keys():
            ssh = paramiko.SSHClient()
            ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
            ssh.connect(superclusters[sc]["IP"], username=username, password=password)

            path = "soft3888_tu12_04_re_p39/Feature_Scraper/Supercluster"
            command = "cd {path}; echo 6r7mYcxLHXLq8Rgu | sudo -S -k python3 supercluster_scraper.py".format(path=path)
            ssh_stdin, ssh_stdout, ssh_stderr = ssh.exec_command(command)

            str_result = ssh_stdout.read().decode('utf-8').replace("\'", "\"")
            json_result = json.loads(str_result)
            result.update(json_result)

        return result


def get_result(username: str, password: str, url_config: str):
    result = get_bmc_result(url_config)
    result.update(get_supercluster_result(username, password, url_config))
    return result


if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Invalid arguments!")
    else:
        username = sys.argv[1]
        password = sys.argv[2]
        config_path = sys.argv[3]
        
        print(get_result(username, password, config_path))