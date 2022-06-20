#!/usr/bin/env python3
import qbittorrentapi
import argparse
from sys import exit
from functools import reduce
import os

PATH=os.path.realpath(__file__)
ICON = ""
ICON_ACTIVE = "%{F#87d7ff}%{F-}"
ICON_DISC = ""
ICON_UP = ""
ICON_DOWN = ""

username=''
password=''
host='pi-media'
port='1340'

parser = argparse.ArgumentParser()
parser.add_argument('--playpause', action="store_true")
args = parser.parse_args()

qbc = qbittorrentapi.Client(host=host,username=username,password=password, port=port, SIMPLE_RESPONSES=True)

try:
    qbc.auth_log_in()
except:
    print(ICON, ICON_DISC + " ")
    exit()

active = qbc.torrents.info.active()
downloading = qbc.torrents.info.downloading()
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
if len(downloading):
    cumulative_percentage = reduce(lambda a, b: a+b['progress'], downloading, 0) / len(downloading) * 100

#print(f'{ICON_ACTIVE + " " + str(len(downloading)) + " " + str(int(cumulative_percentage)) + "%" if downloading else ICON} {ICON_DOWN} {int(dlspeed)}{dlunit} {ICON_UP} {int(upspeed)}{upunit} ')
print(f'{ICON_ACTIVE + " " + str(len(downloading)) + " " + str(int(cumulative_percentage)) + "%" + " " + ICON_DOWN + " " + str(int(dlspeed)) + dlunit if downloading else ICON} {ICON_UP} {int(upspeed)}{upunit} ')
