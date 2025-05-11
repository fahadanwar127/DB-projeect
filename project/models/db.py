import os
import mysql.connector
from dotenv import load_dotenv

# Load environment variables
load_dotenv(dotenv_path='config/.env')

class Database:
    def __init__(self):
        self.conn = mysql.connector.connect(
            host=os.getenv('DB_HOST'),
            user=os.getenv('DB_USER'),
            password=os.getenv('DB_PASSWORD'),
            database=os.getenv('DB_NAME')
        )
        self.cursor = self.conn.cursor(dictionary=True)

    def execute(self, query, params=None, fetch=False):
        try:
            self.cursor.execute(query, params)
            if fetch:
                return self.cursor.fetchall()
            self.conn.commit()
        except mysql.connector.Error as err:
            self.conn.rollback()
            print(f"Error: {err}")
            return None

    def close(self):
        self.cursor.close()
        self.conn.close()
