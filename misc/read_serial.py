import serial
import time

arduino_port = 'COM3'
baud_rate = 9600
output_file = 'misc/output.txt'

def save_to_file(line):
    with open(output_file, 'r+') as file:
        lines = file.readlines()    
        if lines:
            lines[0] = line + '\n'
        else:
            lines.append(line + '\n')
        file.seek(0)
        file.writelines(lines)

try:
    ser = serial.Serial(arduino_port, baud_rate, timeout=1)

    while True:
        line = ser.readline().decode("utf-8").strip()

        if line:
            print(line)
            save_to_file(line)
        else:
            time.sleep(0.0001)

except Exception as e:
    print(f"Error: {e}")