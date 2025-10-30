# HowTo

Updating the `CritterEmote_PetPersonalities.lua` is still a manual process.
Here are the steps:

1. From a terminal:
    1. export CLIENTID="clientID"
    2. export BLSECRET="clientSecret"
    3. These should be in your environment now.
2. run `./scripts/update.py -j data/pets.json -l src/CritterEmote_PetPersonalities.lua`
3. look for the report of any new pets
4. look for any pets missing personalities
5. update the `data/pets.json` file with missing or updated personalities
6. run the script again.
7. Commit `data/pets.json` and `src/CritterEmote_PetPersonalities.lua`
