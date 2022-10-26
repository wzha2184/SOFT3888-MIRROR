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
        project_path = config["project_path"]

        for sc in superclusters.keys():
            ssh = paramiko.SSHClient()
            ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())

            json_result = {
                "GPU":{},
                "CPU": {},
                "BIOS": {}
                }

            try:
                ssh.connect(superclusters[sc]["IP"], username=username, password=password, timeout=4)

                # path = "soft3888_tu12_04_re_p39/Feature_Scraper/Supercluster"
                # command = "cd {path}; echo 6r7mYcxLHXLq8Rgu | sudo -S -k python3 supercluster_scraper.py".format(path=path)
                
                command = "cd {path}; echo 6r7mYcxLHXLq8Rgu | sudo -S -k python3 supercluster_scraper.py".format(path=project_path)

                ssh_stdin, ssh_stdout, ssh_stderr = ssh.exec_command(command, timeout=4)

                str_result = ssh_stdout.read().decode('utf-8').replace("\'", "\"")
                json_result = json.loads(str_result)
                
                json_result["GPU"]["status"] = "OK"
                json_result["CPU"]["status"] = "OK"
                json_result["BIOS"]["status"] = "OK"
            
            except:
                json_result["GPU"]["status"] = "error - Not able to login {}".format(sc)
                json_result["CPU"]["status"] = "error - Not able to login {}".format(sc)
                json_result["BIOS"]["status"] = "error - Not able to login {}".format(sc)

            result["GPU"][sc] = json_result["GPU"]
            result["CPU"][sc] = json_result["CPU"]
            result["BIOS"][sc] = json_result["BIOS"]

        return result


if __name__ == "__main__":
    result = run_supercluster_scraper("usyd-10a", "6r7mYcxLHXLq8Rgu", "..\\config.json")
    print(json.dumps(result, indent=2))