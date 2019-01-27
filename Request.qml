import QtQuick 2.7

// This component enables performing requests for external data in QML-style.
QtObject {

    enum Error {
        NetworkError, // no network
        HttpStatus, // http statuses like 400, 403, 404, 500, etc.
        ParseError, // response cannot be parsed
        ValidationError // validation error - unexpected response schema
    }

    // Entry point method from data access layer. This function should return
    // parsed response via callback (like get, post from requests.js)
    property var handler: null

    // Validator is a function which validates successfully parsed response.
    // It should check if the structure of the object is as expected. If this
    // method returns false, error signal is emitted with error type equal to
    // Request.Error.ValidationError
    property var validator: function() { return true }

    // This property indicates if there is a pending requests (call was invoked
    // but success/error singal has not arrived so far)
    property bool busy: false // read-only

    // invoked when request is initialized (method call is invoked)
    signal called

    // invoked when request is successfully processed
    // res - request object
    // details - object with details of response, see requests.js parseResponse
    signal success(var res, var details)

    // invoked when error occurred
    // type - type of error - see Request.Error
    signal error(int type, var details)

    // invoked always when request is processed, regardless if there is success
    // or error
    signal finished

    // This method initializes request. It takes the same set of parameters as
    // provided handler function excluding last one which should be a callback.
    // This method decides if request is successfull or not and emits success
    // or error singal respectively.
    // If this method is called before the previous invocation is not finished
    // (success/error and finished not emitted), the next invocation will mark
    // previous invocation as abandoned.
    function call() {

        called()

        internal.counter++

        var counter = internal.counter

        var argList = []

        for(var i = 0; i < arguments.length; i++) {
            argList.push(arguments[i])
        }

        argList.push(function(res) {
            if(counter === internal.counter) {

                busy = false

                var status = res.status
                var text = res.text
                var body = res.body

                // network error
                if(status === 0 && text === null) {
                    return _emitError(Error.NetworkError, res)
                }

                // local files
                if(status === 0 && text !== null && body === null) {
                    return _emitError(Error.ParseError, res)
                }

                if(status === 0 && text !== null && body !== null) {

                    if(validator(body)) {
                        return _emitSuccess(body, res)
                    } else {
                        return _emitError(Error.ValidationError, res)
                    }
                }

                // remote reponses
                if(status !== 0) {

                    if(status >= 200 && status < 300) {

                        if(body === null) { // parse error
                            return _emitError(Error.ParseError, res)
                        }

                        if(validator(body)) { // success
                            return _emitSuccess(body, res)
                        } else { // validation error
                            return _emitError(Error.ValidationError, res)
                        }

                    } else { // http status error
                        return _emitError(Error.HttpStatus, res)
                    }
                }
            }
        })

        console.assert(handler)

        busy = true
        handler.apply(null, argList)
    }

    // If there is no pending request (busy flag is set to false), this method
    // has no effect. If there is a pending request, it will be abandoned
    // (success/error and finished signals won't be emited). There is no
    // guarantee that this request already arrived to the server, so it should
    // be used carefully with http requests other than 'GET'
    // No signal is emitted after invoking this method.
    function abandon() {
        internal.counter++
        busy = false
    }

    // private
    function _emitSuccess(body, res) {
        success(body, res)
        finished()
    }

    // private
    function _emitError(errorCode, res) {
        error(errorCode, res)
        finished()
    }


    Component.onDestruction: {
        abandon();
    }

    property QtObject internal: QtObject {
        property int counter: 0
    }
}
