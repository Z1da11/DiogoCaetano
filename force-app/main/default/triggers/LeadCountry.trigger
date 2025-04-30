trigger LeadCountry on Lead (before insert, before update) {
    Map<String, Country__c> countryMap = new Map<String, Country__c>();
    for (Country__c c : [SELECT Name, Alpha2Code__c, Alpha3Code__c, Region__c, Capital__c FROM Country__c]) {
        countryMap.put(c.Name, c);
    }

    for (Lead l : Trigger.new) {
        if (l.Country != null && countryMap.containsKey(l.Country)) {
            Country__c c = countryMap.get(l.Country);
            l.Country_Alpha2__c = c.Alpha2Code__c;
            l.Country_Alpha3__c = c.Alpha3Code__c;
            l.Country_Region__c = c.Region__c;
            l.Country_Capital__c = c.Capital__c;
        }
    }
}