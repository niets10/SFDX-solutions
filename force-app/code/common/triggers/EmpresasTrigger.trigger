trigger EmpresasTrigger on Empresas__c (before update, after update) {
    
    if(trigger.isUpdate && trigger.isAfter){
        UpdateSeguro.updateChild(Trigger.new);
    }
    
}