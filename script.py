import random
import json
import mysql.connector
import time
from datetime import datetime, timedelta

conn = mysql.connector.connect(
    host="localhost",
    user="root",  
    password="", 
    database="autosync"
)
cursor = conn.cursor()

state_to_status = {
    "running": "Active",
    "idle": "Idle",
    "error": "Error"
}

machine_types = [
    "CNC Lathe", "Hydraulic Press", "Milling Machine", "Robotic Welder",
    "Injection Molder", "Laser Cutter", "Stamping Press", "Assembly Robot",
    "Grinding Machine", "Heat Treatment Oven", "Quality Control Scanner", "Packaging Line"
]


type_to_status = {
    "CNC Lathe": "CNC",
    "Milling Machine": "CNC",
    "Laser Cutter": "CNC",
    "Robotic Welder": "Other",
    "Injection Molder": "Other",
    "Stamping Press": "Other",
    "Hydraulic Press": "Other",
    "Assembly Robot": "Other",
    "Grinding Machine": "Other",
    "Heat Treatment Oven": "Other",
    "Quality Control Scanner": "Other",
    "Packaging Line": "Conveyor"
}

num_machines = 5

cursor.execute("SELECT COUNT(*) FROM Machine")
machine_count = cursor.fetchone()[0]

if machine_count == 0:
    print(f"No machines found. Generating {num_machines} new machines...")

    for i in range(1, num_machines + 1):
        machine_name = f"{machine_types[i]}_{i}"
        machine_type = (machine_types[i])  
        status = type_to_status.get(machine_type, "Other")  
        utilization = round(random.uniform(10, 50), 2)  
        num_of_processes = random.randint(1, 50)  
        workstationID = 1  

        sql = """
        INSERT INTO Machine (MachineName, MachineType, Status, Utilization, NumOfProcesses, WorkstationID)
        VALUES (%s, %s, %s, %s, %s, %s)
        """
        values = (machine_name, machine_type, status, utilization, num_of_processes, workstationID)
        cursor.execute(sql, values)

    conn.commit() 
    print("New machines successfully added.")

cursor.execute("SELECT MachineID, MachineName, MachineType, WorkstationID FROM Machine")
existing_machines = {}

for machine_id, name, machine_type, workstation in cursor.fetchall():

    if not machine_type or machine_type.strip() == "":
        machine_type = random.choice(machine_types)
        cursor.execute("UPDATE Machine SET MachineType = %s WHERE MachineID = %s", (machine_type, machine_id))
        conn.commit()
        print(f"Assigned missing type '{machine_type}' to machine '{name}'")

    existing_machines[name] = {"id": machine_id, "type": machine_type, "workstation": workstation}

print("✅ Machines Loaded Successfully:")
for name, details in existing_machines.items():
    print(f"- {name}: Type: {details['type']}, Workstation: {details['workstation']}")

def update_machine_status(machine):
    """Updates the status of a machine in the database, but keeps Workstation unchanged."""
    if machine["machine_name"] not in existing_machines:
        return  

    machine_id = existing_machines[machine["machine_name"]]["id"]
    percentage = machine["percentage"]

    if machine["state"] == "running":
        percentage = min(100, percentage + round(random.uniform(1, 5), 2))
        if percentage == 100:
            machine["state"] = "idle"

    if random.random() < 0.01:  
        machine["state"] = "error"

    sql = """
    UPDATE Machine 
    SET Status = %s, Utilization = %s, NumOfProcesses = %s
    WHERE MachineID = %s
    """  
    values = (
        state_to_status[machine["state"]],
        round(percentage, 2),
        random.randint(1, 100),
        machine_id
    )
    
    cursor.execute(sql, values)
    conn.commit()
    
    machine["percentage"] = percentage
    machine["current_time"] += timedelta(seconds=1)

def simulate_machines():
    """Simulates machine status updates every second."""
    while True:
        output = []
        
        for machine_name in existing_machines.keys():
            machine = {
                "machine_name": machine_name,
                "machine_type": existing_machines[machine_name]["type"],
                "workstation": existing_machines[machine_name]["workstation"],  
                "state": "running",
                "percentage": random.uniform(20, 60),
                "current_time": datetime.now().replace(microsecond=0)
            }
            
            update_machine_status(machine)
            output.append({
                "machine_name": machine["machine_name"],
                "machine_type": machine["machine_type"],
                "workstation": machine["workstation"],  
                "status": machine["state"],
                "percentage": round(machine["percentage"], 2),
                "current_time": machine["current_time"].strftime('%H:%M:%S')
            })
        
        print(json.dumps(output, indent=2))
        time.sleep(1)  
if __name__ == "__main__":
    simulate_machines()
    cursor.close()
    conn.close()
