import Foundation

public enum Endpoint: String {
    
    private static let baseURL = "https://dummyjson.com/"
    
    enum QueryParameter: String {
        case limit
    }

    case todos

    var url: String {
        return Endpoint.baseURL + self.rawValue
    }
    
    func urlWithParams(_ parameters: [QueryParameter: String?]) -> String {
        var url = url + "?"
        for parameter in parameters {
            if let value = parameter.value {
                url += "\(parameter.key)=\(value)&"
            }
        }
        return url
    }
}
