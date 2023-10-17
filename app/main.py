from flask import Flask, jsonify, request
from postal.parser import parse_address


app = Flask(__name__)


@app.route('/')
def expand():
    addr = request.args.get('address', '')
    return jsonify(parse_address(addr))


if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000, debug=False)
