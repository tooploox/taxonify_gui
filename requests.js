.pragma library

function encodeQuery(obj) {

     var result = ""

     try {
    var keys = Object.keys(obj)
    } catch (e) {
        console.log(e)
    }
    keys.forEach(function (key, idx) {

         var val = obj[key]
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

    console.assert(['GET', 'PUT', 'POST', 'DELETE'].includes(method))

    const request = new XMLHttpRequest

    let parametersStr = ""

    if (method === 'GET' && parameters) {

        const fullAddress = address + '?' + encodeQuery(parameters)
        request.open(method, fullAddress)

    } else if (parameters) {

        request.open(method, address)

        parametersStr = JSON.stringify(parameters)
        request.setRequestHeader("Content-type", "application/json")
        request.setRequestHeader("Content-length", parametersStr.length)

    } else {
        request.open(method, address)
    }

    headers.forEach((header) => {
        request.setRequestHeader(header[0], header[1])
    })

    request.onreadystatechange = () => {

        if (request.readyState !== XMLHttpRequest.DONE)
            return

        cb(request)
    }

    if (method !== 'GET' && parameters) {
        request.send(parametersStr)
    } else {
        request.send()
    }

    return request
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

    let status = readyRequest.status
    let text = readyRequest.responseText
    let message = 'Message not provided.'

    let json = null

    //***** https://bugreports.qt.io/browse/QTBUG-30605 //TODO: better workaround
    if(text.substr(0, 33) === 'Moved Permanently. Redirecting to') {
        text = text.substr(text.indexOf('{'))
    }
    //*****

    //https://bugreports.qt.io/browse/QTBUG-46862
    if(status === 0 && text === "") { // loading from fs gives status 0
        message = 'Network error.'
    } else {
        //TODO: Fix Server side bug and remove below if. Preserve else content.
        if (text === "null\n") {
            console.warn('Server responseText: "null\n", '
                         + 'interpreting as empty message "{}"')
            text = "{}"
        }

        try {
            console.log("Normal execution")
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

function rawGenericHttpRequest(method, address, parametersOrCb, cb) {

    let params = null

    if(parametersOrCb instanceof Function) {
        cb = parametersOrCb
    } else {
        params = parametersOrCb
    }

    return sendRequest(address, params, method, [], (readyRequest) => {
        cb(parseResponse(params, readyRequest))
    })
}

function rawGet(address, parametersOrCb, cb) {
    return rawGenericHttpRequest('GET', address, parametersOrCb, cb)
}

// This method behaves like get() but reads data from local file and
// doesn't get any parameters.
function getLocal(address, cb) {

    return sendRequest(address, null, 'GET', [], function(readyRequest) {

        const parsedResponse = parseResponse(null, readyRequest)
        console.assert(parsedResponse.body !== null, parsedResponse.message)

        cb(parsedResponse)
    })
}

// path shoud start with 'file://'
function readJsonFromLocalFileSync(path) {
    const request = new XMLHttpRequest
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

class Server {

    constructor (baseAddress) {
        this.baseAddress = baseAddress
    }

    genericHttpRequest (method, address, parametersOrCb, cb) {
        address = this.baseAddress + address
        return rawGenericHttpRequest(method, address, parametersOrCb, cb)
    }

    get (address, parametersOrCb, cb) {
        return this.genericHttpRequest('GET', address, parametersOrCb, cb)
    }

    post (address, parametersOrCb, cb) {
        return this.genericHttpRequest('POST', address, parametersOrCb, cb)
    }

    put (address, parametersOrCb, cb) {
        return this.genericHttpRequest('PUT', address, parametersOrCb, cb)
    }

    del (address, parametersOrCb, cb) {
        return this.genericHttpRequest('DELETE', address, parametersOrCb, cb)
    }

    send (req, cb) {

        console.assert(cb instanceof Function)
        console.assert(req.hasOwnProperty('handler'))
        console.assert(req.hasOwnProperty('method'))

        const handler = req.handler
        const method = req.method
        const params = req.params
        let headers = req.headers

        if(!headers) {
            headers = []
        }

        const address = this.baseAddress + handler

        return sendRequest(address, params, method, headers, (readyRequest) => {
            const parsedResponse = parseResponse(params, readyRequest)
            cb(parsedResponse)
        })
    }
}
