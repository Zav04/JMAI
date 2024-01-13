from fastapi import FastAPI
import uvicorn
from fastapi.middleware.cors import CORSMiddleware
from GET import get_router
from POST import post_router
from PUT import put_router

api = FastAPI()

api.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)


api.include_router(get_router)
api.include_router(post_router)
api.include_router(put_router)




if __name__ == "__main__":
    uvicorn.run("main:api", host="localhost", port=8000, reload=True)
    #uvicorn.run(api)


