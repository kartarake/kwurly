import json
import os

def load_json(file_path:str) -> dict:
    with open(file_path, "r") as f:
        data = json.load(f)
    return data

def whitelist(paths:list) -> list:
    blacklist = load_json("data/checkignore.json")
    return [path for path in paths if not path in blacklist]

def check_repeat() -> dict:
    output = {}
    paths = whitelist(os.listdir("data/"))
    data = {}

    for path in paths:
        nouns = load_json(f"data/{path}")
        for noun in nouns["nouns"]:
            if not noun in data:
                data[noun] = [path]
            else:
                data[noun].append(path)
    
    for noun in data:
        if len(data[noun]) > 1:
            output[noun] = data[noun]
    
    total_repeats = sum([len(v) for v in output.values()])
    pretty_output = json.dumps(output, indent=4).split("\n")
    for line in pretty_output:
        print(line)
    print(f"Total repeats: {total_repeats}")

if __name__ == "__main__":
    check_repeat()