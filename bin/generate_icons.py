#! /usr/bin/env python

import os
import sys
import json

usage = "Usage: generate_icons <input_svg>"
APP_ICON_DIR="AppIcon.appiconset"

icon_definitions_newer = {
    # IPHONE
    "iphone_notification-20x20@2x.png": "40x40",
    "iphone_notification-20x20@3x.png": "60x60",
    "iphone_settings-29x29.png": "29x29",
    "iphone_settings-29x29@2x.png": "58x58",
    "iphone_settings-29x29@3x.png": "87x87",
    "iphone_spotlight-40x40@2x.png": "80x80",
    "iphone_spotlight-40x40@3x.png": "120x120",
    "iphone_app-60x60@2x.png": "120x120",
    "iphone_app-60x60@3x.png": "180x180",
    # IPAD 
    "ipad_notifications-20x20.png": "20x20",
    "ipad_notifications-20x20@2x.png": "40x40",

    "ipad_settings-29x29.png": "29x29",
    "ipad_settings-29x29@2x.png": "58x58",

    "ipad_spotlight-40x40.png": "40x40",
    "ipad_spotlight-40x40@2x.png": "80x80",

    "ipad_app-76x76.png": "76x76",
    "ipad_app-76x76@2x.png": "152x152",
    # IPAD PRO
    "ipad_pro-app-83_5@2x.png": "167x167",

    # APP STORE
    "ios-marketing_app-store.png": "1024x1024"
}

def parse_scale(icon_name):
    split_by_at = icon_name.split('@')
    if len(split_by_at) > 1:
        return split_by_at[-1].split('.')[0]
    return "1x"

def size_for_json(actual_size, scale):
    w, h = tuple(map(lambda x: float(x), actual_size.split('x')))
    scaled_w = w/scale
    scaled_h = h/scale
    scaled_w = int(scaled_w) if scaled_w.is_integer() else scaled_w
    scaled_h = int(scaled_h) if scaled_h.is_integer() else scaled_h
    return "{0}x{1}".format(scaled_w, scaled_h)

def save_json_representation(directory):
    icon_representations = []
    for icon_name, size in icon_definitions_newer.items():
        parsed_scale = parse_scale(icon_name)
        scale_number = int(parsed_scale.split('x')[0])
        parsed_idiom = icon_name.split('_')[0]
        icon_representations.append({
            "filename": icon_name,
            "size": size_for_json(size, scale_number),
            "idiom": parsed_idiom,
            "scale": parse_scale(icon_name)
        })

    with open(directory + "/" + "Contents.json", "w") as contents_file:
        json.dump({
            "images": icon_representations,
            "info": {
                "author" : "xcode",
                "version" : 1
            }
        }, contents_file, indent=2)

def main():
    if len(sys.argv) != 2:
        print(usage)
        return

    os.mkdir(APP_ICON_DIR)
    save_json_representation(APP_ICON_DIR)

    input_svg = sys.argv[1]
    for icon_name, size in icon_definitions_newer.items():
        edge_size = size.split('x')[0]
        os.system("inkscape -D --export-type=png -o {0} -w {1} -h {2} {3}".format(APP_ICON_DIR + "/" + icon_name, edge_size, edge_size, input_svg))

if __name__ == '__main__':
    main()
