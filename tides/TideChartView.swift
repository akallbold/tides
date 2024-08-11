import SwiftUI
import Charts

struct TideChartView: View {
    @StateObject private var tideService = TideService.shared
    
    var body: some View {
        if let tideData = tideService.tideData {
            Chart {
                // LineMark for the tide heights over time
                ForEach(tideData.heights, id: \.dt) { height in
                    LineMark(
                        x: .value("Time", formatTimestamp(height.dt)),
                        y: .value("Height", height.height)
                    )
                }
                
                // PointMark for the current tide height
                if let currentHeight = tideData.currentHeight {
                    PointMark(
                        x: .value("Time", formatTimestamp(currentHeight.dt)),
                        y: .value("Height", currentHeight.height)
                    )
                    .symbolSize(100)  // Adjust the size of the point
                    .foregroundStyle(.red)  // Customize the color of the point
                }
            }
            .chartYAxis {
                AxisMarks(values: .automatic) { _ in
                    AxisGridLine()
                }
            }
            .chartXAxis {
                AxisMarks(values: .automatic) { _ in
                    AxisGridLine()
                }
            }
            .frame(height: 300)
            .padding()
        } else {
            Text("No Tide Data Available")
        }
    }
    
    // Helper function to convert timestamp to formatted time string
    func formatTimestamp(_ timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.timeStyle = .short
        dateFormatter.dateStyle = .none
        return dateFormatter.string(from: date)
    }
}

struct TideChartView_Previews: PreviewProvider {
    static var previews: some View {
        TideChartView()
    }
}
