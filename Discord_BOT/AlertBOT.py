import discord
import random
from discord.ext import tasks
#change flowing two attributes
channel_ID = 1028168592124026882
token = 'MTAyODE2NzY5MDA3MTgzODcyMA.G2_bMN.T9H_gZt3oUwfGKuCtIedDudXUPd0rfmNHrS5MM'

text = ""
def run(report):
  client = discord.Client(intents=discord.Intents.default())
  global text
  text = report

  @client.event
  async def on_ready():
      global text
      global channel_ID
      channel = client.get_channel(channel_ID)
      await channel.send(text)
      await client.close()
  
  global token
  client.run(token)

#run("Report") will send "Report"