"""
A python script containing some features to handle data of the application manually.
"""
import json
import os

help:str = """\
insert - call for inserting new words in to the json data collection.
list files - call to list out all file paths in data collection.
list sizes - call to list out all file paths + sizes in data collection.
<exit/quit/q> - call for exiting the program.
"""

ignorelist:list[str] = [
    "manager.py",
    "download.py"
]

def simplify(word:str) -> str:
    return word.strip().lower()

def fetcFileList(path:str) -> list[str]:
    paths = os.listdir(path)
    return [path for path in paths if path not in ignorelist]

def isFileFull(path:str) -> bool:
    if os.path.getsize(path) > 1048576:
        return True
    else:
        return False
    
def insertIntoFile(data:list[str]) -> None:
    paths = fetcFileList("./src/data/")
    
    for path in paths:
        if isFileFull(path):
            continue
        else:
            with open(path, "r") as f:
                content:list = json.load(f)
            content.extend(data)
            with open(path, "w") as f:
                json.dump(content, f)
            break

    else: # Catches when there is no file to fill
        with open(f"./src/data/words{len(paths)+1}.json", "w") as f:
            json.dump(data, f)

def displaySizes() -> None:
    paths = fetcFileList("./src/data/")
    for path in paths:
        print(f"{path} size:{os.path.getsize(f'./src/data/{path}')} bytes")


def main() -> None:
    print("The manager for the data collection. Call 'help' for more information.")
    while True:
        query = input("manager $ ")

        if query in ("exit", "quit", "q"):
            break

        elif query == "help":
            print(help)

        elif query.startswith("insert "):
            data = json.loads(query[7:])
            insertIntoFile(data)
            print(f"Sucessfully inserted {len(data)} words into the data collection.")

        elif query == "list files":
            paths = fetcFileList("./src/data/")
            print(json.dumps(paths))

        elif query == "list sizes":
            displaySizes()

        else:
            print("Invalid query. Try 'help' cmd for more information")

        print() # To leave a gap after every query / iteration.


if __name__ == "__main__":
    main()