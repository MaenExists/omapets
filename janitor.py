#!/usr/bin/env python3
import sys
import os
import shutil
import json

def get_dir_size(path):
    total = 0
    expanded = os.path.expanduser(path)
    if not os.path.exists(expanded):
        return 0
    try:
        for root, dirs, files in os.walk(expanded):
            for f in files:
                fp = os.path.join(root, f)
                try:
                    if not os.path.islink(fp):
                        total += os.path.getsize(fp)
                except Exception:
                    pass
    except Exception:
        pass
    return total

def fmt_size(b):
    if b >= 1024**3:
        return f"{b / (1024**3):.1f} GB"
    if b >= 1024**2:
        return f"{b / (1024**2):.1f} MB"
    if b >= 1024:
        return f"{b / 1024:.0f} KB"
    return f"{b} B"

def wipe_dir_contents(path):
    expanded = os.path.expanduser(path)
    if not os.path.exists(expanded):
        return
    for item in os.listdir(expanded):
        ip = os.path.join(expanded, item)
        try:
            if os.path.isdir(ip) and not os.path.islink(ip):
                shutil.rmtree(ip, ignore_errors=True)
            else:
                os.remove(ip)
        except Exception:
            pass

def scan():
    trash = get_dir_size("~/.local/share/Trash")
    thumb = get_dir_size("~/.cache/thumbnails")
    yay = get_dir_size("~/.cache/yay")
    brave = get_dir_size("~/.cache/BraveSoftware/Brave-Browser/Default/Cache") + \
            get_dir_size("~/.cache/BraveSoftware/Brave-Browser/Default/Code Cache")
    safe_total = trash + thumb + yay
    return {
        "trash": fmt_size(trash),
        "thumb": fmt_size(thumb),
        "yay": fmt_size(yay),
        "brave": fmt_size(brave),
        "total": fmt_size(safe_total),
        "safe_bytes": safe_total,
        "brave_bytes": brave
    }

def clean_safe():
    before = get_dir_size("~/.local/share/Trash") + get_dir_size("~/.cache/thumbnails") + get_dir_size("~/.cache/yay")
    wipe_dir_contents("~/.local/share/Trash/files")
    wipe_dir_contents("~/.local/share/Trash/info")
    wipe_dir_contents("~/.cache/thumbnails")
    wipe_dir_contents("~/.cache/yay")
    after = get_dir_size("~/.local/share/Trash") + get_dir_size("~/.cache/thumbnails") + get_dir_size("~/.cache/yay")
    freed = max(0, before - after)
    return {
        "status": "ok",
        "freed": fmt_size(freed if freed > 0 else before)
    }

def clean_browser():
    before = get_dir_size("~/.cache/BraveSoftware/Brave-Browser/Default/Cache") + \
             get_dir_size("~/.cache/BraveSoftware/Brave-Browser/Default/Code Cache")
    wipe_dir_contents("~/.cache/BraveSoftware/Brave-Browser/Default/Cache")
    wipe_dir_contents("~/.cache/BraveSoftware/Brave-Browser/Default/Code Cache")
    after = get_dir_size("~/.cache/BraveSoftware/Brave-Browser/Default/Cache") + \
            get_dir_size("~/.cache/BraveSoftware/Brave-Browser/Default/Code Cache")
    freed = max(0, before - after)
    return {
        "status": "ok",
        "freed": fmt_size(freed if freed > 0 else before)
    }

if __name__ == "__main__":
    action = sys.argv[1] if len(sys.argv) > 1 else "scan"
    if action == "clean":
        res = clean_safe()
    elif action == "clean_browser":
        res = clean_browser()
    else:
        res = scan()
    print(json.dumps(res))
