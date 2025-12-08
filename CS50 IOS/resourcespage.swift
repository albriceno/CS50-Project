//
//  resourcespage.swift
//  CS50
//
//  Created by Alejandra Briceno on 11/26/25.
//

import Foundation
import SwiftUI

//creation of a suite where the app can speciically save the preference (language choice based on toggle)
extension UserDefaults {
    static let resourcesPreviewSuite: UserDefaults = {
        let suiteName = "ResourcesViewPreviewSuite"
        return UserDefaults(suiteName: suiteName) ?? .standard
    }()
}

//actual declaration of the ResourcesView page in the app that integrates the suite just created with a newly created property that defaults to english, until the toggle is "toggle'd"
struct ResourcesView: View {
    @AppStorage("resourcesLanguage", store: UserDefaults.resourcesPreviewSuite) private var resourcesLanguageCode: String = "en"
    
    // here the "enumeration" or "enum" type is created and given two cases; english and spanish, this type deals with differentiation between the English and Spanish strings
    private enum ResourcesLanguage { case english, spanish }
    
    // stores the hard-coded text as English or Spanish and assigns "es" to the Spanish translations as an indicator that is later used in a bool function and assigns "en" to the English translations for the same purpose
    private var language: ResourcesLanguage { resourcesLanguageCode == "es" ? .spanish : .english }
    
    // based off the bool function defined above, this piece codes the actual button onto the user interface
    private var spanishBinding: Binding<Bool> {
        Binding(
            get: { resourcesLanguageCode == "es" },
            set: { isSpanish in resourcesLanguageCode = isSpanish ? "es" : "en" }
        )
    }
    // this next piece codes the actual toggle switch that displays "EN" when the english translations are displayed on the screen on the Resources Page and displays "ES" when the Spanish translations are displayed on the screen
    private var languageToggleButton: some View {
        Button(language == .english ? "ES" : "EN") {
            resourcesLanguageCode = (resourcesLanguageCode == "en") ? "es" : "en"
        }
        .accessibilityLabel(language == .english ? "Switch to Spanish" : "Cambiar a inglés")
    }
    
    //this initial line defines the entire list on the resources page
    var body: some View {
        List {
            // this section is for the "Know Your Rights" portion of the resources page
            // this section features hard-coded English and Spanish translations seperated by a colon (which is a feature reiterated throughout the rest of the page
            Section(language == .english ? "Know Your Rights" : "Conozca Sus Derechos") {
                //each of these "NavigationLink" pieces creates a tab-like structure on the page that can be clicked on to redirect the user to the text hard-coded for each section
                NavigationLink(language == .english ? "Constitutional Rights" : "Derechos Constitucionales") {
                    ScrollView {
                        // here's the hard-coded English and Spanish translations
                        Text(language == .english
                             ? "Under the 4th and 5th Amendments of the US Constitution you have the right to remain silent, to refuse to sign documents without first speaking to a lawyer, and to deny permission for an office to enter your home"
                             : "NO ABRA LA PUERTA si un agente de inmigración está tocando.NO CONTESTE NINGUNA PREGUNTA de un agente de inmigración si trata de hablar con usted. Usted tiene el derecho a guardar silencio.NO FIRME NADA sin antes hablar con un abogado. Usted tiene el derecho de hablar con un abogado. Si usted está fuera de su casa, pregúntele al agente si tiene la libertad de irse y si le dice que sí, váyase con tranquilidad.")
                        //these lines below deal with the style of the resources page including rounded corners for each NavigationLink (for a more polished look) and a nice gray background color to make a more cohesive page
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                        .padding()
                    }
                }
            }

            // this section is for the "Community Organizations" portion of the resources page
            Section(language == .english ? "Boston/Cambridge Community Organizations" : "Organizaciones Comunitarias de Boston/Cambridge") {

                NavigationLink("Massachusetts Immigrant & Refugee Advocacy Coalition (MIRA) ") {
                    // here's the hard-coded English and Spanish translations
                    Text(language == .english ? "Phone Number: 617-350-5480" : "Número de teléfono: 617-350-5480")
                        .padding()
                    //these lines below deal with the style of the resources page including rounded corners for each NavigationLink (for a more polished look) and a nice gray background color to make a more cohesive page, they also feature a proportional translation of the cornerRadius and shadow radius to better style the actual text inside each section
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                        .background(Color(.systemGray6))
                        .padding(.horizontal)
                }

                NavigationLink("Commission on Immigrant Rights & Citizenship (CIRC)") {
                    // here's the hard-coded English and Spanish translations
                    Text(language == .english ? "Phone Number: 617-349-4396" : "Número de teléfono: 617-349-4396")
                        .padding()
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                        .background(Color(.systemGray6))
                        .padding(.horizontal)
                }

                NavigationLink(language == .english ? "Inquilinos Boricuas en Acción" : "Inquilinos Boricuas en Acción") {
                    // here's the hard-coded English and Spanish translations
                    Text(language == .english ? "Phone Number: 617 927-1707" : "Número de teléfono: 617 927-1707")
                        .padding()
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                        .background(Color(.systemGray6))
                        .padding(.horizontal)
                }

                NavigationLink(language == .english ? "Center to Support Immigrant Organizing" : "Centro de Apoyo a la Organización de Inmigrantes") {
                    // here's the hard-coded English and Spanish translations
                    Text(language == .english ? "Phone Number: 617 742-5165" : "Número de teléfono: 617 742-5165")
                        .padding()
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                        .background(Color(.systemGray6))
                        .padding(.horizontal)
                }
            }

            // this section is for the "Legal Services" portion of the resources page
            Section(language == .english ? "Legal Services" : "Servicios Legales") {
                NavigationLink(language == .english ? "Greater Boston Legal Services - Immigration Unit" : "Greater Boston Legal Services - Unidad de Inmigración") {
                    // here's the hard-coded English and Spanish translations
                    Text(language == .english ? "Phone Number: 617 371-1234" : "Número de teléfono: 617 371-1234")
                        .padding()
                        //these lines below deal with the style of the resources page including rounded corners for each NavigationLink (for a more polished look) and a nice gray background color to make a more cohesive page, they also feature a proportional translation of the cornerRadius and shadow radius to better style the actual text inside each section
                        .multilineTextAlignment(.leading)
                        .lineLimit(nil)
                        .background(Color(.systemGray6))
                }
            }
        }
        // the tile of the navigation bar is set as "Resources to Support You" and the boolean idea is preserved here with the colon seperating the English and Spanish translations
        // the boolean expression basically functions like "if the English option is selected choose the translation before the colon, otherwise choose the translation after the colon"
        .navigationTitle(language == .english ? "Resources To Support You" : "Recursos para Apoyarte")
        .toolbar {
            //the toolbar is placed at the top and trailing
            ToolbarItem(placement: .topBarTrailing) {
                Toggle(isOn: spanishBinding) {
                    //the toggle should display "Espanol", instead of just "Spanish" when the Spanish mode is enabled
                    Text(language == .english ? "English" : "Español")
                }
                .toggleStyle(.switch)
                //this is another stylistic change for a translation of the actual "Toggle Spanish" text displayed on the button to increase accesibility
                .accessibilityLabel(language == .english ? "Toggle Spanish" : "Activar Español")
            }
        }
    }
}
