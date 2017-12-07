from flask import Flask, jsonify, request
from flask_cors import CORS
import json
from diplomacyserver import init


app = Flask(__name__)

defUrl = '/api/'

app = Flask(__name__)
CORS(app)

#recives and validates order
#order is of the form JSON: {“unitID”= int,”targetName”=string, “orderType”=string }
@app.route(defUrl + 'send_order', methods=['POST'])
def send_order():
    if request.is_json:
        #content will contain a dictionary describing the order
        content = request.get_json()
        #validate_order will return true if the order is valid
        #valid = validate_order(content)
        if valid:
            #order is ok
            return 200
        else:
            #order is not ok
            return 418
    else:
        return 418

#recives a faction name in a json and returns 200 when all other players
#have confirmed orders
#json of the form {"faction"="faction_name"}
@app.route(defUrl + 'confirm_orders', methods=['POST'])
def confirm_orders():
    if request.is_json:
        content = request.get_json()
        #waits until all orders are in then returns
        #confirm(content)
        return 200
    else:
        return 418

@app.route(defUrl + 'get_game', methods=['GET'])
def getGame():
    print("Game data requested")
    data = init.getGame()

    out = []
    for team in data:
        out.append(str(jsonify({'army':json.dumps(team[0]), 'navy':json.dumps(team[1]), 'score':team[2]}).data))

    return jsonify({'teams':json.dumps(out), 'status':200})

if __name__ == '__main__':
    init.game()
    app.run()