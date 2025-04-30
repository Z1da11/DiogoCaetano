global class CountrySyncBatch implements Database.Batchable<SObject>, Database.AllowsCallouts {
    
    global Iterable<SObject> start(Database.BatchableContext BC) {
        return new List<SObject> { new Country__c() };
    }

    global void execute(Database.BatchableContext BC, List<SObject> scope) {
        Http http = new Http();
        HttpRequest request = new HttpRequest();        
        request.setEndpoint('callout:CountryLabel');         
        request.setMethod('GET');
    
        HttpResponse response = http.send(request);
    
        if (response.getStatusCode() == 200) {
        
            System.debug('Funcionou');
            System.debug(response.getBody());
            List<Object> countries = (List<Object>) JSON.deserializeUntyped(response.getBody());
            List<Country__c> countriesToUpsert = new List<Country__c>();
        
            for(Object countryObj : countries){
                Map<String, Object> country = (Map<String, Object>) countryObj;
                Country__c c = new Country__c();
                c.Name = (String) country.get('name');
                c.Alpha2Code__c = (String) country.get('alpha2Code');
                c.Alpha3Code__c = (String) country.get('alpha3Code');
                c.Capital__c = (String) country.get('capital');
                c.Region__c = (String) country.get('region');
                        
                countriesToUpsert.add(c);
            }
            upsert countriesToUpsert Country__c.Name;
    	}
    }
    global void finish(Database.BatchableContext BC) {}
}