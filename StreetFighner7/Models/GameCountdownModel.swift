//
//  GameCountdownModel.swift
//  StreetFighner7
//
//  Created by Taishin Miyamoto on 2024/09/08.
//

import Foundation

final class GameCountdownModel: ObservableObject {
    private var timer: Timer?
    
    init() {
        
    }

    deinit {
        timer?.invalidate()
    }

    func observeCountdown(timeLimit: Int, countdown:  @escaping (Int) -> Void, completion: @escaping () -> Void) {
        var remainingTime = timeLimit
        countdown(remainingTime)
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            if remainingTime > 0 {
                remainingTime -= 1
                countdown(remainingTime)
            } else {
                self.timer?.invalidate()
                completion()
            }
        }
    }
}
