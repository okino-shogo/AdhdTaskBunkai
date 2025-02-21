//
//  ContentView.swift
//  AdhdTaskBunkai
//
//  Created by 沖野匠吾 on 2025/02/17.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var taskViewModel = TaskViewModel()
    @StateObject private var donationViewModel = DonationViewModel()
    
    var body: some View {
        TabView {
            NavigationView {
                TimelineView()
            }
            .tabItem {
                Label("タイムライン", systemImage: "clock")
            }
            
            NavigationView {
                TaskListView()
            }
            .tabItem {
                Label("タスク", systemImage: "checklist")
            }
            
            NavigationView {
                DonationHistoryView()
            }
            .tabItem {
                Label("寄付履歴", systemImage: "heart.fill")
            }
            
            NavigationView {
                SettingsView()
            }
            .tabItem {
                Label("設定", systemImage: "gear")
            }
        }
        .environmentObject(taskViewModel)
        .environmentObject(donationViewModel)
    }
}

struct SettingsView: View {
    var body: some View {
        List {
            Section(header: Text("アプリ設定")) {
                NavigationLink(destination: Text("通知設定")) {
                    Label("通知", systemImage: "bell")
                }
                
                NavigationLink(destination: Text("テーマ設定")) {
                    Label("テーマ", systemImage: "paintbrush")
                }
                
                NavigationLink(destination: Text("言語設定")) {
                    Label("言語", systemImage: "globe")
                }
            }
            
            Section(header: Text("その他")) {
                NavigationLink(destination: Text("プライバシーポリシー")) {
                    Label("プライバシーポリシー", systemImage: "lock.shield")
                }
                
                NavigationLink(destination: Text("利用規約")) {
                    Label("利用規約", systemImage: "doc.text")
                }
                
                NavigationLink(destination: Text("アプリについて")) {
                    Label("アプリについて", systemImage: "info.circle")
                }
            }
        }
        .navigationTitle("設定")
    }
}

#Preview {
    ContentView()
}
