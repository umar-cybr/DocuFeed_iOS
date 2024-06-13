//
//  ContentView.swift
//  docufeed
//
//  Created by Umar Ahmed on 6/10/24.
//


import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image(systemName: "camera.fill")
                    .resizable()
                    .frame(width: 80, height: 70)
                    .scaledToFill()
                Text("Scan a document")
                    .font(.system(size: 28))
                    .bold()
                NavigationLink(destination: ViewControllerWrapper()) {
                    Text("Capture Document")
                        .font(.system(size: 20))
                        .bold()
                        .padding()
                }
            }
            .padding()
        }
    }
}

struct ViewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ViewController {
        return ViewController()
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        // Update the UI view controller if needed
    }
    
    typealias UIViewControllerType = ViewController
}

#Preview {
    ContentView()
}



/*
import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "camera.fill")
                .resizable()
                .frame(width: 80, height: 70)
                .foregroundStyle(.tint)
                .scaledToFill()
            Text("Scan a document")
                .font(.system(size: 28))
                .bold()
            NavigationLink(destination: ViewControllerWrapper()) {
                Text("Capture Document")
                    .font(.system(size: 20))
                    .bold()
                    .border(Color.black)
                    .padding()
            }
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

struct ViewControllerWrapper: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> ViewController {
        return ViewController()
    }
    
    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        // Update the UI view controller if needed
    }
    
    typealias UIViewControllerType = ViewController
}

#Preview {
    ContentView()
}

*/
