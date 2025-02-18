import SwiftUI

struct NoInternetView: View {
    let retryAction: () -> Void

    var body: some View {
        VStack {
            Image(systemName: "wifi.exclamationmark")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(.orange)
                .padding()
            
            Text("No Internet Connection")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.bottom, 10)
            
            Text("Please connect to the internet to use this app.")
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
            
            Button(action: retryAction) {
                Text("Try Again")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .padding(.horizontal, 40)
            }
            .padding(.top, 20)
        }
    }
}
