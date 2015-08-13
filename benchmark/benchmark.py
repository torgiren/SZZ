#!/usr/bin/env python
import time
import threading
import random
import os
import matplotlib.pyplot as plt
import urllib
quit = False
codes = []


class Requester(threading.Thread):
    def run(self):
        self.times = []
        while not quit:
            self.times.append(time.time())
#            time.sleep(1.0 + random.random() )
            ret = urllib.urlopen('http://test.pl/?fib=25')
            if ret.code is not 200:
                codes.append(ret.code)
#            urllib.request.urlopen('http://paczkomaty.pl')
horyzont = 60
watki = [Requester() for i in range(200)]
for i in watki:
    i.start()
plt.ion()
timeout_axis = 10000
plt.axis([0, timeout_axis, 0, 1])
plt.show(block=False)
start = time.time()
stacked = [[0 for i in range(9)] for j in range(horyzont * 10)]
try:
    while True:
        t = time.time()
        agregated = []
        for i in watki:
            inter = [j for j in i.times if j > (time.time() - horyzont)]
            inter = list(map(lambda x, y: int(1000*(y-x)), inter[:-1], inter[1:]))
#            inter, probki = (list(map(lambda x, y: int(1000*(y-x)), inter[:-1], inter[1:])),
#                             list(map(lambda x: x - inter[0], inter[1:])))
            inter.append(int(1000*(time.time() - i.times[-1])))
#            extra = probki[-1] if len(probki) else 0
#            probki.append(time.time() - i.times[-1] + extra)
            agregated.extend(inter)

#            inter = map(lambda x: int(1000*x), inter)
#            print(list(inter))
#            print(inter[:])
#            print(probki)
#            plt.plot(probki, inter)
#            print(i.times)
#            plt.scatter(time.time() - start, inter[-1],marker='.')
        time.sleep(0.01)
#        print(len(agregated))
        plt.subplot(2,2,1)
        plt.hist(agregated,bins=50, normed=True, cumulative=False, histtype='step', range=(0,10000))
        plt.subplot(2,2,3)
        plt.hist(agregated,bins=100, normed=True, cumulative=False, histtype='step', range=(0,60000))
        ax = plt.subplot(1,2,2)
        ax.yaxis.tick_right()
        ax.yaxis.set_label_position("right")
        agregated.sort()
        l = len(agregated)
        if l:
            x = range(horyzont * 10)
            y = [agregated[int(l*0.5)],
                agregated[int(l*0.6)],
                agregated[int(l*0.75)],
                agregated[int(l*0.8)],
                agregated[int(l*0.9)],
                agregated[int(l*0.95)],
                agregated[int(l*0.98)],
                agregated[int(l*0.99)],
                agregated[-1]]
#            print(y)
            stacked.append(y)
            stacked = stacked[-horyzont * 10:]
#            print(x)
#            print(stacked)

#            print(len(x))
            stacked_t = zip(*stacked)
#            print(len(stacked_t))
#            print(len(stacked_t[0]))
#            print(stacked)
#            print(stacked_t[0])
            plt.plot(x, stacked_t[0], label="50%")
            plt.plot(x, stacked_t[1], label="66%")
            plt.plot(x, stacked_t[2], label="75%")
            plt.plot(x, stacked_t[3], label="80%")
            plt.plot(x, stacked_t[4], label="90%")
            plt.plot(x, stacked_t[5], label="95%")
            plt.plot(x, stacked_t[6], label="98%")
            plt.plot(x, stacked_t[7], label="99%")
            plt.plot(x, stacked_t[8], label="100%")
            plt.legend(loc=2)
        plt.draw()
        plt.clf()
        if l:
            print("50%:  {}\n66%:  {}\n75%:  {}\n80%:  {}\n90%:  {}\n95%:  {}\n98%:  {}\n99%:  {}\n100%: {}\n".format(
                                                              agregated[int(l*0.5)],
                                                              agregated[int(l*0.6)],
                                                              agregated[int(l*0.75)],
                                                              agregated[int(l*0.8)],
                                                              agregated[int(l*0.9)],
                                                              agregated[int(l*0.95)],
                                                              agregated[int(l*0.98)],
                                                              agregated[int(l*0.99)],
                                                              agregated[-1]))
        print(codes)
#        plt.axis([0,timeout_axis,0,1])
#        os.system("clear")
#        print(time.time() - t - 0.1)
except KeyboardInterrupt:
    pass
quit = True
for i in watki:
    i.join()

print("Jakis klawisz, albo co")
raw_input()
