Class hbt.utility.testing.DynamicObjectAssertTest Extends %UnitTest.TestCase
{

Method Assert() As hbt.utility.testing.ObjectAssertBuilder
{
    Return ##class(hbt.utility.testing.AssertBuilder).AssertOnContext($THIS)
}

/// Description
Method TestShouldReadSinglePropertyFromTestClass() As %Status
{
    set obj = ##class(hbt.utility.testing.data.DummyTestClass).%New()
    set obj.TestProperty = "TestValue"
    set properties = ##class(hbt.utility.testing.PropertyUtil).GetProperties(obj)
    set expected = {
        "key": "TestProperty",
        "value": "TestValue"
    }
    do ..Assert().ThatActualArray(properties).UsingFieldByFieldComparison().ToContain(expected)
}

}
