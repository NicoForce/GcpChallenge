import os
from flask import Flask, request
app = Flask('task')

@app.route('/')
def hello_world():
    return 'Hey, we have Flask in a Docker container!'

@app.route('/greetings')
def greetings():
    return 'Hello World from ' + os.uname()[1]

@app.route('/square', methods = ['GET', 'POST'])
def square():
    if request.method == 'POST':
        number = int(request.form.get('number'))
        return number * number
    else:
        return 'No number received'

app.run(debug=False, host='0.0.0.0')