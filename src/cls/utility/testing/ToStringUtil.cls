/// 
Class utility.testing.ToStringUtil
{

/// Description
ClassMethod DynamicObjectToString(obj As %Library.DynamicObject) As %Status
{
    Set name = obj.%ClassName(0)
    Set result = name_"("
    Set iterator = obj.%GetIterator()
    Set first = 0
    While iterator.%GetNext(.key, .value) {
        If '(first=0) {
            Set result = result_", "
        }
        If '($DATA(value)) {
            Set value = "n/a"
        } elseif (value="") {
            
            Set value = "n/a"
        } else {
            Set value = ##class(utility.testing.ToStringUtil).ObjectToString(value)
        }
        Set result = result_key_": "_value
        Set first = 1
    }
    Quit result_")"
}

ClassMethod DynamicArrayToString(obj As %Library.DynamicArray) As %Status
{
    Set result = "DA["
    Set iterator = obj.%GetIterator()
    Set first = 0
    While iterator.%GetNext(.key, .value) {
        If '(first=0) {
            Set result = result_", "
        }
        Set formattedValue = ##class(utility.testing.ToStringUtil).ObjectToString(value)
        Set result = result_formattedValue
        Set first = 1
    }
    Quit result_"]"
}

ClassMethod SystemBaseObjectToString(obj As %Library.SystemBase) As %Status
{
    Set name = obj.%ClassName(0)
    Set result = name_"("
    Set classDef = ##class(%Dictionary.ClassDefinition).%OpenId(obj.%ClassName(1))
    For i=1:1:classDef.Properties.Count() {
        If '(i=1) {
            Set result = result_", "
        }  
        Set name = classDef.Properties.GetAt(i).Name
        Set value = $PROPERTY(obj,classDef.Properties.GetAt(i).Name)
        If '($DATA(value)) {
            Set value = "n/a"
        } elseIf (value="") {
            Set value = "n/a"
        } else {
            Set value = ##class(utility.testing.ToStringUtil).ObjectToString(value)
        }
        Set result = result_name_": "_value
    }
    Set result = result_")"
    Quit result
}

ClassMethod ObjectToString(obj As %Library.SystemBase) As %String
{
    If ($ISOBJECT(obj)) {
        Set name = obj.%ClassName(1)
        If (name="%Library.DynamicObject") {
            Quit ##class(utility.testing.ToStringUtil).DynamicObjectToString(obj)
        } ElseIf (name="%Library.DynamicArray") {
            Quit ##class(utility.testing.ToStringUtil).DynamicArrayToString(obj)
        } Else {
            Quit ##class(utility.testing.ToStringUtil).SystemBaseObjectToString(obj)
        }
    } else {
        return obj
    }
}

}
