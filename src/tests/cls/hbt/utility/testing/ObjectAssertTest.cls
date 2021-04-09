Class hbt.utility.testing.DynamicObjectAssertTest Extends %UnitTest.TestCase {
    /// Description
Method Assert() As hbt.utility.testing.ObjectAssertBuilder
{
    return ##class(hbt.utility.testing.AssertBuilder).AssertOnContext($THIS)
}

/// Description
Method TestShouldPassWithUndefinedProperty() As %Status
{
    #; do ..Assert().ThatActualObject()
    #; Return $$$OK
}

}