#!/usr/bin/env python3

import argparse
import ssl, urllib, urllib.request, urllib.error
import base64
import json
import sys, os

class BattleNetAPI():
	clientID  = os.environ.get("CLIENTID")
	secret    = os.environ.get("BLSECRET")
	token     = ""
	def __init__(self, region: str) -> None:
		# get the access token
		self.region = region
		self.request = urllib.request.Request( "https://oauth.battle.net/token" )
		userpassword = base64.b64encode( (f'{self.clientID}:{self.secret}').encode('ascii') )
		self.request.add_header( "Authorization", "Basic %s" % userpassword.decode('ascii') )
		self.context = ssl._create_unverified_context()
		self.request.add_header( "User-Agent", 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36' )
		data = urllib.parse.urlencode( { 'grant_type': 'client_credentials' } ).encode('utf-8')
		result = urllib.request.urlopen( self.request, context=self.context, data=data )
		tokenJSON = result.read().decode('utf-8')
		self.access_token = json.loads( tokenJSON )['access_token']
	def __makeAPIRequest(self, endPoint: str) -> None:
		""" This sets self.request """
		url = f'https://{self.region}.api.blizzard.com{endPoint}'
		self.request = urllib.request.Request( url )
		self.request.add_header( "Authorization", "Bearer %s" % self.access_token )
	def getPetIndex(self, local: str="en_US") -> dict:
		# https://us.api.blizzard.com/data/wow/pet/index?namespace=static-us&locale=en_US
		self.__makeAPIRequest(f'/data/wow/pet/index?namespace=static-{self.region}&locale={local}')
		result = urllib.request.urlopen( self.request, context=self.context )
		return json.loads(result.read().decode('utf-8'))

class PetData():
	def __init__(self, stringIn: str) -> None:
		self.data = json.loads(stringIn)
		self.newPets = []
		self.missingPersonalities = []
	def set(self, id: int, name: str) -> None:
		# print(id, name, self.data)
		try:
			self.data[str(id)]["name"] = name
		except KeyError:
			self.data[str(id)] = { "name": name, "personality": "" }
			self.newPets.append((id, name))
		if self.data[str(id)]["personality"] == "":
			self.missingPersonalities.append((id, name))
	def compact_inner(self, obj, level=0):
		"""Pretty-print JSON but compact innermost dictionaries/lists onto one line."""
		if isinstance(obj, dict):
			# Check if values are primitive (leaf dict)
			if all(not isinstance(v, (dict, list)) for v in obj.values()):
				return json.dumps(obj, ensure_ascii=False)
			parts = []
			for k, v in obj.items():
				parts.append(f'{json.dumps(k)}: {self.compact_inner(v, level + 1)}')
			indent = " " * 4 * level
			inner_indent = " " * 4 * (level + 1)
			return "{\n" + inner_indent + (",\n" + inner_indent).join(parts) + "\n" + indent + "}"
		elif isinstance(obj, list):
			if all(not isinstance(v, (dict, list)) for v in obj):
				return json.dumps(obj, ensure_ascii=False)
			parts = [self.compact_inner(v, level + 1) for v in obj]
			indent = " " * 4 * level
			inner_indent = " " * 4 * (level + 1)
			return "[\n" + inner_indent + (",\n" + inner_indent).join(parts) + "\n" + indent + "]"
		else:
			return json.dumps(obj, ensure_ascii=False)
	def save(self, outFile) -> None:
		data = dict(sorted(self.data.items(), key=lambda item: item[1]["name"]))
		textOut = json.dumps( data, ensure_ascii=False, indent=None )
		textOut = textOut.replace( "},","},\n")
		with open(outFile, "w", encoding="utf-8") as f:
			f.write(textOut)
	def __del__(self):
		print(f'There are {len(self.newPets)} new Pets.\n{self.newPets}')
		print(f'The pets are missing personalities: {self.missingPersonalities}')


if __name__=="__main__":
	parser = argparse.ArgumentParser()
	parser.add_argument( "-r", "--region", choices=["us","eu","kr","tw"], default="us",
			help="Region to query")
	parser.add_argument( "-f", "--petfile", type=argparse.FileType('r'), default=sys.stdin,
					 help="JSON file of current data" )
	parser.add_argument( "-o", "--outfile",
					 help="JSON output file")
	parser.add_argument( "-l", "--luafile",
					 help="Lua output file")

	args = parser.parse_args()
	print( args )
	petData = PetData(args.petfile.read())
	if args.petfile is not sys.stdin:
		args.petfile.close()
	# print(petData.data)

	BN = BattleNetAPI( args.region )
	petIndexData = BN.getPetIndex()["pets"] # this is a list.

	for pet in petIndexData:
		petData.set( pet["id"], pet["name"] )
	petData.save( args.outfile )

	if args.luafile:
		with open(args.luafile, "w", encoding="utf-8") as f:
			f.write("_, CritterEmote = ...\nCritterEmote.Personalities = {\n")
			data = sorted(petData.data.items(), key=lambda item: item[1]["name"])
			for d in data:
				# f.write(f'["{d[1]["name"]}"] = "{d[1]["personality"]}",\n')
				f.write(f'[{d[0]:>5}] = "{d[1]["personality"]}", -- {d[1]["name"]}\n')
			f.write("}")
