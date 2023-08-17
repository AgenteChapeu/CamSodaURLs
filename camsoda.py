from urllib.parse import urlsplit


blacklist_keywords = [
	'',
	'media',
	'tags',
	'robots.txt',
	'redir',
	'press',

]

blacklist_suffixes = [
	'-cams'
]

def parse_models(filename):
	ret = []
	with open(filename) as fd:
		for line in fd:
			line = line.strip().strip('"')
			url = urlsplit(line)
			if( url.netloc == 'www.camsoda.com' ):
				path = url.path.split('/')
				if(len(path) == 2):
					if(not any([path[1].endswith(suffix) for suffix in blacklist_suffixes])):
						if(path[1] not in blacklist_keywords):
							ret.append(path[1])
	return list(set(ret))


def parse_tags(filename):
	ret = []
	with open(filename) as fd:
		for line in fd:
			line = line.strip().strip('"')
			url = urlsplit(line)
			if( url.netloc == 'www.camsoda.com' ):
				path = url.path.split('/')
				if(len(path) > 2):
					if(path[1] == 'tag'):
						ret.append(path[2])
	return list(set(ret))


def parse_cams(filename):
	ret = []
	with open(filename) as fd:
		for line in fd:
			line = line.strip().strip('"')
			url = urlsplit(line)
			if( url.netloc == 'www.camsoda.com' ):
				path = url.path.split('/')
				try:
					int(path[-1])
					ret.append(url)
				except ValueError as e:
					pass
	return list(set(ret))


for tag in parse_cams("URLs-20230818.txt"):
	print(tag)

