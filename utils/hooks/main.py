from cyrillicFilter import startFilter
from mergeProblem import startMergeProblemTest
import os
import re
import sys


def main():
    print(f'Hook started...')
    startFilter()
    startMergeProblemTest()

if __name__ == '__main__':
    main()