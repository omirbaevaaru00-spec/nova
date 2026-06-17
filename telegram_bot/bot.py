import asyncio
import logging
import os

from aiogram import Bot, Dispatcher, F
from aiogram.filters import CommandStart
from aiogram.types import Message
from dotenv import load_dotenv
from google import genai
from google.genai import types

load_dotenv()

# Настраиваем логирование вместо print
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

BOT_TOKEN = os.getenv("BOT_TOKEN")
GEMINI_API_KEY = os.getenv("GEMINI_API_KEY")

# Проверяем, что секреты заданы, иначе падаем с понятной ошибкой
if not BOT_TOKEN:
    raise RuntimeError("BOT_TOKEN не задан. Добавь его в .env")
if not GEMINI_API_KEY:
    raise RuntimeError("GEMINI_API_KEY не задан. Добавь его в .env")

bot = Bot(token=BOT_TOKEN)
dp = Dispatcher()
# Инициализируем асинхронный клиент Gemini (ключ берём из окружения, не из кода)
client = genai.Client(api_key=GEMINI_API_KEY).aio

# Системный промт выносим в константу
SYSTEM_INSTRUCTION = (
    "Ты AI помощник проекта STICKY. "
    "Помогай студентам выбирать университеты "
    "и отвечай на вопросы про поступление."
)

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


# Реагируем только на текстовые сообщения, чтобы message.text не был None
@dp.message(F.text)
async def ai_chat(message: Message):
    user_text = message.text

    wait_message = await message.answer("🤖 Думаю...")

    try:
        # Системный промт в новом SDK передаётся через config
        config = types.GenerateContentConfig(
            system_instruction=SYSTEM_INSTRUCTION
        )

        # Асинхронная генерация контента
        response = await client.models.generate_content(
            model="gemini-2.5-flash",
            contents=user_text,
            config=config,
        )

        answer = response.text or "Не смог сформировать ответ, попробуй переформулировать."

        await message.answer(answer)
    except Exception as e:
        # Детали ошибки пишем в лог, пользователю — общий текст
        logger.exception("Ошибка при генерации ответа Gemini: %s", e)
        await message.answer(
            "⚠️ Что-то пошло не так. Попробуй ещё раз чуть позже."
        )
    finally:
        # Удаляем "Думаю..." в любом случае, защищаясь от ошибки удаления
        try:
            await wait_message.delete()
        except Exception:
            logger.warning("Не удалось удалить служебное сообщение")


# Ловим любые нетекстовые сообщения (фото, стикеры, голосовые)
@dp.message()
async def fallback(message: Message):
    await message.answer("Пока я понимаю только текстовые сообщения 🙂")


async def main():
    logger.info("Bot started...")
    try:
        await dp.start_polling(bot)
    finally:
        await bot.session.close()


if __name__ == "__main__":
    asyncio.run(main())
