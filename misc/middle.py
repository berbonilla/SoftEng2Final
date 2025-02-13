
def read_first_line(file_path):
    with open(file_path, 'r+') as file:
        lines = file.readlines() 
        if lines:  
            print(lines[0].strip())  
            file.seek(0)  
            file.writelines(lines[1:]) 
            file.truncate()  

read_first_line('misc/output.txt')