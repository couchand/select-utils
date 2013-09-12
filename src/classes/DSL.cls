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
        'isnew' => new Builtins.IsNewFactory(),
        'isequal' => new Builtins.IsEqualFactory(),
        'notequal' => new Builtins.NotEqualFactory(),
        'isnull' => new Builtins.IsNullFactory(),
        'notnull' => new Builtins.NotNullFactory(),
        'startswith' => new Builtins.StartsWithFactory(),
        'endswith' => new Builtins.EndsWithFactory(),
        'contains' => new Builtins.ContainsFactory(),
        'haschildren' => new Builtins.HasChildrenFactory(),
        'hasnochildren' => new Builtins.HasNoChildrenFactory(),
        'all' => new Builtins.AllFactory(),
        'none' => new Builtins.NoneFactory(),
        'and' => new Builtins.AndFactory(),
        'or' => new Builtins.OrFactory(),
        'not' => new Builtins.NotFactory()
    };

    global static void register( String keyword, FilterFactory factory )
    {
        registeredKeywords.put( keyword.toLowerCase(), factory );
    }

    global interface FilterFactory
    {
        Select.Filter build( Parser.FunctionCall call );
    }
}
