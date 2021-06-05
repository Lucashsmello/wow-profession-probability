import requests
import json
import argparse

parser = argparse.ArgumentParser(description='Downloads difficulty skill level for each recipe/item')
parser.add_argument('-o', '--outfile', type=str, help='File out', required=True)
args=parser.parse_args()


def getData(url):
	r=requests.get(url)

	search_str='    data:'
	n=len(search_str)
	for line in r.text.split('\n'):
		if(search_str in line[:n]):
			data_str=line[n:].strip().strip(',')
			return json.loads(data_str)
	print('WARNING: Data not found for "%s!"' % url)
	return None
	
def item2Str(item):
	return '\t["%s"] = {b=%d, e=%d}' % (item['name'],item['colors'][1],item['colors'][3])

professions=['alchemy', 'blacksmithing', 'cooking', 'tailoring', 'engineering',
	'leatherworking', 'enchanting', 'first_aid', 'mining']
url_template='https://classic.wowhead.com/%s'

with open(args.outfile,'w') as fout:
	for prof in professions:
		print(prof)
		data=getData(url_template % prof.replace('_','-'))
		data_str=[item2Str(item) for item in data if('colors' in item)]
		fout.write('\nlocal %s = {\n' % prof)
		fout.write(",\n".join(data_str))
		fout.write('\n};\n')

