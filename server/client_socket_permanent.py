import asyncio

@asyncio.coroutine
def connect(loop):
    reader,writer = yield from asyncio.open_connection('34.245.192.39', 8888)
    print("connected :)")
    return reader,writer

@asyncio.coroutine
def receiver(reader):
    while True:
        response = yield from reader.read(1)
        print(response.decode())
        

@asyncio.coroutine
def transmitter(writer):
    while True:
        yield from asyncio.sleep(1)
        writer.write("A".encode())
        yield from writer.drain()

loop = asyncio.get_event_loop()
reader,writer  = loop.run_until_complete(connect(loop))
tasks = [loop.create_task(receiver(reader)), loop.create_task(transmitter(writer))]
loop.run_until_complete(asyncio.wait(tasks))
loop.close()

