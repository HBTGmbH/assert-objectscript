/// 
Class utility.testing.RecursiveDynamicObjectComparator Extends utility.testing.DynamicObjectComparator
{

/// Defines if order should be ignored when comparing arrays. Defaults to 1
Property IgnoreOrder As %Boolean;

/// Description
Property IgnoredFields As %DynamicArray;

Method %OnNew() As %Status
{
    Set ..IgnoreOrder = 1
    Set ..IgnoredFields = []
    return $$$OK
}

/// Adds an ignored fields. When comparing objects, fields with this name will be ignored from comparison
Method AddIgnoredField(fieldName As %String) As %Status
{
    do ..IgnoredFields.%Push(fieldName)
    Return $$$OK
}

Method IsFieldIgnored(fieldName As %String) As %Boolean
{
    Set iterator = ..IgnoredFields.%GetIterator()
     while iterator.%GetNext(.key, .value) {
        if (value = fieldName) {
            return 1
        }
    }
    return 0
}

/// Description
Method isContainedInArray(arr As %DynamicArray, referenceValue As %DynamicObject) As %Boolean
{
    set iterator = arr.%GetIterator()
    while iterator.%GetNext(.key, .value) {
        if (..areEqual(referenceValue, value)) {
            return 1
        }
    }
    return 0
}

/// Description
Method areEqualDynamicObjects(expected As %DynamicObject, actual As %DynamicObject) As %Boolean
{
    Set expectedIterator = expected.%GetIterator()
    // Make sure each value in 'actual' is represented as the same value in 'expected'
    While expectedIterator.%GetNext(.key, .value) {
        If '(..IsFieldIgnored(key)) {
            Set actualValue = actual.%Get(key)
            If '(..areEqual(value, actualValue)) {
                Return 0
            }
        }
    }
    Set actualIterator = actual.%GetIterator()
    // Check for potentially superflous values in 'actual'
    While actualIterator.%GetNext(.key, .value) {
        If '(..IsFieldIgnored(key)) {
            Set expectedValue = expected.%Get(key)
            If '(..areEqual(value, expectedValue)) {
                Return 0
            }
        }
       
    }
    Return 1
}

/// Description
Method areEqualObjects(expected As %SystemBase, actual As %SystemBase) As %Status
{
    // Array of {key: "<prop-name>", value: <prop-value>}
    set expcetedProperties =  ##class(utility.testing.PropertyUtil).GetProperties(expected)
    set acutalProperties =  ##class(utility.testing.PropertyUtil).GetProperties(actual)
    set expectedIterator = expcetedProperties.%GetIterator()
    set actualIterator = acutalProperties.%GetIterator()
    // Make sure each value in 'actual' is represented as the same value in 'expected'
    While expectedIterator.%GetNext(.key, .value) {
        If '(..IsFieldIgnored(value.key)) {
            // Since the data model is equal for both, we can use containedInArray here
            set isContained = ..isContainedInArray(acutalProperties, value)
            If '(isContained) {
                return 0
            }
        }
    }
    Set actualIterator = acutalProperties.%GetIterator()
    // Check for potentially superflous values in 'actual'
    While actualIterator.%GetNext(.key, .value) {
        If '(..IsFieldIgnored(key)) {
            set isContained = ..isContainedInArray(expcetedProperties, value)
            If '(isContained) {
                return 0
            }
        }
       
    }
    Return 1
}

/// Description
Method areEqualArraysIgnorningOrder(expected As %DynamicArray, actual As %DynamicArray) As %Boolean
{
    Set expectedIterator = expected.%GetIterator()
    // Make sure each value in 'actual' is represented as the same value in 'expected'
    While expectedIterator.%GetNext(.key, .value) {
        // For each value in expected, we verify that it is actually contained
        // in 'actual'. This way, we spot missing elements
        Set isContainedInActual = ..isContainedInArray(actual, value)
        If '(isContainedInActual) {
            Return 0
        }
    }
    Set actualIterator = actual.%GetIterator()
    // Check for potentially superflous values in 'actual'
    While actualIterator.%GetNext(.key, .value) {
        // For each value in 'actual', we verify that it is contained in 'expected'
        // This way, we spot superflous elements (elements that were not expected in actual, but are present anyway)
        Set isContainedInActual = ..isContainedInArray(expected, value)
        If '(isContainedInActual) {
            Return 0
        }
    }
    Return 1
}

Method areEqualArraysRespectingOrder(expected As %DynamicArray, actual As %DynamicArray) As %Boolean
{
    Set expectedIterator = expected.%GetIterator()
    While expectedIterator.%GetNext(.key, .value) {
        Set actualValue = actual.%Get(key)
        if '($DATA(actualValue)) {
            return 0
        }
        if '(actualValue = value) {
            return 0
        }
    }
    Set actualIterator = actual.%GetIterator()
    While actualIterator.%GetNext(.key, .value) {
        Set expectedValue = expected.%Get(key)
        if '($DATA(expectedValue)) {
            return 0
        }
        if '(expectedValue = value) {
            return 0
        }
    }
    return 1
}

Method areEqualArrays(expected As %DynamicArray, actual As %DynamicArray) As %Boolean
{
    If (..IgnoreOrder) {
        return ..areEqualArraysIgnorningOrder(expected, actual)
    }
    return ..areEqualArraysRespectingOrder(expected, actual)
}

/// Description
/// Description
Method areEqual(expected, actual) As %Boolean
{
    if '($DATA(expected)) && '($DATA(actual)) {
        return 1
    } ElseIf ($DATA(expected)) && '($DATA(actual)) {
        return 0
    } ElseIf '($DATA(expected)) && ($DATA(actual)) {
        return 0
    } ElseIf ($ISOBJECT(expected) && $ISOBJECT(actual)) {
        // Both are actually an object. Need to apply more complex logic here.
        // Important to differ between DynamicArray and DynamicObject, since we are
        // ignoring order
       Set expectedName = expected.%ClassName(1)
       Set actualName = actual.%ClassName(1)
       // Name does not match => Fail
       If '(expectedName = actualName) {
           Return 0
       }
       If (expectedName = "%Library.DynamicObject") {
           Return ..areEqualDynamicObjects(expected, actual)
       } Elseif (expectedName="%Library.DynamicArray") {
            Return ..areEqualArrays(expected, actual)
       } Else {
            Return ..areEqualObjects(expected, actual)
       }
    } Else {
        // We have a base type (number, boolean, string, etc). We use basic comparison
        Return expected = actual
    }
}

/// Description
ClassMethod DebugIt() As %Status
{
    Set arrayA = ["A", "B"]
    Set arrayB = ["A"]
    Set instance = ##class(utility.testing.RecursiveDynamicObjectComparator).%New()
    do instance.areEqual(arrayA, arrayB)
}

}
