# Import necessary libraries
from langchain.document_loaders import YoutubeLoader
from langchain.llms import OpenAI
from langchain.schema.runnable import RunnableParallel
from langchain.prompts import PromptTemplate
from langchain.schema import StrOutputParser

# Install required packages (uncomment and run these lines if needed)
# !pip install youtube-transcript-api

# Initialize the language model
llm = OpenAI(temperature=0)

# Function to create YouTube Loader
def create_youtube_loader(url, language="en", translation="en"):
    return YoutubeLoader.from_youtube_url(
        url, 
        add_video_info=True, 
        language=[language], 
        translation=translation
    )

# Function to create an LLM chain for each analysis step
def create_llm_chain(prompt_text):
    prompt = PromptTemplate.from_template(prompt_text)
    return prompt | llm | StrOutputParser()

# Function to combine LLM chains for parallel execution
def create_parallel_chain(chains):
    return RunnableParallel(**chains)

# Main execution function
def analyze_video(url):
    # Create YouTube Loader
    youtube_loader = create_youtube_loader(url)

    # Retrieve transcript
    transcript = youtube_loader.load()

    # Create LLM chains for each analysis step
    transformation_chain = create_llm_chain("Direct transformation of this transcript: {transcript}")
    explanation_chain = create_llm_chain("Why this information is relevant: {transcript}")
    action_plan_chain = create_llm_chain("Action plan based on this transcript: {transcript}")

    # Combine chains for parallel execution
    combined_chain = create_parallel_chain({
        'transformation': transformation_chain, 
        'explanation': explanation_chain, 
        'action_plan': action_plan_chain
    })

    # Execute parallel analysis
    analysis_result = combined_chain.invoke({"transcript": transcript})

    return analysis_result

# Example usage
url = "https://www.youtube.com/watch?v=AVInhYBUnKs&t" # Replace with your video URL
analysis_result = analyze_video(url)
print(analysis_result)

