import discord
import random
from discord.ext import tasks


client = discord.Client(intents=discord.Intents.default())

@tasks.loop(minutes=1)
async def test():
    if 1:
      channel = client.get_channel(1028168592124026882)
      await channel.send("report")

@client.event
async def on_ready():
    test.start()  
    
client.run('MTAyODE2NzY5MDA3MTgzODcyMA.G2_bMN.T9H_gZt3oUwfGKuCtIedDudXUPd0rfmNHrS5MM')
