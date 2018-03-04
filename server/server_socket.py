import asyncio

clients = {}
def accept_client(client_reader, client_writer):
    ("There is a client!")
    task = asyncio.Task(handle_client(client_reader, client_writer))
    clients[task] = (client_reader, client_writer)

@asyncio.coroutine
def handle_client(client_reader, client_writer):
    client_writer.write("Hello\n".encode())
    while True:
        line = yield from client_reader.readline()
        if line.decode() == "":
            print("client left")
            break
        print("Received: ", line.decode())
        to_send= "You sent: " + line.decode()
        for client in clients:
            writer = clients[client][1]
            if writer == client_writer:
                continue
            writer.write(to_send.encode())
            yield from writer.drain()
    

loop = asyncio.get_event_loop()
f = asyncio.start_server(accept_client, host=None, port=8081)
print("I am running")
loop.run_until_complete(f)
loop.run_forever()
loop.close()


