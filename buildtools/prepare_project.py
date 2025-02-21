#!/usr/bin/python3

import sys
import yaml
from optparse import OptionParser
from subprocess import STDOUT, DEVNULL, check_call
import os



def install_dep_deb(debs, arch):
	

	#create list for current arch
	dependencies = []

	for d in debs:
		
		if isinstance(d, dict):
			if arch in d:
				dependencies.extend(d[arch])
		else:
			dependencies.append(d)

	print("Installing DEB dependencies ", dependencies)

	#raise an exception if somthing gone wrong
	check_call(['apt-get', 'install', '-y'] + dependencies) 
	return 0


def install(proj, stage, arch):
	#f-strings not supported in python3.5 =(, and it is latest python available on armhf rasbian distro. 
	if stage+"_dependencies" not in proj:
		print ("No ["+stage+"_dependencies] in project yaml, do nothing")
		return

	build_deps = proj[stage+"_dependencies"]

	result = 0;
	
	if "deb" in build_deps:
		result += install_dep_deb(build_deps["deb"], arch)

	return result

commands = {"install":install}

if __name__ == "__main__":


	cmd = sys.argv[1]
	filename = sys.argv[2]
	stage = sys.argv[3]
	arch = sys.argv[4]
	
	try:
		stream = open(filename, 'r') 
	except: 
		print("No [project.yaml] present, do nothing")
		sys.exit(0)

	proj = yaml.load(stream, yaml.SafeLoader)

	if cmd not in commands:
		print("Unknown command: " + sys.argv[1])
		sys.exit(-1)


	sys.exit(commands[cmd](proj, stage, arch))
