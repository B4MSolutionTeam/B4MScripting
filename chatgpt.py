from datetime import datetime
from logging.config import listen
import speech_recognition as sr
import pyttsx3 
import webbrowser
import wikipedia
import wolframalpha
import openai
 
# Speech engine initialisation
engine = pyttsx3.init()
voices = engine.getProperty('voices')
engine.setProperty('voice', voices[0].id) # 0 = male, 1 = female
activationWord = 'execute' # Single word
 
# Configure browser
# Set the path
chrome_path = r"C:\Program Files\Google\Chrome\Application\chrome.exe"
webbrowser.register('chrome', None, webbrowser.BackgroundBrowser(chrome_path))
 
# Wolfram Alpha client
appId = '5R49J7-J888YX9J2V'
wolframClient = wolframalpha.Client(appId)
 
def speak(text, rate = 120):
    engine.setProperty('rate', rate)
    engine.say(text)
    engine.runAndWait()
 
def parseCommand():
    listener = sr.Recognizer()
    print('Listening for a command')
 
    with sr.Microphone() as source:
        listener.pause_threshold = 2
        input_speech = listener.listen(source)
 
    try: 
        print('Recognizing speech...')
        query = listener.recognize_google(input_speech, language='en_gb')
        print(f'The input speech was: {query}')
    except Exception as exception:
        print('No command received, insert a command')
        speak('No command received, insert a command' )
        print(exception)
        return 'None'
 
    return query
 
def search_wikipedia(query = ''):
    searchResults = wikipedia.search(query)(search_wikipedia(query))
    if not searchResults:
        print('No wikipedia result')
        return 'No result received'
    try: 
        wikiPage = wikipedia.page(searchResults[0])
    except wikipedia.DisambiguationError as error:
        wikiPage = wikipedia.page(error.options[0])
    print(wikiPage.title)
    wikiSummary = str(wikiPage.summary)
    return wikiSummary
 
def listOrDict(var):
    if isinstance(var, list):
        return var[0]['plaintext']
    else:
        return var['plaintext']
 
def search_wolframAlpha(query = ''):
    response = wolframClient.query(query)
 
    # @success: Wolfram Alpha was able to resolve the query
    # @numpods: Number of results returned
    # pod: List of results. This can also contain subpods
    if response['@success'] == 'false':
        return 'Could not compute'
    
    # Query resolved
    else:
        result = ''
        # Question 
        pod0 = response['pod'][0]
        pod1 = response['pod'][1]
        # May contain the answer, has the highest confidence value
        # if it's primary, or has the title of result or definition, then it's the official result
        if (('result') in pod1['@title'].lower()) or (pod1.get('@primary', 'false') == 'true') or ('definition' in pod1['@title'].lower()):
            # Get the result
            result = listOrDict(pod1['subpod'])
            # Remove the bracketed section
            return result.split('(')[0]
        else: 
            question = listOrDict(pod0['subpod'])
            # Remove the bracketed section
            return question.split('(')[0]
            # Search wikipedia instead
            speak('Computation failed. Querying universal databank.')
            return search_wikipedia(question)
 
 
 
# Authenticate to the OpenAI API
openai.api_key = "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"

# Function to generate a response using GPT-3
def generate_response(prompt):
    completions = openai.Completion.create(
        engine="text-davinci-002",
        prompt=prompt,
        max_tokens=2048,
        n=1,
        stop=None,
        temperature=0.5,
    )

    message = completions.choices[0].text
    return message

def speak(text, rate = 120):
    engine.setProperty('rate', rate)
    engine.say(text)
    engine.runAndWait()

def parseCommand():
    listener = sr.Recognizer()
    print('Listening for a command')

    with sr.Microphone() as source:
        listener.pause_threshold = 2
        input_speech = listener.listen(source)

    try: 
        print('Recognizing speech...')
        query = listener.recognize_google(input_speech, language='en_gb')
        print(f'The input speech was: {query}')
    except Exception as exception:
        print('No command received, insert a command' )
        speak('No command received, insert a command' )
        print(exception)
        return 'None'

    return query

# Main loop
if __name__ == '__main__':
    speak('All systems are working correctly and are up to date.')

    while True:
        # Parse command
        query = parseCommand()

        if query != 'None':
            response = generate_response(query)
            speak(response)

 
            # List commands
            
            if query[0] == 'say':
                if 'hello' in query:
                    speak('Hello, Big Boss. How are you today? How can i help you conquer the world?')
                else: 
                    query.pop(0) # Remove say
                    speech = ' '.join(query)
                    speak(speech)

                    # Set commands
            if query[0] == 'say':
                if 'hello' in query:
                    speak('Greetings, all!')
                else:
                    speak(' '.join(query[1:]))
            elif query[0] == 'search':
                if 'wikipedia' in query:
                    speak(search_wikipedia(' '.join(query[1:])))
                else:
                    speak(search_chatgpt(' '.join(query[1:])))
 
            # Navigation
            if query[0] == 'go' and query[1] == 'to':
                speak('Opening...')
                query = ' '.join(query[2:])
                webbrowser.get('chrome').open_new(query)
 
            # Wikipedia 
            if query[0] == 'wikipedia':
                query = ' '.join(query[1:])
                speak('Querying the universal databank.')
                speak(search_wikipedia(query))
                
            # Wolfram Alpha
            if query[0] == 'compute' or query[0] == 'computer':
                query = ' '.join(query[1:])
                speak('Computing')
                try: 
                    result = search_wolframAlpha(query)
                    speak(result)
                except:
                    speak('Unable to compute.')
 # OpenAI client
openai_client =openai.Client(api_key="YOUR-API")

def speak(text, rate = 120):
    engine.setProperty('rate', rate) 
    engine.say(text)
    engine.runAndWait()

def parseCommand():
    listener = sr.Recognizer()
    print('Awaiting command')

    with sr.Microphone() as source:
        listener.pause_threshold = 2
        input_speech = listener.listen(source)

    try:
        print('Recognizing speech...')
        query = listener.recognize_google(input_speech, language='en_gb')
        print(f'The input speech was: {query}')

    except Exception as exception:
        print('no command received, repeat your command')
        speak('no command received, repeat your command')
        print(exception)

        return 'None'

    return query

def search_wikipedia(keyword=''):
    searchResults = wikipedia.search(keyword)
    if not searchResults:
        return 'No result received'
    try: 
        wikiPage = wikipedia.page(searchResults[0]) 
    except wikipedia.DisambiguationError as error:
        wikiPage = wikipedia.page(error.options[0])
    print(wikiPage.title)
    wikiSummary = str(wikiPage.summary)
    return wikiSummary

def search_chatgpt(prompt):
    response = openai_client.completion(engine="text-davinci-002", prompt=prompt, max_tokens=2048)
    return response.choices[0].text

prompt = "Hello, How can i help you today?"
completions = openai.Completion.create(engine="text-davinci-002", prompt=prompt)
print(completions.choices[0].text)
from gtts import gTTS
tts = gTTS("Hello, How can I help you today?")

# Main loop
if __name__ == '__main__': 
    speak('All systems are working optimal.', 120)

    while True:
        # Parse as a list
        query = parseCommand().lower().split()

        if query[0] == activationWord:
            query.pop(0)

            # Set commands
            if query[0] == 'say':
                if 'hello' in query:
                    speak('Greetings, all!')
                else:
                    speak(' '.join(query[1:]))
            elif query[0] == 'search':
                if 'wikipedia' in query:
                    speak(search_wikipedia(' '.join(query[1:])))
                else:
                    speak(search_chatgpt(' '.join(query[1:])))
            # Note taking
            if query[0] == 'log':
                speak('Ready to record your note')
                newNote = parseCommand().lower()
                now = datetime.now().strftime('%Y-%m-%d-%H-%M-%S')
                with open('note_%s.txt' % now, 'w') as newFile:
                    newFile.write(newNote)
                speak('Note written')
 
            if query[0] == 'exit':
                speak('Goodbye')
                break
            