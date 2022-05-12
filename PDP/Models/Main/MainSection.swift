//
//  MainSection.swift
//  PDP
//
//  Created by Евгений Самарин on 30.03.2022.
//

import UIKit

enum MainSectionType: Int {
    case myDevicesSection
    case otherDevicesSecction
}

struct MainSection: Hashable {

    // MARK: - Instance Properties

    private let id = UUID()
    private let type: MainSectionType
    private let title: String
    private let devices: [MainDevicesPreview]

    // MARK: - Init

    init(type: MainSectionType, title: String, devices: [MainDevicesPreview]) {
        self.title = title
        self.type = type
        self.devices = devices
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(self.id)
    }

    static func == (lhs: MainSection, rhs: MainSection) -> Bool {
        lhs.id == rhs.id
    }
}
