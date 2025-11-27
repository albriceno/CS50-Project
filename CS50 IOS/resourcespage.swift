//
//  resourcespage.swift
//  CS50
//
//  Created by Alejandra Briceno on 11/26/25.
//

import Foundation
import SwiftUI

struct ResourcesView: View {
    var body: some View {
        List {
            Section("Know Your Rights") {
                NavigationLink("Constitutional Rights") {
                    Text("Under the 4th and 5th Amendments of the US Constitution you have the right to remain silent, to refuse to sign documents without first speaking to a lawyer, and to deny permission for an office to enter your home")
                        .padding()
                        .navigationTitle("Know Your Rights")
                }
                NavigationLink("Derechos Constitucionales") {
                    Text("NO ABRA LA PUERTA si un agente de inmigración está tocando.NO CONTESTE NINGUNA PREGUNTA de un agente de inmigración si trata de hablar con usted. Usted tiene el derecho a guardar silencio.NO FIRME NADA sin antes hablar con un abogado. Usted tiene el derecho de hablar con un abogado. Si usted está fuera de su casa, pregúntele al agente si tiene la libertad de irse y si le dice que sí, váyase con tranquilidad.")
                        .padding()
                        .navigationTitle("Derechos Constitucionales")
                }
            }

            Section("Boston/Cambidge Community Organizations") {
                NavigationLink("Massachusetts Immigrant & Refugee Advocacy Coalition (MIRA) ") {
                    Text("Phone Number: 617-350-5480")
                        .padding()
                        .navigationTitle("Boston/Cambidge Community Organizations")
                }
                NavigationLink("Commission on Immigrant Rights & Citizenship (CIRC)") {
                    Text("Phone Number: 617-349-4396")
                        .padding()
                        .navigationTitle("Commission on Immigrant Rights & Citizenship (CIRC)")
                }
                NavigationLink("Inquilinos Boricuas en Acción") {
                    Text("Phone Number: 617 927-1707")
                        .padding()
                        .navigationTitle("Inquilinos Boricuas en Acción")
                }
                NavigationLink("Center to Support Immigrant Organizing") {
                    Text("Phone Number: 617 742-5165")
                        .padding()
                        .navigationTitle("Center to Support Immigrant Organizing")
                }
                
            }

            Section("Legal Services") {
                NavigationLink("Greater Boston Legal Services - Immigration Unit") {
                    Text("Phone Number: 617 371-1234")
                        .padding()
                        .navigationTitle("Legal Services")
                }
            }
        }
        .navigationTitle("Resources To Support You")
    }
}

#Preview {
    NavigationStack {
        ResourcesView()
    }
}

