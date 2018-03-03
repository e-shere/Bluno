import socket

clientsocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
clientsocket.connect(('34.244.91.108', 8888))
clientsocket.send('hello'.encode())
data = clientsocket.recv(1024)
print(data.decode())
