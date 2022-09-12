import paramiko
import sys
import json
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

            path = "Feature_Scraper/Supercluster"
            command = "cd {path}; echo 6r7mYcxLHXLq8Rgu | sudo -S -k python3 supercluster_scraper.py {username} {password}".format(
                path=path, 
                username=username,
                password=password)
            ssh_stdin, ssh_stdout, ssh_stderr = ssh.exec_command()

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