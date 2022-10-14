import paramiko
import json


def get_supercluster_result() -> dict:
    from gpu_scraper import GPUScraper
    from shell_scraper import ShellScraper

    gpu_scraper = GPUScraper()
    shell_scraper = ShellScraper()

    gpu_result = gpu_scraper.get_gpu_result()
    shell_result = shell_scraper.get_shell_result()

    result = {"GPU": gpu_result, "CPU": {}, "BIOS": {}}
    result.update(shell_result)

    return result


def run_supercluster_scraper(username: str, password: str, url_config: str) -> dict:
    with open(url_config, "r") as jc:
        config = json.load(jc)

        result = {"GPU": {}, "CPU": {}, "BIOS": {}}
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

            result["GPU"][sc] = json_result["GPU"]
            result["CPU"][sc] = json_result["CPU"]
            result["BIOS"][sc] = json_result["BIOS"]

        return result


if __name__ == "__main__":
    print(get_supercluster_result())
