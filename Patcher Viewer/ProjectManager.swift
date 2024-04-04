import SwiftUI
import UniformTypeIdentifiers

struct ProjectManagerView: View {
    @Binding var selectedProject: Project?
    @Binding var isImporting: Bool
    @State private var showingInfoAlert = false
    @State private var loadingState = false
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            Image("PatcherViewer") // Utilisez le nom de votre asset
                .resizable() // Permet à l'image d'être redimensionnée
                .scaledToFit() // Garde les proportions de l'image
//                .frame(width: 300, height: 300) // Spécifiez la taille souhaitée
//                .opacity(0.8)
            
            Button("About this app") {
                showingInfoAlert = true
            }
                        .padding()
            .font(.callout)
            .alert(isPresented: $showingInfoAlert) {
                Alert(
                    title: Text("Welcome to Patcher Viewer!"),
                    message: Text("This app displays projects generated with PATCHER for macOS."),
                    dismissButton: .default(Text("OK"))
                )
            }
//            Button("Get PATCHER for MacOS") {
//                if let url = URL(string: "https://apps.apple.com/app/idVotreAppID") {
//                    UIApplication.shared.open(url)
//                }
//            }
//            //                       .padding()
//            .font(.callout)
            
            Link("Learn more about PATCHER Ecosystem", destination: URL(string: "https://patools.wixsite.com/patoolsapp")!)
            //                          .padding()
                .font(.callout)
            
            
            Button("IMPORT PROJECT") {
                isImporting = true
            }
            .font(.largeTitle)
            .contrast(10)
            .padding(50)
            .fileImporter(
                isPresented: $isImporting,
                allowedContentTypes: [UTType.json],
                allowsMultipleSelection: false
            ) { result in
                switch result {
                case .success(let urls):
                    let url = urls.first!
                    // Ensure the URL is not accessed outside of the Security Scoped Block
                    _ = url.startAccessingSecurityScopedResource()
                    defer { url.stopAccessingSecurityScopedResource() }
                    loadProject(from: url)
                case .failure(let error):
                    // Handle the error here
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
    
    private func handleImportResult(_ result: Result<[URL], Error>) {
        switch result {
        case .success(let urls):
            guard let url = urls.first else { return }
            loadProject(from: url)
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
    
    private func loadProject(from url: URL) {
         loadingState = true
         DispatchQueue.global(qos: .userInitiated).async {
             do {
                 let jsonData = try Data(contentsOf: url)
                 var loadedProject = try JSONDecoder().decode(Project.self, from: jsonData)
                 
                 // Load annotations if they exist
                 loadAnnotations(for: &loadedProject)
                 
                 DispatchQueue.main.async {
                     self.selectedProject = loadedProject
                     self.loadingState = false
                 }
             } catch {
                 DispatchQueue.main.async {
                     self.errorMessage = "Failed to load project: \(error.localizedDescription)"
                     self.loadingState = false
                 }
             }
         }
     }

    private func loadAnnotations(for project: inout Project) {
        for index in project.audioPatches.indices {
            let patchId = project.audioPatches[index].id
            if let savedAnnotation = UserDefaults.standard.string(forKey: "annotation_\(patchId.uuidString)") {
                project.audioPatches[index].annotation = savedAnnotation
            }
        }
    }

}


