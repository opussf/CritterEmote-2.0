# HowTo

Updating the `CritterEmote_PetPersonalities.lua` is still a manual process.
Here are the steps:

1. From a terminal:
    1. export CLIENTID="clientID"
    2. export BLSECRET="clientSecret"
    3. These should be in your environment now.
2. Change to the `scripts` directory
    1. run `./update.py -o ../data/pets.json -l ../src/CritterEmote_PetPersonalities.lua < ../data/pets.json`
    2. look for the report of any new pets
    3. look for any pets missing personalities
    4. update the `data/pets.json` file with missing or updated personalities
    5. run the script again.
3. Commit `data/pets.json` and `src/CritterEmote_PetPersonalities.lua`
