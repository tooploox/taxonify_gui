pragma Singleton
import QtQuick 2.12

QtObject {
    readonly property var additionalAttributes: ['with_eggs', 'dividing', 'dead',
        'with_epibiont', 'with_parasite', 'broken', 'colony', 'cluster', 'eating',
        'multiple_species', 'partially_cropped', 'male', 'female', 'juvenile',
        'adult', 'ephippium', 'resting_egg', 'heterocyst', 'akinete', 'with_spines',
        'beatles', 'stones', 'zeppelin', 'floyd', 'acdc', 'hendrix', 'alan_parsons',
        'allman', 'dire_straits', 'eagles', 'guns', 'purple', 'van_halen', 'skynyrd',
        'zz_top', 'iron', 'police', 'moore', 'inxs', 'chilli_peppers']

    readonly property var taxonomyAttributes: [
        'empire', 'kingdom', 'phylum', 'class', 'order', 'family', 'genus',
        'species'
    ]

    readonly property var morphometricAttributes: [
        'area', 'aspect_ratio', 'eccentricity', 'estimated_volume', 'file_size',
        'maj_axis_len', 'min_axis_len', 'orientation', 'solidity'
    ]
}
