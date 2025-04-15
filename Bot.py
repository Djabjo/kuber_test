import asyncio
import logging
import sys
import asyncpg
import random
import os

from datetime import datetime
from aiogram import Bot, Dispatcher
from aiogram.client.default import DefaultBotProperties
from aiogram.enums import ParseMode

from aiogram.types import Message
from aiogram.filters import Command
from aiogram import Dispatcher, Router

from asyncpg.pool import Pool

token = os.getenv("TELEGRAM_BOT_TOKEN").strip()

TOKEN = token

dp = Dispatcher()
router = Router()
dp.include_router(router)


DB_CONFIG = {
    "host": "postgres-service",
    "port": 5432,
    "database": "db_bot_biba",
    "user": "kotov",
    "password": "8sdfsdft@"
}


pool: Pool = None

async def create_pool():
    global pool
    if not pool or pool._closed:
        pool = await asyncpg.create_pool(**DB_CONFIG)
    return pool

@router.message(Command("push"))
async def cmd_push(message: Message):
    try:
        await create_pool()  # Инициализация при первом вызове
        
        texts = ["Hello World", "Random Message", "Test Entry", "Sample Data"]
        random_text = random.choice(texts)
        
        async with pool.acquire() as conn:
            await conn.execute('''
                INSERT INTO messages(text, created_at)
                VALUES($1, $2)
            ''', random_text, datetime.utcnow())
            
        await message.answer(f"✅ Запись добавлена: {random_text}")
    except asyncpg.PostgresError as e:
        logging.error(f"Database error: {e}")
        await message.answer("❌ Ошибка при сохранении в БД")
    except Exception as e:
        logging.error(f"General error: {e}")
        await message.answer("❌ Неизвестная ошибка")


@router.message(Command("start"))  
async def cmd_input(message: Message):
    await message.answer(
        f"Раздел отвечает за работу с базой данных\n" 
        f"Выберите вариант для продолжения"
        )

async def main() -> None:
    bot = Bot(token=TOKEN, default=DefaultBotProperties(parse_mode=ParseMode.HTML))
    await dp.start_polling(bot)


if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO, stream=sys.stdout)
    asyncio.run(main())
