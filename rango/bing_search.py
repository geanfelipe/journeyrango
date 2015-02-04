import json 
import urllib, urllib2
from keys import BING_API_KEY



def run_query(search_tems):
	#specify_database
	root_url = 'https://api.datamarket.azure.com/Bing/Search/'
	source = 'Web'

	#specify how many results i wish to be returned per page
	#offset specifies where in the results list to start from
	#with results per page = 10 and offset = 11 this would start from page 2
	result_per_page = 10
	offset = 0

	query = "'{0}'"	.format(search_tems)
	query = urllib.quote(query)

	search_url = "{0}{1}?$format=json&$top={2}&$skip={3}&Query={4}".format(
		root_url,
		source,
		result_per_page,
		offset,
		query)

	username = ''

	password_mgr = urllib2.HTTPPasswordMgrWithDefaultRealm()
	password_mgr.add_password(None,search_url,username,BING_API_KEY)

	#create results list which to be populated
	results = []

	try:
		#prepare for connecting to bing's serves
		handler = urllib2.HTTPBasicAuthHandler(password_mgr)
		opener = urllib2.build_opener(handler)
		urllib2.install_opener(opener)

		#connect to the server and read the response generated
		response = urllib2.urlopen(search_url).read()

		#convert the string response to a python dict objc
		json_response = json.loads(response)

		#loop to populate results list
		for result in json_response['d']['results']:
			results.append({
				'title':result['Title'],
				'link':result['Url'],
				'summary':result['Description']
				})

	except urllib2.URLError, e:
		print "Error when queryng the bing API: ",e

		#returns the list of results			
	return results

if __name__ == '__main__':
	pesquisa = raw_input("pesquisa: ")
	print (run_query(pesquisa))
