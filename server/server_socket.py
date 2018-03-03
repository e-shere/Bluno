from time import sleep
import socket

serversocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
serversocket.bind(("192.168.0.7", 8081))
serversocket.listen(2)

while True:
    print("I am running")
    connection, address = serversocket.accept()
    print("Something connected")
    data = connection.recv(1024)
    if len(data) > 0:
        print("Received: " + data.decode())
        connection.send(data)
    connection.close()
    break

serversocket.close()

sleep(0.05)
