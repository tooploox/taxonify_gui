import QtQuick 2.9

QtObject {

    property var server: null

    property QtObject internal: QtObject {

        readonly property int tokenRefreshInterval: 1000 * 60 * 10 // 10 min

        property string access_token
        property string refresh_token

        property var access_token_header
        property var refresh_token_header

        onAccess_tokenChanged: {
            access_token_header = ['Authorization', 'Bearer ' + access_token]
        }

        onRefresh_tokenChanged: {
             refresh_token_header = ['Authorization', 'Bearer ' + refresh_token]
        }

        property Timer refreshTimer: Timer {
            interval: internal.tokenRefreshInterval
            running: true
            repeat: true

            onTriggered: {
                if(internal.refresh_token) {
                    internal.refresh(internal.refresh_token)
                }
            }
        }

        function refresh(refresh_token) {
            var req = {
                handler: '/user/refresh',
                method: 'POST',
                headers: [internal.refresh_token_header]
            }
            return server.send(req, function(res) {
                if(res.body !== null) {
                    internal.access_token = res.body.access_token
                }
            })
        }
    }
}
