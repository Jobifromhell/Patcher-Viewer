
struct AudioPatch: Codable, Identifiable {
    let id: UUID
    var location: String
    let patchNumber: Int
    var source: String
    var micDI: String
    var stand: String
    var phantom: Bool
    var group: String?
    var annotation: String?
}

struct OutputPatch: Codable, Identifiable/*, Hashable*/ {
    let id: UUID
    let patchNumber: Int
    var busType: String
    var destination: String
    var monitorType: String
    var isStereo: Bool
//    var group: String
    var annotation: String? 
}

struct StageElement: Identifiable, Codable {
    var id: UUID
    var isSelected: Bool
    var zIndex: Int
    var type: String
    var name: String
    var rotation: Double
    var patch: String
    var positionXPercent: Double
    var positionYPercent: Double
}

struct Project: Codable {
    let projectName: String
    var audioPatches: [AudioPatch]
    var outputPatches: [OutputPatch]
    let stageElements: [StageElement]
}


import SwiftUI

struct MainTabView: View {
    @State private var selectedProject: Project? = nil
    @State private var isImporting: Bool = false
    @State private var categorySelections: [ElementType: Bool] = [.riser2x1: true, .source: true, .musician: true]

    var body: some View {
        TabView {
            ProjectManagerView(selectedProject: $selectedProject, isImporting: $isImporting)
                .tabItem {
                    Label("Home", systemImage: "folder")
                }
            
            if let project = selectedProject {
                InputPatchView(project: $selectedProject)
                    .tabItem {
                        Label("Input Patch", systemImage: "waveform.path.ecg")
                    }
                
                OutputPatchView(project: $selectedProject)
                    .tabItem {
                        Label("Output Patch", systemImage: "arrow.up")
                    }
                
//                StagePlotView(project: project, categorySelections: $categorySelections)
//                    .tabItem {
//                        Label("StagePlot", systemImage: "person.3.sequence")
//                    }
            }
        }
        .onAppear {
//            loadProjectData()
        }
    }
    
    
    func load<T: Decodable>(_ filename: String, as type: T.Type = T.self) -> T {
        let data: Data
        
        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
        }
        
        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    }
    
    //            else {
    //                Text("Please select a project")
    //                    .tabItem {
    //                        Label("Select Project", systemImage: "exclamationmark.triangle")
    //                    }
    //            }
}


struct MainTabView_Previews: PreviewProvider {
    static var previews: some View {
        MainTabView()
    }
}
