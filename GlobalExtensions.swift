import Foundation
extension Date{
    func dateToString() -> String{
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withFullDate]
        return f.string(from: self)
    }
}
extension String{
    func stringToDate() -> Date{
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withFullDate]
        return f.date(from: self)!
    }
}
