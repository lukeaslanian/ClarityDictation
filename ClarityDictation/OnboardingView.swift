import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    private let pages = [
        OnboardingPage(imageName: "welcome", title: "Welcome", description: "Welcome to Clarity Dictation!"),
        OnboardingPage(imageName: "permissions", title: "Permissions", description: "Please grant the necessary permissions."),
        OnboardingPage(imageName: "api_key", title: "API Key", description: "Enter your API key to get started.")
    ]

    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                ForEach(pages.indices, id: \.self) { index in
                    OnboardingPageView(page: pages[index])
                        .tag(index)
                }
            }
            #if os(iOS)
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
            #endif

            HStack {
                if currentPage > 0 {
                    Button(action: {
                        withAnimation {
                            currentPage -= 1
                        }
                    }) {
                        Text("Back")
                    }
                }

                Spacer()

                if currentPage < pages.count - 1 {
                    Button(action: {
                        withAnimation {
                            currentPage += 1
                        }
                    }) {
                        Text("Next")
                    }
                } else {
                    Button(action: {
                        // Handle finish action
                    }) {
                        Text("Finish")
                    }
                }
            }
            .padding()
        }
    }
}

struct OnboardingPage {
    let imageName: String
    let title: String
    let description: String
}

struct OnboardingPageView: View {
    let page: OnboardingPage

    var body: some View {
        VStack {
            Image(page.imageName)
                .resizable()
                .scaledToFit()
                .frame(height: 200)
            Text(page.title)
                .font(.largeTitle)
                .padding(.top, 20)
            Text(page.description)
                .font(.body)
                .padding(.top, 10)
                .multilineTextAlignment(.center)
        }
        .padding()
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView()
    }
}
