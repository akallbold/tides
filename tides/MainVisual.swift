import SwiftUI

struct MainVisual: View {
    @ObservedObject private var tideService = TideService.shared
    
    var body: some View {
      
        VStack {
            switch tideService.status {
                
            case "high":
                Image("penguin")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            case "low":
                Image("penguin")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            case "go-low":
                Image("penguin")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            case "go-high":
                Image("penguin")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            default:
                Text("Status not recognized")
            }
        }
        .padding()
        .onAppear {
            print("Initial status: \(String(describing: tideService.status))")
        }
    }
}

//struct MainVisual_Previews: PreviewProvider {
//    static var previews: some View {
//        MainVisual(status: "high")  // Preview with any status
//    }
//}
