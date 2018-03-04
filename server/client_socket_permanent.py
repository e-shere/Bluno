import asyncio
import sys

@asyncio.coroutine
def connect(loop):
    reader,writer = yield from asyncio.open_connection('34.245.192.39', 8888)
    print("connected :)")
    return reader,writer

@asyncio.coroutine
def std_input(loop):
    reader = asyncio.StreamReader()
    reader_protocol = asyncio.StreamReaderProtocol(reader)
    print("set reader and reader protocol")
    yield from loop.connect_read_pipe(lambda: reader_protocol, sys.stdin)
    return reader

@asyncio.coroutine
def receiver(reader):
    while True:
        response = yield from reader.read(1)
        print(response.decode())
        

@asyncio.coroutine
def transmitter(writer,user_input):
    while True:
        line = yield from user_input.readline()
        print("read line", line.decode())
        writer.write(line)
        yield from writer.drain()


loop = asyncio.get_event_loop()
reader,writer  = loop.run_until_complete(connect(loop))
user_input = loop.run_until_complete(std_input(loop))
tasks = [loop.create_task(receiver(reader)), loop.create_task(transmitter(writer,user_input))]
loop.run_until_complete(asyncio.wait(tasks))
loop.close()

