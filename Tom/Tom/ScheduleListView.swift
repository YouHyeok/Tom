//
//  ScheduleListView.swift
//  Tom
//
//  Created by 김종혁 on 2/27/24.
//

import SwiftUI

struct ScheduleListView: View {
    @ObservedObject var jun: Networking = Networking()
    @ObservedObject var jong: Networking = Networking()
    
    @State var selectedUser = false
    @State var showDetails = true
    @State var transition = false
    @State var alertShowing = false
    
    init() {
        jun.getCategories(url: "http://221.159.102.58:8000/api/get/categories", query: ["user": "Jun"], completion: { (categories) in
            
        })
        
        jun.getScheduledTasks(url: "http://221.159.102.58:8000/api/get/scheduled_tasks", query: ["user": "Jun"], completion: { (scheduled_tasks) in
            
        })
        
        jong.getCategories(url: "http://221.159.102.58:8000/api/get/categories", query: ["user": "Jong"], completion: { (categories) in
            
        })
        
        jong.getScheduledTasks(url: "http://221.159.102.58:8000/api/get/scheduled_tasks", query: ["user": "Jong"], completion: { (scheduled_tasks) in
            
        })
    }
    
    var body: some View {
        ZStack {
            VStack {
                HStack {
                    Spacer()
                    
                    Button(action: {
                        if selectedUser == false {
                            jun.getCategories(url: "http://221.159.102.58:8000/api/get/categories", query: ["user": "Jun"], completion: { (categories) in
                                
                            })
                            
                            jun.getScheduledTasks(url: "http://221.159.102.58:8000/api/get/scheduled_tasks", query: ["user": "Jun"], completion: { (scheduled_tasks) in
                                
                            })
                        } else {
                            jong.getCategories(url: "http://221.159.102.58:8000/api/get/categories", query: ["user": "Jong"], completion: { (categories) in
                                
                            })
                            
                            jong.getScheduledTasks(url: "http://221.159.102.58:8000/api/get/scheduled_tasks", query: ["user": "Jong"], completion: { (scheduled_tasks) in
                                
                            })
                        }
                    }, label: {
                        if selectedUser == false {
                            Image(systemName:"arrow.clockwise")
                                .resizable()
                                .frame(width: 35.0, height: 40.0)
                                .foregroundColor(.accentColor)
                                .padding(5)
                        } else {
                            Image(systemName:"arrow.clockwise")
                                .resizable()
                                .frame(width: 35.0, height: 40.0)
                                .foregroundColor(.accentColor)
                                .padding(5)
                                .colorInvert()
                        }
                    })
                }.padding(15.0)
                
                Spacer()
            }
            VStack {
                Button(action: { if selectedUser == false {
                    selectedUser = true
                    showDetails = false
                    
                    transition = true
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                        transition = false
                    }
                } else {
                    selectedUser = false
                    showDetails = true
                    
                    transition = true
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.5) {
                        transition = false
                    }
                }}, label: {
                    if selectedUser == false {
                        Image("yh")
                            .imageScale(.large)
                            .foregroundColor(.accentColor)
                            .frame(height: 125)
                            .padding(.top, 100)
                    } else {
                        Image("yh")
                            .imageScale(.large)
                            .foregroundColor(.accentColor)
                            .colorInvert()
                            .frame(height: 125)
                            .padding(.top, 100)
                    }
                }
                )
                .disabled(transition)
                
                if showDetails {
                    VStack {
                        List(jun.lscheduledTasks) {
                            if (!String(jun.ltimes[$0.scheduled_time!]).contains("Descheduling")) {
                                Text(String($0.task!) + " " + String(jun.ltimes[$0.scheduled_time!]))
                                    .background(Color.white)
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                    .padding(.top, 20)
                    
                } else {
                    VStack() {
                        List(jong.lscheduledTasks) {
                            if (!String(jong.ltimes[$0.scheduled_time!]).contains("Descheduling")) {
                                Text(String($0.task!) + " " + String(jong.ltimes[$0.scheduled_time!]))
                                    .background(Color.white)
                            }
                        }
                        .listStyle(PlainListStyle())
                    }
                    .padding(.top, 20)
                }
            }
        }
        .onAppear {
            DispatchQueue.main.async {
                jun.getCategories(url: "http://221.159.102.58:8000/api/get/categories", query: ["user": "Jun"], completion: { (categories) in
                    
                })
                
                jun.getScheduledTasks(url: "http://221.159.102.58:8000/api/get/scheduled_tasks", query: ["user": "Jun"], completion: { (scheduled_tasks) in
                    
                })
                
                jong.getCategories(url: "http://221.159.102.58:8000/api/get/categories", query: ["user": "Jong"], completion: { (categories) in
                    
                })
                
                jong.getScheduledTasks(url: "http://221.159.102.58:8000/api/get/scheduled_tasks", query: ["user": "Jong"], completion: { (scheduled_tasks) in
                    
                })
            }
        }
    }
        
}

struct ScheduleListView_Previews: PreviewProvider {
    static var previews: some View {
        let mockJun = Networking()
        let mockJong = Networking()

        mockJun.lscheduledTasks = [
            ScheduledTasks(user: "Jun", task: "Category1", scheduled_id: "1", scheduled_time: 0),
            ScheduledTasks(user: "Jun", task: "Category2", scheduled_id: "2", scheduled_time: 1),
            ScheduledTasks(user: "Jun", task: "Category3", scheduled_id: "2", scheduled_time: 2)
        ]
        mockJun.ltimes = ["10:00", "11:00", "Descheduling"]

        mockJong.lscheduledTasks = [
            ScheduledTasks(user: "Jong", task: "Category3", scheduled_id: "3", scheduled_time: 0),
            ScheduledTasks(user: "Jong", task: "Category4", scheduled_id: "4", scheduled_time: 1),
            ScheduledTasks(user: "Jong", task: "Category5", scheduled_id: "4", scheduled_time: 2)
        ]
        mockJong.ltimes = ["14:00", "15:00", "Descheduling"]
        
        var scheduleListView = ScheduleListView()
        
        scheduleListView.jun = mockJun
        scheduleListView.jong = mockJong

        return scheduleListView
    }
}
