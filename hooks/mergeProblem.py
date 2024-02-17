from common import types
import os
import sys

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

def startMergeProblemTest(files):
    print(f'Merge problem test.')

    py_files = [f for f in files if f.endswith(types)]

    cyrillic_files = searchMarker(py_files)

    if cyrillic_files:
        for filename, line_num, line in cyrillic_files:
            print( f'Unresolved merge conflict: File: {filename} , line {line_num} : {line}')
        sys.exit(1)

    print(f'Merge problem test. OK')

