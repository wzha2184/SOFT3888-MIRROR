import discord
import random
from discord.ext import tasks


client = discord.Client(intents=discord.Intents.default())
sh = 0
@tasks.loop(seconds=1)
async def test():
    global sh
    if sh < 30:
      channel = client.get_channel(1028168592124026882)
      await channel.send(sh)
    else:
      channel = client.get_channel(1028168592124026882)
      await channel.send(sh)
    sh += 1

@client.event
async def on_ready():
    test.start()  
    
client.run('MTAyODE2NzY5MDA3MTgzODcyMA.G2_bMN.T9H_gZt3oUwfGKuCtIedDudXUPd0rfmNHrS5MM')
