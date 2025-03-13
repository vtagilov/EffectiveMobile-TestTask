import Foundation

enum NetworkError: Error {
    case badURL(String)
    case network(Error?)
    case decodeError(Error?)
}

typealias NetworkResult<T> = Result<T, NetworkError>

final class NetworkManager {

    public func fetchModel<T: Decodable>(type: T.Type, urlStr: String, _ completion: @escaping (NetworkResult<T>) -> Void) {
        fetchData(urlStr: urlStr) { [weak self] result in
            guard let sSelf = self else { return }
            switch result {
            case .success(let data):
                completion(sSelf.decodeData(data: data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    public func fetchData(urlStr: String, _ completion: @escaping (NetworkResult<Data>) -> Void) {
        guard let url = URL(string: urlStr) else {
            completion(.failure(.badURL(urlStr)))
            return
        }
        print("REQUEST URL: \(url)")
        DispatchQueue.global(qos: .background).async {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let error = error {
                    completion(.failure(.network(error)))
                    return
                }
                guard let data = data else {
                    completion(.failure(.network(nil)))
                    return
                }
                completion(.success(data))
            }.resume()
        }
    }

    private func decodeData<T: Decodable>(data: Data) -> NetworkResult<T> {
        let decodeResult = JSONDecoderService.shared.decode(T.self, from: data)
        switch decodeResult {
        case .success(let model):
            return .success(model)
        case .failure(let error):
            return .failure(.decodeError(error))
        }
    }
}
