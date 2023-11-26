import os
import sys
from langchain.llms import OpenAI
from langchain.chains import LLMChain
from langchain.prompts import PromptTemplate

# Read issue data from the command line argument
issue_data = sys.argv[1]

# Get the OpenAI API key from environment variables
api_key = os.environ['OPENAI_API_KEY']

# Initialize LangChain with OpenAI
llm = OpenAI(api_key=api_key, temperature=0.7)  # Adjust temperature as needed
prompt_template = "Given the following GitHub issue details: {issue_details}, what would be a good solution? Be concise, neutral and professional. aim for the asymptotically highest information density/text ratio"

# Setup LLMChain
llm_chain = LLMChain(llm=llm, prompt=PromptTemplate.from_template(prompt_template))

# Process issue data
response = llm_chain.predict(issue_details=issue_data)

# Save the response to a file
with open('ai_response.txt', 'w') as file:
    file.write(response)


