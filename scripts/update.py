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
		if self.clientID == None or self.secret == None:
			print( "CLINETID and BLSECRET need to set in the environment first." )
			sys.exit(1)
		# get the access token
		self.region = region
		self.request = urllib.request.Request( "https://oauth.battle.net/token" )
		userpassword = base64.b64encode( (f'{self.clientID}:{self.secret}').encode('ascii') )
		self.request.add_header( "Authorization", "Basic %s" % userpassword.decode('ascii') )
		self.context = ssl._create_unverified_context()
		self.request.add_header( "User-Agent", 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_1) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/39.0.2171.95 Safari/537.36' )
		data = urllib.parse.urlencode( { 'grant_type': 'client_credentials' } ).encode('utf-8')
		try:
			result = urllib.request.urlopen( self.request, context=self.context, data=data )
			if result.status != 200:
				print(f"Unexpected status code: {result.status}")
				sys.exit(result.status)
			else:
				tokenJSON = result.read().decode('utf-8')
				self.access_token = json.loads( tokenJSON )['access_token']
		except urllib.error.HTTPError as e:
			# This handles HTTP status codes like 404, 500, etc.
			print(f"HTTP error: {e.code} - {e.reason}")
			sys.exit(1)
		except urllib.error.URLError as e:
			# This handles connection errors, DNS errors, etc.
			print(f"URL error: {e.reason}")
			sys.exit(1)
		except Exception as e:
			# Any other unexpected errors
			print(f"Unexpected error: {e}")
			sys.exit(1)
	def __makeAPIRequest(self, endPoint: str):
		""" This sets self.request """
		url = f'https://{self.region}.api.blizzard.com{endPoint}'
		self.request = urllib.request.Request( url )
		self.request.add_header( "Authorization", "Bearer %s" % self.access_token )
		try:
			result = urllib.request.urlopen( self.request, context=self.context )
			if result.status != 200:
				print(f"Unexpected status code: {result.status}")
				sys.exit(result.status)
			else:
				return result
		except urllib.error.HTTPError as e:
			# This handles HTTP status codes like 404, 500, etc.
			print(f"HTTP error: {e.code} - {e.reason}")
		except urllib.error.URLError as e:
			# This handles connection errors, DNS errors, etc.
			print(f"URL error: {e.reason}")
		except Exception as e:
			# Any other unexpected errors
			print(f"Unexpected error: {e}")

	def getPetIndex(self, local: str="en_US") -> dict | None:
		# https://us.api.blizzard.com/data/wow/pet/index?namespace=static-us&locale=en_US
		result = self.__makeAPIRequest(f'/data/wow/pet/index?namespace=static-{self.region}&locale={local}')
		if result:
			return json.loads(result.read().decode('utf-8'))

class PetData():
	def __init__(self, stringIn: str) -> None:
		self.data = json.loads(stringIn)
		self.newPets = []
		self.missingPersonalities = []
		self.removedPets = json.loads(stringIn) # pop out of here if the pet is updated.
	def set(self, id: int, name: str) -> None:
		# print(id, name, self.data)
		try:
			self.removedPets.pop(str(id), None)  # won’t raise KeyError
			self.data[str(id)]["name"] = name
		except KeyError:
			self.data[str(id)] = { "name": name, "personality": "" }
			self.newPets.append((id, name))
		if self.data[str(id)]["personality"] == "":
			self.missingPersonalities.append((id, name))
	def save(self, outFile) -> None:
		data = dict(sorted(self.data.items(), key=lambda item: item[1]["name"]))
		textOut = json.dumps( data, ensure_ascii=False, indent=None )
		textOut = textOut.replace( "},","},\n")
		with open(outFile, "w", encoding="utf-8") as f:
			f.write(textOut)
	def report(self):
		print(f'There are {len(self.newPets)} new Pets.\n{self.newPets}')
		print(f'The pets are missing personalities: {self.missingPersonalities}')
		print(f'These pets are not listed by Blizzard: {self.removedPets}')

if __name__=="__main__":
	parser = argparse.ArgumentParser()
	parser.add_argument( "-r", "--region", choices=["us","eu","kr","tw"], default="us",
			help="Region to query")
	parser.add_argument( "-j", "--jsonfile", type=str, required=True,
					 help="JSON output file")
	parser.add_argument( "-l", "--luafile", type=str,
					 help="Lua output file")

	args = parser.parse_args()
	if args.jsonfile:
		with open(args.jsonfile, "r", encoding="utf-8") as f:
			petData = PetData(f.read())
	# print(petData.data)

	BN = BattleNetAPI( args.region )
	petIndexData = BN.getPetIndex()
	if petIndexData:
		petIndexData = BN.getPetIndex()["pets"] # this is a list.
		for pet in petIndexData:
			petData.set( pet["id"], pet["name"] )
		petData.save( args.jsonfile )
		if args.luafile:
			with open(args.luafile, "w", encoding="utf-8") as f:
				f.write("_, CritterEmote = ...\nCritterEmote.Personalities = {\n")
				data = sorted(petData.data.items(), key=lambda item: item[1]["name"])
				for d in data:
					# f.write(f'["{d[1]["name"]}"] = "{d[1]["personality"]}",\n')
					try:
						if d[1]["personality"] == "":
							personality = "nil"  # nil will let the default personality be used.
						else:
							personality = f'"{d[1]["personality"]}"'
					except KeyError:
						personality = "nil"
					f.write(f'[{d[0]:>5}] = {personality}, -- {d[1]["name"]}\n')
				f.write("}")
		petData.report()