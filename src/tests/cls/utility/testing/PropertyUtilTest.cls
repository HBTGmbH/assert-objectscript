Class utility.testing.DynamicObjectAssertTest Extends %UnitTest.TestCase
{

Method Assert() As utility.testing.ObjectAssertBuilder
{
    Return ##class(utility.testing.AssertBuilder).AssertOnContext($THIS)
}

/// Description
Method TestShouldReadSinglePropertyFromTestClass() As %Status
{
    set obj = ##class(utility.testing.data.DummyTestClass).%New()
    set obj.TestProperty = "TestValue"
    set properties = ##class(utility.testing.PropertyUtil).GetProperties(obj)
    set expected = {
        "key": "TestProperty",
        "value": "TestValue"
    }
    do ..Assert().ThatActualArray(properties).UsingFieldByFieldComparison().ToContain(expected)
}

}
