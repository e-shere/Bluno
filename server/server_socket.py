from time import sleep
import socket

serversocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
serversocket.bind(("", 8888))
serversocket.listen(2)
print("I am running")

while True:
    connection, address = serversocket.accept()
    print("Something connected")
    data = connection.recv(1024)
    if len(data) > 0:
        print("Received: " + data.decode())
        connection.send(data)
    connection.close()

serversocket.close()

sleep(0.05)
