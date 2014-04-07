# -*- coding: utf:-8 -*-

from eve import Eve
if __name__ == '__main__':
    port = 5000
    host = '127.0.0.1'
    app = Eve()
    app.run(host=host, port=port)
