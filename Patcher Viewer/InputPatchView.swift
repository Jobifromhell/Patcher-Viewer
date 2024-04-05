import SwiftUI

struct InputPatchView: View {
    @Binding var project: Project?
    @State private var selectedPatch: AudioPatch?
    @State private var isShowingDetails = false
    @State private var selectedIndex: Int? = nil

    var body: some View {
        GeometryReader { geometry in
            VStack {
                // En-têtes de colonne fixés au sommet
                headerView
                    .frame(width: geometry.size.width)
                    .background(Color(UIColor.systemBackground)) // Utilisez .systemBackground pour respecter le thème clair/sombre
                
                // Contenu défilable sous les en-têtes
                ScrollView {
                    LazyVStack {
                        ForEach(project?.audioPatches ?? [], id: \.id) { patch in
                            HStack {
                                // Affichage de la ligne de patch
                                Text("\(patch.patchNumber)")
                                    .padding(5)
                                    .background(colorForGroup(patch.group))
                                    .frame(width: 45)
                                    .font(.system(size: 12, weight: .bold))
                                    .foregroundColor(.white)
                                    .cornerRadius(15)
                                    .onTapGesture {
                                        self.selectedPatch = patch
                                        self.isShowingDetails = true
                                    }
                                
                                // Affichage des autres informations du patch
                                Text(patch.source)
                                    .frame(width: 100)
                                    .font(.system(size: 14))
                                Text(patch.micDI)
                                    .font(.system(size: 14))
                                    .frame(width: 80)
                                Text(patch.stand)
                                    .font(.system(size: 14))
                                    .frame(width: 80)
                            }
                            .contentShape(Rectangle())
                            
                            // Affichage de l'annotation sous la ligne de patch
                            if let annotation = patch.annotation, !annotation.isEmpty {
                                Text(annotation)
                                    .font(.caption2)
                                    .italic()
                                    .foregroundColor(.gray)
                                    .padding(.bottom, 10) // Pour décaler l'annotation par rapport aux autres informations du patch
                            }
                            
                            Divider() // Pour séparer chaque patch
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .sheet(isPresented: $isShowingDetails) {
            // Trouvez l'index du patch sélectionné dans la liste des audio patches.
            if let index = project?.audioPatches.firstIndex(where: { $0.id == selectedPatch?.id }) {
                // Créez un Binding<String> pour l'annotation du patch sélectionné.
                let annotationBinding = Binding<String>(
                    get: { self.project?.audioPatches[index].annotation ?? "" },
                    set: { newValue in
                        print("Annotation changed: \(newValue)")
                        self.project?.audioPatches[index].annotation = newValue
                        saveAnnotations() // Appel de la sauvegarde après chaque modification d'annotation
                    }
                )
                
                PatchAnnotationView(annotation: annotationBinding, onClose: {
                    self.isShowingDetails = false
                }, saveAnnotations: saveAnnotations) // Passez la fonction saveAnnotations() ici

            }
            
        }

    }
    
    var headerView: some View {
        HStack {
            Text("#").frame(width: 25, alignment: .leading)
            Text("Source").frame(width: 100, alignment: .leading)
            Text("Mic/DI").frame(width: 80, alignment: .leading)
            Text("Stand").frame(width: 80, alignment: .leading)
        }
        .padding(.horizontal)
    }
    
    // Fonction de sauvegarde des annotations
  
    func saveAnnotations() {
        if let encoded = try? JSONEncoder().encode(project) {
            UserDefaults.standard.set(encoded, forKey: "SavedProject")
            print("Annotations saved successfully")
        }
    }
    
    
    // Fonction pour attribuer une couleur en fonction du groupe
    func colorForGroup(_ group: String?) -> Color {
        guard let group = group, let firstLetter = group.first else {
            return .white // Couleur par défaut si le groupe est nil ou vide
        }
        
        switch firstLetter {
        case "A": return .brown
        case "B": return .red
        case "C": return .orange
        case "D": return .yellow
        case "E": return .green
        case "F": return .blue
        case "G": return .purple
        case "H": return .gray
        case "I": return
                .gray
                .opacity(0.4)
            
        default: return .pink // Couleur par défaut pour tout autre caractère non alphabétique
        }
    }
}


struct PatchAnnotationView: View {
    @Binding var annotation: String
    let onClose: () -> Void
    let saveAnnotations: () -> Void // Ajoutez ce paramètre pour passer la fonction saveAnnotations()

    var body: some View {
        VStack {
            Text("Edit Annotation").font(.title)
            TextField("Annotation", text: $annotation)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Button("Done") {
                onClose()
                saveAnnotations() // Appel de la fonction saveAnnotations() lors de la fermeture de la vue
            }
        }
        .padding()
    }
}


extension Optional where Wrapped == String {
    var bound: String {
        get { self ?? "" }
        set { self = newValue }
    }
}

extension Binding {
    func unwrap<Wrapped>() -> Binding<Wrapped>? where Value == Wrapped? {
        guard let _ = self.wrappedValue else { return nil }
        return Binding<Wrapped>(
            get: { self.wrappedValue! },
            set: { self.wrappedValue = $0 }
        )
    }
}
