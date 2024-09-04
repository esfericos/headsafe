//
//  HeadSafeFlow.swift
//  HeadSafe
//
//  Created by Pedro Olyntho on 28/08/24.
//

import SwiftUI

class HeadSafeFlow: ObservableObject {
    static let shared = HeadSafeFlow()
    
    @Published var path = NavigationPath()
    
    func clear() {
        path = .init()
    }
    
    func navigateBackToRoot() {
        path.removeLast(path.count)
    }
    
    func backToPrevious() {
        path.removeLast()
    }
    
    func done() {
        path = .init()
    }
    
//    func navigateToAboutView() {
//        path.append(PomodoroNavigation.aboutView)
//    }
//    
//    func navigateToHistoryView() {
//        path.append(PomodoroNavigation.historyView)
//    }
//    
//    func navigateToTimerView() {
//        path.append(PomodoroNavigation.timerView)
//    }
}
