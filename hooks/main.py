from cyrillicFilter import startFilter
from mergeProblem import startMergeProblemTest
import os
import sys
import subprocess

def main():
    files_1 = os.popen('git diff --cached --name-only --diff-filter=ACMRTUXB').read().splitlines()
    files_2 = os.popen('git diff --name-only --diff-filter=ACMRTUXB').read().splitlines()
    files = []
    if len(files_1) == 0 : 
        files = files_2
    else :
        files = files_1

    param = sys.argv[1]

    print(f'{param} Test started...')
    if param == 'full_test' :
        startFilter(files)
        startMergeProblemTest(files)   
    
if __name__ == '__main__':
    main()