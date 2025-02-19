import os
import re
import sys
from colorama import init, Fore, Style

def has_cyrillic(content):
    return bool(re.search('[а-яА-Я]', content))

def filter_cyrillic(files):
    cyrillic_files = []
    for filename in files:
        with open(filename, 'r') as file:
            content = file.readlines()
            for line_num, line in enumerate(content):
                if has_cyrillic(line):
                    cyrillic_files.append((filename, line_num+1, line))
    return cyrillic_files

def startFilter():
    print('Start cyrillic test.')
    files = os.popen('git diff --cached --name-only --diff-filter=ACMRTUXB').read().splitlines()

    types = ('.py', '.cpp', '.h', '.pro', '.pri', '.c', '.hpp', '.txt', '.mk')

    py_files = [f for f in files if f.endswith(types)]

    cyrillic_files = filter_cyrillic(py_files)

    if cyrillic_files:
        for filename, line_num, line in cyrillic_files:
            init()
            print( Fore.RED + 'Error cyrillic test:' + Style.RESET_ALL + f' File: {filename} , line {line_num} : {line}')
        sys.exit(1)

    print('Cyrillic test. OK')

