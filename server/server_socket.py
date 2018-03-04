import asyncio

clients = {}
def accept_client(client_reader, client_writer):
    task = asyncio.Task(handle_client(client_reader, client_writer))
    clients[task] = (client_reader, client_writer)

@asyncio.coroutine
def handle_client(client_reader, client_writer):
    print("Client connected")
    client_writer.write("HELLO\n".encode())
    while True:
        line = yield from client_reader.readline()
        if line.decode() == "":
            print("Client left")
            break
        print("Received: ", line.decode().rstrip())
        for client in clients:
            writer = clients[client][1]
            if writer == client_writer:
                continue
            writer.write(line)
            yield from writer.drain()
    

loop = asyncio.get_event_loop()
f = asyncio.start_server(accept_client, host=None, port=8888)
print("Server running")
loop.run_until_complete(f)
loop.run_forever()
loop.close()


