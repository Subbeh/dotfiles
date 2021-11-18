#!/usr/bin/env python3

import configparser
import sys
import json
import requests
from decimal import Decimal
from os.path import expanduser
from math import log, floor

def human_format(number):
    units = ['', 'K', 'M', 'G', 'T', 'P']
    k = 1000.0
    magnitude = int(floor(log(number, k)))
    return '%.2f%s' % (number / k**magnitude, units[magnitude])

config = configparser.ConfigParser()

with open(expanduser('~/.local/share/portfolio'), 'r', encoding='utf-8') as f:
  config.read_file(f)

currencies = [x for x in config.sections() if x != 'general']
base_currency = config['general']['base_currency']
params = {'convert': base_currency}

holdings = 0
holdings_old = 0
for currency in currencies:
    json = requests.get(f'https://api.coingecko.com/api/v3/coins/{currency}',).json()["market_data"]
    local_price = float(json["current_price"][f'{base_currency.lower()}'])
    change = float(json['price_change_percentage_1h_in_currency'][f'{base_currency.lower()}'])
    qty = float(config[currency]['qty'])
    holdings += local_price * qty
    holdings_old += (local_price * qty) / ((100 + change) / 100)

diff=round(((holdings - holdings_old) / holdings_old) * 100, 2)
icon=('%{F#afd787}%{F-}' if diff > 0 else '%{F#ff5f5f}%{F-}')
sys.stdout.write(f'{base_currency} {human_format(holdings)} ')
sys.stdout.write(f'{icon} {diff:+}%')
