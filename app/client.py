import socket
import hashlib
import os

SERVER_HOST = "server-ip-here"
PORT = 5000
DATA_DIR = "/clientdata"
FILE_PATH = os.path.join(DATA_DIR, "received.txt")

def calculate_checksum(data):
    return hashlib.sha256(data).hexdigest()

def start_client():
    os.makedirs(DATA_DIR, exist_ok=True)

    with socket.socket() as s:
        s.connect((SERVER_HOST, PORT))

        checksum = s.recv(65).decode().strip()
        data = s.recv(2048)

        with open(FILE_PATH, "wb") as f:
            f.write(data)

        local_checksum = calculate_checksum(data)

        if checksum == local_checksum:
            print("Integrity verified ✅")
        else:
            print("Integrity failed ❌")

if __name__ == "__main__":
    start_client()
