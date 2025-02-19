import subprocess
import os
import multiprocessing
import shutil

if os.path.exists('../../node_build'):
    shutil.rmtree('../../node_build')

os.chdir('../../')

subprocess.run(['mkdir', 'node_build'], check=True)

os.chdir('node_build')

subprocess.run(['cmake', '../cellframe-node/'], check=True)

num_cores = str(multiprocessing.cpu_count())
subprocess.run(['make', '-j', num_cores], check=True)

subprocess.run(['cpack'], check=True)

print('Project successfully built and installed!')
input("Press Enter ...")
