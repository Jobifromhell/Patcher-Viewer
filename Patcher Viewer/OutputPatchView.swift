import SwiftUI

struct OutputPatchView: View {
    @Binding var project: Project?
    @State private var selectedPatch: OutputPatch?
    @State private var isShowingDetails = false

    var body: some View {
        GeometryReader { geometry in
            VStack {
                headerView
                    .frame(width: geometry.size.width)
                    .background(Color(UIColor.systemBackground))
                
                ScrollView {
                    LazyVStack {
                        ForEach(project?.outputPatches ?? [], id: \.id) { patch in
                            HStack {
                                if let annotation = patch.annotation, !annotation.isEmpty {
                                    Text(annotation)
                                        .italic()
                                        .foregroundColor(.gray)
                                        .padding(.trailing, 5)
//                                        .frame(width: 50)
                                }
                                Text("\(patch.patchNumber)")
                                    .frame(width: 25, alignment: .leading)
                                    .font(.system(size: 14, weight: .bold))
                                Text(patch.destination)
                                    .frame(width: 110, alignment: .leading)
                                    .font(.system(size: 14))
                                Text(patch.monitorType)
                                    .frame(width: 100, alignment: .leading)
                                    .font(.system(size: 14))
                                Text(patch.busType)
                                    .frame(width: 80, alignment: .leading)
                                    .font(.system(size: 14))
                            }
                            .padding(4)
                            .background(patch.isStereo ? Color.blue.opacity(0.2) : Color.clear) // Encadrement bleu pour les sorties stéréo
                            .cornerRadius(5)
//                            .overlay(
//                                RoundedRectangle(cornerRadius: 5)
//                                    .stroke(patch.isStereo ? Color.blue : Color.clear, lineWidth: 2) // Ajoute un bord pour les sorties stéréo
//                            )
                            Divider()
                        }
                    }
                    .padding(.horizontal)
                }
            }
        }
        .sheet(isPresented: $isShowingDetails) {
            // Trouvez l'index du patch sélectionné dans la liste des audio patches.
            if let index = project?.outputPatches.firstIndex(where: { $0.id == selectedPatch?.id }) {
                // Créez un Binding<String> pour l'annotation du patch sélectionné.
                let annotationBinding = Binding<String>(
                    get: { self.project?.outputPatches[index].annotation ?? "" },
                    set: { self.project?.outputPatches[index].annotation = $0 }
                )
                
                PatchAnnotationView(annotation: annotationBinding, onClose: {
                    self.isShowingDetails = false
                })
            }
        }
    }

    var headerView: some View {
        HStack {
            Text("#").frame(width: 25, alignment: .leading)
            Text("Destination").frame(width: 100, alignment: .leading)
            Text("Monitor Type").frame(width: 80, alignment: .leading)
            Text("Bus Type").frame(width: 80, alignment: .leading)
        }
        .padding(.horizontal)
    }
}

