import os

from fastapi import FastAPI

app = FastAPI()


@app.get("/")
async def root():
    return {
        'env': {
            'PARAM1': os.getenv('PARAM1'),
            'PARAM2': os.getenv('PARAM2')
        },
        'cwd': os.getcwd()
    }