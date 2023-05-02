Class utility.testing.DynamicObjectAssertTest Extends %UnitTest.TestCase
{

/// Description
Method Assert() As utility.testing.ObjectAssertBuilder
{
    return ##class(utility.testing.AssertBuilder).AssertOnContext($THIS)
}

Method TestShouldPassWithDefinedObjectForDefinedCheck() As %Status
{
    set object = {"value": "ABC"}
    do ..Assert().ThatActualObject(object).IsDefined()
    return $$$OK
}

Method TestSHouldPassWithUndefinedObjectForUndefinedCheck() As %Status
{
    do ..Assert().ThatActualObject($$$NULLOREF).IsNotDefined()
    return $$$OK
}

/// Description
Method TestShouldPassWithEqualObjects() As %Status
{
     set object = {"value": "ABC"}
     do ..Assert().ThatActualObject(object).IsEqualTo(object)
}

Method TestShouldPassWithEqualObjectsUsingFieldByFieldComparison() As %Status
{
     set objectA = {"value": "ABC"}
     set objectB = {"value": "ABC"}
     do ..Assert().ThatActualObject(objectA).UsingFieldByFieldComparison().IsEqualTo(objectB)
}

Method TestShouldPassWithEqualObjectsIgnoringId() As %Status
{
     set objectA = {"id": "1", "value": "ABC"}
     set objectB = {"id": "1", "value": "ABC"}
     do ..Assert().ThatActualObject(objectA).UsingFieldByFieldComparison().IgnoringFields(["id"]).IsEqualTo(objectB)
}

}
