import subprocess
import re

path_to_executable = "/opt/cellframe-node/bin/cellframe-node-cli"

parameters = "help"

command = [path_to_executable, parameters]

output = subprocess.check_output(command)
output = output.decode("utf-8")
pattern = r'(?<=\n)[^:\n]+(?=:)'
matches = re.findall(pattern, output)

result = ""
for command_up in matches:
    parameters = ["help", command_up]
    command = [path_to_executable, parameters]
    resultRequest = subprocess.run([path_to_executable] + parameters, capture_output=True, text=True)
    output_lines = resultRequest.stdout.splitlines()
    for line in output_lines:
        if line.startswith(command_up):
            print(line)
            result += line + '\n'      

file = open("commands.txt", "w")
file.write(result)

file.close()

input("Press Enter ...")