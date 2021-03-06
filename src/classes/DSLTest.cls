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

    private static testMethod void smokeTests()
    {
        List<String> tests = new List<String>
        {
            'and(hasChanged(Amount),isEqual(Amount,42))',
            'or(hasChanged(Amount),isEqual(Amount,42))',
            'not(and(hasChanged(Amount),isEqual(Amount,42)))',
            'and(hasChanged(Amount),isEqual(Amount,42.2))',
            'and(hasChanged(Amount),isEqual(Stage,"Complete"))',
            'and(hasChanged(Amount),notEqual(Amount,42))',
//            'and(isNew(),isEqual(Amount,42))',
            'and(isNew(Amount),isNull(Stage))',
            'and(notNull(Amount),startsWith(Stage,"Complete"))',
            'and(endsWith(Stage," - 3"),contains(Stage,"Working"))',
            'and(hasChildren(OpportunityLineItems),hasNoChildren(Budget__c))',
            'and(all(),none())'
        };

        List<String> errorCases = new List<String>();

        Test.startTest();

            for ( String testCase : tests )
            {
                Object parsed;

                try
                {
                    parsed = DSL.parse( testCase );

                    if ( parsed == null )
                    {
                        errorCases.add( testCase );
                    }
                }
                catch ( Exception ex )
                {
                    errorCases.add( testCase );
                }
            }

        Test.stopTest();

        if ( !errorCases.isEmpty() )
        {
            System.assert( false, 'Error parsing the following cases:\n' + String.join( errorCases, '\n' ) );
        }
    }

    private static testMethod void registerTest()
    {
        DSL.FilterFactory factory = new Builtins.AllFactory();

        DSL.registeredKeywords.clear();

        Test.startTest();

            DSL.register( 'Foobar', factory );

        Test.stopTest();

        System.assertEquals( 1, DSL.registeredKeywords.size(),
            'The keyword should be added to the registry' );
        System.assertEquals( factory, DSL.registeredKeywords.get( 'foobar' ),
            'The filter factory should be stored in the registry' );
    }
}
