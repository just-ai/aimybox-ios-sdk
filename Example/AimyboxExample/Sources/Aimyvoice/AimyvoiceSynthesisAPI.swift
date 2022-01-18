import AVFoundation
import Foundation

final
class AimyvoiceSynthesisAPI {

    private
    let address: URL

    private
    let operationQueue: OperationQueue

    private
    let apiKey: String

    init(
        apiKey: String,
        api address: URL,
        operation queue: OperationQueue
    ) {
        self.apiKey = apiKey
        self.address = address
        self.operationQueue = queue
    }

    func request(text: String, onResponse completion: @escaping (URL?) -> Void) {
        guard let components = URLComponents(url: address, resolvingAgainstBaseURL: true) else {
            return
        }

        guard
            let str = components.url?.absoluteString.replacingOccurrences(of: "+", with: "%2B"),
            let url = URL(string: str)
        else {
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue(apiKey, forHTTPHeaderField: "api-key")
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        request.httpBody = "text=\(text)".data(using: .utf8)

        perform(request, onResponse: completion)
    }

    private
    func perform(_ request: URLRequest, onResponse: @escaping (URL?) -> Void) {
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard error == nil else {
                return onResponse(nil)
            }

            guard let code = (response as? HTTPURLResponse)?.statusCode, 200..<300 ~= code else {
                return onResponse(nil)
            }

            guard let localData = data else {
                return onResponse(nil)
            }

            guard let localUrl = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
                .first?
                .appendingPathComponent("\(UUID().uuidString).wav")
            else {
                return onResponse(nil)
            }

            do {
                try localData.write(to: localUrl)
                onResponse(localUrl)
                try? FileManager.default.removeItem(at: localUrl)
            } catch {
                onResponse(nil)
            }
        }

        DispatchQueue.global(qos: .userInitiated).async {
            task.resume()
        }
    }

}
