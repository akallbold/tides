import Foundation
import Alamofire
import Combine

class TideService: ObservableObject {
    static let shared = TideService()
    private init() {}

    @Published var tideData: TideData?

    func fetchTideData(latitude: Double, longitude: Double, completion: (([TideExtreme]?, TideHeight?, String?) -> Void)? = nil) {
        let url = "https://us-central1-ideas-411418.cloudfunctions.net/get-tides"
        let parameters: [String: Any] = ["latitude": latitude, "longitude": longitude]

        print("Fetching tide data for latitude: \(latitude), longitude: \(longitude)")

        AF.request(url, method: .get, parameters: parameters).responseDecodable(of: TideResponse.self) { response in
            switch response.result {
            case .success(let tideResponse):
                print("Tide data fetched successfully: \(tideResponse)")
                
                self.tideData = TideData(extremes: tideResponse.extremes, currentHeight: tideResponse.currentHeight)
                
                completion?(tideResponse.extremes, tideResponse.currentHeight, nil)

            case .failure(let error):
                print("Error fetching tide data: \(error.localizedDescription)")
                
                // Clear the public variable if there's an error
                self.tideData = nil
                
                // Pass the error to the completion handler
                completion?(nil, nil, error.localizedDescription)
            }
        }
    }
}

struct TideExtreme: Decodable {
    let dt: Int
    let date: String
    let height: Double
    let type: String
}

struct TideHeight: Decodable, Equatable {
    let dt: Int
    let date: String
    let height: Double
}

struct TideResponse: Decodable {
    let extremes: [TideExtreme]
    let currentHeight: TideHeight?
}

struct TideData: Decodable {
    let extremes: [TideExtreme]
    let currentHeight: TideHeight?
}
