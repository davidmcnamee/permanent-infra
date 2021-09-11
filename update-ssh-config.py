from typing import Optional
import re
import sys
from os.path import expanduser

def find_hostname(lines, name) -> Optional[int]:
    """finds line number of HostName entry for the Host called 'name'"""
    j = 0
    for i, line in enumerate(lines):
        if line.startswith('Host ' + name):
            for j in range(i, len(lines)):
                if not lines[j].strip(): continue
                if lines[j].strip().startswith("HostName "):
                    return j
    return None

def main():
    ip = sys.argv[1]
    with open(expanduser('~/.ssh/config'), 'r') as f:
        lines = f.readlines()
        i = find_hostname(lines, "Dev-Environment")
        if i is None:
            lines.extend([
                "Host Dev-Environment\n",
                f"  HostName {ip}\n",
                "  User davidmcnamee\n",
            ])
        else:
            lines[i] = re.sub(r'\S+\s+$', ip+"\n", lines[i])
    with open(expanduser('~/.ssh/config'), 'w') as f:
        f.writelines(lines)
    with open(expanduser("~/.ssh/known_hosts"), "r") as f:
        lines = f.readlines()
        index = next((i for i, s in enumerate(lines) if s.startswith(ip)), None)
        if index is not None:
            lines.pop(index)
    with open(expanduser("~/.ssh/known_hosts"), "w") as f:
        f.writelines(lines)

if __name__ == '__main__':
    main()
