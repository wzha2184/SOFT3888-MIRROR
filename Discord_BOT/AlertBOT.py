import discord
import random
from discord.ext import tasks
text = ""
def run(report):
  client = discord.Client(intents=discord.Intents.default())
  global text
  text = report

  @client.event
  async def on_ready():
      global text
      channel = client.get_channel(1028168592124026882)
      await channel.send(text)
      await client.close()
    
  client.run('MTAyODE2NzY5MDA3MTgzODcyMA.G2_bMN.T9H_gZt3oUwfGKuCtIedDudXUPd0rfmNHrS5MM')

run("Report")