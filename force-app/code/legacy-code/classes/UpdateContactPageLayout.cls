public class UpdateContactPageLayout {
    
    public Metadata.Layout addLayoutItem(){
        
        List<Metadata.Metadata> layoutsList = Metadata.Operations.retrieve(Metadata.MetadataType.Layout, new List<String> {'Contact-Contact Layout'});
        
        Metadata.Layout layoutMetadata = (Metadata.Layout) layoutsList.get(0);
        
        System.debug('Layout Metadata ' + layoutMetadata);
        
        Metadata.LayoutSection contactLayoutSection = null;
        
        List<Metadata.LayoutSection> layoutSections = layoutMetadata.layoutSections;
        
        for(Metadata.LayoutSection layoutSection : layoutSections){
            
            if(layoutSection.label == 'Additional Information'){
                contactLayoutSection = layoutSection;
                break;
            }            
        }
        
        System.debug('Layout Section ' + contactLayoutSection);
        
        List<Metadata.LayoutColumn> contactColumns  = contactLayoutSection.layoutColumns;
        System.debug('Layout Column ' + contactColumns.get(0));
        List<Metadata.LayoutItem> contactLayoutItems  = contactColumns.get(0).layoutItems;
        System.debug('Layout Item ' + contactLayoutItems);
        
        Metadata.LayoutItem newField  = new Metadata.LayoutItem();
        newField.behavior = Metadata.UiBehavior.Edit;
        newField.field = 'Hobbies__c';
        contactLayoutItems.add(newField);
        
        return layoutMetadata;
    }

}