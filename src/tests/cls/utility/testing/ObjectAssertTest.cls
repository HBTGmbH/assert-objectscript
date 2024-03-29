Class utility.testing.DynamicObjectAssertTest Extends %UnitTest.TestCase
{

/// Description
Method Assert() As utility.testing.ObjectAssertBuilder
{
    Return ##class(utility.testing.AssertBuilder).AssertOnContext($THIS)
}

/// Description
Method TestShouldPassWithUndefinedProperty() As %Status
{
    
    Set obj = ##class(utility.testing.data.DummyTestClass).%New()
    Do ..Assert().ThatActualObject(obj).NotToHaveProperty("DoesNotExistProperty")
    return $$$OK
}

/// Description
Method TestShouldPassWithDefinedProperty() As %Status
{
    Set obj = ##class(utility.testing.data.DummyTestClass).%New()
    Do ..Assert().ThatActualObject(obj).ToHaveProperty("TestProperty")
    return $$$OK
}

/// Two objects that are equal by their object reference
Method TestShouldPassWithObjectEquality() As %Status
{
    Set obj = ##class(utility.testing.data.DummyTestClass).%New()
    set obj.TestProperty = "ABCDEFGH"
    Do ..Assert().ThatActualObject(obj).IsEqualTo(obj)
}

// Two objects that are a different instance but have the same property values

Method TestShouldPassWithObjectEqualityUsingFieldByFieldComparison() As %Status
{
    Set dummyObj = ##class(utility.testing.data.DummyTestClass).%New()
    set dummyObj.TestProperty = "ABCDEFGH"

    Set objA = ##class(utility.testing.data.NestedDummyTestClass).%New()
    Set objB = ##class(utility.testing.data.NestedDummyTestClass).%New()
    set objA.NestedObj = dummyObj
    set objB.NestedObj = dummyObj
    Do ..Assert().ThatActualObject(objB).UsingFieldByFieldComparison().IsEqualTo(objA)
}

}
