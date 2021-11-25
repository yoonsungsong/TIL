from flask import *
app = Flask(__name__)
@app.route("/")
def hello():
    return "Hello Flask"
# returns an HTML webpage
@app.route("/user/<username>")
def user(username):
    return render_template('profile.html', name=username)
# retruns a piece of data in JSON format
@app.route("/people")
def people():
    people = {"alice": 25, "jin":35}
    return jsonify(people)
# run was
app.run(debug=True)
