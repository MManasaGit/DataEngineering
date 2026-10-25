import uuid

from langchain_openai import ChatOpenAI
from langchain_community.utilities import SQLDatabase
from langchain_community.agent_toolkits import SQLDatabaseToolkit
from langgraph.checkpoint.memory import InMemorySaver
from langchain.agents import create_agent
from dotenv import load_dotenv
from uuid import uuid4
import streamlit as st

load_dotenv()

db = SQLDatabase.from_uri("sqlite:///mytasks.db")
db.run("CREATE TABLE IF NOT EXISTS tasks (id INTEGER PRIMARY KEY, task TEXT, status TEXT,created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP)")
print("Database and table created successfully.")

model = ChatOpenAI(model_name="gpt-5")
toolkit = SQLDatabaseToolkit(db=db, llm=model)
tools = toolkit.get_tools()



system_prompt = """
You are a task management assistant that interacts with a SQL database containing a 'tasks' table. 

TASK RULES:
1. Limit SELECT queries to 10 results max with ORDER BY created_at DESC
2. After CREATE/UPDATE/DELETE, confirm with SELECT query
3. If the user requests a list of tasks, present the output in a structured table format to ensure a clean and organized display in the browser."

CRUD OPERATIONS:
    CREATE: INSERT INTO tasks(title, description, status)
    READ: SELECT * FROM tasks WHERE ... LIMIT 10
    UPDATE: UPDATE tasks SET status=? WHERE id=? OR title=?
    DELETE: DELETE FROM tasks WHERE id=? OR title=?

Table schema: id, title, description, status(pending/in_progress/completed), created_at.
"""

if "chat_history" not in st.session_state:
    st.session_state.chat_history = []

if "thread_id" not in st.session_state:
    st.session_state.thread_id = str(uuid4())

if "memory" not in st.session_state:
    st.session_state.memory = InMemorySaver()

memory = st.session_state.memory 
chat_history = st.session_state.chat_history
thread_id = st.session_state.thread_id

agent = create_agent(
        tools=tools, 
        model=model, 
        checkpointer=memory, 
        system_prompt=system_prompt
    )

# --------------------------------------------------
# UI
# --------------------------------------------------

st.title("📋 Task Management Assistant")

st.write("Ask me to create, update, delete, or view your tasks.")

for message in chat_history:
    with st.chat_message(message["role"]):
      st.markdown(message["content"])


user_input = st.chat_input( "Ask me anything about your tasks..." )

if user_input:

    # Display user message
    with st.chat_message("user"):
        st.markdown(user_input)

    chat_history.append({
        "role": "user",
        "content": user_input
    })


    # Call agent
    with st.chat_message("assistant"):

        with st.spinner("Thinking..."):

            response = agent.invoke(
                {
                    "messages": [
                        {
                            "role": "user",
                            "content": user_input
                        }
                    ]
                },
                {
                    "configurable": {
                        "thread_id": thread_id
                    }
                }
            )

            assistant_message = response["messages"][-1].content

            st.markdown(assistant_message)

    print (thread_id)
    # Save assistant response
    chat_history.append({
        "role": "assistant",
        "content": assistant_message
    })