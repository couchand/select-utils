global class Builtins
{
    global class HasChangedFactory implements DSL.FilterFactory
    {
        global Select.Filter build( Parser.FunctionCall call )
        {
            return Select.Field.hasChanged( (String)call.parameters[0] );
        }
    }

    global class IsEqualFactory implements DSL.FilterFactory
    {
        global Select.Filter build( Parser.FunctionCall call )
        {
            return Select.Field.isEqual( (String)call.parameters[0], JSON.deserializeUntyped( (String)call.parameters[1] ) );
        }
    }

    global class NotEqualFactory implements DSL.FilterFactory
    {
        global Select.Filter build( Parser.FunctionCall call )
        {
            return Select.Field.notEqual( (String)call.parameters[0], JSON.deserializeUntyped( (String)call.parameters[1] ) );
        }
    }

    global class AndFactory implements DSL.FilterFactory
    {
        global Select.Filter build( Parser.FunctionCall call )
        {
            return DSL.buildFilter( (Parser.FunctionCall)call.parameters[0] )
            .andx( DSL.buildFilter( (Parser.FunctionCall)call.parameters[1] ) );
        }
    }

    global class OrFactory implements DSL.FilterFactory
    {
        global Select.Filter build( Parser.FunctionCall call )
        {
            return DSL.buildFilter( (Parser.FunctionCall)call.parameters[0] )
            .orx( DSL.buildFilter( (Parser.FunctionCall)call.parameters[1] ) );
        }
    }

    global class NotFactory implements DSL.FilterFactory
    {
        global Select.Filter build( Parser.FunctionCall call )
        {
            return DSL.buildFilter( (Parser.FunctionCall)call.parameters[0] ).notx();
        }
    }
}
