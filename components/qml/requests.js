.pragma library
.import Application 1.0 as App

var baseAddress = App.Configuration ? App.Configuration.serverAddress() : '';
//var baseAddress = 'http://virtum-production.westeurope.cloudapp.azure.com/pythagoras'

// Creates url query string from provided map. Key should not contain spaces
// nor special characters. Value is converted to a string using .toString()
// method.
//
// Example:
// var query = {
//     key1: 'val1',
//     key2: 'val2 and sth'
// }
//
// Req.encodeQuery(advancedQuery)
//
// result: 'key1=val1&key2=val2%20and%20sth'
function encodeQuery(obj) {

    var result = ""

    try {
    var keys = Object.keys(obj)
    } catch (e) {
        console.log(e)
    }
    keys.forEach(function (key, idx) {

        var val = obj[key]

//        if(!(typeof val === 'string' || val instanceof String))
//            return

        if(result.length !== 0)
            result += '&'

        result += key + '=' + encodeURI(val.toString())
    })

    return result
}

// This method sends requests appending parameters appropriately to given
// method. XMLHttpRequest is returned immediatelly and by callback when request
// is in DONE state.
function sendRequest(address, parameters, method, headers, cb) {

    console.assert(['GET', 'PUT', 'POST', 'DELETE'].indexOf(method) != -1)

    var request = new XMLHttpRequest

    var parametersStr = ""

    if (method === 'GET' && parameters) {

        var fullAddress = address + '?' + encodeQuery(parameters)
        request.open(method, fullAddress)

    } else if (parameters) {

        request.open(method, address)

        parametersStr = JSON.stringify(parameters)
        request.setRequestHeader("Content-type", "application/json")
        request.setRequestHeader("Content-length", parametersStr.length)

    } else {

        request.open(method, address)
    }

    headers.forEach(function(header) {
        request.setRequestHeader(header[0], header[1])
    })

    request.onreadystatechange = function() {

        if (request.readyState !== XMLHttpRequest.DONE)
            return;

        cb(request);
    }

    if (method !== 'GET' && parameters) {
        request.send(parametersStr)
    } else {
        request.send()
    }

    return request;
}

// This method parses ready XMLHttpRequest and returns following object:
// {
//     parameters: object - contains original paramters used in the request
//     status: number - http response code or 0
//     body: object - http response parsed to json or null if parsing failed
//     message: string - message extracted from response or default one
//     text: string - original response
// }
function parseResponse(parameters, readyRequest) {

    console.assert(readyRequest.readyState === 4)

    var status = readyRequest.status
    var text = readyRequest.responseText
    var message = 'Message not provided.'

    var json = null

    //***** https://bugreports.qt.io/browse/QTBUG-30605 //TODO: better workaround
    if(text.substr(0, 33) === 'Moved Permanently. Redirecting to') {
        text = text.substr(text.indexOf('{'))
    }
    //*****

    //https://bugreports.qt.io/browse/QTBUG-46862
    if(status === 0 && text === "") { // loading from fs gives status 0
        message = 'Network error.'
    } else {
        try {
            json = JSON.parse(text)
            if(json.message)
                message = json.message
        }
        catch (error) {
            message = 'JSON parse error (received: ' + text + ")"
        }
    }
    return {
        parameters: parameters,
        status: status,
        body: json,
        message: message,
        text: text
    }
}

// Helper checking types of arguments and relaying to sendRequest method.
// Immediatelly returns original XMLHttpRequest object and parsed response
// (using parseRepsonse method) by callback.
function genericHttpRequest(method, address, parametersOrCb, cb) {

    address = baseAddress + address
    cb = parametersOrCb instanceof Function ? parametersOrCb : cb
    var params = parametersOrCb instanceof Function ? null : parametersOrCb

    return sendRequest(address, params, method, [], function(readyRequest) {

        var parsedResponse = parseResponse(params, readyRequest);

        cb(parsedResponse);
    });
}

function rawGenericHttpRequest(method, address, parametersOrCb, cb) {

    //address = baseAddress + address
    cb = parametersOrCb instanceof Function ? parametersOrCb : cb
    var params = parametersOrCb instanceof Function ? null : parametersOrCb

    return sendRequest(address, params, method, [], function(readyRequest) {

        var parsedResponse = parseResponse(params, readyRequest);

        cb(parsedResponse);
    });
}

// Set of convenience functions calling genericHttpRequest with appropriate
// parameters.

function get(address, parametersOrCb, cb) {
    return genericHttpRequest('GET', address, parametersOrCb, cb)
}

function rawGet(address, parametersOrCb, cb) {
    return rawGenericHttpRequest('GET', address, parametersOrCb, cb)
}

function post(address, parametersOrCb, cb) {
    return genericHttpRequest('POST', address, parametersOrCb, cb)
}

function put(address, parametersOrCb, cb) {
    return genericHttpRequest('PUT', address, parametersOrCb, cb)
}

function del(address, parametersOrCb, cb) {
    return genericHttpRequest('DELETE', address, parametersOrCb, cb)
}

// This method behaves like get() but reads data from local file and
// doesn't get any parameters.
function getLocal(address, cb) {

    return sendRequest(address, null, 'GET', [], function(readyRequest) {

        var parsedResponse = parseResponse(null, readyRequest);
        console.assert(parsedResponse.body !== null, parsedResponse.message);

        cb(parsedResponse);
    });
}

// path shoud start with 'file://'
function readJsonFromLocalFileSync(path) {
    var request = new XMLHttpRequest
    request.open('GET', path, false)
    request.send(null)

    if (request.status === 200) {
        try {
            return JSON.parse(request.responseText)
        } catch(e) {
            console.warn('Error when reading json file ', path)
            console.log(e)
        }
    }

    return null
}


function forward(obj) {
    return {
        status: 200,
        body: obj,
        text: ''
    }
}

function Server(baseAddress) {
    this.baseAddress = baseAddress
}

Server.prototype = {
    genericHttpRequest: function (method, address, parametersOrCb, cb) {
        address = this.baseAddress + address

        var params = null

        if(parametersOrCb instanceof Function) {
            cb = parametersOrCb
        } else {
            params = parametersOrCb
        }

        return sendRequest(address, params, method, [], function(readyRequest) {
            cb(parseResponse(params, readyRequest));
        });
    },
    get: function(address, parametersOrCb, cb) {
        return this.genericHttpRequest('GET', address, parametersOrCb, cb)
    },
    post: function(address, parametersOrCb, cb) {
        return this.genericHttpRequest('POST', address, parametersOrCb, cb)
    },
    put: function(address, parametersOrCb, cb) {
        return this.genericHttpRequest('PUT', address, parametersOrCb, cb)
    },
    del: function(address, parametersOrCb, cb) {
        return this.genericHttpRequest('DELETE', address, parametersOrCb, cb)
    },

    send: function(req, cb) {

        console.assert(cb instanceof Function)
        console.assert(req.hasOwnProperty('handler'))
        console.assert(req.hasOwnProperty('method'))

        var handler = req.handler
        var method = req.method
        var params = req.params
        var headers = req.headers

        if(!headers) {
            headers = []
        }

        var address = this.baseAddress + handler

        return sendRequest(address, params, method, headers, function(readyRequest) {

            var parsedResponse = parseResponse(params, readyRequest);
            cb(parsedResponse);
        });
    }
}
