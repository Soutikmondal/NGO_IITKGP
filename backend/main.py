# main.py
import uvicorn
from fastapi import FastAPI, Request
from pydantic import BaseModel
# uvicorn main:app --reload --host 0.0.0.0 --port 8000

# Langchain setup
import os 
MODEL="llama2"
from langchain_community.llms import Ollama
model = Ollama(model=MODEL)

from langchain_core.output_parsers import StrOutputParser
parser= StrOutputParser()
chain= model | parser

from langchain_community.document_loaders import PyPDFLoader
loader=PyPDFLoader("test.pdf")
pages=loader.load_and_split()

from langchain.prompts import PromptTemplate
template="""
Answer the questions based on context below. Don't start with based on context... If it's
not based on the context, reply "I don't know".

Context: {context}

Question: {question}
"""
prompt=PromptTemplate.from_template(template)

from langchain_community.embeddings import OllamaEmbeddings
from langchain_community.vectorstores import DocArrayInMemorySearch
embeddings=OllamaEmbeddings()
vectorstore=DocArrayInMemorySearch.from_documents(
    pages,
    embedding=embeddings
)

retreiver=vectorstore.as_retriever()


from operator import itemgetter

chain = (
    {
        "context": itemgetter("question") | retreiver,
        "question":itemgetter("question")
    }
    
    |prompt | model | parser)

app = FastAPI()

class QuestionRequest(BaseModel):
    question: str

@app.post("/ask-question")
async def ask_question(request: QuestionRequest):
    response = chain.invoke({"question": request.question})
    return {"answer": response}

if __name__ == "__main__":
    uvicorn.run(app, host="0.0.0.0", port=8000)
