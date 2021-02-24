/// Description
Class hbt.utility.testing.ObjectAssertBuilder Extends %SystemBase
{

/// The test context. This is necessary for the assert to work properly
Property TestContext As %UnitTest.TestCase;

/// Defines fields that are ignored when using the field by field comparison
/// Only works with enabled field by field comparison (disabled by default)
Property IgnoredFields As %DynamicArray;

/// Defines that we are going to compare values in this array using recursive field by field comparison, not
/// the object equality comparison
Property UseFieldByFieldComparison As %Boolean;

/// The expected array. The actual array in 'isEqualTo' will be compared against this
Property Expected As %DynamicObject;

Property Actual As %DynamicObject;

Property Comparator As hbt.utility.testing.DynamicObjectComparator;

ClassMethod BuildInstance(testContext As %UnitTest.TestCase, actual As %DynamicObject) As hbt.utility.testing.ObjectAssertBuilder
{
    set builder = ##class(ObjectAssertBuilder).%New()
    set builder.IgnoredFields = []
    set builder.UseFieldByFieldComparison = 0
    set builder.TestContext = testContext
    set builder.Actual = actual
    return builder
}

/// Description
Method IgnoringFields(fieldNames As %DynamicArray) As hbt.utility.testing.ObjectAssertBuilder
{
    set ..IgnoredFields = fieldNames
    return $THIS
}

/// Description
Method UsingFieldByFieldComparison() As hbt.utility.testing.ObjectAssertBuilder
{
    Set ..UseFieldByFieldComparison = 1
    return $THIS
}

/// FIXME this is duplicated code
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
        set ..Comparator.IgnoredFields = ..IgnoredFields
    } else {
        set ..Comparator = ##class(hbt.utility.testing.ObjectEqualityComparator).%New()
    }
}

/// Description
Method IsDefined() As %Status
{
    Write !,!,..Actual
    if (..Actual = $$$NULLOREF) {
        set msg = "Expected actual value to be defined"
        do ..TestContext.AssertFailureViaMacro(msg)
    }
    return $$$OK
}

/// Description
Method IsNotDefined() As %Status
{
    if '(..Actual = $$$NULLOREF) {
        set actualAsString = ##class(hbt.utility.testing.ToStringUtil).ObjectToString(..Actual)
        set msg = "Expected "_actualAsString_" to be undefined"
        do ..TestContext.AssertFailureViaMacro(msg)
    }
    return $$$OK
}

/// Description
Method IsEqualTo(expected) As %Status
{
    do ..InitComparator()
    If '(..Comparator.areEqual(..Actual, expected)) {
        set actualAsString = $$$NL_##class(hbt.utility.testing.ToStringUtil).ObjectToString(..Actual)_$$$NL
        set expectedAsString =  $$$NL_##class(hbt.utility.testing.ToStringUtil).ObjectToString(expected)_$$$NL
        set msg = $$$NL_"    Expected:"_actualAsString_"    to be equal to:"_expectedAsString
        do ..TestContext.AssertFailureViaMacro(msg)
    }
    Return $$$OK
}

}
