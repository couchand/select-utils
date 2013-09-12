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
        'haschanged' => new Builtins.HasChangedFactory(),
        'isequal' => new Builtins.IsEqualFactory(),
        'notequal' => new Builtins.NotEqualFactory(),
        'and' => new Builtins.AndFactory(),
        'or' => new Builtins.OrFactory(),
        'not' => new Builtins.NotFactory()
    };

    global interface FilterFactory
    {
        Select.Filter build( Parser.FunctionCall call );
    }
}
