/// Description
Class utility.testing.ObjectAssertBuilder Extends %SystemBase
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

Property Comparator As utility.testing.DynamicObjectComparator;

ClassMethod BuildInstance(testContext As %UnitTest.TestCase, actual As %DynamicObject) As utility.testing.ObjectAssertBuilder
{
    Set builder = ##class(ObjectAssertBuilder).%New()
    Set builder.IgnoredFields = []
    Set builder.UseFieldByFieldComparison = 0
    Set builder.TestContext = testContext
    Set builder.Actual = actual
    Return builder
}

/// Description
Method IgnoringFields(fieldNames As %DynamicArray) As utility.testing.ObjectAssertBuilder
{
    Set ..IgnoredFields = fieldNames
    Return $THIS
}

/// Description
Method UsingFieldByFieldComparison() As utility.testing.ObjectAssertBuilder
{
    Set ..UseFieldByFieldComparison = 1
    Return $THIS
}

/// FIXME this is duplicated code
Method InitComparator() As %Status [ Private ]
{
  // Now, make the comparator used for comparison
    // If we have ignored fields, we also need FieldByField comparison
    Set hasIgnoredFields = ..IgnoredFields.%Size() > 0
    If ('(..UseFieldByFieldComparison) && hasIgnoredFields) {
         Do ..TestContext.AssertFailureViaMacro("Cannot use ignored fields without using UseFieldByFieldComparison")
    }
    // If we are using field by field comparison, we need a RecursiveDynamicObjectComparator comparator
    If (..UseFieldByFieldComparison) {
        Set ..Comparator = ##class(utility.testing.RecursiveDynamicObjectComparator).%New()
        Set ..Comparator.IgnoredFields = ..IgnoredFields
    } Else {
        Set ..Comparator = ##class(utility.testing.ObjectEqualityComparator).%New()
    }
}

/// Description
Method IsDefined() As %Status
{
    If (..Actual = $$$NULLOREF) {
        Set msg = "Expected actual value to be defined"
        Do ..TestContext.AssertFailureViaMacro(msg)
    }
    Return $$$OK
}

/// Description
Method ToHaveProperty(key As %String) As %Status
{
    set isDefined = ..IsPropertyDefined(..Actual, key)
    If 'isDefined {
        Set actualAsString = $$$NL_##class(utility.testing.ToStringUtil).ObjectToString(..Actual)_$$$NL
        Set msg = "   Expected"_actualAsString_"   to have the property "_key
        Do ..TestContext.AssertFailureViaMacro(msg)
    }
    Return $$$OK
}

/// Description
Method NotToHaveProperty(key As %String) As %Status
{
    set isDefined = ..IsPropertyDefined(..Actual, key)
    If isDefined {
        Set actualAsString = $$$NL_##class(utility.testing.ToStringUtil).ObjectToString(..Actual)_$$$NL
        Set msg = "   Expected"_actualAsString_"   to not have the property "_key
        Do ..TestContext.AssertFailureViaMacro(msg)
    }
    Return $$$OK
}

/// Description
Method IsNotDefined() As %Status
{
    If '(..Actual = $$$NULLOREF) {
        Set actualAsString = ##class(utility.testing.ToStringUtil).ObjectToString(..Actual)
        Set msg = "Expected "_actualAsString_" to be undefined"
        Do ..TestContext.AssertFailureViaMacro(msg)
    }
    Return $$$OK
}

/// Description
Method IsEqualTo(expected) As %Status
{
    Do ..InitComparator()
    If '(..Comparator.areEqual(..Actual, expected)) {
        Set actualAsString = $$$NL_##class(utility.testing.ToStringUtil).ObjectToString(..Actual)_$$$NL
        Set expectedAsString = $$$NL_##class(utility.testing.ToStringUtil).ObjectToString(expected)_$$$NL
        Set msg = "   Expected:"_actualAsString_"   to be equal to:"_expectedAsString_$$$NL
        Do ..TestContext.AssertFailureViaMacro(msg)
    }
    Return $$$OK
}

/// Checks if the obj is a DynamicObject or a compiled class (%SystemBase)
Method IsDynamicObject(obj) As %Boolean
{
   Set name = obj.%ClassName(1)
   Return name = "%Library.DynamicObject"
}

/// Checks if a property on the given obj exists
/// obj may either by a %SystemBase (a compiled class) or a DynamicObject.
Method IsPropertyDefined(obj, key As %String) As %Status
{
    If (..IsDynamicObject(..Actual)) {
        Return ..Actual.%IsDefined(key)
    } Else {
        // Apparently, it's not quite to simple to check this on non dynamic objects
        // for compiled classes, need to check it this way
        // from https://stackoverflow.com/questions/15389075/test-if-property-exists-on-a-class-at-runtime
        Set className = obj.%ClassName(1)
        return ##class(%Dictionary.CompiledProperty).IDKEYExists(className, key)
    }
}

}
