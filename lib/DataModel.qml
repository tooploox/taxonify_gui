import QtQuick 2.0

ListModel {
    Component.onCompleted: {
        for(var i = 0; i < 100; i++) {

            var idx = i % 17
            var dead = i % 2
            var animal = exampleAnimals[i % 3]

            var item = {
                image: 'sample/sample_images/' + idx + '.jpeg',
                selected: false,
                dead: dead === 0
            }

            for (let p in animal)
                item[p] = animal[p]

            append(item)
        }
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
