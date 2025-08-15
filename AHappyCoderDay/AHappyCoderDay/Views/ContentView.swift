import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        NavigationSplitView {
            Text("侧边栏")
                .navigationTitle("AHappyCoderDay")
        } detail: {
            VStack {
                Image(systemName: "heart.fill")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("欢迎使用 AHappyCoderDay Todo List")
                    .font(.title2)
                Text("专为程序员设计的幸福日常规划工具")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            .padding()
        }
    }
}

#Preview {
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}