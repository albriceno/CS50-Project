DESIGN - BACKEND








DESIGN - MAPKIT









DESIGN- UI
    The largest task for UI was the implementation of the Resources Page that is connected to the Navigation Bar in the app interface. The goals of the resource page was to put together contact information with various organizations in the Boston/Cambridge community that support immigrant communities through both community-building/community protection and legal services. We also wanted the page to be user-friendly and accesible while still providing ample resources and a "Know your Rights" page. The basic structure of the resources page is a list with different sections to keep the information organized with a more polished look than just a table. Each section is opened via a Naviagation Link and displays contact information for each resource. 
    
    To enhance accesibibility, we had the idea of piloting a language-switch feature through the resources page. This feature, in theory, would be a toggle switch on the resource page that could switch the text displayed on the page from English text to Spanish text. We settled on Spanish translations as we felt this langauge would specifically enhance the accesibility of the app. After thorough research, pre-built Apple API's and other instant translation features, we concluded that a live translation feature such as these would not be feasible to implement with the timeline/pre-existing goals we had for the project. We still felt it was important to incorporate this feature within at least the resource page so we settled on a different method. We hard-coded Spanish translations of the English text for the resource page specifically and then implemented a toggle button feature to swtich between translations instead of live, instantaneous translations. 
    
    Essentially, the button translation feature is built on a single "enumeration" or type that stores these hard-coded English and Spanish translations. Based on the toggle, the "enumeration" or "enum" can either be set to .english or .spanish. Although, this limits our project's look/functionality by not providing instantaneous translations, it is a stable method for making the app more accesible in its current stage. This feature was defintely the most difficult to implement, but is a great way to enhance accesibility, especially at this early stage of the project/while the app is still developing. 
