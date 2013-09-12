global class DSL
{
    global static Select.Filter parse( String input )
    {
        Object parsed = Parser.Parse.expression( input );

        return buildFilter( (Parser.FunctionCall)parsed );
    }

    global static Select.Filter buildFilter( Parser.FunctionCall call )
    {
        FilterFactory factory = registeredKeywords.get( call.name.toLowerCase() );

        if ( factory != null )
        {
            return factory.build( call );
        }

        return null;
    }

    global static Map<String, FilterFactory> registeredKeywords = new Map<String, FilterFactory>{
        'haschanged' => new HasChangedFactory(),
        'isequal' => new IsEqualFactory(),
        'notequal' => new NotEqualFactory(),
        'and' => new AndFactory(),
        'or' => new OrFactory(),
        'not' => new NotFactory()
    };

    global interface FilterFactory
    {
        Select.Filter build( Parser.FunctionCall call );
    }

    global class HasChangedFactory implements FilterFactory
    {
        global Select.Filter build( Parser.FunctionCall call )
        {
            return Select.Field.hasChanged( (String)call.parameters[0] );
        }
    }

    global class IsEqualFactory implements FilterFactory
    {
        global Select.Filter build( Parser.FunctionCall call )
        {
            return Select.Field.isEqual( (String)call.parameters[0], JSON.deserializeUntyped( (String)call.parameters[1] ) );
        }
    }

    global class NotEqualFactory implements FilterFactory
    {
        global Select.Filter build( Parser.FunctionCall call )
        {
            return Select.Field.notEqual( (String)call.parameters[0], JSON.deserializeUntyped( (String)call.parameters[1] ) );
        }
    }

    global class AndFactory implements FilterFactory
    {
        global Select.Filter build( Parser.FunctionCall call )
        {
            return buildFilter( (Parser.FunctionCall)call.parameters[0] )
            .andx( buildFilter( (Parser.FunctionCall)call.parameters[1] ) );
        }
    }

    global class OrFactory implements FilterFactory
    {
        global Select.Filter build( Parser.FunctionCall call )
        {
            return buildFilter( (Parser.FunctionCall)call.parameters[0] )
            .orx( buildFilter( (Parser.FunctionCall)call.parameters[1] ) );
        }
    }

    global class NotFactory implements FilterFactory
    {
        global Select.Filter build( Parser.FunctionCall call )
        {
            return buildFilter( (Parser.FunctionCall)call.parameters[0] ).notx();
        }
    }
}
