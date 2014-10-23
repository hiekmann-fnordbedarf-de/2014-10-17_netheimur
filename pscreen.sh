#!/usr/bin/env python
# -*- coding: utf-8 -*-

""" 
Taken from the interwobs and adapted!
Original: https://faq.i3wm.org/question/202/what-do-you-guys-use-for-printscreen/

Use in i3wm with:
Save as screeshot.py somewhere into your PATH
bindsym --release Print exec --no-startup-id screenshot.py
"""


import os
from datetime import datetime
from subprocess import Popen, PIPE
from tempfile import NamedTemporaryFile

SCREENSHOT_UTILITY = '/usr/bin/scrot -s' # /usr/bin/import

def feed_xclipboard(str):
    pipe = Popen("xclip -sel clip", shell=True, stdin=PIPE).stdin
    pipe.write(str)
    pipe.close()

def import_screenshot():
    t = datetime.now()
    filename = NamedTemporaryFile(
        suffix='.png',
        prefix='screenshot_' + str(t.year) + "-" + str(t.month) + "-" + str(t.day) + "_" + str(t.hour) + ":" + str(t.minute) + ":" + str(t.second),
        dir = os.path.expanduser('~/Downloads'),
        delete=False).name
    p = Popen(SCREENSHOT_UTILITY + " " + filename, shell=True)
    sts = os.waitpid(p.pid, 0)[1]
    return filename


if __name__ == '__main__':
    screenshot = import_screenshot()
    feed_xclipboard(screenshot)
