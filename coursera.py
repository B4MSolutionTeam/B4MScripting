import threading

def test_thread(a):
    a = a + 1
    return a
t1 = threading.Thread(target = test_thread,args=[1])
t1.start()
print(t1.join())