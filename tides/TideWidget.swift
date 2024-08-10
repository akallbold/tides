import SwiftUI

struct TideWidget: View {
    var currentTide: String
    var nextHighTide: String
    var nextLowTide: String

    var body: some View {
        VStack {
            Text("Current Tide: \(currentTide)")
            Text("Next High Tide: \(nextHighTide)")
            Text("Next Low Tide: \(nextLowTide)")
        }
        .padding()
        .background(gradientColor)
        .cornerRadius(10)
    }

    var gradientColor: LinearGradient {
        let highTideColor = Color.blue
        let lowTideColor = Color.green

        // Assuming tide data is formatted as "12:34 PM"
        let currentTime = Date()
        let highTideTime = tideTime(from: nextHighTide)
        let lowTideTime = tideTime(from: nextLowTide)

        let progress = CGFloat(timeDifference(from: currentTime, to: highTideTime) / timeDifference(from: lowTideTime, to: highTideTime))

        return LinearGradient(gradient: Gradient(colors: [highTideColor, lowTideColor]), startPoint: .top, endPoint: .bottom)
    }

    func tideTime(from string: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm a"
        return formatter.date(from: string) ?? Date()
    }

    func timeDifference(from date1: Date, to date2: Date) -> TimeInterval {
        return date2.timeIntervalSince(date1)
    }
}

struct TideWidget_Previews: PreviewProvider {
    static var previews: some View {
        TideWidget(currentTide: "12:34 PM", nextHighTide: "06:12 PM", nextLowTide: "01:45 AM")
    }
}
