@isTest
global class DSLTest
{
    private static testMethod void testParse()
    {
        Test.startTest();

            Select.Filter filter = DSL.parse( 'hasChanged(Amount)' );

        Test.stopTest();

        Opportunity oldChanged = new Opportunity( Id = '006000000123456', Amount = 42 );
        Opportunity newChanged = new Opportunity( Id = '006000000123456', Amount = 24 );
        Opportunity oldNotChanged = new Opportunity( Id = '006000000123457', Amount = 36 );
        Opportunity newNotChanged = new Opportunity( Id = '006000000123457', Amount = 36 );

        List<sObject> filtered = filter.filter(
            new List<sObject>{ newChanged, newNotChanged },
            new Map<Id, sObject>{ oldChanged.Id => oldChanged, oldNotChanged.Id => oldNotChanged  }
        );

        System.assertEquals( 1, filtered.size() );
        System.assertEquals( newChanged.Id, filtered[0].get('Id') );
    }

    private static testMethod void testParseComplex()
    {
        Test.startTest();

            Select.Filter filter = DSL.parse( 'and(hasChanged(Amount),isEqual(Amount,42))' );

        Test.stopTest();

        Opportunity oldChangedTo24 = new Opportunity( Id = '006000000123455', Amount = 42 );
        Opportunity newChangedTo24 = new Opportunity( Id = '006000000123455', Amount = 24 );
        Opportunity oldChangedTo42 = new Opportunity( Id = '006000000123456', Amount = 24 );
        Opportunity newChangedTo42 = new Opportunity( Id = '006000000123456', Amount = 42 );
        Opportunity oldNotChanged = new Opportunity( Id = '006000000123457', Amount = 36 );
        Opportunity newNotChanged = new Opportunity( Id = '006000000123457', Amount = 36 );

        List<sObject> filtered = filter.filter(
            new List<sObject>{ newChangedTo24, newChangedTo42, newNotChanged },
            new Map<Id, sObject>{ oldChangedTo24.Id => oldChangedTo24, oldChangedTo42.Id => oldChangedTo42, oldNotChanged.Id => oldNotChanged  }
        );

        System.assertEquals( 1, filtered.size() );
        System.assertEquals( newChangedTo42.Id, filtered[0].get('Id') );
    }
}
