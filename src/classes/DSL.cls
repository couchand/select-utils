global class DSL
{
    global static Select.Filter parse( String input )
    {
        Object parsed = Parser.Parse.expression( input );

        return buildFilter( (Parser.FunctionCall)parsed );
    }

    global static Select.Filter buildFilter( Parser.FunctionCall call )
    {
        if ( call.name.toLowerCase() == 'haschanged' )
        {
            return Select.Field.hasChanged( (String)call.parameters[0] );
        }
        if ( call.name.toLowerCase() == 'isequal' )
        {
            return Select.Field.isEqual( (String)call.parameters[0], JSON.deserializeUntyped( (String)call.parameters[1] ) );
        }
        if ( call.name.toLowerCase() == 'notequal' )
        {
            return Select.Field.notEqual( (String)call.parameters[0], JSON.deserializeUntyped( (String)call.parameters[1] ) );
        }
        if ( call.name.toLowerCase() == 'and' )
        {
            return buildFilter( (Parser.FunctionCall)call.parameters[0] )
            .andx( buildFilter( (Parser.FunctionCall)call.parameters[1] ) );
        }
        if ( call.name.toLowerCase() == 'or' )
        {
            return buildFilter( (Parser.FunctionCall)call.parameters[0] )
            .orx( buildFilter( (Parser.FunctionCall)call.parameters[1] ) );
        }
        if ( call.name.toLowerCase() == 'not' )
        {
            return buildFilter( (Parser.FunctionCall)call.parameters[0] ).notx();
        }

        return null;
    }
}
