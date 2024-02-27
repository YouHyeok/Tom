//
//  ContentView.swift
//  Tom
//
//  Created by 김종혁 on 2023/10/08.
//


import Foundation
import SwiftUI
import Alamofire

struct ContentView: View {
    var body: some View {
        ZStack {
            TabView {
                MainView()
                    .tabItem {
                        Label("Main", systemImage: "desktopcomputer")
                    }
                
                ScheduleView()
                    .tabItem {
                        Label("Schedule", systemImage: "desktopcomputer")
                    }
                
                ScheduleListView()
                    .tabItem {
                        Label("Schedule List", systemImage: "desktopcomputer")
                    }
                
                DeployView()
                    .tabItem {
                        Label("Deploy", systemImage: "desktopcomputer")
                    }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
