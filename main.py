from flask import Flask, jsonify, request
from postal.parser import parse_address


app = Flask(__name__)


@app.route('/', methods=['POST'])
def expand():
    addr = request.json.get('address', '')
    return jsonify(parse_address(addr))

