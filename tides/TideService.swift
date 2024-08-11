import Foundation
import Alamofire
import Combine

class TideService: ObservableObject {
    static let shared = TideService()
    private init() {}

    @Published var tideData: TideData?
    @Published var status: String?

    func fetchTideData(latitude: Double, longitude: Double, completion: (([TideExtreme]?, TideHeight?, String?) -> Void)? = nil) {
        let url = "https://us-central1-ideas-411418.cloudfunctions.net/get-tides"
        let parameters: [String: Any] = ["latitude": latitude, "longitude": longitude]

        print("Fetching tide data for latitude: \(latitude), longitude: \(longitude)")

        AF.request(url, method: .get, parameters: parameters).responseDecodable(of: TideResponse.self) { response in
            switch response.result {
            case .success(let tideResponse):
                
                self.tideData = TideData(extremes: tideResponse.extremes,currentHeight: tideResponse.currentHeight, heights: tideResponse.heights)
                self.setStatus()
//                completion?(tideResponse.extremes, tideResponse.currentHeight, nil)

            case .failure(let error):
                print("Error fetching tide data: \(error.localizedDescription)")
                
                // Clear the public variable if there's an error
                self.tideData = nil
                
                // Pass the error to the completion handler
//                completion?(nil, nil, error.localizedDescription)
            }
        }
    }
    func setStatus() {
            guard let tideData = tideData else { return }
            let currentTime = Date().timeIntervalSince1970
        print("currentTime: \(String(describing: currentTime))")
       

            // Iterate through the extremes to determine the status
            for i in 0..<tideData.extremes.count {
                let extreme = tideData.extremes[i]
                let timeDifference = abs(Double(extreme.dt) - currentTime)
                let oneHourInSeconds: Double = 3600
                if timeDifference <= oneHourInSeconds {
                    if extreme.type == "Low" {
                        status = "low"
                        return
                    } else if extreme.type == "High" {
                        status = "high"
                        return
                    }
                } else if extreme.type == "Low" && currentTime < Double(extreme.dt) {
                    status = "go-low"
                } else if extreme.type == "High" && currentTime < Double(extreme.dt) {
                    status = "go-high"
                }
            }
        }
    }




struct TideExtreme: Decodable,Identifiable {
    let dt: Int
    let date: String
    let height: Double
    let type: String
    var id: Int { dt }
}

struct TideHeight: Decodable,Identifiable {
    let dt: Int
    let date: String
    let height: Double
    var id: Int { dt }
}

struct TideResponse: Decodable {
    let extremes: [TideExtreme]
    let currentHeight: TideHeight?
    let heights: [TideHeight]
}

struct TideData: Decodable {
    let extremes: [TideExtreme]
    let currentHeight: TideHeight?
    let heights: [TideHeight]
}
