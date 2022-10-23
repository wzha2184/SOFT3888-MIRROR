import discord
import random
from discord.ext import tasks
#change flowing two attributes
channel_ID = 1028168592124026882
token = 'MTAyODE2NzY5MDA3MTgzODcyMA.GlsZYf.qVyYSFvUplPSTVOldV3qDPq3jbjJJKCEvE0kho'

text = ""
def run(report):
  client = discord.Client(intents=discord.Intents.default())
  global text
  text = report.decode()

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