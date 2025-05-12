//
//  TheatreShowTime.swift
//  Cinema Booking
//
//  Created by max on 11/5/2025.
//

import Foundation

struct TheatreShowtime: Identifiable {
    let id = UUID()
    let location: String
    let time: String
    var unavailableSeats: Set<String> = ["F4", "F5", "F6", "E2", "E3", "D5"]
}
