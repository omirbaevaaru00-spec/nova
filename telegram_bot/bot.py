import asyncio
import os

from aiogram import Bot, Dispatcher
from aiogram.filters import CommandStart
from aiogram.types import Message
from dotenv import load_dotenv
from google import genai
from google.genai import types

load_dotenv()

BOT_TOKEN = os.getenv("BOT_TOKEN")
# Меняем имя переменной в соответствии с новым ключом
GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")

bot = Bot(token=BOT_TOKEN)
dp = Dispatcher()

# Инициализируем асинхронный клиент Gemini
client = genai.Client(api_key="AIzaSyAH-vfFprdNgQdFc3PwWgRvYrBpqhpqMpY").aio


@dp.message(CommandStart())
async def start(message: Message):
    await message.answer(
        "👋 Привет! Я AI помощник STICKY.\n\n"
        "Спроси меня про:\n"
        "• университеты\n"
        "• поступление\n"
        "• специальности\n"
        "• приложение STICKY"
    )


@dp.message()
async def ai_chat(message: Message):
    user_text = message.text

    wait_message = await message.answer("🤖 Думаю...")

    try:
        # Системный промт в новом SDK передается через config
        config = types.GenerateContentConfig(
            system_instruction=(
                "Ты AI помощник проекта STICKY. "
                "Помогай студентам выбирать университеты "
                "и отвечай на вопросы про поступление."
            )
        )

        # Вызываем асинент-генерацию контента
        response = await client.models.generate_content(
            model='gemini-2.5-flash',
            contents=user_text,
            config=config
        )

        answer = response.text

        await wait_message.delete()
        await message.answer(answer)

    except Exception as e:
        await wait_message.delete()
        await message.answer(f"Ошибка: {e}")


async def main():
    print("Bot started...")
    await dp.start_polling(bot)


if __name__ == "__main__":
    asyncio.run(main())