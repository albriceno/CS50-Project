//
//  resourcespage.swift
//  CS50
//
//  Created by Alejandra Briceno on 11/26/25.
//

import Foundation
import SwiftUI

extension UserDefaults {
    static let resourcesPreviewSuite: UserDefaults = {
        let suiteName = "ResourcesViewPreviewSuite"
        return UserDefaults(suiteName: suiteName) ?? .standard
    }()
}

struct ResourcesView: View {
    @AppStorage("resourcesLanguage", store: UserDefaults.resourcesPreviewSuite) private var resourcesLanguageCode: String = "en"
    
    private enum ResourcesLanguage { case english, spanish }
    
    private var language: ResourcesLanguage { resourcesLanguageCode == "es" ? .spanish : .english }
    
    private var languageToggleButton: some View {
        Button(language == .english ? "ES" : "EN") {
            resourcesLanguageCode = (resourcesLanguageCode == "en") ? "es" : "en"
        }
        .accessibilityLabel(language == .english ? "Switch to Spanish" : "Cambiar a inglés")
    }
    
    var body: some View {
        List {
            Section(language == .english ? "Know Your Rights" : "Conozca Sus Derechos") {
                NavigationLink(language == .english ? "Constitutional Rights" : "Derechos Constitucionales") {
                    ScrollView {
                        Text(language == .english
                             ? "Under the 4th and 5th Amendments of the US Constitution you have the right to remain silent, to refuse to sign documents without first speaking to a lawyer, and to deny permission for an office to enter your home"
                             : "NO ABRA LA PUERTA si un agente de inmigración está tocando.NO CONTESTE NINGUNA PREGUNTA de un agente de inmigración si trata de hablar con usted. Usted tiene el derecho a guardar silencio.NO FIRME NADA sin antes hablar con un abogado. Usted tiene el derecho de hablar con un abogado. Si usted está fuera de su casa, pregúntele al agente si tiene la libertad de irse y si le dice que sí, váyase con tranquilidad.")
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                        .padding()
                        .background(Color(.systemGray6))
                        .cornerRadius(12)
                        .shadow(radius: 4)
                        .padding(.horizontal)
                    }
                }
            }
            
            Section(language == .english ? "Boston/Cambridge Community Organizations" : "Organizaciones Comunitarias de Boston/Cambridge") {
                NavigationLink("Massachusetts Immigrant & Refugee Advocacy Coalition (MIRA) ") {
                    Text(language == .english ? "Phone Number: 617-350-5480" : "Número de teléfono: 617-350-5480")
                        .padding()
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .shadow(radius: 2)
                        .padding(.horizontal)
                }
                NavigationLink("Commission on Immigrant Rights & Citizenship (CIRC)") {
                    Text(language == .english ? "Phone Number: 617-349-4396" : "Número de teléfono: 617-349-4396")
                        .padding()
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .shadow(radius: 2)
                        .padding(.horizontal)
                }
                NavigationLink(language == .english ? "Inquilinos Boricuas en Acción" : "Inquilinos Boricuas en Acción") {
                    Text(language == .english ? "Phone Number: 617 927-1707" : "Número de teléfono: 617 927-1707")
                        .padding()
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .shadow(radius: 2)
                        .padding(.horizontal)
                }
                NavigationLink(language == .english ? "Center to Support Immigrant Organizing" : "Centro de Apoyo a la Organización de Inmigrantes") {
                    Text(language == .english ? "Phone Number: 617 742-5165" : "Número de teléfono: 617 742-5165")
                        .padding()
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .shadow(radius: 2)
                        .padding(.horizontal)
                }
            }
            
            Section(language == .english ? "Legal Services" : "Servicios Legales") {
                NavigationLink(language == .english ? "Greater Boston Legal Services - Immigration Unit" : "Greater Boston Legal Services - Unidad de Inmigración") {
                    Text(language == .english ? "Phone Number: 617 371-1234" : "Número de teléfono: 617 371-1234")
                        .padding()
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .shadow(radius: 2)
                        .padding(.horizontal)
                }
            }
        }
        .navigationTitle(language == .english ? "Resources To Support You" : "Recursos para Apoyarte")
    }
}
