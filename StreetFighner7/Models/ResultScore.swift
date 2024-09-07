import Foundation

class ResultScore: ObservableObject {
    @Published var successLeft: Int = 0
    @Published var successCenter: Int = 0
    @Published var successRight: Int = 0
    @Published var failureLeft: Int = 0
    @Published var failureCenter: Int = 0
    @Published var failureRight: Int = 0
    @Published var totalAvoid: Int = 0

    var totalSuccess: Int {
        return successLeft + successCenter + successRight
    }

    var totalFailure: Int {
        return failureLeft + failureCenter + failureRight
    }

    func recordSuccess(at position: CatHandDirection) {
        switch position {
        case .left:
            successLeft += 1
        case .center:
            successCenter += 1
        case .right:
            successRight += 1
        }
    }

    func recordFailure(at position: CatHandDirection) {
        switch position {
        case .left:
            failureLeft += 1
        case .center:
            failureCenter += 1
        case .right:
            failureRight += 1
        }
    }
    
    func recordAvoid(){
        totalAvoid += 1
    }

    func resetScores() {
        successLeft = 0
        successCenter = 0
        successRight = 0
        failureLeft = 0
        failureCenter = 0
        failureRight = 0
        totalAvoid = 0 // ただ避けただけの回数
    }
}
