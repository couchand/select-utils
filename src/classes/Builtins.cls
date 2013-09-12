global class Builtins
{
    global class HasChangedFactory implements DSL.FilterFactory
    {
        global Select.Filter build( Parser.FunctionCall call )
        {
            return Select.Field.hasChanged( (String)call.parameters[0] );
        }
    }

    global class IsNewFactory implements DSL.FilterFactory
    {
        global Select.Filter build( Parser.FunctionCall call )
        {
            return Select.Field.isNew( (String)call.parameters[0] );
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

    global class IsNullFactory implements DSL.FilterFactory
    {
        global Select.Filter build( Parser.FunctionCall call )
        {
            return Select.Field.isNull( (String)call.parameters[0] );
        }
    }

    global class NotNullFactory implements DSL.FilterFactory
    {
        global Select.Filter build( Parser.FunctionCall call )
        {
            return Select.Field.notNull( (String)call.parameters[0] );
        }
    }

    global class StartsWithFactory implements DSL.FilterFactory
    {
        global Select.Filter build( Parser.FunctionCall call )
        {
            return Select.Field.startsWith( (String)call.parameters[0], (String)JSON.deserializeUntyped( (String)call.parameters[1] ) );
        }
    }

    global class EndsWithFactory implements DSL.FilterFactory
    {
        global Select.Filter build( Parser.FunctionCall call )
        {
            return Select.Field.endsWith( (String)call.parameters[0], (String)JSON.deserializeUntyped( (String)call.parameters[1] ) );
        }
    }

    global class ContainsFactory implements DSL.FilterFactory
    {
        global Select.Filter build( Parser.FunctionCall call )
        {
            return Select.Field.contains( (String)call.parameters[0], (String)JSON.deserializeUntyped( (String)call.parameters[1] ) );
        }
    }

    global class HasChildrenFactory implements DSL.FilterFactory
    {
        global Select.Filter build( Parser.FunctionCall call )
        {
            return Select.Field.hasChildren( (String)call.parameters[0] );
        }
    }

    global class HasNoChildrenFactory implements DSL.FilterFactory
    {
        global Select.Filter build( Parser.FunctionCall call )
        {
            return Select.Field.hasNoChildren( (String)call.parameters[0] );
        }
    }

    global class AllFactory implements DSL.FilterFactory
    {
        global Select.Filter build( Parser.FunctionCall call )
        {
            return Select.Records.all();
        }
    }

    global class NoneFactory implements DSL.FilterFactory
    {
        global Select.Filter build( Parser.FunctionCall call )
        {
            return Select.Records.none();
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
