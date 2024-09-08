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
    
    func setResultScoreValue(resultScoreValue: ResultScoreValue) {
        self.successLeft = resultScoreValue.successLeft
        self.successCenter = resultScoreValue.successCenter
        self.successRight = resultScoreValue.successRight
        self.failureLeft = resultScoreValue.failureLeft
        self.failureCenter = resultScoreValue.failureCenter
        self.failureRight = resultScoreValue.failureRight
        self.totalAvoid = resultScoreValue.totalAvoid
    }
}

class ResultScoreValue: Codable {
    let successLeft: Int
    let successCenter: Int
    let successRight: Int
    let failureLeft: Int
    let failureCenter: Int
    let failureRight: Int
    let totalAvoid: Int
    
    init(successLeft: Int, successCenter: Int, successRight: Int, failureLeft: Int, failureCenter: Int, failureRight: Int, totalAvoid: Int) {
        self.successLeft = successLeft
        self.successCenter = successCenter
        self.successRight = successRight
        self.failureLeft = failureLeft
        self.failureCenter = failureCenter
        self.failureRight = failureRight
        self.totalAvoid = totalAvoid
    }
    
    func toJson() -> String? {
        let encoder = JSONEncoder()
        
        do {
            let jsonData = try encoder.encode(self)
            let jsonString = String(data: jsonData, encoding: .utf8)
            return jsonString
        } catch {
            print("Failed to encode Message to JSON: \(error)")
            return nil
        }
    }
    
    static func fromJson(jsonString: String) -> ResultScoreValue? {
        let decoder = JSONDecoder()
        
        guard let jsonData = jsonString.data(using: .utf8) else {
            print("Failed to convert JSON string to Data.")
            return nil
        }
        
        do {
            let message = try decoder.decode(ResultScoreValue.self, from: jsonData)
            return message
        } catch {
            print("Failed to decode JSON: \(error)")
            return nil
        }
    }
}
