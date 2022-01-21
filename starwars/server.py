import socket
import sys
import os
from time import sleep


STAR_WARS_FILE = 'starwars.ascii'
FRAME_DELAY = 0.2 #seconds

def load_animation(filename):
    path = os.path.join(os.getcwd(), STAR_WARS_FILE)
    with open(path, "r") as f:
        data = f.readlines()

    return data

def generate_frames(animation_data):
    frame = ""
    END_OF_FRAME = chr(27)
    for line in animation_data:
        frame += line
        if END_OF_FRAME in line:
            yield frame
            frame = ""

def main(listen_host, listen_port, animation_data):
    print(f"listening on {listen_host}:{listen_port}")

    while True:
        with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as sock:

            sock.bind((listen_host, listen_port))
            sock.listen()

            connection, client_ip = sock.accept()
            with connection:
                for frame in generate_frames(animation_data):
                    try:
                        connection.sendall(frame.encode('utf-8'))
                    except BrokenPipeError:
                        continue
                    sleep(FRAME_DELAY)
            connection.close()

if __name__ == "__main__":
    animation = load_animation(STAR_WARS_FILE)
    main(os.environ.get("LISTEN_HOST", "localhost"), os.environ.get("LISTEN_PORT", 8080), animation)
