#!/usr/bin/env python

import os
import sys
import shutil
import json
import re
import codecs
import fnmatch
import pystache

def capitalize(s):
    if len(s) == 0: return s
    return s[0].upper() + s[1:]

def render(data, templatefile, outfile):
    with open(templatefile, 'r') as f:
        template = f.read()
        result = pystache.render(template, data)
        with codecs.open(outfile, "wb", encoding="utf-8") as f:
            f.write(result)
            # f.write(html.unescape(result))


def find_files(root_dir, file_pattern):
    matches = []
    for root, dirnames, filenames in os.walk(root_dir):
        for filename in filenames:
            fullname = os.path.join(root, filename)
            if fnmatch.fnmatch(filename, file_pattern):
                matches.append(os.path.join(root, filename))
    matches.sort()
    return matches

def get_field_name(line):
    m = re.match("(\w*)\.(\w*) = function.*", line)
    if m:
        return m.groups()[1]
    m = re.match("function (\w*)\.(\w*)", line)
    if m:
        return m.groups()[1]
    m = re.match("(\w*)\.(\w*) = .*", line)
    if m:
        return m.groups()[1]
    return None

def parse_param(line, param):
    line = line.replace("@" + param + " ", "")
    param_name = line.split(' ', 1)[0]
    param_desc = line.removeprefix(param_name).strip()
    return {
        "name": param_name,
        "description": capitalize(param_desc),
        "type": None if param == "param" else param
    }


def process_entry(line, lines):
    entry = {}
    line = line.replace("---", "")
    if line.startswith(" "):
        entry["summary"] = capitalize(line.strip())
    entry["description"] = ""
    entry["usage"] = None
    entry["params"] = []
    entry["returns"] = []
    while len(lines) > 0:
        line = lines.pop(0).strip()
        
        # end of entry
        # try to figure out name of entry (unless it has been explicitly set)
        if not line.strip().startswith("--"):
            if "name" not in entry:
                entry["name"] = get_field_name(line)
            break
        
        line = line[3:]
        # generic parameter
        if line.startswith("@param"):
            entry["params"].append(parse_param(line, "param"))

        # typed parameter
        elif line.startswith("@number"):
            entry["params"].append(parse_param(line, "number"))
        elif line.startswith("@string"):
            entry["params"].append(parse_param(line, "string"))
        elif line.startswith("@table"):
            entry["params"].append(parse_param(line, "table"))
        elif line.startswith("@function"):
            entry["params"].append(parse_param(line, "function"))
        elif line.startswith("@bool"):
            entry["params"].append(parse_param(line, "bool"))
        elif line.startswith("@vec2"):
            entry["params"].append(parse_param(line, "vec2"))

        # generic return
        elif line.startswith("@return"):
            line = line.replace("@return", "").strip()
            m = re.match("(\w*?) (.*)", line)
            if m:
                return_name = m.groups()[0]
                return_desc = m.groups()[1]
                entry["returns"].append({
                    "name": return_name,
                    "description": capitalize(return_desc)
                })
        # typed return
        elif line.startswith("@treturn"):
            line = line.replace("@treturn", "").strip()
            m = re.match("(\w*?) (\w*?) (.*)", line)
            if m:
                return_type = m.groups()[0]
                return_name = m.groups()[1]
                return_desc = m.groups()[2]
                entry["returns"].append({
                    "name": return_name,
                    "type": return_type,
                    "description": capitalize(return_desc)
                })
        # typed parameter
        elif line.startswith("@tparam"):
            line = line.replace("@tparam", "").strip()
            m = re.match("(\w*?) (\w*?) (.*)", line)
            if m:
                param_type = m.groups()[0]
                param_name = m.groups()[1]
                param_desc = m.groups()[2]
                entry["params"].append({
                    "name": param_name,
                    "type": param_type,
                    "description": capitalize(param_desc)
                })
        elif line.startswith("@field"):
            entry["field"] = True
            m = re.match("\@field (.*)", line)
            if m:
                entry["field_type"] = m.groups()[0]
        elif line.startswith("@name"):
            line = line.replace("@name", "").strip()
            entry["name"] = line
        elif line.startswith("@usage"):
            entry["usage"] = line.replace("@usage", "")
        elif line.startswith("@"):
            m = re.match("\@(\w*?) (.*)", line)
            if m:
                tag = m.groups()[0]
                text = m.groups()[1]
                entry[tag] = text
            else:
                print("Found unknown tag: " + line)
        else:
            if entry.get("usage") is not None:
                entry["usage"] = entry["usage"] + line + "\n"
            else:
                entry["description"] = entry["description"] + line + " "

    has_params = len(entry["params"]) > 0
    if has_params:
        params = []
        for p in entry["params"]:
            params.append(p["name"])
        entry["params_string"] = ",".join(params)

    entry["has_params"] = has_params
    entry["has_returns"] = len(entry["returns"]) > 0
    entry["description"] = capitalize(entry["description"].strip())
    return entry


def process_lines(lines):
    print("Processing {}".format(filename))
    entries = []
    while len(lines) > 0:
        line = lines.pop(0).strip()
        if line.startswith("---"):
            entry = process_entry(line, lines)
            entries.append(entry)
    return entries


groups_lookup = {}
files = find_files("boom", "*.lua")
for filename in files:
    with open(filename, encoding='utf-8', errors='ignore') as f:
        lines = f.readlines()
        file_description = None
        first_line = lines.pop(0).strip()
        if first_line.startswith("--- "):
            file_description = process_entry(first_line, lines)
        if not file_description:
            file_description = {}
        else:
            file_description["file_summary"] = file_description["summary"]
            file_description["file_description"] = file_description["description"]
            file_description["summary"] = None
            file_description["description"] = None
        
        file_entries = process_lines(lines)
        if file_entries:
            # components, events, info etc
            if "group" not in file_description:
                group_name = os.path.dirname(filename).replace("boom/", "")
                file_description["group"] = group_name
            if "module" not in file_description:
                module = os.path.basename(filename).replace(".lua", "")
                file_description["module"] = module
            file_description["entries"] = file_entries
            file_description["filename"] = filename

            group_name = file_description["group"]
            if group_name not in groups_lookup:
                groups_lookup[group_name] = {
                    "group": group_name,
                    "files": []
                }
            groups_lookup[group_name]["files"].append(file_description)


groups = []
for group_name in groups_lookup.keys():
    group = groups_lookup.get(group_name)
    groups.append(group)


api = { "groups": groups }
with open("api.json", "w", encoding='utf-8') as f:
    json.dump(api, f, indent=4, sort_keys=True)

render(api, "api_markdown.mtl", "api.md")
render(api, "api_script.mtl", os.path.join("boom", "api", "boom.script_api"))
