import requests
import json
import argparse
import string

parser = argparse.ArgumentParser(description='Downloads difficulty skill level for each recipe/item')
parser.add_argument('-o', '--outfile', type=str, help='File out', required=True)
args = parser.parse_args()


def getData(url):
    r = requests.get(url)

    search_str = '    data:'
    n = len(search_str)
    for line in r.text.split('\n'):
        if(search_str in line[:n]):
            data_str = line[n:].strip().strip(',')
            return json.loads(data_str)
    print('WARNING: Data not found for "%s!"' % url)
    return None


def item2Str(item):
    return '\t["%s"] = {b=%d, e=%d}' % (item['name'], item['colors'][1], item['colors'][3])


professions = ['alchemy', 'blacksmithing', 'cooking', 'tailoring', 'engineering',
               'leatherworking', 'enchanting', 'first-aid', 'mining', 'jewelcrafting']
# url_template='https://classic.wowhead.com/%s'
url_template = 'https://tbc.wowhead.com/%s'

with open(args.outfile, 'w') as fout:
    for prof in professions:
        print(prof)
        data = getData(url_template % prof.replace('_', '-'))
        data_str = [item2Str(item) for item in data if('colors' in item)]
        fout.write('\nlocal %s = {\n' % prof.replace('-', '_'))
        fout.write(",\n".join(data_str))
        fout.write('\n};\n')

    fout.write("\n")
    fout.write("local professions_table = {\n")
    profcode = ['\t["%s"] = %s' % (string.capwords(prof.replace('-', ' ')), prof.replace('-', '_'))
                for prof in professions]
    fout.write(",\n".join(profcode))
    fout.write("\n};")
