import streamlit as st
from langchain_openai import ChatOpenAI
from dotenv import load_dotenv
from langchain_core.messages import HumanMessage, AIMessage
import uuid

# -----------------------------
# Load Environment Variables
# -----------------------------

load_dotenv()

# -----------------------------
# LLM Configuration
# -----------------------------
llm = ChatOpenAI(
    model_name="gpt-4o",
    temperature=0.7
)

# ============================================================
# Snowflake Connection
# ============================================================

conn = st.connection("snowflake")

print("Snowflake Connection:", conn)

cursor = conn.cursor()

cursor.execute("""
    SELECT
        CURRENT_ACCOUNT(),
        CURRENT_ACCOUNT_NAME(),
        CURRENT_ORGANIZATION_NAME(),
        CURRENT_ROLE(),
        CURRENT_WAREHOUSE()
""")

print(cursor.fetchone())


# -----------------------------
# Session State Initialization
# -----------------------------
if "chat_history" not in st.session_state:
    st.session_state.chat_history = []

if "session_id" not in st.session_state:
    st.session_state.session_id = str(uuid.uuid4())
    print("Session ID:", st.session_state.session_id)

if "chat_title" not in st.session_state:
    st.session_state.chat_title = "New Chat"

if "selected_session_id" not in st.session_state:
    st.session_state.selected_session_id = None

# ============================================================
# FUNCTIONS
# ============================================================

# -----------------------------
# Generate Chat Title and invoke LLM
# -----------------------------

def generate_chat_title(query):
    title_prompt = f"""
    Generate a short title for this conversation.

    Requirements:
    - Maximum 5 words
    - Describe the main topic
    - No quotation marks
    - Return only the title

    User question:
    {query}
    """

    response = llm.invoke([HumanMessage(content=title_prompt)])
    return response.content.strip()


# -----------------------------
# Save Chat Session to Snowflake
# -----------------------------

def save_chat_session(session_id, title):

    Merge_query = f"""
        MERGE INTO CHAT_SESSIONS target
        USING (
            SELECT
                ? AS SESSION_ID,
                ? AS TITLE
        ) source
        ON target.SESSION_ID = source.SESSION_ID

        WHEN MATCHED THEN UPDATE SET
            TITLE = source.TITLE,
            CREATED_AT = CURRENT_TIMESTAMP()

        WHEN NOT MATCHED THEN INSERT (
            SESSION_ID,
            TITLE
        )
        VALUES (
            source.SESSION_ID,
            source.TITLE
        )
    """

    conn.cursor().execute(
        Merge_query, 
        (','.join(map(str, {session_id})), ','.join(map(str, {title})))
    )

    conn._instance.commit()

# ------------------------------------------------------------
# Save Message
# ------------------------------------------------------------

def save_message(session_id, role, content):

    insert_query = """
        INSERT INTO CHAT_MESSAGES
        (
            SESSION_ID,
            ROLE,
            CONTENT
        )
        VALUES (?, ?, ?)
    """

    conn.cursor().execute(
        insert_query,
        (session_id, role, content)
    )

# ------------------------------------------------------------
# Load Full Chat
# ------------------------------------------------------------

def load_chat(session_id):

    query = """
        SELECT
            ROLE,
            CONTENT
        FROM CHAT_MESSAGES
        WHERE SESSION_ID = ?
        ORDER BY CREATED_AT
    """

    rows = conn.cursor().execute(
        query,
        (session_id)
    ).fetchall()

    return rows


# ------------------------------------------------------------
# Get Sidebar Chat Sessions
# ------------------------------------------------------------

def get_chat_sessions():

    query = """
        SELECT
            SESSION_ID,
            TITLE
        FROM CHAT_SESSIONS
        ORDER BY CREATED_AT DESC
    """

    return conn.cursor().execute(query).fetchall()

# ============================================================
# MAIN PAGE
# ============================================================

st.title("QA Chatbot")

st.markdown("This is a simple QA chatbot application built using Streamlit.")

# ============================================================
# DISPLAY CHAT HISTORY
# ============================================================

history = st.session_state.chat_history

for message in history:
    with st.chat_message(message["role"]):
        st.write(message["content"])

# ============================================================
# DISPLAY CHAT HISTORY
# ============================================================

query = st.chat_input("Ask a question:")

# ============================================================
# PROCESS USER QUERY
# ============================================================

if query:


    # --------------------------------------------------------
    # Generate chat title ONLY for first question
    # --------------------------------------------------------

    if st.session_state.chat_title == "New Chat":

        st.session_state.chat_title = generate_chat_title(query)

        save_chat_session(
            st.session_state.session_id,
            st.session_state.chat_title
        )

    # --------------------------------------------------------
    # Add user message to Streamlit history
    # --------------------------------------------------------
    
    # Add user's question to history
    history.append({
        "role": "user",
        "content": query
    })

    # Display user's question
    with st.chat_message("user"):
        st.write(query)

    # Send chat history to LLM
    response = llm.invoke(history)
    
    # --------------------------------------------------------
    # Display assistant response
    # --------------------------------------------------------


    # Display assistant response
    with st.chat_message("assistant"):
        st.write(response.content)

    # Add assistant response to history
    history.append({
        "role": "assistant",
        "content": response.content
    })

    # --------------------------------------------------------
    # Save user message
    # --------------------------------------------------------

    save_message(
        st.session_state.session_id,
        "user",
        query
    )

    # --------------------------------------------------------
    # Save assistant message
    # --------------------------------------------------------

    save_message(
        st.session_state.session_id,
        "assistant",
        response.content
    )

# ============================================================
# SIDEBAR
# ============================================================

st.sidebar.title("Chat History")

# ------------------------------------------------------------
# New Chat Button
# ------------------------------------------------------------

if st.sidebar.button("➕ New Chat"):

    st.session_state.session_id = str(uuid.uuid4())

    st.session_state.chat_history = []

    st.session_state.chat_title = "New Chat"

    st.session_state.selected_session_id = None

    st.rerun()

# ------------------------------------------------------------
# Get Previous Chats
# ------------------------------------------------------------

sidebar_history = get_chat_sessions()

for session_id, title in sidebar_history:

    if st.sidebar.markdown(
        title,
        key=f"chat_{session_id}"
    ):

        st.session_state.selected_session_id = session_id

        st.session_state.session_id = session_id

        # Load full conversation
        rows = load_chat(session_id)

        # Convert Snowflake data into Streamlit history
        st.session_state.chat_history = []

        for role, content in rows:

            st.session_state.chat_history.append({
                "role": role,
                "content": content
            })
        st.rerun()


# ============================================================
# LOAD CURRENT CHAT TITLE
# ============================================================

if st.session_state.selected_session_id:

    for session_id, title in sidebar_history:

        if session_id == st.session_state.selected_session_id:

            st.session_state.chat_title = title

            break



#st.sidebar.write("This is the chat history of your conversation with the chatbot.")
#st.sidebar.write(history)

# Below are the streamlit methosds used in the code above:
# st.title(): This method is used to set the title of the Streamlit app. In this case, it sets the title to "QA Chatbot".
# st.markdown(): This method is used to render Markdown text in the Streamlit app.  
# st.write(): This method is used to display text or other elements in the Streamlit app. It can be used to display strings, data frames, charts, and more.
# st.session_state: This is a special object in Streamlit that allows you to store and manage state across reruns of the app. In this code, it is used to store the chat history.

# st.chat_message(): This method is used to display chat messages in the Streamlit app. It takes a role ("user" or "assistant") as an argument and displays the corresponding message. 
# st.chat_input(): This method is used to create a chat input box in the Streamlit app. It allows users to enter their queries or messages.
# st.char_history: This is a list that stores the chat messages exchanged between the user and the assistant. Each message is represented as a dictionary with "role" and "content" keys.

# st.sidebar.button(): This method is used to create a button in the sidebar of the Streamlit app. In this case, it creates a "New Chat" button that resets the chat history when clicked.
# st.sidebar.title(): This method is used to set the title of the sidebar in the Streamlit app. In this case, it sets the title to "Chat History".
# st.sidebar.write(): This method is used to display text or other elements in the sidebar of the Streamlit app. It can be used to display strings, data frames, charts, and more.
# st.sidebar.text_input(): This method is used to create a text input box in the sidebar of the Streamlit app. It allows users to enter their OpenAI API key, which is required for the chatbot to function.
# st.sidebar.text_input("OpenAI API Key", type="password"): This method creates a password input field in the sidebar for users to enter their OpenAI API key. The input is masked for security.

# below are the LangChain methods used in the code above:
# ChatOpenAI: This is a class from the langchain_openai module that allows you to interact with OpenAI's chat models. It takes parameters such as model_name and temperature to configure the behavior of the model.
# ChatPromptTemplate: This is a class from the langchain_core.prompts module that allows you to create prompt templates for chat interactions. It takes a list of messages with roles and content to define the structure of the conversation.
# chat_prompt_template.from_messages(): This method is used to create a chat prompt template from a list of messages. Each message is represented as a tuple with the role ("user" or "assistant") and the content of the message.
# llm.invoke(): This method is used to invoke the language model with the provided input. It takes the chat history as input and returns the model's response. The response can be accessed through the content attribute of the returned object.
# response.content: This attribute contains the content of the response generated by the language model. It can be displayed in the Streamlit app using st.chat_message() or other methods.

# to do
# All the methods used in the st.session_state like chat_history, chat_message, chat_input
# Complete to get the history in the side bar using snowflake and streamlit
# Write proper documentation for all the methods used in the code above.

# https://www.youtube.com/watch?v=o-s2coJtT7E&t=1079s
