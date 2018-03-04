import socket

clientsocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
clientsocket.connect(('34.244.91.108', 8888))

while True:
    data = input("what shall I send? ")
    clientsocket.send(data.encode())
    data = clientsocket.recv(1024)
    print(data.decode())
    
