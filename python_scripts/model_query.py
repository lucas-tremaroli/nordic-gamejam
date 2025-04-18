import asyncio
import sys
import os
import json

from openai import AsyncAzureOpenAI

client = AsyncAzureOpenAI(
    azure_endpoint="https://models.assistant.legogroup.io",
    api_key="86988b839654443195687812d7f00399:9HrDabZ5KvFfscs7jbNGZP2ClryQp0KZVve0V4lPCfxNmmVNrjRvZD8dRVHnJCYlbSwOrvTawr56K0-SnGvbuWrYXM5tFZQAqmXWrbwESf0HJolnvUfEK67QvteXPHUlAW-a0oSY-ECQfJNozxWYREwvl0okBS5VaynQyVgOwLPCZqYf5zHUTt-7_oGH2FR8ZKlH6VHQ_fk4u_3tfDQBIrzW5bVQtH_4QeS60hrDjIw4vNRU8mwrptYjrYJSQTDhGu7lu4BZqVJalIaGhToZFgR7x1Qg8VonJFDlAK8-3R0e2nOyLNQndgotIf3bmD0YwsI0s7abhX-aC4qUPoqxbQ",
    api_version="2024-03-01-preview"
)

background_info = """
You are an agent in a game and need to provide dialog responses to what the player says. Below is a description of the idea behind the game and your character role in it.

# Background info
You are acting as a teenage friend to a teenage player in a fictional world. You need to keep the conversation fun and light. In this world there is a day and night cycle. The player plays a mini game during the night and then has a conversation with you during the day. You can't mention ANYTHING about the minigame so that it stays a secret to the player
"""


day0_system_prompt = f"""
{background_info}

# Output
The dialog should reflect how well the player did during the night, which is given by a score between 0 and 10. The higher the score your response should be more optimistic in terms of how fresh and energetic the player character seems. For instance if the score is 10 you should respond with something like "Wow, you look so fresh and energetic today!" and if the score is 0 you should respond with something like "Oh no, you look so tired today. I hope you can some proper get some rest soon."

Your output should be a few sentences of dialog in response to the player. End with a question to the player about how they felt about how well they did in their dream. Was there something they wished that would have been differently about their character. But don't mention anything about the minigame, it is not obvious to you that the player is playing a minigame, or that they are doing anything at all in the night or the dream. So you need to get creative about how to ask the player about their character.

# Player score input
"""

generate_monster_stats_system_prompt = f"""
{background_info}

# Task
Given the player's description of how they felt about their dream and how they wished their character was different in terms of stats, generate a new set of character stats for the player.

# Player Stats
- movement_speed
- hitpoints
- attack_strength
- ammo

Each stat:
- Must be an integer between 1 and 10 (inclusive)
- The combined total must NOT exceed 20

Balance rules:
- If one stat is high, others must be lower. For example, if speed is high, you cannot also have high hitpoints and attack_strength.

# Output format (IMPORTANT)
⚠️ You must respond ONLY with a valid JSON object. Do NOT include explanations or additional text.
Use this format **exactly**:

{{
    "movement_speed": <int>,
    "hitpoints": <int>,
    "attack_strength": <int>,
    "ammo": <int>
}}

Example:
Input: "I wish I was faster and stronger."
Output:
{{
    "movement_speed": 7,
    "hitpoints": 3,
    "attack_strength": 8,
    "ammo": 3
}}

# Player Input:
"""

messages = [{
    "role": "system",
    "content": day0_system_prompt if sys.argv[1] == '1' else generate_monster_stats_system_prompt
}]

if os.path.isfile("python_scripts/messages.json"):
    with open("python_scripts/messages.json", "r") as file:
        messages += json.load(file)

if len(sys.argv) > 1:
    prompt = sys.argv[2]

    messages.append({
        "role": "user",
        "content": prompt
    })

response = asyncio.run(
    client.chat.completions.create(model="gpt-4o-2024-08-06", messages=messages, temperature=0.85)
)
response_text = response.choices[0].message.content

messages.append({
    "role": "assistant",
    "content": response_text
})

with open("python_scripts/messages.json", "w+") as file:
    messages_without_system_prompt = [msg for msg in messages if msg["role"] != "system"]

    # Trim to only the first human and the ai message
    # (keep only the first 2 messages)
    if len(messages_without_system_prompt) > 2:
        messages_without_system_prompt = messages_without_system_prompt[-2:]

    json.dump(messages_without_system_prompt, file)

sys.stdout.write(response_text)
