# apimesh

Welcome to the `apimesh` GitHub Action. This tool is designed to automate the processing of GitHub issues using language model-based scripts, providing a more efficient way to manage project interactions.

### Getting Started
To integrate `apimesh` into your workflow, you have two options:
1. **Fork this Repository**: The simplest way is to fork this repository, which includes all the necessary components.
2. **Manual Setup**: Alternatively, manually copy the `workflow.yml`, `LICENSE`, and the `apimesh.py` Python file into your repository.

### Essential Setup
- **Enable Features**: Ensure that Workflows and Issues are active in your forked or manually configured repository for the proper functioning of `apimesh`.
- **OpenAI API Key**: An environment variable with your OpenAI API key is required. This can be set in the repository's Secrets tab.

### How to Use
Using `apimesh` is straightforward:
- **Trigger the Workflow**: Label an issue with "apimesh" in your repository.
- **Automated Processing**: The workflow will process the issue using the language model scripts and post a response as a comment.

### Experience `apimesh`
To understand how `apimesh` functions, visit the Issues tab in this repository. You'll find instances of the bot's responses, showcasing its utility in issue management.

### Customization
You can customize the script settings, such as the language model's temperature in the `apimesh.py` script (default is 0.7), or alter the prompt template according to your project needs.

Please note, the presence of the `apimesh.py` script in your repository is crucial for the proper execution of the workflow.

We hope `apimesh` enhances your project management efficiency and look forward to your valuable contributions and feedback.
