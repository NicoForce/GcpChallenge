import os
from flask import Flask, request
app = Flask('task')

@app.route('/greetings', methods = ['GET', 'POST'])
def greetings():
    return 'Hello World from ' + os.uname()[1]

@app.route('/square', methods = ['GET', 'POST'])
def square():
    if request.method == 'POST':
        number = int(request.form.get('number'))
        return str(number * number)
    else:
        return 'No number received, use a POST call'

app.run(debug=False, host='0.0.0.0')