import os
import re
import sys
from colorama import init, Fore, Style

def searchMarker(files):
    problem_files = []
    markers = ['<<<<<<<', '=======', '>>>>>>>']
    for filename in files:
        with open(filename, 'r') as file:
            content = file.readlines()
            for line_num, line in enumerate(content):
                for marker in markers:
                    if marker in line:
                        problem_files.append((filename, line_num+1, line))
    return problem_files

def startMergeProblemTest():
    print('Merge problem test.')
    files = os.popen('git diff --cached --name-only --diff-filter=ACMRTUXB').read().splitlines()

    types = ('.py', '.cpp', '.h', '.pro', '.pri', '.c', '.hpp', '.txt', '.mk')

    py_files = [f for f in files if f.endswith(types)]

    cyrillic_files = searchMarker(py_files)

    if cyrillic_files:
        for filename, line_num, line in cyrillic_files:
            init()
            print( Fore.RED + 'Unresolved merge conflict:' + Style.RESET_ALL + f' File: {filename} , line {line_num} : {line}')
        sys.exit(1)

    print('Merge problem test. OK')

