Class utility.testing.PropertyUtil Extends %SystemBase
{

/// Description
ClassMethod GetProperties(obj As %SystemBase) As %DynamicArray
{
    set res = []
    Set classDef = ##class(%Dictionary.ClassDefinition).%OpenId(obj.%ClassName(1))
    For i=1:1:classDef.Properties.Count() {
        Set name = classDef.Properties.GetAt(i).Name
        Set value = $PROPERTY(obj,classDef.Properties.GetAt(i).Name)
        set entry = {}
        set entry.key = name
        set entry.value = value
        do res.%Push(entry)
    }
    return res
}

}
