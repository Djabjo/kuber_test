import asyncio
import logging
import sys
import asyncpg
import random
import os
import string

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

### 
async def create_pool():
    host = 'botic-postgres-svc'
    port = 5432
    database = os.getenv("POSTGRES_DB").strip()
    user = os.getenv("POSTGRES_USER").strip()
    password = os.getenv("POSTGRES_PASSWORD").strip()
    
    pool = await asyncpg.create_pool(
        host=host,
        port=port,
        database=database,
        user=user,
        password=password,
        min_size=1,
        max_size=20,
        max_queries=101, 
        max_inactive_connection_lifetime=20
    )
    return pool

async def generate_random_message():
    random_text = ''.join(random.choices(string.ascii_letters + string.digits, k=20))
    return random_text
                            
@router.message(Command("push"))
async def cmd_push(message: Message):
    try:        
        for i in range(50):
            message_text = await generate_random_message()
            pool = await create_pool()
            # Выполняем вставку
            async with pool.acquire() as connection:
                await connection.execute('''
                    INSERT INTO messages (text)
                    VALUES ($1)
                ''', message_text)
                
                # Получаем количество записей
                
                count = await connection.fetchval('SELECT COUNT(*) FROM messages')
        await message.answer(f"✅ Запись добавлина в БД. Всего записей: {count}")

    except asyncpg.PostgresError as e:
        logging.error(f"Database error: {e}")
        await message.answer("❌ Ошибка при сохранении в БД")
    except Exception as e:
        logging.error(f"General error: {e}")
        await message.answer("❌ Неизвестная ошибка")

#### надо чинить 

async def main() -> None:
    bot = Bot(token=TOKEN, default=DefaultBotProperties(parse_mode=ParseMode.HTML))
    await dp.start_polling(bot)

if __name__ == "__main__":
    logging.basicConfig(level=logging.INFO, stream=sys.stdout)
    asyncio.run(main())
