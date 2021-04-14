/// Description
Class hbt.utility.testing.RecursiveDynamicObjectComparatorTest Extends %UnitTest.TestCase
{

/// Description
Method VerifyEqual(arrayOrObjectA, arrayOrObjectB) As %Status
{
    Set comparator = ##class(hbt.utility.testing.RecursiveDynamicObjectComparator).%New()
    Set areEqual = comparator.areEqual(arrayOrObjectA, arrayOrObjectB)
    Set arrayAString = ##class(hbt.utility.testing.ToStringUtil).ObjectToString(arrayOrObjectA)
    Set arrayBString = ##class(hbt.utility.testing.ToStringUtil).ObjectToString(arrayOrObjectB)
    Do $$$AssertTrue(areEqual, " Expected "_arrayAString_" to equal "_arrayBString)
}

Method VerifyNotEqualWithOrder(arrayOrObjectA, arrayOrObjectB) As %Status
{
    Set comparator = ##class(hbt.utility.testing.RecursiveDynamicObjectComparator).%New()
    Set comparator.IgnoreOrder = 0
    Set areEqual = comparator.areEqual(arrayOrObjectA, arrayOrObjectB)
    Set arrayAString = ##class(hbt.utility.testing.ToStringUtil).ObjectToString(arrayOrObjectA)
    Set arrayBString = ##class(hbt.utility.testing.ToStringUtil).ObjectToString(arrayOrObjectB)
    Do $$$AssertNotTrue(areEqual, " Expected "_arrayAString_" to equal "_arrayBString)
}

Method VerifyNotEqual(arrayOrObjectA, arrayOrObjectB) As %Status
{
    Set comparator = ##class(hbt.utility.testing.RecursiveDynamicObjectComparator).%New()
    Set areEqual = comparator.areEqual(arrayOrObjectA, arrayOrObjectB)
    Set arrayAString = ##class(hbt.utility.testing.ToStringUtil).ObjectToString(arrayOrObjectA)
    Set arrayBString = ##class(hbt.utility.testing.ToStringUtil).ObjectToString(arrayOrObjectB)
    Do $$$AssertNotTrue(areEqual, " Expected "_arrayAString_" not to equal "_arrayBString)
}

Method TestWithBasicArraysShouldBeEqual() As %Status
{
    Set arrayA = ["A", "B"]
    Set arrayB = ["A", "B"]
    Do ..VerifyEqual(arrayA, arrayB)
}

Method TestWithMultipleDataTypesShouldBeEqual() As %Status
{
    Set arrayA = ["A", 1]
    Set arrayB = ["A", 1]
    Do ..VerifyEqual(arrayA, arrayB)
}

Method TestWithDifferentOrderShouldBeEqual() As %Status
{
    Set arrayA = ["A", "C", "B"]
    Set arrayB = ["A", "B", "C"]
    Do ..VerifyEqual(arrayA, arrayB)
}

/// Description
Method TestWithMissingValueShouldNotBeEqual() As %Status
{
    Set arrayA = ["A", "C", "B"]
    Set arrayB = ["A", "C"]
    Do ..VerifyNotEqual(arrayA, arrayB)
}

Method TestWithSuperflousValueShouldNotBeEqual() As %Status
{
    Set arrayA = ["A", "B"]
    Set arrayB = ["A", "B", "C"]
    Do ..VerifyNotEqual(arrayA, arrayB)
}

Method TestWithObjectsShouldBeEqual() As %Status
{
    Set objectA = {"value": "A"}
    Set objectB = {"value": "A"}
    Do ..VerifyEqual(objectA, objectB)
}

Method TestWithObjectInObjectShouldBeEqual() As %Status
{
    Set objectA = {"value": {"value2": "A"}}
    Set objectB = {"value": {"value2": "A"}}
    Do ..VerifyEqual(objectA, objectB)
}

Method TestWithSuperflousKeyShouldNotBeEqual() As %Status
{
    Set objectA = {"valueA": "A"}
    Set objectB = {"valueA": "A", "valueB": "B"}
    Do ..VerifyNotEqual(objectA, objectB)
}

/// Description
Method TestWithRelevantOrderShouldNotBeEqual() As %Status
{
    Set arrayA = ["A", "B"]
    Set arrayB = ["B", "A"]
    Do ..VerifyNotEqualWithOrder(arrayA, arrayB)
}

/// Description
Method TestWithIgnoredFieldsShouldBeEqual() As %Status
{
    Set objectA = {"id": "1", "device": "CRT"}
    Set objectB = {"id": "2", "device": "CRT"}
    // do something
    Set comparator = ##class(hbt.utility.testing.RecursiveDynamicObjectComparator).%New()
    do comparator.AddIgnoredField("id")
    Set areEqual = comparator.areEqual(objectA, objectB)
    Set objectAString = ##class(hbt.utility.testing.ToStringUtil).ObjectToString(objectA)
    Set objectBString = ##class(hbt.utility.testing.ToStringUtil).ObjectToString(objectB)
    Do $$$AssertTrue(areEqual, " Expected "_objectAString_" to equal "_objectBString)
}

/// T
Method TestWithNormalSimpleObjectShouldBeEqual() As %Status
{
    set inner = ##class(hbt.utility.testing.data.DummyTestClass).%New()
    set inner.TestProperty = "Value"
    set objectA = ##class(hbt.utility.testing.data.NestedDummyTestClass).%New()
    set objectA.NestedObj = inner
    set objectB = ##class(hbt.utility.testing.data.NestedDummyTestClass).%New()
    set objectB.NestedObj = inner
    Set comparator = ##class(hbt.utility.testing.RecursiveDynamicObjectComparator).%New()
    Set areEqual = comparator.areEqual(objectA, objectB)
    Set objectAString = ##class(hbt.utility.testing.ToStringUtil).ObjectToString(objectA)
    Set objectBString = ##class(hbt.utility.testing.ToStringUtil).ObjectToString(objectB)
    Do $$$AssertTrue(areEqual, " Expected "_objectAString_" to equal "_objectBString)
    return $$$OK
}

}
