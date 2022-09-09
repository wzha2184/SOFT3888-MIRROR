import paramiko

ssh = paramiko.SSHClient()
ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
ssh.connect("192.168.10.9", username="usyd-10a", password="6r7mYcxLHXLq8Rgu")
ssh_stdin, ssh_stdout, ssh_stderr = ssh.exec_command('cd CPUandBIOS; echo 6r7mYcxLHXLq8Rgu | sudo -S -k python3 all_data_capture.py')
print(ssh_stdout.read().decode('utf-8'))