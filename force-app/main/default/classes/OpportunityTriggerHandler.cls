public with sharing class OpportunityTriggerHandler {
    
    public static void beforeUpdate(List<Opportunity> newOpps){
        String tooLowAmountError = 'Opportunity amount must be greater than 5000';
        Set<Id> getAccountIds = new Set<Id>();


        
        for(Opportunity o : newOpps){
            if (o.Amount < 5000 && o.Amount != null) o.addError(tooLowAmountError);
            getAccountIds.add(o.AccountId);
        }

        if(!getAccountIds.isEmpty()){
            List<Contact> getCEOContacts = [SELECT Id, AccountId FROM Contact WHERE AccountId IN :getAccountIds AND Title = 
                                            'CEO'];

            Map<Id,Id> accCEO = new Map<Id,Id>();

            for(Contact c : getCEOContacts){
                accCEO.put(c.AccountId, c.Id);
            }

            for(Opportunity ceoOpps: newOpps){
                ceoOpps.Primary_Contact__c = accCEO.get(ceoOpps.AccountId);    
            }
        }
            
    }

    public static void beforeDelete(List<Opportunity> toBeDelOpps){
        String preventDelForWonBankOpp = 'Cannot delete closed opportunity for a banking account that is won';
        Map<Id, Account> getBankingAccs = new Map<Id, Account>([SELECT Id, Industry FROM Account WHERE Industry =
                                                'Banking']);

        for(Opportunity opp : toBeDelOpps){
            if(getBankingAccs.containsKey(opp.AccountId) && opp.StageName == 'Closed Won'){
                opp.addError(preventDelForWonBankOpp);
            } 
        }
    }


}