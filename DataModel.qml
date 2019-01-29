import QtQuick 2.0

ListModel {
    Component.onCompleted: {
        for(var i = 0; i < 100; i++) {

            var idx = i % 17
            var dead = i % 2

            append({
                       image: 'sample/sample_images/' + idx + '.jpeg',
                       selected: false,
                       dead: dead === 0
                   })
        }
    }
}
