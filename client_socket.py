import socket

clientsocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
clientsocket.connect(('192.168.0.7', 8081))
clientsocket.send('hello'.encode())
data = clientsocket.recv(1024)
print(data.decode())
