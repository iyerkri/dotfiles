#!/bin/bash
iwconfig wlan0 essid "$1"
ifconfig wlan0 up
dhcpcd
