# -*- coding: utf-8 -*-
"""
This module builds on the i3status modules memory and disk modules

Copied partly from https://py3status.readthedocs.io/en/latest/modules.html#sysdata

"""

import subprocess

class Py3status:

    format_memory = "Mem:"
    format_disk = "Free:"
    default_display = "memory"
    _mouseclick = False
    interval = 10


    def memory_disk(self):
        if self._mouseclick:
            self._mouseclick = False
        else:
            if self.default_display == "memory":
                mem_info = self._get_meminfo()
                self.full_text = self.format_memory + self._calc_mem_info(mem_info)
                self.memory = True
            else:
                self.full_text = self.format_disk + self._get_diskinfo()
                self.memory = False
        return {
            'full_text': self.full_text,
            'cached_until': self.py3.time_in(self.interval),
        }

    def on_click(self, event):
        button = event['button']
        if button==1:
            if self.memory:
                self.full_text = self.format_disk + self._get_diskinfo()
                self.memory = False
                self._mouseclick = True
            else:
                mem_info = self._get_meminfo()
                self.full_text = self.format_memory + self._calc_mem_info(mem_info)
                self.memory = True
                self._mouseclick = True


    def _get_meminfo(self, head=52):
        """
        copied from
        https://github.com/ultrabug/py3status/blob/master/py3status/modules/sysdata.py
        """
        with open("/proc/meminfo") as f:
            info = [line.split() for line in (next(f) for x in range(head))]
            return {fields[0]: float(fields[1]) for fields in info}




    def _calc_mem_info(self, meminfo):
        """
        mostly copied from
        https://github.com/ultrabug/py3status/blob/master/py3status/modules/sysdata.py
        """
        total_mem_kib = meminfo["MemTotal:"]
        used_mem_kib = (
            total_mem_kib
            - meminfo["MemFree:"]
            - (
                meminfo["Buffers:"]
                + meminfo["Cached:"]
                + (meminfo["SReclaimable:"] - meminfo["Shmem:"])
            )
        )

        if used_mem_kib/1024/1024 > 1:
            return str(round(used_mem_kib/1024/1024,1)) + " GiB"
        elif used_mem_kib/1024 > 1:
            return str(round(used_mem_kib/1024,1)) + " MiB"
        else:
            return str(round(used_mem_kib,1)) + " KiB"



    def _get_diskinfo(self):
        """
        https://cmdlinetips.com/2014/03/how-to-run-a-shell-command-from-python-and-get-the-output/
        """
        out = subprocess.Popen(['df', '-h', '--output=avail', '/home'],
                               stdout=subprocess.PIPE,
                               stderr=subprocess.STDOUT)
        stdout,stderr = out.communicate()
        return stdout.split()[1].decode('UTF-8')
