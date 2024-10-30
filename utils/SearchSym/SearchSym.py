import os
import re

allowed_pattern = re.compile(r'^[\w\s.,!?()\"\'-+*/=<>:;{}[\]()&|^%$#@!~`\\/]*$', re.UNICODE)
excluded_extensions = {'.jpg', '.png', '.exe', '.gif', '.zip', '.tar', '.gz', '.ico', '.svg', '.yaml', '.md', '.pack', '.odt', '.icns', '.idx', '.txt', '.jar', '.rsrc', '.qmodel', '.tm', '.qm'}

def find_invalid_characters_in_file(file_path, output_file):
    try:
        _, ext = os.path.splitext(file_path)

        if ext.lower() in excluded_extensions:
            print(f"Файл {file_path} исключен из проверки.")
            return
        
        with open(file_path, 'r', encoding='utf-8', errors='ignore') as file:
            content = file.read()
            for line_number, line in enumerate(content.splitlines(), start=1):
                if not allowed_pattern.match(line):
                    result = f"Invalid characters found in the file {file_path}, line {line_number}: {line} \n"
                    print(result.strip())
                    output_file.write(result)  
    except FileNotFoundError:
        print(f"file not found: {file_path}")
    except Exception as e:
        print(f"An error occurred while processing the file {file_path}: {e}")


def search_directory(directory, output_file):
    for root, dirs, files in os.walk(directory):
        for file in files:
            file_path = os.path.join(root, file)
            find_invalid_characters_in_file(file_path, output_file)

if __name__ == "__main__":
    directory_to_search = input("Enter the path to the directory to search for: ")
    output_file_path = "result.txt"

    with open(output_file_path, 'w', encoding='utf-8') as output_file:
        search_directory(directory_to_search, output_file)
    
    print(f"The results are recorded in a file: {output_file_path}")
