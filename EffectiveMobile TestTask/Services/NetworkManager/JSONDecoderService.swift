import Foundation

typealias DecodeResult<T: Decodable> = Result<T, Error>

final class JSONDecoderService {

    public static let shared = JSONDecoderService()

    private let decoder: JSONDecoder

    private init() {
        decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
    }

    func decode<T: Decodable>(_ type: T.Type, from data: Data) -> DecodeResult<T> {
        do {
            let decodedObject = try decoder.decode(T.self, from: data)
            return .success(decodedObject)
        } catch {
            return .failure(error)
        }
    }
}
