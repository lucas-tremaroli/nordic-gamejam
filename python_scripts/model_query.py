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

messages = [{
        "role": "system",
        "content": """
            You are acting as a teenage friend to a teenage player in a fictional world. Keep the conversation fun and light, bring some weird points. In this world there is a day and night cycle.
            During the night the gameplay happens in the dreams where the player fights off enemies. What happens in the day dialog with you affects the abilities of the player and the enemies.
            During the day the player has a casual friendly chat with you about a real-life problem you are having.
            You need to start by deciding on the abilities of the enemies. The enemy abilities cannot change, make these fun and extreme rather than average. Then shape the conversation strictly around the enemies abilities without directly mentioning anything related to the night-time, sleep, dreams or the abilities.
            You need to make the player take a stance on real-life decisions resembling the night-time abilities of the player, make the decision affect the abilities more dramatically in certain directions so there is one ability clearly overruling the others.

            The output should contain a maximum of one sentence message response to the player and the ability ratings.
            Give the abilities a rating of 0-10, with combined maximum of 20 for both the player and enemies.
            The player abilities are: movement_speed, endurance, hitpoints, attack_strength
            The enemy abilities are: movement_speed, enemy_count, hitpoints, attack_strength
            Format the output as a single JSON object containing the message response and the ability ratings:
            {
                "message": "..."
                "player_abilities": {
                    "ability_name": 0,
                    ...
                },
                "enemy_abilities": {
                    "ability_name": 0,
                    ...
                }
            }

            Start by initiating the conversation with the user.
        """
}]

if os.path.isfile("./messages.json"):
    with open("./messages.json", "r") as file:
        messages = json.load(file)

if len(sys.argv) > 1:
    prompt = sys.argv[1]

    messages.append({
        "role": "user",
        "content": prompt
    })

response = asyncio.run(
    client.chat.completions.create(model="gpt-4o-2024-08-06", messages=messages)
)
response_text = response.choices[0].message.content

messages.append({
    "role": "assistant",
    "content": response_text
})

with open("./messages.json", "w+") as file:
    json.dump(messages, file)

sys.stdout.write(response_text)
