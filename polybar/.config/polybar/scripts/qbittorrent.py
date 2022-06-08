#!/usr/bin/env python3
import qbittorrentapi
import argparse
from sys import exit
import os

PATH=os.path.realpath(__file__)
ICON = ""
ICON_DISC = ""
ICON_UP = ""
ICON_DOWN = ""

username=''
password=''
host='pi-mediaa'
port='1340'

qbc = qbittorrentapi.Client(host=host,username=username,password=password, port=port, SIMPLE_RESPONSES=True)

parser = argparse.ArgumentParser()
parser.add_argument('--playpause', action="store_true")
args = parser.parse_args()

qbc = qbittorrentapi.Client(host=host,username=username,password=password, port=port, SIMPLE_RESPONSES=True)
failed = False
try:
    qbc.auth_log_in()
except:
    print(ICON, ICON_DISC + " ")
    exit(1)

active = qbc.torrents.info.active()
if args.playpause:
    if len(active):
        qbc.torrent_pause('all')
    else:
        qbc.torrent_resume('all')
    exit()

dlspeed = qbc.transfer.info['dl_info_speed']/1024
dlunit = dlunit = "Kb/s"
if dlspeed > 1024:
    dlunit = "Mb/s"
    dlspeed = dlspeed/1024

upspeed = qbc.transfer.info['up_info_speed']/1024
upunit = "Kb/s"
if upspeed > 1024:
    upunit = "Mb/s"
    upspeed = upspeed/1024

cumulative_percentage = 0
if len(active):
    cumulative_percentage = reduce(lambda a, b: a+b['progress'], active, 0) / len(active)

print(f'%{{A1: {PATH} --playpause:}}{ICON}%{{A}} {len(active)}  {cumulative_percentage:.2%} {ICON_UP} {upspeed:.2f}{upunit} {ICON_DOWN} {dlspeed:.2f}{dlunit} ')
