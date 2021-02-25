/// Description
Class hbt.utility.testing.ArrayAssertBuilder Extends %SystemBase
{

/// Defines that we are going to compare values in this array using recursive field by field comparison, not
/// the object equality comparison
Property UseFieldByFieldComparison As %Boolean;

/// Defines fields that are ignored when using the field by field comparison
/// Only works with enabled field by field comparison (disabled by default)
Property IgnoredFields As %DynamicArray;

/// Defines that the order of the arrays is unimportant. field by field comparison if enabled, otherwise object equality.
Property IgnoreOrder As %Boolean;

/// The test context. This is necessary for the assert to work properly
Property TestContext As %UnitTest.TestCase;

/// The expected array. The actual array in 'isEqualTo' will be compared against this
Property Expected As %DynamicArray;

Property Actual As %DynamicArray;

Property Comparator As hbt.utility.testing.DynamicObjectComparator;

/// This is supposed to be called from the AssertBuilder. Do not call yourself.
ClassMethod BuildInstance(testContext As %UnitTest.TestCase, actual As %DynamicArray) As hbt.utility.testing.ArrayAssertBuilder
{
    set builder = ##class(ArrayAssertBuilder).%New()
    set builder.IgnoredFields = []
    set builder.UseFieldByFieldComparison = 0
    set builder.TestContext = testContext
    set builder.Actual = actual
    return builder
}

/// Description
Method IgnoringField(fieldName As %String) As hbt.utility.testing.ArrayAssertBuilder
{
    do ..IgnoredFields.%Push(fieldName)
    return $THIS
}

/// Description
Method IgnoringFields(fieldNames As %DynamicArray) As hbt.utility.testing.ArrayAssertBuilder
{
    set iterator = fieldNames.%GetIterator()
    While iterator.%GetNext(.key, .value) {
        do ..IgnoringField(iterator)
    }
    return $THIS
}

/// Description
Method IgnoringOrder() As hbt.utility.testing.ArrayAssertBuilder
{
    set ..IgnoreOrder = 1
    return $THIS
}

/// Description
Method UsingFieldByFieldComparison() As hbt.utility.testing.ArrayAssertBuilder
{
    Set ..UseFieldByFieldComparison = 1
    return $THIS
}

Method IsContainedInArray(arr As %DynamicArray, referenceValue As %DynamicObject) As %Boolean [ Private ]
{
    set iterator = arr.%GetIterator()
    while iterator.%GetNext(.key, .value) {
        if (..Comparator.areEqual(value, referenceValue)) {
            return 1
        }
    }
    return 0
}

/// Description
Method InitComparator() As %Status [ Private ]
{
  // Now, make the comparator used for comparison
    // If we have ignored fields, we also need FieldByField comparison
    set hasIgnoredFields = ..IgnoredFields.%Size() > 0
    if ('(..UseFieldByFieldComparison) && hasIgnoredFields) {
         do ..TestContext.AssertFailureViaMacro("Cannot use ignored fields without using UseFieldByFieldComparison")
    }
    // If we are using field by field comparison, we need a RecursiveDynamicObjectComparator comparator
    If (..UseFieldByFieldComparison) {
        set ..Comparator = ##class(hbt.utility.testing.RecursiveDynamicObjectComparator).%New()
        set ..Comparator.IgnoreOrder = ..IgnoreOrder
        set ..Comparator.IgnoredFields = ..IgnoredFields
    } else {
        set ..Comparator = ##class(hbt.utility.testing.ObjectEqualityComparator).%New()
    }
}

Method AssertIgnoringOrder() [ Private ]
{
    set expectedIterator = ..Expected.%GetIterator()
    while expectedIterator.%GetNext(.key, .value) {
        If '(..IsContainedInArray(..Actual, value)) {
            set actualAsString = ##class(hbt.utility.testing.ToStringUtil).DynamicArrayToString(..Actual)
            set expectedAsString = ##class(hbt.utility.testing.ToStringUtil).DynamicArrayToString(..Expected)
            set missingAsString = ##class(hbt.utility.testing.ToStringUtil).ObjectToString(value)
            set msg = "Expected "_actualAsString_" to equal "_expectedAsString_" but did not find "_missingAsString_" while ignoring order of fields"
            do ..TestContext.AssertFailureViaMacro(msg)
        }
    }
    set actualIterator = ..Actual.%GetIterator()
    while actualIterator.%GetNext(.key, .value) {
        If '(..IsContainedInArray(..Expected, value)) {
            set actualAsString = ##class(hbt.utility.testing.ToStringUtil).DynamicArrayToString(..Actual)
            set expectedAsString = ##class(hbt.utility.testing.ToStringUtil).DynamicArrayToString(..Expected)
            set superflousAsString = ##class(hbt.utility.testing.ToStringUtil).ObjectToString(value)
            set msg = "Expected "_actualAsString_" to equal "_expectedAsString_", but found superflous element "_superflousAsString_" while ignoring order of fields"
            do ..TestContext.AssertFailureViaMacro(msg)
        }
    }
    return $$$OK
}

Method AssertKeepingOrder() [ Private ]
{
    set expectedIterator = ..Expected.%GetIterator()
    while expectedIterator.%GetNext(.key, .value) {
        set otherValue = ..Actual.%Get(key)
        If ('($DATA(otherValue))) || (otherValue = "") {
            set actualAsString = $$$NL_##class(hbt.utility.testing.ToStringUtil).DynamicArrayToString(..Actual)_$$$NL
            set expectedAsString = $$$NL_##class(hbt.utility.testing.ToStringUtil).DynamicArrayToString(..Expected)_$$$NL
            set missingAsString = ##class(hbt.utility.testing.ToStringUtil).ObjectToString(value)
            set msg = "Expected "_expectedAsString_" to equal "_actualAsString_" but did not find "_missingAsString_" at index "_key
            do ..TestContext.AssertFailureViaMacro(msg)
        } elseif '(..Comparator.areEqual(value, otherValue)) {
            set actualAsString = $$$NL_##class(hbt.utility.testing.ToStringUtil).DynamicArrayToString(..Actual)_$$$NL
            set expectedAsString = $$$NL_##class(hbt.utility.testing.ToStringUtil).DynamicArrayToString(..Expected)_$$$NL
            set expectedValueString = ##class(hbt.utility.testing.ToStringUtil).ObjectToString(value)
            set actualValueString = ##class(hbt.utility.testing.ToStringUtil).ObjectToString(otherValue)
            set msg = $$$NL_"   Expected "_actualAsString_"    to equal "_expectedAsString_"    but element at index "_key_" mismatches:"_$$$NL
            set msg = msg_"Expected "_expectedValueString_" to equal "_actualValueString
            do ..TestContext.AssertFailureViaMacro(msg)
        }
    }
    Quit $$$OK
}

Method ToEqual(expected As %DynamicArray) As hbt.utility.testing.ArrayAssertBuilder
{
  
    set ..Expected = expected
    do ..InitComparator()
    If (..IgnoreOrder) {
        do ..AssertIgnoringOrder()
    } else {
        do ..AssertKeepingOrder()
    }
    return $$$OK
}

Method ToContain(value) As %Status
{
    do ..InitComparator()
    If '(..IsContainedInArray(..Actual, value)) {
        Set actualAsString = ##class(hbt.utility.testing.ToStringUtil).DynamicArrayToString(..Actual)
        Set missingAsString = ##class(hbt.utility.testing.ToStringUtil).ObjectToString(value)
        Set msg = $$$NL_"   Expected "_$$$NL_actualAsString_$$$NL_"   to contain "_$$$NL_missingAsString_$$$NL_$$$NL
        Do ..TestContext.AssertFailureViaMacro(msg)
    }
    return $$$OK
}

Method NotToContain(value) As %Status
{
    do ..InitComparator()
    If (..IsContainedInArray(..Actual, value)) {
        set actualAsString = ##class(hbt.utility.testing.ToStringUtil).DynamicArrayToString(..Actual)
        set missingAsString = ##class(hbt.utility.testing.ToStringUtil).ObjectToString(value)
        Set msg = $$$NL_"   Expected "_$$$NL_actualAsString_$$$NL_"   not to contain "_$$$NL_missingAsString_$$$NL_$$$NL
        do ..TestContext.AssertFailureViaMacro(msg)
    }
    return $$$OK
}

Method HasSize(expectedSize As %Integer) As %Status
{
    set actualSize = ..Actual.%Size()
    If '(actualSize = expectedSize) {
        set actualAsString = ##class(hbt.utility.testing.ToStringUtil).ObjectToString(..Actual)
        set msg = $$$NL_"   Expected "_$$$NL_actualAsString_":"_$$$NL_"    To have size "_expectedSize_" but was "_actualSize_$$$NL_$$$NL
        do ..TestContext.AssertFailureViaMacro(msg)
    }
    return $$$OK
}

Method ToBeEmpty() As %Status
{
    set actualSize = ..Actual.%Size()
    If '(actualSize = 0) {
        set actualAsString = ##class(hbt.utility.testing.ToStringUtil).ObjectToString(..Actual)
        set msg = $$$NL_"   Expected "_$$$NL_actualAsString_":"_$$$NL_"    To be empty but has "_actualSize_ "elements" _$$$NL_$$$NL
        do ..TestContext.AssertFailureViaMacro(msg)
    }
    return $$$OK
}

Method NotToBeEmpty() As %Status
{
    set actualSize = ..Actual.%Size()
    If (actualSize = 0) {
        set actualAsString = ##class(hbt.utility.testing.ToStringUtil).ObjectToString(..Actual)
        set msg = $$$NL_"   Expected "_$$$NL_actualAsString_":"_$$$NL_"    Not to be empty but has "_actualSize_ "elements" _$$$NL_$$$NL
        do ..TestContext.AssertFailureViaMacro(msg)
    }
    return $$$OK
}

}
