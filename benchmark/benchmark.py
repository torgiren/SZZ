#!/usr/bin/env python
import time
import threading
import random
import os
import matplotlib.pyplot as plt
quit = False
class Requester(threading.Thread):
    def run(self):
        self.times = []
        while not quit:
            self.times.append(time.time())
            time.sleep(1.0 + random.random() )
watki = [Requester() for i in range(100)]
for i in watki:
    i.start()
plt.ion()
plt.axis([0,20,0,3000])
plt.show(block=False)
start = time.time()
try:
    while True:
        t = time.time()
        for i in watki:
            inter = [j for j in i.times if j > (time.time() - 30)]
            inter,probki = list(map(lambda x,y: int(1000*(y-x)), inter[:-1], inter[1:])), list(map(lambda x: x - inter[0], inter[1:]))
#            inter.append(time.time() - i.times[-1])
#            inter = map(lambda x: int(1000*x), inter)
#            print(list(inter))
#            print(inter[:])
#            print(probki) 
            plt.plot(probki, inter)
#            print(i.times)
#            plt.scatter(time.time() - start, inter[-1],marker='.')
        time.sleep(0.1)
        plt.draw()
        plt.clf()
        plt.axis([0,40,0,3000])
#        os.system("clear")
#        print(time.time() - t - 0.1)
except KeyboardInterrupt:
    pass
quit = True
for i in watki:
    i.join()
