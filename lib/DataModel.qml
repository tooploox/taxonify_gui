import QtQuick 2.0

ListModel {
    property var images: [
        {path: 'sample/sample_images/15.jpeg', width: 104},
        {path: 'sample/sample_images/10.jpeg', width: 168},
        {path: 'sample/sample_images/14.jpeg', width: 192},
        {path: 'sample/sample_images/6.jpeg', width: 196},
        {path: 'sample/sample_images/4.jpeg', width: 192},
        {path: 'sample/sample_images/5.jpeg', width: 480},
        {path: 'sample/sample_images/13.jpeg', width: 352},
        {path: 'sample/sample_images/11.jpeg', width: 276},
        {path: 'sample/sample_images/3.jpeg', width: 236},
        {path: 'sample/sample_images/16.jpeg', width: 60},
        {path: 'sample/sample_images/9.jpeg', width: 332},
        {path: 'sample/sample_images/2.jpeg', width: 384},
        {path: 'sample/sample_images/8.jpeg', width: 252},
        {path: 'sample/sample_images/7.jpeg', width: 304},
        {path: 'sample/sample_images/12.jpeg', width: 228},
        {path: 'sample/sample_images/1.jpeg', width: 504},
        {path: 'sample/sample_images/0.jpeg', width: 192},
    ]
    property int imageNums: images.length

    function widthChanged(width) {
        console.log("widthchanged: ",width)
        clear()
        var row = []
        for(var i = 0, sumWidth=0; i < 5; i++) {
            var dead = i % 2
            var animal = exampleAnimals[i % 3]
            let idx = i % imageNums
            if(sumWidth + images[idx].width > width) {
                append({sub: row})
                sumWidth = 0
                row = []
            }
            var item = {
                image: images[idx].path,
                selected: false,
                dead: dead === 0
            }
            for (let p in animal)
                item[p] = animal[p]

            sumWidth += images[idx].width
            row.push(item)
            console.log("i=",i,", sumwidth=",sumWidth)
        }
        if(row.length > 0) {
            append({sub: row})
        }
    }

    Component.onCompleted: {
        widthChanged(640)
    }

    property var exampleAnimals: [{
            'empire': 'eukaryota',
            'kingdom': 'Animalia',
            'phylum': 'Rotifera',
            'class': 'Eurotatoria',
            'order': 'Flosculariacea',
            'family': 'Conochilidae',
            'genus': 'Conochilus',
            'species': 'sp'
    },
    {
            'empire': 'eukaryota',
            'kingdom': 'Chromalveolata',
            'phylum': 'Ciliophora',
            'class': 'Oligotrichea',
            'order': 'Choreotrichida',
            'family': 'Codonellidae',
            'genus': 'Tintinnopsis',
            'species': 'lacustris'
    },
    {
            'empire': 'prokaryota',
            'kingdom': 'Bacteria',
            'phylum': 'Cyanobacteria',
            'class': 'Cyanophyceae',
            'order': 'Nostocales',
            'family': 'Nostocaceae',
            'genus': 'Anabaena',
            'species': 'sp'
    }]
}
