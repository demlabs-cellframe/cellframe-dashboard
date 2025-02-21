#!/bin/bash
set -e

SERVERS=(	pvt_cellframe 				pub_cellframe 							pub_kelvpn 						pub_vendeta)
KEYS=(		/root/.ssh/cellframe_key 	/root/.ssh/cellframe_key 				/root/.ssh/cellframe_key 		/root/.ssh/cellframe_key)
CREDS=( 	admin@pvt.demlabs.net		www-files@internal-pub.cellframe.net 				admin@pub.cellframe.net 				admin@pub.cellframe.net)
PATHS=( 	"/var/www/libcellframe-node-cdb/"				"/srv/fancy-nginx/files/" 	"/var/www/pub.klvn.io/" 	"/var/www/libcellframe-node-cdb/vendeta-vpn")

