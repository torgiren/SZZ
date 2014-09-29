#!/usr/bin/env python
import time
import threading
import random
import os
quit = False
class Requester(threading.Thread):
    def run(self):
        self.times = []
        while not quit:
            self.times.append(time.time())
            time.sleep(1.0 + random.random() )
watki = [Requester() for i in range(90)]
for i in watki:
    i.start()
try:
    while True:
        t = time.time()
        for i in watki:
            inter = [j for j in i.times if j > (time.time() - 20)]
            inter = list(map(lambda x,y: y-x, inter[:-1], inter[1:]))
            inter.append(time.time() - i.times[-1])
            inter = map(lambda x: int(1000*x), inter)
            print(inter)
        time.sleep(0.1)
        os.system("clear")
#        print(time.time() - t - 0.1)
except KeyboardInterrupt:
    pass
quit = True
for i in watki:
    i.join()
