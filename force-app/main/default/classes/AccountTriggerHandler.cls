public with sharing class AccountTriggerHandler {
    
    public static void beforeInsert(List<Account> newAccounts){
    
            for(Account a : newAccounts){
            //default the Type field to Prospect if not populated
            a.Type = String.isBlank(a.Type) ? 'Prospect' : a.Type;

            //map BillingAddress fields to ShippingAddress fields
            a.BillingStreet = String.isBlank(a.BillingStreet) ? a.ShippingStreet : a.BillingStreet;
            a.BillingCity =String.isBlank( a.BillingCity) ? a.ShippingCity : a.BillingCity;
            a.BillingState = String.isBlank(a.BillingState) ? a.ShippingState : a.BillingState;
            a.BillingPostalCode = String.isBlank(a.BillingPostalCode) ? a.ShippingPostalCode : a.BillingPostalCode;
            a.BillingCountry = String.isBlank(a.BillingCountry) ? a.ShippingCountry : a.BillingCountry;
            
            //Set rating to Hot if related fields are populated
            Boolean ratingHotFields = a.Phone != '' && a.Website != '' && a.Fax != '';
            
            a.rating = ratingHotFields ? 'Hot' : a.rating;
            }
        }
    public static void afterInsert(List<Account> newAcc){
        List<Contact> defaultContact = new List<Contact>();

        for(Account a : newAcc){
                defaultContact.add(
                new Contact(
                    LastName = 'DefaultContact',
                    Email = 'default@email.com',
                    AccountId = a.Id
                )
            );
        }
        try{
            insert defaultContact;
        } catch (Exception e){
            System.debug('Unable to insert the default contact record ' + e.getMessage());        
        }
    }
}