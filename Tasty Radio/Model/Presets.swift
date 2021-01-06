//
//  Presets.swift
//  Tasty Radio
//
//  Created by Vitaliy Podolskiy on 02.01.2021.
//  Copyright © 2021 DEVLAB, LLC. All rights reserved.
//

import Foundation

enum Presets {
    case presset1
    case presset2
    case presset3
    case presset4
    case presset5
    case presset6
    case presset7
    case presset8
    case presset9
    case presset10
    case presset11
    case presset12
    case presset13
    case presset14
    case presset15
    case presset16
    case presset17
    case presset18
    case presset19
    case presset20
    case presset21
    case presset22
    
    var name: String {
        switch self {
            case .presset1: return "Acoustic"
            case .presset2: return "Default"
            case .presset3: return "Treble Booster"
            case .presset4: return "Deep"
            case .presset5: return "Jazz"
            case .presset6: return "Classical"
            case .presset7: return "Latin"
            case .presset8: return "Lounge"
            case .presset9: return "Small Speakers"
            case .presset10: return "Treble Reducer"
            case .presset11: return "Pop"
            case .presset12: return "Spoken Word"
            case .presset13: return "R&B"
            case .presset14: return "Rock"
            case .presset15: return "Dance"
            case .presset16: return "Loudness"
            case .presset17: return "Bass Reducer"
            case .presset18: return "Bass Booster"
            case .presset19: return "Vocal Booster"
            case .presset20: return "Piano"
            case .presset21: return "Hip-Hop"
            case .presset22: return "Electronic"
        }
    }
    
    var values: [Double] {
        switch self {
            case .presset1:
                return [5.0, 5.0, 4.900000095367, 2.549999952316, 1.049999952316, 2.150000095367, 1.75, 3.5, 4.099999904633, 3.549999952316, 2.150000095367, 1.150000095367]
            case .presset2:
                return [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
            case .presset3:
                return [0, 0, 0, 0, 0, 0, 1.25, 2.5, 3.5, 4.25, 5.5, 6.0]
            case .presset4:
                return [5.0, 4.949999809265, 3.549999952316, 1.75, 1.0, 2.849999904633, 2.5, 1.450000047684, -2.150000095367, -3.549999952316, -4.599999904633, -5.0]
            case .presset5:
                return [4.0, 4.0, 3.0, 1.5, 2.25, -1.5, -1.5, 0.0, 1.5, 3.0, 3.75, 4.0]
            case .presset6:
                return [5.0, 4.75, 3.75, 3.0, 2.5, -1.5, -1.5, 0.0, 2.25, 3.25, 3.75, 4.0]
            case .presset7:
                return [5.0, 4.5, 3.0, 0.0, 0.0, -1.5, -1.5, -1.5, 0.0, 3.0, 4.5, 5.0]
            case .presset8:
                return [-3.0, -3.0, -1.5, -0.5, 1.5, 4.0, 2.5, 0.0, -1.5, 2.0, 1.0, 0.5]
            case .presset9:
                return [5.5, 5.5, 4.25, 3.5, 2.5, 1.25, 0.0, -1.25, -2.5, -3.5, -4.25, -5.0]
            case .presset10:
                return [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, -1.25, -2.5, -3.5, -4.25, -5.5, -5.75]
            case .presset11:
                return [-1.5, -1.5, -1.0, 0.0, 2.0, 4.0, 4.0, 2.0, 0.0, -1.0, -1.5, -2.0]
            case .presset12:
                return [-4, -3.460000038147, -0.469999998808, 0.0, 0.689999997616, 3.460000038147, 4.610000133514, 4.840000152588, 4.280000209808, 2.539999961853, 0.0, 0.0]
            case .presset13:
                return [3, 2.619999885559, 6.920000076294, 5.650000095367, 1.330000042915, -2.19000005722, -1.5, 2.319999933243, 2.650000095367, 3.0, 3.75, 4]
            case .presset14:
                return [5.0, 5.0, 4.0, 3.0, 1.5, -0.5, -1.0, 0.5, 2.5, 3.5, 4.5, 5]
            case .presset15:
                return [3.569999933243, 3.569999933243, 6.550000190735, 4.989999771118, 0.0, 1.919999957085, 3.650000095367, 5.150000095367, 4.539999961853, 3.589999914169, 0.0, 0.0]
            case .presset16:
                return [6.0, 6.0, 4.0, 0.0, 0.0, -2.0, 0.0, -1.0, -5.0, 5.0, 1.0, 1.0]
            case .presset17:
                return [-6.0, -5.5, -4.25, -3.5, -2.5, -1.25, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
            case .presset18:
                return [6.0, 5.5, 4.25, 3.5, 2.5, 1.25, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0]
            case .presset19:
                return [-1.2, -1.5, -3.0, -3.0, 1.5, 3.75, 3.75, 3.0, 1.5, 0.0, -1.5, -2.0]
            case .presset20:
                return [3.5, 3.0, 2.0, 0.0, 2.5, 3.0, 1.5, 3.5, 4.5, 3.0, 3.5, 4.0]
            case .presset21:
                return [5.25, 5.0, 4.25, 1.5, 3.0, -1.0, -1.0, 1.5, -0.5, 2.0, 3.0, 4.0]
            case .presset22:
                return [4.5, 4.25, 3.799999952316, 1.200000047684, 0.0, -2.150000095367, 2.25, 0.850000023842, 1.25, 3.950000047684, 4.800000190735, 5]
        }
    }
}
