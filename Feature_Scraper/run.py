import paramiko
import sys


def get_result(username: str, password: str, bmc_url: str):
    for i in range(1, len(sys.argv)):
        sc_ip = sys.argv[i]

        ssh = paramiko.SSHClient()
        ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
        ssh.connect(sc_ip, username=username, password=password)
        ssh_stdin, ssh_stdout, ssh_stderr = ssh.exec_command('cd AllInfo; echo 6r7mYcxLHXLq8Rgu | sudo -S -k python3 all_feature_scraper.py')
        print(ssh_stdout.read().decode('utf-8'))

if __name__ == "__main__":
    username = "usyd-10a"
    password="6r7mYcxLHXLq8Rgu"
    bmc_url = "https://192.168.10.108"

    get_result()