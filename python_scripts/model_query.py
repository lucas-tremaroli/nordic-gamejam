import asyncio
import sys

from openai import AsyncAzureOpenAI

client = AsyncAzureOpenAI(
    azure_endpoint="https://models.assistant.legogroup.io",
    api_key="918cc305f9df4b2c9f00ef7d130793dc:qFy_lKGRRSYTkwZnauLPlkvadWW5-PBM3rykbW9dOZixR8w_pDCcLl48Wf9X0K33HJVYKSYXNys5jzBcVkiNKjnZ0PTtThiuOHr1SW5u8KF84fPfToasXOom7xdCEdBOKZOvkwZUskm2O3vXuwLgM8oEa_Ku_A-Nm-7LA9GomuE6h_VDIdcdFkaGKu1JPO-FPcRA0WWgaaBtwLgUiOK5zJn5TC1ykEXIqM9f4quzaSNOIu5eiBCu9UnIy6BeJJs8J86tTu4pgfQYh8zlX15TFK2Kym1dKKVVwR8zapLDtxrDthOE528sLvxKTGJAaoPmCIW0M7ADAvFSkeGI5pOveA",
    api_version="2024-03-01-preview"
)

messages = [{
    "role": "system",
    "content": """
        You are a balancing trade-off agent to a game. Come with characteristics for a game character satisfying the prompt but balancing out any strengths with adequate weaknesses.
        You have the following abilities to work with: [Movement speed, Jump height, Endurance, Attack strength, Armor]. Give the character a rating for each from 1 - 10, but the combined values can be maximum 25.
        Format the output as a json object containing a list of abilities with a rating for each, a name of the character and a one sentence description of the character.
        The name should use existing terms and references from other games.
        The description should be fun to read and describe the strengths and weaknesses of the character without mentioning the underlying abilities.
    """
}]

async def query_model(message: str):
    messages.append({
        "role": "user",
        "content": message
    })

    response = await client.chat.completions.create(model="gpt-4o-mini-2024-07-18", messages=messages)
    response_text = response.choices[0].message.content

    messages.append({
        "role": "assistant",
        "content": response_text
    })

    return response_text


prompt = sys.argv[1]

sys.stdout.write(asyncio.run(query_model(prompt)))
